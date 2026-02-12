import 'package:get/get.dart';

import '../../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../data/network/property/services/property_service.dart';

class ResellerPropertyController extends PaginatedController<Items> {
  final PropertyService _service = PropertyService();

  /// Filters
  Map<String, String>? filters = {};
  final String resellerId;
  ResellerPropertyController({required this.resellerId}) {
    filters = {'assignedTo': resellerId,'isExpired':false.toString()};
  }

  /// State
  RxString selectedCity = ''.obs;
  RxBool isApplyingFilter = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  /// Core pagination fetch
  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProperties(
        page: page,
        filters: filters,
      );

      print(
        "Reseller Properties → Page $page | Items: ${response.items.length}",
      );

      return response;
    } catch (e) {
      print("❌ Error fetching reseller properties: $e");
      rethrow;
    }
  }

  /// Apply any filter (city, listingType, bhk, etc.)
  void applyFilter(String key, String value) {
    filters ??= {};
    filters![key] = value;
    filters!['assignedTo'] = resellerId;
    filters!['isExpired'] = false.toString();

    _resetPagination();
    refreshList();
  }

  /// Apply bulk filters (from search / bottom sheet)
  Future<void> applyFilters(Map<String, String> newFilters) async {
    isApplyingFilter.value = true;
    filters = Map<String, String>.from(newFilters);
    filters!['assignedTo'] = resellerId;
    filters!['isExpired'] = false.toString();

    _resetPagination();
    await refreshList();

    isApplyingFilter.value = false;
  }

  /// Clear one filter
  void clearFilter(String key) {
    filters ??= {};
    filters!.remove(key);
    filters!['assignedTo'] = resellerId;
    filters!['isExpired'] = false.toString();

    _resetPagination();
    refreshList();
  }

  /// Clear everything except city + reseller
  void clearAllFilters() {
    filters?.clear();
    filters!['assignedTo'] = resellerId;
    filters!['isExpired'] = false.toString();

    _resetPagination();
    refreshList();
  }

  /// Pagination reset helper
  void _resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();
    update();
  }

  /// Manual refresh (pull-to-refresh)
  Future<void> refreshResellerProperties() async {
    _resetPagination();
    await refreshList();
  }
}
