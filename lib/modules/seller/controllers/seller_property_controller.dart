import 'package:get/get.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../../data/network/property/services/property_service.dart';

class SellerListedPropertyController extends PaginatedController<Items> {
  final PropertyService _service = PropertyService();

  /// Seller-specific filters
  Map<String, String> filters = {};

  final RxBool apiLoading = false.obs;
  final RxString sellerId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initSeller();
  }

  /// Load seller ID and initial data
  Future<void> _initSeller() async {
    final user = await SecureStorage.getUserData();
    final id = user?.user?.id;

    if (id == null) return;

    sellerId.value = id.toString();
    // Default filter → seller properties only
    filters = {'created_by': sellerId.value};
    print("Seller seller listed controller ID: $sellerId");
    await loadInitial();
  }

  /// Apply filters (keeps seller constraint)
  Future<void> applyFilters(Map<String, String> newFilters) async {
    try {
      apiLoading.value = true;

      // Merge new filters with the mandatory seller ID
      filters = {...newFilters, 'created_by': sellerId.value};

      currentPage.value = 1;
      hasMore.value = true;
      items.clear();
      await refreshList();
    } finally {
      apiLoading.value = false;
    }
  }

  /// Apply single filter
  void applyFilter(String key, String value) {
    filters[key] = value;
    filters['created_by'] = sellerId.value;

    currentPage.value = 1;
    hasMore.value = true;
    items.clear();
    refreshList();
  }

  /// Clear all filters except seller
  void clearAllFilters() {
    filters = {'created_by': sellerId.value};
    currentPage.value = 1;
    hasMore.value = true;
    items.clear();
    refreshList();
  }

  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      // Ensure the seller constraint is ALWAYS there before
      print('Seller fetch property called: 1');

      filters['created_by'] = sellerId.value;
      print('Seller fetch property called:');
      final response = await _service.fetchProperties(
        page: page,
        filters: filters,
      );
      print("Fetched Seller Listed items: ${response.items.length}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteProperty(String propertyId) async {
    try {
      isLoading.value = true;
      final success = await _service.deleteProperty(propertyId);
      if (success) {
        items.removeWhere(
          (e) => (e.id == propertyId || e.propertyId == propertyId),
        );
        items.refresh();
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
