import 'package:get/get.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../../data/network/property/services/property_service.dart';

class SellerListedPropertyController extends PaginatedController<Items> {
  final PropertyService _service = PropertyService();

  final Rx<PropertyListState> state = PropertyListState.initialLoading.obs;

  final RxString sellerId = ''.obs;

  /// Always-active filters (seller + user filters)
  Map<String, String> filters = {};

  @override
  void onInit() {
    super.onInit();
    _initSeller();
  }

  Future<void> _initSeller() async {
    final user = await SecureStorage.getUserData();
    final id = user?.user?.id;

    if (id == null) {
      state.value = PropertyListState.error;
      return;
    }

    sellerId.value = id.toString();
    filters = {'created_by': sellerId.value};

    await loadInitial();
  }

  /// FIRST LOAD / REFRESH
  @override
  Future<void> loadInitial() async {
    state.value = PropertyListState.initialLoading;
    items.clear();
    currentPage.value = 1;
    hasMore.value = true;

    try {
      await super.loadInitial();

      state.value =
          items.isEmpty ? PropertyListState.empty : PropertyListState.loaded;
    } catch (_) {
      state.value = PropertyListState.error;
    }
  }

  /// APPLY FILTERS
  Future<void> applyFilters(Map<String, String> newFilters) async {
    state.value = PropertyListState.filtering;

    filters = {...newFilters, 'created_by': sellerId.value};

    items.clear();
    currentPage.value = 1;
    hasMore.value = true;

    try {
      await super.loadInitial();

      state.value =
          items.isEmpty ? PropertyListState.empty : PropertyListState.loaded;
    } catch (_) {
      state.value = PropertyListState.error;
    }
  }

  /// CLEAR FILTERS
  Future<void> clearAllFilters() async {
    await applyFilters({});
  }

  /// PAGINATION
  @override
  Future<void> loadMore() async {
    if (state.value == PropertyListState.loadingMore || !hasMore.value) return;

    state.value = PropertyListState.loadingMore;
    await super.loadMore();
    state.value = PropertyListState.loaded;
  }

  /// API
  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    filters['created_by'] = sellerId.value;

    final response = await _service.fetchProperties(
      page: page,
      filters: filters,
    );
    print("response of seller property: ${response.meta.toJson()}");
    return response;
  }

  /// DELETE
  Future<void> deleteProperty(String propertyId) async {
    final success = await _service.deleteProperty(propertyId);
    if (success) {
      items.removeWhere(
        (e) => e.id == propertyId || e.propertyId == propertyId,
      );

      if (items.isEmpty) {
        state.value = PropertyListState.empty;
      }
    }
  }
}

enum PropertyListState {
  initialLoading, // first time open
  loadingMore, // pagination
  filtering, // applying filters
  loaded, // data available
  empty, // no data (after filter or fresh)
  error,
}
