// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/font_res.dart';
// import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
// import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
// import 'package:housing_flutter_app/data/network/review/model/review_model.dart';
// import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
// import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
// import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
// import 'package:housing_flutter_app/modules/profile/views/seller_profile_detail.dart';
// import 'package:housing_flutter_app/modules/profile/views/widget/buyer_profile.dart';
// import 'package:housing_flutter_app/modules/referral/view/referral_dashboard.dart';
// import 'package:housing_flutter_app/modules/review/views/widget/add_app_review_screen.dart';
// import 'package:housing_flutter_app/modules/review/views/widget/app_review_card.dart';
// import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';
// import 'package:housing_flutter_app/widgets/button/button.dart';
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
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/font_res.dart';
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
//                                   fontFamily: FontRes.nuNunitoSans,
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
//                                     fontFamily: FontRes.nuNunitoSans,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/font_res.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/review/model/review_model.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
import 'package:housing_flutter_app/modules/profile/views/seller_profile_detail.dart';
import 'package:housing_flutter_app/modules/profile/views/widget/buyer_profile.dart';
import 'package:housing_flutter_app/modules/profile/views/widget/my_contractor_screen.dart';
import 'package:housing_flutter_app/modules/referral/view/referral_dashboard.dart';
import 'package:housing_flutter_app/modules/review/views/widget/add_app_review_screen.dart';
import 'package:housing_flutter_app/modules/review/views/widget/app_review_card.dart';
import 'package:housing_flutter_app/modules/saved_property/views/user_activity_screen.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/widgets/expandable_tile/expandable_widget.dart';
import '../../auth/views/select_account_type_screen.dart';
import '../../calender/views/calender_screen.dart';
import '../../profile/views/edit_profile_screen.dart';
import '../../review/controllers/review_controller.dart';
import '../../saved_property/views/saved_property_screen.dart';

// Import additional screens
import '../../auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import '../../contractor/view/widget/convert_to_contractor.dart';
import '../../hire_contractor/view/hire_contractor_screen.dart';
import '../../subscription/views/user_subscription_details.dart';
import '../../support_ticket/views/support_ticket_screen.dart';
import '../../support_ticket/controllers/chat_socket_controller.dart';
import '../../dashboard/views/seller_dashboard_screen.dart';
import '../../reseller/view/property_reseller.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
import '../../property/controllers/property_controller.dart';

import '../../visit/screen/visit_screen.dart';
import '../controllers/buyer_profiledata.dart';

class ProfileScreen extends StatelessWidget {
  final String imageUrl;

  ProfileScreen({super.key, required this.imageUrl});

