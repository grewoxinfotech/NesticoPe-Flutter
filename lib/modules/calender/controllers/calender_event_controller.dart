import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../data/network/calender/model/calender_category_model.dart';
import '../../../data/network/calender/model/calender_model.dart';
import '../../../data/network/calender/service/calender_service.dart';
import 'calender_event_category_controller.dart';

class CalenderEventController extends PaginatedController<CalenderEventModel> {
  /// Service instance
  final CalenderService _service = CalenderService();

  /// Get existing category controller
  final CalenderCategoryController categoryController = Get.put(
    CalenderCategoryController(),
  );

  /// Stores all categories
  RxList<CalenderCategoryModel> categories = <CalenderCategoryModel>[].obs;
  Rx<CalenderCategoryModel?> selectedCategory = Rx<CalenderCategoryModel?>(
    null,
  );

  /// Active filters
  final RxMap<String, String> filters = <String, String>{}.obs;

  /// Apply filters and reload first page
  void applyFilters(Map<String, String> newFilters) {
    filters.assignAll(newFilters);
    loadInitial();
  }

  /// Load all categories on start
  Future<void> loadCategories() async {
    try {
      await categoryController.loadInitial();

      categories.assignAll(categoryController.items);

      if (categories.isNotEmpty && selectedCategory.value == null) {
        selectedCategory.value = categories.first;
      }

      print("Loaded Categories: ${categories.length}");
    } catch (e) {
      print("Error loading categories: $e");
    }
  }

  /// Pagination fetch
  @override
  Future<PaginationResponse<CalenderEventModel>> fetchItems(int page) async {
    try {
      isLoading.value = true;

      final response = await _service.fetchEvents(page: page, filters: filters);

      for (final item in response.items) {
        if (item.categoryId == null) continue;

        // Try find locally
        final localCategory = categoryController.items.firstWhereOrNull(
          (e) => e.id == item.categoryId,
        );

        if (localCategory != null) {
          item.categoryName = localCategory.name;
          continue;
        }

        // Fetch from API
        final fetched = await categoryController.getCategoryById(
          item.categoryId!,
        );

        if (fetched != null) {
          item.categoryName = fetched.name;
        } else {
          item.categoryName = "Unknown";
        }
      }

      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Add Event
  Future<bool> addEvent(CalenderEventModel model) async {
    final created = await _service.addEvent(model);
    if (created != null) {
      loadInitial();
      return true;
    }
    return false;
  }

  /// Update Event
  Future<void> updateEvent(CalenderEventModel model) async {
    final updated = await _service.updateEvent(model);
    if (updated != null) loadInitial();
  }

  /// Delete Event
  Future<void> deleteEvent(String id) async {
    final deleted = await _service.deleteEvent(id);
    if (deleted) loadInitial();
  }

  // ---------------------------------------------------------------------------
  //                          REQUIRED METHODS ADDED 🔥
  // ---------------------------------------------------------------------------

  /// Get events for a specific date
  List<CalenderEventModel> getEventsForDate(DateTime date) {
    final dateStr = DateFormat("yyyy-MM-dd").format(date);

    return items.where((event) {
      final eventDateStr = DateFormat(
        "yyyy-MM-dd",
      ).format(DateTime.tryParse(event.date!)!);
      return eventDateStr == dateStr;
    }).toList();
  }

  /// Check if a date has event(s)
  bool hasEventOnDate(DateTime date) {
    return getEventsForDate(date).isNotEmpty;
  }

  /// Get all upcoming dates that have events (used for month view)
  List<DateTime> getUpcomingEventDates() {
    final Set<DateTime> uniqueDates = {};

    for (final event in items) {
      final raw = event.date;
      if (raw == null || raw.isEmpty) continue;

      final parsed = DateTime.tryParse(raw);
      if (parsed == null) continue;

      // Normalize: keep only Y-M-D, drop HH:mm
      final normalized = DateTime(parsed.year, parsed.month, parsed.day);

      uniqueDates.add(normalized);
    }

    // Return sorted unique list
    final list = uniqueDates.toList()..sort((a, b) => a.compareTo(b));

    return list;
  }

  /// Select category from UI
  void selectCategory(CalenderCategoryModel category) {
    selectedCategory.value = category;
  }

  Map<DateTime, List<CalenderEventModel>> get eventsGroupedByDate {
    final Map<DateTime, List<CalenderEventModel>> grouped = {};

    for (final event in items) {
      if (event.date == null || event.date!.isEmpty) continue;

      final parsed = DateTime.tryParse(event.date!);
      if (parsed == null) continue;

      final normalized = DateTime(parsed.year, parsed.month, parsed.day);

      grouped.putIfAbsent(normalized, () => []);
      grouped[normalized]!.add(event);
    }

    // Sort each list by time (if you want)
    for (final list in grouped.values) {
      list.sort((a, b) => a.date!.compareTo(b.date!));
    }

    return grouped;
  }

  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Load events
    loadCategories(); // Load categories
  }
}
