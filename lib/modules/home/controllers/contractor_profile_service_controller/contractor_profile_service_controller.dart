import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../data/network/contractor/service/contractor_my_service.dart';

class ContractorServiceController
    extends PaginatedController<ContractorServiceItem> {
  final ContractorMyService _service = ContractorMyService.contractorMyService;

  RxList<ContractorServiceItem> selectedItems = <ContractorServiceItem>[].obs;

  /// Contractor ID is required to fetch services
  final String contractorId;

  ContractorServiceController({required this.contractorId});

  /// --- Reactive UI states ---
  RxBool isExpanded = false.obs;
  RxString selectedPriceModel = ''.obs;
  RxString selectedAvailability = ''.obs;

  /// --- Optional filters ---
  Map<String, String> filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  /// --------------------------------------------------------------------------
  /// FETCH PAGINATED SERVICES
  /// --------------------------------------------------------------------------
  @override
  Future<PaginationResponse<ContractorServiceItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchContractorService(
        page: page,
        filters: filters,
        id: contractorId,
      );

      print("Fetched Contractor Services: ${response.items.length}");
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// --------------------------------------------------------------------------
  /// APPLY SINGLE FILTER
  /// --------------------------------------------------------------------------
  void applyFilter(String key, String value) {
    filters.clear();
    filters[key] = value;

    resetPagination();
    refreshList();
  }

  /// --------------------------------------------------------------------------
  /// APPLY MULTIPLE FILTERS
  /// --------------------------------------------------------------------------
  Future<void> applyFilters(Map<String, String> newFilters) async {
    isLoading.value = true;

    filters = newFilters;

    resetPagination();
    await refreshList();

    isLoading.value = false;
  }

  /// Reset pagination states
  void resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();
  }

  /// --------------------------------------------------------------------------
  /// GET SINGLE SERVICE BY ID
  /// --------------------------------------------------------------------------
  Future<ContractorServiceItem?> getServiceById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      // If needed, create a getById endpoint later
      print("Service not found in list. You may add getById API support.");
    } catch (e) {
      print("Error getServiceById: $e");
    }
    return null;
  }

  /// --------------------------------------------------------------------------
  /// TOGGLE ACTIVE/INACTIVE
  /// --------------------------------------------------------------------------
  Future<void> toggleActiveStatus(String id, bool current) async {
    try {
      await _service.changeActiveToInActive(id, !current);

      final index = items.indexWhere((e) => e.id == id);
      if (index != -1) {
        items[index].isActive = !current;
        items.refresh();
      }
    } catch (e) {
      print("Error toggling active status: $e");
    }
  }

  /// --------------------------------------------------------------------------
  /// DELETE SERVICE
  /// --------------------------------------------------------------------------
  Future<bool> deleteService(String id) async {
    try {
      final success = await _service.deletedService(id);
      if (success) {
        items.removeWhere((element) => element.id == id);
        items.refresh();
      }
      return success;
    } catch (e) {
      print("Error deleting service: $e");
      return false;
    }
  }

  void addSelectedService(ContractorServiceItem service) {
    selectedItems.add(service);
  }

  void removeSelectedService(ContractorServiceItem service) {
    selectedItems.remove(service);
  }

  void toggleSelectedService(ContractorServiceItem service) {
    if (selectedItems.contains(service)) {
      removeSelectedService(service);
    } else {
      addSelectedService(service);
    }
  }

  void clearSelection() {
    selectedItems.clear();
  }
}
