import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:housing_flutter_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:housing_flutter_app/modules/profile/model/seller_profile.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/property/controllers/top_seller_property_controller.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/seller/view/widget/seller_property_list.dart';

import '../../../app/widgets/image/custom_image.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../property/controllers/top_seller_profile_controller.dart';
import '../../property/controllers/top_seller_project_controller.dart';
import '../../reseller/view/listing/property_listing.dart';

// /// --- DATA MODEL ---
// class AgentProfile {
//   final String name;
//   final bool isOwner;
//   final String logoUrl;
//   final String badgeText;
//   final String buyersServed;
//   final String listings;
//   final String description;
//   final List<InfoTileData> infoTiles;
//   final List<String> areas;
//   final List<Map<String, dynamic>> categories;
//   final List<AgentTagData> tags;
//
//   /// --- Visibility flags ---
//   final bool showTags;
//   final bool showAreas;
//   final bool showActiveProperties;
//   final bool showSellerPropertyList;
//
//   AgentProfile({
//     required this.name,
//     required this.logoUrl,
//     required this.badgeText,
//     required this.buyersServed,
//     required this.isOwner,
//     required this.listings,
//     required this.description,
//     required this.infoTiles,
//     required this.areas,
//     required this.categories,
//     required this.tags,
//     this.showTags = true,
//     this.showAreas = true,
//     this.showActiveProperties = true,
//     this.showSellerPropertyList = true,
//   });
// }
//
// class InfoTileData {
//   final String title;
//   final String value;
//   InfoTileData({required this.title, required this.value});
// }
//
// class AgentTagData {
//   final IconData icon;
//   final String text;
//   final Color color;
//
//   AgentTagData({required this.icon, required this.text, required this.color});
// }

