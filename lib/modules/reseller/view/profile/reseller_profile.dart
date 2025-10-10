// import 'package:flutter/material.dart';
//
// import '../../controller/profile/profile_controller.dart';
// import 'package:get/get.dart';
//
// class ResellerProfileScreen extends StatelessWidget {
//   const ResellerProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final profileController = Get.put(ProfileController());
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         actions: [
//           Obx(() => IconButton(
//             icon: Icon(profileController.isEditing.value ? Icons.save : Icons.edit),
//             onPressed: profileController.isEditing.value
//                 ? () => profileController.saveProfile()
//                 : () => profileController.toggleEdit(),
//           )),
//         ],
//       ),
//       body: Obx(() {
//         if (profileController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Profile Header
//               _buildProfileHeader(profileController),
//               const SizedBox(height: 24),
//
//               // Statistics Cards
//               _buildStatisticsCards(profileController),
//               const SizedBox(height: 24),
//
//               // Profile Information Form
//               _buildProfileForm(profileController),
//               const SizedBox(height: 24),
//
//               // Profile Options
//               if (!profileController.isEditing.value) ...[
//                 _buildProfileOption(Icons.notifications, 'Notifications', () {}),
//                 _buildProfileOption(Icons.security, 'Security', () {}),
//                 _buildProfileOption(Icons.help, 'Help & Support', () {}),
//                 _buildProfileOption(Icons.logout, 'Logout', () => _showLogoutDialog(), isLogout: true),
//               ],
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildProfileHeader(ProfileController controller) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.blue,
//                 backgroundImage: controller.profile.value.avatarUrl.isNotEmpty
//                     ? NetworkImage(controller.profile.value.avatarUrl)
//                     : null,
//                 child: controller.profile.value.avatarUrl.isEmpty
//                     ? const Icon(Icons.person, size: 50, color: ColorRes.white)
//                     : null,
//               ),
//               if (controller.isEditing.value)
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: const BoxDecoration(
//                       color: Colors.blue,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.camera_alt,
//                       color: ColorRes.white,
//                       size: 16,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             controller.profile.value.name,
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             controller.profile.value.position,
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           ),
//           Text(
//             controller.profile.value.company,
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatisticsCards(ProfileController controller) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total Sales',
//             '\$${controller.profile.value.totalSales.toStringAsFixed(0)}',
//             Icons.attach_money,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: _buildStatCard(
//             'Leads Closed',
//             '${controller.profile.value.leadsCount}',
//             Icons.people,
//             Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: _buildStatCard(
//             'Rating',
//             '${controller.profile.value.rating}',
//             Icons.star,
//             Colors.orange,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileForm(ProfileController controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Form(
//         key: controller.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Profile Information',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             _buildFormField(
//               controller: controller.nameController,
//               label: 'Full Name',
//               icon: Icons.person,
//               enabled: controller.isEditing.value,
//               validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
//             ),
//             const SizedBox(height: 16),
//             _buildFormField(
//               controller: controller.emailController,
//               label: 'Email',
//               icon: Icons.email,
//               enabled: controller.isEditing.value,
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value?.isEmpty ?? true) return 'Email is required';
//                 if (!GetUtils.isEmail(value!)) return 'Enter a valid email';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildFormField(
//               controller: controller.phoneController,
//               label: 'Phone',
//               icon: Icons.phone,
//               enabled: controller.isEditing.value,
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             _buildFormField(
//               controller: controller.positionController,
//               label: 'Position',
//               icon: Icons.work,
//               enabled: controller.isEditing.value,
//             ),
//             const SizedBox(height: 16),
//             _buildFormField(
//               controller: controller.companyController,
//               label: 'Company',
//               icon: Icons.business,
//               enabled: controller.isEditing.value,
//             ),
//             const SizedBox(height: 16),
//             _buildFormField(
//               controller: controller.bioController,
//               label: 'Bio',
//               icon: Icons.info,
//               enabled: controller.isEditing.value,
//               maxLines: 3,
//             ),
//             if (controller.isEditing.value) ...[
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: controller.saveProfile,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: ColorRes.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: controller.isSaving.value
//                           ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: ColorRes.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                           : const Text('Save Changes'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: controller.cancelEdit,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey,
//                         foregroundColor: ColorRes.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
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
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         filled: !enabled,
//         fillColor: enabled ? null : Colors.grey[100],
//       ),
//       keyboardType: keyboardType,
//       validator: validator,
//       maxLines: maxLines,
//     );
//   }
//
//   Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: isLogout ? Colors.red : Colors.grey[700]),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: isLogout ? Colors.red : Colors.black87,
//           ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   void _showLogoutDialog() {
//     Get.defaultDialog(
//       title: 'Logout',
//       content: const Text('Are you sure you want to logout?'),
//       textConfirm: 'Yes',
//       textCancel: 'No',
//       confirmTextColor: ColorRes.white,
//       buttonColor: Colors.red,
//       onConfirm: () {
//         Get.back();
//         Get.snackbar('Success', 'Logged out successfully',
//             backgroundColor: Colors.green, colorText: ColorRes.white);
//       },
//     );
//   }
// }













import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';

import '../../controller/profile/profile_controller.dart';
import 'package:get/get.dart';

class ResellerProfileScreen extends StatelessWidget {
  const ResellerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor:ColorRes.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Obx(() => Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(
                profileController.isEditing.value ? Icons.check : Icons.edit_outlined,
                size: 22,
              ),
              onPressed: profileController.isEditing.value
                  ? () => profileController.saveProfile()
                  : () => profileController.toggleEdit(),
              style: IconButton.styleFrom(
                backgroundColor: profileController.isEditing.value
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                foregroundColor: profileController.isEditing.value
                    ? Colors.blue
                    : Colors.grey[700],
              ),
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(profileController),
              const SizedBox(height: 16),

              // Statistics Cards
              _buildStatisticsCards(profileController),
              const SizedBox(height: 16),

              // Profile Information Form
              _buildProfileForm(profileController),
              const SizedBox(height: 16),

              // Profile Options
              if (!profileController.isEditing.value) ...[
                _buildProfileOptionsSection(),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      }),
    );
  }

  // Widget _buildProfileHeader(ProfileController controller) {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: ColorRes.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: Colors.grey.withOpacity(0.3),
  //         width: 1,
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         Stack(
  //           children: [
  //             Obx(() {
  //               ImageProvider? imageProvider;
  //
  //               // Priority: selectedImage > avatarUrl > null
  //               if (controller.selectedImage.value != null) {
  //                 imageProvider = FileImage(controller.selectedImage.value!);
  //               } else if (controller.profile.value.avatarUrl.isNotEmpty) {
  //                 imageProvider = NetworkImage(controller.profile.value.avatarUrl);
  //               }
  //
  //               return Container(
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(
  //                     color: ColorRes.primary.withOpacity(0.2),
  //                     width: 3,
  //                   ),
  //                 ),
  //                 child: CircleAvatar(
  //                   radius: 35,
  //                   backgroundColor: ColorRes.primary.withOpacity(0.1),
  //                   backgroundImage: imageProvider,
  //                   child: imageProvider == null
  //                       ? Icon(
  //                     Icons.person,
  //                     size: 25,
  //                     color: ColorRes.primary.withOpacity(0.8),
  //                   )
  //                       : null,
  //                 ),
  //               );
  //             }),
  //             if (controller.isEditing.value)
  //               Positioned(
  //
  //                 bottom:-2,
  //                 right: 0,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     controller.showImagePickerOptions(Get.context!);
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.primary,
  //                       shape: BoxShape.circle,
  //                       border: Border.all(color: ColorRes.white, width: 3),
  //                     ),
  //                     child: const Icon(
  //                       Icons.camera_alt,
  //                       color: ColorRes.white,
  //                       size: 14,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           controller.profile.value.name,
  //           style: const TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF1A1A1A),
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 6),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //           decoration: BoxDecoration(
  //             color: ColorRes.primary.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(
  //               color: ColorRes.primary.withOpacity(0.3),
  //               width: 1,
  //             ),
  //           ),
  //           child: Text(
  //             controller.profile.value.position,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color:ColorRes.primary.withOpacity(0.8),
  //               fontWeight: FontWeight.w500,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.business_outlined, size: 14, color: Colors.grey[600]),
  //             const SizedBox(width: 4),
  //             Text(
  //               controller.profile.value.company,
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.grey[600],
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }


  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
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

                // Priority: selectedImage > avatarUrl > null
                if (controller.selectedImage.value != null) {
                  imageProvider = FileImage(controller.selectedImage.value!);
                } else if (controller.profile.value.avatarUrl.isNotEmpty) {
                  imageProvider = NetworkImage(controller.profile.value.avatarUrl);
                }

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorRes.primary,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: ColorRes.primary.withOpacity(0.1),
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
                  width:150,
                  child: Text(
                    controller.profile.value.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: ColorRes.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    controller.profile.value.position,
                    style: TextStyle(
                      fontSize: 10,
                      color: ColorRes.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.business_outlined,
                        size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 150,
                      child: Text(
                        '${controller.profile.value.company}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500
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




  Widget _buildStatisticsCards(ProfileController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Sales',
            '${Formatter.formatPrice(controller.profile.value.totalSales)}',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Leads',
            '${controller.profile.value.leadsCount}',
            Icons.people_alt_outlined,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Rating',
            '${controller.profile.value.rating}',
            Icons.star_rounded,
            Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
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
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          // Value
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person_outline, color: Colors.blue[700], size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField(
              controller: controller.nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              enabled: controller.isEditing.value,
              validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
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
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.positionController,
              label: 'Position',
              icon: Icons.work_outline,
              enabled: controller.isEditing.value,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.companyController,
              label: 'Company',
              icon: Icons.business_outlined,
              enabled: controller.isEditing.value,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.bioController,
              label: 'Bio',
              icon: Icons.info_outline,
              enabled: controller.isEditing.value,
              maxLines: 3,
            ),
            if (controller.isEditing.value) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: ColorRes.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isSaving.value
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: ColorRes.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.cancelEdit,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
          fontSize: 12,
          color: enabled ? Colors.grey[700] : Colors.grey[500],

        ),
        prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        filled: true,
        fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 12, color: Color(0xFF1A1A1A)),
    );
  }

  Widget _buildProfileOptionsSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProfileOption(Icons.notifications_outlined, 'Notifications', () {}, showDivider: true),
          _buildProfileOption(Icons.security_outlined, 'Security', () {}, showDivider: true),
          _buildProfileOption(Icons.help_outline, 'Help & Support', () {}, showDivider: true),
          _buildProfileOption(Icons.logout, 'Logout', () => _showLogoutDialog(Get.context!), isLogout: true),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false, bool showDivider = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLogout ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isLogout ? Colors.red : Colors.grey[700],
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isLogout ? Colors.red : const Color(0xFF1A1A1A),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey[400],
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.withOpacity(0.2),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
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
                  backgroundColor: Colors.green,
                  colorText: ColorRes.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}