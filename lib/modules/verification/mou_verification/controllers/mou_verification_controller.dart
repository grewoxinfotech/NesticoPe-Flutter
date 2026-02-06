import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:signature/signature.dart';
import '../../../../data/network/verification/mou_verification/mou_verification.dart';

class DigitalSignatureController extends GetxController {
  final DigitalSignatureService _service = DigitalSignatureService();

  DigitalSignatureController({required this.userId});

  /// User ID
  final String userId;

  /// ================================
  /// Signature Upload Related
  /// ================================
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
  );

  final nameController = TextEditingController();

  RxBool isUploadLoading = false.obs;
  RxBool isAgreed = false.obs;

  /// ================================
  /// Signature List Related
  /// ================================
  final RxList<dynamic> signatures = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool hasMoreData = true.obs;
  final isSignatureVerified = false.obs;

  /// Pagination
  int _page = 1;
  final int _limit = 10;

  /// ================================
  /// Submit MOU (Upload Signature)
  /// ================================
  Future<void> submitMou() async {
    if (!isAgreed.value) {
      Get.snackbar("Error", "Please agree to MOU terms");
      return;
    }

    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter full name");
      return;
    }

    if (signatureController.isEmpty) {
      Get.snackbar("Error", "Please provide signature");
      return;
    }

    try {
      isUploadLoading.value = true;

      Uint8List? bytes = await signatureController.toPngBytes();

      if (bytes == null) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Signature capture failed',
          contentType: ContentType.failure,
        );
        return;
      }

      await _service.uploadSignature(
        signatureBytes: bytes,
        name: nameController.text.trim(),
        userId: userId,
      );

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: "MOU signed successfully",
        contentType: ContentType.success,
      );

      isSignatureVerified.value = true;
      signatureController.clear();
      nameController.clear();

      /// Refresh the signature list after upload
      await refreshList();

      Get.back();
    } catch (e) {
      print("Signature Error: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to upload signature',
        contentType: ContentType.failure,
      );
    } finally {
      isUploadLoading.value = false;
    }
  }

  /// ================================
  /// Clear Signature Canvas
  /// ================================
  void clearSignature() {
    signatureController.clear();
  }

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

      /// Parse response based on API structure
      final data = response['data'];
      final List newData = data?['items'] ?? [];

      signatures.addAll(newData);

      if (signatures.isNotEmpty) {
        isSignatureVerified.value = true;
      }

      /// Use backend pagination flag
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

  @override
  void onInit() {
    super.onInit();
    fetchDigitalSignatures();
  }

  @override
  void onClose() {
    signatureController.dispose();
    nameController.dispose();
    super.onClose();
  }
}