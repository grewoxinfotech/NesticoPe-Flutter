import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/widgets/expandable_tile/expandable_widget.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/calender/views/calender_screen.dart';
import 'package:nesticope_app/modules/in_app_message/view/in_app_message_screen.dart';
import 'package:nesticope_app/modules/referral/view/referral_dashboard.dart';
import 'package:nesticope_app/modules/reseller/view/meeting/reseller_meeting_screen.dart';
import 'package:nesticope_app/modules/reseller/view/profile/success_story_screen.dart';
import 'package:nesticope_app/modules/review/controllers/review_controller.dart';
import 'package:nesticope_app/modules/review/views/widget/add_app_review_screen.dart';
import 'package:nesticope_app/modules/review/views/widget/app_review_card.dart';
import 'package:nesticope_app/modules/subscription/views/my_subscription_screen.dart';
import 'package:nesticope_app/modules/support_ticket/controllers/chat_socket_controller.dart';
import 'package:nesticope_app/modules/support_ticket/views/support_ticket_screen.dart';
import 'package:nesticope_app/widgets/button/button.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../utils/shimmer/reseller/profile_screen/reseller_profile_screen_shimmer.dart';
import '../../../../widgets/input/city_selection_widget.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../auth/views/delete_account.dart';
import '../../../home/views/home_screen/home_screen.dart';
import '../../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../controller/fack_lead_controller/fack_lead_controller.dart';
import '../../controller/profile/profile_controller.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';

import '../lead/lead_screen.dart';
import '../subscription_plan/reseller_subscription_plan.dart';
import '../../../profile/views/offers_discounts_screen.dart';

class ResellerProfileScreen extends StatefulWidget {
  const ResellerProfileScreen({Key? key}) : super(key: key);

  @override
  State<ResellerProfileScreen> createState() => _ResellerProfileScreenState();
}