  static const double _defaultPadding = 16.0;
  static const double _cardRadius = 16.0;
  static const double _profileRadius = 36.0;
  final profileController = Get.find<BuyerProfileDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_defaultPadding),
          child:
              UserHelper.isGuest
                  ? Column(
                    children: [
                      _buildProfileCard(BuyerProfileDataController(), imageUrl),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => LoginScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.success,
                          ),
                          child: Text('Login'),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: ColorRes.leadGreyColor.shade700,
                                  fontFamily: FontRes.nuNunitoSans,
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
                                    color: ColorRes.success,
                                    fontWeight: AppFontWeights.extraBold,
                                    fontFamily: FontRes.nuNunitoSans,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileCard(profileController, imageUrl),
                      const SizedBox(height: 20),

                      // 🎯 Role-Based Action Buttons Section
                      _buildRoleBasedActions(),

                      // Existing Menu Items
                      SettingsMenuTile(
                        icon: Icons.monitor_heart_outlined,
                        title: "My Activity",
                        subTitle: "Track your interactions",
                        onTap: () => Get.to(() => UserActivityScreen()),
                      ),
                      SettingsMenuTile(
                        icon: Icons.travel_explore,
                        title: "Visits",
                        subTitle: "Track your Visit",
                        onTap: () => Get.to(() => VisitScreen()),
                      ),
                      // SettingsMenuTile(
                      //   icon: Icons.subscriptions_outlined,
                      //   title: "My Subscription",
                      //   subTitle: "show your all plan",
                      //   onTap: () => Get.to(() => UserSubscriptionDetails()),
                      // ),
                      if (!UserHelper.isGuest) ...[
                        SettingsMenuTile(
                          icon: Icons.card_giftcard,
                          title: "Referral",
                          subTitle: "Refer And Earn",
                          onTap: () => Get.to(() => ReferralProgramScreen()),
                        ),
                      ],
                      _buildActionButton(
                        icon: Icons.engineering_outlined,
                        label: "My Contractors",
                        subtitle: "Service contractor",
                        onTap: () => Get.to(() => MyContractorScreen()),
                      ),
                      if (!UserHelper.isGuest && !UserHelper.isBuyer) ...[
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
                      ],
                      if (!UserHelper.isGuest && !UserHelper.isBuyer) ...[
                        SettingsMenuTile(
                          icon: Icons.event_available,
                          title: "Events",
                          subTitle: "Upcoming events",
                          onTap: () => Get.to(() => CalendarScreen()),
                        ),
                      ],

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
                      const SizedBox(height: 20),

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
                      SizedBox(
                        width: double.infinity,
                        child: NesticoPeButton(
                          width: double.infinity,
                          onTap: () {
                            Get.lazyPut(() => AuthController());
                            final controller = Get.find<AuthController>();
                            controller.logout();
                          },
                          title: 'Logout',
                        ),
                      ),
                    ],
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
        if (UserHelper.isBuyer) ...[
          SettingsMenuTile(
            icon: Icons.person_add_outlined,
            title: "Convert to Seller",
            subTitle: "Become the seller",
            onTap: () => Get.to(() => SellerConversionScreen()),
          ),

          SettingsMenuTile(
            icon: Icons.group_add_outlined,
            title: "Convert to Reseller",
            subTitle: "Become the reseller",
            onTap: () => Get.to(() => ResellerConversionScreen()),
          ),

          SettingsMenuTile(
            icon: Icons.construction_outlined,
            title: "Convert to Contractor",
            subTitle: "Become the contractor",
            onTap: () => Get.to(() => ConvertToContractorConversionScreen()),
          ),

          // SettingsMenuTile(
          //   icon: Icons.engineering_outlined,
          //   title: "Hire Contractor",
          //   subTitle: "Hire top contractors",
          //   onTap: () => Get.to(() => HireContractorScreen()),
          // ),
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

          // _buildActionButton(
          //   icon: Icons.engineering_outlined,
          //   subtitle: "Hire top contractors",
          //   label: "Hire Contractor",
          //   onTap: () => Get.to(() => HireContractorScreen()),
          // ),

          _buildActionButton(
            icon: Icons.support_agent_outlined,
            label: "Support Ticket",
            subtitle: 'Talk to support',
            onTap: () {
              Get.put(SocketController());
              Get.to(() => SupportTicketScreen());
            },
          ),
        ],

        // 🔄 RESELLER ACTIONS
        if (UserHelper.isReseller) ...[
          _buildActionButton(
            icon: Icons.dashboard_outlined,
            label: "Partner Dashboard",
            subtitle: 'Navigate to Partner Panel',
            onTap: () => Get.to(() => MainNavigationScreen()),
          ),

          // _buildActionButton(
          //   icon: Icons.engineering_outlined,
          //   label: "Hire Contractor",
          //   subtitle: "Hire top contractors",
          //   onTap: () => Get.to(() => HireContractorScreen()),
          // ),

          _buildActionButton(
            icon: Icons.support_agent_outlined,
            label: "Support Ticket",
            subtitle: 'Talk to support',
            onTap: () {
              Get.put(SocketController());
              Get.to(() => SupportTicketScreen());
            },
          ),
        ],

        // 🏗️ CONTRACTOR ACTIONS
        if (UserHelper.isContractor) ...[
          _buildActionButton(
            icon: Icons.dashboard_outlined,
            label: "Contractor Dashboard",
            subtitle: 'Navigate to Contractor Panel',
            onTap: () => Get.to(() => ContractorMainScreen()),
          ),
          // _buildActionButton(
          //   icon: Icons.engineering_outlined,
          //   label: "Hire Contractor",
          //   subtitle: "Hire top contractors",
          //   onTap: () => Get.to(() => HireContractorScreen()),
          // ),
          _buildActionButton(
            icon: Icons.support_agent_outlined,
            label: "Support Ticket",
            subtitle: 'Talk to support',
            onTap: () {
              Get.put(SocketController());
              Get.to(() => SupportTicketScreen());
            },
          ),
        ],

        // 🏢 BUILDER ACTIONS (Seller with Builder type)
        if (UserHelper.isSellerBuilder) ...[
          _buildActionButton(
            icon: Icons.apartment_outlined,
            subtitle: 'Navigate to Builder Panel',
            label: "Builder Dashboard",

            onTap: () => Get.to(() => BuilderMainScreen()),
          ),
          // _buildActionButton(
          //   icon: Icons.engineering_outlined,
          //   label: "Hire Contractor",
          //   subtitle: "Hire top contractors",
          //   onTap: () => Get.to(() => HireContractorScreen()),
          // ),

          _buildActionButton(
            icon: Icons.support_agent_outlined,
            label: "Support Ticket",
            subtitle: 'Talk to support',
            onTap: () {
              Get.put(SocketController());
              Get.to(() => SupportTicketScreen());
            },
          ),
        ],
      ],
    );
  }

  /// Action Button Widget
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28, color: ColorRes.primary),
      title: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSizes.medium,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.leadGreyColor[600],
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorRes.white,
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
      padding: const EdgeInsets.all(_defaultPadding),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [
          BoxShadow(
            color: ColorRes.blackShade12,
            blurRadius: 8,
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
  var name;

  _ProfileWelcomeSection({required this.name});

  @override
  Widget build(BuildContext context) {
    final userType = UserHelper.userTypeString ?? "guest";
    final sellerType = UserHelper.sellerTypeStringValue;

    String displayRole = userType[0].toUpperCase() + userType.substring(1);
    String displaySellerType = sellerType != null ? "(${name})" : "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello 👋 ${name ?? 'Guest'}",
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "✓ Easy contact with sellers",
          style: TextStyle(
            color: ColorRes.leadGreyColor,
            fontSize: AppFontSizes.small,
          ),
        ),
        Text(
          "✓ Personalized experience",
          style: TextStyle(
            color: ColorRes.leadGreyColor,
            fontSize: AppFontSizes.small,
          ),
        ),
      ],
    );
  }
}

class SettingsMenuTile extends StatelessWidget {
  const SettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: ColorRes.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSizes.medium,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.leadGreyColor[600],
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
