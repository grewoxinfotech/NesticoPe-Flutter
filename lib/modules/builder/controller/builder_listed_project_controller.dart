// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
// import 'package:nesticope_app/data/network/builder/service/builder_service.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//
// class BuilderProjectListController extends PaginatedController<ProjectItem> {
//   final BuilderService _builderService = BuilderService();
//
//   /// UI state
//   final RxBool isLoading = false.obs;
//   final RxBool isRefreshing = false.obs;
//
//   /// Filters
//   final RxString selectedCity = ''.obs;
//   final RxString selectedStatus = ''.obs;
//   final RxString selectedPropertyType = ''.obs;
//
//   Map<String, String> filters = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initBuilderProjects();
//   }
//
//   /// Initial load with builder filter
//   Future<void> _initBuilderProjects() async {
//     await _applyBuilderFilter();
//     await loadInitial();
//   }
//
//   /// Builder-only projects
//   Future<void> _applyBuilderFilter() async {
//     final userData = await SecureStorage.getUserData();
//     final userId = userData?.user?.id;
//
//     if (userId == null) return;
//
//     filters['created_by'] = userId;
//   }
//
//   // ==============================
//   // Pagination
//   // ==============================
//
//   @override
//   Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
//     try {
//       log("📦 Fetch Builder Projects | page=$page | filters=$filters");
//       return await _builderService.fetchProjects(page: page, filters: filters);
//     } catch (e) {
//       log("❌ Fetch error: $e");
//       rethrow;
//     }
//   }
//
//   // ==============================
//   // Filters
//   // ==============================
//
//   void applyCity(String city) {
//     selectedCity.value = city;
//     filters['city'] = city;
//     // Don't reload here - let triggerReload handle it
//   }
//
//   void applyStatus(String status) {
//     selectedStatus.value = status;
//     filters['status'] = status;
//     // Don't reload here - let triggerReload handle it
//   }
//
//   void applyPropertyType(String type) {
//     selectedPropertyType.value = type;
//     filters['propertyTypes'] = type;
//     // Don't reload here - let triggerReload handle it
//   }
//
//   void clearFilter(String key) {
//     filters.remove(key);
//
//     // Clear corresponding observable
//     switch (key) {
//       case 'city':
//         selectedCity.value = '';
//         break;
//       case 'status':
//         selectedStatus.value = '';
//         break;
//       case 'propertyTypes':
//         selectedPropertyType.value = '';
//         break;
//     }
//
//     _resetAndReload();
//   }
//
//   void clearAllFilters() {
//     final createdBy = filters['created_by'];
//     filters.clear();
//     if (createdBy != null) {
//       filters['created_by'] = createdBy;
//     }
//
//     // Clear all observable filters
//     selectedCity.value = '';
//     selectedStatus.value = '';
//     selectedPropertyType.value = '';
//
//     _resetAndReload();
//   }
//
//   /// New method to trigger reload after multiple filters are applied
//   void triggerReload() {
//     _resetAndReload();
//   }
//
//   void _resetAndReload() {
//     currentPage.value = 1;
//     totalPages.value = 1;
//     hasMore.value = true;
//     items.clear();
//     refreshList();
//   }
//
//   // ==============================
//   // Refresh
//   // ==============================
//
//   Future<void> refreshProjects() async {
//     try {
//       isRefreshing.value = true;
//       _resetAndReload();
//       await Future.delayed(const Duration(milliseconds: 600));
//     } finally {
//       isRefreshing.value = false;
//     }
//   }
//
//   // ==============================
//   // Actions
//   // ==============================
//
//   Future<ProjectItem?> getProjectById(String id) async {
//     try {
//       final cached = items.firstWhereOrNull((element) => element.id == id);
//       if (cached != null) return cached;
//
//       final project = await _builderService.getProjectById(id);
//       items.add(project);
//       return project;
//     } catch (e) {
//       log("❌ Get project error: $e");
//       return null;
//     }
//   }
//
//   void _deleteError() {
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: "Delete Failed",
//       message: "Unable to delete project",
//       contentType: ContentType.failure,
//     );
//   }
// }

// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
// import 'package:nesticope_app/data/network/builder/service/builder_service.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//
// class BuilderProjectListController extends PaginatedController<ProjectItem> {
//   final BuilderService _builderService = BuilderService();
//
//   /// UI state
//   final RxBool isLoading = false.obs;
//   final RxBool isRefreshing = false.obs;
//
//   Map<String, String> filters = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initBuilderProjects();
//   }
//
//   /// Initial load with builder filter
//   Future<void> _initBuilderProjects() async {
//     await _applyBuilderFilter();
//     await loadInitial();
//   }
//
//   /// Builder-only projects
//   Future<void> _applyBuilderFilter() async {
//     final userData = await SecureStorage.getUserData();
//     final userId = userData?.user?.id;
//
//     if (userId == null) return;
//
//     filters['created_by'] = userId;
//   }
//
//   // ==============================
//   // Pagination
//   // ==============================
//
//   @override
//   Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
//     try {
//       log("📦 Fetch Builder Projects | page=$page | filters=$filters");
//       return await _builderService.fetchProjects(page: page, filters: filters);
//     } catch (e) {
//       log("❌ Fetch error: $e");
//       rethrow;
//     }
//   }
//
//   // ==============================
//   // Filters
//   // ==============================
//
//   /// Apply multiple filters at once
//   void applyFilters(Map<String, String> newFilters) {
//     // Preserve the created_by filter
//     final createdBy = filters['created_by'];
//
//     // Clear and set new filters
//     filters.clear();
//     filters.addAll(newFilters);
//
//     // Ensure created_by is always present
//     if (createdBy != null) {
//       filters['created_by'] = createdBy;
//     }
//
//     _resetAndReload();
//   }
//
//   void clearFilter(String key) {
//     // Don't allow clearing created_by
//     if (key == 'created_by') return;
//
//     filters.remove(key);
//     _resetAndReload();
//   }
//
//   void clearAllFilters() {
//     final createdBy = filters['created_by'];
//     filters.clear();
//     if (createdBy != null) {
//       filters['created_by'] = createdBy;
//     }
//     _resetAndReload();
//   }
//
//   void _resetAndReload() {
//     currentPage.value = 1;
//     totalPages.value = 1;
//     hasMore.value = true;
//     items.clear();
//     refreshList();
//   }
//
//   // ==============================
//   // Refresh
//   // ==============================
//
//   Future<void> refreshProjects() async {
//     try {
//       isRefreshing.value = true;
//       _resetAndReload();
//       await Future.delayed(const Duration(milliseconds: 600));
//     } finally {
//       isRefreshing.value = false;
//     }
//   }
//
//   // ==============================
//   // Actions
//   // ==============================
//
//   Future<ProjectItem?> getProjectById(String id) async {
//     try {
//       final cached = items.firstWhereOrNull((element) => element.id == id);
//       if (cached != null) return cached;
//
//       final project = await _builderService.getProjectById(id);
//       items.add(project);
//       return project;
//     } catch (e) {
//       log("❌ Get project error: $e");
//       return null;
//     }
//   }
//
//   void _deleteError() {
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: "Delete Failed",
//       message: "Unable to delete project",
//       contentType: ContentType.failure,
//     );
//   }
// }

// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
// import 'package:nesticope_app/data/network/builder/service/builder_service.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//
// class BuilderProjectListController extends PaginatedController<ProjectItem> {
//   final BuilderService _builderService = BuilderService();
//
//   /// UI state
//   final RxBool isLoading = false.obs;
//   final RxBool isRefreshing = false.obs;
//   final RxBool isFilterLoading = false.obs;
//
//   Map<String, String> filters = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initBuilderProjects();
//   }
//
//   /// Initial load with builder filter
//   Future<void> _initBuilderProjects() async {
//     await _applyBuilderFilter();
//     await loadInitial();
//   }
//
//   /// Builder-only projects
//   Future<void> _applyBuilderFilter() async {
//     final userData = await SecureStorage.getUserData();
//     final userId = userData?.user?.id;
//
//     if (userId == null) return;
//
//     filters['created_by'] = userId;
//   }
//
//   // ==============================
//   // Pagination
//   // ==============================
//
//   @override
//   Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
//     try {
//       log("📦 Fetch Builder Projects | page=$page | filters=$filters");
//       return await _builderService.fetchProjects(page: page, filters: filters);
//     } catch (e) {
//       log("❌ Fetch error: $e");
//       rethrow;
//     }
//   }
//
//   // ==============================
//   // Filters
//   // ==============================
//
//   /// Apply multiple filters at once
//   Future<void> applyFilters(Map<String, String> newFilters) async {
//     try {
//       isFilterLoading.value = true;
//
//       // Preserve the created_by filter
//       final createdBy = filters['created_by'];
//
//       // Clear and set new filters
//       filters.clear();
//       filters.addAll(newFilters);
//
//       // Ensure created_by is always present
//       if (createdBy != null) {
//         filters['created_by'] = createdBy;
//       }
//
//       await _resetAndReload();
//     } finally {
//       isFilterLoading.value = false;
//     }
//   }
//
//   Future<void> clearFilter(String key) async {
//     // Don't allow clearing created_by
//     if (key == 'created_by') return;
//
//     try {
//       isFilterLoading.value = true;
//       filters.remove(key);
//       await _resetAndReload();
//     } finally {
//       isFilterLoading.value = false;
//     }
//   }
//
//   Future<void> clearAllFilters() async {
//     try {
//       isFilterLoading.value = true;
//
//       final createdBy = filters['created_by'];
//       filters.clear();
//       if (createdBy != null) {
//         filters['created_by'] = createdBy;
//       }
//
//       await _resetAndReload();
//     } finally {mgmk kdiem
//       isFilterLoading.value = false;
//     }
//   }
//
//   Future<void> _resetAndReload() async {
//     currentPage.value = 1;
//     totalPages.value = 1;
//     hasMore.value = true;
//     items.clear();
//     await refreshList();
//   }
//
//   // ==============================
//   // Refresh
//   // ==============================
//
//   Future<void> refreshProjects() async {
//     try {
//       isRefreshing.value = true;
//       await _resetAndReload();
//       await Future.delayed(const Duration(milliseconds: 600));
//     } finally {
//       isRefreshing.value = false;
//     }
//   }
//
//   // ==============================
//   // Actions
//   // ==============================
//
//   Future<ProjectItem?> getProjectById(String id) async {
//     try {
//       final cached = items.firstWhereOrNull((element) => element.id == id);
//       if (cached != null) return cached;
//
//       final project = await _builderService.getProjectById(id);
//       items.add(project);
//       return project;
//     } catch (e) {
//       log("❌ Get project error: $e");
//       return null;
//     }
//   }
//
//   void _deleteError() {
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: "Delete Failed",
//       message: "Unable to delete project",
//       contentType: ContentType.failure,
//     );
//   }
// }

import 'dart:developer';

import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/data/network/builder/service/builder_service.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

/// ==============================
/// Screen Loading States
/// ==============================
enum BuilderProjectLoadingState {
  initialLoading,
  normal,
  filterLoading,
  refreshing,
  error,
}

class BuilderProjectListController extends PaginatedController<ProjectItem> {
  final BuilderService _builderService = BuilderService();

  /// ==============================
  /// Screen-level UI State
  /// ==============================
  final Rx<BuilderProjectLoadingState> loadingState =
      BuilderProjectLoadingState.initialLoading.obs;

  bool get isInitialLoading =>
      loadingState.value == BuilderProjectLoadingState.initialLoading;

  bool get isFilterLoading =>
      loadingState.value == BuilderProjectLoadingState.filterLoading;

  /// NOTE:
  /// isRefreshing is inherited from PaginatedController (RxBool)
  /// DO NOT override it here

  /// ==============================
  /// Filtersjdncj vnjsdnjureSkidsjfidmmskiefdhnjsie
  /// ==============================
  final Map<String, String> filters = {};

  @override
  void onInit() {
    super.onInit();

    _initBuilderProjects();
  }

