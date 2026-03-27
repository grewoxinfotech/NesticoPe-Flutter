import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

import '../../../../data/database/secure_storage_service.dart';
import '../../../data/network/visit/model/visit_model.dart';
import '../../../data/network/visit/service/visit_service.dart';

class VisitController extends PaginatedController<VisitItem> {
  final VisitService _visitService = VisitService();

  /// ================== State ==================
  final isSubmitting = false.obs;

  /// Filters
  final RxString propertyId = ''.obs;
  final RxString buyerId = ''.obs;
  final RxString sellerId = ''.obs;
  final RxString status = ''.obs;

  /// ================== Lifecycle ==================
  @override
  void onInit() {
    super.onInit();
    getVisitsForCurrentUser();
  }

  /// ================== Filters ==================
  Future<void> getVisitsByPropertyId(String propertyId) async {
    this.propertyId.value = propertyId;
    await refreshList();
  }

  Future<void> getVisitsForCurrentUser() async {
    isLoading.value = true;

    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';

    buyerId.value = userId;
    await refreshList();
    isLoading.value = false;
  }

  void setStatus(String value) {
    status.value = value;
    refreshList();
  }

  void clearFilters() {
    propertyId.value = '';
    buyerId.value = '';
    sellerId.value = '';
    status.value = '';
    refreshList();
  }

  /// ================== Filters Map ==================
  Map<String, String> get filters {
    final Map<String, String> filterMap = {};

    if (propertyId.isNotEmpty) {
      filterMap['property_id'] = propertyId.value;
    }
    if (buyerId.isNotEmpty) {
      filterMap['buyer_id'] = buyerId.value;
    }
    if (sellerId.isNotEmpty) {
      filterMap['seller_id'] = sellerId.value;
    }
    if (status.isNotEmpty) {
      filterMap['status'] = status.value;
    }

    return filterMap;
  }

  /// ================== Pagination Fetch ==================
  @override
  Future<PaginationResponse<VisitItem>> fetchItems(int page) async {
    try {
      final response = await _visitService.fetchVisits(
        page: page,
        filters: filters,
      );

      debugPrint("Fetched visits: ${response.items.length}");
      return response;
    } catch (e) {
      debugPrint("Exception in fetchItems: $e");
      rethrow;
    }
  }
}
