import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/platform_review/service/platform_review_service.dart';
import 'package:nesticope_app/modules/seller/module/lead_screen/model/lead_model.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/buyer/model/my_contractor_model.dart';
import '../../../data/network/buyer/service/my_contractor_service.dart';
import '../../../data/network/lead/lead_service.dart';
import '../../../data/network/review/service/review_service.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../review/controllers/review_controller.dart';
import '../../review/views/widget/rating_widget.dart';

class MyContractorController
    extends PaginatedController<ContractorProjectItem> {
  final ReviewController controller = Get.put(ReviewController());
  final ContractorProjectService _service = ContractorProjectService();
  Rxn<GlobalKey> formKey = Rxn<GlobalKey>();
  RxMap<String, String> filters = <String, String>{}.obs;
  var isReasonValid = false.obs;
  final currentUserId = "".obs;
  ReviewUserService _reviewService = ReviewUserService();
  var txtReason = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    txtReason.addListener(() {
      final text = txtReason.text.trim();
      isReasonValid.value = text.length >= 10;
    });
    getCurrentUserid();
    loadInitial();
  }

  Future<void> refreshLead() async {
    try {
      isRefreshing.value = true;
      refreshList();

      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> getCurrentUserid() async {
    final user = await SecureStorage.getUserData();
    currentUserId.value = user?.user?.id ?? '';
  }

  void clearValues() {
    txtReason.clear();
    controller.overallRating.value = 0.0;
  }

  Future<bool> checkReviewDone(String id) async {
    final reponse = await _reviewService.getTheBuyerGiveReview(id);
    return reponse;
  }

  void openAddFollowUpDialog(String name, String contractor, String serviceId) {
    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${'Write a Review'}",
                        style: const TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        clearValues();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(
                        Icons.close_rounded,
                        color: ColorRes.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Form(
                    key: formKey.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name ?? 'N/A',
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodyMedium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                contractor ?? 'Unknown Contractor',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodySmall,
                                  color: Colors.grey.shade700,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => RatingField(
                            title: 'Overall Rating',
                            rating: controller.overallRating.value,
                            isRequired: true,
                            onRatingChanged: (value) {
                              controller.overallRating.value = value;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Type Dropdown
                        NesticoPeTextField(
                          controller: txtReason,

                          title: 'Reason',
                          hintText: 'Enter Reason',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textSecondary,
                          ),
                          prefixIcon: Icons.note_alt_outlined,
                          isRequired: true,
                          maxLines: 3,

                          // ✅ Added validation rule
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Reason is required';
                            } else if (value.trim().length < 10) {
                              return 'Reason must be at least 10 characters long';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                clearValues();
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: ColorRes.primary,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //   ),
                            //   onPressed: () async {
                            //     if (formKey.value?.currentState != null &&
                            //         !(formKey.value?.currentState as FormState).validate()) {
                            //       log("Form is invalid. Please correct the errors.");
                            //       return;
                            //     }
                            //
                            //     Get.back();
                            //     log("Form is valid. Submitting review...");
                            //
                            //     await addReviewForContractorHandler(
                            //
                            //       serviceId: contractor, // Pass contractor ID
                            //       reviewerId: currentUserId.value, // Replace with actual logged-in user ID
                            //     );
                            //   },
                            //
                            //   child: Text('Submit'),
                            // ),
                            Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorRes.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    isReasonValid.value
                                        ? () async {
                                          if (formKey.value?.currentState !=
                                                  null &&
                                              !(formKey.value?.currentState
                                                      as FormState)
                                                  .validate()) {
                                            log(
                                              "Form is invalid. Please correct the errors.",
                                            );
                                            return;
                                          }

                                          Get.back();
                                          log(
                                            "Form is valid. Submitting review...",
                                          );

                                          await addReviewForContractorHandler(
                                            serviceId:
                                                serviceId, // Pass contractor ID
                                            reviewerId:
                                                currentUserId
                                                    .value, // Replace with actual logged-in user ID
                                          );
                                        }
                                        : null, // ✅ Disabled if reason < 10 chars
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> addReviewForContractorHandler({
    required String serviceId,
    required String reviewerId,
  }) async {
    try {
      // 1️⃣ Build the review payload
      final Map<String, dynamic> reviewPayload = {
        "entity_type": "contractor_service",
        "entity_id": serviceId,
        "reviewer_id": reviewerId,
        "rating": controller.overallRating.value,
        "content": txtReason.text.trim(),
        "pros": {},
        "cons": {},
      };

      log("📝 Review Payload: $reviewPayload");

      // 2️⃣ Send the review using the ReviewUserService
      final bool success = await _reviewService.addReviewForContractor(
        reviewPayload,
      );

      // 3️⃣ Handle the response
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: "Review submitted successfully!",
          contentType: ContentType.success,
        );
        refreshList();
        clearValues();
      } else {
        clearValues();
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Failed to submit review. Please try again.",
          contentType: ContentType.failure,
        );
      }
    } catch (e, st) {
      log("❌ Error in addReviewForContractorHandler: $e\n$st");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong while adding review.",
        contentType: ContentType.failure,
      );
    }
  }

  @override
  Future<PaginationResponse<ContractorProjectItem>> fetchItems(int page) async {
    final user = await SecureStorage.getUserData();
    final email = user?.user?.email;
    print('Email $email');
    final response = await _service.fetchContractorProjects(
      page: page,
      filters: filters,
      email: email,
    );
    loadData();
    return response;
  }

  void loadData() {
    log("My Contractor Data ${items.map((element) => element.toJson())}");
  }
}
