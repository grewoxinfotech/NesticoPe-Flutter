import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
import '../../../data/network/contractor/service/contactor_service_category_service.dart';


class TopCategoryController extends GetxController {
  final TopCategoryService _service = TopCategoryService();

  ///==================== Observable States ====================
  final RxBool isLoading = false.obs;
  final RxList<TopCategoryItem> categories = <TopCategoryItem>[].obs;
  final RxString errorMessage = ''.obs;

  ///==================== Lifecycle ====================
  @override
  void onInit() {
    super.onInit();
    fetchTopCategories();
  }

  ///==================== Fetch Top Categories ====================
  Future<void> fetchTopCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.fetchTopCategories(limit: 12);
      categories.assignAll(result);
    } catch (e) {
      debugPrint("TopCategoryController error: $e");
      errorMessage.value = 'Failed to load categories';
    } finally {
      isLoading.value = false;
    }
  }

  ///==================== Refresh Categories ====================
  Future<void> refreshCategories() async {
    await fetchTopCategories();
  }

  ///==================== Get Category by ID ====================
  TopCategoryItem? getCategoryById(String id) {
    try {
      return categories.firstWhereOrNull((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
