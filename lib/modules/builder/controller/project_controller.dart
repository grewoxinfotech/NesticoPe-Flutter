import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/builder/model/builder_model.dart'
    hide ProjectContactInfo, ProjectSize, MediaGallery, Brochure;
// import '../../../data/network/builder/model/builder_projectModel.dart';
import '../../../data/network/property/models/inquiry_model.dart';
import '../../../data/network/property/services/property_contacted_service.dart';
import '../../../data/network/property/services/property_service.dart';
import '../../../widgets/messages/snack_bar.dart';

class ProjectController extends GetxController {
  // final Rx<ProjectItem?> project = Rx<ProjectItem>();

  final PropertyService _propertyService = PropertyService();

  final RxInt selectedConfigIndex = 0.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasSubmittedInquiry = false.obs;
  final PropertyContactedService _contactedService = PropertyContactedService();
  RxList<Inquiry> inquiryResponse = <Inquiry>[].obs;

  final currentConfigPage = 0.obs;
  RxMap<int, int> variantIndexMap = <int, int>{}.obs;
  late PageController configPageController;
  final showAllConfigurations = false.obs;

  // Add these methods
  void toggleShowAllConfigurations() {
    showAllConfigurations.value = !showAllConfigurations.value;
  }

  void initializeExpandedStates(int count) {
    showAllConfigurations.value = false;
  }

  @override
  void onClose() {
    configPageController.dispose();
    super.onClose();
  }

  void initializeVariantIndices(int configCount) {
    variantIndexMap.clear();
    for (int i = 0; i < configCount; i++) {
      variantIndexMap[i] = 0;
    }
  }

  void updateVariantIndex(int configIndex, int variantIndex) {
    variantIndexMap.value[configIndex] = variantIndex;
  }

  void updateConfigPage(int page) {
    currentConfigPage.value = page;
  }

  @override
  void onInit() {
    super.onInit();
    configPageController = PageController();
  }

  void selectConfiguration(int index) {
    selectedConfigIndex.value = index;
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  String formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  Future<void> downloadDocument(String? path) async {
    if (path != null) {
      await launchUrl(Uri.parse(path), mode: LaunchMode.platformDefault);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Document',
        message: 'Loading...',
        contentType: ContentType.help,
      );
    }
  }

  void contactSales(String type) {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Contact',
      message: 'Opening $type...',
      contentType: ContentType.help,
    );
  }

  Future<bool> addView(String id) async {
    final success = await _propertyService.addView(id);
    return success;
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    print("Inquiry Data Sent: $data ====$id");

    final success = await _propertyService.addInquiry(data, id);
    return success;
  }

  Future<void> getAllInQuireData(String propertyId) async {
   if(UserHelper.isGuest)
     {
       final exists = await SecureStorage.hasPropertyInquiry(propertyId);
       hasSubmittedInquiry.value = exists;
     }
   else{
     try {
       final UserModel user = await SecureStorage.getUserData() ?? UserModel();
       final userId = user.user?.id ?? '';
       final inquiries = await _contactedService.fetchContactedInquiries(userId);
       inquiryResponse.assignAll(inquiries);

       final result = inquiryResponse.any((e) => e.propertyId == propertyId);

       hasSubmittedInquiry.value = result;
       print(
         "Inquiry Data ** ${inquiryResponse.map((e) => e.toJson()).toList()}    ${result} ${hasSubmittedInquiry.value}",
       );
       print("Inquiry Response ** ${result} ${hasSubmittedInquiry.value}");
     } catch (e) {
       print("Error fetching inquiries: $e");
     }
   }
  }

  Future<void> getHasInQuireData(String propertyId) async {
    if(UserHelper.isGuest) {
      final exists = await SecureStorage.hasPropertyInquiry(propertyId);
      hasSubmittedInquiry.value = exists;
    }else{
      try {
        final UserModel user = await SecureStorage.getUserData() ?? UserModel();
        final userId = user.user?.id ?? '';
        final inquiries = await _contactedService.fetchHasInquiries(
          userId,
          itemId: propertyId,
        );

        hasSubmittedInquiry.value = inquiries;
        print(
          "Inquiry Data ** ${inquiryResponse.map((e) => e.toJson()).toList()}    ${inquiries} ${hasSubmittedInquiry.value}",
        );
        print("Inquiry Response ** ${inquiries} ${hasSubmittedInquiry.value}");
      } catch (e) {
        print("Error fetching inquiries: $e");
      }
    }
    }

}
