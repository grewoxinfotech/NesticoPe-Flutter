import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property_share/property_share_model.dart';
import 'package:housing_flutter_app/data/network/property_share/property_share_service.dart';
import 'package:housing_flutter_app/modules/reseller/view/property_share/reseller_property_share.dart';
import 'package:housing_flutter_app/modules/reseller/view/property_share/reseller_property_share_link_screen.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/utils/helper_function/contact_helper.dart';
import '../../../../data/network/interest_form/interest_form_model.dart';
import '../../../../data/network/interest_form/interest_form_service.dart';
import '../../../../widgets/messages/snack_bar.dart';

// class ReSellerPropertyShareController extends GetxController {
//   final InterestFormService _interestFormService = InterestFormService();
//   final PropertyShareService _propertyShareService = PropertyShareService();
//   final RxList<CustomFormField> customFields = <CustomFormField>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxList<PropertyShareModel> propertyShareItems =
//       <PropertyShareModel>[].obs;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   /// Create Interest Form
//   Future<void> createInterestForm({required String propertyId}) async {
//     try {
//       isLoading.value = true;
//
//       final user = await SecureStorage.getUserData();
//       final resellerId = user?.user?.id ?? '';
//
//       final InterestFormModel data = InterestFormModel(
//         propertyId: propertyId,
//         resellerId: resellerId,
//         formFields: customFields,
//       );
//
//       final String? formId = await _interestFormService.addInterestForm(data);
//
//       if (formId != null) {
//         final shareData = PropertyShareModel(
//           propertyId: propertyId,
//           resellerId: resellerId,
//           interestFormId: formId,
//           platform: "mobile",
//           shareType: "direct",
//         );
//         final link = await _propertyShareService.addPropertyShare(shareData);
//         if (link != null) {
//           Get.to(
//             () => ResellerPropertyShareLinkScreen(
//               shareUrl: link,
//               propertyId: propertyId,
//               resellerId: resellerId,
//             ),
//           );
//         }
//         print("✅ Form created successfully with ID: $formId");
//         Get.snackbar(
//           "Success",
//           "Interest Form Created (ID: $formId)",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         print("❌ Failed to create form");
//       }
//     } catch (e) {
//       print("⚠️ Error During Form Creation: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> createPropertyShare({
//     required String propertyId,
//     required String resellerId,
//     required String platform,
//     required String shareType,
//   }) async {
//     try {
//       isLoading.value = true;
//       Get.snackbar("Sharing", "Creating property share for $platform...");
//
//       // 🔹 Step 1: Fetch existing property shares for this property & reseller
//       final List<PropertyShareModel>? existingShares =
//           await _propertyShareService.getPropertyShareByPropertyAndReseller(
//             propertyId: propertyId,
//             resellerId: resellerId,
//           );
//
//       // 🔹 Step 2: If any existing shares found, store them in propertyShareItems list
//       propertyShareItems.clear();
//       if (existingShares != null && existingShares.isNotEmpty) {
//         propertyShareItems.addAll(existingShares);
//         debugPrint(
//           "📦 Loaded existing property shares: ${existingShares.length}",
//         );
//       } else {
//         debugPrint("ℹ️ No existing shares found for this property/reseller");
//       }
//
//       // 🔹 Step 3: Prepare share data (use first form if exists, else null)
//       final String? interestFormId =
//           propertyShareItems.isNotEmpty
//               ? propertyShareItems.first.interestFormId
//               : null;
//
//       final PropertyShareModel shareData = PropertyShareModel(
//         propertyId: propertyId,
//         resellerId: resellerId,
//         interestFormId: interestFormId,
//         platform: platform,
//         shareType: shareType,
//       );
//
//       // 🔹 Step 4: Create new property share & get share link
//       final String? shareLink = await _propertyShareService.addPropertyShare(
//         shareData,
//       );
//
//       // 🔹 Step 5: Handle response
//       if (shareLink != null && shareLink.isNotEmpty) {
//         debugPrint("✅ Property share created successfully: $shareLink");
//
//         // Try launching the link externally before redirecting
//         final uri = Uri.parse(shareLink);
//
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         debugPrint("⚠️ Failed to generate share link");
//         Get.snackbar(
//           "Error",
//           "Failed to generate share link. Please try again.",
//         );
//       }
//     } catch (e) {
//       debugPrint("⚠️ Error During Property Share Creation: $e");
//       Get.snackbar("Error", "Something went wrong while creating share link.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> handleShareButtonTap({
//     required String propertyId,
//     required String resellerId,
//   }) async {
//     try {
//       isLoading.value = true;
//
//       // 🔹 Step 1: Check if share already exists
//       final List<PropertyShareModel>? existingShares =
//           await _propertyShareService.getPropertyShareByPropertyAndReseller(
//             propertyId: propertyId,
//             resellerId: resellerId,
//           );
//
//       if (existingShares != null && existingShares.isNotEmpty) {
//         final existingShare = existingShares.first;
//         final existingLink = existingShare.shareUrl;
//
//         debugPrint("🔁 Existing share found: $existingLink");
//
//         // If existing share URL is valid → navigate directly
//         if (existingLink != null && existingLink.isNotEmpty) {
//           Get.to(
//             () => ResellerPropertyShareLinkScreen(
//               shareUrl: existingLink,
//               resellerId: resellerId,
//               propertyId: propertyId,
//             ),
//           );
//           return;
//         }
//       }
//
//       // 🔹 Step 2: If no existing share found → create a new one
//       debugPrint("🆕 Creating new property share...");
//       final shareData = PropertyShareModel(
//         propertyId: propertyId,
//         resellerId: resellerId,
//         platform: "whatsapp", // default or based on selected platform
//         shareType: "chat", // default or based on selected type
//       );
//
//       final String? newShareLink = await _propertyShareService.addPropertyShare(
//         shareData,
//       );
//
//       if (newShareLink != null && newShareLink.isNotEmpty) {
//         debugPrint("✅ New share created: $newShareLink");
//         Get.to(
//           () => ResellerPropertyShareLinkScreen(
//             shareUrl: newShareLink,
//             resellerId: resellerId,
//             propertyId: propertyId,
//           ),
//         );
//       } else {
//         Get.snackbar("Error", "Failed to generate property share link.");
//       }
//     } catch (e) {
//       debugPrint("⚠️ Error handling property share: $e");
//       Get.snackbar("Error", "Something went wrong while sharing property.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void addPropertyShare(PropertyShareModel form) {
//     propertyShareItems.add(form);
//   }
//
//   void removePropertyShare(PropertyShareModel form) {
//     propertyShareItems.remove(form);
//   }
//
//   void clearPropertyShare() {
//     propertyShareItems.clear();
//   }
//
//   void addField(CustomFormField field) {
//     customFields.add(field);
//   }
//
//   void removeField(CustomFormField field) {
//     customFields.remove(field);
//   }
class ReSellerPropertyShareController extends GetxController {
  // 🔹 Services
  final InterestFormService _interestFormService = InterestFormService();
  final PropertyShareService _propertyShareService = PropertyShareService();

