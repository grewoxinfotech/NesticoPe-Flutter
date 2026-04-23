// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/font_res.dart';
// import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/data/network/auth/model/user_model.dart';
// import 'package:nesticope_app/data/network/review/model/review_model.dart';
// import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
// import 'package:nesticope_app/modules/auth/views/login_screen.dart';
// import 'package:nesticope_app/modules/auth/views/register_screen.dart';
// import 'package:nesticope_app/modules/profile/views/seller_profile_detail.dart';
// import 'package:nesticope_app/modules/profile/views/widget/buyer_profile.dart';
// import 'package:nesticope_app/modules/referral/view/referral_dashboard.dart';
// import 'package:nesticope_app/modules/review/views/widget/add_app_review_screen.dart';
// import 'package:nesticope_app/modules/review/views/widget/app_review_card.dart';
// import 'package:nesticope_app/widgets/bar/app_bar/common_bar.dart';
// import 'package:nesticope_app/widgets/button/button.dart';
//
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../app/widgets/expandable_tile/expandable_widget.dart';
// import '../../auth/views/select_account_type_screen.dart';
// import '../../calender/views/calender_screen.dart';
// import '../../profile/views/edit_profile_screen.dart';
// import '../../review/controllers/review_controller.dart';
// import '../../saved_property/views/saved_property_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/font_res.dart';
//
// import '../controllers/buyer_profiledata.dart';
//
//
// class ProfileScreen extends StatelessWidget {
//   final String imageUrl;
//
//   ProfileScreen({super.key, required this.imageUrl});
//
//   // Constants for better maintainability
//   static const double _defaultPadding = 16.0;
//   static const double _cardRadius = 16.0;
//   static const double _profileRadius = 36.0;
//   final profileController = Get.find<BuyerProfileDataController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: _buildAppBar(), //
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(_defaultPadding),
//           child:
//               UserHelper.isGuest
//                   ? Column(
//                     children: [
//                       _buildProfileCard(BuyerProfileDataController(),imageUrl),
//                       SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Get.to(() => LoginScreen());
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorRes.success,
//                           ),
//                           child: Text('Login'),
//                         ),
//                       ),
//
//                       SizedBox(height: 12),
//
//                       Center(
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Don't have an account?",
//                                 style: TextStyle(
//                                   color: ColorRes.leadGreyColor.shade700,
//                                   fontFamily: FontRes.poppins,
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed:
//                                     () => Get.to(
//                                       () =>
//                                           RegisterScreen(role: UserRole.buyer),
//                                     ),
//                                 child: Text(
//                                   'Sign Up here',
//                                   style: TextStyle(
//                                     color: ColorRes.success,
//                                     // fontWeight: FontWeight.bold,
//                                     fontWeight: AppFontWeights.extraBold,
//                                     fontFamily: FontRes.poppins,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                   : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//
//
//                        _buildProfileCard(profileController,imageUrl),
//
//                       const SizedBox(height: 20),
//                       SettingsMenuTile(
//                         icon: Icons.monitor_heart_outlined,
//                         title: "My Activity",
//                         subTitle: "Track your interactions",
//                         onTap: () => Get.to(() => SavedPropertyScreen()),
//                       ),
//                       if (!UserHelper.isGuest) ...[
//                         SettingsMenuTile(
//                           icon: Icons.card_giftcard,
//                           title: "Referral",
//                           subTitle: "Refer And Earn",
//                           onTap: () => Get.to(() => ReferralProgramScreen()),
//                         ),
//                       ],
//
//                       if (UserHelper.isSeller) ...[
//                         Obx(() {
//                           final controller = Get.put(ReviewController());
//
//                           final review = controller.appReview.value;
//
//                           if (review == null) {
//                             // 🔹 No review exists → Show Settings tile
//                             return SettingsMenuTile(
//                               icon: Icons.reviews_outlined,
//                               title: "Reviews and Ratings",
//                               subTitle: "Add your review",
//                               onTap: () {
//                                 Get.dialog(AddAppReviewDialog()).then((_) {
//                                   controller
//                                       .getAppReview(); // refresh after returning
//                                 });
//                               },
//                             );
//                           } else {
//                             // 🔹 Review exists → Show Review section
//                             return _buildReviewSection(review);
//                           }
//                         }),
//                       ],
//
//                       if (!UserHelper.isGuest && !UserHelper.isBuyer) ...[
//                         SettingsMenuTile(
//                           icon: Icons.event_available,
//                           title: "Events",
//                           subTitle: "Upcoming events",
//                           onTap: () => Get.to(() => CalendarScreen()),
//                         ),
//                       ],
//
//                       SettingsMenuTile(
//                         icon: Icons.diamond_outlined,
//                         title: "Zero Brokerage Properties",
//                         subTitle: "Browse properties without brokerage",
//                         onTap: () => _navigateToZeroBrokerage(),
//                       ),
//                       SettingsMenuTile(
//                         icon: Icons.save_outlined,
//                         title: "Saved Search",
//                         subTitle: "Access your saved filters",
//                         onTap: () => _navigateToSavedSearch(),
//                       ),
//                       _buildQuickLinksSection(),
//                       _buildHomeSearchSection(),
//                       _buildResidentialPackagesSection(),
//                       _buildToolsAndAdviceSection(),
//                       SettingsMenuTile(
//                         icon: Icons.art_track_outlined,
//                         title: "Housing News",
//                         subTitle: "Latest property updates",
//                         onTap: () => _navigateToNews(),
//                       ),
//                       SettingsMenuTile(
//                         icon: Icons.home_repair_service_outlined,
//                         title: "Housing Edge Services",
//                         subTitle: "Premium home services",
//                         onTap: () => _navigateToServices(),
//                       ),
//                       SettingsMenuTile(
//                         icon: Icons.star_border_rounded,
//                         title: "Recommended Properties (10)",
//                         subTitle: "Curated for you",
//                         onTap: () => _navigateToRecommended(),
//                       ),
//                       SettingsMenuTile(
//                         icon: Icons.warning_amber_rounded,
//                         title: "Report a fraud",
//                         subTitle: "Stay safe from scams",
//                         onTap: () => _navigateToReportFraud(),
//                       ),
//                       // _buildSettingsSection(),
//                       const SizedBox(height: 20),
//                       _buildHelpCenter(),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: TextButton(
//                           onPressed: () {
//                             Get.lazyPut(() => AuthController());
//                             final controller = Get.find<AuthController>();
//                             controller.logout();
//                           },
//                           child: Text('Logout', style: TextStyle(fontSize: 14)),
//                         ),
//                       ),
//                     ],
//                   ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: ColorRes.white,
//       title: const Text(
//         "My Profile",
//         style: TextStyle(
//           color: ColorRes.black,
//           fontWeight: AppFontWeights.extraBold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileCard(BuyerProfileDataController? profileController,String image) {
//     return Container(
//       padding: const EdgeInsets.all(_defaultPadding),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(_cardRadius),
//         boxShadow: const [
//           BoxShadow(
//             color: ColorRes.blackShade12,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//              _buildProfileAvatar(image??''),
//               const SizedBox(width: 16),
//
//               Expanded(
//                 child: Obx(
//                   () => _ProfileWelcomeSection(
//                     name: profileController?.userProfile.value?.username ?? '',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Divider(color: ColorRes.leadGreyColor.shade200),
//           const SizedBox(height: 4),
//           // 🧭 Visit Profile button
//           GestureDetector(
//             onTap: () {
//               Get.to(() => BuyerProfileScreen());
//             },
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Visit Profile",
//                   style: TextStyle(
//                     fontSize: AppFontSizes.bodySmall,
//                     fontWeight: AppFontWeights.medium,
//                     color: ColorRes.primary, // subtle emphasis
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   size: 14,
//                   color: ColorRes.primary,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileAvatar(String image) {
//     log("djfgdfg $image");
//
//     const double _profileRadius = 35; // adjust or use your variable
//
//     if (image.isNotEmpty) {
//       return CircleAvatar(
//         radius: _profileRadius,
//         backgroundColor: Colors.transparent,
//         child: ClipOval(
//           child: Image.network(
//             image,
//             fit: BoxFit.cover,
//             width: _profileRadius * 2,
//             height: _profileRadius * 2,
//             // 🔹 Show loader while image loads
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Center(
//                 child: SizedBox(
//                   width: 25,
//                   height: 25,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//               );
//             },
//             // 🔹 Fallback on error
//             errorBuilder: (context, error, stackTrace) {
//               return CircleAvatar(
//                 radius: _profileRadius,
//                 backgroundColor: ColorRes.primary,
//                 child: const Icon(
//                   Icons.person,
//                   color: ColorRes.white,
//                   size: 32,
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } else {
//       // 🔹 Default avatar if no image
//       return CircleAvatar(
//         radius: _profileRadius,
//         backgroundColor: ColorRes.primary,
//         child: const Icon(
//           Icons.person,
//           color: ColorRes.white,
//           size: 32,
//         ),
//       );
//     }
//   }
//
//
//   Widget _buildReviewSection(ReviewItem review) {
//     return ExpandableTile(
//       title: "Reviews and Ratings",
//       subtitle: "See your reviews",
//       leadingIcon: Icons.reviews,
//       trailingIcon: Icons.keyboard_arrow_down_rounded,
//       children: [AppReviewCard(review: review)],
//     );
//   }
//
//
//
//   Widget _buildQuickLinksSection() {
//
//     return ExpandableTile(
//       title: 'Quick Links',
//       subtitle: 'Access frequently used features',
//       leadingIcon: Icons.link,
//       trailingIcon: Icons.keyboard_arrow_down_rounded,
//       children: const [
//         SubItems(title: "Smart Deals", icon: Icons.local_offer),
//         SubItems(title: "Sell/Rent", icon: Icons.house),
//         SubItems(title: "Pay Rent", icon: Icons.payment),
//         SubItems(title: "House Protect", icon: Icons.shield, isNew: true),
//       ],
//     );
//   }
//
//   Widget _buildHomeSearchSection() {
//     return ExpandableTile(
//       title: "Home Search",
//       subtitle: "Search for properties",
//       leadingIcon: Icons.search_outlined,
//       trailingIcon: Icons.keyboard_arrow_down_rounded,
//       children: const [
//         SubItems(title: "Buy", icon: Icons.home_work_outlined),
//         SubItems(title: "Sell", icon: Icons.sell_outlined),
//         SubItems(title: "P.G.", icon: Icons.people_outline),
//       ],
//     );
//   }
//
//   Widget _buildResidentialPackagesSection() {
//     return ExpandableTile(
//       title: "Residential Packages",
//       subtitle: "Explore property types",
//       leadingIcon: Icons.home_work_outlined,
//       trailingIcon: Icons.keyboard_arrow_down_rounded,
//       children: const [
//         SubItems(title: "For Developer", icon: Icons.apartment_outlined),
//         SubItems(title: "For Broker", icon: Icons.verified_user_outlined),
//         SubItems(title: "For Buyer", icon: Icons.home_work_outlined),
//       ],
//     );
//   }
//
//   Widget _buildToolsAndAdviceSection() {
//     return ExpandableTile(
//       title: "Tools & Advice",
//       subtitle: 'Property calculators & guides',
//       leadingIcon: Icons.tips_and_updates_outlined,
//       trailingIcon: Icons.keyboard_arrow_down_rounded,
//       children: const [
//         SubItems(title: "EMI Calculator", icon: Icons.calculate_outlined),
//         SubItems(
//           title: "Affordability Calculator",
//           icon: Icons.calculate_outlined,
//         ),
//         SubItems(
//           title: "Eligibility Calculator",
//           icon: Icons.calculate_outlined,
//         ),
//         SubItems(title: "Guide", icon: Icons.help_outline_rounded, isNew: true),
//       ],
//     );
//   }
//
//   Widget _buildHelpCenter() {
//     return Center(
//       child: NesticoPeButton(
//         width: double.infinity,
//         onTap: () {
//           // TODO: Navigate to help center
//         },
//         title: 'Help Center',
//       ),
//     );
//   }
//
//   // Navigation methods - TODO: Implement actual navigation
//   void _navigateToZeroBrokerage() => print("Navigate to Zero Brokerage");
//   void _navigateToSavedSearch() => print("Navigate to Saved Search");
//   void _navigateToNews() => print("Navigate to News");
//   void _navigateToServices() => print("Navigate to Services");
//   void _navigateToRecommended() => print("Navigate to Recommended");
//   void _navigateToReportFraud() => print("Navigate to Report Fraud");
// }
//
// // Separate widget for profile welcome section (better for maintainability)
// class _ProfileWelcomeSection extends StatelessWidget {
//   var name;
//
//   _ProfileWelcomeSection({required this.name});
//
//   @override
//   Widget build(BuildContext context) {
//     log("dhfdfhtghtu $name");
//     // Fetch string values (safe for null)
//     final userType = UserHelper.userTypeString ?? "guest";
//     final sellerType = UserHelper.sellerTypeStringValue;
//
//     // Capitalize first letter for UI
//     String displayRole = userType[0].toUpperCase() + userType.substring(1);
//     String displaySellerType = sellerType != null ? "(${name})" : "";
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Hello 👋 ${name ?? 'Guest'}",
//           style: TextStyle(
//             fontSize: AppFontSizes.medium,
//             fontWeight: AppFontWeights.bold,
//             color: ColorRes.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           "✓ Easy contact with sellers",
//
//           style: TextStyle(
//             color: ColorRes.leadGreyColor,
//             fontSize: AppFontSizes.small,
//           ),
//         ),
//         Text(
//           "✓ Personalized experience",
//           style: TextStyle(
//             color: ColorRes.leadGreyColor,
//             fontSize: AppFontSizes.small,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Data class for settings menu items
// class _SettingsMenuItem {
//   final IconData icon;
//   final String title;
//   final String subTitle;
//   final VoidCallback? onTap;
//
//   const _SettingsMenuItem({
//     required this.icon,
//     required this.title,
//     required this.subTitle,
//     this.onTap,
//   });
// }
//
// /// Optimized Settings Tile with better performance
// class SettingsMenuTile extends StatelessWidget {
//   const SettingsMenuTile({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.subTitle,
//     this.trailing,
//     this.onTap,
//   });
//
//   final IconData icon;
//   final String title, subTitle;
//   final Widget? trailing;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return ListTile(
//       leading: Icon(icon, size: 28, color: ColorRes.primary),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: AppFontSizes.medium,
//           fontWeight: AppFontWeights.semiBold,
//         ),
//       ),
//       subtitle: Text(
//         subTitle,
//         style: TextStyle(
//           fontSize: AppFontSizes.caption,
//           color: ColorRes.leadGreyColor[600],
//         ),
//       ),
//       trailing: trailing ?? const Icon(Icons.chevron_right),
//       onTap: onTap,
//     );
//   }
// }

import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/enum.dart';
import 'package:nesticope_app/app/constants/font_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';
import 'package:nesticope_app/data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import 'package:nesticope_app/data/network/support_ticket/service/ticket_service/support_ticket_service.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/auth/views/delete_account.dart';
import 'package:nesticope_app/modules/auth/views/listing_intro_screen.dart';
import 'package:nesticope_app/modules/auth/views/login_screen.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/profile/views/offers_discounts_screen.dart';
import 'package:nesticope_app/modules/profile/views/seller_profile_detail.dart';
import 'package:nesticope_app/modules/profile/views/widget/buyer_profile.dart';
import 'package:nesticope_app/modules/profile/views/widget/my_contractor_screen.dart';
import 'package:nesticope_app/modules/referral/view/referral_dashboard.dart';
import 'package:nesticope_app/modules/review/views/widget/add_app_review_screen.dart';
import 'package:nesticope_app/modules/review/views/widget/app_review_card.dart';
import 'package:nesticope_app/modules/saved_property/views/user_activity_screen.dart';
import 'package:nesticope_app/modules/subscription/views/my_subscription_screen.dart';
import 'package:nesticope_app/modules/subscription/views/suscription_plan_screen.dart';
import 'package:nesticope_app/widgets/bar/app_bar/common_bar.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/widgets/expandable_tile/expandable_widget.dart';
import '../../auth/views/select_account_type_screen.dart';
import '../../calender/views/calender_screen.dart';
import '../../profile/views/edit_profile_screen.dart';
import '../../review/controllers/review_controller.dart';
import '../../saved_property/views/saved_property_screen.dart';
import '../../in_app_message/view/in_app_message_screen.dart';

// Import additional screens
import '../../auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import '../../contractor/view/widget/convert_to_contractor.dart';
import '../../hire_contractor/view/hire_contractor_screen.dart';
import '../../subscription/views/user_subscription_details.dart';
import '../../support_ticket/views/support_ticket_screen.dart';
import '../../support_ticket/controllers/chat_socket_controller.dart';
import '../../support_ticket/views/instant_support_chat_screen.dart';
import '../../support_ticket/views/support_ticket_chat_screen.dart';
// import '../../data/network/support_ticket/service/ticket_service/support_ticket_service.dart';
// import '../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import '../../dashboard/views/seller_dashboard_screen.dart';
import '../../reseller/view/property_reseller.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
import '../../property/controllers/property_controller.dart';

import '../../visit/screen/visit_screen.dart';
import '../controllers/buyer_profiledata.dart';
import 'login_as_partner_options_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String imageUrl;

  ProfileScreen({super.key, required this.imageUrl});

  static const double _defaultPadding = 16.0;
  static const double _cardRadius = 16.0;
  static const double _profileRadius = 36.0;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.find<BuyerProfileDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ProfileScreen._defaultPadding),
          child:
              UserHelper.isGuest
                  ? Column(
                    children: [
                      _buildProfileCard(BuyerProfileDataController(), widget.imageUrl),
                      const SizedBox(height: 20),

                      // 🎯 Role-Based Action Buttons Section
                      _buildRoleBasedActions(),

                      // const SizedBox(height: 10),
                      // SettingsMenuTile(
                      //   icon: Icons.help_outlined,
                      //   title: "Help & Support",
                      //   subTitle: "Get help and support",
                      //   onTap: () async {
                      //     final uri = Uri.parse(
                      //       'https://nesticope.grewoxinfotech.com/contact',
                      //     );
                      //     await launchUrl(
                      //       uri,
                      //       mode: LaunchMode.externalApplication,
                      //     );
                      //   },
                      // ),
                      // SizedBox(height: 24),
                      // SizedBox.shrink(),
                      // SizedBox(height: 12),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileCard(profileController, widget.imageUrl),
                      const SizedBox(height: 20),

                      // 🎯 Role-Based Action Buttons Section
                      _buildRoleBasedActions(),

                      // Existing Menu Items
                      // const SizedBox(height: 10),
                      // SettingsMenuTile(
                      //   icon: Icons.monitor_heart_outlined,
                      //   title: "My Activity",
                      //   subTitle: "Track your interactions",
                      //   onTap: () => Get.to(() => UserActivityScreen()),
                      // ),
                      // const SizedBox(height: 10),
                      if (!UserHelper.isGuest && !UserHelper.isBuyer) ...[
                        SettingsMenuTile(
                          icon: Icons.workspace_premium,
                          title: "My Subscription",
                          subTitle: "Track your Subscription",
                          onTap: () => Get.to(() => MySubscriptionScreen()),
                        ),
                        const SizedBox(height: 10),
                      ],
                      // SettingsMenuTile(
                      //   icon: Icons.travel_explore,
                      //   title: "Visits",
                      //   subTitle: "Track your Visit",
                      //   onTap: () => Get.to(() => VisitScreen()),
                      // ),
                      // const SizedBox(height: 10),
                      // SettingsMenuTile(
                      //   icon: Icons.notifications_outlined,
                      //   title: "Notifications",
                      //   subTitle: "Notifications and messages",
                      //   onTap: () => Get.to(() => InAppMessageScreen()),
                      // ),
                      // SettingsMenuTile(
                      //   icon: Icons.subscriptions_outlined,
                      //   title: "My Subscription",
                      //   subTitle: "show your all plan",
                      //   onTap: () => Get.to(() => UserSubscriptionDetails()),
                      // ),
                      // const SizedBox(height: 10),
                      // if (!UserHelper.isGuest) ...[
                      // SettingsMenuTile(
                      //   icon: Icons.card_giftcard,
                      //   title: "Referral",
                      //   subTitle: "Refer And Earn",
                      //   onTap:
                      //       () =>
                      //           !UserHelper.isGuest
                      //               ? Get.to(() => ReferralProgramScreen())
                      //               : Get.to(() => LoginScreen()),
                      // ),
                      // const SizedBox(height: 10),

                      // ],
                      _buildActionButton(
                        icon: Icons.local_offer_outlined,
                        label: "Offers & Discounts",
                        subtitle: "View available offers and discounts",
                        onTap: () {
                          Get.to(
                            () => OffersDiscountsScreen(
                              userType: UserHelper.getOfferUserType(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildActionButton(
                        icon: Icons.engineering_outlined,
                        label: "My Contractors",
                        subtitle: "Service contractor",
                        onTap: () => Get.to(() => MyContractorScreen()),
                      ),
                      const SizedBox(height: 10),
                      if (!UserHelper.isGuest) ...[
                        Obx(() {
                          final controller = Get.put(ReviewController());
                          final review = controller.appReview.value;

                          if (review == null) {
                            return SettingsMenuTile(
                              icon: Icons.reviews_outlined,
                              title: "Reviews and Ratings",
                              subTitle: "Add your review",
                              onTap: () {
                                Get.dialog(AddAppReviewDialog()).then((_) {
                                  controller.getAppReview();
                                });
                              },
                            );
                          } else {
                            return _buildReviewSection(review);
                          }
                        }),
                        const SizedBox(height: 10),
                      ],
                      if (!UserHelper.isGuest && !UserHelper.isBuyer) ...[
                        SettingsMenuTile(
                          icon: Icons.event_available,
                          title: "Events",
                          subTitle: "Upcoming events",
                          onTap: () => Get.to(() => CalendarScreen()),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // const SizedBox(height: 10),
                      // SettingsMenuTile(
                      //   icon: Icons.help_outlined,
                      //   title: "Help & Support",
                      //   subTitle: "Get help and support",
                      //   onTap: () async {
                      //     final uri = Uri.parse(
                      //       'https://nesticope.grewoxinfotech.com/contact',
                      //     );
                      //     await launchUrl(
                      //       uri,
                      //       mode: LaunchMode.externalApplication,
                      //     );
                      //   },
                      // ),

                      // SettingsMenuTile(
                      //   icon: Icons.diamond_outlined,
                      //   title: "Zero Brokerage Properties",
                      //   subTitle: "Browse properties without brokerage",
                      //   onTap: () => _navigateToZeroBrokerage(),
                      // ),
                      // SettingsMenuTile(
                      //   icon: Icons.save_outlined,
                      //   title: "Saved Search",
                      //   subTitle: "Access your saved filters",
                      //   onTap: () => _navigateToSavedSearch(),
                      // ),
                      // _buildQuickLinksSection(),
                      // _buildHomeSearchSection(),
                      // _buildResidentialPackagesSection(),
                      // _buildToolsAndAdviceSection(),
                      // SettingsMenuTile(
                      //   icon: Icons.art_track_outlined,
                      //   title: "Housing News",
                      //   subTitle: "Latest property updates",
                      //   onTap: () => _navigateToNews(),
                      // ),
                      // SettingsMenuTile(
                      //   icon: Icons.home_repair_service_outlined,
                      //   title: "Housing Edge Services",
                      //   subTitle: "Premium home services",
                      //   onTap: () => _navigateToServices(),
                      // ),
                      // SettingsMenuTile(
                      //   icon: Icons.star_border_rounded,
                      //   title: "Recommended Properties (10)",
                      //   subTitle: "Curated for you",
                      //   onTap: () => _navigateToRecommended(),
                      // ),
                      // SettingsMenuTile(
                      //   icon: Icons.warning_amber_rounded,
                      //   title: "Report a fraud",
                      //   subTitle: "Stay safe from scams",
                      //   onTap: () => _navigateToReportFraud(),
                      // ),
                      // const SizedBox(height: 20),
                      // _buildHelpCenter(),

                      // SizedBox(
                      //   width: double.infinity,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Get.lazyPut(() => AuthController());
                      //       final controller = Get.find<AuthController>();
                      //       controller.logout();
                      //     },
                      //     child: Text('Logout', style: TextStyle(fontSize: 14)),
                      //   ),
                      // ),
                      SizedBox.shrink(),
                    ],
                  ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: ColorRes.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border(
              top: BorderSide(color: ColorRes.leadGreyColor.shade100, width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
            child:
                UserHelper.isGuest
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                     
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => OtpLoginScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(letterSpacing: 0.5),
                            ),
                          ),
                        ),
                           SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: ColorRes.leadGreyColor.shade700,
                                  fontFamily: FontRes.poppins,
                                  fontSize: 12,fontWeight: FontWeight.w500
                                ),
                              ),
                              TextButton(
                                onPressed:
                                    () => Get.to(
                                      () =>
                                          RegisterScreen(role: UserRole.buyer),
                                    ),
                                child: Text(
                                  'Sign Up here',
                                  style: TextStyle(
                                    color: ColorRes.primary,
                                    fontWeight: AppFontWeights.extraBold,
                                    fontSize: 13,
                                    fontFamily: FontRes.poppins,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: NesticoPeButton(
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(10),
                            titleTextStyle: TextStyle(
                              fontSize: AppFontSizes.medium,
                              color: ColorRes.white,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                            height: 45,
                            onTap: () {
                              Get.lazyPut(() => AuthController());
                              final controller = Get.find<AuthController>();
                              controller.logout();
                            },
                            title: 'Logout',
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDeleteAccountButton(),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  /// 🎯 Role-Based Actions Widget
  Widget _buildRoleBasedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 👤 BUYER ACTIONS
        if (UserHelper.isBuyer || UserHelper.isGuest) ...[
          // SettingsMenuTile(
          //   icon: Icons.person_add_outlined,
          //   title: "Convert to Seller",
          //   subTitle: "Become the seller",
          //   onTap:
          //       () => Get.to(
          //         () => ListingIntroScreen(
          //           role: Roles.sellerOwner.name,
          //           planTitle: "Seller Plans",
          //           config: ListingIntroConfig(
          //             logoAsset: 'assets/images/NesticoPe_logo.png',
          //             appBarBrand: 'NesticoPe',
          //             badgeText: 'New Feature',
          //             headline: 'Sell Your Property',
          //             highlightWord: 'Faster with NesticoPe',
          //             subHeadline:
          //                 'Post your property for FREE and reach thousands of verified buyers directly. No brokers, no hidden fees, only pure success.',
          //             primaryCta: 'Post Property Free',
          //             sellWithTitle: 'Sell With NesticoPe',
          //             sellWithSubtitle:
          //                 'We provide the tools and reach you need to sell your property at the best price.',
          //             manageTitle: 'Already have a listing?',
          //             manageSubtitle:
          //                 'Boost your listing to the top of search results and sell 3x faster.',
          //             manageButtonText: 'Manage Listings',
          //             premiumTitle: 'Premium Listings',
          //             premiumActionText: 'View All',
          //             stepsTitle: 'How It Works?',
          //             viewPlansTitle: 'Find the Perfect Plan for You',
          //             viewPlansSubtitle:
          //                 'Choose from our range of premium plans designed to get your property sold faster with maximum exposure.',
          //             viewPlansButtonText: 'View Plans',
          //             stats: [
          //               StatItemData('Growing', 'Active Buyers'),
          //               StatItemData('Massive', 'Monthly Leads'),
          //               StatItemData('Trusted', 'Top Sellers'),
          //             ],
          //             features: [
          //               FeatureItemData(
          //                 Icons.camera_alt_outlined,
          //                 'Free Listing',
          //                 'List your property for free and reach thousands of buyers without any cost .',
          //               ),
          //               FeatureItemData(
          //                 Icons.visibility_outlined,
          //                 'More Visibility',
          //                 'Get your property in front of thousands of active buyers every day.',
          //               ),
          //               FeatureItemData(
          //                 Icons.support_agent_outlined,
          //                 'NesticoPe Support',
          //                 'Dedicated relationship managers to help you list and sell.',
          //               ),
          //               FeatureItemData(
          //                 Icons.verified_outlined,
          //                 'Serious Enquiries',
          //                 'Build trust with buyers and receive enquiries from verified, serious buyers.',
          //               ),
          //             ],
          //             premiumListings: [
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.home2,
          //                 title: 'Skyline Apartments',
          //                 subtitle: 'Downtown, NYC',
          //                 priceText: '₹45,00,000',
          //               ),
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.project_2,
          //                 title: 'Greenview Residency',
          //                 subtitle: 'Udhna, Surat',
          //                 priceText: '₹1,20,00,000',
          //               ),
          //             ],
          //             steps: [
          //               HowStep(
          //                 'Post Property',
          //                 'Enter basic details and upload high-quality photos in just few minutes.',
          //               ),
          //               HowStep(
          //                 'Get Verified',
          //                 'Our team verifies your listing to build trust with potential buyers.',
          //               ),
          //               HowStep(
          //                 'Receive Inquiries',
          //                 'Buyers will contact you directly via call or message through our platform.',
          //               ),
          //               HowStep(
          //                 'Close the Deal',
          //                 'Negotiate directly and sell your property with zero brokerage fees.',
          //               ),
          //             ],
          //             plansForm: const PlansFormConfig(
          //               pillText: 'Pricing',
          //               title: 'Owner Premium Plans',
          //               subtitle:
          //                   'Get featured, sell 3x faster with priority support',
          //               buttonText: 'Unlock Owner Plans',
          //             ),
          //             finalCallout: const FinalCalloutConfig(
          //               headline: "Still Waiting? Your Buyer Isn’t!",
          //               points: [
          //                 'Quick Fast Posting',
          //                 'Zero Brokerage',
          //                 'Unlimited Visibility',
          //               ],
          //               cta: 'Start Your Free Listing',
          //             ),
          //           ),
          //           onPrimaryCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.seller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerConversionScreen());
          //             } else if (UserHelper.isSellerOwner) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerDashboardScreen());
          //             }
          //           }, // Post Property Free
          //           onManageListings: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.seller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerConversionScreen());
          //             } else if (UserHelper.isSellerOwner) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerDashboardScreen());
          //             }
          //           }, // Manage Listings
          //           onUnlockPlans: () async {
          //             // Get.to(
          //             //   () => SubscriptionPlansScreen(
          //             //     role: Roles.sellerOwner.name,

          //             //     origin: 'buyer',
          //             //     isNotFromBuyerSide: false,
          //             //   ),
          //             // );
          //             final data =
          //                 await SecureStorage.hasSubscriptionInquiryForUser(
          //                   Roles.sellerOwner.name,
          //                   userId: (await SecureStorage.getClientId()) ?? '',
          //                   role: Roles.sellerOwner.name,
          //                 );
          //             debugPrint("Has Subscription Inquiry For : $data");
          //             Get.to(
          //               () => SubscriptionPlansScreen(
          //                 role: Roles.sellerOwner.name,
          //                 isInquirySubmitted: data,
          //                 origin: 'buyer',
          //                 isNotFromBuyerSide: false,
          //               ),
          //             );
          //           }, // Unlock Owner Plans
          //           onFinalCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.seller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerConversionScreen());
          //             } else if (UserHelper.isSellerOwner) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerDashboardScreen());
          //             }
          //           }, // Final CTA
          //         ),
          //       ),
          //   // : Get.to(() => OtpLoginScreen()),
          // ),
          // const SizedBox(height: 10),
          // SettingsMenuTile(
          //   icon: Icons.person_add_outlined,

          //   title: "Convert to Builder",
          //   subTitle: "Become the builder",

          //   onTap:
          //       () =>
          //       // (!UserHelper.isGuest)
          //       //     // ? Get.to(() => SellerConversionScreen())
          //       Get.to(
          //         () => ListingIntroScreen(
          //           role: Roles.sellerBuilder.name,
          //           planTitle: "Builder Plans",
          //           isBulletPoint: true,
          //           config: ListingIntroConfig(
          //             logoAsset: 'assets/images/NesticoPe_logo.png',
          //             appBarBrand: 'NesticoPe',
          //             badgeText: 'New Feature',

          //             headline: 'Showcase Your Projects',
          //             highlightWord: 'with NesticoPe',
          //             subHeadline:
          //                 'Elevate your construction brand and reach thousands of verified property seekers with our specialized developer solutions.',
          //             primaryCta: 'Register as Builder',
          //             sellWithTitle: 'Developer Solutions',
          //             sellWithSubtitle:
          //                 'Designed for large scale projects and high-volume sales management.',
          //             manageTitle: 'Already have projects?',
          //             manageSubtitle:
          //                 'Boost visibility and manage leads from one place.',
          //             manageButtonText: 'Manage Projects',
          //             premiumTitle: 'Featured Projects',
          //             premiumActionText: 'View All',
          //             stepsTitle: 'Sell with NesticoPe',
          //             viewPlansTitle: 'Find the Perfect Plan for You',
          //             viewPlansSubtitle:
          //                 'Choose from premium plans to maximize reach and brand visibility.',
          //             viewPlansButtonText: 'View Plans',
          //             stats: const [
          //               StatItemData('Growing', 'Projects Listed'),
          //               StatItemData('Massive', 'Monthly Leads'),
          //               StatItemData('Trusted', 'Top Developers'),
          //             ],
          //             features: const [
          //               FeatureItemData(
          //                 Icons.photo_library_outlined,
          //                 'Project Showcase',
          //                 'Feature your entire project portfolio with dedicated galleries and virtual tours.',
          //               ),
          //               FeatureItemData(
          //                 Icons.people_outlined,
          //                 'Bulk Lead Generation',
          //                 'Get high-intent corporate and individual leads specifically for your developments.',
          //               ),
          //               FeatureItemData(
          //                 Icons.verified_outlined,
          //                 'Developer Authority',
          //                 'Build brand presence with a premium verified builder profile and RERA badges.',
          //               ),
          //               FeatureItemData(
          //                 Icons.support_agent_outlined,
          //                 'Enterprise Support',
          //                 'Dedicated account managers for seamless project management and updates.',
          //               ),
          //             ],
          //             premiumListings: const [
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.home2,
          //                 title: 'Skyline Apartments',
          //                 subtitle: 'Downtown, NYC',
          //                 priceText: '₹45,00,000',
          //               ),
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.project_2,
          //                 title: 'Greenview Residency',
          //                 subtitle: 'Udhna, Surat',
          //                 priceText: '₹1,20,00,000',
          //               ),
          //             ],
          //             steps: const [
          //               HowStep(
          //                 'Massive Buyer Network',
          //                 'Instant access to over 10,000+ active property seekers.',
          //               ),
          //               HowStep(
          //                 'NesticoPe Premium Support',
          //                 'Get dedicated support for project promotion and strategic marketing to boost your sales.',
          //               ),
          //               HowStep(
          //                 'Advanced CRM Tools',
          //                 'Manage your leads, site visits, and inventory from a single dashboard.',
          //               ),
          //               HowStep(
          //                 'Brand Authority',
          //                 'Get a verified builder profile that builds immediate trust with investors.',
          //               ),
          //             ],
          //             plansForm: const PlansFormConfig(
          //               pillText: 'Pricing',
          //               title: 'Owner Premium Plans',
          //               subtitle:
          //                   'Get featured, sell 3x faster with priority support',
          //               buttonText: 'Unlock Owner Plans',
          //             ),
          //             finalCallout: const FinalCalloutConfig(
          //               headline: "Scale Your Construction Business Today!",
          //               points: [
          //                 'Large Active Builders',
          //                 'Proven Units Sold',
          //                 'Constant Support',
          //               ],
          //               cta: 'Register Now',
          //             ),
          //           ),
          //           onPrimaryCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.seller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerConversionScreen());
          //             } else if (UserHelper.isSellerBuilder) {
          //               Get.to(() => BuilderMainScreen());
          //               // return;
          //             }
          //           }, // Post Property Free
          //           onManageListings: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.seller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerConversionScreen());
          //             } else if (UserHelper.isSellerBuilder) {
          //               Get.to(() => BuilderMainScreen());
          //               // return;
          //             }
          //           }, // Manage Listings
          //           onUnlockPlans: () async {
          //             // Get.to(
          //             //   () => SubscriptionPlansScreen(
          //             //     role: Roles.sellerBuilder.name,

          //             //     isNotFromBuyerSide: false,
          //             //     origin: 'buyer',
          //             //   ),
          //             // );
          //             final data =
          //                 await SecureStorage.hasSubscriptionInquiryForUser(
          //                   Roles.sellerBuilder.name,
          //                   userId: (await SecureStorage.getClientId()) ?? '',
          //                   role: Roles.sellerBuilder.name,
          //                 );
          //             debugPrint("Has Subscription Inquiry For : $data");
          //             Get.to(
          //               () => SubscriptionPlansScreen(
          //                 role: Roles.sellerBuilder.name,
          //                 isInquirySubmitted: data,
          //                 isNotFromBuyerSide: false,
          //                 origin: 'buyer',
          //               ),
          //             );
          //           }, // Unlock Owner Plans
          //           onFinalCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.seller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => SellerConversionScreen());
          //             } else if (UserHelper.isSellerBuilder) {
          //               Get.to(() => BuilderMainScreen());
          //               // return;
          //             }
          //           }, // Final CTA
          //         ),
          //       ),
          //   // : Get.to(() => OtpLoginScreen()),
          // ),
          // const SizedBox(height: 10),

          // SettingsMenuTile(
          //   icon: Icons.group_add_outlined,
          //   title: "Convert to Partner",
          //   subTitle: "Become the Partner",
          //   onTap:
          //       () =>
          //       // (!UserHelper.isGuest)
          //       //     // ? Get.to(() => ResellerConversionScreen())
          //       Get.to(
          //         () => ListingIntroScreen(
          //           role: Roles.reseller.name,
          //           planTitle: "Partner Plans",
          //           isBulletPoint: true,
          //           config: ListingIntroConfig(
          //             logoAsset: 'assets/images/NesticoPe_logo.png',
          //             appBarBrand: 'NesticoPe',
          //             badgeText: 'New Feature',

          //             headline: '''Start Your Real Estate''',
          //             highlightWord: 'Journey With Us',
          //             subHeadline:
          //                 'Unlock endless possibilities in the property market with our advanced platform and verified inventory.',
          //             primaryCta: 'Sign Up as Partner',
          //             sellWithTitle: 'How You Can Earn?',
          //             sellWithSubtitle:
          //                 'Simple 4-step process to start your real estate business with zero investment',
          //             manageTitle: 'Already have a partner account?',
          //             manageSubtitle:
          //                 'Boost visibility and manage leads from one place.',
          //             manageButtonText: 'Manage Account',
          //             premiumTitle: 'Featured Projects',
          //             premiumActionText: 'View All',
          //             stepsTitle: 'Why Become a NesticoPe Partner?',
          //             viewPlansTitle: 'Find the Perfect Plan for You',
          //             viewPlansSubtitle:
          //                 'Choose from premium plans to maximize your partner visibility.',

          //             viewPlansButtonText: 'View Plans',
          //             stats: const [
          //               StatItemData('High', 'Commission Payouts'),
          //               StatItemData('Rapidly Growing', 'Property Sales'),
          //               StatItemData('Expanding', 'Partner Network'),
          //             ],
          //             features: const [
          //               FeatureItemData(
          //                 Icons.person_add_outlined,
          //                 'Register & Join',
          //                 'Create your partner profile and get verified in minutes.',
          //               ),
          //               FeatureItemData(
          //                 Icons.search_off_sharp,
          //                 'Access Inventory',
          //                 'Browse thousands of verified properties and projects.',
          //               ),
          //               FeatureItemData(
          //                 Icons.share_outlined,
          //                 'Share & Connect',
          //                 'Share personalized property links with your potential buyers.',
          //               ),
          //               FeatureItemData(
          //                 Icons.attach_money_outlined,
          //                 'Earn Commission',
          //                 'Receive direct payouts when your clients close a deal.',
          //               ),
          //             ],
          //             premiumListings: const [
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.home2,
          //                 title: 'Skyline Apartments',
          //                 subtitle: 'Downtown, NYC',
          //                 priceText: '₹45,00,000',
          //               ),
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.project_2,
          //                 title: 'Greenview Residency',
          //                 subtitle: 'Udhna, Surat',
          //                 priceText: '₹1,20,00,000',
          //               ),
          //             ],
          //             steps: const [
          //               HowStep(
          //                 'High Commission',
          //                 'Earn up to 2% on every successful deal.',
          //               ),
          //               HowStep(
          //                 'Trusted Network',
          //                 'Partner with verified builders & owners.',
          //               ),
          //               HowStep(
          //                 'Premium Support',
          //                 '24/7 dedicated support team.',
          //               ),
          //               HowStep(
          //                 'Quality Listings',
          //                 'Access to verified property listings.',
          //               ),
          //               HowStep(
          //                 'Gamified Dashboard',
          //                 'Track your earnings and progress seamlessly.',
          //               ),
          //               HowStep(
          //                 'Special Incentives',
          //                 'Earn bonuses and extra rewards for your performance.',
          //               ),
          //             ],
          //             plansForm: const PlansFormConfig(
          //               pillText: 'Pricing',
          //               title: 'Owner Premium Plans',
          //               subtitle:
          //                   'Get featured, sell 3x faster with priority support',
          //               buttonText: 'Unlock Owner Plans',
          //             ),
          //             finalCallout: const FinalCalloutConfig(
          //               headline: "Ready to Scale Your Earning?",
          //               points: [
          //                 'Elite Active Partners',
          //                 'Huge Comm. Paid',
          //                 'Reliable Partner Support',
          //               ],
          //               cta: 'Start Your Journey Now',
          //             ),
          //           ),
          //           onPrimaryCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.reseller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => ResellerConversionScreen());
          //             } else if (UserHelper.isReseller) {
          //               Get.to(() => MainNavigationScreen());
          //             }
          //           }, // Post Property Free
          //           onManageListings: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.reseller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => ResellerConversionScreen());
          //             } else if (UserHelper.isReseller) {
          //               Get.to(() => MainNavigationScreen());
          //             }
          //           }, // Manage Listings
          //           onUnlockPlans: () async {
          //             final data =
          //                 await SecureStorage.hasSubscriptionInquiryForUser(
          //                   Roles.reseller.name,
          //                   userId: (await SecureStorage.getClientId()) ?? '',
          //                   role: Roles.reseller.name,
          //                 );
          //             debugPrint("Has Subscription Inquiry For : $data");
          //             Get.to(
          //               () => SubscriptionPlansScreen(
          //                 isNotFromBuyerSide: false,
          //                 role: Roles.reseller.name,
          //                 isInquirySubmitted: data,
          //                 origin: 'buyer',
          //               ),
          //             );
          //           }, // Unlock Owner Plans
          //           onFinalCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.reseller),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => ResellerConversionScreen());
          //             } else if (UserHelper.isReseller) {
          //               Get.to(() => MainNavigationScreen());
          //             }
          //           }, // Final CTA
          //         ),
          //       ),
          //   // : Get.to(() => OtpLoginScreen()),
          // ),

          // const SizedBox(height: 10),
          SettingsMenuTile(
            icon: Icons.verified_user_outlined,
            title: "Partner with Us",
            subTitle: "Choose your partner role",
            onTap: () => Get.to(() => const LoginAsPartnerOptionsScreen()),
          ),
          // const SizedBox(height: 10),
          // SettingsMenuTile(
          //   icon: Icons.construction_outlined,
          //   title: "Convert to Contractor",
          //   subTitle: "Become the contractor",
          //   onTap:
          //       () =>
          //       // (!UserHelper.isGuest)
          //       // ? Get.to(() => ConvertToContractorConversionScreen())
          //       Get.to(
          //         () => ListingIntroScreen(
          //           role: Roles.contractor.name,
          //           showPropertySection: false,
          //           planTitle: "Contractor Plans",

          //           config: ListingIntroConfig(
          //             contractorStrategyTitle:
          //                 'Skyrocket Your Business as a NesticoPe Contractor',
          //             contractorStrategySubtitle:
          //                 'Strategic steps to scale your construction business with our platform',
          //             contractorStrategySteps: const [
          //               FeatureItemData(
          //                 Icons.search,
          //                 'Identify Local Demand',
          //                 'Use our data insights to find high-demand localities in your expertise.',
          //               ),
          //               FeatureItemData(
          //                 Icons.bar_chart,
          //                 'Optimize Your Profile',
          //                 'Showcase your best projects and gather verified reviews for higher visibility.',
          //               ),
          //               FeatureItemData(
          //                 Icons.rocket_launch,
          //                 'Leverage Technology',
          //                 'Use our advanced management tools to streamline your operations and sales.',
          //               ),
          //             ],
          //             contractorBenefitsTitle:
          //                 'Empowering Your Construction Business',
          //             contractorBenefitsSubtitle:
          //                 'At NesticoPe, we provide a holistic platform for contractors. We offer buyers a complete property solution from initial searching and legal vetting to high-quality construction and interior design. This integrated approach ensures a steady flow of verified projects for our partners, creating a massive opportunity for everyone to scale their business with trust and technology.',
          //             contractorBenefits: const [
          //               FeatureItemData(
          //                 Icons.trending_up,
          //                 'Complete Project Ecosystem',
          //                 'We offer buyers everything—from property search and legal work to construction and interior design. You are part of a full-service journey.',
          //               ),
          //               FeatureItemData(
          //                 Icons.business,
          //                 'Verified High-Intent Leads',
          //                 'Access a steady stream of verified construction and renovation inquiries from buyers already engaged in our property ecosystem.',
          //               ),
          //               FeatureItemData(
          //                 Icons.verified,
          //                 'VBrand Authority',
          //                 'Build a verified professional contractor profile that establishes immediate trust with property owners and large-scale developers.',
          //               ),
          //               FeatureItemData(
          //                 Icons.construction,
          //                 'Advanced Digital Tools',
          //                 'Manage projects, track site visits, and showcase your portfolio with our enterprise-grade contractor dashboard.',
          //               ),
          //               FeatureItemData(
          //                 Icons.location_city,
          //                 'Premium Networking',
          //                 'Connect with top builders and developers for high-value commercial and residential construction opportunities.',
          //               ),
          //               FeatureItemData(
          //                 Icons.handshake,
          //                 'Unmatched Growth Support',
          //                 'Scale your construction business with 24/7 dedicated support and specialized marketing solutions for elite contractors.',
          //               ),
          //             ],
          //             logoAsset: 'assets/images/NesticoPe_logo.png',
          //             appBarBrand: 'NesticoPe',
          //             badgeText: 'New Feature',

          //             headline: 'Build Your Legacy',
          //             highlightWord: 'With NesticoPe',
          //             subHeadline:
          //                 'Grow your business with verified leads and professional tools.',
          //             primaryCta: 'Sign Up as Contractor',
          //             sellWithTitle: 'What NesticoPe Expects from You',
          //             sellWithSubtitle:
          //                 'We maintain the highest standards to ensure quality and trust in our ecosystem.',
          //             manageTitle: 'Already have services?',
          //             manageSubtitle:
          //                 'Boost visibility and manage your services from one place.',
          //             manageButtonText: 'Manage Services',
          //             premiumTitle: 'Featured Contractors',
          //             premiumActionText: 'View All',
          //             stepsTitle: 'How It Works?',
          //             viewPlansTitle: 'Find the Perfect Plan for You',
          //             viewPlansSubtitle:
          //                 'Choose from premium plans to maximize your reach and brand visibility.',
          //             viewPlansButtonText: 'View Plans',
          //             stats: const [
          //               StatItemData('₹100Cr+', 'Projects Completed'),
          //               StatItemData('800+', 'Active Projects'),
          //               StatItemData('300+', 'Verified Contractors'),
          //             ],
          //             features: const [
          //               FeatureItemData(
          //                 Icons.security_outlined,
          //                 'No Spam Policy',
          //                 '''We value our buyers' privacy. Only meaningful interactions are encouraged.''',
          //               ),
          //               FeatureItemData(
          //                 Icons.high_quality_outlined,
          //                 'Quality Over Quantity',
          //                 'We prioritize exceptional craftsmanship over the number of projects handled.',
          //               ),
          //               FeatureItemData(
          //                 Icons.verified_outlined,
          //                 'Verified Professionals Only',
          //                 'Every contractor must pass a thorough verification process for trust.',
          //               ),
          //               // FeatureItemData(
          //               //   Icons.support_agent_outlined,
          //               //   'Direct Support',
          //               //   'Dedicated support for project management and updates.',
          //               // ),
          //             ],
          //             premiumListings: const [
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.home2,
          //                 title: 'Skyline Apartments',
          //                 subtitle: 'Downtown, NYC',
          //                 priceText: '₹45,00,000',
          //               ),
          //               PremiumListingItem(
          //                 imageAsset: IMGRes.project_2,
          //                 title: 'Greenview Residency',
          //                 subtitle: 'Udhna, Surat',
          //                 priceText: '₹1,20,00,000',
          //               ),
          //             ],
          //             steps: const [
          //               HowStep(
          //                 'Register & Profile',
          //                 'Complete your professional registration and get verified.',
          //               ),
          //               HowStep(
          //                 'Add Your Services',
          //                 'List your specialized construction services and expertise.',
          //               ),
          //               HowStep(
          //                 'Get Quality Leads',
          //                 'Receive inquiries from interested clients.',
          //               ),
          //               HowStep(
          //                 'Start Project',
          //                 'Connect with clients and start your construction work.',
          //               ),
          //               HowStep(
          //                 'High Earnings',
          //                 'Grow your business and maximize your revenue with us.',
          //               ),
          //             ],
          //             plansForm: const PlansFormConfig(
          //               pillText: 'Pricing',
          //               title: 'Contractor Premium Plans',
          //               subtitle: 'Get featured and grow your service business',
          //               buttonText: 'Unlock Contractor Plans',
          //             ),
          //             finalCallout: const FinalCalloutConfig(
          //               headline: "Ready to Build Your Legacy?",
          //               points: [
          //                 '300+ Verified Contractors',
          //                 '₹100Cr+ Projects Value',
          //                 '24/7 Expert Support',
          //               ],
          //               cta: 'Start Your Journey Now',
          //             ),
          //           ),
          //           onPrimaryCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.contractor),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => ConvertToContractorConversionScreen());
          //             } else if (UserHelper.isContractor) {
          //               Get.to(() => ContractorMainScreen());
          //             }
          //           }, // Post Property Free
          //           onManageListings: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.contractor),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => ConvertToContractorConversionScreen());
          //             } else if (UserHelper.isContractor) {
          //               Get.to(() => ContractorMainScreen());
          //             }
          //           }, // Manage Listings
          //           onUnlockPlans: () async {
          //             // final data =
          //             //     await SecureStorage.hasSubscriptionInquiryForUser(
          //             //       Roles.contractor.name,
          //             //       userId: (await SecureStorage.getClientId()) ?? '',

          //             //       role: Roles.contractor.name,
          //             //     );
          //             // debugPrint("Has Subscription Inquiry For : $data");
          //             // Get.to(
          //             //   () => SubscriptionPlansScreen(
          //             //     role: Roles.contractor.name,
          //             //     isNotFromBuyerSide: false,

          //             //     origin: 'buyer',
          //             //   ),
          //             // );
          //             final data =
          //                 await SecureStorage.hasSubscriptionInquiryForUser(
          //                   Roles.contractor.name,
          //                   userId: (await SecureStorage.getClientId()) ?? '',
          //                   role: Roles.contractor.name,
          //                 );
          //             debugPrint("Has Subscription Inquiry For : $data");
          //             Get.to(
          //               () => SubscriptionPlansScreen(
          //                 role: Roles.contractor.name,
          //                 isNotFromBuyerSide: true,
          //                 isInquirySubmitted: data,
          //                 origin: 'buyer',
          //               ),
          //             );
          //           }, // Unlock Owner Plans

          //           onFinalCta: () async {
          //             if (UserHelper.isGuest) {
          //               Navigator.of(Get.context!).pop();
          //               await Get.to(
          //                 () => RegisterScreen(role: UserRole.contractor),
          //               );
          //             } else if (UserHelper.isBuyer) {
          //               // Get.to(() => ManageListingsScreen());
          //               Get.to(() => ConvertToContractorConversionScreen());
          //             } else if (UserHelper.isContractor) {
          //               Get.to(() => ContractorMainScreen());
          //             }
          //           }, // Final CTA
          //         ),
          //       ),
          //   // : Get.to(() => OtpLoginScreen()),
          // ),
          const SizedBox(height: 10),
          SettingsMenuTile(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            subTitle: "Notifications and messages",
            onTap:
                () =>
                    (!UserHelper.isGuest)
                        ? Get.to(() => InAppMessageScreen())
                        : Get.to(() => OtpLoginScreen()),
          ),
          const SizedBox(height: 10),
          SettingsMenuTile(
            icon: Icons.monitor_heart_outlined,
            title: "My Activity",
            subTitle: "Track your interactions",
            onTap:
                () =>
                    !UserHelper.isGuest
                        ? Get.to(() => UserActivityScreen())
                        : Get.to(() => OtpLoginScreen()),
          ),
          const SizedBox(height: 10),

          SettingsMenuTile(
            icon: Icons.travel_explore,
            title: "Visits",
            subTitle: "Track your Visit",
            onTap:
                () =>
                    (!UserHelper.isGuest)
                        ? Get.to(() => VisitScreen())
                        : Get.to(() => OtpLoginScreen()),
          ),
          const SizedBox(height: 10),
          // if (!UserHelper.isGuest) ...[
          SettingsMenuTile(
            icon: Icons.card_giftcard,
            title: "Referral",
            subTitle: "Refer And Earn",
            onTap:
                () =>
                    !UserHelper.isGuest
                        ? Get.to(() => ReferralProgramScreen())
                        : Get.to(() => OtpLoginScreen()),
          ),
          const SizedBox(height: 10),

          SettingsMenuTile(
            icon: Icons.engineering_outlined,
            title: "Explore Verified Services",
            subTitle: "View all verified services",
            badgeText: "RECOMMENDED",
            onTap: () => Get.to(() => HireContractorScreen()),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.support_agent_outlined,
            label: "Contact Support",
            subtitle: 'Chat with us',
            onTap: () async {
              Get.put(SocketController());
              try {
                final service = TicketService();
                if (UserHelper.isGuest) {
                  final storedId = await SecureStorage.getSupportTicketId();
                  if (storedId != null && storedId.isNotEmpty) {
                    final t = TicketItem(
                      id: storedId,
                      status: 'open',
                      title: 'Support Ticket',
                    );
                    Get.to(
                      () => SupportTicketChatScreen(ticketId: t.id!, ticket: t),
                    );
                  } else {
                    Get.to(
                      () => const SupportTicketChatScreen(
                        createOnFirstSend: true,
                      ),
                    );
                  }
                } else if (UserHelper.isBuyer) {
                  // Buyer: use API to find existing ticket by created_by; no secure storage
                  final user = await SecureStorage.getUserData();
                  final userId = user?.user?.id ?? '';
                  final resp = await service.fetchTickets(
                    page: 1,
                    filters: {'created_by': userId, 'limit': '100'},
                  );
                  final items = resp.items;
                  log('Fetched tickets: $items');

                  if (items.isNotEmpty &&
                      (items.first.id?.isNotEmpty ?? false)) {
                    final id = items.first.id!;
                    final ticket =
                        await service.fetchTicketById(id) ?? items.first;

                        print(" Ticket item that shgo ${items.map((e) => e.id,)}");
                    Get.to(
                      () =>
                          SupportTicketChatScreen(ticketId: id, ticket: ticket),
                    );
                  } else {
                    // No previous ticket found → create on first send
                    Get.to(
                      () => const SupportTicketChatScreen(
                        createOnFirstSend: true,
                      ),
                    );
                  }
                } else {
                  // Other roles: prefer existing open ticket; fallback to first-message screen
                  final response = await service.fetchTickets(
                    page: 1,
                    filters: {'status': 'open'},
                  );
                  final List<TicketItem> items = response.items;
                  if (items.isNotEmpty &&
                      (items.first.id?.isNotEmpty ?? false)) {
                    final t = items.first;
                    Get.to(
                      () => SupportTicketChatScreen(ticketId: t.id!, ticket: t),
                    );
                  } else {
                    Get.to(() => const InstantSupportChatScreen());
                  }
                }
              } catch (_) {
                Get.to(() => const InstantSupportChatScreen());
              }
            },
          ),

          const SizedBox(height: 10),
        ],

        // 🏠 SELLER ACTIONS
        if (UserHelper.isSellerOwner) ...[
          _buildActionButton(
            icon: Icons.dashboard_outlined,
            label: "Seller Dashboard",
            subtitle: 'Navigate to Seller Panel',
            onTap: () {
              Get.to(
                () => SellerDashboardScreen(),
                binding: BindingsBuilder(() {
                  Get.lazyPut<PropertyController>(() => PropertyController());
                }),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.engineering_outlined,
            subtitle: "Hire top contractors",
            label: "Hire Contractor",
            onTap: () => Get.to(() => HireContractorScreen()),
          ),
          const SizedBox(height: 10),
          // _buildActionButton(
          //   icon: Icons.support_agent_outlined,
          //   label: "Support Ticket",

          //   subtitle: 'Talk to support',
          //   onTap: () {

          //     Get.put(SocketController());
          //     Get.to(() => const InstantSupportChatScreen());
          //   },
          // ),
        ],

        // 🔄 RESELLER ACTIONS
        if (UserHelper.isReseller) ...[
          _buildActionButton(
            icon: Icons.dashboard_outlined,
            label: "Partner Dashboard",
            subtitle: 'Navigate to Partner Panel',
            onTap: () => Get.to(() => MainNavigationScreen()),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.engineering_outlined,
            label: "Hire Contractor",
            subtitle: "Hire top contractors",
            onTap: () => Get.to(() => HireContractorScreen()),
          ),
          const SizedBox(height: 10),
          // _buildActionButton(
          //   icon: Icons.support_agent_outlined,
          //   label: "Support Ticket",
          //   subtitle: 'Talk to support',
          //   onTap: () {
          //     Get.put(SocketController());
          //     Get.to(() => const InstantSupportChatScreen());
          //   },
          // ),
        ],

        // 🏗️ CONTRACTOR ACTIONS
        if (UserHelper.isContractor) ...[
          _buildActionButton(
            icon: Icons.dashboard_outlined,
            label: "Contractor Dashboard",
            subtitle: 'Navigate to Contractor Panel',
            onTap: () => Get.to(() => ContractorMainScreen()),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.engineering_outlined,
            label: "Hire Contractor",
            subtitle: "Hire top contractors",
            onTap: () => Get.to(() => HireContractorScreen()),
          ),
          const SizedBox(height: 10),
          // _buildActionButton(
          //   icon: Icons.support_agent_outlined,
          //   label: "Support Ticket",
          //   subtitle: 'Talk to support',
          //   onTap: () {
          //     Get.put(SocketController());
          //     Get.to(() => const InstantSupportChatScreen());
          //   },
          // ),
        ],

        // 🏢 BUILDER ACTIONS (Seller with Builder type)
        if (UserHelper.isSellerBuilder) ...[
          _buildActionButton(
            icon: Icons.apartment_outlined,
            subtitle: 'Navigate to Builder Panel',
            label: "Builder Dashboard",

            onTap: () => Get.to(() => BuilderMainScreen()),
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            icon: Icons.engineering_outlined,
            label: "Hire Contractor",
            subtitle: "Hire top contractors",
            onTap: () => Get.to(() => HireContractorScreen()),
          ),
          const SizedBox(height: 10),
          // _buildActionButton(
          //   icon: Icons.support_agent_outlined,
          //   label: "Support Ticket",
          //   subtitle: 'Talk to support',
          //   onTap: () {
          //     Get.put(SocketController());
          //     Get.to(() => const InstantSupportChatScreen());
          //   },
          // ),
        ],
      ],
    );
  }

  /// Action Button Widget
  // Widget _buildActionButton({
  //   required IconData icon,
  //   required String label,
  //   required String subtitle,
  //   required VoidCallback onTap,
  //   Widget? trailing,
  // }) {
  //   return ListTile(
  //     leading: Icon(icon, size: 28, color: ColorRes.primary),
  //     title: Text(
  //       label,
  //       style: TextStyle(
  //         fontSize: AppFontSizes.medium,
  //         fontWeight: AppFontWeights.semiBold,
  //       ),
  //     ),
  //     subtitle: Text(
  //       subtitle,
  //       style: TextStyle(
  //         fontSize: AppFontSizes.caption,
  //         color: ColorRes.leadGreyColor[600],
  //       ),
  //     ),
  //     trailing: trailing ?? const Icon(Icons.chevron_right),
  //     onTap: onTap,
  //   );
  // }
  Widget _buildDeleteAccountButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const RequestDeleteAccount(),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            /// ✅ Icon Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 24, color: ColorRes.primary),
            ),

            const SizedBox(width: 14),

            /// ✅ Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.leadGreyColor[600],
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),

            /// ✅ Arrow
            trailing ??
                Icon(Icons.chevron_right, color: ColorRes.leadGreyColor[400]),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFF5F6FA),
      title: const Text(
        "My Profile",
        style: TextStyle(
          color: ColorRes.black,
          fontWeight: AppFontWeights.extraBold,
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuyerProfileDataController? profileController,
    String image,
  ) {
    return Container(
      padding: const EdgeInsets.all(ProfileScreen._defaultPadding),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildProfileAvatar(image ?? ''),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => _ProfileWelcomeSection(
                    name: profileController?.userProfile.value?.username ?? '',
                  ),
                ),
              ),
            ],
          ),
          Divider(color: ColorRes.leadGreyColor.shade200),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              Get.to(() => BuyerProfileScreen());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Visit Profile",
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: ColorRes.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String image) {
    const double _profileRadius = 35;

    if (image.isNotEmpty) {
      return CircleAvatar(
        radius: _profileRadius,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            image,
            fit: BoxFit.cover,
            width: _profileRadius * 2,
            height: _profileRadius * 2,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorRes.primary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                radius: _profileRadius,
                backgroundColor: ColorRes.primary,
                child: const Icon(
                  Icons.person,
                  color: ColorRes.white,
                  size: 32,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: _profileRadius,
        backgroundColor: ColorRes.primary,
        child: const Icon(Icons.person, color: ColorRes.white, size: 32),
      );
    }
  }

  Widget _buildReviewSection(ReviewItem review) {
    return ExpandableTile(
      title: "Reviews and Ratings",
      subtitle: "See your reviews",
      leadingIcon: Icons.reviews,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      children: [AppReviewCard(review: review)],
    );
  }

  Widget _buildQuickLinksSection() {
    return ExpandableTile(
      title: 'Quick Links',
      subtitle: 'Access frequently used features',
      leadingIcon: Icons.link,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      children: const [
        SubItems(title: "Smart Deals", icon: Icons.local_offer),
        SubItems(title: "Sell/Rent", icon: Icons.house),
        SubItems(title: "Pay Rent", icon: Icons.payment),
        SubItems(title: "House Protect", icon: Icons.shield, isNew: true),
      ],
    );
  }

  Widget _buildHomeSearchSection() {
    return ExpandableTile(
      title: "Home Search",
      subtitle: "Search for properties",
      leadingIcon: Icons.search_outlined,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      children: const [
        SubItems(title: "Buy", icon: Icons.home_work_outlined),
        SubItems(title: "Sell", icon: Icons.sell_outlined),
        SubItems(title: "P.G.", icon: Icons.people_outline),
      ],
    );
  }

  Widget _buildResidentialPackagesSection() {
    return ExpandableTile(
      title: "Residential Packages",
      subtitle: "Explore property types",
      leadingIcon: Icons.home_work_outlined,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      children: const [
        SubItems(title: "For Developer", icon: Icons.apartment_outlined),
        SubItems(title: "For Broker", icon: Icons.verified_user_outlined),
        SubItems(title: "For Buyer", icon: Icons.home_work_outlined),
      ],
    );
  }

  Widget _buildToolsAndAdviceSection() {
    return ExpandableTile(
      title: "Tools & Advice",
      subtitle: 'Property calculators & guides',
      leadingIcon: Icons.tips_and_updates_outlined,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      children: const [
        SubItems(title: "EMI Calculator", icon: Icons.calculate_outlined),
        SubItems(
          title: "Affordability Calculator",
          icon: Icons.calculate_outlined,
        ),
        SubItems(
          title: "Eligibility Calculator",
          icon: Icons.calculate_outlined,
        ),
        SubItems(title: "Guide", icon: Icons.help_outline_rounded, isNew: true),
      ],
    );
  }

  Widget _buildHelpCenter() {
    return Center(
      child: NesticoPeButton(
        width: double.infinity,
        onTap: () {
          // TODO: Navigate to help center
        },
        title: 'Help Center',
      ),
    );
  }

  void _navigateToZeroBrokerage() => print("Navigate to Zero Brokerage");

  void _navigateToSavedSearch() => print("Navigate to Saved Search");

  void _navigateToNews() => print("Navigate to News");

  void _navigateToServices() => print("Navigate to Services");

  void _navigateToRecommended() => print("Navigate to Recommended");

  void _navigateToReportFraud() => print("Navigate to Report Fraud");
}

class _ProfileWelcomeSection extends StatelessWidget {
  String name;

  _ProfileWelcomeSection({required this.name});

  @override
  Widget build(BuildContext context) {
    final userType = UserHelper.userTypeString ?? "guest";
    final sellerType = UserHelper.sellerTypeStringValue;

    String displayRole = userType[0].toUpperCase() + userType.substring(1);
    String displaySellerType = sellerType != null ? "${name}" : "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello 👋 ${name.capitalize?.replaceAll("_", " ") ?? 'Guest'}",
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Easy contact with sellers",
          style: TextStyle(
            color: ColorRes.leadGreyColor.shade600,
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,
          ),
        ),
        Text(
          "Personalized experience",
          style: TextStyle(
            color: ColorRes.leadGreyColor.shade600,
            fontWeight: AppFontWeights.medium,
            fontSize: AppFontSizes.caption,
          ),
        ),
      ],
    );
  }
}

class SettingsMenuTile extends StatefulWidget {

  const SettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.badgeText,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title, subTitle;
  final String? badgeText;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  State<SettingsMenuTile> createState() => _SettingsMenuTileState();
}

class _SettingsMenuTileState extends State<SettingsMenuTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                /// ✅ Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, size: 24, color: ColorRes.primary),
                ),

                const SizedBox(width: 14),

                /// ✅ Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subTitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.leadGreyColor[600],
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ✅ Trailing Arrow
                widget.trailing ??
                    Icon(
                      Icons.chevron_right,
                      color: ColorRes.leadGreyColor[400],
                    ),
              ],
            ),
          ),
          if (widget.badgeText != null && widget.badgeText!.isNotEmpty)
            Positioned(
              right: 20,
              top: -5,
              child: _buildShinyText(widget.badgeText??''),
            ),
        ],
      ),
    );
  }

 Widget _buildShinyText(String text) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        /// 🎯 Smooth pulse scale
        final scale = 1 + (0.04 * sin(_controller.value * 2 * 3.1416));

        return Transform.scale(
          scale: scale,

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ColorRes.homeYellow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                /// ✨ Shimmer text
                ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment(-1.5 + _controller.value * 3, 0),
                      end: Alignment(-0.5 + _controller.value * 3, 0),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                        Colors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                    fontSize: AppFontSizes.mini,
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}