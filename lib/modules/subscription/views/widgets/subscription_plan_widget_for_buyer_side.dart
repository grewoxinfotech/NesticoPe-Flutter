import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/subscription/model/subscription_model.dart';
import 'package:nesticope_app/modules/subscription/controller/subscription_controller.dart';
import 'package:nesticope_app/utils/shimmer/common_screen/plan_screen/plan_list_screen_shimmer.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/display/ic.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class SubscriptionPlansCarousel extends StatefulWidget {
  final SubscriptionPlanController controller;
  final double cardWidth;
  final double cardHeight;
  final Duration autoScrollInterval;
  const SubscriptionPlansCarousel({
    super.key,
    required this.controller,
    this.cardWidth = 280,
    this.cardHeight = 300,
    this.autoScrollInterval = const Duration(seconds: 4),
  });
  @override
  State<SubscriptionPlansCarousel> createState() => _SubscriptionPlansCarouselState();
}

class _SubscriptionPlansCarouselState extends State<SubscriptionPlansCarousel> {
  late final PageController _pageController;
  int _index = 0;
  bool _userDragging = false;
  late Timer _timer;
  final RxInt selectedPlanIndex = (-1).obs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollInterval, (_) {
      if (!mounted || _userDragging) return;
      final items = widget.controller.items;
      if (items.isEmpty) return;
      _index = (_index + 1) % items.length;
      _pageController.animateToPage(
        _index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value && widget.controller.items.isEmpty) {
        return PlanListScreenShimmer();
      }
      final plans = widget.controller.items;
      if (plans.isEmpty) return const SizedBox.shrink();
      return SizedBox(
        height: widget.cardHeight,
        child: Listener(
          onPointerDown: (_) => _userDragging = true,
          onPointerUp: (_) => _userDragging = false,
          
          child: PageView.builder(
            controller: _pageController,
            itemCount: plans.length,
             clipBehavior: Clip.none, // ✅
            padEnds: false,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  right: i == plans.length - 1 ? 0 : 12,
                  
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                
                    height: widget.cardHeight,
                    child: _buildPlanCard(plans[i], i),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    return Obx(() {
      log("Plan is Active or Not  ${plan.isActive}");
      final bool isSelected = selectedPlanIndex.value == index;

      log("Plan Selected : ${selectedPlanIndex.value == index}");

      return GestureDetector(
        onTap: () async {
          selectedPlanIndex.value = index;
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(16),
            border: isSelected?Border.all(
              color:
                   ColorRes.primary,
                     
              width: 2 
            ,
            ):null,
             boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,

              offset: const Offset(0, 3),
            ),
          ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(plan),
              if (plan.plansFor != "sellerBuilder") ...[
                _buildPriceSection(plan),
              ],
              const SizedBox(height: 8),
              _buildFeaturePreview(plan),
              _buildShowMore(plan, index),
              _buildSelectButton(plan, isSelected, index),
            ],
          ),
        ),
      );
    });
  }

  // ------------------------------------------------------
  // Header
  // ------------------------------------------------------
  Widget _buildHeader(SubscriptionPlan plan) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.primary,
                ),
              ),
              // if (plan.isPremium) ...[
              //   const SizedBox(width: 4),
              //   NesticoPeIc(
              //     iconPath: "assets/icons/gemini.svg",
              //     height: 14,
              //     width: 14,
              //   ),
              // ],
              const Spacer(),
              if (plan.isPremium) _buildPopularBadge(plan),
            ],
          ),
        ],
      ),
    );
  }

  // Popular Badge
  Widget _buildPopularBadge(SubscriptionPlan plan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Premium',
        style: TextStyle(
          color: Colors.white,
          fontSize: AppFontSizes.extraSmall,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Price
  // ------------------------------------------------------
  Widget _buildPriceSection(SubscriptionPlan plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.amount,
                style: TextStyle(
                  fontSize: AppFontSizes.heading,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            "Duration: ${plan.durationMonths} Month",
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // Feature preview (first 3)
  // ------------------------------------------------------
  Widget _buildFeaturePreview(SubscriptionPlan plan) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children:
              plan.features
                  .toFeatureList()
                  .take(3)
                  .map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            f.isIncluded ? Icons.check : Icons.close,
                            size: 16,
                            color:
                                f.isIncluded
                                    ? ColorRes.primary
                                    : ColorRes.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.medium,

                                color:
                                    f.isIncluded
                                        ? ColorRes.textPrimary
                                        : ColorRes.leadGreyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  .toList(),
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // "Show more"
  // ------------------------------------------------------
  Widget _buildShowMore(SubscriptionPlan plan, int index) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(_buildPlanExpanded(plan, index)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            Text(
              "Show more",
              style: TextStyle(
                color: ColorRes.primary,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: ColorRes.primary, size: 16),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Select Button - UPDATED WITH RAZORPAY INTEGRATION
  // ------------------------------------------------------
  Widget _buildSelectButton(SubscriptionPlan plan, bool isSelected, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Obx(() {
          final isProcessing =widget. controller.isProcessingPayment.value;

          return ElevatedButton(
            onPressed:
                (isSelected && !isProcessing)
                    ? () async {
                      if (UserHelper.isSellerBuilder) {
                        // For seller builders, show inquiry dialog
                        log("Seller builder - showing inquiry dialog");
                        selectedPlanIndex.value = index;
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
                      } else {
                        // For other users, open Razorpay checkout
                        log("Opening Razorpay checkout for plan: ${plan.id}");
                        await widget.controller.openRazorpayCheckout(plan.id);
                      }
                    }
                    : () => selectedPlanIndex.value = index,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected
                      ? ColorRes.primary
                      : ColorRes.leadGreyColor.shade100,
              foregroundColor: isSelected ? Colors.white : Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                isProcessing && isSelected
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isSelected ? Colors.white : ColorRes.primary,
                        ),
                      ),
                    )
                    : Text(
                      isSelected
                          ? (UserHelper.isSellerBuilder
                              ? "Get Offer"
                              : "Buy Now")
                          : "Select Plan",
                      style: const TextStyle(
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
  Widget _buildPlanExpanded(SubscriptionPlan plan, int index) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(plan),
              if (plan.plansFor != "sellerBuilder") ...[_buildPriceSection(plan)],
              const SizedBox(height: 12),
      
              // Full feature list
              ...plan.features.toFeatureList().map((f) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        f.isIncluded ? Icons.check : Icons.close,
                        size: 20,
                        color: f.isIncluded ? ColorRes.primary : ColorRes.error,
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
                                    ? ColorRes.textPrimary
                                    : ColorRes.leadGreyColor,
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
