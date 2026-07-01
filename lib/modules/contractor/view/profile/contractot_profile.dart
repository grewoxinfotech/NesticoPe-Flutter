// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/utils/formater/formater.dart';
// import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:nesticope_app/app/widgets/expandable_tile/expandable_widget.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/data/network/auth/model/user_model.dart';
// import 'package:intl/intl.dart';

// import '../../../../app/constants/app_font_sizes.dart';

// import 'package:get/get.dart';

// import '../../../../utils/shimmer/contractor/profile/contractor_profile_screen_shimmer.dart';
// import '../../../../widgets/input/city_selection_widget.dart';
// import '../../../../widgets/messages/snack_bar.dart';
// import '../../../auth/views/delete_account.dart';
// import '../../../home/views/home_screen/home_screen.dart';
// import '../../../reseller/view/reseller_success_stories/reseller_success_stories.dart';
// import '../../controller/contractor_profile_controller.dart';
// import '../contractor_plan/contractor_plan_screen.dart';
// import '../employee/contractor_employee_screen.dart';
// import '../project/contractor_service.dart';
// import '../widget/my_service_screen.dart';
// import '../widget/contractor_quotation_list_screen.dart';
// import '../../../profile/views/offers_discounts_screen.dart';

// class ContractorProfileScreen extends StatefulWidget {
//   const ContractorProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ContractorProfileScreen> createState() =>
//       _ContractorProfileScreenState();
// }

// class _ContractorProfileScreenState extends State<ContractorProfileScreen> {
//   final profileController = Get.put(ContractorProfileController());

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       profileController.refreshFollowUp();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Profile',
//           style: TextStyle(fontWeight: AppFontWeights.semiBold),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         centerTitle: false,
//         actions: [
//           Obx(
//             () => Container(
//               margin: const EdgeInsets.only(right: 12),
//               child: IconButton(
//                 icon: Icon(
//                   profileController.isEditing.value
//                       ? Icons.check
//                       : Icons.edit_outlined,
//                   size: 22,
//                 ),
//                 onPressed:
//                     profileController.isEditing.value
//                         ? () => profileController.saveProfile()
//                         : () => profileController.toggleEdit(),
//                 style: IconButton.styleFrom(
//                   backgroundColor:
//                       profileController.isEditing.value
//                           ? ColorRes.blueColor.withOpacity(0.1)
//                           : ColorRes.leadGreyColor.withOpacity(0.1),
//                   foregroundColor:
//                       profileController.isEditing.value
//                           ? ColorRes.blueColor
//                           : ColorRes.leadGreyColor[700],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Obx(() {
//           if (profileController.isLoading.value) {
//             return ContractorProfileScreenShimmer();
//           }

//           return RefreshIndicator(
//             onRefresh: profileController.refreshFollowUp,
//             color: ColorRes.primary,
//             child:
//                 (UserHelper.isContractor)
//                     ? SingleChildScrollView(
//                       padding: const EdgeInsets.all(16),
//                       child: Form(
//                         key: profileController.formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Profile Header
//                             _buildProfileHeader(profileController),
//                             const SizedBox(height: 16),

//                             // Download Certificate Button
//                             if (!profileController.isEditing.value)...[
//                               Obx(
//                                 () => _buildDownloadCertificateButton(
//                                   profileController,
//                                 ),
//                               ),],
//                             const SizedBox(height: 16),

//                             // Contact Info Section (Editable)
//                             Obx(
//                               () => _buildContactInfoSection(profileController),
//                             ),
//                             const SizedBox(height: 16),

//                             // Business Details Section (Editable)
//                             if (UserHelper.isSellerBuilder) ...[
//                               Obx(
//                                 () => _buildBusinessDetailsSection(
//                                   profileController,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                             ],

//                             // Seller Details Section (Read-only)
//                             if (!profileController.isEditing.value)
//                               _buildPerformanceInfoSection(profileController),

//                             // Account Information Section (Read-only)
//                             if (!profileController.isEditing.value)
//                               const SizedBox(height: 16),
//                             _buildAccountInfoSection(profileController),
//                             // if (!profileController.isEditing.value)
//                             //   const SizedBox(height: 16),

//                             // Profile Options
//                             if (!profileController.isEditing.value) ...[
//                               // _buildProfileOptionsSection(),
//                               const SizedBox(height: 16),
//                             ],
//                             _buildActionButton(
//                               icon: Icons.local_offer_outlined,
//                               label: "Offers & Discounts",
//                               subtitle: "View and manage your offers and discounts",
//                               onTap: () {
//                                 Get.to(
//                                   () => const OffersDiscountsScreen(
//                                     userType: 'contractor',
//                                   ),
//                                 );
//                               },
//                             ),
//                             _buildActionButton(
//                               icon: Icons.my_library_books_outlined,
//                               label: "Service Categories",
//                               subtitle: "View and manage your service categories",

//                               onTap: () {
//                                 Get.to(() => MyServiceScreen());
//                               },
//                             ),
//                             _buildActionButton(
//                               icon: Icons.miscellaneous_services_outlined,
//                               label: "My Service",
//                               subtitle: "View and manage your services",

//                               onTap: () {
//                                 Get.to(() => ContractorService());
//                               },
//                             ),
//                             _buildActionButton(
//                               icon: Icons.credit_card_outlined,
//                               label: "Plan & Subscription",
//                               subtitle: "View and manage your plan and subscription",

//                               onTap: () {
//                                 Get.to(() => ContractorPlanScreen());
//                               },
//                             ),
//                             _buildActionButton(
//                               icon: Icons.person,
//                               label: "Employees",
//                               subtitle: "View and manage your employees",

