import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/verification/mou_verification/mou_content_model.dart';
import 'package:nesticope_app/data/network/verification/mou_verification/platform_setting_model.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:signature/signature.dart';
import '../../../../data/network/verification/mou_verification/mou_post_service.dart';
import 'mou_verification_controller.dart';

class MouController extends PaginatedController<MouItem> {
  final MouService _service = MouService();

  // Look up the shared DigitalSignatureController instance registered
  // with the 'signature' tag to match other parts of the app.

  MouController({required this.digitalSignatureController});
  DigitalSignatureController digitalSignatureController;

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
  );

  final nameController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isAgreed = false.obs;
  @override
  onInit() {
    super.onInit();
    // fetchFirstPage();
    loadInitial();
  }

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
      digitalSignatureController.isSignatureVerified.value = true;
      signatureController.clear();

      Get.back();
    } catch (e) {
      print("Signature Error : ${e}");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to upload signature',
        contentType: ContentType.failure,
      );
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

  @override
  Future<PaginationResponse<MouItem>> fetchItems(int page) {
    // TODO: implement fetchItems
    // throw UnimplementedError();
    print("Check Mou come perfect ${_service.getMouVerification(page: page, limit: 10)}=======${items.map((element) => element.toJson(),)}");
    
    return _service.getMouVerification(page: page, limit: 10);
  }
}

// ignore: camel_case_types
class PlatformFeeController extends PaginatedController<PlatformFeeItem> {
  final MouService _service = MouService();

  // List<PlatformFeeResponse> platformFeeItems = <PlatformFeeResponse>[].obs;

  @override
  onInit() {
    super.onInit();
    // fetchFirstPage();
    loadInitial();
  }

  @override
  Future<PaginationResponse<PlatformFeeItem>> fetchItems(int page) {
    return _service.getPlatformFeeSetting(page: page, limit: 10);
  }
}
