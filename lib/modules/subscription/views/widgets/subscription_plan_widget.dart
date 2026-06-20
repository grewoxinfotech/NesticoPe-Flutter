// import 'dart:developer';
//
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/font_res.dart';
// import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:nesticope_app/app/widgets/snackbar/snackbar.dart';
//
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
// import '../../../../data/database/secure_storage_service.dart';
// import '../../../../data/network/subscription/model/subscription_model.dart';
// import '../../../../utils/shimmer/common_screen/plan_screen/plan_list_screen_shimmer.dart';
// import '../../../../widgets/New folder/inputs/text_field.dart';
// import '../../../../widgets/display/ic.dart';
// import '../../../../widgets/messages/snack_bar.dart';
// import '../../controller/subscription_controller.dart';
//
// class SubscriptionPlansWidget extends StatelessWidget {
//   final SubscriptionPlanController controller;
//
//   /// Selected index stored in GetX (so it works anywhere)
//   final RxInt selectedPlanIndex = (-1).obs;
//
//   SubscriptionPlansWidget({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value && controller.items.isEmpty) {
//         return PlanListScreenShimmer();
//       }
//
//       final plans = controller.items;
//
//       return ListView.separated(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: plans.length,
//         padding: const EdgeInsets.all(12),
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (_, index) {
//           return SizedBox(
//             height: 300,
//             child: _buildPlanCard(plans[index], index),
//           );
//         },
//       );
//     });
//   }
//
//   // ------------------------------------------------------
//   // CARD UI
//   // ------------------------------------------------------
//   Widget _buildPlanCard(SubscriptionPlan plan, int index) {
//     return Obx(() {
//       final bool isSelected = selectedPlanIndex.value == index;
//
//       log("Plan Selected : ${selectedPlanIndex.value == index}");
//
//       return GestureDetector(
//         onTap: () async {
//           selectedPlanIndex.value = index;
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: ColorRes.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color:
//                   isSelected
//                       ? ColorRes.primary
//                       : ColorRes.leadGreyColor.withOpacity(0.2),
//               width: isSelected ? 2 : 1,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(plan),
//               if (plan.plansFor != "sellerBuilder") ...[
//                 _buildPriceSection(plan),
//               ],
//               const SizedBox(height: 8),
//               _buildFeaturePreview(plan),
//               _buildShowMore(plan, index),
//               _buildSelectButton(plan, isSelected, index),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   // ------------------------------------------------------
//   // Header
//   // ------------------------------------------------------
//   Widget _buildHeader(SubscriptionPlan plan) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 plan.name,
//                 style: TextStyle(
//                   fontSize: AppFontSizes.large,
//                   fontWeight: AppFontWeights.bold,
//                   color: ColorRes.primary,
//                 ),
//               ),
//               if (plan.isPremium) ...[
//                 const SizedBox(width: 4),
//                 NesticoPeIc(
//                   iconPath: "assets/icons/gemini.svg",
//                   height: 14,
//                   width: 14,
//                 ),
//               ],
//               const Spacer(),
//               if (plan.isPremium) _buildPopularBadge(plan),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Popular Badge
//   Widget _buildPopularBadge(SubscriptionPlan plan) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: ColorRes.primary,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: const Text(
//         'Premium',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: AppFontSizes.extraSmall,
//           fontWeight: AppFontWeights.extraBold,
//         ),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------
//   // Price
//   // ------------------------------------------------------
//   Widget _buildPriceSection(SubscriptionPlan plan) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 plan.amount,
//                 style: TextStyle(
//                   fontSize: AppFontSizes.heading,
//                   fontWeight: AppFontWeights.bold,
//                   color: ColorRes.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             "${plan.durationMonths} Month",
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ------------------------------------------------------
//   // Feature preview (first 3)
//   // ------------------------------------------------------
//   Widget _buildFeaturePreview(SubscriptionPlan plan) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children:
//               plan.features
//                   .toFeatureList()
//                   .take(!UserHelper.isSellerBuilder ? 3 : 5)
//                   .map((f) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Row(
//                         children: [
//                           Icon(
//                             f.isIncluded ? Icons.check : Icons.close,
//                             size: 20,
//                             color:
//                                 f.isIncluded
//                                     ? ColorRes.primary
//                                     : ColorRes.error,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               f.name,
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.bodySmall,
//                                 fontWeight: AppFontWeights.medium,
//
//                                 color:
//                                     f.isIncluded
//                                         ? ColorRes.textPrimary
//                                         : ColorRes.leadGreyColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   })
//                   .toList(),
//         ),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------
//   // "Show more"
//   // ------------------------------------------------------
//   Widget _buildShowMore(SubscriptionPlan plan, int index) {
//     return GestureDetector(
//       onTap: () => Get.bottomSheet(_buildPlanExpanded(plan, index)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18),
//         child: Row(
//           children: [
//             Text(
//               "Show more",
//               style: TextStyle(
//                 color: ColorRes.primary,
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//               ),
//             ),
//             Icon(Icons.keyboard_arrow_down, color: ColorRes.primary, size: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------
//   // Select Button
//   // ------------------------------------------------------
//   Widget _buildSelectButton(SubscriptionPlan plan, bool isSelected, int index) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed:
//               isSelected
//                   ? () async {
//                     if (UserHelper.isSellerBuilder) {
//                       log("Plan buy or not ");
//                       selectedPlanIndex.value = index;
//                       try {
//                         final user = await SecureStorage.getUserData();
//
//                         if (user == null) {
//                           NesticoPeSnackBar.showAwesomeSnackbar(
//                             title: 'Error',
//                             message: 'No user data found. Please log in.',
//                             contentType: ContentType.failure,
//                           );
//                           return;
//                         }
//
//                         final fullName = user.user?.fullName ?? '';
//                         final firstName = user.user?.firstName ?? '';
//                         final username = user.user?.username ?? '';
//                         final email = user.user?.email ?? '';
//                         final phone = user.user?.phone ?? '';
//
//                         final displayName =
//                             (firstName.isEmpty ? username : fullName).trim();
//
//                         if (Get.context == null) {
//                           NesticoPeSnackBar.showAwesomeSnackbar(
//                             title: "Error",
//                             message: 'UI not ready to show dialog.',
//                             contentType: ContentType.failure,
//                           );
//                           return;
//                         }
//
//                         addInquiryForPlanBuy(
//                           displayName,
//                           email,
//                           phone,
//                           plan.id,
//                           user.user?.id ?? '',
//                           isPlanInquiry: true,
//                         );
//                       } catch (e, s) {
//                         debugPrint('❌ Error in Get Offer button: $e');
//                         debugPrint('$s');
//
//                         NesticoPeSnackBar.showAwesomeSnackbar(
//                           title: "Error",
//                           message: 'Something went wrong. Please try again.',
//                           contentType: ContentType.failure,
//                         );
//                       }
//                     } else {
//                       final controller = Get.find<SubscriptionPlanController>();
//                       final success = await controller.buySubscriptionPlan(
//                         plan.id,
//                       );
//                       if (success) {
//                         NesticoPeSnackBar.showAwesomeSnackbar(
//                           title: 'Success',
//                           message: "Plan purchased successfully",
//                           contentType: ContentType.success,
//                         );
//                       }
//                     }
//                   }
//                   : () => selectedPlanIndex.value = index,
//           style: ElevatedButton.styleFrom(
//             backgroundColor:
//                 isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade100,
//             foregroundColor: isSelected ? Colors.white : Colors.black,
//             elevation: 0,
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             isSelected ? "Buy Now" : "Select Plan",
//             style: const TextStyle(
//               fontWeight: AppFontWeights.semiBold,
//               fontSize: AppFontSizes.bodySmall,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ------------------------------------------------------
//   // Expanded bottom sheet
//   // ------------------------------------------------------
//   Widget _buildPlanExpanded(SubscriptionPlan plan, int index) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(plan),
//             if (plan.plansFor != "sellerBuilder") ...[_buildPriceSection(plan)],
//             const SizedBox(height: 12),
//
//             // Full feature list
//             ...plan.features.toFeatureList().map((f) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       f.isIncluded ? Icons.check : Icons.close,
//                       size: 20,
//                       color: f.isIncluded ? ColorRes.primary : ColorRes.error,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         f.name,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.bodySmall,
//                           fontWeight: AppFontWeights.medium,
//
//                           color:
//                               f.isIncluded
//                                   ? ColorRes.textPrimary
//                                   : ColorRes.leadGreyColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void addInquiryForPlanBuy(
//   String name,
//   String email,
//   String phone,
//   String plan,
//   String userId, {
//   bool isPlanInquiry = false,
// }) {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final _nameController = TextEditingController(text: name);
//   final _emailController = TextEditingController(text: email);
//   final _phoneController = TextEditingController(text: phone);
//
//   Get.dialog(
//     Dialog(
//       backgroundColor: ColorRes.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         isPlanInquiry
//                             ? "Request Plan Upgrade"
//                             : "Get Offer Price",
//                         style: TextStyle(
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.white,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () => Get.back(),
//                       borderRadius: BorderRadius.circular(50),
//                       child: const Icon(
//                         Icons.close_rounded,
//                         color: ColorRes.white,
//                         size: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Body
//               Flexible(
//                 flex: 1,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       NesticoPeTextField(
//                         controller: _nameController,
//                         title: "Name",
//                         hintText: 'Enter your name',
//                         prefixIcon: Icons.person_outline,
//                         isRequired: true,
//                         validator:
//                             (value) =>
//                                 value == null || value.trim().isEmpty
//                                     ? 'Name is required'
//                                     : null,
//                       ),
//                       const SizedBox(height: 16),
//
//                       NesticoPeTextField(
//                         controller: _emailController,
//                         hintText: 'Enter your email',
//                         prefixIcon: Icons.email_outlined,
//                         title: "Email",
//                         keyboardType: TextInputType.emailAddress,
//                         isRequired: true,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Email is required';
//                           }
//                           if (!GetUtils.isEmail(value.trim())) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//
//                       NesticoPeTextField(
//                         controller: _phoneController,
//                         hintText: 'Enter your phone number',
//                         title: "Phone",
//                         prefixIcon: Icons.phone_outlined,
//                         keyboardType: TextInputType.phone,
//                         isRequired: true,
//                         maxLength: 10,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Phone is required';
//                           }
//                           if (!GetUtils.isPhoneNumber(value.trim())) {
//                             return 'Enter a valid phone number';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Footer Buttons
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: ColorRes.white,
//                   border: Border(
//                     top: BorderSide(
//                       color: ColorRes.grey.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Get.back(),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           side: const BorderSide(color: ColorRes.primary),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.medium,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       flex: 2,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             final controller =
//                                 Get.find<SubscriptionPlanController>();
//
//                             // perform your submission logic here
//                             final inquiry = {
//                               "userId": userId,
//                               "planId": plan,
//                               "name": name,
//                               "email": email,
//                               "phone": phone,
//                               "status": "pending",
//                             };
//                             final success = await controller
//                                 .subscriptionPlanInquiry(inquiry);
//
//                             if (success) {
//                               CustomSnackBar.show(
//                                 Get.overlayContext!,
//                                 message: "Inquiry submitted Successfully",
//                                 type: SnackBarType.success,
//                               );
//                               Get.back();
//                             }
//                             // if (success) {
//                             //   NesticoPeSnackBar.showAwesomeSnackbar(
//                             //     title: 'Success',
//                             //     message: "Plan purchased successfully",
//                             //     contentType: ContentType.success,
//                             //   );
//                             // }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorRes.primary,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.send, size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               isPlanInquiry
//                                   ? 'Submit Inquiry'
//                                   : 'Request Offer Price',
//
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.medium,
//                                 fontWeight: AppFontWeights.semiBold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//     barrierDismissible: true,
//   );
// }

import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/platform_review/model/platform_review_model.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/contractor/view/widget/convert_to_contractor.dart';
import 'package:nesticope_app/modules/home/controllers/home_controller/platform_review-controller.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/contractor_all_review_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/subscription/model/subscription_model.dart';
import '../../../../utils/shimmer/common_screen/plan_screen/plan_list_screen_shimmer.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../controller/subscription_controller.dart';

class SubscriptionPlansWidget extends StatelessWidget {
  final SubscriptionPlanController controller;
  final RxString selectedPlanName;
  final Map<String, String> planStatusByPlanId;
 
  final PlatformReviewController reviewController =
      Get.isRegistered<PlatformReviewController>(tag: 'subscription_reviews')
          ? Get.find<PlatformReviewController>(tag: 'subscription_reviews')
          : Get.put(
            PlatformReviewController(
              type: ['contractor'],
              filters: {'status': 'published'},
            ),
            tag: 'subscription_reviews',
          );

  SubscriptionPlansWidget({
    super.key,
    required this.controller,
    required this.selectedPlanName,
    this.planStatusByPlanId = const {},
  }) {
    // Note: fetching reviews is handled in `PlatformReviewController.onInit()`
    // Avoid calling `fetchAllReviews()` here to prevent duplicate requests
    // when this widget is reconstructed frequently.
  }
  @override
  Widget build(BuildContext context) {

    log("planStatusByPlanId: ${planStatusByPlanId}");
    return Obx(() {
      if (controller.isLoading.value && controller.items.isEmpty) {
        return PlanListScreenShimmer();
      }

      final plans =
          controller.items
              .where((plan) => plan.name == selectedPlanName.value)
              .toList();

      if (plans.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            'No plans available for "${selectedPlanName.value}".',
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.leadGreyColor.shade700,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: plans.length,
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final double newPrice = double.tryParse(plans[index].amount) ?? 0;
              final double oldPrice =
                  double.tryParse(plans[index].originalPrice) ?? 0;
              final bool hasDiscount =
                  oldPrice > 0 && newPrice > 0 && oldPrice > newPrice;

              return SizedBox(
                height: hasDiscount ? 396 : 375,
                child: _buildPlanCard(plans[index], index),
              );
            },
          ),
          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: Text(
          //     'Contractor Reviews',
          //     style: TextStyle(
          //       color: ColorRes.textPrimary,
          //       fontSize: AppFontSizes.body,
          //       fontWeight: AppFontWeights.bold,
          //     ),
          //   ),
          // ),
          if (UserHelper.isBuyer || UserHelper.isGuest) ...[
            TitleWithViewAll(
              title: "Contractor Reviews",
              showViewAll: true,
              onViewAll: () {
                Get.to(() => ContractorAllReviewScreen());
              },
              icon: Icons.reviews,
              showIcon: true,

              iconColor: ColorRes.success,
              iconBgColor: ColorRes.success.withOpacity(0.1),
            ),

            const SizedBox(height: 8),
            ReviewsAndTestimonials(reviewController: reviewController),
          ],
          const SizedBox(height: 12),
        ],
      );
    });
  }

  // ------------------------------------------------------
  // CARD UI
  // ------------------------------------------------------
  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    final bool rec = plan.isRecommended == true;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: rec ? 12 : 0),
          decoration: BoxDecoration(
            gradient:
                rec
                    ? LinearGradient(
                      colors: [
                        Color(0xffFFC107), // base
                        Color(0xffFFB300), // dark
                        Color.fromARGB(255, 247, 230, 174), // very light
                        Color(0xffFFE082), // light
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : LinearGradient(
                      colors: [
                        //  brant blue
                        const Color(0xff426DD4), // your base color
                        const Color(0xff2F54C6), // deeper blue for depth
                        const Color(0xff6A8DFF), // lighter bluish highlight
                        const Color(0xff4A7BFF), // vi
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            borderRadius: BorderRadius.circular(20),
            border:
                rec
                    ? Border.all(color: Colors.amber.shade200, width: 1.5)
                    : Border.all(
                      color: ColorRes.primary.withValues(alpha: 0.2),
                    ),
            boxShadow: [
              if (rec)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              if (!rec)
                BoxShadow(
                  color: ColorRes.primary.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: _buildHeader(plan),
              ),
              SizedBox(width: 10),

              /// RIGHT SIDE (Price)
              if (plan.plansFor != "sellerBuilder")
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5),
                  child: _buildPriceSection(plan, rec),
                ),

              const SizedBox(height: 12),
              _buildFeaturePreview(plan, rec),
              _buildShowMore(plan, index, rec),
              Spacer(),
              _buildSelectButton(plan),
            ],
          ),
        ),
        if (rec)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: _buildRecommendedBadge()),
          ),
      ],
    );
  }

  // ------------------------------------------------------
  // Header
  // ------------------------------------------------------
  Widget _buildHeader(SubscriptionPlan plan) {
    final bool rec = plan.isRecommended == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${plan.name}',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: rec ? AppFontSizes.title : AppFontSizes.large,

                fontWeight: AppFontWeights.bold,
                color: rec ? ColorRes.textPrimary : ColorRes.white,
                // fontFamily: FontFamily.,
                fontStyle: FontStyle.italic,
              ),
            ),
            Spacer(),
            if (plan.isPremium)
              Container(
                margin: EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorRes.primary,
                  boxShadow: [
                    BoxShadow(
                      color: ColorRes.primary.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: ColorRes.primary, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Premium',
                  style: TextStyle(
                    color: ColorRes.white,
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.semiBold,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        boxShadow: [
          BoxShadow(
            color: ColorRes.primary.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: ColorRes.primary, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'MOST POPULAR',
        style: TextStyle(
          color: ColorRes.white,
          fontSize: AppFontSizes.small,
          fontWeight: AppFontWeights.semiBold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Price
  // ------------------------------------------------------
  Widget _buildPriceSection(SubscriptionPlan plan, bool rec) {
    final double newPrice = double.tryParse(plan.amount) ?? 0;
    final double oldPrice = double.tryParse(plan.originalPrice) ?? 0;
    final bool hasDiscount =
        oldPrice > 0 && newPrice > 0 && oldPrice > newPrice;

    final int offPercent =
        hasDiscount ? (((oldPrice - newPrice) / oldPrice) * 100).round() : 0;

    final String gstText =
        (plan.gstRate.isNotEmpty && plan.gstRate != '0.00')
            ? "Incl. ${plan.gstRate}% GST"
            : "Taxes may apply";

    final int months = plan.durationMonths;
    final String durationText = months == 1 ? " /month" : " /$months months";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 👈 IMPORTANT
      children: [
        if (hasDiscount) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: rec ? Colors.red.shade100 : ColorRes.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$offPercent% OFF",
                  style: TextStyle(
                    color: !rec ? ColorRes.primary : Colors.red.shade600,
                    fontSize:
                        rec ? AppFontSizes.small : AppFontSizes.extraSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "${plan.originalPrice}",
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  color:
                      rec
                          ? ColorRes.leadGreyColor.shade700
                          : ColorRes.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 4),

        Row(
          children: [
            Text(
              "${Formatter.formatPrice(num.tryParse(plan.amount) ?? 0)}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: rec ? ColorRes.textPrimary : ColorRes.white,
              ),
            ),
            Text(
              durationText,
              style: TextStyle(
                fontSize: 12,
                color:
                    rec
                        ? ColorRes.leadGreyColor.shade700
                        : ColorRes.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        Text(
          gstText,
          style: TextStyle(
            fontSize: 12,
            color:
                rec
                    ? ColorRes.textPrimary
                    : ColorRes.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------
  // Feature preview (first 3)
  // ------------------------------------------------------
  Widget _buildFeaturePreview(SubscriptionPlan plan, bool rec) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        children:
            plan.features.toFeatureList().take(4).map((f) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    /// 🔥 Circle Background Icon (LIKE IMAGE)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            f.isIncluded
                                ? rec
                                    ? ColorRes.black.withValues(alpha: 0.8)
                                    : ColorRes.white.withValues(alpha: 0.2)
                                : ColorRes.leadGreyColor.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        f.isIncluded ? Icons.check : Icons.close,
                        size: 10,
                        color:
                            f.isIncluded ? (ColorRes.white) : ColorRes.primary,
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Text
                    Expanded(
                      child: Text(
                        f.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.medium,
                          color:
                              f.isIncluded
                                  ? rec
                                      ? ColorRes.textPrimary
                                      : ColorRes.white.withValues(alpha: 0.8)
                                  : rec
                                  ? ColorRes.leadGreyColor
                                  : ColorRes.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  // ------------------------------------------------------
  // "Show more"
  // ------------------------------------------------------
  Widget _buildShowMore(SubscriptionPlan plan, int index, bool rec) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(_buildPlanExpanded(plan, index, rec)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            Text(
              "Show more",
              style: TextStyle(
                color: rec ? ColorRes.black : ColorRes.white,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: rec ? ColorRes.black : ColorRes.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Select Button - UPDATED WITH RAZORPAY INTEGRATION
  // ------------------------------------------------------
  Widget _buildSelectButton(SubscriptionPlan plan) {
    debugPrint("Check plan data ${planStatusByPlanId}");
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Obx(() {
          final isProcessing = controller.isProcessingPayment.value;
          final bool rec = plan.isRecommended == true;

          final normalizedStatus =
              (planStatusByPlanId[plan.id] ?? '').trim().toLowerCase();

          final isActivePlan = normalizedStatus == 'active';
          final isExpiredPlan = normalizedStatus == 'expired';
          final showLoader = isProcessing && !isActivePlan;
          final buttonText =
              isActivePlan ? 'Active Plan' : (isExpiredPlan ? 'Renew' : 'Buy Now');
          final Color bg = rec ? ColorRes.black : ColorRes.white;
          final Color fg =
              rec ? Colors.black : Colors.white.withValues(alpha: 0.8);

          return ElevatedButton(
            onPressed:
                (!isProcessing && !isActivePlan)
                    ? () async {
                      if (UserHelper.isGuest) {
                        // Navigator.of(Get.context!).pop();
                        await Get.to(
                          () => RegisterScreen(role: UserRole.contractor),
                        );
                        return;
                      } else if (UserHelper.isBuyer) {
                        // Get.to(() => ManageListingsScreen());
                        await Get.to(
                          () => ConvertToContractorConversionScreen(),
                        );
                        return;
                      } else if (UserHelper.isContractor) {
                        log(
                          "Contractor user - opening Razorpay checkout for plan: ${plan.id}",
                        );
                        await controller.openRazorpayCheckout(plan.id);
                        return;
                      } else if (UserHelper.isSellerBuilder) {
                        // For seller builders, show inquiry dialog
                        log("Seller builder - showing inquiry dialog");
                        try {
                          final user = await SecureStorage.getUserData();

                          if (user == null) {
                            NesticoPeSnackBar.showAwesomeSnackbar(
                              title: 'Error',
                              message: 'No user data found. Please log in.',
                              contentType: ContentType.failure,
                            );
                            return;
                          }

                          final fullName = user.user?.fullName ?? '';
                          final firstName = user.user?.firstName ?? '';
                          final username = user.user?.username ?? '';
                          final email = user.user?.email ?? '';
                          final phone = user.user?.phone ?? '';

                          final displayName =
                              (firstName.isEmpty ? username : fullName).trim();

                          if (Get.context == null) {
                            NesticoPeSnackBar.showAwesomeSnackbar(
                              title: "Error",
                              message: 'UI not ready to show dialog.',
                              contentType: ContentType.failure,
                            );
                            return;
                          }

                          addInquiryForPlanBuy(
                            displayName,
                            email,
                            phone,
                            plan.id,
                            user.user?.id ?? '',
                            isPlanInquiry: true,
                          );
                        } catch (e, s) {
                          debugPrint('❌ Error in Get Offer button: $e');
                          debugPrint('$s');

                          NesticoPeSnackBar.showAwesomeSnackbar(
                            title: "Error",
                            message: 'Something went wrong. Please try again.',
                            contentType: ContentType.failure,
                          );
                        }
                        return;
                      } else {
                        // For other users, open Razorpay checkout
                        log("Opening Razorpay checkout for plan: ${plan.id}");
                        await controller.openRazorpayCheckout(plan.id);
                        return;
                      }
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isActivePlan ? Colors.grey.shade300 : bg,
              foregroundColor: fg,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child:
                showLoader
                    ? SizedBox(
                      height: 20,
                      width: 20,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      buttonText,
                      style: TextStyle(
                        color:
                            isActivePlan
                                ? Colors.grey.shade700
                                : (rec ? ColorRes.white : ColorRes.primary),
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: AppFontSizes.bodySmall,
                      ),
                    ),
          );
        }),
      ),
    );
  }

  // ------------------------------------------------------
  // Expanded bottom sheet
  // ------------------------------------------------------
  Widget _buildPlanExpanded(SubscriptionPlan plan, int index, bool rec) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient:
              rec
                  ? LinearGradient(
                    colors: [
                      Color(0xffFFC107), // base
                      Color(0xffFFB300), // dark
                      Color.fromARGB(255, 247, 230, 174), // very light
                      Color(0xffFFE082), // light
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(
                    colors: [
                      //  brant blue
                      const Color(
                        0xff426DD4,
                      ), // your base color bbvhhebnajin ndjsnojdjnskj
                      const Color(0xff2F54C6), // deeper blue for depth
                      const Color(0xff6A8DFF), // lighter bluish highlight
                      const Color(0xff4A7BFF), // vi
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border:
              rec
                  ? Border.all(color: Colors.amber.shade200, width: 1.5)
                  : Border.all(color: ColorRes.primary.withValues(alpha: 0.2)),
          boxShadow: [
            if (rec)
              BoxShadow(
                color: Colors.amber.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            if (!rec)
              BoxShadow(
                color: ColorRes.primary.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildHeader(plan),
              ),
              SizedBox(width: 10),

              /// RIGHT SIDE (Price)
              if (plan.plansFor != "sellerBuilder")
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _buildPriceSection(plan, rec),
                ),

              const SizedBox(height: 12),

              // Full feature list
              ...plan.features.toFeatureList().map((f) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              f.isIncluded
                                  ? rec
                                      ? ColorRes.black.withValues(alpha: 0.8)
                                      : ColorRes.white.withValues(alpha: 0.2)
                                  : ColorRes.leadGreyColor.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          f.isIncluded ? Icons.check : Icons.close,
                          size: 10,
                          color:
                              f.isIncluded
                                  ? (ColorRes.white)
                                  : ColorRes.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f.name,
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: AppFontWeights.medium,

                            color:
                                f.isIncluded
                                    ? rec
                                        ? ColorRes.textPrimary
                                        : ColorRes.white.withValues(alpha: 0.8)
                                    : rec
                                    ? ColorRes.leadGreyColor
                                    : ColorRes.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewsAndTestimonials extends StatelessWidget {
  final PlatformReviewController reviewController;
  const ReviewsAndTestimonials({super.key, required this.reviewController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reviewController.isLoading.value &&
          reviewController.allReviews.isEmpty) {
        return const SizedBox(
          height: 170,
          child: Center(
            child: CircularProgressIndicator(color: ColorRes.homeGreenFade),
          ),
        );
      }

      if (reviewController.allReviews.isEmpty) {
        return SizedBox(
          height: 170,
          child: Center(
            child: Text(
              'No reviews available',
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor.shade600,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
        );
      }

      return SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: reviewController.allReviews.length,
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder:
              (context, index) =>
                  _buildReviewCard(context, reviewController.allReviews[index]),
        ),
      );
    });
  }

  Widget _buildReviewCard(BuildContext context, ReviewItem review) {
    final rating = review.rating ?? 0.0;
    final isVerified = review.isVerified ?? false;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,

              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with avatar and rating
              Row(
                children: [
                  /// Avatar (placeholder since we don't have reviewer details)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          ColorRes.homeGreenFade.withOpacity(0.08),
                          ColorRes.homeGreenDarkFade.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Color(0xFF2E7D63).withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child:
                        (() {
                          final user = review.reviewer;
                          final profilePic = user?.profilePic?.trim() ?? '';
                          final username = user?.username?.trim() ?? '';
                          final initial =
                              username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : '?';

                          if (profilePic.isNotEmpty) {
                            return ClipOval(
                              child: Image.network(
                                profilePic,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Text(
                                      initial,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.large,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.homeGreenDarkFade,
                                      ),
                                    ),
                              ),
                            );
                          }

                          return Text(
                            initial,
                            style: TextStyle(
                              fontSize: AppFontSizes.large,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.homeGreenDarkFade,
                            ),
                          );
                        })(),
                  ),

                  const SizedBox(width: 12),

                  /// Reviewer ID and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${review.reviewer?.username?.replaceAll("_", " ").capitalize}',
                                      maxLines: 1,

                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.homeBlackFade,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _formatDate(
                                      review.createdAt?.toIso8601String(),
                                    ),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.leadGreyColor.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: ColorRes.homeGreenDarkFade,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: ColorRes.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${review.reviewer?.userType?.replaceAll("_", " ").capitalize}',
                          maxLines: 1,

                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.regular,
                            color: ColorRes.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(5, (starIndex) {
                              if (starIndex < rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else if (starIndex < rating) {
                                return const Icon(
                                  Icons.star_half,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else {
                                return Icon(
                                  Icons.star_outline,
                                  color: ColorRes.leadGreyColor.shade300,
                                  size: 16,
                                );
                              }
                            }),
                            const SizedBox(width: 8),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.homeBlackFade,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (review.title != null && review.title!.isNotEmpty) ...[
                SizedBox(
                  width: 280,
                  child: Text(
                    review.title!,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.homeBlackFade,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: 280,
                child: Text(
                  '"${review.content ?? 'No review content'}"',
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade700,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Recently';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}

// ------------------------------------------------------
// Inquiry Dialog Function (Unchanged)
// ------------------------------------------------------
void addInquiryForPlanBuy(
  String name,
  String email,
  String phone,
  String plan,
  String userId, {
  bool isPlanInquiry = false,
}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: name);
  final _emailController = TextEditingController(text: email);
  final _phoneController = TextEditingController(text: phone);

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isPlanInquiry
                            ? "Request Plan Upgrade"
                            : "Get Offer Price",
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
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

              // Body
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NesticoPeTextField(
                        controller: _nameController,
                        title: "Name",
                        hintText: 'Enter your name',
                        prefixIcon: Icons.person_outline,
                        isRequired: true,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Name is required'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      NesticoPeTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        title: "Email",
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      NesticoPeTextField(
                        controller: _phoneController,
                        hintText: 'Enter your phone number',
                        title: "Phone",
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone is required';
                          }
                          if (!GetUtils.isPhoneNumber(value.trim())) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Footer Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  border: Border(
                    top: BorderSide(
                      color: ColorRes.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: ColorRes.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final controller =
                                Get.find<SubscriptionPlanController>();

                            // perform your submission logic here
                            final inquiry = {
                              "userId": userId,
                              "planId": plan,
                              "name": name,
                              "email": email,
                              "phone": phone,
                              "status": "pending",
                            };
                            final success = await controller
                                .subscriptionPlanInquiry(inquiry);

                            if (success) {
                              // CustomSnackBar.show(
                              //   Get.overlayContext!,
                              //   message: "Inquiry submitted Successfully",
                              //   type: SnackBarType.success,
                              // );
                              NesticoPeSnackBar.showAwesomeSnackbar(
                                title: 'Successfully',
                                message: " Inquiry submitted Successfully",
                                contentType: ContentType.success,
                              );
                              Get.back();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 20),
                            SizedBox(width: 8),
                            Text(
                              isPlanInquiry
                                  ? 'Submit Inquiry'
                                  : 'Request Offer Price',

                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