//                               onTap: () {
//                                 Get.to(() => ContractorEmployeeScreen());
//                               },
//                             ),
//                             _buildActionButton(
//                               icon: Icons.dashboard_outlined,
//                               label: "Success Story",
//                               subtitle: "View and manage your success stories",

//                               onTap: () {
//                                 Get.to(() => ContractorSuccessStoryScreen());
//                               },
//                             ),
//                             _buildActionButton(
//                               icon: Icons.receipt_long_outlined,
//                               label: "My Quotations",
//                               subtitle: "View and manage your quotations",

//                               onTap: () {
//                                 Get.to(() => ContractorQuotationListScreen());
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                     : SizedBox.shrink(),
//           );
//         }),
//       ),
//     );
//   }

//   // Widget _buildActionButton({
//   //   required IconData icon,
//   //   required String label,

//   //   required VoidCallback onTap,
//   //   Widget? trailing,
//   // }) {
//   //   return GestureDetector(
//   //     onTap: onTap,
//   //     child: ListTile(
//   //       leading: Icon(icon, size: 28, color: ColorRes.primary),
//   //       title: Text(
//   //         label,
//   //         style: TextStyle(
//   //           fontSize: AppFontSizes.medium,
//   //           fontWeight: AppFontWeights.semiBold,
//   //         ),
//   //       ),
//   //       trailing: trailing ?? const Icon(Icons.chevron_right),
//   //       // onTap: onTap,
//   //     ),
//   //   );
//   // }
//    Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required String subtitle,
//     required VoidCallback onTap,
//     Widget? trailing,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.04),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),

//         child: Row(
//           children: [
//             /// ✅ Icon Box
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: ColorRes.primary.withOpacity(.1),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(icon, size: 24, color: ColorRes.primary),
//             ),

//             const SizedBox(width: 14),

//             /// ✅ Text Section
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.caption,
//                       color: ColorRes.leadGreyColor[600],
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// ✅ Arrow
//             trailing ??
//                 Icon(Icons.chevron_right, color: ColorRes.leadGreyColor[400]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader(ContractorProfileController controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(width: 6),
//               Stack(
//                 children: [
//                   Obx(() {
//                     ImageProvider? imageProvider;
//                     final profilePic =
//                         controller.profileData.value?.user?.profilePic;
//                     final selectedImage = controller.selectedImage.value;

//                     // 🔹 Show loader if image upload in progress
//                     if (controller.isLoadingIMage.value) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     bool isNetworkImage = false;
//                     String? imageUrl;

//                     // 1️⃣ If user selected a new image
//                     if (selectedImage != null) {
//                       if (selectedImage is File) {
//                         imageProvider = FileImage(selectedImage);
//                       } else if (selectedImage.toString().startsWith('http')) {
//                         imageUrl = selectedImage.toString();
//                         imageProvider = NetworkImage(imageUrl);
//                         isNetworkImage = true;
//                       }
//                     } else if (profilePic != null && profilePic.isNotEmpty) {
//                       if (profilePic.startsWith('http')) {
//                         imageUrl = profilePic;
//                         imageProvider = NetworkImage(profilePic);
//                         isNetworkImage = true;
//                       } else if (File(profilePic).existsSync()) {
//                         imageProvider = FileImage(File(profilePic));
//                       }
//                     }

