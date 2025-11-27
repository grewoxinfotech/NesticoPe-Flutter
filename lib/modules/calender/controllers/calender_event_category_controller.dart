import 'package:get/get.dart';
import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../data/network/calender/model/calender_category_model.dart';
import '../../../data/network/calender/service/calender_category_service.dart';

class CalenderCategoryController
    extends PaginatedController<CalenderCategoryModel> {
  /// Service instance
  final CalenderCategoryService _service = CalenderCategoryService();

  /// Active filters (if any)
  final RxMap<String, String> filters = <String, String>{}.obs;

  /// Apply filters and reload first page
  void applyFilters(Map<String, String> newFilters) {
    filters.assignAll(newFilters);
    loadInitial();
  }

  /// Fetch page from API → required by PaginatedController
  @override
  Future<PaginationResponse<CalenderCategoryModel>> fetchItems(int page) async {
    try {
      isLoading.value = true;
      final response = await _service.fetchEventsCategory(
        page: page,
        filters: filters,
      );
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new category
  Future<void> addCategory(String name) async {
    final created = await _service.addEventCategory(name);
    if (created != null) {
      loadInitial();
    }
  }

  /// Update existing category
  Future<void> updateCategory(CalenderCategoryModel category) async {
    final updated = await _service.updateEvent(category);
    if (updated != null) {
      loadInitial();
    }
  }

  /// Delete category
  Future<void> deleteCategory(String id) async {
    final deleted = await _service.deleteEventCategory(id);
    if (deleted) {
      loadInitial();
    }
  }

  Future<CalenderCategoryModel?> getCategoryById(String id) async {
    // First check local cache
    final existingCategory = items.firstWhereOrNull(
      (element) => element.id == id,
    );

    if (existingCategory != null) return existingCategory;

    // Fetch from API (only if not found)
    final category = await _service.getCategoryById(id);

    if (category != null) {
      items.add(category);
    }

    return category;
  }

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Auto load first time
  }
}
