import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/share_property/service/share_property-service.dart';

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

}