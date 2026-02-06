import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/network/verification/mou_verification/mou_verification.dart';

class DigitalSignatureController extends GetxController {
  final DigitalSignatureService _service = DigitalSignatureService();

  DigitalSignatureController({required this.userId});

  /// Observables
  final RxList<dynamic> signatures = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool hasMoreData = true.obs;

  /// Pagination
  int _page = 1;
  final int _limit = 10;

  /// Replace this with your auth userId source
  final String userId;

  /// ================================
  /// Fetch Digital Signatures
  /// ================================
  Future<void> fetchDigitalSignatures({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _page = 1;
        hasMoreData.value = true;
        signatures.clear();
      }

      if (!hasMoreData.value) return;

      if (_page == 1) {
        isLoading.value = true;
      } else {
        isPaginationLoading.value = true;
      }

      final response = await _service.fetchDigitalSignatures(
        page: _page,
        limit: _limit,
        userId: userId,
      );

      /// ✅ Correct parsing based on your API response
      final data = response['data'];
      final List newData = data?['items'] ?? [];

      signatures.addAll(newData);

      /// ✅ Use backend pagination flag
      hasMoreData.value = data?['hasMore'] ?? false;

      if (hasMoreData.value) {
        _page++;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  /// ================================
  /// Pull to Refresh
  /// ================================
  Future<void> refreshList() async {
    await fetchDigitalSignatures(isRefresh: true);
  }

  /// ================================
  /// Load More (Infinite Scroll)
  /// ================================
  Future<void> loadMore() async {
    if (!isPaginationLoading.value && hasMoreData.value) {
      await fetchDigitalSignatures();
    }
  }

  /// ================================
  /// Getter: Verification Status
  /// ================================
  bool get isDigitalSignatureVerified => signatures.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchDigitalSignatures();
  }
}
