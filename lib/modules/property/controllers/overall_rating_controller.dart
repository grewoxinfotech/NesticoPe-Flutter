import 'package:get/get.dart';

import '../../../data/network/overall_rating/model/overall_rating_model.dart';
import '../../../data/network/overall_rating/service/overall_rating_service.dart';

class OverallRatingController extends GetxController {
  final _service = OverallRatingService();

  /// Reactive states
  var isLoading = false.obs;
  var ratingData = Rxn<PropertyReviewResponse>(); // Holds full response model
  var errorMessage = ''.obs;

  /// Fetch overall rating for a specific property
  Future<void> fetchOverallRating(String propertyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.fetchOverallRating(propertyId);

      if (response != null && response.success) {
        ratingData.value = response;
      } else {
        errorMessage.value =
            response?.message ?? "Failed to load overall rating.";
        ratingData.value = null;
      }
    } catch (e) {
      print("❌ Error fetching overall rating: $e");
      errorMessage.value = "Something went wrong while loading ratings.";
      ratingData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🧮 Getters for easier UI access
  double get overallRating => ratingData.value?.data?.overallRating ?? 0.0;

  int get totalReviews => ratingData.value?.data?.totalReviews ?? 0;

  DetailedRatings get detailedRatings =>
      ratingData.value?.data?.detailedRatings ??
      DetailedRatings(
        location: 0,
        cleanliness: 0,
        accuracy: 0,
        value: 0,
        amenities: 0,
      );
}