//                     return Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: ColorRes.primary, width: 2),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(2.0),
//                         child: ClipOval(
//                           child: SizedBox(
//                             width: 70,
//                             height: 70,
//                             child:
//                                 imageProvider != null
//                                     ? (isNetworkImage
//                                         ? Image.network(
//                                           imageUrl!,
//                                           fit: BoxFit.cover,
//                                           loadingBuilder: (
//                                             context,
//                                             child,
//                                             progress,
//                                           ) {
//                                             if (progress == null) return child;
//                                             return const Center(
//                                               child: SizedBox(
//                                                 width: 25,
//                                                 height: 25,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                       strokeWidth: 2,
//                                                     ),
//                                               ),
//                                             );
//                                           },
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Icon(
//                                                     Icons.person,
//                                                     size: 30,
//                                                   ),
//                                         )
//                                         : Image(
//                                           image: imageProvider,
//                                           fit: BoxFit.cover,
//                                         ))
//                                     : CircleAvatar(
//                                       radius: 35,
//                                       backgroundColor: ColorRes.primary
//                                           .withOpacity(0.1),
//                                       child: Icon(
//                                         Icons.person,
//                                         size: 25,
//                                         color: ColorRes.primary.withOpacity(
//                                           0.8,
//                                         ),
//                                       ),
//                                     ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),

//                   // Obx(() {
//                   //   ImageProvider? imageProvider;
//                   //
//                   //   // ✅ 1. Check if user selected a new local image
//                   //   if (controller.selectedImage.value != null) {
//                   //     imageProvider = FileImage(controller.selectedImage.value!);
//                   //   }
//                   //   // ✅ 2. Else use profilePic from API
//                   //   else {
//                   //     final profilePic = controller.profileData.value?.user?.profilePic;
//                   //
//                   //     if (profilePic != null && profilePic.isNotEmpty) {
//                   //       // ✅ If it's a network URL
//                   //       if (profilePic.startsWith('http') || profilePic.startsWith('https')) {
//                   //         imageProvider = NetworkImage(profilePic);
//                   //       }
//                   //       // ✅ Else if it's a valid local file path
//                   //       else if (File(profilePic).existsSync()) {
//                   //         imageProvider = FileImage(File(profilePic));
//                   //       }
//                   //     }
//                   //   }
//                   //
//                   //   // ✅ 3. Build the circular avatar
//                   //   return Container(
//                   //     decoration: BoxDecoration(
//                   //       shape: BoxShape.circle,
//                   //       border: Border.all(color: ColorRes.primary, width: 2),
//                   //     ),
//                   //     child: Padding(
//                   //       padding: const EdgeInsets.all(2.0),
//                   //       child: CircleAvatar(
//                   //         radius: 35,
//                   //         backgroundColor:
//                   //         imageProvider == null ? ColorRes.primary.withOpacity(0.1) : null,
//                   //         backgroundImage: imageProvider,
//                   //         child: imageProvider == null
//                   //             ? Icon(
//                   //           Icons.person,
//                   //           size: 25,
//                   //           color: ColorRes.primary.withOpacity(0.8),
//                   //         )
//                   //             : null,
//                   //       ),
//                   //     ),
//                   //   );
//                   // }),
//                   if (controller.isEditing.value)
//                     Positioned(
//                       bottom: -2,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: () {
//                           controller.showImagePickerOptions(Get.context!);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: ColorRes.primary,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: ColorRes.white, width: 2),
//                           ),
//                           child: const Icon(
//                             Icons.camera_alt,
//                             color: ColorRes.white,
//                             size: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 16),
//               // Text Info Section
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 140,
//                       child: Text(
//                         ' ${controller.profileData.value?.user?.username ?? ''}',
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: ColorRes.textPrimary,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: ColorRes.primary.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(
//                           color: ColorRes.primary.withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: Text(
//                         '${controller.profileData.value?.user?.userType ?? ''}',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.extraSmall,
//                           color: ColorRes.primary,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 150,
//                           child: Text(
//                             '${controller.profileData.value?.user?.city ?? 'Not Define'} ',
//                             style: TextStyle(
//                               fontSize: AppFontSizes.small,
//                               color: ColorRes.leadGreyColor[600],
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 6),
//           Obx(
//             () => GestureDetector(
//               onTap: () {
//                 if (controller.isEditing.value) {
//                   controller.saveProfile();
//                 } else {
//                   controller.toggleEdit();
//                 }
//               },

//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF4281F6), Color(0xFF1E43FF)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 3,
//                       offset: const Offset(0, 1),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   controller.isEditing.value ? 'Save Changes' : 'Customize',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildAccountHealthCard() {

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Icon Container
//           Container(
//             height: 36,
//             width: 36,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: color.withOpacity(0.2), width: 1),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(height: 8),
//           // Value
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.homeBlackFade,
//                 height: 1.2,
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           // Title
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: AppFontSizes.extraSmall,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.medium,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool enabled = true,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       enabled: enabled,
//       minLines: 1,
//       decoration: InputDecoration(
//         labelText: label,

//         labelStyle: TextStyle(
//           fontSize: AppFontSizes.small,
//           color:
//               enabled
//                   ? ColorRes.leadGreyColor[700]
//                   : ColorRes.leadGreyColor[500],
//         ),
//         prefixIcon: Icon(icon, size: 20, color: ColorRes.leadGreyColor[600]),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: ColorRes.leadGreyColor.withOpacity(0.3),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: ColorRes.leadGreyColor.withOpacity(0.3),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: ColorRes.blueColor, width: 1.5),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: ColorRes.leadGreyColor.withOpacity(0.2),
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: ColorRes.error, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: ColorRes.error, width: 1.5),
//         ),
//         filled: true,
//         fillColor:
//             enabled ? ColorRes.leadGreyColor[50] : ColorRes.leadGreyColor[100],
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//       ),
//       keyboardType: keyboardType,
//       validator: validator,
//       maxLines: maxLines,
//       style: TextStyle(
//         fontSize: AppFontSizes.small,
//         color: ColorRes.homeBlackFade,
//       ),
//     );
//   }

//   // Contact Info Section (Editable)
//   Widget _buildContactInfoSection(ContractorProfileController controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               // Container(
//               //   padding: const EdgeInsets.all(8),
//               //   decoration: BoxDecoration(
//               //     color: ColorRes.blueColor.withOpacity(0.1),
//               //     borderRadius: BorderRadius.circular(8),
//               //   ),
//               //   child: Icon(
//               //     Icons.contacts_outlined,
//               //     color: ColorRes.blueColor[700],
//               //     size: 20,
//               //   ),
//               // ),
//               // const SizedBox(width: 12),
//               Text(
//                 'Personal Info',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.bodyMedium,
//                   fontWeight: AppFontWeights.bold,
//                   color: ColorRes.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // if (controller.isEditing.value) ...[
//           // Editable form fields
//           _buildFormField(
//             controller: controller.nameController,
//             label: 'First Name',
//             icon: Icons.person_outline,
//             enabled: controller.isEditing.value,
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.lastNameController,
//             label: 'Last Name',
//             icon: Icons.person_outline,
//             enabled: controller.isEditing.value,
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.emailController,
//             label: 'Email',
//             icon: Icons.email_outlined,
//             enabled: controller.isEditing.value,
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value?.isEmpty ?? true) return 'Email is required';
//               if (!GetUtils.isEmail(value!)) return 'Enter a valid email';
//               return null;
//             },
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.phoneController,
//             label: 'Phone',
//             icon: Icons.phone_outlined,
//             enabled: controller.isEditing.value,
//             keyboardType: TextInputType.phone,
//             validator: (value) {
//               if (value?.isEmpty ?? true) return 'Phone number is required';
//               return null;
//             },
//           ),
//           const SizedBox(height: 14),
//           // _buildFormField(
//           //   controller: controller.positionController,
//           //   label: 'City',
//           //   icon: Icons.location_city_outlined,
//           //   enabled: controller.isEditing.value,
//           // ),
//           CitySelectionWidget(
//             isEditing: controller.isEditing.value,
//             controller: controller.positionController,
//             iconColor: ColorRes.leadGreyColor.shade600,
//             isRequiredTitle: false,
//             onCitySelected: (selectedCity) {
//               print("✅ Selected city: ${selectedCity.description}");
//               controller.positionController.text =
//                   selectedCity.description ?? '';
//               controller.companyController.text = selectedCity.reference ?? '';
//               // You can also store city details in your controller here
//             },
//           ),
//           const SizedBox(height: 14),
//           // _buildFormField(
//           //   controller: controller.companyController,
//           //   label: 'State',
//           //   icon: Icons.location_on_outlined,
//           //   enabled: true,
//           // ),
//           StateSelectionWidget(
//             isEditing: false,
//             controller: controller.companyController,
//             onCitySelected: (selectedCity) {
//               print("✅ Selected city: ${selectedCity.description}");
//               controller.companyController.text =
//                   selectedCity.description ?? '';
//               // You can also store city details in your controller here
//             },
//           ),