/// --- PAGE ---
// class AgentProfilePage extends StatefulWidget {
//   final String sellerId;
//   final String? profilePic;
//   final bool isPremiumAgent;
//
//   const AgentProfilePage({
//     super.key,
//     required this.sellerId,
//     this.profilePic,
//     this.isPremiumAgent = false,
//   });
//
//   @override
//   State<AgentProfilePage> createState() => _AgentProfilePageState();
// }
//
// class _AgentProfilePageState extends State<AgentProfilePage> {
//   late final TopSellerPropertyController controller;
//   late final TopSellerProfileController sellerProfileController;
//   Rxn<ProfileSellerModel> sellerProfile = Rxn<ProfileSellerModel>();
//
//   @override
//   void initState() {
//     controller = Get.put(
//       TopSellerPropertyController(sellerId: widget.sellerId),
//       tag: 'SellerProperties_${widget.sellerId}',
//     );
//     sellerProfileController = Get.put(
//       TopSellerProfileController(),
//       tag: 'SellerProfile_${widget.sellerId}',
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//     });
//     super.initState();
//   }
//
//   Future<void> _loadData() async {
//     final profile = await sellerProfileController.getSellerProfileById(
//       widget.sellerId,
//     );
//     sellerProfile.value = profile;
//     await controller.loadInitial();
//   }
//
//   @override
//   dispose() {
//     Get.delete<TopSellerPropertyController>(
//       tag: 'SellerProperties_${widget.sellerId}',
//     );
//     Get.delete<TopSellerProfileController>(
//       tag: 'SellerProfile_${widget.sellerId}',
//     );
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ColorRes.primary,
//               minimumSize: const Size(double.infinity, 48),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             icon: const Icon(Icons.home, color: ColorRes.white, size: 18),
//             label: Text(
//               'View Properties',
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 color: ColorRes.white,
//               ),
//             ),
//             onPressed: () {
//               // TODO: Navigate to Agent’s property list
//             },
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: ListView(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 8, top: 8),
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: ColorRes.blackShade87,
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//
//             /// Profile Logo
//             Center(
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage:
//                     (widget.profilePic != null && widget.profilePic!.isNotEmpty)
//                         ? NetworkImage(widget.profilePic!)
//                         : AssetImage(IMGRes.user_1),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             /// Agent Name
//             Center(
//               child: Text(
//                 sellerProfile.value!.companyName,
//                 style: TextStyle(
//                   fontSize: AppFontSizes.body,
//                   fontWeight: AppFontWeights.bold,
//                   color: ColorRes.textColor,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             /// Tags (controlled by flag)
//             // if (widget.agent.showTags && widget.agent.tags.isNotEmpty) ...[
//             //   Row(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children:
//             //         widget.agent.tags
//             //             .map(
//             //               (tag) => Padding(
//             //                 padding: const EdgeInsets.symmetric(horizontal: 8),
//             //                 child: AgentTag(
//             //                   icon: tag.icon,
//             //                   text: tag.text,
//             //                   color: tag.color,
//             //                 ),
//             //               ),
//             //             )
//             //             .toList(),
//             //   ),
//             // ],
//             const SizedBox(height: 20),
//
//             /// Agent Card
//             AgentCard(
//               logoUrl:
//                   (widget.profilePic != null && widget.profilePic!.isNotEmpty)
//                       ? widget.profilePic!
//                       : IMGRes.user_1,
//               title: sellerProfile.value?.contactName ?? 'N/A',
//               isOwner:
//                   sellerProfile.value?.sellerType.toLowerCase() == 'owner'
//                       ? true
//                       : false,
//
//               // listings: widget.agent.listings,
//             ),
//
//             /// Areas (controlled by flag)
//             // if (widget.agent.showAreas && widget.agent.areas.isNotEmpty) ...[
//             //   const SectionTitle("Areas of operation"),
//             //   Padding(
//             //     padding: const EdgeInsets.symmetric(
//             //       horizontal: 12,
//             //       vertical: 8,
//             //     ),
//             //     child: Wrap(
//             //       spacing: 8,
//             //       children:
//             //           widget.agent.areas.map((area) => AreaChip(area)).toList(),
//             //     ),
//             //   ),
//             // ],
//
//             /// Active Properties (controlled by flag)
//             SectionTitle("Active Properties (${controller.totalPages.value})"),
//             const SizedBox(height: 15),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 // child: Row(
//                 //   children: List.generate(
//                 //     widget.agent.categories.length,
//                 //     (index) => CategoryChip(
//                 //       label: widget.agent.categories[index]['type'],
//                 //       isSelected: index == 0,
//                 //       number: widget.agent.categories[index]['number'],
//                 //     ),
//                 //   ),
//                 // ),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // if (widget.agent.showSellerPropertyList) ...[SellerPropertyList()],
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AgentCard extends StatelessWidget {
//   final String logoUrl;
//   final String title;
//
//   final bool isOwner;
//
//   const AgentCard({
//     super.key,
//     required this.logoUrl,
//     required this.title,
//
//     required this.isOwner,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.grey.withOpacity(0.25), width: 0.8),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.08),
//         //     blurRadius: 10,
//         //     offset: const Offset(0, 4),
//         //   ),
//         // ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Top Row with logo & badge
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 26,
//                   backgroundImage: NetworkImage(logoUrl),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.bold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                     // const SizedBox(height: 4),
//                     // Container(
//                     //   padding: const EdgeInsets.symmetric(
//                     //     horizontal: 10,
//                     //     vertical: 4,
//                     //   ),
//                     //   decoration: BoxDecoration(
//                     //     color: ColorRes.primary,
//                     //     borderRadius: BorderRadius.circular(6),
//                     //   ),
//                     //   child: Text(
//                     //     badgeText,
//                     //     style: TextStyle(
//                     //       fontSize: AppFontSizes.mini,
//                     //       color: ColorRes.white,
//                     //       fontWeight: AppFontWeights.semiBold,
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             /// Buyers & Listings row
//             // if (!isOwner) ...[
//             //   Row(
//             //     children: [
//             //       const Icon(Icons.groups, color: ColorRes.blueColor, size: 18),
//             //       const SizedBox(width: 6),
//             //       Expanded(
//             //         child: Text(
//             //           buyersServed,
//             //           style: TextStyle(
//             //             fontSize: AppFontSizes.extraSmall,
//             //             fontWeight: AppFontWeights.medium,
//             //           ),
//             //         ),
//             //       ),
//             //       const Icon(
//             //         Icons.verified_user,
//             //         color: ColorRes.green,
//             //         size: 18,
//             //       ),
//             //       const SizedBox(width: 6),
//             //       Expanded(
//             //         child: Text(
//             //           listings,
//             //           style: TextStyle(
//             //             fontSize: AppFontSizes.extraSmall,
//             //             fontWeight: AppFontWeights.medium,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ] else ...[
//             //   Row(
//             //     children: [
//             //       // const Icon(Icons.groups, color: Colors.blue, size: 18),
//             //       // const SizedBox(width: 6),
//             //       // Expanded(
//             //       //   child: Text(
//             //       //     buyersServed,
//             //       //     style: const TextStyle(
//             //       //       fontSize: 10,
//             //       //       fontWeight: AppFontWeights.medium,
//             //       //     ),
//             //       //   ),
//             //       // ),
//             //       const Icon(
//             //         Icons.verified_user,
//             //         color: ColorRes.green,
//             //         size: 18,
//             //       ),
//             //       const SizedBox(width: 6),
//             //       Expanded(
//             //         child: Text(
//             //           listings,
//             //           style: TextStyle(
//             //             fontSize: AppFontSizes.extraSmall,
//             //             fontWeight: AppFontWeights.medium,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ],
//             // const SizedBox(height: 16),
//
//             /// Description
//             // Text(
//             //   description,
//             //   style: TextStyle(
//             //     fontSize: AppFontSizes.caption,
//             //     color: ColorRes.grey,
//             //   ),
//             // ),
//             const SizedBox(height: 12),
//             Divider(thickness: 0.5, color: ColorRes.grey.withOpacity(0.5)),
//             // const SizedBox(height: 12),
//
//             /// Info Tiles with Vertical Dividers
//             // IntrinsicHeight(
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //     children: [
//             //       for (int i = 0; i < infoTiles.length; i++) ...[
//             //         infoTiles[i],
//             //         if (i != infoTiles.length - 1)
//             //           const VerticalDivider(
//             //             thickness: 0.5,
//             //             width: 20,
//             //             color: ColorRes.leadGreyColor,
//             //           ),
//             //       ],
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class InfoTile extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const InfoTile({super.key, required this.title, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: AppFontSizes.caption,
//             color: ColorRes.leadGreyColor,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AgentTag extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color color;
//
//   const AgentTag({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 18),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: AppFontSizes.mini,
//             color: ColorRes.leadGreyColor,
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AreaChip extends StatelessWidget {
//   final String label;
//   const AreaChip(this.label, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       label: Text(label, style: const TextStyle(fontSize: 11)),
//       backgroundColor: ColorRes.leadGreyColor.shade100,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//         side: BorderSide(color: ColorRes.leadGreyColor.shade200, width: 1),
//       ),
//     );
//   }
// }
//
// class CategoryChip extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final int number;
//
//   const CategoryChip({
//     super.key,
//     required this.label,
//     required this.isSelected,
//     required this.number,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 12, bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: isSelected ? ColorRes.primary.withOpacity(0.08) : ColorRes.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: isSelected ? ColorRes.primary : ColorRes.grey.withOpacity(0.4),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: AppFontSizes.medium,
//               fontWeight: AppFontWeights.medium,
//               color: isSelected ? ColorRes.primary : ColorRes.textPrimary,
//             ),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             "($number)",
//             style: TextStyle(
//               fontSize: AppFontSizes.caption,
//               fontWeight: AppFontWeights.regular,
//               color:
//                   isSelected
//                       ? ColorRes.primary
//                       : ColorRes.leadGreyColor.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SectionTitle extends StatelessWidget {
//   final String title;
//   const SectionTitle(this.title, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: AppFontSizes.medium,
//           fontWeight: AppFontWeights.semiBold,
//           color: ColorRes.textColor,
//         ),
//       ),
//     );
//   }
// }
//
// num totalPropertyLength(List<Map<String, dynamic>> list) {
//   return list.fold(0, (sum, item) => sum + item['number']);
// }

/// --- PAGE ---
class AgentProfilePage extends StatefulWidget {
  final String sellerId;
  final String? profilePic;
  final bool isOwner;

  const AgentProfilePage({
    super.key,
    required this.sellerId,
    this.profilePic,
    required this.isOwner,
  });

  @override
  State<AgentProfilePage> createState() => _AgentProfilePageState();
}

class _AgentProfilePageState extends State<AgentProfilePage> {
  late final TopSellerPropertyController? propertyController;
  late final TopSellerProjectController? projectController;
  late final TopSellerProfileController profileController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers based on owner status
    if (widget.isOwner) {
      propertyController = Get.put(
        TopSellerPropertyController(sellerId: widget.sellerId),
        tag: 'SellerProperties_${widget.sellerId}',
      );
      projectController = null;
    } else {
      projectController = Get.put(
        TopSellerProjectController(sellerId: widget.sellerId),
        tag: 'SellerProjects_${widget.sellerId}',
      );
      propertyController = null;
    }

    profileController = Get.put(
      TopSellerProfileController(),
      tag: 'SellerProfile_${widget.sellerId}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      await profileController.loadSellerProfile(widget.sellerId);
      if (widget.isOwner) {
        await propertyController?.loadInitial();
      } else {
        await projectController?.loadInitial();
      }
    } catch (e) {
      // Handle error if needed
      debugPrint('Error loading data: $e');
    }
  }

  @override
  void dispose() {
    if (widget.isOwner) {
      Get.delete<TopSellerPropertyController>(
        tag: 'SellerProperties_${widget.sellerId}',
      );
    } else {
      Get.delete<TopSellerProjectController>(
        tag: 'SellerProjects_${widget.sellerId}',
      );
    }
    Get.delete<TopSellerProfileController>(
      tag: 'SellerProfile_${widget.sellerId}',
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = profileController.sellerProfile.value;
        final user = profileController.userModel.value;

        // Handle null profile case
        if (profile == null) {
          return _buildErrorState(
            icon: Icons.error_outline,
            message: 'Unable to load profile',
            onRetry: _loadData,
          );
        }

        return SafeArea(
          child: ListView(
            children: [
              _buildBackButton(context),
              _buildProfileHeader(user),
              _buildVerifiedBadge(user),
              _buildAgentCard(user, profile),
              const SizedBox(height: 20),
              _buildContentSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.blackShade87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              (widget.profilePic != null && widget.profilePic!.isNotEmpty)
                  ? NetworkImage(widget.profilePic!)
                  : const AssetImage(IMGRes.user_1) as ImageProvider,
        ),
        const SizedBox(height: 12),
        Text(
          user?.fullName ?? 'N/A',
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textColor,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildVerifiedBadge(dynamic user) {
    if (user?.isPremium != true) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_outlined, color: ColorRes.green, size: 17),
            const SizedBox(width: 4),
            Text(
              'Verified Seller',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAgentCard(dynamic user, dynamic profile) {
    final totalItems =
        widget.isOwner
            ? propertyController?.total.value ?? 0
            : projectController?.items.length ?? 0;

    final itemLabel = widget.isOwner ? 'properties' : 'projects';

    return AgentCard(
      experience: '${user?.totalExperience ?? 'N/A'} years',
      totalProperty: '$totalItems $itemLabel',
      sellerType: profile?.sellerType ?? 'N/A',
    );
  }

  Widget _buildContentSection() {
    if (widget.isOwner) {
      return _buildPropertiesSection();
    } else {
      return _buildProjectsSection();
    }
  }

  Widget _buildPropertiesSection() {
    return Obx(() {
      final controller = propertyController!;

      if (controller.isLoading.value && controller.items.isEmpty) {
        return _buildLoadingState();
      }

      if (!controller.isLoading.value && controller.items.isEmpty) {
        return _buildErrorState(
          icon: Icons.error_outline,
          message: 'Failed to load properties',
          onRetry: () => controller.loadInitial(),
        );
      }

      if (controller.items.isEmpty) {
        return _buildEmptyState(
          icon: Icons.home_outlined,
          message: 'No properties available',
        );
      }

      return _buildItemList(
        title: "Active Properties",
        items: controller.items,
        hasMore: controller.hasMore.value,
        onItemTap: (property) {
          Get.to(() => PropertyDetailScreen(propertyId: property.id));
        },
        itemBuilder:
            (property) => SellerProfilePropertyCard(property: property),
      );
    });
  }

  Widget _buildProjectsSection() {
    return Obx(() {
      final controller = projectController!;

      if (controller.isLoading.value && controller.items.isEmpty) {
        return _buildLoadingState();
      }

      if (!controller.isLoading.value && controller.items.isEmpty) {
        return _buildErrorState(
          icon: Icons.error_outline,
          message: 'Failed to load projects',
          onRetry: () => controller.loadInitial(),
        );
      }

      if (controller.items.isEmpty) {
        return _buildEmptyState(
          icon: Icons.home_outlined,
          message: 'No projects available',
        );
      }

      return _buildItemList(
        title: "Active Projects",
        items: controller.items,
        hasMore: controller.hasMore.value,
        onItemTap: (project) {
          Get.to(() => ProjectDetailsScreen(projectId: project.id));
        },
        itemBuilder: (project) => SellerProfileProjectCard(project: project),
      );
    });
  }

  Widget _buildItemList<T>({
    required String title,
    required List<T> items,
    required bool hasMore,
    required Function(T) onItemTap,
    required Widget Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        const SizedBox(height: 15),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: items.length + (hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const SizedBox.shrink(); // Placeholder for load more
            }

            final item = items[index];
            return GestureDetector(
              onTap: () => onItemTap(item),
              child: itemBuilder(item),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState({
    required IconData icon,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: ColorRes.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: ColorRes.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgentCard extends StatelessWidget {
  final String experience;
  final String totalProperty;
  final String sellerType;

  const AgentCard({
    super.key,
    required this.experience,
    required this.totalProperty,
    required this.sellerType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.grey.withOpacity(0.25), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: ColorRes.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: InfoTile(title: 'Experience', value: experience)),

          _divider(),

          Expanded(child: InfoTile(title: 'Type', value: sellerType)),

          _divider(),

          Expanded(
            child: InfoTile(title: 'Total Properties', value: totalProperty),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 36,
      width: 1,
      color: ColorRes.grey.withOpacity(0.35),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSizes.medium,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textColor,
        ),
      ),
    );
  }
}

// Placeholder property card widget - replace with your actual implementation
class SellerProfilePropertyCard extends StatelessWidget {
  final Items property;

  const SellerProfilePropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: ColorRes.black.withOpacity(0.06),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Row(
          children: [
            // IMAGE SECTION
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(11),
              ),
              child: CustomImage(
                type: CustomImageType.network,
                src:
                    (property.propertyMedia?.images?.isNotEmpty ?? false)
                        ? property.propertyMedia!.images!.first
                        : 'https://via.placeholder.com/150',
                width: 110,
                height: 121,
                fit: BoxFit.cover,
              ),
            ),

            // CONTENT SECTION
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TITLE + SHARE ICON
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            PropertyNameManager(property).displayName,
                            style: TextStyle(
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textColor,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // ADDRESS
                    Text(
                      property.address ?? 'No address provided',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // FACILITIES (UI ONLY)
                    ResellerFacilities(property: property),

                    // PRICE + VISIT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            PropertyPriceManager(
                              listingType: property.listingType ?? '',
                              financialInfo:
                                  property.propertyDetails?.financialInfo,
                            ).displayPrice,
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: AppFontWeights.bold,
                              color: ColorRes.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Visit',
                            style: TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.small,
                              color: ColorRes.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }
}

class SellerProfileProjectCard extends StatelessWidget {
  final ProjectItem project;

  const SellerProfileProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: ColorRes.black.withOpacity(0.06),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Row(
          children: [
            /// IMAGE SECTION
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(11),
              ),
              child: CustomImage(
                type: CustomImageType.network,
                src:
                    (project.mediaGallery?.images?.isNotEmpty ?? false)
                        ? project.mediaGallery!.images!.first
                        : 'https://via.placeholder.com/150',
                width: 110,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            /// CONTENT SECTION
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// PROJECT NAME + VERIFIED
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.projectName,
                            style: TextStyle(
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textColor,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (project.isVerified)
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: ColorRes.primary,
                          ),
                      ],
                    ),

                    /// LOCATION
                    Text(
                      '${project.projectArea}, ${project.city}',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// CONFIGURATION + SIZE
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chip(
                            project.configuration.isNotEmpty
                                ? project.configuration
                                    .map((e) => e.variants.first.name)
                                    .join(', ')
                                : 'Configs',
                          ),
                          const SizedBox(width: 6),
                          _chip(project.getPriceRange()),
                        ],
                      ),
                    ),

                    /// PRICE RANGE + STATUS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.getPriceRange(),
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: AppFontWeights.bold,
                              color: ColorRes.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _statusBadge(project.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SMALL CHIP UI
  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppFontSizes.small,
          color: ColorRes.leadGreyColor[700],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// STATUS BADGE
  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            status.toLowerCase() == 'active'
                ? ColorRes.success.withOpacity(0.15)
                : ColorRes.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: AppFontSizes.small,
          fontWeight: AppFontWeights.semiBold,
          color:
              status.toLowerCase() == 'active'
                  ? ColorRes.success
                  : ColorRes.warning,
        ),
      ),
    );
  }
}
