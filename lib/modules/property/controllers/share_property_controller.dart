import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/share_property/service/share_property-service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/network/share_property/model/share_property_model.dart';

class SharePropertyController extends GetxController{
  Rxn<SharePropertyResponse> shareProperty = Rxn<SharePropertyResponse>();

  var isLoading = false.obs;

  Future<void> getPropertyLinkById(String propertyId) async {
    try {
      isLoading.value = true;
      final data = await SharePropertyService.service.getPropertyLink(propertyId);
      shareProperty.value = SharePropertyResponse.fromJson(data);
    } catch (e, stackTrace) {
      debugPrint('❌ Error fetching property link: $e');
      debugPrint(stackTrace.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> getPropertyLinkByIdInReseller(String propertyId) async {
    try {
      isLoading.value = true;

      final shareUrl = await SharePropertyService.service.sharePropertyLink(propertyId);

      if (shareUrl != null && shareUrl.isNotEmpty) {
        debugPrint("✅ Property Share URL: $shareUrl");

        // 🟢 Share via default apps (WhatsApp, Gmail, Messages, etc.)
        final params = ShareParams(
         uri: Uri.parse(shareUrl)

        );

        // 🟢 Share using new API
        await SharePlus.instance.share(params);
      } else {
        debugPrint("⚠️ Failed to get property share link.");
        Get.snackbar(
          "Error",
          "Failed to generate share link.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error sharing property link: $e');
      debugPrint(stackTrace.toString());
      Get.snackbar(
        "Error",
        "Something went wrong while sharing.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

}