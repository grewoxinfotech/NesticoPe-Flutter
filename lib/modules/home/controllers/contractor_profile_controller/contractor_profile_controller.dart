import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import '../../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../../data/network/contractor/service/contractor_profile_service.dart';

class TopContractorsController extends PaginatedController<Contractor> {
  final TopContractorsService _service = TopContractorsService();

  /// Reactive UI states
  RxBool isExpanded = false.obs;

  /// Filters (optional)
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // auto-load page 1
  }

  Future<Contractor?> getContractorById(String id)
  async {
    print("Contactor Id : ${id}");
      final data=await _service.fetchContractorById(id);
    print("Contactor Data : ${data?.toJson()}");

      if(data!=null){
        items.removeWhere((element) => element.id == id,);
        items.add(data);
        return data;

    }
    return null;

  }

  /// =====================================================
  /// Pagination Fetch
  /// =====================================================
  @override
  Future<PaginationResponse<Contractor>> fetchItems(int page) async {
    try {
      final response = await _service.fetchTopContractors(
        page: page,
        filters: filters,
      );
      print("Fetched news items: ${response.items.length}");
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// =====================================================
  /// Apply a Single Filter
  /// =====================================================
  void applyFilter(String key, String value) {
    filters ??= {};
    filters!.clear();
    filters![key] = value;

    resetPagination();
    refreshList();
  }

  /// =====================================================
  /// Apply Multiple Filters
  /// =====================================================
  Future<void> applyFilters(Map<String, String> newFilters) async {
    isLoading.value = true;

    filters = newFilters;
    resetPagination();
    await refreshList();

    isLoading.value = false;
  }

  /// Helper to reset pagination state
  void resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();
  }

  /// =====================================================
  /// Get Contractor by ID
  /// =====================================================
  // Future<Contractor?> getContractorById(String id) async {
  //   try {
  //     final existing = items.firstWhereOrNull((c) => c.id == id);
  //     if (existing != null) return existing;
  //
  //     final contractor = await _service.fetchContractorById(id);
  //
  //     if (contractor != null) {
  //       items.add(contractor);
  //       items.refresh();
  //       return contractor;
  //     }
  //   } catch (e) {
  //     debugPrint("Get contractor by ID error: $e");
  //   }
  //   return null;
  // }
}
