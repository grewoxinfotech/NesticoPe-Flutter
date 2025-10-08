// import 'package:get/get.dart';
// import '../models/pagination_models.dart';
//
// abstract class PaginatedController<T> extends GetxController {
//   var items = <T>[].obs;
//   var isLoading = false.obs;      // For initial loading & refresh
//   var isPaging = false.obs;       // For loading next pages
//   var currentPage = 1.obs;
//   var totalPages = 1.obs;
//   var hasMore = true.obs;
//   var isRefreshing = false.obs;
//
//   /// Fetch items from API, returning a PaginationResponse
//   // Future<PaginationResponse<T>> fetchItems(int page);
//
//   Future<List<T>> fetchItems(int page);
//
//
//   Future<void> loadInitial() async {
//     print("Pagination: loadInitial called");
//     currentPage.value = 1;
//     items.clear();
//     await _loadPage(page: 1);
//   }
//
//   Future<void> loadMore() async {
//     if (hasMore.value && !isPaging.value && !isLoading.value) {
//       print("Pagination: loadMore called. Current page: ${currentPage.value}, Total pages: ${totalPages.value}");
//       currentPage.value += 1;
//       await _loadPage(page: currentPage.value);
//     } else {
//       print("Pagination: loadMore skipped. Current page: ${currentPage.value}, Total pages: ${totalPages.value}, isLoading: ${isLoading.value}, isPaging: ${isPaging.value}, hasMore: ${hasMore.value}");
//     }
//   }
//
//   Future<void> refreshList() async {
//     print("Pagination: refreshList called");
//     isRefreshing.value = true;
//     currentPage.value = 1;
//     items.clear();
//     await _loadPage(page: 1);
//     isRefreshing.value = false;
//   }
//
//   Future<void> _loadPage({required int page}) async {
//     print("Pagination: _loadPage called for page $page");
//
//     if (page == 1 && !isRefreshing.value) {
//       isLoading.value = true;
//     } else {
//       isPaging.value = true;
//     }
//
//     try {
//       final response = await fetchItems(page);
// print("Pagination: Response from fetchItems: ${response}");
//       if (page == 1) {
//         items.assignAll(response);
//         isLoading.value = false;
//       } else {
//         items.addAll(response);
//         isPaging.value = false;
//       }
//
//     //   // Update pagination metadata
//     //   currentPage.value = response.meta.currentPage;
//     //   totalPages.value = response.meta.totalPages;
//     //   hasMore.value = response.meta.hasMore;
//     //
//     //   print("Pagination: Page ${response.meta.currentPage} loaded. Total pages: ${response.meta.totalPages}, Has more: ${response.meta.hasMore}");
//     } catch (e) {
//       print("Pagination: Error loading page $page: $e");
//       isLoading.value = false;
//       isPaging.value = false;
//     }
//   }
// }

