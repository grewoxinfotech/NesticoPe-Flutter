import 'package:get/get.dart';

class FilterController extends GetxController {
  /// Filters
  RxInt selectedPropertyTypeIndex = 0.obs;
  // Holds all current filters
  RxMap<String, dynamic> filters = <String, dynamic>{}.obs;

  // Pagination support
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMore = true.obs;

  // --- FILTER METHODS ---

  /// Add or update a single filter
  void setFilter(String key, dynamic value) {
    filters[key] = value;
  }

  /// Remove a filter by key
  void removeFilter(String key) {
    filters.remove(key);
  }

  /// Clear all filters
  void clearFilters() {
    filters.clear();
  }

  /// Apply a batch of filters at once
  void applyFilters(Map<String, dynamic> newFilters) {
    filters.value = newFilters;
    _resetPagination();
    loadInitial(); // Load data with new filters
  }

  /// Check if a filter exists
  bool hasFilter(String key) {
    return filters.containsKey(key);
  }

  /// Get filter value safely
  T? getFilter<T>(String key) {
    return filters[key] as T?;
  }

  /// Toggle a value in a list filter (for multi-select checkboxes)
  void toggleFilterValue(String key, dynamic value) {
    if (!filters.containsKey(key) || filters[key] == null) {
      filters[key] = [value];
    } else {
      final list = List.from(filters[key]);
      if (list.contains(value)) {
        list.remove(value);
      } else {
        list.add(value);
      }
      filters[key] = list;
    }
  }

  // --- PAGINATION HELPERS ---
  void _resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
  }

  // --- DATA LOADING ---
  void loadInitial() {
    // Call your API/service here with current filters
    print("Loading data with filters: $filters");
  }

  void loadMore() {
    if (!hasMore.value) return;
    currentPage.value += 1;
    loadInitial(); // Or call API for next page
  }
}