  // 🔹 Observables
  final RxList<CustomFormField> customFields = <CustomFormField>[].obs;
  final RxList<PropertyShareModel> propertyShareItems =
      <PropertyShareModel>[].obs;
  final RxList<MultiShareData> multiShareItems = <MultiShareData>[].obs;
  final RxBool isLoading = false.obs;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // 🧾 CREATE INTEREST FORM
  // ============================================================
  Future<void> createInterestForm({required String propertyId}) async {
    try {
      isLoading.value = true;

      final user = await SecureStorage.getUserData();
      final resellerId = user?.user?.id ?? '';

      if (resellerId.isEmpty) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "User not found. Please login again.",
          contentType: ContentType.failure,
        );
        return;
      }

      final formData = InterestFormModel(
        propertyId: propertyId,
        resellerId: resellerId,
        formFields: customFields,
      );

      final String? formId = await _interestFormService.addInterestForm(
        formData,
      );

      if (formId == null) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Failed to create interest form.",
          contentType: ContentType.failure,
        );
        return;
      }

      // Create property share after form creation
      final shareData = PropertyShareModel(
        propertyId: propertyId,
        resellerId: resellerId,
        interestFormId: formId,
        platform: "mobile",
        shareType: "direct",
      );

      final data = await _propertyShareService.addPropertyShare(shareData);

      if (data != null) {
        Get.back();
        Get.to(
          () => ResellerPropertyShareLinkScreen(
            shareId: data.id ?? '',
            shareUrl: data.shareUrl ?? '',
            propertyId: propertyId,
            resellerId: resellerId,
          ),
        );

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: "Interest Form Created Successfully!",
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Form created, but failed to generate share link.",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      debugPrint("⚠️ Error During Form Creation: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong while creating the form.",
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // 🔗 CREATE PROPERTY SHARE
  // ============================================================
  // Future<void> createPropertyShare({
  //   required String propertyId,
  //   required String resellerId,
  //   required String platform,
  //   required String shareType,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     Get.snackbar("Sharing", "Creating property share for $platform...");
  //
  //     // Step 1: Fetch existing shares
  //     final existingShares = await _propertyShareService
  //         .getPropertyShareByPropertyAndReseller(
  //           propertyId: propertyId,
  //           resellerId: resellerId,
  //         );
  //
  //     propertyShareItems
  //       ..clear()
  //       ..addAll(existingShares ?? []);
  //
  //     debugPrint("📦 Loaded existing shares: ${propertyShareItems.length}");
  //
  //     // Step 2: Get interest form id (if exists)
  //     final String? interestFormId =
  //         propertyShareItems.isNotEmpty
  //             ? propertyShareItems.first.interestFormId
  //             : null;
  //
  //     // Step 3: Create new share
  //     final shareData = PropertyShareModel(
  //       propertyId: propertyId,
  //       resellerId: resellerId,
  //       interestFormId: interestFormId,
  //       platform: platform,
  //       shareType: shareType,
  //     );
  //
  //     final shareLink = await _propertyShareService.addPropertyShare(shareData);
  //
  //     if (shareLink != null && shareLink.isNotEmpty) {
  //       // final uri = Uri.parse(shareLink);
  //       // await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       handleShare(platform: platform, shareType: shareType, link: shareType);
  //     } else {
  //       Get.snackbar("Error", "Failed to generate share link.");
  //     }
  //   } catch (e) {
  //     debugPrint("⚠️ Error During Property Share Creation: $e");
  //     Get.snackbar("Error", "Something went wrong while creating share link.");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> createPropertyShare({
    required String propertyId,
    required String resellerId,
    required String platform,
    required String shareType,
  }) async {
    try {
      isLoading.value = true;

      // 🔹 Step 1: Fetch existing shares for this reseller + property
      final existingShares = await _propertyShareService
          .getPropertyShareByPropertyAndReseller(
            propertyId: propertyId,
            resellerId: resellerId,
          );

      propertyShareItems
        ..clear()
        ..addAll(existingShares ?? []);

      // 🔹 Step 2: Check if share already exists for same platform & shareType
      final alreadyExists = propertyShareItems.any(
        (share) =>
            share.platform?.toLowerCase() == platform.toLowerCase() &&
            share.shareType?.toLowerCase() == shareType.toLowerCase(),
      );

      if (alreadyExists) {
        print("Share already exists for $platform and $shareType");
        final exist = propertyShareItems.firstWhereOrNull(
          (share) =>
              share.platform?.toLowerCase() == platform.toLowerCase() &&
              share.shareType?.toLowerCase() == shareType.toLowerCase(),
        );

        print("exist: ${exist?.toJson()}");
        handleShare(
          platform: platform,
          shareType: shareType,
          link: exist?.shareUrl ?? '',
        );
      } else {
        // 🔹 Step 3: Use existing interestFormId if available
        final String? interestFormId =
            propertyShareItems.isNotEmpty
                ? propertyShareItems.first.interestFormId
                : null;

        // 🔹 Step 4: Prepare new share data
        final PropertyShareModel shareData = PropertyShareModel(
          propertyId: propertyId,
          resellerId: resellerId,
          interestFormId: interestFormId,
          platform: platform,
          shareType: shareType,
        );

        // 🔹 Step 5: Create new property share
        final data = await _propertyShareService.addPropertyShare(shareData);

        if (data != null) {
          debugPrint("✅ Property share created successfully: $data");

          // 🔹 Step 6: Add to local list & handle share action
          propertyShareItems.add(shareData);
          handleShare(
            platform: platform,
            shareType: shareType,
            link: data.shareUrl ?? '',
          );

          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: "Property shared on $platform successfully!",
            contentType: ContentType.success,
          );
        } else {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Error',
            message: "Failed to create property share. Please try again.",
            contentType: ContentType.failure,
          );
        }
      }
    } catch (e, stack) {
      debugPrint("❌ Error During Property Share Creation: $e");
      debugPrint(stack.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMultiPropertyShare(List<String> propertyIds) async {
    try {
      isLoading.value = true;
      final user = await SecureStorage.getUserData();
      final resellerId = user?.user?.id ?? '';

      final multiShareData = CreateMultiShareRequest(
        resellerId: resellerId,
        propertyIds: propertyIds,
        formFields: customFields,
      );

      final data = await _propertyShareService.addMultiPropertyShare(
        multiShareData,
      );

      if (data != null) {
        Get.back();
        Get.to(
          () => ResellerPropertyShareLinkScreen(
            shareId: data.id,
            isMultiShare: true,
            shareUrl: data.url,
          ),
        );
      }
    } catch (e) {
      print("Error During Multi Property Share Creation: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // 🔍 HANDLE SHARE BUTTON CLICK
  // ============================================================
  Future<void> handleShareButtonTap({
    required String propertyId,
    required String resellerId,
  }) async {
    try {
      isLoading.value = true;

      final existingShares = await _propertyShareService
          .getPropertyShareByPropertyAndReseller(
            propertyId: propertyId,
            resellerId: resellerId,
          );

      // print("existingShares: ${existingShares?.first.toJson()}");

      if (existingShares != null && existingShares.isNotEmpty) {
        final existingLink = existingShares.first.shareUrl;
        if (existingLink != null && existingLink.isNotEmpty) {
          debugPrint("🔁 Existing share found: $existingLink");
          Get.to(
            () => ResellerPropertyShareLinkScreen(
              shareId: existingShares.first.id ?? '',
              shareUrl: existingLink,
              propertyId: propertyId,
              resellerId: resellerId,
            ),
          );
          return;
        }
      } else {
        print("No existing shares found for this property/reseller");
        Get.to(() => ReSellerPropertyShare(propertyId: [propertyId]));
      }

      // debugPrint("🆕 No existing share found. Creating new one...");
      // await createPropertyShare(
      //   propertyId: propertyId,
      //   resellerId: resellerId,
      //   platform: "whatsapp",
      //   shareType: "chat",
      // );
    } catch (e) {
      debugPrint("⚠️ Error handling property share: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong while sharing property.",
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePropertyShare(String id) async {
    try {
      isLoading.value = true;
      final success = await _propertyShareService.deletePropertyShare(id);
      if (success) {
        propertyShareItems.removeWhere((share) => share.id == id);
        Get.back();
      }
    } catch (e) {
      print("Error Deleting Property Share: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMultiPropertyShare() async {
    try {
      isLoading.value = true;
      final data = await _propertyShareService.getMultiPropertyShare();
      if (data != null && data.isNotEmpty) {
        multiShareItems.clear();
        multiShareItems.addAll(data);
      }
    } catch (e) {
      print("Error Getting Multi Property Share: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // 🧩 STATE HELPERS
  // ============================================================
  void addPropertyShare(PropertyShareModel form) =>
      propertyShareItems.add(form);

  void removePropertyShare(PropertyShareModel form) =>
      propertyShareItems.remove(form);

  void clearPropertyShare() => propertyShareItems.clear();

  void addField(CustomFormField field) => customFields.add(field);

  void removeField(CustomFormField field) => customFields.remove(field);

  void showAddCustomFieldDialog(BuildContext context) {
    final labelController = TextEditingController();
    final nameController = TextEditingController();
    final placeHolderController = TextEditingController();
    String selectedType = 'Text';
    bool isRequired = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text(
                    'Add Custom Field',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NesticoPeTextField(
                            controller: nameController,
                            isRequired: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Enter Name',
                            title: 'Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          NesticoPeTextField(
                            controller: labelController,
                            isRequired: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Enter Label',
                            title: 'Label',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a label';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          NesticoPeDropdownField<String>(
                            title: "Type",
                            value: selectedType,
                            items:
                                ['Text', 'Email', 'Phone', 'Number', 'Date']
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setDialogState(() => selectedType = value!);
                            },
                          ),
                          const SizedBox(height: 12),
                          NesticoPeTextField(
                            controller: placeHolderController,
                            isRequired: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            hintText: 'Enter Placeholder',
                            title: 'PlaceHolder',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a placeholder';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text("Required"),
                              const Spacer(),
                              Switch(
                                value: isRequired,
                                onChanged: (value) {
                                  setDialogState(() => isRequired = value);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (labelController.text.isEmpty) {
                          _formKey.currentState!.validate();
                          return;
                        }
                        addField(
                          CustomFormField(
                            id:
                                "form_custom_${DateTime.now().millisecondsSinceEpoch.toString()}",
                            label: labelController.text.trim(),
                            type: selectedType,
                            required: isRequired,
                            name: nameController.text.trim(),
                            placeHolder: placeHolderController.text.trim(),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
          ),
    );
  }

  void handleShare({
    required String platform,
    required String shareType,
    required String link,
  }) {
    switch (platform.toLowerCase()) {
      case 'whatsapp':
        if (shareType == 'success') {
          ContactHelper.openPublicWhatsApp(message: link, shareToStatus: true);
        } else {
          ContactHelper.openPublicWhatsApp(message: link);
        }
        break;

      // case 'instagram':
      //   if (shareType == 'success') {
      //     ContactHelper.shareToInstagramStory(link);
      //   } else {
      //     ContactHelper.shareToInstagramFeed(link);
      //   }
      //   break;

      case 'facebook':
        if (shareType == 'success') {
          ContactHelper.shareToFacebookStory(link);
        } else {
          ContactHelper.shareToFacebookFeed(link, caption: "Check this out!");
        }
        break;

      //
      // case 'linkedin':
      //   _onLinkedInShareTap();
      //   break;
      //
      case 'email':
        ContactHelper.sendEmailWithOutReceiver(body: link);
        break;

      case 'general':
        ContactHelper.shareContent(link: link, text: link);
        break;

      default:
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Unsupported share platform: $platform",
          contentType: ContentType.failure,
        );
    }
  }
}
