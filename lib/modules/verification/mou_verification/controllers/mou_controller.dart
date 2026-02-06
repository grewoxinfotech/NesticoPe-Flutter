import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../../../data/network/verification/mou_verification/mou_post_service.dart';

class MouController extends GetxController {
  final MouService _service = MouService();

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
  );

  final nameController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isAgreed = false.obs;

  final String userId = "iaZ6nlM6pd3R34V2pxNuVG6";

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
      isLoading.value = true;

      Uint8List? bytes = await signatureController.toPngBytes();

      if (bytes == null) {
        Get.snackbar("Error", "Signature capture failed");
        return;
      }

      await _service.uploadSignature(
        signatureBytes: bytes,
        name: nameController.text.trim(),
        userId: userId,
      );

      Get.snackbar("Success", "MOU signed successfully");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload signature");
    } finally {
      isLoading.value = false;
    }
  }

  void clearSignature() {
    signatureController.clear();
  }

  @override
  void onClose() {
    signatureController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
