import 'dart:io';

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/app/widgets/expandable_tile/expandable_widget.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';

import '../../../../app/constants/app_font_sizes.dart';

import 'package:get/get.dart';

import '../../reseller/controller/profile/profile_controller.dart';
import '../controllers/seller_profile_controller.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({Key? key}) : super(key: key);

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(SellerProfileController());

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        backgroundColor: ColorRes.white,
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
      body: SafeArea(
        child: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
        
          return (UserHelper.isSeller)
              ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: profileController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      _buildProfileHeader(profileController),
                      const SizedBox(height: 16),
        
                      // Contact Info Section (Editable)
                      Obx(() => _buildContactInfoSection(profileController)),
                      const SizedBox(height: 16),
        
                      // Business Details Section (Editable)
                   if(UserHelper.isSellerBuilder)...[
                     Obx(() => _buildBusinessDetailsSection(profileController)),
                     const SizedBox(height: 16),
                   ],
        
                      // Seller Details Section (Read-only)
                      if (!profileController.isEditing.value)
                        _buildSellerDetailsSection(profileController),
                      if (!profileController.isEditing.value)
                        const SizedBox(height: 16),
        
                      // Account Information Section (Read-only)
                      if (!profileController.isEditing.value)
                        _buildAccountInfoSection(profileController),
                      if (!profileController.isEditing.value)
                        const SizedBox(height: 16),
        
                      // Profile Options
                      if (!profileController.isEditing.value) ...[
                        _buildProfileOptionsSection(),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              )
              : SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildProfileHeader(SellerProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Obx(() {
                ImageProvider? imageProvider;

                // ✅ 1. Check if user selected a new local image
                if (controller.selectedImage.value != null) {
                  imageProvider = FileImage(controller.selectedImage.value!);
                }
                // ✅ 2. Else use profilePic from API
                else {
                  final profilePic = controller.profileData.value?.user?.profilePic;

                  if (profilePic != null && profilePic.isNotEmpty) {
                    // ✅ If it's a network URL
                    if (profilePic.startsWith('http') || profilePic.startsWith('https')) {
                      imageProvider = NetworkImage(profilePic);
                    }
                    // ✅ Else if it's a valid local file path
                    else if (File(profilePic).existsSync()) {
                      imageProvider = FileImage(File(profilePic));
                    }
                  }
                }

                // ✅ 3. Build the circular avatar
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorRes.primary, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor:
                      imageProvider == null ? ColorRes.primary.withOpacity(0.1) : null,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? Icon(
                        Icons.person,
                        size: 25,
                        color: ColorRes.primary.withOpacity(0.8),
                      )
                          : null,
                    ),
                  ),
                );
              }),

              // Obx(() {
              //   ImageProvider? imageProvider;
              //
              //   // Priority: selectedImage (local file) > profilePic (network URL) > null
              //   if (controller.selectedImage.value != null) {
              //     // If user selected a new image from gallery/camera
              //     imageProvider = FileImage(controller.selectedImage.value!);
              //   } else if (controller
              //           .profileData
              //           .value
              //           ?.user
              //           ?.profilePic
              //           ?.isNotEmpty ??
              //       false) {
              //     // If profile pic URL exists from API
              //     imageProvider = FileImage(
              //       File(controller.profileData.value!.user!.profilePic!),
              //     );
              //   }
              //   // If both are null, imageProvider stays null and shows placeholder icon
              //
              //   return Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(color: ColorRes.primary, width: 2),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(2.0),
              //       child: CircleAvatar(
              //         radius: 35,
              //         backgroundColor:
              //             imageProvider == null
              //                 ? ColorRes.primary.withOpacity(0.1)
              //                 : null,
              //         backgroundImage: imageProvider,
              //         child:
              //             imageProvider == null
              //                 ? Icon(
              //                   Icons.person,
              //                   size: 25,
              //                   color: ColorRes.primary.withOpacity(0.8),
              //                 )
              //                 : null,
              //       ),
              //     ),
              //   );
              // }),
              if (controller.isEditing.value)
                Positioned(
                  bottom: -2,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.showImagePickerOptions(Get.context!);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorRes.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorRes.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: ColorRes.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Text Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    ' ${controller.profileData.value?.user?.username ?? ''}',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: ColorRes.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${controller.profileData.value?.user?.userType ?? ''}',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        '${controller.profileData.value?.user?.city ?? 'Not Define'} ',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.leadGreyColor[600],
                          fontWeight: AppFontWeights.medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  // Widget _buildAccountHealthCard() {
  Widget _buildAccountHealthCard({required int remainingWarnings}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT HEALTH',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Text(
                  'Warning',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($remainingWarnings more to block)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildStatisticsCards(ProfileController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Commission',
            '${Formatter.formatPrice(int.tryParse(controller.resellerProfile.value?.data.totalCommissions ?? '') ?? 0) ?? ''}',
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

  // Contact Info Section (Editable)
  Widget _buildContactInfoSection(SellerProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorRes.blueColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.contacts_outlined,
                  color: ColorRes.blueColor[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Contact Info',
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  color: ColorRes.homeBlackFade,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (controller.isEditing.value) ...[
            // Editable form fields
            _buildFormField(
              controller: controller.nameController,
              label: 'First Name',
              icon: Icons.person_outline,
              enabled: true,
              validator:
                  (value) =>
                      value?.isEmpty ?? true ? 'First name is required' : null,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              enabled: true,
              validator:
                  (value) =>
                      value?.isEmpty ?? true ? 'Last name is required' : null,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              enabled: true,
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
              enabled: true,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.positionController,
              label: 'City',
              icon: Icons.location_city_outlined,
              enabled: true,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.companyController,
              label: 'State',
              icon: Icons.location_on_outlined,
              enabled: true,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.addressController,
              label: 'Address',
              icon: Icons.location_city_outlined,
              enabled: true,
            ),

          ] else ...[
            // Read-only display
            _buildInfoRow(
              Icons.person,
              '${controller.profileData.value?.user?.firstName ?? ''} ${controller.profileData.value?.user?.lastName ?? ''}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.email,
              controller.profileData.value?.user?.email ?? '',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.phone,
              controller.profileData.value?.user?.phone ?? '',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              '${controller.profileData.value?.user?.city ?? ''}, ${controller.profileData.value?.user?.state ?? ''}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.apartment_outlined,
              '${controller.profileData.value?.user?.address ?? ''}',
            ),

          ],
        ],
      ),
    );
  }

  // Business Details Section (Editable)
  Widget _buildBusinessDetailsSection(SellerProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorRes.blueColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business_outlined,
                  color: ColorRes.blueColor[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Business Details',
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  color: ColorRes.homeBlackFade,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (controller.isEditing.value) ...[
            // Editable form fields
            _buildFormField(
              controller: controller.contactPersonController,
              label: 'Contact Person',
              icon: Icons.person_outline,
              enabled: true,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.contactPhoneController,
              label: 'Contact Phone',
              icon: Icons.phone_outlined,
              enabled: true,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.companyNameController,
              label: 'Company Name',
              icon: Icons.business,
              enabled: true,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.reraNumberController,
              label: 'RERA Number',
              icon: Icons.assignment,
              enabled: true,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.gstNumberController,
              label: 'GST Number',
              icon: Icons.receipt_long,
              enabled: true,
            ),
          ] else ...[
            // Read-only display
            _buildInfoRow(
              Icons.person_outline,
              controller.resellerProfile.value?.contactName ?? 'Not Set',
              label: 'Contact Person',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.phone_outlined,
              controller.resellerProfile.value?.contactPhone ?? 'Not Set',
              label: 'Contact Phone',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.business,
              controller.resellerProfile.value?.companyName ?? 'Not Set',
              label: 'Company Name',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.assignment,
              controller.resellerProfile.value?.reraNumber ?? 'Not Set',
              label: 'RERA Number',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.receipt_long,
              controller.resellerProfile.value?.gstNumber ?? 'Not Set',
              label: 'GST Number',
            ),
          ],
          // Save/Cancel buttons at bottom when editing
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
    );
  }

  // Seller Details Section (Read-only)
  Widget _buildSellerDetailsSection(SellerProfileController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seller Details',
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'SELLER TYPE',
            controller.resellerProfile.value?.sellerType.toUpperCase() ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'COMPANY NAME',
            controller.resellerProfile.value?.companyName ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'RERA NUMBER',
            controller.resellerProfile.value?.reraNumber ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'GST NUMBER',
            controller.resellerProfile.value?.gstNumber ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'NUMBER OF PROPERTIES',
            controller.resellerProfile.value?.numberOfProperties.toString() ??
                '0',
          ),
        ],
      ),
    );
  }

  // Account Information Section (Read-only)
  Widget _buildAccountInfoSection(SellerProfileController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'CREATED AT',
            controller.resellerProfile.value?.createdAt != null
                ? '${controller.resellerProfile.value!.createdAt?.day} ${_getMonthName(controller.resellerProfile.value!.createdAt!.month)} ${controller.resellerProfile.value!.createdAt?.year}'
                : 'N/A',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'LAST UPDATED',
            controller.resellerProfile.value?.updatedAt != null
                ? '${controller.resellerProfile.value!.updatedAt?.day} ${_getMonthName(controller.resellerProfile.value!.updatedAt!.month)} ${controller.resellerProfile.value!.updatedAt?.year}'
                : 'N/A',
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'USER ID',
            controller.resellerProfile.value?.id ?? 'N/A',
          ),
        ],
      ),
    );
  }

  // Helper method for info rows (with icon)
  Widget _buildInfoRow(IconData icon, String value, {String? label}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ColorRes.leadGreyColor[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    color: ColorRes.leadGreyColor[600],
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: ColorRes.textPrimary,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method for detail rows (label + value)
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

  // Helper to get month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
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
                Get.snackbar(
                  'Success',
                  'Logged out successfully',
                  backgroundColor: ColorRes.success,
                  colorText: ColorRes.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
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
