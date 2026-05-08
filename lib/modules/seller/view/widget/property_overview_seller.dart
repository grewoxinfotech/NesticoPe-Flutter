import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/manager/icon_manager.dart';
import 'package:nesticope_app/app/manager/property/property_name_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'package:nesticope_app/modules/seller/view/widget/seller_property_approval_history.dart';
import 'package:nesticope_app/utils/property_mapper/property_mapper.dart';
import 'package:nesticope_app/widgets/dialog/delete_confirmation_dialog.dart';
import 'package:nesticope_app/widgets/property/furnishing_details.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../add_property/view/create_property.dart';
import '../../../performance_score/views/performance_score_screen.dart';
import '../../../property/controllers/property_controller.dart';
import '../../../property/views/property_detail_screen.dart';
import '../../../property/views/widgets/property_media_gallery.dart';
import '../../../reseller/view/lead_overview/widget/lead_negotiable_price_screen.dart';
import '../../../reseller/view/lead_overview/widget/lead_visit.dart';
import '../../module/lead_screen/controllers/lead_property_inquiry_controller.dart';
import '../../module/lead_screen/controllers/lead_property_negotiable_price_controller.dart';
import '../../module/lead_screen/controllers/lead_visit_controller.dart';
import '../../module/lead_screen/views/lead_screen_enhanced.dart';
import 'package:url_launcher/url_launcher.dart';

// class PropertyOverviewSellerScreen extends StatelessWidget {
//   final Items property;
//
//   const PropertyOverviewSellerScreen({Key? key, required this.property})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<PropertyController>();
//     final isCompact = MediaQuery
//         .of(context)
//         .size
//         .width < 600;
//
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           'Property Overview',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Property Images Gallery
//             // _buildPropertyImageGallery(context),
//             PropertyMediaGallery(
//               images: property.propertyMedia?.images,
//               videos: property.propertyMedia?.videos,
//               itemId: property.id,
//               showReraTag: !controller.isDeveloper.value,
//               showBackButton: false,
//               showFavorite: false,
//               showShare: false,
//             ),
//
//             Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//
//             // Property Status & Performance
//             _buildStatusSection(context, isCompact),
//
//             Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//
//             // Property Overview
//             _buildPropertyOverviewSection(context, isCompact),
//
//             Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//
//             // Financial Information
//             _buildFinancialSection(context, isCompact),
//
//             Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//
//             // Property Details
//             _buildPropertyDetailsSection(context, isCompact),
//
//             Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//
//             // Amenities
//             if (property.propertyDetails?.amenities?.isNotEmpty ?? false) ...[
//               _buildAmenitiesSection(context, isCompact),
//               Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//             ],
//
//             // Performance Metrics
//             _buildPerformanceSection(context, isCompact),
//
//             Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//
//             // Assignment Info (if assigned)
//             if (property.assignedTo != null) ...[
//               _buildAssignmentSection(context, isCompact),
//               Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
//             ],
//
//             // Action Buttons
//             _buildActionButtons(context, isCompact),
//
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
class PropertyOverviewSellerScreen extends StatefulWidget {
  final String propertyId;
  final Function() onDelete;

  const PropertyOverviewSellerScreen({
    Key? key,
    required this.propertyId,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<PropertyOverviewSellerScreen> createState() =>
      _PropertyOverviewSellerScreenState();
}

class _PropertyOverviewSellerScreenState
    extends State<PropertyOverviewSellerScreen> {
  late final PropertyController controller;
  final LeadPropertyInquiryController leadPropertyInquiryController = Get.put(
    LeadPropertyInquiryController(),
  );
  final LeadVisitController leadVisitController = Get.put(
    LeadVisitController(),
  );
  final LeadPropertyNegotiablePriceController
  leadPropertyNegotiablePriceController = Get.put(
    LeadPropertyNegotiablePriceController(),
  );
  final Rxn<Items> _property = Rxn<Items>();

  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      PropertyController(),
      tag: 'property_${widget.propertyId}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    Get.delete<PropertyController>(tag: 'property_${widget.propertyId}');
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      _isLoading.value = true;

      final fetchedProperty = await controller.getPropertyById(
        widget.propertyId,
      );
      if (fetchedProperty == null) {
        // Show error and go back
        if (mounted) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Error',
            message: 'Property not found',
            contentType: ContentType.failure,
          );
          Get.back();
        }
        return;
      }
      _property.value = fetchedProperty;

