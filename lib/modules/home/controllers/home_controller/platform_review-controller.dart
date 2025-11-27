// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../data/network/platform_review/model/platform_review_model.dart';
// import '../../../../data/network/platform_review/service/platform_review_service.dart';
//
// class PlatformReviewController extends GetxController {
//   final ReviewService _reviewService = ReviewService();
//
//   var isLoading = false.obs;
//   var isLoadingMore = false.obs;
//   var allReviews = <ReviewItem>[].obs;
//   var siteReviews = <ReviewItem>[].obs;
//   Rxn<UsersResponse> userData = Rxn<UsersResponse>();
//   var listOfUser = <UserItem>[].obs;
//
//   // Pagination variables
//   var currentPage = 1.obs;
//   var totalPages = 1.obs;
//   var hasMore = false.obs;
//   var total = 0.obs;
//
//   // ScrollController for pagination
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     scrollController.addListener(_scrollListener);
//     fetchAllReviews();
//   }
//
//   @override
//   void onClose() {
//     scrollController.removeListener(_scrollListener);
//     scrollController.dispose();
//     super.onClose();
//   }
//
//   void _scrollListener() {
//     if (scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent) {
//       if (hasMore.value && !isLoadingMore.value) {
//         loadMoreReviews();
//       }
//     }
//   }
//
//   Future<void> fetchAllReviews({bool refresh = false}) async {
//     try {
//       if (refresh) {
//         currentPage.value = 1;
//         allReviews.clear();
//       }
//
//       isLoading.value = true;
//
//       final response = await _reviewService.fetchReviews(
//         page: currentPage.value,
//       );
//
//       if (response != null && response.story == true) {
//         if (refresh) {
//           allReviews.value = response.data?.items ?? [];
//         } else {
//           allReviews.addAll(response.data?.items ?? []);
//         }
//
//         total.value = response.data?.total ?? 0;
//         currentPage.value = response.data?.currentPage ?? 1;
//         totalPages.value = response.data?.totalPages ?? 1;
//         hasMore.value = response.data?.hasMore ?? false;
//
//         filterSiteReviews();
//       }
//     } catch (e) {
//       debugPrint("Error fetching all reviews: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   RxList<ReviewWithUser> siteReviewWithUsers = <ReviewWithUser>[].obs;
//
//   Future<void> filterSiteReviews() async {
//     siteReviews.value =
//         allReviews.where((review) {
//           return review.entityType?.toLowerCase() == 'site';
//         }).toList();
//
//     userData.value = await _reviewService.fetchReviewsData(
//       page: currentPage.value,
//     );
//
//     final matched = <ReviewWithUser>[];
//
//     for (var site in siteReviews.value) {
//       final user = userData.value?.data?.items?.firstWhereOrNull(
//         (u) => u.id == site.entityId,
//       );
//
//       matched.add(ReviewWithUser(review: site, user: user));
//     }
//
//     siteReviewWithUsers.value = matched;
//   }
//
//   // Future<void> filterSiteReviews() async {
//   //   siteReviews.value = allReviews.where((review) {
//   //     return review.entityType?.toLowerCase() == 'site';
//   //   }).toList();
//   //
//   //   userData.value = await _reviewService.fetchReviewsData(
//   //     page: currentPage.value,
//   //   );
//   //
//   //   for(var site in siteReviews.value)
//   //     {
//   //       for(UserItem userData in userData.value?.data?.items??[])
//   //         {
//   //           if(site.entityId==userData.id)
//   //             {
//   //               listOfUser.value.add(userData);
//   //             }
//   //
//   //         }
//   //     }
//   //   debugPrint("Total reviews: ${allReviews.length}");
//   //   debugPrint("Site reviews: ${siteReviews.length}");
//   //   debugPrint("Review reviews: ${userData.value?.data?.toMap()}=================");
//   //   debugPrint("Review fdgfdfg: ${listOfUser.map((element) => element.toMap(),)}=================");
//   // }
//   Future<void> loadMoreReviews() async {
//     if (!hasMore.value || isLoadingMore.value) return;
//
//     try {
//       isLoadingMore.value = true;
//       currentPage.value++;
//
//       final response = await _reviewService.fetchReviews(
//         page: currentPage.value,
//       );
//
//       if (response != null && response.story == true) {
//         allReviews.addAll(response.data?.items ?? []);
//         hasMore.value = response.data?.hasMore ?? false;
//
//         // Update site reviews filter
//         filterSiteReviews();
//       }
//     } catch (e) {
//       debugPrint("Error loading more reviews: $e");
//       currentPage.value--;
//     } finally {
//       isLoadingMore.value = false;
//     }
//   }
// }
//
// class ReviewWithUser {
//   final ReviewItem review;
//   final UserItem? user;
//
//   ReviewWithUser({required this.review, this.user});
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/network/platform_review/model/platform_review_model.dart';
import '../../../../data/network/platform_review/service/platform_review_service.dart';