  /// ==============================
  /// Initial Load
  /// ==============================
  Future<void> _initBuilderProjects() async {
    try {
      loadingState.value = BuilderProjectLoadingState.initialLoading;

      await applyBuilderFilter();
      await loadInitial();
    } catch (e) {
      log("❌ Initial load error: $e");
      loadingState.value = BuilderProjectLoadingState.error;
    } finally {
      loadingState.value = BuilderProjectLoadingState.normal;
    }
  }

  /// Ensure builder-only projects
  Future<void> applyBuilderFilter() async {
    final userData = await SecureStorage.getUserData();
    print("User data for builder filter: ${userData?.user?.toJson()}");
    final userId = userData?.user?.id;
    if (userId != null) {
      filters['created_by'] = userId;
    }
  }

  /// ==============================
  /// Pagination
  /// ==============================
  @override
  Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
    try {
      log("📦 Fetch Builder Projects | page=$page | filters=$filters");

      return await _builderService.fetchProjects(page: page, filters: filters);
    } catch (e) {
      log("❌ Fetch error: $e");
      loadingState.value = BuilderProjectLoadingState.error;
      rethrow;
    }
  }

  /// ==============================
  /// Filters
  /// ==============================
  Future<void> applyFilters(Map<String, String> newFilters) async {
    try {
      print("Applying filters: $newFilters");
      loadingState.value = BuilderProjectLoadingState.filterLoading;

      final createdBy = filters['created_by'];

      filters
        ..clear()
        ..addAll(newFilters);

      if (createdBy != null) {
        filters['created_by'] = createdBy;
      }

      await _resetAndReload();
    } finally {
      loadingState.value = BuilderProjectLoadingState.normal;
    }
  }

  Future<void> clearFilter(String key) async {
    if (key == 'created_by') return;

    try {
      loadingState.value = BuilderProjectLoadingState.filterLoading;

      filters.remove(key);
      await _resetAndReload();
    } finally {
      loadingState.value = BuilderProjectLoadingState.normal;
    }
  }

  Future<void> clearAllFilters() async {
    try {
      loadingState.value = BuilderProjectLoadingState.filterLoading;

      final createdBy = filters['created_by'];
      filters.clear();

      if (createdBy != null) {
        filters['created_by'] = createdBy;
      }

      await _resetAndReload();
    } finally {
      loadingState.value = BuilderProjectLoadingState.normal;
    }
  }

  /// ==============================
  /// Refresh (Pull to Refresh)
  /// ==============================
  Future<void> refreshProjects() async {
    try {
      /// from PaginatedController
      isRefreshing.value = true;
      loadingState.value = BuilderProjectLoadingState.refreshing;

      await _resetAndReload();
    } finally {
      isRefreshing.value = false;
      loadingState.value = BuilderProjectLoadingState.normal;
    }
  }

  /// ==============================
  /// Helpers
  /// ==============================
  Future<void> _resetAndReload() async {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();
    await refreshList();
  }

  /// ==============================
  /// Actions
  /// ==============================
  Future<ProjectItem?> getProjectById(String id) async {
    try {
      // final cached = items.firstWhereOrNull((e) => e.id == id);
      //
      // if (cached != null) return cached;

      final project = await _builderService.getProjectById(id);
      items.add(project);
      return project;
    } catch (e) {
      log("❌ Get project error: $e");
      return null;
    }
  }

  /// Delete a project (builder) and remove from list
  Future<void> deleteProject(String id) async {
    try {
      loadingState.value = BuilderProjectLoadingState.filterLoading;
      final ok = await _builderService.deleteProject(id);
      if (ok) {
        items.removeWhere((p) => p.id == id);
        await refreshList();
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Deleted',
          message: 'Project deleted successfully',
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Delete Failed',
          message: 'Unable to delete project',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      log('❌ Delete project error: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Delete Failed',
        message: 'Unable to delete project',
        contentType: ContentType.failure,
      );
    } finally {
      loadingState.value = BuilderProjectLoadingState.normal;
    }
  }

  void _deleteError() {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: "Delete Failed",
      message: "Unable to delete project",
      contentType: ContentType.failure,
    );
  }
}
