import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/app/widgets/expandable_tile/expandable_widget.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../home/views/home_screen/home_screen.dart';
import '../../controller/fack_lead_controller/fack_lead_controller.dart';
import '../../controller/profile/profile_controller.dart';
import 'package:get/get.dart';

class ResellerProfileScreen extends StatelessWidget {
  const ResellerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

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
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return (UserHelper.isReseller)
            ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(profileController),
                  const SizedBox(height: 16),

                  // Statistics Cards
                  _buildStatisticsCards(profileController),
                  const SizedBox(height: 16),

                  _buildLeadOverView(),
                  const SizedBox(height: 16),

                  // Profile Information Form
                  Obx(() => _buildProfileForm(profileController)),
                  const SizedBox(height: 16),

                  // Profile Options
                  if (!profileController.isEditing.value) ...[
                    // _buildProfileOptionsSection(),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            )
            : SizedBox.shrink();
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
  //         color: ColorRes.leadGreyColor.withOpacity(0.3),
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
  //               fontWeight: AppFontWeights.medium,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.business_outlined, size: 14, color: ColorRes.leadGreyColor[600]),
  //             const SizedBox(width: 4),
  //             Text(
  //               controller.profile.value.company,
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: ColorRes.leadGreyColor[600],
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
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              // Obx(() {
              //   ImageProvider? imageProvider;
              //
              //   // ✅ 1. Check if user selected a new local image
              //   if (controller.selectedImage.value != null) {
              //     imageProvider = FileImage(controller.selectedImage.value!);
              //   }
              //   // ✅ 2. Else use profilePic from API
              //   else {
              //     final profilePic = controller.profileData.value?.user?.profilePic;
              //
              //     if (profilePic != null && profilePic.isNotEmpty) {
              //       // ✅ If it's a network URL
              //       if (profilePic.startsWith('http') || profilePic.startsWith('https')) {
              //         imageProvider = NetworkImage(profilePic);
              //       }
              //       // ✅ Else if it's a valid local file path
              //       else if (File(profilePic).existsSync()) {
              //         imageProvider = FileImage(File(profilePic));
              //       }
              //     }
              //   }
              //
              //   // ✅ 3. Build the circular avatar
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
              //         imageProvider == null ? ColorRes.primary.withOpacity(0.1) : null,
              //         backgroundImage: imageProvider,
              //         child: imageProvider == null
              //             ? Icon(
              //           Icons.person,
              //           size: 25,
              //           color: ColorRes.primary.withOpacity(0.8),
              //         )
              //             : null,
              //       ),
              //     ),
              //   );
              // }),
              Obx(() {
                ImageProvider? imageProvider;
                final profilePic = controller.profileData.value?.user?.profilePic;
                final selectedImage = controller.selectedImage.value;

                // 🔹 Show loader if image upload in progress
                if (controller.isLoadingIMage.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                bool isNetworkImage = false;
                String? imageUrl;

                // 1️⃣ If user selected a new image
                if (selectedImage != null) {
                  if (selectedImage is File) {
                    imageProvider = FileImage(selectedImage);
                  } else if (selectedImage.toString().startsWith('http')) {
                    imageUrl = selectedImage.toString();
                    imageProvider = NetworkImage(imageUrl);
                    isNetworkImage = true;
                  }
                }


                else if (profilePic != null && profilePic.isNotEmpty) {
                  if (profilePic.startsWith('http')) {
                    imageUrl = profilePic;
                    imageProvider = NetworkImage(profilePic);
                    isNetworkImage = true;
                  } else if (File(profilePic).existsSync()) {
                    imageProvider = FileImage(File(profilePic));
                  }
                }

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorRes.primary, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipOval(
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: imageProvider != null
                            ? (isNetworkImage
                            ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 30),
                        )
                            : Image(image: imageProvider, fit: BoxFit.cover))
                            : CircleAvatar(
                          radius: 35,
                          backgroundColor: ColorRes.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 25,
                            color: ColorRes.primary.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Obx(() {
              //   ImageProvider? imageProvider;
              //
              //   // Priority: selectedImage > avatarUrl > null
              //   if (controller.selectedImage.value != null) {
              //     // If user selected a new image from gallery/camera
              //     imageProvider = FileImage(controller.selectedImage.value!);
              //   } else if (controller
              //       .profileData
              //       .value
              //       ?.user
              //       ?.profilePic
              //       ?.isNotEmpty ??
              //       false) {
              //     // If profile pic URL exists from API
              //     imageProvider = FileImage(
              //       File(controller.profileData.value!.user!.profilePic!),
              //     );
              //   }
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
          border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
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
                          label: 'TOTAL FAKE LEADS',
                          value: stats.totalFakeLeads.toString(),
                          valueColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildLeadStatCard(
                          label: 'RECENT FAKE LEADS',
                          value: stats.recentFakeLeads.toString(),
                          valueColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildLeadStatCard(
                    label: 'ACCOUNT STATUS',
                    value: stats.isCurrentlyBlocked ? "Blocked" : "Not Blocked",
                    valueColor:
                        stats.isCurrentlyBlocked ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildAccountHealthCard(
                    remainingWarnings: stats.remainingBeforeBlock,
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: ColorRes.leadGreyColor.withOpacity(0.3),
              indent: 12,
              endIndent: 12,
            ),
            const SizedBox(height: 16),

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
                    const Text(
                      'No fake lead reports yet.',
                      style: TextStyle(color: Colors.grey),
                    )
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
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLeadStatCard({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      width: double.infinity,
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
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAccountHealthCard() {
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
  //             Container(
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
  //             const SizedBox(width: 8),
  //             Text(
  //               '(3 more to block)',
  //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorRes.blueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: ColorRes.blueColor[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    color: ColorRes.homeBlackFade,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFormField(
              controller: controller.nameController,
              label: 'Fist Name',
              icon: Icons.person_outline,
              enabled: controller.isEditing.value,
              validator:
                  (value) => value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _buildFormField(
              controller: controller.lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              enabled: controller.isEditing.value,
              validator:
                  (value) => value?.isEmpty ?? true ? 'Name is required' : null,
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
            // _buildFormField(
            //   controller: controller.positionController,
            //   label: 'City',
            //   icon: Icons.location_on_outlined,
            //   enabled: controller.isEditing.value,
            // ),
            CitySelectionWidget(
              isEditing: controller.isEditing.value,
              controller: controller.positionController,
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
            // const SizedBox(height: 14),
            // _buildFormField(
            //   controller: controller.bioController,
            //   label: 'Bio',
            //   icon: Icons.info_outline,
            //   enabled: controller.isEditing.value,
            //   maxLines: 3,
            // ),
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
