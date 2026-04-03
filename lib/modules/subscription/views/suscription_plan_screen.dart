import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/sign_up_subscription_card.dart';
import 'package:nesticope_app/utils/shimmer/common_screen/plan_screen/plan_list_screen_shimmer.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/utils/formater/formater.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import '../../contractor/view/widget/convert_to_contractor.dart';
import '../../reseller/view/property_reseller.dart';
import '../controller/subscription_controller.dart';
import '../controller/user_subscription_controller.dart';
import 'widgets/subscription_plan_widget.dart';
import 'package:get/get.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  final String role;
  final bool isShowCurrentPlan;
  final String origin;
   bool isInquirySubmitted;
  final bool isNotFromBuyerSide;
  final bool showArrow;

  SubscriptionPlansScreen({
    super.key,
    required this.role,
    this.isShowCurrentPlan = false,
    this.origin = 'buyer',
    this.isInquirySubmitted = false,
    this.isNotFromBuyerSide = true,
    this.showArrow = true,
  });

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  // ✅ Declare once as fields — never reassign inside build/Obx
  final RxBool _unlocked = false.obs;

  late SubscriptionPlanController controller;
  CurrentUserPlanController? currentPlanController;

  @override
  void initState() {
    super.initState();

    controller =
        Get.isRegistered<SubscriptionPlanController>(tag: widget.role)
            ? Get.find<SubscriptionPlanController>(tag: widget.role)
            : Get.put(
              SubscriptionPlanController(userRole: widget.role),
              tag: widget.role,
            );

    if (widget.isShowCurrentPlan) {
      currentPlanController =
          Get.isRegistered<CurrentUserPlanController>()
              ? Get.find<CurrentUserPlanController>()
              : Get.put(CurrentUserPlanController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _unlocked.value = widget.isNotFromBuyerSide;
      final data = await SecureStorage.hasSubscriptionInquiryForUser(
        widget.role,
        userId: (await SecureStorage.getClientId()) ?? '',
        role: widget.role,
      );

      if (data == true && mounted) {
        setState(() {
          widget.isInquirySubmitted = true;
        });
      }
    });
  }

  // ✅ Pure computed getters — no side effects, no RxBool creation
  bool get _isBuyerOrGuest => UserHelper.isBuyer || UserHelper.isGuest;

  /// Gate is active when the user is buyer/guest AND hasn't unlocked AND hasn't submitted inquiry
  bool get _showBlurGate => _isBuyerOrGuest && !_unlocked.value;

  /// Show the inline compact CTA banner after unlocking (buyer/guest only)
  bool get _showCompactCta => _isBuyerOrGuest && _unlocked.value;

  @override
  Widget build(BuildContext context) {
    log("SubscriptionPlansScreen - build() ${widget.isNotFromBuyerSide}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:
            (!widget.showArrow)
                ? null
                : IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
        automaticallyImplyLeading: widget.showArrow,

        title: Text(
          "Subscription Plans",
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      ),
      body: Stack(
        children: [
          // ─── Scrollable content ───────────────────────────────────────────
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Current plan section (seller/builder/reseller/contractor only)
                  if (widget.isNotFromBuyerSide) ...[
                    if (currentPlanController != null &&
                        widget.isShowCurrentPlan) ...[
                      Obx(() {
                        if (currentPlanController!.isLoading.value) {
                          return PlanListScreenShimmer(count: 1);
                        }

                        final item =
                            (currentPlanController?.items.isNotEmpty ?? false)
                                ? currentPlanController?.items.firstWhereOrNull(
                                  (element) =>
                                      element.status?.toLowerCase() == 'active',
                                )
                                : null;

                        if (item == null) {
                          return _buildNoSubscriptionState();
                        }

                        final plan = item.plan;
                        final int used =
                            item.usedProperties > 0
                                ? item.usedProperties
                                : item.usedServices;

                        log(
                          "Check which plan was selected ${plan?.toMap()}   ${widget.role}",
                        );

                        final dynamic rawMax =
                            item.metadata?['maxProperties'] ??
                            item.metadata?['maxServices'];

                        final bool isUnlimited =
                            rawMax == null ||
                            rawMax == -1 ||
                            rawMax == "unlimited";

                        final int max =
                            isUnlimited
                                ? 0
                                : (rawMax is String
                                    ? int.tryParse(rawMax) ?? 0
                                    : rawMax);

                        final double percent =
                            isUnlimited || max <= 0
                                ? 0.0
                                : (used / max).clamp(0.0, 1.0);

                        log("Plan Usage $percent | Unlimited: $isUnlimited");

                        return _buildCurrentPlanCard(
                          item: item,
                          plan: plan,
                          used: used,
                          max: max,
                          isUnlimited: isUnlimited,
                          percent: percent,
                        );
                      }),
                    ],
                  ],

                  // ✅ Compact inline CTA banner (shown after gate is unlocked for buyer/guest)
                  if (!widget.isNotFromBuyerSide) ...[
                    Obx(() {
                      final unlocked = _unlocked.value;
              if (!unlocked) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          const SizedBox(height: 8),
                          SignUpSubscriptionScreen(
                            title: _mapRoleToTitle(widget.role),
                            compact: true,
                            onSubmit: (name, email, phone) {
                              _saveInquiryToStorage(name, email, phone);
                              if (UserHelper.isGuest) {
                                onGuestTap();
                              } else {
                                onBuyerTap();
                              }
                            },
                          ),
                        ],
                      );
                    }),
                  ],

                  SubscriptionPlansWidget(controller: controller),
                ],
              ),
            ),
          ),

          // ─── Blur overlay (gate) ──────────────────────────────────────────
          if (!widget.isNotFromBuyerSide && widget.role != 'contractor') ...[
            Obx(() {
              final unlocked = _unlocked.value;
              final showGate = !unlocked;
              if (!showGate) return const SizedBox.shrink();
              return Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(color: Colors.white.withOpacity(0.28)),
                  ),
                ),
              );
            }),
          ],

          // ─── Full sign-up form overlay (gate) ────────────────────────────
          if (!widget.isNotFromBuyerSide && widget.role != 'contractor') ...[
            Obx(() {
              final unlocked = _unlocked.value;
              final showGate = !unlocked;
              if (!showGate) return const SizedBox.shrink();
              return Center(
                child: SignUpSubscriptionScreen(
                  title: _mapRoleToTitle(widget.role),
                  compact: false,
                  showThankYou: widget.isInquirySubmitted,
                  onSubmit: (name, email, phone) async {
                    final planId =
                        controller.items.isNotEmpty
                            ? controller.items.first.id
                            : '';

                    final payload = {
                      "userId":
                          ((await SecureStorage.getClientId())?.isNotEmpty ??
                                  false)
                              ? (await SecureStorage.getClientId())
                              : null,
                      "name": name,
                      "email": email,
                      "phone": phone,
                      "planId": planId,
                      "status": "pending",
                    };
                    final isSuccess = await controller.subscriptionPlanInquiry(
                      payload,
                    );
                    if (isSuccess) {
                      _saveInquiryToStorage(name, email, phone);
                      if (mounted) {
                        setState(() {
                          widget.isInquirySubmitted = true;
                        });
                      }
                    }
                  },
                ),
              );
            }),
          ],

          // ─── Seller/builder/reseller/contractor sign-up overlay ───────────
          if (!widget.isNotFromBuyerSide && widget.role != 'contractor') ...[
            if (widget.isShowCurrentPlan &&
                (UserHelper.isSellerOwner ||
                    UserHelper.isSellerBuilder ||
                    UserHelper.isReseller ||
                    UserHelper.isContractor)) ...[
              Obx(() {
                final hasActive =
                    currentPlanController != null &&
                    currentPlanController!.items.firstWhereOrNull(
                          (e) => (e.status ?? '').toLowerCase() == 'active',
                        ) !=
                        null;

                if (hasActive) {
                  return const SizedBox.shrink();
                }

                return Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            color: Colors.white.withOpacity(0.28),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SignUpSubscriptionScreen(
                        title: _mapRoleToTitle(widget.role),
                        compact: false,
                        showThankYou: widget.isInquirySubmitted,
                        onSubmit: (name, email, phone) async {
                          final planId =
                              controller.items.isNotEmpty
                                  ? controller.items.first.id
                                  : '';
                          final payload = {
                            "userId":
                                ((await SecureStorage.getClientId())
                                            ?.isNotEmpty ??
                                        false)
                                    ? (await SecureStorage.getClientId())
                                    : null,
                            "name": name,
                            "email": email,
                            "phone": phone,
                            "planId": planId,
                            "status": "pending",
                          };
                          final isSuccess = await controller
                              .subscriptionPlanInquiry(payload);
                          if (isSuccess) {
                            _saveInquiryToStorage(name, email, phone);
                            if (mounted) {
                              setState(() {
                                widget.isInquirySubmitted = true;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
            ],
          ],
        ],
      ),
    );
  }

  // ─── Extracted widget to keep build() readable ──────────────────────────

  Widget _buildCurrentPlanCard({
    required dynamic item,
    required dynamic plan,
    required int used,
    required int max,
    required bool isUnlimited,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: ColorRes.primary,
                size: 26,
              ),
              const SizedBox(width: 8),
              const Text(
                "My Plan Details",
                style: TextStyle(
                  color: ColorRes.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: "Currently on "),
                TextSpan(
                  text: plan?.name ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorRes.primary,
                  ),
                ),
                const TextSpan(
                  text: " - View your plan details and usage statistics",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Metrics Grid
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final cards = [
                (
                  'Start Date',
                  Formatter.formatDate(item.startDate.toString()),
                  Icons.timer_outlined,
                  ColorRes.primary,
                ),
                (
                  'Expiry Date',
                  Formatter.formatDate(item.endDate.toString()),
                  Icons.calendar_month_outlined,
                  ColorRes.green,
                ),
                (
                  'Plan Amount',
                  Formatter.formatPrice(
                    double.tryParse(plan?.amount ?? "0") ?? 0,
                  ),
                  Icons.currency_rupee_outlined,
                  ColorRes.orangeColor,
                ),
                (
                  'Subscription Tier',
                  plan?.isPremium == true ? "Premium" : "Basic",
                  Icons.star_rounded,
                  ColorRes.primary,
                ),
              ];
              return _buildMetricCard(
                cards[index].$1,
                cards[index].$2,
                cards[index].$3,
                cards[index].$4,
              );
            },
          ),

          const SizedBox(height: 10),

          const Text(
            "Property Listing Usage",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                isUnlimited ? "$used / ∞" : "$used / $max",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Total Used",
                style: TextStyle(
                  fontWeight: AppFontWeights.medium,
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          if (!isUnlimited) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade200,
              color: ColorRes.primary.withOpacity(0.4),
              minHeight: 6,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 6),
            Text(
              "${(max - used).clamp(0, max)} ${userRole == UserRole.contractor ? 'services' : 'properties'} remaining in your current cycle",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4EF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF8ED1B2), width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2EFE3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: Color(0xFF1AAE84),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Unlimited Property Listings",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Your plan allows for unlimited property listings",
                          style: TextStyle(
                            fontSize: 11,
                            color: ColorRes.leadGreyColor.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String _mapRoleToTitle(String role) {
    switch (role) {
      case 'sellerOwner':
        return 'Become a Seller';
      case 'sellerBuilder':
        return 'Become a Seller';
      case 'reseller':
        return 'Become a Partner';
      case 'contractor':
        return 'Become a Contractor';
      default:
        return '';
    }
  }

  VoidCallback get onBuyerTap {
    switch (widget.role) {
      case 'sellerOwner':
        return () => Get.to(() => SellerConversionScreen());
      case 'sellerBuilder':
        return () => Get.to(() => SellerConversionScreen());
      case 'reseller':
        return () => Get.to(() => ResellerConversionScreen());
      case 'contractor':
        return () => Get.to(() => ConvertToContractorConversionScreen());
      default:
        return () {};
    }
  }

  VoidCallback get onGuestTap {
    switch (widget.role) {
      case 'sellerOwner':
        return () => Get.to(() => RegisterScreen(role: userRole));
      case 'sellerBuilder':
        return () => Get.to(() => RegisterScreen(role: userRole));
      case 'reseller':
        return () => Get.to(() => RegisterScreen(role: userRole));
      case 'contractor':
        return () => Get.to(() => RegisterScreen(role: userRole));
      default:
        return () {};
    }
  }

  UserRole get userRole {
    switch (widget.role) {
      case 'sellerOwner':
        return UserRole.seller;
      case 'sellerBuilder':
        return UserRole.seller;
      case 'reseller':
        return UserRole.reseller;
      case 'contractor':
        return UserRole.contractor;
      default:
        return UserRole.buyer;
    }
  }

  Future<void> _saveInquiryToStorage(
    String name,
    String email,
    String phone,
  ) async {
    final user = await SecureStorage.getUserData();
    final username =
        user?.user?.username ?? (UserHelper.isGuest ? 'guest' : name);
    final userId = user?.user?.id ?? '';
    final payload = {
      'userId': userId,
      'username': username,
      'role': widget.role,
      'name': name,
      'email': email,
      'phone': phone,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await SecureStorage.addSubscriptionInquiry(payload);
  }

  Widget _buildNoSubscriptionState() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorRes.white,
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 60, color: ColorRes.primary),
            const SizedBox(height: 16),
            Text(
              "No Active Subscription",
              style: TextStyle(
                fontSize: 16,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "You don't have an active subscription plan. Please subscribe to start listing properties as builder.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// // list_screen_shimmer.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:nesticope_app/modules/auth/views/register_screen.dart';
// import 'package:nesticope_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
// import 'package:nesticope_app/modules/subscription/views/widgets/sign_up_subscription_card.dart';
// import 'package:nesticope_app/utils/shimmer/common_screen/plan_screen/plan_list_screen_shimmer.dart';

// import '../../../app/constants/color_res.dart';
// import '../../../app/utils/formater/formater.dart';
// import '../../../data/network/auth/model/user_model.dart';
// import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
// import '../../contractor/view/widget/convert_to_contractor.dart';
// import '../../reseller/view/property_reseller.dart';
// import '../controller/subscription_controller.dart';
// import '../controller/user_subscription_controller.dart';
// import 'widgets/subscription_plan_widget.dart';
// import 'package:get/get.dart';

// class SubscriptionPlansScreen extends StatelessWidget {
//   final String role;
//   final bool isShowCurrentPlan;
//   final String origin;
//   final bool showArrow;

//   final bool isNotFromBuyerSide;

//   const SubscriptionPlansScreen({
//     super.key,
//     required this.role,
//     this.isShowCurrentPlan = false,
//     this.showArrow = true,
//     this.isNotFromBuyerSide = true,

//     this.origin = 'buyer',
//   });

//   @override
//   Widget build(BuildContext context) {
//     CurrentUserPlanController? currentPlanController;
//     if (isShowCurrentPlan) {
//       currentPlanController = Get.put(CurrentUserPlanController());
//     }
//     final controller = Get.put(SubscriptionPlanController(userRole: role));

//     return Scaffold(
//       appBar: AppBar(
//         leading:
//             (!showArrow)
//                 ? null
//                 : IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: Icon(Icons.arrow_back),
//                 ),
//                 automaticallyImplyLeading: showArrow,
//         title: const Text("Subscription Plans"),
//         // automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         top: false,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (isNotFromBuyerSide) ...[
//                 if (currentPlanController != null && isShowCurrentPlan) ...[
//                   Obx(() {
//                     if (currentPlanController!.isLoading.value) {
//                       return PlanListScreenShimmer(count: 1);
//                     }

//                     final item =
//                         currentPlanController.items.isNotEmpty
//                             ? currentPlanController.items.firstWhereOrNull(
//                               (element) =>
//                                   element.status?.toLowerCase() == 'active',
//                             )
//                             : null;

//                     if (item == null) {
//                       return _buildNoSubscriptionState();
//                     }

//                     final plan = item.plan;

//                     final int used =
//                         item.usedProperties > 0
//                             ? item.usedProperties
//                             : item.usedServices;

//                     log("Check which plan was selected ${plan?.toMap()}");

//                     /// ===== Unlimited handling =====
//                     final dynamic rawMax =
//                         item.metadata?['maxProperties'] ??
//                         item.metadata?['maxServices'];

//                     final bool isUnlimited =
//                         rawMax == null || rawMax == -1 || rawMax == "unlimited";

//                     final int max =
//                         isUnlimited
//                             ? 0
//                             : (rawMax is String
//                                 ? int.tryParse(rawMax) ?? 0
//                                 : rawMax);

//                     final double percent =
//                         isUnlimited || max <= 0
//                             ? 0.0
//                             : (used / max).clamp(0.0, 1.0);

//                     log("Plan Usage $percent | Unlimited: $isUnlimited");

//                     return Container(
//                       padding: const EdgeInsets.all(16),
//                       margin: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// Header
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.workspace_premium_rounded,
//                                 color: ColorRes.primary,
//                                 size: 26,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "My Plan Details",
//                                 style: TextStyle(
//                                   color: ColorRes.primary,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green.shade50,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: const Text(
//                                   "ACTIVE",
//                                   style: TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 10),

//                           RichText(
//                             text: TextSpan(
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black54,
//                                 height: 1.4,
//                               ),
//                               children: [
//                                 const TextSpan(text: "Currently on "),
//                                 TextSpan(
//                                   text: plan?.name ?? '-',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: ColorRes.primary,
//                                   ),
//                                 ),
//                                 const TextSpan(
//                                   text:
//                                       " - View your plan details and usage statistics",
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           /// Metrics Grid
//                           GridView.builder(
//                             shrinkWrap: true,
//                             padding: EdgeInsets.zero,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   crossAxisSpacing: 10,
//                                   mainAxisSpacing: 10,
//                                   childAspectRatio: 1.6,
//                                 ),
//                             itemCount: 4,
//                             itemBuilder: (context, index) {
//                               final cards = [
//                                 (
//                                   'Start Date',
//                                   Formatter.formatDate(
//                                     item.startDate.toString(),
//                                   ),
//                                   Icons.timer_outlined,
//                                   ColorRes.primary,
//                                 ),
//                                 (
//                                   'Expiry Date',
//                                   Formatter.formatDate(item.endDate.toString()),
//                                   Icons.calendar_month_outlined,
//                                   ColorRes.green,
//                                 ),
//                                 (
//                                   'Plan Amount',
//                                   Formatter.formatPrice(
//                                     double.tryParse(plan?.amount ?? "0") ?? 0,
//                                   ),
//                                   Icons.currency_rupee_outlined,
//                                   ColorRes.orangeColor,
//                                 ),
//                                 (
//                                   'Subscription Tier',
//                                   plan?.isPremium == true ? "Premium" : "Basic",
//                                   Icons.star_rounded,
//                                   ColorRes.primary,
//                                 ),
//                               ];

//                               return _buildMetricCard(
//                                 cards[index].$1,
//                                 cards[index].$2,
//                                 cards[index].$3,
//                                 cards[index].$4,
//                               );
//                             },
//                           ),

//                           const SizedBox(height: 10),

//                           const Text(
//                             "Property Listing Usage",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                               color: Colors.black87,
//                             ),
//                           ),

//                           const SizedBox(height: 8),

//                           /// Usage row
//                           Row(
//                             children: [
//                               Text(
//                                 isUnlimited ? "$used / ∞" : "$used / $max",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 15,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "Total Used",
//                                 style: TextStyle(
//                                   fontWeight: AppFontWeights.medium,
//                                   color: Colors.black54,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           /// Show progress only if limited
//                           if (!isUnlimited) ...[
//                             const SizedBox(height: 12),
//                             LinearProgressIndicator(
//                               value: percent,
//                               backgroundColor: Colors.grey.shade200,
//                               color: ColorRes.primary.withOpacity(0.4),
//                               minHeight: 6,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               "${(max - used).clamp(0, max)} ${(userRole == UserRole.contractor) ? 'services' : 'properties'} remaining in your current cycle",
//                               style: const TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ] else ...[
//                             const SizedBox(height: 12),
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFE6F4EF),
//                                 // light green background
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: const Color(0xFF8ED1B2),
//                                   // soft green border
//                                   width: 1.2,
//                                 ),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFD2EFE3),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: const Icon(
//                                       Icons.apartment_rounded,
//                                       color: Color(0xFF1AAE84),
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Unlimited Property Listings",
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                         SizedBox(height: 6),
//                                         Text(
//                                           "Your plan allows for unlimited property listings",
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             color:
//                                                 ColorRes.leadGreyColor.shade600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     );
//                   }),
//                 ],
//               ],

//               if (UserHelper.isBuyer || UserHelper.isGuest) ...[
//                 SignUpSubscriptionScreen(
//                   title: _mapRoleToTitle(role),
//                   onTap: UserHelper.isGuest ? onGuestTap : onBuyerTap,
//                 ),
//               ],
//               SubscriptionPlansWidget(controller: controller),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNoSubscriptionState() {
//     return Container(
//       margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: ColorRes.white,
//         border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.info_outline, size: 60, color: ColorRes.primary),
//             SizedBox(height: 16),
//             Text(
//               "No Active Subscription",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textColor,
//               ),
//             ),
//             SizedBox(height: 8),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24),
//               child: Text(
//                 "You don't have an active subscription plan. Please subscribe to start listing properties as builder.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 10),
//               ),
//             ),
//             SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Build metric card widget
//   Widget _buildMetricCard(
//     String title,
//     String value,
//     IconData icon,
//     Color iconColor,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: iconColor, size: 20),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 10,
//               color: Colors.black54,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   String _mapRoleToTitle(String role) {
//     switch (role) {
//       case 'sellerOwner':
//         return 'Become a Seller';
//       case 'sellerBuilder':
//         return 'Become a Seller';
//       case 'reseller':
//         return 'Become a Partner';
//       case 'contractor':
//         return 'Become a Contractor';
//       default:
//         return '';
//     }
//   }

//   VoidCallback get onBuyerTap {
//     switch (role) {
//       case 'sellerOwner':
//         return () => Get.to(() => SellerConversionScreen());
//       case 'sellerBuilder':
//         return () => Get.to(() => SellerConversionScreen());
//       case 'reseller':
//         return () => Get.to(() => ResellerConversionScreen());
//       case 'contractor':
//         return () => Get.to(() => ConvertToContractorConversionScreen());
//       default:
//         return () {};
//     }
//   }

//   VoidCallback get onGuestTap {
//     switch (role) {
//       case 'sellerOwner':
//         return () => Get.to(() => RegisterScreen(role: userRole));
//       case 'sellerBuilder':
//         return () => Get.to(() => RegisterScreen(role: userRole));
//       case 'reseller':
//         return () => Get.to(() => RegisterScreen(role: userRole));
//       case 'contractor':
//         return () => Get.to(() => RegisterScreen(role: userRole));
//       default:
//         return () {};
//     }
//   }

//   UserRole get userRole {
//     switch (role) {
//       case 'sellerOwner':
//         return UserRole.seller;
//       case 'sellerBuilder':
//         return UserRole.seller;
//       case 'reseller':
//         return UserRole.reseller;
//       case 'contractor':
//         return UserRole.contractor;
//       default:
//         return UserRole.buyer;
//     }
//   }
// }