// import 'package:get/get.dart';
// import '../models/pagination_models.dart';
//
// abstract class PaginatedController<T> extends GetxController {
//   var items = <T>[].obs;
//   var isLoading = false.obs;      // For initial loading & refresh
//   var isPaging = false.obs;       // For loading next pages
//   var currentPage = 1.obs;
//   var totalPages = 1.obs;
//   var hasMore = true.obs;
//   var isRefreshing = false.obs;
//
//   /// Fetch items from API, returning a PaginationResponse
//   Future<PaginationResponse<T>> fetchItems(int page);
//
//   // Future<List<T>> fetchItems(int page);
//
//
//   Future<void> loadInitial() async {
//     print("Pagination: loadInitial called");
//     currentPage.value = 1;
//     items.clear();
//     await _loadPage(page: 1);
//   }
//
//   Future<void> loadMore() async {
//     if (hasMore.value && !isPaging.value && !isLoading.value) {
//       print("Pagination: loadMore called. Current page: ${currentPage.value}, Total pages: ${totalPages.value}");
//       currentPage.value += 1;
//       await _loadPage(page: currentPage.value);
//     } else {
//       print("Pagination: loadMore skipped. Current page: ${currentPage.value}, Total pages: ${totalPages.value}, isLoading: ${isLoading.value}, isPaging: ${isPaging.value}, hasMore: ${hasMore.value}");
//     }
//   }
//
//   Future<void> refreshList() async {
//     print("Pagination: refreshList called");
//     isRefreshing.value = true;
//     currentPage.value = 1;
//     items.clear();
//     await _loadPage(page: 1);
//     isRefreshing.value = false;
//   }
//
//   Future<void> _loadPage({required int page}) async {
//     print("Pagination: _loadPage called for page $page");
//
//     if (page == 1) {
//       isLoading.value = true;
//     } else {
//       isPaging.value = true;
//     }
//
//     try {
//       final response = await fetchItems(page);
//       print("Pagination: Response from fetchItems: ${response}");
//       if (page == 1) {
//         items.assignAll(response.items);
//         isLoading.value = false;
//       } else {
//         items.addAll(response.items);
//         isPaging.value = false;
//       }
//
//       //   // Update pagination metadata
//         currentPage.value = response.meta.currentPage;
//         totalPages.value = response.meta.totalPages;
//         hasMore.value = response.meta.hasMore;
//       //
//       //   print("Pagination: Page ${response.meta.currentPage} loaded. Total pages: ${response.meta.totalPages}, Has more: ${response.meta.hasMore}");
//     } catch (e) {
//       print("Pagination: Error loading page $page: $e");
//       isLoading.value = false;
//       isPaging.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import '../models/pagination_models.dart';

/// Generic Pagination Controller using GetX
abstract class PaginatedController<T> extends GetxController {
  var items = <T>[].obs;

  var isLoading = false.obs; // For initial loading & refresh
  var isPaging = false.obs; // For loading next pages
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMore = true.obs;
  var isRefreshing = false.obs;

  /// Fetch items from API, must return PaginationResponse<T>
  Future<PaginationResponse<T>> fetchItems(int page);

  /// Load first page (initial or after refresh)
  Future<void> loadInitial() async {
    print("Pagination: loadInitial called");
    currentPage.value = 1;
    await _loadPage(page: 1, clear: true);
  }

  /// Load next page
  Future<void> loadMore() async {
    // if (hasMore.value && !isPaging.value && !isLoading.value) {
    print(
      "Pagination: loadMore called. Current page: ${currentPage.value}, Total pages: ${totalPages.value}",
    );
    currentPage.value += 1;
    await _loadPage(page: currentPage.value);
    // } else {
    //   print(
    //     "Pagination: loadMore skipped. Current page: ${currentPage.value}, "
    //     "Total pages: ${totalPages.value}, isLoading: ${isLoading.value}, "
    //     "isPaging: ${isPaging.value}, hasMore: ${hasMore.value}",
    //   );
    // }
  }

  /// Pull-to-refresh
  Future<void> refreshList() async {
    print("Pagination: refreshList called");
    isRefreshing.value = true;
    currentPage.value = 1;
    await _loadPage(page: 1, clear: true);
    isRefreshing.value = false;
  }

  /// Internal loader
  Future<void> _loadPage({required int page, bool clear = false}) async {
    print("Pagination: _loadPage called for page $page");

    if (page == 1 && !isRefreshing.value) {
      isLoading.value = true;
    } else {
      isPaging.value = true;
    }

    try {
      final response = await fetchItems(page);
      print("Pagination: Response from fetchItems: ${response.meta.toJson()}");

      if (clear) {
        // ✅ replaces clear+addAll to avoid intermediate empty state
        items.assignAll(response.items);
      } else {
        items.addAll(response.items);
      }

      // ✅ Update pagination metadata safely
      currentPage.value = response.meta.currentPage;
      totalPages.value = response.meta.totalPages;
      hasMore.value = response.meta.hasMore;

      isLoading.value = false;
      isPaging.value = false;

      print(
        "Pagination: Page ${response.meta.currentPage} loaded. "
        "Total pages: ${response.meta.totalPages}, "
        "Has more: ${response.meta.hasMore}",
      );
    } catch (e) {
      print("Pagination: Error loading page $page: $e");
      isLoading.value = false;
      isPaging.value = false;
    }
  }
}
