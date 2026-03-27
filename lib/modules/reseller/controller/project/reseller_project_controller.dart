// import 'dart:developer';
// import 'package:get/get.dart';
//
// import '../../../../data/network/builder/service/builder_service.dart';
//
// // Import your models and services
// // import 'package:your_app/models/project_model.dart';
// // import 'package:your_app/services/project_service.dart';
//
// class ResellerProjectController extends GetxController {
//   final String? resellerId;
//
//   ResellerProjectController({this.resellerId});
//
//   // Observable state
//   final RxBool isLoading = false.obs;
//   final RxList<dynamic> items = <dynamic>[].obs; // Replace with ProjectModel
//   final RxMap<String, String> appliedFilters = <String, String>{}.obs;
//
//   // Pagination
//   int currentPage = 1;
//   int itemsPerPage = 20;
//   bool hasMoreData = true;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadInitialProjects();
//   }
//
//   /// Load initial projects with reseller filter
//   Future<void> _loadInitialProjects() async {
//     try {
//       isLoading.value = true;
//
//       final Map<String, String> initialFilter = {};
//       if (resellerId != null && resellerId!.isNotEmpty) {
//         initialFilter['assignedTo'] = resellerId!;
//       }
//
//       await applyFilters(initialFilter);
//     } catch (e) {
//       log('❌ Error loading initial projects: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Apply filters to project list
//   Future<void> applyFilters(Map<String, String> filters) async {
//     try {
//       isLoading.value = true;
//       currentPage = 1;
//       hasMoreData = true;
//
//       appliedFilters.value = Map<String, String>.from(filters);
//
//       // Add reseller ID to filters if not present
//       if (resellerId != null && resellerId!.isNotEmpty) {
//         appliedFilters['assignedTo'] = resellerId!;
//       }
//
//       log('📊 Applying filters: ${appliedFilters.toString()}');
//
//       // Call your API service here
//       final response = await BuilderService.fe(
//         filters: appliedFilters,
//         page: currentPage,
//         limit: itemsPerPage,
//       );
//
//       // items.value = response.data ?? [];
//       // hasMoreData = response.hasMore ?? false;
//
//       // Temporary mock data
//       items.clear();
//       // items.addAll(mockProjects);
//     } catch (e) {
//       log('❌ Error applying filters: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to load projects',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Load more projects (pagination)
//   Future<void> loadMore() async {
//     if (isLoading.value || !hasMoreData) return;
//
//     try {
//       isLoading.value = true;
//       currentPage++;
//
//       log('📄 Loading page $currentPage');
//
//       // Call your API service here
//       // final response = await ProjectService.getProjects(
//       //   filters: appliedFilters,
//       //   page: currentPage,
//       //   limit: itemsPerPage,
//       // );
//
//       // if (response.data != null && response.data!.isNotEmpty) {
//       //   items.addAll(response.data!);
//       //   hasMoreData = response.hasMore ?? false;
//       // } else {
//       //   hasMoreData = false;
//       // }
//     } catch (e) {
//       log('❌ Error loading more projects: $e');
//       currentPage--; // Revert page increment on error
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Refresh reseller projects
//   Future<void> refreshResellerProjects() async {
//     currentPage = 1;
//     hasMoreData = true;
//     await applyFilters(Map<String, String>.from(appliedFilters));
//   }
//
//   /// Clear all filters
//   Future<void> clearAllFilters() async {
//     final Map<String, String> baseFilter = {};
//
//     // Keep reseller ID filter
//     if (resellerId != null && resellerId!.isNotEmpty) {
//       baseFilter['assignedTo'] = resellerId!;
//     }
//
//     await applyFilters(baseFilter);
//   }
//
//   /// Remove specific filter
//   Future<void> removeFilter(String key) async {
//     appliedFilters.remove(key);
//     await applyFilters(Map<String, String>.from(appliedFilters));
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import 'package:nesticope_app/data/network/builder/service/builder_service.dart';

import '../../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../data/network/builder/model/builder_model.dart';

class ResellerProjectController extends PaginatedController<ProjectItem> {
  final BuilderService _service = BuilderService();

  /// Filters
  Map<String, String>? filters = {};
  final String resellerId;

  ResellerProjectController({required this.resellerId}) {
    filters = {'assignedTo': resellerId};
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
  Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProjects(
        page: page,
        filters: filters,
      );

      print("Reseller Projects → Page $page | Items: ${response.items.length}");

      return response;
    } catch (e) {
      print("❌ Error fetching reseller projects: $e");
      rethrow;
    }
  }

  /// Apply single filter (city, status, type, etc.)
  void applyFilter(String key, String value) {
    filters ??= {};
    filters![key] = value;
    filters!['assignedTo'] = resellerId;

    _resetPagination();
    refreshList();
  }

  /// Apply bulk filters (search / bottom sheet)
  Future<void> applyFilters(Map<String, String> newFilters) async {
    isApplyingFilter.value = true;

    filters = Map<String, String>.from(newFilters);
    filters!['assignedTo'] = resellerId;

    _resetPagination();
    await refreshList();

    isApplyingFilter.value = false;
  }

  /// Clear single filter
  void clearFilter(String key) {
    filters ??= {};
    filters!.remove(key);
    filters!['assignedTo'] = resellerId;

    _resetPagination();
    refreshList();
  }

  /// Clear all filters except reseller
  void clearAllFilters() {
    filters?.clear();
    filters!['assignedTo'] = resellerId;

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
  Future<void> refreshResellerProjects() async {
    _resetPagination();
    await refreshList();
  }
}