class PlatformReviewController extends GetxController {
  final ReviewService _reviewService = ReviewService();

  PlatformReviewController({required this.type});
  // Observables
  final String type;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var allReviews = <ReviewItem>[].obs;
  var siteReviews = <ReviewItem>[].obs;
  Rxn<UsersResponse> userData = Rxn<UsersResponse>();
  var siteReviewWithUsers = <ReviewWithUser>[].obs;

  // Pagination for reviews
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMore = false.obs;
  var total = 0.obs;

  // Pagination for users
  var userCurrentPage = 1.obs;
  var userTotalPages = 1.obs;
  var userHasMore = false.obs;
  var userFetchedAll = false.obs;
  var userTotal = 0.obs;

  Map<String, String> filters = {};

  // Scroll controller
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    filters = {'entity_type': type};
    fetchAllReviews();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (hasMore.value && !isLoadingMore.value) {
        loadMoreReviews();
      }
    }
  }

  /// 🔹 Fetch all reviews
  Future<void> fetchAllReviews({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        allReviews.clear();
      }

      isLoading.value = true;

      final response = await _reviewService.fetchReviews(
        page: currentPage.value,
        filters: filters,
      );

      if (response != null && response.success == true) {
        if (refresh) {
          allReviews.value = response.data?.items ?? [];
        } else {
          allReviews.addAll(response.data?.items ?? []);
        }

        total.value = response.data?.total ?? 0;
        currentPage.value = response.data?.currentPage ?? 1;
        totalPages.value = response.data?.totalPages ?? 1;
        hasMore.value = response.data?.hasMore ?? false;

        await filterSiteReviews();
      }
    } catch (e) {
      debugPrint("❌ Error fetching all reviews: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Filter site reviews and attach users
  Future<void> filterSiteReviews() async {
    siteReviews.value =
        allReviews.where((review) {
          return review.entityType?.toLowerCase() == 'site';
        }).toList();

    // Fetch user data
    await _fetchUsersData();

    final matched = <ReviewWithUser>[];

    for (var site in siteReviews) {
      final user = userData.value?.data?.items?.firstWhereOrNull(
        (u) => u.id == site.entityId,
      );
      matched.add(ReviewWithUser(review: site, user: user));
    }

    siteReviewWithUsers.value = matched;

    debugPrint("✅ Total reviews: ${allReviews.length}");
    debugPrint("✅ Site reviews: ${siteReviews.length}");
    debugPrint("✅ Matched siteReviewWithUsers: ${siteReviewWithUsers.length}");
  }

  /// 🔹 Fetch users data with pagination fields handled
  Future<void> _fetchUsersData() async {
    try {
      userData.value = await _reviewService.fetchReviewsData(
        page: userCurrentPage.value,
      );

      final response = userData.value;
      if (response == null) return;

      userTotal.value = response.data?.total ?? 0;
      userCurrentPage.value = response.data?.currentPage ?? 1;
      userTotalPages.value = response.data?.totalPages ?? 1;
      userHasMore.value = response.data?.hasMore ?? false;
      userFetchedAll.value = response.data?.fetchedAll ?? false;
    } catch (e) {
      debugPrint("❌ Error fetching user data: $e");
    }
  }

  /// 🔹 Load more reviews (pagination)
  Future<void> loadMoreReviews() async {
    if (!hasMore.value || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await _reviewService.fetchReviews(
        page: currentPage.value,
      );

      if (response != null && response.success == true) {
        allReviews.addAll(response.data?.items ?? []);
        hasMore.value = response.data?.hasMore ?? false;

        await filterSiteReviews();
      }
    } catch (e) {
      debugPrint("❌ Error loading more reviews: $e");
      currentPage.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }
}

/// 🔹 Combined review + user model
class ReviewWithUser {
  final ReviewItem review;
  final UserItem? user;

  ReviewWithUser({required this.review, this.user});
}