//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.experienceController,
//             label: 'Total Experience',
//             icon: Icons.star_outline,
//             enabled: controller.isEditing.value,
//             keyboardType: TextInputType.phone,
//             validator: (value) {
//               if (value?.isEmpty ?? true) {
//                 return 'Experience is required';
//               }
//               final experience = double.tryParse(value!);
//               if (experience == null) {
//                 return 'Enter a valid number';
//               }
//               if (experience > 60) {
//                 return 'Experience cannot be more than 60 years';
//               }
//               return null;
//             },
//           ),

//           if (controller.isEditing.value) ...[
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: controller.saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorRes.blueColor,
//                       foregroundColor: ColorRes.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child:
//                         controller.isSaving.value
//                             ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 color: ColorRes.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                             : Text(
//                               'Save Changes',
//                               style: TextStyle(
//                                 fontWeight: AppFontWeights.semiBold,
//                                 fontSize: AppFontSizes.bodyMedium,
//                               ),
//                             ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: controller.cancelEdit,
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: ColorRes.leadGreyColor[700],
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       side: BorderSide(
//                         color: ColorRes.leadGreyColor.withOpacity(0.3),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.bodyMedium,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ] /*else ...[
//             // Read-only display
//             _buildInfoRow(
//               Icons.person,
//               '${controller.profileData.value?.user?.firstName ?? ''} ${controller.profileData.value?.user?.lastName ?? ''}',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.email,
//               controller.profileData.value?.user?.email ?? '',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.phone,
//               controller.profileData.value?.user?.phone ?? '',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.location_on,
//               '${controller.profileData.value?.user?.city ?? ''}, ${controller.profileData.value?.user?.state ?? ''}',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.apartment_outlined,
//               '${controller.profileData.value?.user?.address ?? ''}',
//             ),

//           ],*/, //   ],
//       ),
//     );
//   }

//   // Business Details Section (Editable)
//   Widget _buildBusinessDetailsSection(ContractorProfileController controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: ColorRes.blueColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.business_outlined,
//                   color: ColorRes.blueColor[700],
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Business Details',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.bodyMedium,
//                   color: ColorRes.homeBlackFade,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // if (controller.isEditing.value) ...[
//           // Editable form fields
//           _buildFormField(
//             controller: controller.contactPersonController,
//             label: 'Contact Person',
//             icon: Icons.person_outline,
//             enabled: controller.isEditing.value,
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.contactPhoneController,
//             label: 'Contact Phone',
//             icon: Icons.phone_outlined,
//             enabled: controller.isEditing.value,
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.companyNameController,
//             label: 'Company Name',
//             icon: Icons.business,
//             enabled: controller.isEditing.value,
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.reraNumberController,
//             label: 'RERA Number',
//             icon: Icons.assignment,
//             enabled: controller.isEditing.value,
//           ),
//           const SizedBox(height: 14),
//           _buildFormField(
//             controller: controller.gstNumberController,
//             label: 'GST Number',
//             icon: Icons.receipt_long,
//             enabled: controller.isEditing.value,
//           ),
//           /*else ...[
//             // Read-only display
//             _buildInfoRow(
//               Icons.person_outline,
//               controller.resellerProfile.value?.contactName ?? 'Not Set',
//               label: 'Contact Person',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.phone_outlined,
//               controller.resellerProfile.value?.contactPhone ?? 'Not Set',
//               label: 'Contact Phone',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.business,
//               controller.resellerProfile.value?.companyName ?? 'Not Set',
//               label: 'Company Name',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.assignment,
//               controller.resellerProfile.value?.reraNumber ?? 'Not Set',
//               label: 'RERA Number',
//             ),
//             const SizedBox(height: 12),
//             _buildInfoRow(
//               Icons.receipt_long,
//               controller.resellerProfile.value?.gstNumber ?? 'Not Set',
//               label: 'GST Number',
//             ),
//           ],*/
//           // Save/Cancel buttons at bottom when editing
//           if (controller.isEditing.value) ...[
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: controller.saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorRes.blueColor,
//                       foregroundColor: ColorRes.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child:
//                         controller.isSaving.value
//                             ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 color: ColorRes.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                             : Text(
//                               'Save Changes',
//                               style: TextStyle(
//                                 fontWeight: AppFontWeights.semiBold,
//                                 fontSize: AppFontSizes.bodyMedium,
//                               ),
//                             ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: controller.cancelEdit,
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: ColorRes.leadGreyColor[700],
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       side: BorderSide(
//                         color: ColorRes.leadGreyColor.withOpacity(0.3),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.bodyMedium,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // Seller Details Section (Read-only)

//   // Account Information Section (Read-only)
//   Widget _buildAccountInfoSection(ContractorProfileController controller) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Account Information',
//             style: TextStyle(
//               fontSize: AppFontSizes.bodyMedium,
//               fontWeight: AppFontWeights.bold,
//               color: ColorRes.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow(
//                   'CREATED AT',
//                   Formatter.formatDate(
//                     controller.profileData.value?.user?.createdAt,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDetailRow(
//                   'LAST UPDATED',
//                   Formatter.formatDate(
//                     controller.profileData.value?.user?.updatedAt,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               _buildDetailRow(
//                 'Verification Status',
//                 '${(controller.profileData.value?.user?.isVerified ?? true) ? "Verified" : "Not Verified"}',
//               ),
//               const SizedBox(height: 12),
//             ],
//           ),

//           const SizedBox(height: 12),

//           RequestDeleteAccount(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPerformanceInfoSection(ContractorProfileController controller) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: ColorRes.leadGreyColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Performance Overview',
//             style: TextStyle(
//               fontSize: AppFontSizes.bodyMedium,
//               fontWeight: AppFontWeights.bold,
//               color: ColorRes.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildDetailRow(
//                 'Overall Rating',
//                 controller.resellerProfile.value?.overallRating ?? '',
//               ),
//               _buildDetailRow(
//                 'Total Reviews',
//                 controller.resellerProfile.value?.totalReviews.toString() ?? '',
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildDetailRow(
//                 'Total Services',

//                 controller.resellerProfile.value?.totalServices.toString() ??
//                     '',
//               ),
//               _buildDetailRow(
//                 'Active Services',
//                 controller.resellerProfile.value?.activeServices.toString() ??
//                     '',
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildDetailRow(
//                 'Warnings',

//                 controller.resellerProfile.value?.warningCount.toString() ?? '',
//               ),
//               _buildDetailRow(
//                 'Account Status',
//                 (controller.resellerProfile.value?.isBlocked ?? false)
//                     ? 'Inactive'
//                     : 'Active',
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildDetailRow(
//                 'Contractor Type',

//                 controller.resellerProfile.value?.contractorType ??
//                     'Not Provided',
//               ),
//               // _buildDetailRow(
//               //   'Account Status',
//               //   (controller.resellerProfile.value?.isBlocked ?? false)
//               //       ? 'Inactive'
//               //       : 'Active',
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return 'N/A';
//     try {
//       final date = DateTime.parse(dateString);
//       return DateFormat('dd MMM yyyy').format(date); // Example: 01 Dec 2025
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   // Helper method for info rows (with icon)
//   Widget _buildInfoRow(IconData icon, String value, {String? label}) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: ColorRes.leadGreyColor[600]),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (label != null) ...[
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.extraSmall,
//                     color: ColorRes.leadGreyColor[600],
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//               ],
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: AppFontSizes.small,
//                   color: ColorRes.textPrimary,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Helper method for detail rows (label + value)
//   Widget _buildDetailRow(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: AppFontSizes.extraSmall,
//             color: ColorRes.leadGreyColor[600],
//             fontWeight: AppFontWeights.medium,
//             letterSpacing: 0.5,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             color: ColorRes.textPrimary,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDownloadCertificateButton(
//     ContractorProfileController controller,
//   ) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed:
//             controller.isDownloadingCertificate.value
//                 ? null
//                 : controller.downloadCertificate,
//         icon:
//             controller.isDownloadingCertificate.value
//                 ? const SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: ColorRes.white,
//                   ),
//                 )
//                 : const Icon(Icons.file_download_outlined, size: 20),
//         label: Text(
//           controller.isDownloadingCertificate.value
//               ? "Downloading ${(controller.downloadProgress.value * 100).toStringAsFixed(0)}%"
//               : "Download Contractor Certificate",
//           style: TextStyle(
//             fontSize: AppFontSizes.bodySmall,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: ColorRes.primary,

//           foregroundColor: ColorRes.white,
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           elevation: 0,
//         ),
//       ),
//     );
//   }
// }

// // Helper to get month name
// String _getMonthName(int month) {
//   const months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];
//   return months[month - 1];
// }

// Widget _buildProfileOptionsSection() {
//   return Container(
//     decoration: BoxDecoration(
//       color: ColorRes.white,
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(
//         color: ColorRes.leadGreyColor.withOpacity(0.3),
//         width: 1,
//       ),
//     ),
//     child: Column(
//       children: [
//         _buildProfileOption(
//           Icons.notifications_outlined,
//           'Notifications',
//           () {},
//           showDivider: true,
//         ),
//         _buildProfileOption(
//           Icons.security_outlined,
//           'Security',
//           () {},
//           showDivider: true,
//         ),
//         _buildProfileOption(
//           Icons.help_outline,
//           'Help & Support',
//           () {},
//           showDivider: true,
//         ),
//         _buildProfileOption(
//           Icons.logout,
//           'Logout',
//           () => _showLogoutDialog(Get.context!),
//           isLogout: true,
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildProfileOption(
//   IconData icon,
//   String title,
//   VoidCallback onTap, {
//   bool isLogout = false,
//   bool showDivider = false,
// }) {
//   return Column(
//     children: [
//       ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color:
//                 isLogout
//                     ? ColorRes.error.withOpacity(0.1)
//                     : ColorRes.leadGreyColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             icon,
//             color: isLogout ? ColorRes.error : ColorRes.leadGreyColor[700],
//             size: 20,
//           ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontSize: AppFontSizes.bodyMedium,
//             fontWeight: AppFontWeights.medium,
//             color: isLogout ? ColorRes.error : ColorRes.homeBlackFade,
//           ),
//         ),
//         trailing: Icon(
//           Icons.chevron_right,
//           size: 20,
//           color: ColorRes.leadGreyColor[400],
//         ),
//         onTap: onTap,
//       ),
//       if (showDivider)
//         Divider(
//           height: 1,
//           thickness: 1,
//           color: ColorRes.leadGreyColor.withOpacity(0.2),
//           indent: 16,
//           endIndent: 16,
//         ),
//     ],
//   );
// }

// void _showLogoutDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: ColorRes.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Logout',
//           style: TextStyle(
//             fontSize: AppFontSizes.subtitle,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: const Text(
//           'Are you sure you want to logout?',
//           style: TextStyle(
//             fontSize: AppFontSizes.bodyMedium,
//             color: ColorRes.blackShade87,
//           ),
//         ),
//         actions: [
//           // Cancel Button
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 fontSize: AppFontSizes.bodyMedium,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.leadGreyColor[600],
//               ),
//             ),
//           ),

//           // Logout Button
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();

//               NesticoPeSnackBar.showAwesomeSnackbar(
//                 title: 'Success',
//                 message: 'Logged out successfully',
//                 contentType: ContentType.success,
//               );
//             },
//             child: Text(
//               'Logout',
//               style: TextStyle(
//                 fontSize: AppFontSizes.bodyMedium,
//                 fontWeight: AppFontWeights.extraBold,
//                 color: ColorRes.error,
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/widgets/expandable_tile/expandable_widget.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/calender/views/calender_screen.dart';
import 'package:nesticope_app/modules/in_app_message/view/in_app_message_screen.dart';
import 'package:nesticope_app/modules/referral/view/referral_dashboard.dart';
import 'package:nesticope_app/modules/review/controllers/review_controller.dart';
import 'package:nesticope_app/modules/review/views/widget/add_app_review_screen.dart';
import 'package:nesticope_app/modules/review/views/widget/app_review_card.dart';
import 'package:nesticope_app/modules/subscription/views/my_subscription_screen.dart';
import 'package:nesticope_app/modules/support_ticket/controllers/chat_socket_controller.dart';
import 'package:nesticope_app/modules/support_ticket/views/support_ticket_screen.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:intl/intl.dart';

import '../../../../app/constants/app_font_sizes.dart';

import 'package:get/get.dart';

import '../../../../utils/shimmer/contractor/profile/contractor_profile_screen_shimmer.dart';
import '../../../../widgets/input/city_selection_widget.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../auth/views/delete_account.dart';
import '../../../home/views/home_screen/home_screen.dart';
import '../../../reseller/view/reseller_success_stories/reseller_success_stories.dart';
import '../../controller/contractor_dashboard_controller.dart';
import '../../controller/contractor_profile_controller.dart';
import '../contractor_plan/contractor_plan_screen.dart';
import '../employee/contractor_employee_screen.dart';
import '../project/contractor_service.dart';
import '../widget/my_service_screen.dart';
import '../widget/contractor_quotation_list_screen.dart';
import '../../../profile/views/offers_discounts_screen.dart';

class ContractorProfileScreen extends StatefulWidget {
  const ContractorProfileScreen({Key? key}) : super(key: key);

  @override
  State<ContractorProfileScreen> createState() =>
      _ContractorProfileScreenState();
}

class _ContractorProfileScreenState extends State<ContractorProfileScreen> {
  final profileController = Get.put(ContractorProfileController());
  late final ContractorDashboardController dashboardController;

  @override
  void initState() {
    super.initState();
    dashboardController =
        Get.isRegistered<ContractorDashboardController>()
            ? Get.find<ContractorDashboardController>()
            : Get.put(ContractorDashboardController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.refreshFollowUp();
      dashboardController.fetchActiveSubscription(showDialogWhenMissing: false);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  color: const Color(0xFF6B7280),
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
              return ContractorProfileScreenShimmer();
            }
            return RefreshIndicator(
              onRefresh: profileController.refreshFollowUp,
              color: ColorRes.primary,
              child:
                  (UserHelper.isContractor)
                      ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Form(
                          key: profileController.formKey,
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
                                        ? _buildContactInfoEditSection(
                                          profileController,
                                        )
                                        : _buildPersonalInfoCard(
                                          profileController,
                                        ),
                              ),
                              const SizedBox(height: 20),
                              if (!profileController.isEditing.value) ...[
                                _buildSectionTitle('Performance Overview'),
                                const SizedBox(height: 10),
                                _buildPerformanceCard(profileController),
                                const SizedBox(height: 20),
                                _buildSectionTitle('Account Information'),
                                const SizedBox(height: 10),
                                _buildAccountInfoCard(profileController),
                                const SizedBox(height: 20),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.local_offer_outlined,
                                    iconColor: const Color(0xFF6366F1),
                                    iconBg: const Color(0xFFEEF2FF),
                                    label: 'Offers & Discounts',
                                    subtitle:
                                        'View and manage your active promos',
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(
                                          () => const OffersDiscountsScreen(
                                            userType: 'contractor',
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildActionTile(
                                  icon: Icons.credit_card_outlined,
                                  iconColor: const Color(0xFF0EA5E9),
                                  iconBg: const Color(0xFFE0F2FE),
                                  label: 'Plan & Subscription',
                                  subtitle: 'Membership details and billing',
                                  onTap:
                                      () =>
                                          Get.to(() => ContractorPlanScreen()),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.my_library_books_outlined,
                                    iconColor: const Color(0xFF10B981),
                                    iconBg: const Color(0xFFD1FAE5),
                                    label: 'Service Categories',
                                    subtitle:
                                        'View and manage your service categories',
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(() => MyServiceScreen()),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.notifications_outlined,
                                    iconColor: const Color(0xFF6366F1),
                                    iconBg: const Color(0xFFEEF2FF),
                                    label: "Notifications",
                                    subtitle: "Notifications and messages",
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () =>
                                            Get.to(() => InAppMessageScreen()),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildActionTile(
                                  icon: Icons.workspace_premium,
                                  iconColor: const Color(0xFF6366F1),
                                  iconBg: const Color(0xFFEEF2FF),
                                  label: "My Subscription",
                                  subtitle: "Track your Subscription",
                                  onTap:
                                      () =>
                                          Get.to(() => MySubscriptionScreen()),
                                ),

                                const SizedBox(height: 10),
                                _buildActionTile(
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
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.event_available,
                                    iconColor: const Color(0xFF6366F1),
                                    iconBg: const Color(0xFFEEF2FF),
                                    label: "Events",
                                    subtitle: "Upcoming events",
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap: () => Get.to(() => CalendarScreen()),
                                  ),
                                ),

                                // const SizedBox(height: 16),
                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.card_giftcard,
                                    iconColor: const Color(0xFF6366F1),
                                    iconBg: const Color(0xFFEEF2FF),
                                    label: "Referral",
                                    subtitle: "Refer And Earn",
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(
                                          () => ReferralProgramScreen(),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(() {
                                  final controller = Get.put(
                                    ReviewController(),
                                  );
                                  final review = controller.appReview.value;
                                  final hasActivePlan =
                                      dashboardController
                                          .activeSubscription
                                          .value !=
                                      null;

                                  if (review == null) {
                                    return _buildActionTile(
                                      icon: Icons.reviews_outlined,
                                      label: "Reviews and Ratings",
                                      iconColor: const Color(0xFFEC4899),
                                      iconBg: const Color(0xFFFCE7F3),
                                      subtitle: "Add your review",
                                      enabled: hasActivePlan,
                                      onTap: () {
                                        Get.dialog(AddAppReviewDialog()).then((
                                          _,
                                        ) {
                                          controller.getAppReview();
                                        });
                                      },
                                    );
                                  } else {
                                    final widget = _buildReviewSection(review);
                                    return AbsorbPointer(
                                      absorbing: !hasActivePlan,
                                      child: Opacity(
                                        opacity: hasActivePlan ? 1 : 0.45,
                                        child: widget,
                                      ),
                                    );
                                  }
                                }),

                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.miscellaneous_services_outlined,
                                    iconColor: const Color(0xFFF59E0B),
                                    iconBg: const Color(0xFFFEF3C7),
                                    label: 'My Service',
                                    subtitle: 'View and manage your services',
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(() => ContractorService()),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.person_outline,
                                    iconColor: const Color(0xFF8B5CF6),
                                    iconBg: const Color(0xFFEDE9FE),
                                    label: 'Employees',
                                    subtitle: 'View and manage your employees',
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(
                                          () => ContractorEmployeeScreen(),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.dashboard_outlined,
                                    iconColor: const Color(0xFFEC4899),
                                    iconBg: const Color(0xFFFCE7F3),
                                    label: 'Success Story',
                                    subtitle:
                                        'View and manage your success stories',
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(
                                          () => ContractorSuccessStoryScreen(),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => _buildActionTile(
                                    icon: Icons.receipt_long_outlined,
                                    iconColor: const Color(0xFF14B8A6),
                                    iconBg: const Color(0xFFCCFBF1),
                                    label: 'My Quotations',
                                    subtitle: 'View and manage your quotations',
                                    enabled:
                                        dashboardController
                                            .activeSubscription
                                            .value !=
                                        null,
                                    onTap:
                                        () => Get.to(
                                          () => ContractorQuotationListScreen(),
                                        ),
                                  ),
                                ),
                                // const SizedBox(height: 24),
                              ],
                            ],
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            );
          }),
          Obx(() {
            final show = profileController.isSaving.value;
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
            final show = profileController.isSaving.value;
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

  Widget _buildReviewSection(ReviewItem review) {
    return ExpandableTile(
      title: "Reviews and Ratings",
      subtitle: "See your reviews",
      leadingIcon: Icons.reviews,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      children: [AppReviewCard(review: review)],
    );
  }

  // ─────────────────────────────────────────────
  // PROFILE HEADER  (matches screenshot exactly)
  // ─────────────────────────────────────────────
  Widget _buildProfileHeader(ContractorProfileController controller) {
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

                ImageProvider? imageProvider;
                String? imageUrl;
                bool isNetwork = false;

                if (selectedImage != null) {
                  if (selectedImage is File) {
                    imageProvider = FileImage(selectedImage);
                  } else if (selectedImage.toString().startsWith('http')) {
                    imageUrl = selectedImage.toString();
                    imageProvider = NetworkImage(imageUrl);
                    isNetwork = true;
                  }
                } else if (profilePic != null && profilePic.isNotEmpty) {
                  if (profilePic.startsWith('http')) {
                    imageUrl = profilePic;
                    imageProvider = NetworkImage(profilePic);
                    isNetwork = true;
                  } else if (File(profilePic).existsSync()) {
                    imageProvider = FileImage(File(profilePic));
                  }
                }

                Widget imageWidget;
                if (imageProvider != null) {
                  imageWidget =
                      isNetwork
                          ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                            loadingBuilder:
                                (ctx, child, prog) =>
                                    prog == null
                                        ? child
                                        : const CircularProgressIndicator(),
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.person, size: 40),
                          )
                          : Image(
                            image: imageProvider,
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
              controller.profileData.value?.user?.username?.capitalize
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

  // ─────────────────────────────────────────────
  // SECTION TITLE
  // ─────────────────────────────────────────────
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

  // ─────────────────────────────────────────────
  // PERSONAL INFO CARD (read-only, matches screenshot)
  // ─────────────────────────────────────────────
  Widget _buildPersonalInfoCard(ContractorProfileController controller) {
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

  // ─────────────────────────────────────────────
  // PERFORMANCE CARD  (2×2 grid style)
  // ─────────────────────────────────────────────
  Widget _buildPerformanceCard(ContractorProfileController controller) {
    final profile = controller.resellerProfile.value;
    return Column(
      children: [
        // Row 1
        Row(
          children: [
            Expanded(
              child: _perfCell(
                label: 'Overall Rating',
                value: profile?.overallRating ?? '0.00',
                valueWidget: Row(
                  children: [
                    Text(
                      Formatter.formatNumber(
                        num.tryParse(profile?.overallRating ?? '0.00') ?? 0.0,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _perfCell(
                label: 'Total Reviews',
                value: Formatter.formatNumber(profile?.totalReviews ?? 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2
        Row(
          children: [
            Expanded(
              child: _perfCell(
                label: 'Active Services',
                value: Formatter.formatNumber(profile?.activeServices ?? 0),
                valueColor: ColorRes.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _perfCell(
                label: 'Account Status',
                valueWidget: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            (profile?.isBlocked ?? false)
                                ? ColorRes.error
                                : ColorRes.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (profile?.isBlocked ?? false) ? 'Inactive' : 'Active',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: AppFontWeights.semiBold,
                        color:
                            (profile?.isBlocked ?? false)
                                ? ColorRes.error
                                : ColorRes.success,
                      ),
                    ),
                  ],
                ),
                value: '',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2
        Row(
          children: [
            Expanded(
              child: _perfCell(
                label: 'Total Services',
                value: Formatter.formatNumber(profile?.totalServices ?? 0),
                valueColor: ColorRes.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _perfCell(
                label: 'Warnings',
                value: Formatter.formatNumber(profile?.warningCount ?? 0),
                valueColor: ColorRes.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        // Row 3 — Contractor Type full width
        Container(
          padding: EdgeInsets.all(14),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contractor Type',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 155, 161, 172),
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.contractorType?.toLowerCase() == 'labour'
                        ? 'Worker'
                        : profile?.contractorType ?? 'Not Provided',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ],
              ),
              // C/O badge example matching screenshot
              Row(children: [_typeBadge('C'), _typeBadge('O')]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _typeBadge(String letter) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _perfCell({
    required String label,
    required String value,
    Widget? valueWidget,
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
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
            style: TextStyle(
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

  // ─────────────────────────────────────────────
  // ACCOUNT INFORMATION CARD (dark bg)
  // ─────────────────────────────────────────────
  Widget _buildAccountInfoCard(ContractorProfileController controller) {
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

  // ─────────────────────────────────────────────
  // ACTION TILE
  // ─────────────────────────────────────────────
  Widget _buildActionTile({
    required IconData icon,
    Color? iconColor,
    Color? iconBg,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey.shade100,
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
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DELETE ACCOUNT BUTTON
  // ─────────────────────────────────────────────
  Widget _buildDeleteAccountButton() {
    return Container(
      decoration: BoxDecoration(
        // color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const RequestDeleteAccount(),
    );
  }

  // ─────────────────────────────────────────────
  // EDIT MODE — Contact Info Section
  // ─────────────────────────────────────────────
  Widget _buildContactInfoEditSection(ContractorProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 12),
          _buildFormField(
            controller: controller.nameController,
            label: 'First Name',
            icon: Icons.person_outline,
            enabled: true,
          ),
          const SizedBox(height: 12),
          _buildFormField(
            controller: controller.lastNameController,
            label: 'Last Name',
            icon: Icons.person_outline,
            enabled: true,
          ),
          const SizedBox(height: 12),
          _buildFormField(
            controller: controller.emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            enabled: true,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Email is required';
              if (!GetUtils.isEmail(v!)) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildFormField(
            controller: controller.phoneController,
            label: 'Phone',
            icon: Icons.phone_outlined,
            enabled: true,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Phone is required';
              return null;
            },
          ),
          const SizedBox(height: 12),
          CitySelectionWidget(
            isEditing: true,
            controller: controller.positionController,
            iconColor: const Color(0xFF9CA3AF),
            isRequiredTitle: false,
            onCitySelected: (c) {
              controller.positionController.text = c.description ?? '';
              controller.companyController.text = c.reference ?? '';
            },
          ),
          const SizedBox(height: 12),
          StateSelectionWidget(
            isEditing: false,
            controller: controller.companyController,
            onCitySelected: (c) {
              controller.companyController.text = c.description ?? '';
            },
          ),
          const SizedBox(height: 12),
          _buildFormField(
            controller: controller.experienceController,
            label: 'Total Experience',
            icon: Icons.star_outline,
            enabled: true,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Experience required';
              final e = double.tryParse(v!);
              if (e == null) return 'Enter a valid number';
              if (e > 60) return 'Cannot be more than 60 years';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(
                    () =>
                        controller.isSaving.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.cancelEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7280),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
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
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: enabled ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
        ),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF9CA3AF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        filled: true,
        fillColor: enabled ? const Color(0xFFF9FAFB) : const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

// ─── Helpers (top-level, unchanged) ───────────────────────────────────────────

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
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLogout ? const Color(0xFFFEF2F2) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF1A1A2E),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 20,
          color: Color(0xFFD1D5DB),
        ),
        onTap: onTap,
      ),
      if (showDivider)
        const Divider(
          height: 1,
          color: Color(0xFFF3F4F6),
          indent: 16,
          endIndent: 16,
        ),
    ],
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                NesticoPeSnackBar.showAwesomeSnackbar(
                  title: 'Success',
                  message: 'Logged out successfully',
                  contentType: ContentType.success,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ),
  );
}
