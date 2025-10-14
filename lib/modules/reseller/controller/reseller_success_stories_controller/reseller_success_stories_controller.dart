import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/network/reseller_success_stories/reseller_success_stories_model.dart';
import '../../../../data/network/reseller_success_stories/reseller_success_stories_service.dart';


class ResellerSuccessStoryController extends PaginatedController<ResellerSuccessItem> {
  final ResellerSuccessStoryService _service = ResellerSuccessStoryService();

  // ---------------- Form Controllers ----------------
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController achievementController = TextEditingController();
  final TextEditingController monthYearController = TextEditingController();
  final TextEditingController totalDealsController = TextEditingController();
  final TextEditingController totalValueController = TextEditingController();

  // --- Dropdown & Slider ---
  final List<String> statusOptions = ['published', 'draft'];
  RxString selectedStatus = 'draft'.obs;


  // ---------------- Reactive Variables ----------------
  RxInt rating = 0.obs;
  Rxn<DateTime> selectedMonthYear = Rxn<DateTime>();
  RxMap<String, String> filters = <String, String>{}.obs;


  // ---------------- Image ----------------
  Rxn<File> imagePath = Rxn<File>(); // local path or network URL

  @override
  void onInit() {
    super.onInit();
    resetForm();
    loadInitial();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    achievementController.dispose();
    totalDealsController.dispose();
    totalValueController.dispose();
    monthYearController.dispose();
    super.onClose();
  }

  // ====================================================
  // ================ Pagination Fetch ==================
  // ====================================================
  @override
  Future<PaginationResponse<ResellerSuccessItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchSuccessStories(
        page: page,
        filters: filters,
      );
      debugPrint("📥 Fetched Success Stories: ${response.items.length}");
      return response;
    } catch (e) {
      debugPrint("⚠️ Exception in fetchItems: $e");
      rethrow;
    }
  }

  // ====================================================
  // =================== CRUD Methods ===================
  // ====================================================

  Future<bool> createStory(ResellerSuccessItem story, {String? imageFilePath}) async {
    try {
      isLoading.value = true;
      final imageFile = imageFilePath != null ? File(imageFilePath) : null;
      final success = await _service.createSuccessStory(
        storyData: story,
        image: imageFile,
      );
      if (success) await loadInitial();
      return success;
    } catch (e) {
      debugPrint("❌ Create story error: $e");
      return false;
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateStory(String id, ResellerSuccessItem updatedStory, {String? imageFilePath}) async {
    try {
      isLoading.value = true;
      final imageFile = imageFilePath != null ? File(imageFilePath) : null;
      final success = await _service.updateSuccessStory(
        storyId: id,
        storyData: updatedStory,
        image: imageFile,
      );

      if (success) {
        int index = items.indexWhere((item) => item.id == id);
        if (index != -1) {
          items[index] = updatedStory;
          items.refresh();
        }
      }
      return success;
    } catch (e) {
      debugPrint("❌ Update story error: $e");
      return false;
    }finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteStory(String id) async {
    try {
      // If you have delete API, you can use it here.
      // For now, remove locally for demo.
      items.removeWhere((item) => item.id == id);
      items.refresh();
      return true;
    } catch (e) {
      debugPrint("❌ Delete story error: $e");
      return false;
    }
  }

  // ====================================================
  // ==================== Filters =======================
  // ====================================================
  Future<void> applyFilters(Map<String, String> newFilters) async {
    filters.value = newFilters;
    await refreshList();
  }

  void resetFilters() {
    filters.clear();
    refreshList();
  }

  // ====================================================
  // ================= Form Helpers =====================
  // ====================================================

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    achievementController.clear();
    totalDealsController.clear();
    totalValueController.clear();
    monthYearController.clear();
    selectedMonthYear.value = null;
    rating.value = 0;
    selectedStatus.value = statusOptions.first;
    imagePath.value = null;
  }

  // void populateForm(ResellerSuccessItem story) {
  //   print("Populating form with story: ${story.toJson()}");
  //   titleController.text = story.title;
  //   descriptionController.text = story.description;
  //   achievementController.text = story.achievement;
  //   totalDealsController.text = story.totalDeals.toString();
  //   totalValueController.text = story.totalValue;
  //   monthYearController.text = "${story.monthYear.year}-${story.monthYear.month.toString().padLeft(2, '0')}";
  //   selectedMonthYear.value = story.monthYear;
  //   rating.value = story.rating;
  //   selectedStatus.value = story.status;
  //   if (story.image != null) {
  //     imagePath.value = File(story.image!);
  //   } else {
  //     imagePath.value = null;
  //   }
  // }

  void populateForm(ResellerSuccessItem story) {
    print("Populating form with story: ${story.toJson()}");

    titleController.text = story.title;
    descriptionController.text = story.description;
    achievementController.text = story.achievement;
    totalDealsController.text = story.totalDeals.toString();
    totalValueController.text = story.totalValue;
    monthYearController.text =
    "${story.monthYear.year}-${story.monthYear.month.toString().padLeft(2, '0')}";
    selectedMonthYear.value = story.monthYear;
    rating.value = story.rating;
    selectedStatus.value = story.status;

    if (story.image != null && story.image!.isNotEmpty) {
      // ✅ Check if the image path exists locally
      final file = File(story.image!);
      if (file.existsSync()) {
        // Local file exists
        imagePath.value = file;
      } else {
        // Treat as network URL
        imagePath.value =  File(story.image!); // create a separate RxString for network image
      }
    }
  }


  bool isValidForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        achievementController.text.isNotEmpty &&
        totalDealsController.text.isNotEmpty &&
        totalValueController.text.isNotEmpty &&
        selectedMonthYear.value != null;
  }

  void setMonthYear(DateTime date) {
    selectedMonthYear.value = date;
    monthYearController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  void clearMonthYear() {
    selectedMonthYear.value = null;
    monthYearController.clear();
  }

  void setRating(int value) {
    rating.value = value;
  }

  void setStatus(String value) {
    if (statusOptions.contains(value)) {
      selectedStatus.value = value;
    }
  }

  ResellerSuccessItem buildStoryModel() {
    return ResellerSuccessItem(
      id: "",
      resellerId: "tzX2qZP1qmVBS2K8uYt22XO", // You can dynamically assign current user ID here
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      achievement: achievementController.text.trim(),
      totalDeals: int.tryParse(totalDealsController.text) ?? 0,
      totalValue: totalValueController.text.trim(),
      monthYear: selectedMonthYear.value ?? DateTime.now(),
      rating: rating.value,
      status: selectedStatus.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: null,
      updatedBy: null,
      image: imagePath.value?.path,
    );
  }

  Future<void> builderImagePicker() async {
    try {
      XFile? files = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (files != null) {
        imagePath.value = File(files.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