      // final currentProperty = _property.value;
      // if (currentProperty == null) return;
      //
      // // Set review filter
      // reviewController.filters.value = {"entity_id": currentProperty.id ?? ""};
      // reviewController.filters.refresh();
      //
      // // Fetch nearby landmarks and all categories
      // if (currentProperty.address?.isNotEmpty ?? false) {
      //   await mapController.fetchAllCategoriesData(currentProperty.address!);
      // }
      //
      // // Check review permission
      // final user = await SecureStorage.getUserData();
      // final userId = user?.user?.id ?? '';
      // if (currentProperty.id != null) {
      //   final exists = await reviewController.isReviewExist(
      //     entityId: currentProperty.id!,
      //     reviewerId: userId,
      //   );
      //   canAddReview.value = !exists;
      // }
      //
      // // Track view
      // controller.addView(currentProperty.id ?? '');
      // _overallRatingController.fetchOverallRating(currentProperty.id ?? '');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyController>();
    final isCompact = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Property Overview',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: Obx(() {
          if (_isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_property.value == null) {
            return const Center(child: Text("Property not found"));
          }
          log(
            'Rendering property overview for ID: ${_property.value!.toJson()}',
          );

          final property = _property.value!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Property Media
                PropertyMediaGallery(
                  images: property.propertyMedia?.images,
                  videos: property.propertyMedia?.videos,
                  itemId: property.id,
                  showReraTag: !controller.isDeveloper.value,
                  showBackButton: false,
                  showFavorite: false,
                  showShare: false,
                ),

                // if ((property.propertyMedia?.documents?.isNotEmpty ?? false))
                // Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

                _buildStatusSection(context, isCompact),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

                _buildPropertyOverviewSection(context, isCompact),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                if (((property.propertyDetails?.subRegistrarOfficeName
                            ?.trim()
                            .isNotEmpty ??
                        false) ||
                    (property.propertyDetails?.saleDeedDocumentNumber
                            ?.trim()
                            .isNotEmpty ??
                        false) ||
                    ((property.propertyDetails?.yearOfRegistration
                                ?.toString() ??
                            '')
                        .trim()
                        .isNotEmpty))) ...[
                  _buildSubRegistrarSection(property),
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                ],
                if ((property.propertyMedia?.documents?.isNotEmpty ?? false))
                  _buildPropertyDocumentsSection(property),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

                _buildFinancialSection(context, isCompact),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

                _buildPropertyDetailsSection(context, isCompact),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

                if (property.propertyDetails?.amenities?.isNotEmpty ??
                    false) ...[
                  _buildAmenitiesSection(context, isCompact),
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                ],

