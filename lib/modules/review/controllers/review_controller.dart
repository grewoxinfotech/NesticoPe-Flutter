import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/review/model/review_model.dart';
import 'package:housing_flutter_app/modules/property/controllers/overall_rating_controller.dart';

import '../../../data/network/review/service/review_service.dart';
import '../../../widgets/messages/snack_bar.dart';

class ReviewController extends PaginatedController<ReviewItem> {
  final ReviewService _service = ReviewService();

  // Reactive variables
  RxString statusFilter = 'all'.obs;
  RxMap<String, String> filters = <String, String>{}.obs;

  Rxn<ReviewItem> appReview = Rxn<ReviewItem>();

  // Form controllers
  // Form
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final prosController = TextEditingController();
  final consController = TextEditingController();

  // Ratings
  var overallRating = 0.0.obs;
  var locationRating = 0.0.obs;
  var cleanlinessRating = 0.0.obs;
  var accuracyRating = 0.0.obs;
  var valueRating = 0.0.obs;
  var amenitiesRating = 0.0.obs;

  RxBool isVerified = false.obs;
  RxBool isExpanded = false.obs;
  Rxn<Map<String, dynamic>> detailedRatings = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    ever(filters, (_) {
      refreshList();
    });
    loadInitial(); // Load first page automatically
    getAppReview();
  }

  /// ✅ Fetch paginated reviews
  @override
  Future<PaginationResponse<ReviewItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchReviews(
        page: page,
        filters: filters,
      );

      print("Fetched items: ${response.items.length}");
      return response; // contains items + meta (page/total)
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// ✏️ Create review
  Future<bool> createReview(ReviewItem data) async {
    try {
      final success = await _service.createReview(data);
      if (success) {
        final _overallRatingController = Get.find<OverallRatingController>();
        _overallRatingController.fetchOverallRating(data.entityId ?? '');
        await refreshList();
      }
      return success;
    } catch (e) {
      print("❌ Error creating review: $e");
      return false;
    }
  }

  /// 🌟 Add app review
  Future<bool> addAppReview({
    required String title,
    required String content,
    double rating = 0.0,
  }) async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;
      // Build review data
      final reviewData = ReviewItem(
        entityType: "seller",
        rating: rating,
        title: title,
        content: content,
        entityId: userId,
        reviewerId: userId,
        status: "published",
        isVerified: user?.user?.isVerified ?? false,
      );

      // Call service to add review
      final success = await _service.createReview(reviewData);

      if (success) {
        // Optionally refresh app review list
        await refreshList();
      }

      return success;
    } catch (e) {
      print("❌ Error adding app review: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: '${e.toString()}',
        contentType: ContentType.failure,
      );
      return false;
    }
  }

  /// 📌 Get all app reviews for the logged-in user
  Future<ReviewItem?> getAppReviews() async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;

      if (userId == null) {
        print("❌ No user ID found in secure storage");
        return null;
      }

      // Call review service with filters (entityType + reviewerId)
      final response = await _service.fetchReviews(
        page: 1,
        filters: {
          'entity_type': 'seller', // App review type
          'reviewer_id': userId, // Fetch only this user’s app reviews
        },
      );

      print("Fetched app reviews: ${response.items.length}");

      return response.items.first;
    } catch (e) {
      print("❌ Error fetching app reviews: $e");
      return null;
    }
  }

  Future<void> getAppReview() async {
    try {
      final reviews = await getAppReviews(); // Your existing fetch method
      if (reviews != null) {
        appReview.value = reviews;
      } else {
        appReview.value = null;
      }
    } catch (e) {
      appReview.value = null;
    }
  }

  /// 🔁 Update review
  Future<bool> updateReview(String id, Map<String, dynamic> updateData) async {
    try {
      final success = await _service.updateReview(id, updateData);
      if (success) {
        int index = items.indexWhere((r) => r.id == id);
        if (index != -1) {
          final updated = ReviewItem.fromJson({
            ...items[index].toJson(),
            ...updateData,
          });
          items[index] = updated;
          items.refresh();
        }
      }
      return success;
    } catch (e) {
      print("❌ Error updating review: $e");
      return false;
    }
  }

  /// 🗑️ Delete review
  Future<bool> deleteReview(String id) async {
    try {
      final success = await _service.deleteReview(id);
      if (success) {
        items.removeWhere((r) => r.id == id);
        items.refresh();
      }
      return success;
    } catch (e) {
      print("❌ Error deleting review: $e");
      return false;
    }
  }

  /// 👍 Mark review as helpful
  Future<bool> markHelpful(String id) async {
    try {
      final success = await _service.markHelpful(id);
      if (success) {
        final review = items.firstWhereOrNull((r) => r.id == id);
        if (review != null) {
          final updated = review.copyWith(
            helpfulCount: review.helpfulCount! + 1,
          );
          final index = items.indexOf(review);
          items[index] = updated;
          items.refresh();
        }
      }
      return success;
    } catch (e) {
      print("❌ Error marking helpful: $e");
      return false;
    }
  }

  /// 🔄 Apply filters and refresh
  Future<void> applyFilters(Map<String, String> newFilters) async {
    try {
      isLoading.value = true;
      filters.value = Map<String, String>.from(newFilters);
      currentPage.value = 1;
      items.clear();
      await refreshList();
    } finally {
      isLoading.value = false;
    }
  }

  /// 🧹 Reset form
  void resetForm() {
    titleController.clear();
    contentController.clear();
    prosController.clear();
    consController.clear();
    overallRating.value = 0.0;
    locationRating.value = 0.0;
    cleanlinessRating.value = 0.0;
    accuracyRating.value = 0.0;
    valueRating.value = 0.0;
    amenitiesRating.value = 0.0;

    isVerified.value = false;
    detailedRatings.value = null;
  }

  /// ✅ Check if a review exists for given entity and reviewer
  Future<bool> isReviewExist({
    required String entityId,
    required String reviewerId,
  }) async {
    try {
      // Call the service with filters
      final response = await _service.fetchReviews(
        page: 1,
        filters: {'entity_id': entityId, 'reviewer_id': reviewerId},
      );

      // Check if total reviews = 1
      final total = response.meta.total;
      return total == 1;
    } catch (e) {
      print("❌ Error checking existing review: $e");
      return false;
    }
  }

  /// UI helpers
  void toggleExpanded() => isExpanded.value = !isExpanded.value;
}