class _ResellerProfileScreenState extends State<ResellerProfileScreen> {
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.refreshReseller();
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LeadController(), tag: "reseller_property");
    Get.lazyPut(() => LeadController(), tag: "reseller_project");

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,

            color: Color(0xFF1A1A2E),
          ),
        ),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        centerTitle: false,
        actions: [
          Obx(
            () => Container(
              margin: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: Icon(
                  profileController.isEditing.value
                      ? Icons.check
                      : Icons.edit_outlined,
                  size: 22,
                ),
                onPressed:
                    profileController.isEditing.value
                        ? () => profileController.saveProfile()
                        : () => profileController.toggleEdit(),
                style: IconButton.styleFrom(
                  backgroundColor:
                      profileController.isEditing.value
                          ? ColorRes.blueColor.withOpacity(0.1)
                          : ColorRes.leadGreyColor.withOpacity(0.1),
                  foregroundColor:
                      profileController.isEditing.value
                          ? ColorRes.blueColor
                          : ColorRes.leadGreyColor[700],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (profileController.isLoading.value) {
              return ResellerProfileScreenShimmer();
            }

            return RefreshIndicator(
              onRefresh: profileController.refreshReseller,
              color: ColorRes.primary,
              child:
                  (UserHelper.isReseller)
                      ? SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileHeader(profileController),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Personal Information'),
                            const SizedBox(height: 10),
                            Obx(
                              () =>
                                  profileController.isEditing.value
                                      ? _buildProfileForm(profileController)
                                      : _buildPersonalInfoCard(
                                        profileController,
                                      ),
                            ),
                            const SizedBox(height: 20),
                            if (!profileController.isEditing.value) ...[
                              _buildSectionTitle('Performance Overview'),
                              const SizedBox(height: 10),
                              _buildSellerDetailsSection(profileController),
                              const SizedBox(height: 20),
                              _buildSectionTitle('Account Information'),
                              const SizedBox(height: 10),
                              _buildSellerAccountSection(profileController),
                              const SizedBox(height: 16),
                              _buildLeadOverView(),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.local_offer_outlined,
                                label: "Offers & Discounts",
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                subtitle:
                                    "View and manage your offers and discounts",
                                onTap: () {
                                  Get.to(
                                    () => const OffersDiscountsScreen(
                                      userType: 'reseller',
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.dashboard_outlined,
                                label: "Success Story",
                                iconColor: const Color(0xFFEC4899),
                                iconBg: const Color(0xFFFCE7F3),
                                subtitle:
                                    "View and manage your success stories",
                                onTap: () {
                                  Get.to(() => SuccessStoryScreen());
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.event_available,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                label: "Events",
                                subtitle: "Upcoming events",
                                onTap: () => Get.to(() => CalendarScreen()),
                              ),

                              // const SizedBox(height: 16),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.card_giftcard,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                label: "Referral",
                                subtitle: "Refer And Earn",
                                onTap:
                                    () => Get.to(() => ReferralProgramScreen()),
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.workspace_premium,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                label: "My Subscription",
                                subtitle: "Track your Subscription",
                                onTap:
                                    () => Get.to(() => MySubscriptionScreen()),
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.video_call_outlined,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                label: "Request Meeting",
                                subtitle: "Request a meeting with us",
                                onTap:
                                    () => Get.to(() => ResellerMeetingScreen()),
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.notifications_outlined,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                label: "Notifications",
                                subtitle: "Notifications and messages",
                                onTap: () => Get.to(() => InAppMessageScreen()),
                              ),

                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.support_agent_outlined,
                                label: "Support Ticket",
                                iconColor: const Color(0xFFEC4899),
                                iconBg: const Color(0xFFFCE7F3),
                                subtitle: 'Talk to support',
                                onTap: () {
                                  Get.put(SocketController());
                                  Get.to(() => SupportTicketScreen());
                                },
                              ),
                              const SizedBox(height: 10),
                              Obx(() {
                                final controller = Get.put(ReviewController());
                                final review = controller.appReview.value;

                                if (review == null) {
                                  return _buildActionButton(
                                    icon: Icons.reviews_outlined,
                                    label: "Reviews and Ratings",
                                    iconColor: const Color(0xFFEC4899),
                                    iconBg: const Color(0xFFFCE7F3),
                                    subtitle: "Add your review",
                                    onTap: () {
                                      Get.dialog(AddAppReviewDialog()).then((
                                        _,
                                      ) {
                                        controller.getAppReview();
                                      });
                                    },
                                  );
                                } else {
                                  return _buildReviewSection(review);
                                }
                              }),

                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.apartment_outlined,
                                label: "Project Lead",
                                iconColor: const Color(0xFF14B8A6),
                                iconBg: const Color(0xFFCCFBF1),
                                subtitle: "View and manage your project leads",
                                onTap: () {
                                  Get.to(
                                    () => CommonLeadScreen(
                                      title: 'Project Buyer Leads',
                                      controllerTag: 'reseller_project',
                                      showDataMasking: true,
                                      module: 'project',
                                      isForProject: true,
                                      isResellerFromApp: true,
                                      isViewAll: false,
                                      onLoadMore: (controller, id) async {
                                        if (id != null) {
                                          controller.loadMorePropertyLeads(id);
                                        } else {
                                          controller.loadMore();
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                icon: Icons.home_outlined,
                                label: "Property Lead",
                                iconColor: const Color(0xFFF59E0B),
                                iconBg: const Color(0xFFFEF3C7),
                                subtitle: "View and manage your property leads",
                                onTap: () {
                                  Get.to(
                                    () => CommonLeadScreen(
                                      title: 'Property Buyer Leads',
                                      controllerTag: 'reseller_property',
                                      showDataMasking: true,
                                      module: 'property',
                                      isResellerFromApp: true,
                                      isViewAll: false,
                                      onLoadMore: (controller, id) async {
                                        if (id != null) {
                                          controller.loadMorePropertyLeads(id);
                                        } else {
                                          controller.loadMore();
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                              // const SizedBox(height: 24),
                              SizedBox.shrink(),
                            ],
                          ],
                        ),
                      )
                      : SizedBox.shrink(),
            );
          }),
          Obx(() {
            final bool show = profileController.isSaving.value;
            return show
                ? const Positioned.fill(
                  child: ModalBarrier(
                    color: Color.fromRGBO(255, 255, 255, 0.35),
                    dismissible: false,
                  ),
                )
                : const SizedBox.shrink();
          }),
          Obx(() {
            final bool show = profileController.isSaving.value;
            return show
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Obx(
        () =>
            (!profileController.isEditing.value)
                ? SafeArea(
                  child: Container(
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorRes.white,
                          ColorRes.white.withOpacity(0.5), // top: solid white
                          ColorRes.white.withOpacity(
                            0.0,
                          ), // bottom: transparent
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorRes.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border(
                        top: BorderSide(
                          color: ColorRes.leadGreyColor.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
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
                                final controller =
                                    Get.isRegistered<AuthController>()
                                        ? Get.find<AuthController>()
                                        : Get.put(AuthController());
                                controller.logout();
                              },
                              title: 'Logout',
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDeleteAccountButton(),
                        ],
                      ),
                    ),
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return Container(
      decoration: BoxDecoration(
        // color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const RequestDeleteAccount(),
    );
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: AppFontWeights.semiBold,
        color: ColorRes.textPrimary,
      ),
    );
  }

  Widget _buildPersonalInfoCard(ProfileController controller) {
    final user = controller.profileData.value?.user;
    return Container(
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
        children: [
          _infoRow(
            icon: Icons.person_outline,
            iconColor: const Color(0xFF6366F1),
            iconBg: const Color(0xFFEEF2FF),
            label: 'Full Name',
            value: '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
          ),
          _divider(),
          _infoRow(
            icon: Icons.email_outlined,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFD1FAE5),
            label: 'Email Address',
            value: user?.email ?? '',
          ),
          _divider(),
          _infoRow(
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFEF3C7),
            label: 'Phone Number',
            value: user?.phone ?? '',
          ),
          _divider(),
          _infoRow(
            icon: Icons.apartment_outlined,
            iconColor: const Color.fromARGB(255, 245, 97, 11),

            iconBg: const Color.fromARGB(255, 252, 223, 203),

            label: 'State',
            value: user?.state ?? '',
          ),
          _divider(),
          // City + Experience in same row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.location_city_outlined,
                    size: 20,
                    color: Color(0xFFEC4899),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'City',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 155, 161, 172),
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.city ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Experience',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 155, 161, 172),
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (user?.totalExperience == null ||
                              user!.totalExperience.toString().toLowerCase() ==
                                  'null' ||
                              user.totalExperience.toString().isEmpty)
                          ? 'Not Provided'
                          : '${user.totalExperience} Years',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,

                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 155, 161, 172),
                  fontWeight: AppFontWeights.medium,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : 'Not Provided',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    indent: 16,
    endIndent: 16,
    color: Color(0xFFF3F4F6),
  );

  Widget _buildDownloadCertificateButton(ProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            controller.isDownloadingCertificate.value
                ? null
                : controller.downloadCertificate,
        icon:
            controller.isDownloadingCertificate.value
                ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorRes.white,
                  ),
                )
                : const Icon(Icons.file_download_outlined, size: 20),
        label: Text(
          controller.isDownloadingCertificate.value
              ? "Downloading ${(controller.downloadProgress.value * 100).toStringAsFixed(0)}%"
              : "Download Reseller Certificate",
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorRes.primary,

          foregroundColor: ColorRes.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // Widget _buildActionButton({
  //   required IconData icon,
  //   required String label,

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
  //     trailing: trailing ?? const Icon(Icons.chevron_right),
  //     onTap: onTap,
  //   );
  // }
  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }

  // Widget _buildSellerDetailsSection(ProfileController controller) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: ColorRes.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: ColorRes.leadGreyColor.withOpacity(0.3),
  //         width: 1,
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Performance Overview',
  //           style: TextStyle(
  //             fontSize: AppFontSizes.bodyMedium,
  //             fontWeight: AppFontWeights.bold,
  //             color: ColorRes.textPrimary,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 16),
  //             _buildDetailRow(
  //               'Total Commission',
  //               '${Formatter.formatPrice(num.tryParse(controller.resellerProfile.value?.data.totalCommissions ?? '') ?? 0) ?? ''}',
  //             ),
  //             const SizedBox(height: 12),
  //             Spacer(),
  //             _buildDetailRow(
  //               'Performance Levels',
  //               controller.resellerProfile.value?.data.performanceLevel ?? '',
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 16),
  //             _buildDetailRow(
  //               'Success Rate',
  //               '${controller.resellerProfile.value?.data.successRate == null ? '0' : controller.resellerProfile.value?.data.successRate} %',
  //             ),
  //             const SizedBox(height: 12),
  //             Spacer(),
  //             _buildDetailRow(
  //               'Total Sales',
  //               '${Formatter.formatNumber(num.tryParse(controller.resellerProfile.value?.data.totalSales.toString() ?? '') ?? 0) ?? ''}',
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildSellerDetailsSection(ProfileController controller) {
    final profile = controller.resellerProfile.value?.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Row 1
        Row(
          children: [
            Expanded(
              child: _perfCell(
                label: 'Total Commission',
                value: Formatter.formatPrice(
                  num.tryParse(profile?.totalCommissions ?? '') ?? 0,
                ),
                valueColor: ColorRes.primary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _perfCell(
                label: 'Performance Level',
                value: profile?.performanceLevel ?? 'N/A',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// Row 2
        Row(
          children: [
            Expanded(
              child: _perfCell(
                label: 'Success Rate',
                value:
                    '${profile?.successRate == null ? '0' : profile?.successRate} %',
                valueColor: ColorRes.success,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _perfCell(
                label: 'Total Sales',
                value: Formatter.formatNumber(
                  num.tryParse(profile?.totalSales.toString() ?? '') ?? 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _perfCell({
    required String label,
    required String value,
    Widget? valueWidget,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 155, 161, 172),
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 4),
          valueWidget ??
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: AppFontWeights.semiBold,
                  color: valueColor ?? ColorRes.textPrimary,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSellerAccountSection(ProfileController controller) {
    final user = controller.profileData.value?.user;
    final isVerified = user?.isVerified ?? false;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CREATED AT',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatter.formatDate(user?.createdAt),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: AppFontWeights.semiBold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LAST UPDATED',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatter.formatDate(user?.updatedAt),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: AppFontWeights.semiBold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 20, color: Colors.white.withOpacity(0.1)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Verification Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),

                  fontWeight: AppFontWeights.medium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isVerified ? ColorRes.success : ColorRes.error,
                  ),
                  color: const Color.fromARGB(255, 28, 28, 44),

                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isVerified ? 'VERIFIED' : 'NOT VERIFIED',
                  style: TextStyle(
                    color: isVerified ? ColorRes.success : ColorRes.error,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.leadGreyColor[600],
            fontWeight: AppFontWeights.medium,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ],
    );
  }

  // Widget _buildProfileHeader(ProfileController controller) {
  //   return Container(
  //    width: double.infinity,
  //     padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: ColorRes.white,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: ColorRes.leadGreyColor.withOpacity(0.3),
  //         width: 1,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(

  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             SizedBox(width: 6),
  //             Stack(
  //               children: [

  //                 //   ImageProvider? imageProvider;
  //                 //
  //                 //   // ✅ 1. Check if user selected a new local image
  //                 //   if (controller.selectedImage.value != null) {
  //                 //     imageProvider = FileImage(controller.selectedImage.value!);
  //                 //   }
  //                 //   // ✅ 2. Else use profilePic from API
  //                 //   else {
  //                 //     final profilePic = controller.profileData.value?.user?.profilePic;
  //                 //
  //                 //     if (profilePic != null && profilePic.isNotEmpty) {
  //                 //       // ✅ If it's a network URL
  //                 //       if (profilePic.startsWith('http') || profilePic.startsWith('https')) {
  //                 //         imageProvider = NetworkImage(profilePic);
  //                 //       }
  //                 //       // ✅ Else if it's a valid local file path
  //                 //       else if (File(profilePic).existsSync()) {
  //                 //         imageProvider = FileImage(File(profilePic));
  //                 //       }
  //                 //     }
  //                 //   }
  //                 //
  //                 //   // ✅ 3. Build the circular avatar
  //                 //   return Container(
  //                 //     decoration: BoxDecoration(
  //                 //       shape: BoxShape.circle,
  //                 //       border: Border.all(color: ColorRes.primary, width: 2),
  //                 //     ),
  //                 //     child: Padding(
  //                 //       padding: const EdgeInsets.all(2.0),
  //                 //       child: CircleAvatar(
  //                 //         radius: 35,
  //                 //         backgroundColor:
  //                 //         imageProvider == null ? ColorRes.primary.withOpacity(0.1) : null,
  //                 //         backgroundImage: imageProvider,
  //                 //         child: imageProvider == null
  //                 //             ? Icon(
  //                 //           Icons.person,
  //                 //           size: 25,
  //                 //           color: ColorRes.primary.withOpacity(0.8),
  //                 //         )
  //                 //             : null,
  //                 //       ),
  //                 //     ),
  //                 //   );
  //                 // }),
  //                 Obx(() {
  //                   ImageProvider? imageProvider;
  //                   final profilePic =
  //                       controller.profileData.value?.user?.profilePic;
  //                   final selectedImage = controller.selectedImage.value;

  //                   // 🔹 Show loader if image upload in progress
  //                   if (controller.isLoadingIMage.value) {
  //                     return const Center(child: CircularProgressIndicator());
  //                   }

  //                   bool isNetworkImage = false;
  //                   String? imageUrl;

  //                   // 1️⃣ If user selected a new image
  //                   if (selectedImage != null) {
  //                     if (selectedImage is File) {
  //                       imageProvider = FileImage(selectedImage);
  //                     } else if (selectedImage.toString().startsWith('http')) {
  //                       imageUrl = selectedImage.toString();
  //                       imageProvider = NetworkImage(imageUrl);
  //                       isNetworkImage = true;
  //                     }
  //                   } else if (profilePic != null && profilePic.isNotEmpty) {
  //                     if (profilePic.startsWith('http')) {
  //                       imageUrl = profilePic;
  //                       imageProvider = NetworkImage(profilePic);
  //                       isNetworkImage = true;
  //                     } else if (File(profilePic).existsSync()) {
  //                       imageProvider = FileImage(File(profilePic));
  //                     }
  //                   }

  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(color: ColorRes.primary, width: 2),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(2.0),
  //                       child: ClipOval(
  //                         child: SizedBox(
  //                           width: 70,
  //                           height: 70,
  //                           child:
  //                               imageProvider != null
  //                                   ? (isNetworkImage
  //                                       ? Image.network(
  //                                         imageUrl!,
  //                                         fit: BoxFit.cover,
  //                                         loadingBuilder: (
  //                                           context,
  //                                           child,
  //                                           progress,
  //                                         ) {
  //                                           if (progress == null) return child;
  //                                           return const Center(
  //                                             child: SizedBox(
  //                                               width: 25,
  //                                               height: 25,
  //                                               child:
  //                                                   CircularProgressIndicator(
  //                                                     strokeWidth: 2,
  //                                                   ),
  //                                             ),
  //                                           );
  //                                         },
  //                                         errorBuilder:
  //                                             (context, error, stackTrace) =>
  //                                                 const Icon(
  //                                                   Icons.person,
  //                                                   size: 30,
  //                                                 ),
  //                                       )
  //                                       : Image(
  //                                         image: imageProvider,
  //                                         fit: BoxFit.cover,
  //                                       ))
  //                                   : CircleAvatar(
  //                                     radius: 35,
  //                                     backgroundColor: ColorRes.primary
  //                                         .withOpacity(0.1),
  //                                     child: Icon(
  //                                       Icons.person,
  //                                       size: 25,
  //                                       color: ColorRes.primary.withOpacity(
  //                                         0.8,
  //                                       ),
  //                                     ),
  //                                   ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 }),

  //                 if (controller.isEditing.value)
  //                   Positioned(
  //                     bottom: -2,
  //                     right: 0,
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         controller.showImagePickerOptions(Get.context!);
  //                       },
  //                       child: Container(
  //                         padding: const EdgeInsets.all(6),
  //                         decoration: BoxDecoration(
  //                           color: ColorRes.primary,
  //                           shape: BoxShape.circle,
  //                           border: Border.all(color: ColorRes.white, width: 2),
  //                         ),
  //                         child: const Icon(
  //                           Icons.camera_alt,
  //                           color: ColorRes.white,
  //                           size: 12,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //             const SizedBox(width: 16),

  //             // Text Info Section
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     width: 140,
  //                     child: Text(
  //                       ' ${controller.profileData.value?.user?.username ?? ''}',
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                         fontSize: AppFontSizes.body,
  //                         fontWeight: AppFontWeights.bold,
  //                         color: ColorRes.textPrimary,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 2,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.primary.withOpacity(0.08),
  //                       borderRadius: BorderRadius.circular(6),
  //                       border: Border.all(
  //                         color: ColorRes.primary.withOpacity(0.3),
  //                         width: 1,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       '${(controller.profileData.value?.user?.userType == "reseller") ? "Partner" : ""}'
  //                           .toUpperCase(),
  //                       style: TextStyle(
  //                         fontSize: AppFontSizes.extraSmall,
  //                         color: ColorRes.primary,
  //                         fontWeight: AppFontWeights.medium,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 6),
  //                   Row(
  //                     children: [
  //                       SizedBox(
  //                         width: 150,
  //                         child: Text(
  //                           '${controller.profileData.value?.user?.city ?? 'Not Define'} ',
  //                           style: TextStyle(
  //                             fontSize: AppFontSizes.small,
  //                             color: ColorRes.leadGreyColor[600],
  //                             fontWeight: AppFontWeights.medium,
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 6),
  //         Obx(
  //           () => GestureDetector(
  //             onTap: () {
  //               if (controller.isEditing.value) {
  //                 controller.saveProfile();
  //               } else {
  //                 controller.toggleEdit();
  //               }
  //             },

  //             child: Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 14,
  //                 vertical: 6,
  //               ),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 gradient: const LinearGradient(
  //                   colors: [Color(0xFF4281F6), Color(0xFF1E43FF)],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.15),
  //                     blurRadius: 3,
  //                     offset: const Offset(0, 1),
  //                   ),
  //                 ],
  //               ),
  //               child: Text(
  //                 controller.isEditing.value ? 'Save Changes' : 'Customize',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar + verified badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Obx(() {
                final profilePic =
                    controller.profileData.value?.user?.profilePic;
                final selectedImage = controller.selectedImage.value;

                if (controller.isLoadingIMage.value) {
                  return _avatarShell(child: const CircularProgressIndicator());
                }

                Widget imageWidget;
                if (selectedImage != null) {
                  if (selectedImage is File) {
                    imageWidget = Image.file(
                      selectedImage,
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    );
                  } else if (selectedImage.toString().startsWith('http')) {
                    imageWidget = CustomImage(
                      type: CustomImageType.network,
                      src: selectedImage.toString(),
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    );
                  } else {
                    imageWidget = Icon(
                      Icons.person,
                      size: 40,
                      color: ColorRes.primary.withOpacity(0.8),
                    );
                  }
                } else if (profilePic != null && profilePic.isNotEmpty) {
                  if (profilePic.startsWith('http')) {
                    imageWidget = CustomImage(
                      type: CustomImageType.network,
                      src: profilePic,
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    );
                  } else if (File(profilePic).existsSync()) {
                    imageWidget = Image.file(
                      File(profilePic),
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    );
                  } else {
                    imageWidget = Icon(
                      Icons.person,
                      size: 40,
                      color: ColorRes.primary.withOpacity(0.8),
                    );
                  }
                } else {
                  imageWidget = Icon(
                    Icons.person,
                    size: 40,
                    color: ColorRes.primary.withOpacity(0.8),
                  );
                }

                return _avatarShell(child: imageWidget);
              }),

              // Verified badge
              (!controller.isEditing.value)
                  ? Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: ColorRes.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  )
                  : SizedBox.shrink(),

              // Camera button when editing
              Obx(
                () =>
                    controller.isEditing.value
                        ? Positioned(
                          bottom: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap:
                                () => controller.showImagePickerOptions(
                                  Get.context!,
                                ),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ColorRes.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Username
          Obx(
            () => Text(
               (controller.profileData.value?.user?.username ?? 'User Name')
                      .capitalize
                      ?.replaceAll('_', ' ') ??
                  '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Role badge + City
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (controller.profileData.value?.user?.userType ?? '')
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ColorRes.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
                Text(
                  controller.profileData.value?.user?.city ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Customize Profile button
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    controller.isEditing.value
                        ? () => profileController.saveProfile()
                        : () => profileController.toggleEdit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller.isEditing.value
                      ? 'Save Changes'
                      : 'Customize Profile',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Download Certificate button
          Obx(
            () =>
                !profileController.isEditing.value
                    ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            controller.isDownloadingCertificate.value
                                ? null
                                : controller.downloadCertificate,
                        icon:
                            controller.isDownloadingCertificate.value
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF3B82F6),
                                  ),
                                )
                                : const Icon(
                                  Icons.file_download_outlined,
                                  size: 18,
                                  color: ColorRes.primary,
                                ),
                        label: Text(
                          controller.isDownloadingCertificate.value
                              ? 'Downloading ${(controller.downloadProgress.value * 100).toStringAsFixed(0)}%'
                              : 'Contractor Certificate',
                          style: TextStyle(
                            color: ColorRes.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: BorderSide(color: ColorRes.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _avatarShell({required Widget child}) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorRes.primary.withOpacity(0.15),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: Center(child: child)),
    );
  }

  Widget _buildLeadOverView() {
    final Rxn<UserModel> user = Rxn<UserModel>();
    final isLoading = true.obs;

    // Load user data only once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storedUser = await SecureStorage.getUserData();
      user.value = storedUser;
      isLoading.value = false;
    });

    return Obx(() {
      if (isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (user.value == null ||
          user.value!.user?.id == null ||
          user.value!.user!.id!.isEmpty) {
        return const Center(
          child: Text("User not found", style: TextStyle(color: Colors.grey)),
        );
      }

      return ExpandableTile(
        title: 'Lead Report',
        leadingIcon: Icons.leaderboard_outlined,
        trailingIcon: Icons.keyboard_arrow_down_rounded,
        children: [_buildLeadSection(user.value!.user!.id!)],
      );
    });
  }

  Widget _buildLeadSection(String resellerId) {
    final fakeLeadController = Get.put(
      ResellerFakeLeadController(),
    ); // put once

    // Fetch when widget builds (optional safety)
    if (fakeLeadController.fakeLeadStats.value == null &&
        !fakeLeadController.isLoading.value) {
      fakeLeadController.fetchFakeLeadStats(resellerId);
    }

    return Obx(() {
      if (fakeLeadController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (fakeLeadController.errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              fakeLeadController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      final stats = fakeLeadController.fakeLeadStats.value;

      if (stats == null) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Lead Quality Stats',
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ),

            Divider(
              height: 1,
              color: ColorRes.leadGreyColor.withOpacity(0.3),
              indent: 12,
              endIndent: 12,
            ),

            // Stats Grid
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildLeadStatCard(
                          label: 'Total Fake Leads',
                          value: stats.totalFakeLeads.toString(),
                          percentageChange: '+5%',
                          isPositiveChange:
                              false, // red for increase in fake leads
                          icon: Icons.access_time_outlined,
                          iconColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildLeadStatCard(
                          label: 'Recent Fake Leads',
                          value: stats.recentFakeLeads.toString(),
                          percentageChange: '-12%',
                          isPositiveChange: true, // green/good for decrease
                          icon: Icons.history,
                          iconColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  _buildAccountStatusCard(isBlocked: stats.isCurrentlyBlocked),
                  const SizedBox(height: 12),
                  _buildAccountHealthCard(
                    remainingWarnings: stats.remainingBeforeBlock,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Divider(
              height: 1,
              color: ColorRes.leadGreyColor.withOpacity(0.3),
              indent: 12,
              endIndent: 12,
            ),

            // Recent Reports Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Fake Lead Reports',
                    style: TextStyle(
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (stats.fakeLeadHistory.isEmpty)
                    _buildEmptyReports()
                  else
                    ...stats.fakeLeadHistory.map(
                      (report) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildReportCard(
                          date:
                              "${report.markedFakeAt.toLocal()}".split('.')[0],
                          leadId: report.reason,
                        ),
                      ),
                    ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyReports() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: Colors.grey[500],
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            "No reports yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "When fake leads are identified, they will appear here for your review.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadStatCard({
    required String label,
    required String value,
    required String percentageChange,
    required bool isPositiveChange,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + Icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 155, 161, 172),
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 10),
          // Value + percentage badge
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStatusCard({required bool isBlocked}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCOUNT STATUS',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 155, 161, 172),
                  fontWeight: AppFontWeights.medium,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isBlocked ? 'Blocked' : 'Not Blocked',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: AppFontWeights.semiBold,
                  color: isBlocked ? Colors.red[700] : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isBlocked ? Icons.cancel : Icons.check_circle,
                    size: 15,
                    color: isBlocked ? ColorRes.error : ColorRes.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isBlocked ? 'Account Blocked' : 'Good Standing',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isBlocked ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Shield icon circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isBlocked
                      ? ColorRes.error.withOpacity(0.08)
                      : ColorRes.primary.withOpacity(0.08),
            ),
            child: Icon(
              isBlocked ? Icons.shield_outlined : Icons.verified_user_outlined,
              color: isBlocked ? ColorRes.error : ColorRes.primary,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountHealthCard({required int remainingWarnings}) {
    // Calculate health percentage — assumes max 10 warnings before block
    const int maxWarnings = 10;
    final int usedWarnings = maxWarnings - remainingWarnings;
    final double healthPercent = ((remainingWarnings / maxWarnings) * 100)
        .clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT HEALTH',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 155, 161, 172),
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$remainingWarnings more to block',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${healthPercent.toStringAsFixed(0)}% Healthy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ColorRes.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: healthPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                healthPercent > 60
                    ? Colors.blue
                    : healthPercent > 30
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WARNING ZONE',
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 155, 161, 172),
                  fontWeight: AppFontWeights.medium,
                ),
              ),
              Text(
                'SAFETY ZONE',
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 155, 161, 172),
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({required String date, required String leadId}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            leadId,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildLeadSection() {
  //   final fackLeadController = Get.find<ResellerFakeLeadController>();
  //   return Obx(() {
  //     return Container(
  //       margin: const EdgeInsets.symmetric(vertical: 16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Header
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Text(
  //               'Lead Quality Stats',
  //               style: TextStyle(
  //                 fontSize: AppFontSizes.bodyMedium,
  //                 fontWeight: AppFontWeights.bold,
  //                 color: ColorRes.textPrimary,
  //               ),
  //             ),
  //           ),
  //
  //           Divider(
  //             height: 1,
  //             color: ColorRes.leadGreyColor.withOpacity(0.3),
  //             indent: 12,
  //             endIndent: 12,
  //           ),
  //
  //           // Stats Grid
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: _buildLeadStatCard(
  //                         label: 'TOTAL FAKE LEADS',
  //                         value: '2',
  //                         valueColor: Colors.red,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: _buildLeadStatCard(
  //                         label: 'RECENT FAKE LEADS',
  //                         value: '2',
  //                         valueColor: Colors.orange,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //                 const SizedBox(height: 16),
  //                 _buildLeadStatCard(
  //                   label: 'BLOCK STATUS',
  //                   value: 'Not Blocked',
  //                   valueColor: Colors.green,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 _buildAccountHealthCard(),
  //               ],
  //             ),
  //           ),
  //
  //           Divider(
  //             height: 1,
  //             color: ColorRes.leadGreyColor.withOpacity(0.3),
  //             indent: 12,
  //             endIndent: 12,
  //           ),
  //           const SizedBox(height: 16),
  //
  //           // Recent Reports Section
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Recent Fake Lead Reports',
  //                   style: TextStyle(
  //                     fontSize: AppFontSizes.bodyMedium,
  //                     fontWeight: AppFontWeights.bold,
  //                     color: ColorRes.textPrimary,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 _buildReportCard(
  //                   date: '06 Nov 2025, 18:13',
  //                   leadId: 'dfbfghfghfghfhfgh',
  //                 ),
  //                 const SizedBox(height: 12),
  //                 _buildReportCard(
  //                   date: '06 Nov 2025, 15:47',
  //                   leadId: 'yhtrtyrtrytryrtty',
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // Widget _buildLeadSection(String resellerId) {
  //   final fakeLeadController = Get.put(
  //     ResellerFakeLeadController(),
  //   ); // put once

  //   // Fetch when widget builds (optional safety)
  //   if (fakeLeadController.fakeLeadStats.value == null &&
  //       !fakeLeadController.isLoading.value) {
  //     fakeLeadController.fetchFakeLeadStats(resellerId);
  //   }

  //   return Obx(() {
  //     if (fakeLeadController.isLoading.value) {
  //       return const Center(
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(vertical: 20),
  //           child: CircularProgressIndicator(),
  //         ),
  //       );
  //     }

  //     if (fakeLeadController.errorMessage.isNotEmpty) {
  //       return Center(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Text(
  //             fakeLeadController.errorMessage.value,
  //             style: const TextStyle(color: Colors.red),
  //           ),
  //         ),
  //       );
  //     }

  //     final stats = fakeLeadController.fakeLeadStats.value;

  //     if (stats == null) {
  //       return const SizedBox.shrink();
  //     }

  //     return Container(
  //       margin: const EdgeInsets.symmetric(vertical: 16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Header
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Text(
  //               'Lead Quality Stats',
  //               style: TextStyle(
  //                 fontSize: AppFontSizes.bodyMedium,
  //                 fontWeight: AppFontWeights.bold,
  //                 color: ColorRes.textPrimary,
  //               ),
  //             ),
  //           ),

  //           Divider(
  //             height: 1,
  //             color: ColorRes.leadGreyColor.withOpacity(0.3),
  //             indent: 12,
  //             endIndent: 12,
  //           ),

  //           // Stats Grid
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: _buildLeadStatCard(
  //                         label: 'TOTAL FAKE LEADS',
  //                         value: stats.totalFakeLeads.toString(),
  //                         valueColor: Colors.red,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: _buildLeadStatCard(
  //                         label: 'RECENT FAKE LEADS',
  //                         value: stats.recentFakeLeads.toString(),
  //                         valueColor: Colors.orange,
  //                       ),
  //                     ),
  //                   ],
  //                 ),

  //                 const SizedBox(height: 16),
  //                 _buildLeadStatCard(
  //                   label: 'ACCOUNT STATUS',
  //                   value: stats.isCurrentlyBlocked ? "Blocked" : "Not Blocked",
  //                   valueColor:
  //                       stats.isCurrentlyBlocked ? Colors.red : Colors.green,
  //                 ),
  //                 const SizedBox(height: 16),
  //                 _buildAccountHealthCard(
  //                   remainingWarnings: stats.remainingBeforeBlock,
  //                 ),
  //               ],
  //             ),
  //           ),

  //           Divider(
  //             height: 1,
  //             color: ColorRes.leadGreyColor.withOpacity(0.3),
  //             indent: 12,
  //             endIndent: 12,
  //           ),
  //           const SizedBox(height: 16),

  //           // Recent Reports Section
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Recent Fake Lead Reports',
  //                   style: TextStyle(
  //                     fontSize: AppFontSizes.bodyMedium,
  //                     fontWeight: AppFontWeights.bold,
  //                     color: ColorRes.textPrimary,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),

  //                 if (stats.fakeLeadHistory.isEmpty)
  //                   const Text(
  //                     'No fake lead reports yet.',
  //                     style: TextStyle(color: Colors.grey),
  //                   )
  //                 else
  //                   ...stats.fakeLeadHistory.map(
  //                     (report) => Padding(
  //                       padding: const EdgeInsets.only(bottom: 12),
  //                       child: _buildReportCard(
  //                         date:
  //                             "${report.markedFakeAt.toLocal()}".split('.')[0],
  //                         leadId: report.reason,
  //                       ),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // Widget _buildLeadStatCard({
  //   required String label,
  //   required String value,
  //   required Color valueColor,
  // }) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey[200]!),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 11,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey[600],
  //             letterSpacing: 0.5,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: valueColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAccountHealthCard({required int remainingWarnings}) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey[200]!),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'ACCOUNT HEALTH',
  //           style: TextStyle(
  //             fontSize: 11,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey[600],
  //             letterSpacing: 0.5,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           children: [
  //             /* Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 10,
  //                 vertical: 4,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.orange[50],
  //                 borderRadius: BorderRadius.circular(4),
  //                 border: Border.all(color: Colors.orange[300]!),
  //               ),
  //               child: Text(
  //                 'Warning',
  //                 style: TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.orange[700],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 8),*/
  //             Text(
  //               '($remainingWarnings more to block)',
  //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildReportCard({required String date, required String leadId}) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.red[50],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.red[100]!),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           date,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[700],
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           leadId,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[800],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatisticsCards(ProfileController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Commission',
            '${Formatter.formatPrice(num.tryParse(controller.resellerProfile.value?.data.totalCommissions ?? '') ?? 0) ?? ''}',
            Icons.trending_up,
            ColorRes.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Total Sales',
            '${controller.resellerProfile.value?.data.totalSales ?? ''}',
            Icons.people_alt_outlined,
            ColorRes.blueColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Success Rate',
            '${controller.resellerProfile.value?.data.successRate}',
            Icons.star_rounded,
            ColorRes.homeAmber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Container
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          // Value
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.homeBlackFade,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.extraSmall,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildFormField(
              controller: controller.nameController,
              label: 'Fist Name',
              icon: Icons.person_outline,
              enabled: controller.isEditing.value,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              enabled: controller.isEditing.value,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              enabled: controller.isEditing.value,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!GetUtils.isEmail(value!)) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.phoneController,
              label: 'Phone',
              icon: Icons.phone_outlined,
              enabled: controller.isEditing.value,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Phone number is required';
                return null;
              },
            ),
            const SizedBox(height: 14),
            // _buildFormField(
            //   controller: controller.positionController,
            //   label: 'City',
            //   icon: Icons.location_on_outlined,
            //   enabled: controller.isEditing.value,
            // ),
            CitySelectionWidget(
              isEditing: controller.isEditing.value,
              controller: controller.positionController,
              isRequiredTitle: false,
              iconColor: ColorRes.leadGreyColor.shade600,
              onCitySelected: (selectedCity) {
                print("✅ Selected city: ${selectedCity.description}");
                controller.positionController.text =
                    selectedCity.description ?? '';
                controller.companyController.text =
                    selectedCity.reference ?? '';
                // You can also store city details in your controller here
              },
            ),

            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.addressController,
              label: 'Address',
              icon: Icons.location_on_outlined,
              enabled: controller.isEditing.value,
            ),
            const SizedBox(height: 14),
            StateSelectionWidget(
              isEditing: false,
              isRequiredTitle: false,
              iconColor: ColorRes.leadGreyColor.shade600,
              controller: controller.companyController,
              onCitySelected: (selectedCity) {
                print("✅ Selected city: ${selectedCity.description}");
                controller.companyController.text =
                    selectedCity.description ?? '';
                // You can also store city details in your controller here
              },
            ),

            // _buildFormField(
            //   controller: controller.companyController,
            //   label: 'State',
            //   icon: Icons.location_on_outlined,
            //   enabled: controller.isEditing.value,
            // ),
            const SizedBox(height: 14),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.totalExperience,
              label: 'Total Experience',
              keyboardType: TextInputType.number,
              icon: Icons.work_history_outlined,
              enabled: controller.isEditing.value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Total experience is required';
                }

                final number = int.tryParse(value);

                if (number == null) {
                  return 'Please enter a valid number';
                }

                if (number > 60) {
                  return 'Experience cannot be more than 60 years';
                }

                return null; // valid
              },
            ),
            if (controller.isEditing.value) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.blueColor,
                        foregroundColor: ColorRes.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          controller.isSaving.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: ColorRes.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  fontSize: AppFontSizes.bodyMedium,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.cancelEdit,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorRes.leadGreyColor[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: ColorRes.leadGreyColor.withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      minLines: 1,
      decoration: InputDecoration(
        labelText: label,

        labelStyle: TextStyle(
          fontSize: AppFontSizes.small,
          color:
              enabled
                  ? ColorRes.leadGreyColor[700]
                  : ColorRes.leadGreyColor[500],
        ),
        prefixIcon: Icon(icon, size: 20, color: ColorRes.leadGreyColor[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorRes.leadGreyColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorRes.leadGreyColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorRes.blueColor, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorRes.leadGreyColor.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorRes.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorRes.error, width: 1.5),
        ),
        filled: true,
        fillColor:
            enabled ? ColorRes.leadGreyColor[50] : ColorRes.leadGreyColor[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: AppFontSizes.small,
        color: ColorRes.homeBlackFade,
      ),
    );
  }

  Widget _buildProfileOptionsSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProfileOption(
            Icons.notifications_outlined,
            'Notifications',
            () {},
            showDivider: true,
          ),
          _buildProfileOption(
            Icons.security_outlined,
            'Security',
            () {},
            showDivider: true,
          ),
          _buildProfileOption(
            Icons.help_outline,
            'Help & Support',
            () {},
            showDivider: true,
          ),
          _buildProfileOption(
            Icons.logout,
            'Logout',
            () => _showLogoutDialog(Get.context!),
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isLogout
                      ? ColorRes.error.withOpacity(0.1)
                      : ColorRes.leadGreyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isLogout ? ColorRes.error : ColorRes.leadGreyColor[700],
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: AppFontWeights.medium,
              color: isLogout ? ColorRes.error : ColorRes.homeBlackFade,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 20,
            color: ColorRes.leadGreyColor[400],
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: ColorRes.leadGreyColor.withOpacity(0.2),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRes.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: AppFontSizes.subtitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              color: ColorRes.blackShade87,
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.leadGreyColor[600],
                ),
              ),
            ),

            // Logout Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                NesticoPeSnackBar.showAwesomeSnackbar(
                  title: 'Success',
                  message: 'Logged out successfully',
                  contentType: ContentType.failure,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  fontWeight: AppFontWeights.extraBold,
                  color: ColorRes.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