                if (property.propertyDetails?.furnishInfo?.furnishDetails !=
                    null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Furnishing',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return FurnishingDetails(
                        property: property,
                        bgColor: ColorRes.propertyBg,
                        txtColor: ColorRes.primary,
                      );
                    },
                  ),
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                ],
                if (property.listingType?.toUpperCase() == "PG" &&
                    property.propertyDetails?.pgInfo?.pgRules != null) ...[
                  const SizedBox(height: 12),
                  // const TitleWithViewAll(title: 'PG Rules'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'PG Rules',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPgRulesSection(
                    property.propertyDetails!.pgInfo!.pgRules!,
                  ),
                  const SizedBox(height: 20),
                  // Divider(
                  //   indent: 18,
                  //   endIndent: 18,
                  //   color: ColorRes.leadGreyColor.shade300,
                  // ),
                ],

                if (property.listingType?.toUpperCase() == "PG" &&
                    property.propertyDetails?.pgInfo?.pgRoomInfo != null &&
                    property
                        .propertyDetails!
                        .pgInfo!
                        .pgRoomInfo!
                        .isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),

                    // color: ColorRes.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          thickness: 8,
                          color: ColorRes.leadGreyColor[100],
                        ),
                        const SizedBox(height: 12),
                        //  TitleWithViewAll(
                        //   title: 'Room Options & Pricing',
                        //   showIcon: true,
                        //   icon: Icons.room_outlined,
                        //   iconBgColor: ColorRes.white,
                        //   iconColor: ColorRes.primary,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Room Options & Pricing',
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildRoomOptionsSection(
                          property.propertyDetails!.pgInfo!.pgRoomInfo!,
                        ),
                        const SizedBox(height: 15),
                        // Divider(
                        //   indent: 18,
                        //   endIndent: 18,
                        //   color: ColorRes.leadGreyColor.shade300,
                        // ),
                      ],
                    ),
                  ),
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                ],

                _buildPerformanceSection(context, isCompact),
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

                if (property.assignedTo != null) ...[
                  _buildAssignmentSection(context, isCompact),
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                ],

                if (property.scoreBreakdown != null) ...[
                  PerformanceScoreWidget(score: property.scoreBreakdown!),
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                ],

                _buildMenuItem(
                  iconColor: ColorRes.primary,
                  title: "Approval History",
                  icon: Icons.history,
                  onTap: () {
                    Get.to(
                      () => SellerPropertyApprovalHistory(
                        propertyId: property.id ?? '',
                      ),
                    );
                  },
                  iconBg: ColorRes.primary.withOpacity(0.1),
                  subtitle: 'View timeline of approvals',
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  iconColor: ColorRes.green,
                  title: "Property lead",
                  icon: Icons.label_important_outline,
                  onTap: () {
                    Get.to(
                      () => SellerLeadScreen(propertyId: property.id ?? ''),
                    );
                  },
                  iconBg: ColorRes.green.withOpacity(0.1),

                  subtitle: 'New potential buyers',
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  title: "Visit",
                  iconColor: ColorRes.deepPurpleColor,
                  icon: Icons.history,
                  onTap: () {
                    Get.to(
                      () => LeadVisit(
                        leadVisitController: leadVisitController,
                        propertyInquiryController:
                            leadPropertyInquiryController,
                        propertyId: property.id,
                      ),
                    );
                  },
                  iconBg: ColorRes.deepPurpleColor.withOpacity(0.1),
                  subtitle: 'View visit history',
                ),
                SizedBox(height: 10),
                _buildMenuItem(
                  title: "Negotiable",
                  iconColor: ColorRes.builderGridPink,
                  icon: Icons.currency_rupee_outlined,
                  onTap: () {
                    leadPropertyNegotiablePriceController
                        .setLeadNegotiablePriceId(property.id ?? '');
                    log(
                      'Negotiable Price ID set: ${leadPropertyNegotiablePriceController.items.map((e) => e.toMap())}',
                    );
                    Get.to(
                      () => LeadNegotiablePriceScreen(
                        controller: leadPropertyNegotiablePriceController,
                      ),
                    );
                  },
                  iconBg: ColorRes.builderGridPink.withOpacity(0.1),
                  subtitle: 'View negotiable price history',
                ),
                SizedBox(height: 10),

                if (property.propertyStatus?.toLowerCase() != "sold") ...[
                  _buildActionButtons(
                    context,
                    isCompact,
                    property,
                    widget.onDelete,
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPgRulesSection(PgRules rules) {
    final rulesList = <Map<String, dynamic>>[];

    if (rules.nonVegAllowed != null) {
      rulesList.add({
        'label': 'Non-Veg',
        'allowed': rules.nonVegAllowed!,
        'icon': Icons.restaurant,
      });
    }
    if (rules.petsAllowed != null) {
      rulesList.add({
        'label': 'Pets',
        'allowed': rules.petsAllowed!,
        'icon': Icons.pets,
      });
    }
    if (rules.lateEntryAllowed != null) {
      rulesList.add({
        'label': 'Late Entry',
        'allowed': rules.lateEntryAllowed!,
        'icon': Icons.access_time,
      });
    }
    if (rules.smokingAllowed != null) {
      rulesList.add({
        'label': 'Smoking',
        'allowed': rules.smokingAllowed!,
        'icon': Icons.smoke_free,
      });
    }
    if (rules.drinkingAllowed != null) {
      rulesList.add({
        'label': 'Drinking',
        'allowed': rules.drinkingAllowed!,
        'icon': Icons.no_drinks,
      });
    }
    if (rules.visitorAllowed != null) {
      rulesList.add({
        'label': 'Visitor',
        'allowed': rules.visitorAllowed!,
        'icon': Icons.people,
      });
    }

    if (rulesList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'No rules specified',
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            color: ColorRes.leadGreyColor,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            rulesList.map((rule) {
              final isAllowed = rule['allowed'] as bool;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isAllowed
                          ? ColorRes.green.withOpacity(0.02)
                          : ColorRes.error.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isAllowed
                            ? ColorRes.green.withOpacity(0.8)
                            : ColorRes.error.withOpacity(0.8),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      rule['icon'] as IconData,
                      size: 16,
                      color:
                          isAllowed
                              ? ColorRes.green.withOpacity(0.8)
                              : ColorRes.error.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rule['label'] as String,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.medium,
                        color:
                            isAllowed
                                ? ColorRes.green.withOpacity(0.8)
                                : ColorRes.error.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isAllowed ? Icons.check_circle : Icons.cancel,
                      size: 14,
                      color:
                          isAllowed
                              ? ColorRes.green.withOpacity(0.8)
                              : ColorRes.error.withOpacity(0.8),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildRoomOptionsSection(List<PgRoomInfo> rooms) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children:
            rooms.map((room) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: ColorRes.leadGreyColor.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: ColorRes.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room.roomType?.toUpperCase() ?? 'Room',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${Formatter.formatPrice(room.rent ?? 0)} / month',
                            style: const TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (room.securityDeposit != null &&
                        room.securityDeposit! > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.security,
                            size: 14,
                            color: ColorRes.leadGreyColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Security Deposit: ${Formatter.formatPrice(room.securityDeposit ?? 0)}',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: ColorRes.leadGreyColor.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Room Facilities
                    if (room.roomFacilityInfo != null) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Facilities:',
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.blackShade87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _buildFacilityChips(room.roomFacilityInfo!),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  List<Widget> _buildFacilityChips(RoomFacilityInfo facilities) {
    final chips = <Widget>[];

    if (facilities.wifi == true) {
      chips.add(_buildFacilityChip('WiFi', Icons.wifi));
    }
    if (facilities.ac == true) {
      chips.add(_buildFacilityChip('AC', Icons.ac_unit));
    }
    if (facilities.tv == true) {
      chips.add(_buildFacilityChip('TV', Icons.tv));
    }
    if (facilities.geyser == true) {
      chips.add(_buildFacilityChip('Geyser', Icons.hot_tub));
    }
    if (facilities.fridge == true) {
      chips.add(_buildFacilityChip('Fridge', Icons.kitchen));
    }
    if (facilities.cupboard == true) {
      chips.add(_buildFacilityChip('Cupboard', Icons.door_sliding));
    }
    if (facilities.other != null && facilities.other!.isNotEmpty) {
      chips.addAll(
        facilities.other!
            .split("\n\n")
            .map((e) => _buildFacilityChip(e, Icons.more_horiz))
            .toList(),
      );
    }

    if (chips.isEmpty) {
      chips.add(
        const Text(
          'No facilities specified',
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor,
          ),
        ),
      );
    }

    return chips;
  }

  /// Build individual facility chip
  Widget _buildFacilityChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorRes.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: ColorRes.white,
            child: Row(
              children: [
                /// Icon Box
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),

                const SizedBox(width: 14),

                /// Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.leadGreyColor[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.leadGreyColor[600],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorRes.leadGreyColor[500],
                ),
              ],
            ),
          ),

          /// Divider
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: ColorRes.leadGreyColor.shade200,
            ),
        ],
      ),
    );
  }

  // Widget _buildPropertyImageGallery(BuildContext context) {
  //   final images =
  //       property.propertyMedia?.images ?? property.propertyImages ?? [];
  //
  //   if (images.isEmpty) {
  //     return Container(
  //       height: 280,
  //       color: ColorRes.leadGreyColor[300],
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.home, size: 80, color: ColorRes.leadGreyColor[400]),
  //           SizedBox(height: 8),
  //           Text(
  //             property.title ?? 'No images available',
  //             style: TextStyle(
  //               fontSize: AppFontSizes.body,
  //               fontWeight: AppFontWeights.extraBold,
  //               color: ColorRes.leadGreyColor[600],
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   return Container(
  //     height: 280,
  //     child: Stack(
  //       children: [
  //         PageView.builder(
  //           itemCount: images.length,
  //           itemBuilder: (context, index) {
  //             return Image.network(
  //               images[index],
  //               fit: BoxFit.cover,
  //               errorBuilder: (context, error, stackTrace) {
  //                 return Container(
  //                   color: ColorRes.leadGreyColor[300],
  //                   child: Icon(
  //                     Icons.image_not_supported,
  //                     size: 80,
  //                     color: ColorRes.leadGreyColor[400],
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //
  //         // Image counter
  //         Positioned(
  //           bottom: 16,
  //           right: 16,
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             decoration: BoxDecoration(
  //               color: ColorRes.black.withOpacity(0.6),
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Text(
  //               '1/${images.length}',
  //               style: TextStyle(
  //                 color: ColorRes.white,
  //                 fontSize: AppFontSizes.small,
  //                 fontWeight: AppFontWeights.semiBold,
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         // Status Badge
  //         Positioned(
  //           top: 16,
  //           left: 16,
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //             decoration: BoxDecoration(
  //               color: _getStatusColor(property.propertyStatus ?? 'active'),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Text(
  //               _formatStatus(property.propertyStatus ?? 'active'),
  //               style: TextStyle(
  //                 color: ColorRes.white,
  //                 fontSize: AppFontSizes.small,
  //                 fontWeight: AppFontWeights.extraBold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPropertyDocumentsSection(Items property) {
    final docs = property.propertyMedia?.documents ?? <String>[];
    if (docs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROPERTY DOCUMENTS & BROCHURES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          ...docs.asMap().entries.map((entry) {
            final index = entry.key;
            final docUrl = entry.value;
            final fileName = Uri.tryParse(docUrl)?.pathSegments.last;
            final displayName =
                (fileName != null && fileName.isNotEmpty)
                    ? fileName
                    : 'Document ${index + 1}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openDocumentUrl(docUrl),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: ColorRes.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // PDF icon badge
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: ColorRes.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: ColorRes.error,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // File name + subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'PDF · Tap to download',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: ColorRes.textColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Download chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.download_rounded,
                                size: 18,
                                color: ColorRes.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _openDocumentUrl(String docUrl) async {
    final uri = Uri.tryParse(docUrl);
    if (uri == null) {
      Get.snackbar('Invalid document', 'Unable to open this file.');
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      Get.snackbar('Download failed', 'Unable to open document right now.');
    }
  }

  Widget _buildSubRegistrarSection(Items? currentProperty) {
    final subRegistrarOfficeName =
        currentProperty?.propertyDetails?.subRegistrarOfficeName?.trim() ?? '';
    final saleDeedDocumentNumber =
        currentProperty?.propertyDetails?.saleDeedDocumentNumber?.trim() ?? '';
    final yearOfRegistration =
        currentProperty?.propertyDetails?.yearOfRegistration?.toString() ?? '';
    if (subRegistrarOfficeName.isEmpty &&
        saleDeedDocumentNumber.isEmpty &&
        yearOfRegistration.isEmpty) {
      return const SizedBox.shrink();
    }
    final formattedSubRegistrarOfficeName =
        subRegistrarOfficeName.capitalize?.replaceAll("_", " ") ??
        subRegistrarOfficeName.replaceAll("_", " ");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const TitleWithViewAll(title: 'Sub-Registrar Office'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorRes.leadGreyColor.shade200),
            ),
            child: Column(
              children: [
                _SubRegistrarRow(
                  label: 'Office',
                  value:
                      formattedSubRegistrarOfficeName.isNotEmpty
                          ? formattedSubRegistrarOfficeName
                          : 'Not defined',
                ),
                SizedBox(height: 10),
                _SubRegistrarRow(
                  label: 'Sale Deed Number',
                  value:
                      saleDeedDocumentNumber.isNotEmpty
                          ? saleDeedDocumentNumber
                          : 'Not defined',
                ),
                SizedBox(height: 10),
                _SubRegistrarRow(
                  label: 'Year of Registration',
                  value:
                      yearOfRegistration.isNotEmpty
                          ? yearOfRegistration
                          : 'Not defined',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, bool isCompact) {
    final property = _property.value!;
    final reraId = property.reraId;
    final hasValidReraId =
        reraId != null && reraId.isNotEmpty && reraId.toLowerCase() != 'null';

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Property Status',
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textColor,
                ),
              ),
              if (property.propertyStatus?.toLowerCase() == "sold") ...[
                Container(
                  decoration: BoxDecoration(
                    color: ColorRes.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      ' ${property.propertyStatus?.toUpperCase() ?? 'N/A'} ',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.error,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      ' ${property.propertyStatus?.toUpperCase() ?? 'N/A'} ',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.primary,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Approval Status',
                  _formatStatus(property.approvalStatus ?? 'pending'),
                  _getStatusColor(property.approvalStatus ?? 'pending'),
                  Icons.verified_outlined,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Verified',
                  property.isVerified ?? false ? 'Yes' : 'No',
                  property.isVerified ?? false
                      ? ColorRes.success
                      : ColorRes.orangeColor,
                  Icons.check_circle_outline,
                ),
              ),
            ],
          ),
          // SizedBox(height: 16),
          if (hasValidReraId) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorRes.success.withOpacity(0.18)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_moon_outlined,
                    size: 20,
                    color: ColorRes.success,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RERA ID',
                          style: TextStyle(
                            fontSize:
                                isCompact
                                    ? AppFontSizes.extraSmall
                                    : AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.leadGreyColor[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reraId.toUpperCase(),
                          style: TextStyle(
                            fontSize:
                                isCompact
                                    ? AppFontSizes.small
                                    : AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textColor,
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

  Widget _buildStatusCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: ColorRes.leadGreyColor[700],
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
    final property = _property.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Builder(
            builder: (context) {
              final title = PropertyNameManager(property);
              final type = property.type?.toLowerCase() ?? '';
              final propertyType = property.propertyType?.capitalize ?? '';
              final bhk = property.propertyDetails?.bhk ?? 0;

              return Text(
                title.displayName,
                style: TextStyle(
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: AppFontSizes.body,
                  color: ColorRes.blackShade87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),

        SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: ColorRes.leadGreyColor[600],
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${property.address ?? ''}, ${property.city ?? ''}, ${property.state ?? ''} - ${property.zipCode ?? ''}',
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor[700],
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        Facilities(property: property ?? Items()),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFinancialSection(BuildContext context, bool isCompact) {
    final property = _property.value!;
    final financialInfo = property.propertyDetails?.financialInfo;
    final listingType = property.listingType ?? "";

    // Use the price manager
    final priceManager = PropertyPriceManager(
      listingType: listingType,
      financialInfo: financialInfo,
      pgInfo: property.propertyDetails?.pgInfo,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Information',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorRes.success.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Property Price Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listingType.toLowerCase() == "rent"
                              ? 'Monthly Rent'
                              : 'Property Price',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.leadGreyColor[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priceManager.displayPrice,
                          style: TextStyle(
                            fontSize: AppFontSizes.large,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.success.shade800,
                          ),
                        ),
                      ],
                    ),

                    // Negotiable Badge
                    if (financialInfo?.negotiable ?? false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.orangeColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.orangeColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Negotiable',
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.orangeColor.shade700,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                // Divider(thickness: 1, color: ColorRes.leadGreyColor[300]),
                // const SizedBox(height: 8),

                /// --- Optional Details ---
                if (priceManager.pricePerSqft != null)
                  _buildInfoRow("Price per Sqft", priceManager.pricePerSqft!),

                if (priceManager.maintenance != null)
                  _buildInfoRow("Maintenance", priceManager.maintenance!),

                if (priceManager.securityDeposit != null)
                  _buildInfoRow(
                    "Security Deposit",
                    priceManager.securityDeposit!,
                  ),

                if (priceManager.brokerCommission != null)
                  _buildInfoRow(
                    "Broker Commission",
                    priceManager.brokerCommission!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Row Builder for financial items
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[700],
              fontWeight: AppFontWeights.medium,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.blueColor.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
    final property = _property.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((property.propertyDetails?.financialInfo?.is_for_sellorrent ??
                false) &&
            (property.listingType?.toLowerCase() == 'sell')) ...[
          if (property.propertyDetails?.financialInfo?.propertyRentPerMonth !=
              null) ...[
            // Padding(
          

            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Also for Rent',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Rent Price',
                              style: const TextStyle(
                                fontSize: AppFontSizes.caption,
                                fontWeight: AppFontWeights.medium,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                            Text(
                              '${Formatter.formatPrice(property.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
                              style: const TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
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
            const SizedBox(height: 12),
            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
          ],
        ],
        if ((property.propertyDetails?.financialInfo?.is_for_sellorrent ??
                false) &&
            (property.listingType?.toLowerCase() == 'rent')) ...[
          if (property.propertyDetails?.financialInfo?.price != null) ...[
            const SizedBox(height: 12),
            Divider(
              indent: 18,
              endIndent: 18,
              color: ColorRes.leadGreyColor.shade300,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Also for Sell',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Sell Price',
                              style: const TextStyle(
                                fontSize: AppFontSizes.caption,
                                fontWeight: AppFontWeights.medium,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                            Text(
                              '${Formatter.formatPrice(property.propertyDetails?.financialInfo?.price ?? 0)}',
                              style: const TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
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

            const SizedBox(height: 12),
            Divider(
              indent: 18,
              endIndent: 18,
              color: ColorRes.leadGreyColor.shade300,
            ),
          ],
        ],

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Property Details',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
        ),
        // SizedBox(height: 16),

        // if (property.builderName != null)
        //   _buildDetailRow('Builder', property.builderName!),
        // if (property.projectName != null)
        //   _buildDetailRow('Project', property.projectName!),
        // _buildDetailRow(
        //   'Property Type',
        //   property.propertyType?.toUpperCase() ?? 'N/A',
        // ),
        // if (propertyDetails?.zoneType != null)
        //   _buildDetailRow('Zone Type', propertyDetails!.zoneType!),
        // if (propertyDetails?.propertyFacing != null)
        //   _buildDetailRow('Facing', propertyDetails!.propertyFacing!),
        // if (propertyDetails?.floorInfo != null)
        //   _buildDetailRow(
        //     'Floor',
        //     '${propertyDetails!.floorInfo!.floorNumber ?? 'N/A'} of ${propertyDetails.floorInfo!.totalFloors ?? 'N/A'}',
        //   ),
        // if (propertyDetails?.furnishInfo?.furnishType != null)
        //   _buildDetailRow(
        //     'Furnishing',
        //     propertyDetails!.furnishInfo!.furnishType!.toUpperCase(),
        //   ),
        // if (propertyDetails?.parkingInfo != null)
        //   _buildDetailRow(
        //     'Parking',
        //     _formatParking(propertyDetails!.parkingInfo!),
        //   ),
        Details(property: property),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: Color(0xff4F47E5),
              fontWeight: AppFontWeights.medium,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
    final property = _property.value!;
    final amenities = property.propertyDetails?.amenities ?? [];
    log("Amenities: ${amenities.map((e) => e).toList()}");

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities.map((amenity) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.blueColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.blueColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconManager.getAmenitiesIcon(amenity),
                          size: 12,
                          color: ColorRes.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          capitalizeEachWord(amenity),
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.blueColor.shade700,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection(BuildContext context, bool isCompact) {
    final property = _property.value!;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Views',
                  '${property.totalViews ?? 0}',
                  Icons.visibility_outlined,
                  ColorRes.blueColor,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Inquiries',
                  '${property.totalInquiries ?? 0}',
                  Icons.question_answer_outlined,
                  ColorRes.orangeColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Favorites',
                  '${property.totalFavorites ?? 0}',
                  Icons.favorite_border,
                  ColorRes.error,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Shares',
                  '${property.totalShares ?? 0}',
                  Icons.share_outlined,
                  ColorRes.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.leadGreyColor[600],
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppFontSizes.large,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.leadGreyColor[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentSection(BuildContext context, bool isCompact) {
    final property = _property.value!;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assignment Information',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xffEEF2FF),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Color.fromARGB(255, 199, 210, 245)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildDetailRow(
                      'Assignment Status',
                      _formatStatus(property.assignmentStatus ?? 'N/A'),
                    ),
                    Spacer(),
                    if (property.assignmentDate != null)
                      _buildDetailRow(
                        'Assigned Date',
                        _formatDate(property.assignmentDate!),
                      ),
                  ],
                ),

                if (property.potentialEarnings != null) ...[
                  SizedBox(height: 12),
                  Expanded(
                    child: _buildDetailRow(
                      'Potential Earnings',
                      '₹${_formatPrice(double.tryParse(property.potentialEarnings!) ?? 0)}',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isCompact,
    Items property,
    Function() onDelete,
  ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(
                    () => CreatePropertyScreen(
                      isLogin: true,
                      isEdit: true,
                      property: property.toAddPropertyModel(),
                    ),
                  );
                },
                icon: Icon(Icons.edit_outlined),
                label: Text(
                  'Edit Property',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  foregroundColor: ColorRes.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Share property
                  //     },
                  //     child: Icon(Icons.share_outlined),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: ColorRes.success.shade700,
                  //       foregroundColor: ColorRes.white,
                  //       padding: EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Share property
                        showDeleteConfirmationDialog(
                          onConfirm: () async {
                            final success = await controller.deleteProperty(
                              property.id ?? '',
                            );
                            if (success) {
                              onDelete();
                              Get.back();
                            }
                          },
                          title: "Delete Property",
                          message:
                              "Are you sure you want to delete this property?",
                        );
                      },
                      icon: Icon(Icons.delete_outline),
                      label: Text(
                        'Delete Property',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.error.shade700,
                        foregroundColor: ColorRes.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return ColorRes.success;
      case 'pending':
        return ColorRes.orangeColor;
      case 'rejected':
      case 'inactive':
        return ColorRes.error;
      default:
        return ColorRes.leadGreyColor;
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(2)} L';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(2)} K';
    }
    return price.toStringAsFixed(0);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildOverviewChip(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: color,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 22, color: ColorRes.blueColor.shade700),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.extraBold,
            color: ColorRes.leadGreyColor[900],
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatParking(ParkingInfo parkingInfo) {
    List<String> parking = [];
    if (parkingInfo.open ?? false) parking.add('Open');
    if (parkingInfo.covered ?? false) parking.add('Covered');
    return parking.isEmpty ? 'None' : parking.join(' & ');
  }
}

class _SubRegistrarRow extends StatelessWidget {
  final String label;
  final String value;

  const _SubRegistrarRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textColor,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.textPrimary,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
