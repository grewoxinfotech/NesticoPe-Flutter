import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/svg_res.dart';
import 'package:nesticope_app/app/manager/data_masker.dart';
import 'package:nesticope_app/app/manager/icon_manager.dart';
import 'package:nesticope_app/app/manager/property/property_name_manager.dart';
import 'package:nesticope_app/app/manager/property/property_pricemanager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/utils/helper_function/contact_helper.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_negotiable_price_screen.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_visit.dart';
import 'package:nesticope_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:nesticope_app/widgets/property/furnishing_details.dart';
import '../../../../app/manager/property_highlight_manager.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../builder/view/builder_leads.dart';
import '../../../performance_score/views/performance_score_screen.dart';
import '../../../property/views/widgets/property_media_gallery.dart';
import '../../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../../seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
import '../../../seller/module/lead_screen/controllers/lead_property_negotiable_price_controller.dart';
import '../../../seller/module/lead_screen/controllers/lead_visit_controller.dart';
import '../../../seller/view/widget/seller_property_approval_history.dart';
import '../../controller/dashborad_controller/dashboard_controller.dart';
import '../../controller/reseller_property_controller/reseller_property_controller.dart';
import '../../model/reseller_lead_model/reseller_lead_overview.dart';
import '../lead/lead_screen.dart';
import '../report/report_screen.dart';

class LeadDetailScreen extends StatefulWidget {
  final LeadItem? lead;
  final Items? property;
  final bool isFromLead;
  final bool isReseller;
  final LeadPropertyInquiryController? leadPropertyInquiryController;
  final LeadVisitController? leadVisitController;
  final LeadPropertyNegotiablePriceController?
  leadPropertyNegotiablePriceController;
  final ResellerPropertyController? propertyController;

  LeadDetailScreen({
    Key? key,
    this.lead,
    this.property,
    this.isFromLead = false,
    this.leadPropertyInquiryController,
    this.leadVisitController,
    this.leadPropertyNegotiablePriceController,
    this.propertyController,
    this.isReseller = false,
  }) : assert(
         (lead != null) != (property != null),
         'You must provide either lead OR property, not both.',
       ),
       super(key: key);

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  Rxn<Items> leadProperty = Rxn<Items>();

  RxBool isLoadingProperty = false.obs;
  RxString markedBy = "".obs;

  @override
  void initState() {
    final propertyId = widget.property?.id ?? widget.lead!.propertyId;
    if (propertyId != null) {
      _initializeProperty(propertyId);
    }

    super.initState();
  }

  // Initialize controller
  final DashboardController controller = Get.put(DashboardController());

  void _initializeProperty(String propertyId) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final propertyController = Get.put(
        PropertyController(),
        tag: 'property_$propertyId',
      );
      isLoadingProperty.value = true;
      print('propertyId: $propertyId');
      leadProperty.value = await propertyController.getPropertyById(propertyId);
      print(
        'leadProperty: ${leadProperty.value?.scoreBreakdown?.toJson() ?? ''}',
      );
      isLoadingProperty.value = false;
    });
  }

  // Helper getters to access data from either lead or property
  // Items get propertyData =>
  //     widget.isFromLead ? leadProperty.value ?? Items() : widget.property!;
  Items get propertyData => leadProperty.value!;

  String get propertyTitle =>
      widget.isFromLead
          ? leadProperty.value?.title ?? ''
          : widget.property!.title ?? '';

  String get propertyAddress =>
      widget.isFromLead
          ? leadProperty.value?.address ?? ''
          : widget.property!.address ?? '';

  String get propertyCity =>
      widget.isFromLead
          ? leadProperty.value?.city ?? ''
          : widget.property!.city ?? '';

  String get propertyState =>
      widget.isFromLead
          ? leadProperty.value?.state ?? ''
          : widget.property!.state ?? '';

  String get propertyZipCode =>
      widget.isFromLead
          ? leadProperty.value?.zipCode ?? ''
          : widget.property!.zipCode ?? '';

  String get propertyType =>
      widget.isFromLead
          ? leadProperty.value?.propertyType ?? ''
          : widget.property!.propertyType ?? '';

  String get listingType =>
      widget.isFromLead
          ? leadProperty.value?.listingType ?? ''
          : widget.property!.listingType ?? '';

  String get builderName =>
      widget.isFromLead
          ? leadProperty.value?.ownerName ?? ''
          : widget.property!.ownerName ?? '';

  String get projectName =>
      widget.isFromLead
          ? leadProperty.value?.projectName ?? ''
          : widget.property!.projectName ?? '';

  List<String> get propertyImages =>
      widget.isFromLead
          ? leadProperty.value?.propertyMedia?.images ?? []
          : widget.property!.propertyMedia?.images ?? [];

  List<String> get propertyVideos =>
      widget.isFromLead
          ? leadProperty.value?.propertyMedia?.videos ?? []
          : widget.property!.propertyMedia?.videos ?? [];

  PropertyDetails? get propertyDetails =>
      widget.isFromLead
          ? leadProperty.value?.propertyDetails
          : widget.property!.propertyDetails;

  Items get property =>
      widget.isFromLead
          ? leadProperty?.value ?? Items()
          : widget.property ?? Items();

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;

    log(
      "Building Name in Reseller ${property.propertyDetails?.furnishInfo?.furnishDetails?.toJson()}",
    );

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
        ),
        title: Text(
          '${(widget.isFromLead) ? 'Lead Details' : 'Property Overview'}',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        // actions: [
        //   IconButtvsgsv bsgwh bdheb hsdbgs on(
        //     icon: const Icon(Icons.more_verhdub sbdhsb t),
        //     onPressed: () => _showMoreOptions(context),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Contact Information (Only for Leads)
              if (widget.isFromLead) ...[
                _buildContactSection(context, isCompact),
                Divider(thickness: 8, color: Colors.grey[100]),
              ],

              // 2. Property Image Gallery (Always Visible)
              // _buildPropertyImageGallery(context),
              Obx(() {
                if (leadProperty.value == null &&
                    widget.isFromLead &&
                    isLoadingProperty.value) {
                  return Container(
                    height: 280,
                    color: ColorRes.leadGreyColor[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorRes.primary,
                        ),
                      ),
                    ),
                  );
                }

                return PropertyMediaGallery(
                  images: propertyImages,
                  videos: propertyVideos,
                  showShare: false,
                  showFavorite: false,
                  showBackButton: false,
                );
              }),

              Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

              // 3. Property Overview (Always Visible)
              Obx(() {
                if (leadProperty.value == null && isLoadingProperty.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!isLoadingProperty.value && leadProperty.value == null) {
                  return SizedBox.shrink();
                }
                return _buildPropertyOverviewSection(context, isCompact);
              }),

              // Expand/Collapse Button

              // Conditional Sections (Show when expanded)
              Obx(
                () =>
                    controller.isResellerDetailExpanded.value
                        ? Column(
                          children: [
                            Divider(
                              thickness: 8,
                              color: ColorRes.leadGreyColor[100],
                            ),

                            // 4. Property Details
                            _buildPropertyDetailsSection(context, isCompact),

                            if (propertyDetails?.amenities?.isNotEmpty ??
                                false) ...[
                              Divider(
                                thickness: 8,
                                color: ColorRes.leadGreyColor[100],
                              ),

                              // 5. Amenities
                              _buildAmenitiesSection(context, isCompact),
                              Divider(
                                thickness: 8,
                                color: ColorRes.leadGreyColor[100],
                              ),
                            ],

                            Obx(() => _buildExpandButton(context)),
                          ],
                        )
                        : Obx(() => _buildExpandButton(context)),
              ),

              // 6. Financial Information
              if (widget.isFromLead)
                Obx(() {
                  if (leadProperty.value == null && isLoadingProperty.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!isLoadingProperty.value && leadProperty.value == null) {
                    return SizedBox.shrink();
                  }
                  Divider(thickness: 8, color: ColorRes.leadGreyColor[100]);
                  return _buildFinancialSection(context, isCompact);
                })
              else
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
              _buildFinancialSection(context, isCompact),

              // if (widget.isFromLead) ...[
              //   Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
              //
              //   // 7. Lead Status & Timeline
              //   _buildStatusTimelineSection(context, isCompact),
              // ],
              Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child:
                    widget.lead != null
                        ? Obx(
                          () => PropertyOverviewCard(
                            property: leadProperty.value,
                          ),
                        )
                        : PropertyOverviewCard(property: widget.property),
              ),

              if (widget.property != null) ...[
                if (widget.property?.propertyStatus?.toLowerCase() !=
                    "sold") ...[
                  Divider(thickness: 8, color: Colors.grey[100]),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _buildSectionHeader(
                      'Report',
                      Icons.report_gmailerrorred_outlined,
                      isCompact,
                    ),
                  ),
                  ReportPropertyCard(propertyId: widget.property!.id!),
                ],
              ],

              // 8. Notes Section (Only for Leads)
              if (widget.isFromLead && widget.lead?.notes != null) ...[
                Divider(thickness: 8, color: Colors.grey[100]),
                _buildNotesSection(context, isCompact),
              ],

              if ((widget.lead?.isFake ?? false) && widget.isFromLead) ...[
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildSectionHeader(
                    'Lead Status',
                    Icons.leaderboard_sharp,
                    true,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFBDBD)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "MARKED AS FAKE",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Marked By: Adimn\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              // TextSpan(text: "Admin\n"),
                              TextSpan(
                                text: "On: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${Formatter.formatDateFromDateTime(DateTime.tryParse(widget.lead?.markedFakeAt ?? ''))}\n",
                              ),

                              TextSpan(
                                text: "Reason: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: "${widget.lead?.fakeReason}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if ((widget.lead?.status?.toLowerCase() == "converted") &&
                  (widget.lead?.stage?.toLowerCase() == "sell")) ...[
                Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildSectionHeader(
                    'Lead Status',
                    Icons.leaderboard_sharp,
                    true,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // 🟢 Add your action here
                    // Example: Get.to(() => CommissionPaymentScreen(lead: widget.lead));
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FBE8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF86E386)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.attach_money_rounded,
                          color: Color(0xFF27AE60),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "PAY PARTNER COMMISSION NOW",
                          style: TextStyle(
                            color: Color(0xFF27AE60),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
              Obx(() {
                if (leadProperty.value == null && isLoadingProperty.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!isLoadingProperty.value && leadProperty.value == null) {
                  return SizedBox.shrink();
                }
                return _buildAnalyticsSection(
                  context,
                  propertyData,
                  widget.leadPropertyInquiryController,
                  widget.leadVisitController ?? LeadVisitController(),
                  widget.leadPropertyNegotiablePriceController ??
                      LeadPropertyNegotiablePriceController(),
                  widget.isFromLead,
                  widget.lead == null,
                );
              }),

              Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),

              // 9. Action Buttons
              // _buildActionButtons(context, isCompact),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(
    BuildContext context,
    Items property,
    LeadPropertyInquiryController? propertyInquiryController,
    LeadVisitController leadVisitController,
    LeadPropertyNegotiablePriceController leadPropertyNegotiablePriceController,
    bool isFromLead,
    bool isLeadIsempty,
    
  ) {
    return Column(
      children: [
        /// Analytics
        if (!isFromLead && isLeadIsempty) ...[
          if (property.scoreBreakdown != null) ...[
            PerformanceScoreWidget(score: property.scoreBreakdown!),
          ],
        ],

        /// Approval History
        if (!isFromLead && isLeadIsempty) ...[
          // ListTile(
          //   tileColor: ColorRes.white,
          //   title: Text(
          //     'Approval History',
          //     style: TextStyle(
          //       fontSize: AppFontSizes.medium,
          //       fontWeight: AppFontWeights.semiBold,
          //     ),
          //   ),
          //   leading: Icon(Icons.history, color: ColorRes.primary),
          //   trailing: Icon(Icons.arrow_forward_ios_rounded),
          //   onTap: () {
          //     Get.to(
          //       () => SellerPropertyApprovalHistory(
          //         propertyId: property.id ?? '',
          //       ),
          //     );
          //   },
          // ),
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

          const SizedBox(height: 8),

          // ListTile(
          //   tileColor: ColorRes.white,
          //   title: Text(
          //     'Leads',
          //     style: TextStyle(
          //       fontSize: AppFontSizes.medium,
          //       fontWeight: AppFontWeights.semiBold,
          //     ),
          //   ),
          //   leading: Icon(Icons.leaderboard_outlined, color: ColorRes.primary),
          //   trailing: Icon(Icons.arrow_forward_ios_rounded),
          //   onTap: () {
          //     Get.to(
          //       () =>
          //           widget.isReseller
          //               ? CommonLeadScreen(
          //                 title: 'Property Buyer Leads',
          //                 controllerTag: 'reseller',
          //                 entityId: property.id,
          //                 showDataMasking: true,
          //                 onLoadMore: (controller, id) async {
          //                   if (id != null) {
          //                     controller.loadMorePropertyLeads(id);
          //                   } else {
          //                     controller.loadMore();
          //                   }
          //                 },
          //               )
          //               : BuilderLeads(projectId: property.id ?? ''),
          //     );
          //   },
          // ),
          _buildMenuItem(
            title: "Leads",
            iconColor: ColorRes.builderGridPink,
            icon: Icons.leaderboard_outlined,
            onTap: () {
              Get.to(
                () =>
                    widget.isReseller
                        ? CommonLeadScreen(
                          title: 'Property Buyer Leads',
                          controllerTag: 'reseller',
                          entityId: property.id,
                          showDataMasking: true,
                          onLoadMore: (controller, id) async {
                            if (id != null) {
                              controller.loadMorePropertyLeads(id);
                            } else {
                              controller.loadMore();
                            }
                          },
                        )
                        : BuilderLeads(projectId: property.id ?? ''),
              );
            },
            iconBg: ColorRes.builderGridPink.withOpacity(0.1),
            subtitle: 'View negotiable price history',
          ),
        ],
        const SizedBox(height: 8),
        if (!UserHelper.isReseller) ...[
          //  ListTile(
          //    tileColor: ColorRes.white,
          //    title: Text(
          //      'Visit',
          //      style: TextStyle(
          //        fontSize: AppFontSizes.medium,
          //        fontWeight: AppFontWeights.semiBold,
          //      ),
          //    ),
          //    leading: Icon(Icons.history, color: ColorRes.primary),
          //    trailing: Icon(Icons.arrow_forward_ios_rounded),
          //    onTap: () {
          //      // final buyerId=propertyInquiryController?.selectedInquiry.value?.userId;
          //      // final propertyId=propertyInquiryController?.selectedInquiry.value?.propertyId;

          //      log(
          //        "Buyer Data ${property.id}    ============== ${propertyInquiryController?.selectedInquiry.value?.propertyId}",
          //      );
          //      log(
          //        "Buyer Id from api ${propertyInquiryController?.selectedInquiry.value?.userId}",
          //      );
          //      Get.to(
          //            () => LeadVisit(
          //          leadVisitController: leadVisitController,
          //          propertyInquiryController:
          //          propertyInquiryController ??
          //              LeadPropertyInquiryController(),
          //          buyerID:
          //          propertyInquiryController?.selectedInquiry.value?.userId,
          //          propertyId:
          //          propertyInquiryController
          //              ?.selectedInquiry
          //              .value
          //              ?.propertyId ??
          //              property.id,
          //        ),
          //      );
          //    },
          //  ),
          _buildMenuItem(
            iconColor: ColorRes.deepPurpleColor,
            title: "Visit",
            icon: Icons.history,
            onTap: () {
              log(
                "Buyer Data ${property.id}    ============== ${propertyInquiryController?.selectedInquiry.value?.propertyId}",
              );
              log(
                "Buyer Id from api ${propertyInquiryController?.selectedInquiry.value?.userId}",
              );
              Get.to(
                () => LeadVisit(
                  leadVisitController: leadVisitController,
                  // leadItem: ,
                  propertyInquiryController:
                      propertyInquiryController ??
                      LeadPropertyInquiryController(),
                  buyerID:
                      propertyInquiryController?.selectedInquiry.value?.userId,
                  propertyId:
                      propertyInquiryController
                          ?.selectedInquiry
                          .value
                          ?.propertyId ??
                      property.id,
                ),
              );
            },
            iconBg: ColorRes.deepPurpleColor.withOpacity(0.1),
            subtitle: 'View visit history',
          ),
          const SizedBox(height: 8),
          // ListTile(
          //   tileColor: ColorRes.white,
          //   title: Text(
          //     'Negotiable',
          //     style: TextStyle(
          //       fontSize: AppFontSizes.medium,
          //       fontWeight: AppFontWeights.semiBold,
          //     ),
          //   ),
          //   leading: Icon(
          //     Icons.currency_rupee_outlined,
          //     color: ColorRes.primary,
          //   ),
          //   trailing: Icon(Icons.arrow_forward_ios_rounded),
          //   onTap: () {
          //     final selectedInquiry =
          //         propertyInquiryController?.selectedInquiry.value;

          //     // Set visit id
          //     log(
          //       'Setting visit ID for user ${selectedInquiry?.userId} and property ${selectedInquiry?.propertyId}',
          //     );
          //     leadPropertyNegotiablePriceController.setLeadNegotiablePriceId(
          //       selectedInquiry?.propertyId ?? property.id ?? '',
          //       buyerID: selectedInquiry?.userId ?? '',
          //     );
          //     log(
          //       'Negotiable Price ID set: ${leadPropertyNegotiablePriceController.items.map((e) => e.toMap())}',
          //     );

          //     Get.to(
          //       () => LeadNegotiablePriceScreen(
          //         controller: leadPropertyNegotiablePriceController,
          //       ),
          //     );
          //   },
          // ),
          _buildMenuItem(
            title: "Negotiable",
            iconColor: ColorRes.builderGridPink,
            icon: Icons.currency_rupee_outlined,
            onTap: () {
              final selectedInquiry =
                  propertyInquiryController?.selectedInquiry.value;

              // Set visit id
              log(
                'Setting visit ID for user ${selectedInquiry?.userId} and property ${selectedInquiry?.propertyId}',
              );
              leadPropertyNegotiablePriceController.setLeadNegotiablePriceId(
                selectedInquiry?.propertyId ?? property.id ?? '',
                buyerID: selectedInquiry?.userId ?? '',
              );
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
        ],

        const SizedBox(height: 8),
        if (widget.isFromLead) ...[
          // ListTile(
          //   tileColor: ColorRes.white,
          //   title: Text(
          //     'Follow Ups',
          //     style: TextStyle(
          //       fontSize: AppFontSizes.medium,
          //       fontWeight: AppFontWeights.semiBold,
          //     ),
          //   ),
          //   leading: Icon(Icons.follow_the_signs, color: ColorRes.primary),
          //   trailing: Icon(Icons.arrow_forward_ios_rounded),
          //   onTap: () {
          //     final selectedInquiry =
          //         propertyInquiryController?.selectedInquiry.value;

          //     // Set visit id
          //     log(
          //       'Setting visit ID for user ${selectedInquiry?.userId} and property ${selectedInquiry?.propertyId}',
          //     );
          //     leadPropertyNegotiablePriceController.setLeadNegotiablePriceId(
          //       selectedInquiry?.propertyId ?? property.id ?? '',
          //       buyerID: selectedInquiry?.userId ?? '',
          //     );
          //     log(
          //       'Negotiable Price ID set: ${leadPropertyNegotiablePriceController.items.map((e) => e.toMap())}',
          //     );

          //     log("Set the lead user ${widget.lead?.toJson()}");
          //     leadVisitController.getLeadId(widget.lead?.id ?? '');
          //     Get.to(() => LeadFollowUpScreen(controller: leadVisitController));
          //   },
          // ),
          _buildMenuItem(
            title: "Follow Ups",
            iconColor: ColorRes.green,
            icon: Icons.follow_the_signs,
            onTap: () {
              final selectedInquiry =
                  propertyInquiryController?.selectedInquiry.value;

              // Set visit id
              log(
                'Setting visit ID for user ${selectedInquiry?.userId} and property ${selectedInquiry?.propertyId}',
              );
              leadPropertyNegotiablePriceController.setLeadNegotiablePriceId(
                selectedInquiry?.propertyId ?? property.id ?? '',
                buyerID: selectedInquiry?.userId ?? '',
              );
              log(
                'Negotiable Price ID set: ${leadPropertyNegotiablePriceController.items.map((e) => e.toMap())}',
              );

              log("Set the lead user ${widget.lead?.toJson()}");
              leadVisitController.getLeadId(widget.lead?.id ?? '');
              Get.to(() => LeadFollowUpScreen(controller: leadVisitController));
            },
            iconBg: ColorRes.green.withOpacity(0.1),
            subtitle: 'View follow up history',
          ),
        ],
        const SizedBox(height: 8),
      ],
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

  Widget _buildExpandButton(BuildContext context) {
    return InkWell(
      onTap: () => controller.toggleExpanded(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.isResellerDetailExpanded.value
                  ? 'Hide Additional Details'
                  : 'Show Additional Details',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: isCompact ? 24 : 28,
                backgroundColor: ColorRes.primary.withOpacity(0.2),
                child: Text(
                  widget.lead!.name!
                      .split(' ')
                      .map((e) => e[0])
                      .join()
                      .toUpperCase(),
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.semiBold,
                    fontSize:
                        isCompact ? AppFontSizes.medium : AppFontSizes.large,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DataMasker.maskName(widget.lead!.name!),
                      style: TextStyle(
                        fontSize:
                            isCompact ? AppFontSizes.body : AppFontSizes.large,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorRes.leadGreyColor[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Lead Source: ${widget.lead!.source!.toUpperCase()}',
                              style: TextStyle(
                                color: ColorRes.leadGreyColor[700],
                                fontSize: AppFontSizes.extraSmall,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorRes.leadGreyColor[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Property Type: ${propertyType.toUpperCase()}',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.leadGreyColor[700],
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildContactRow(
            Icons.email_outlined,
            'Email',
            DataMasker.maskEmail(widget.lead!.email!),
            Colors.blue,
            () => _launchEmail(widget.lead!.email!),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildContactRow(
                  Icons.phone_outlined,
                  'Phone',
                  DataMasker.maskPhone(widget.lead!.phone!),
                  Colors.green,
                  () => _launchPhone(widget.lead!.phone!),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: AppFontWeights.medium,
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.leadGreyColor[700],
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.textColor,
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

  Widget _buildPropertyImageGallery(BuildContext context) {
    final dummyImages = [
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
      'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
    ];

    return Container(
      height: 280,
      color: ColorRes.white,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: dummyImages.length,
            onPageChanged: (value) {},
            itemBuilder: (context, index) {
              return Image.network(
                dummyImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ColorRes.leadGreyColor[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          size: 80,
                          color: ColorRes.leadGreyColor[400],
                        ),
                        SizedBox(height: 8),
                        Text(
                          propertyTitle,
                          style: TextStyle(
                            fontSize: AppFontSizes.large,
                            fontWeight: AppFontWeights.bold,
                            color: ColorRes.leadGreyColor[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorRes.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '1/${dummyImages.length}',
                style: TextStyle(
                  color: ColorRes.white,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),
          if (widget.isFromLead)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.lead!.status!),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(
                      widget.lead!.status!,
                    ).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(widget.lead!.status!),
                  style: TextStyle(
                    color: ColorRes.white,
                    fontSize: AppFontSizes.extraSmall,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
  //   final details = propertyDetails;
  //   if (details == null) return SizedBox.shrink();
  //   final nameManager = PropertyNameManager(propertyData);
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildSectionHeader(
  //           'Property Overview',
  //           Icons.home_outlined,
  //           isCompact,
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           nameManager.displayName,
  //           style: TextStyle(
  //             fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
  //             fontWeight: AppFontWeights.semiBold,
  //             color: ColorRes.textColor,
  //           ),
  //         ),
  //         const SizedBox(height: 6),
  //         SizedBox(
  //           width: 300,
  //           child: Text(
  //             '$propertyAddress, $propertyCity, $propertyState - $propertyZipCode',
  //             style: TextStyle(
  //               fontSize:
  //                   isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
  //               color: ColorRes.leadGreyColor[700],
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Wrap(
  //           spacing: 10,
  //           runSpacing: 10,
  //           children: [
  //             if (details.bhk != null && details.bhk! > 0) ...[
  //               _buildOverviewChip(
  //                 '${details.bhk ?? 0} BHK',
  //                 Icons.bed_outlined,
  //                 ColorRes.primary,
  //                 isCompact,
  //               ),
  //             ],
  //             _buildOverviewChip(
  //               propertyType.toUpperCase(),
  //               Icons.apartment_outlined,
  //               ColorRes.purpleColor,
  //               isCompact,
  //             ),
  //             _buildOverviewChip(
  //               listingType,
  //               Icons.sell_outlined,
  //               ColorRes.orangeColor,
  //               isCompact,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             if (details.propertyCarpetArea != null) ...[
  //               _buildStatItem(
  //                 '${details.propertyCarpetArea ?? 0}',
  //                 'Carpet Area\n(sq.ft)',
  //                 Icons.straighten,
  //                 isCompact,
  //               ),
  //             ],
  //             Container(
  //               width: 1,
  //               height: 50,
  //               color: ColorRes.leadGreyColor[300],
  //             ),
  //             if (details.bathroom != null && details.bathroom! > 0) ...[
  //               _buildStatItem(
  //                 '${details.bathroom ?? 0}',
  //                 'Bathrooms',
  //                 Icons.bathtub_outlined,
  //                 isCompact,
  //               ),
  //               Container(
  //                 width: 1,
  //                 height: 50,
  //                 color: ColorRes.leadGreyColor[300],
  //               ),
  //             ],
  //             if (details.bathroom != null && details.bathroom! > 0) ...[
  //               _buildStatItem(
  //                 '${details.balcony ?? 0}',
  //                 'Balconies',
  //                 Icons.balcony_outlined,
  //                 isCompact,
  //               ),
  //             ],
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
    final details = propertyDetails;
    if (details == null) return SizedBox.shrink();
    final nameManager = PropertyNameManager(propertyData);
    final reraId = propertyData.reraId;
    final hasValidReraId =
        reraId != null && reraId.isNotEmpty && reraId.toLowerCase() != 'null';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(
                'Property Overview',
                Icons.home_outlined,
              
                isCompact,
              ),

            if(property.propertyStatus?.toLowerCase()=='sold' || property.propertyStatus?.toLowerCase()=='rented')...[
                _buildOverviewChip(
                property.propertyStatus?.toUpperCase()??'',
                Icons.sell_outlined,
                (property.propertyStatus?.toLowerCase()=='sold')?ColorRes.error:ColorRes.homeAmber,
                isCompact,
              ),
            ]else...[
                _buildOverviewChip(
                property.propertyStatus??'',
                Icons.sell_outlined,
                ColorRes.deepPurpleColor,
                isCompact,
              ),
            ]
            ],
          ),
          const SizedBox(height: 16),
          Text(
            nameManager.displayName,
            style: TextStyle(
              fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 300,
            child: Text(
              '$propertyAddress, $propertyCity, $propertyState - $propertyZipCode',
              style: TextStyle(
                fontSize: isCompact ? AppFontSizes.caption : AppFontSizes.small,
                color: ColorRes.leadGreyColor[700],
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (details.bhk != null && details.bhk! > 0) ...[
                _buildOverviewChip(
                  '${details.bhk ?? 0} BHK',
                  Icons.bed_outlined,
                  ColorRes.primary,
                  isCompact,
                ),
              ],
              _buildOverviewChip(
                propertyType.toUpperCase().replaceAll("_", " "),
                Icons.apartment_outlined,
                ColorRes.purpleColor,
                isCompact,
              ),
              _buildOverviewChip(
                listingType,
                Icons.sell_outlined,
                ColorRes.orangeColor,
                isCompact,
              ),
            ],
          ),
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
          const SizedBox(height: 20),

          // ✅ Replaced static Row with dynamic highlights
          _buildDynamicHighlightsRow(isCompact),
        ],
      ),
    );
  }

  Widget _buildDynamicHighlightsRow(bool isCompact) {
    final highlightManager = PropertyHighlightManager(propertyData);
    final highlights = highlightManager.getHighlights();

    if (highlights.isEmpty) return const SizedBox.shrink();

    final limitedHighlights = highlights.take(3).toList();

    final items = <Widget>[];
    for (int i = 0; i < limitedHighlights.length; i++) {
      final h = limitedHighlights[i];

      items.add(_buildStatItem(h.value, h.title, h.icon!, isCompact));

      if (i < limitedHighlights.length - 1) {
        items.add(
          Container(width: 1, height: 50, color: ColorRes.leadGreyColor[300]),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isCompact) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: ColorRes.primary),
        ),

        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.bodySmall : AppFontSizes.body,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewChip(
    String text,
    IconData icon,
    Color color,
    bool isCompact,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize:
                  isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
              color: color,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    bool isCompact,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isCompact ? 18 : 22,
          color: ColorRes.primary.withOpacity(0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.small : AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
            color: ColorRes.leadGreyColor[700],
            fontWeight: AppFontWeights.medium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
    final details = propertyDetails;
    if (details == null) return SizedBox.shrink();

    final furnishInfo = details.furnishInfo;
    final floorInfo = details.floorInfo;
    final possessionInfo = details.possessionInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((propertyDetails?.financialInfo?.is_for_sellorrent ?? false) &&
            (listingType?.toLowerCase() == 'sell')) ...[
          if (propertyDetails?.financialInfo?.propertyRentPerMonth != null) ...[
            // Padding(

            // Divider(
            //   indent: 18,
            //   endIndent: 18,
            //   color: ColorRes.leadGreyColor.shade300,
            // ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    'Also for Rent',
                    Icons.sell_outlined,
                    true,
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
                                '${Formatter.formatPrice(propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
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
            ),
            const SizedBox(height: 12),
          ],
        ],
        if ((propertyDetails?.financialInfo?.is_for_sellorrent ?? false) &&
            (listingType?.toLowerCase() == 'rent')) ...[
          if (propertyDetails?.financialInfo?.price != null) ...[
            const SizedBox(height: 12),

            // Divider(
            //   indent: 18,
            //   endIndent: 18,
            //   color: ColorRes.leadGreyColor.shade300,
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    'Also for Sell',
                    Icons.sell_outlined,
                    true,
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
                                '${Formatter.formatPrice(propertyDetails?.financialInfo?.price ?? 0)}',
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
            ),

            const SizedBox(height: 12),
            Divider(thickness: 8, color: ColorRes.leadGreyColor[100]),
            const SizedBox(height: 12),
          ],
        ],

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSectionHeader('Property Details', Icons.info_outline, true),
              SizedBox(height: 12),

              if (builderName.isNotEmpty &&
                  (!builderName.contains("null")) &&
                  builderName != null)
                _buildDetailRow('Builder', builderName),
              if (projectName.isNotEmpty)
                _buildDetailRow('Project', projectName),
              _buildDetailRow('Property Type', propertyType.toUpperCase()),
              if (details.zoneType != null)
                _buildDetailRow('Zone Type', details.zoneType!),
              if (details.propertyFacing != null)
                _buildDetailRow('Facing', details.propertyFacing!),
              if (floorInfo != null)
                _buildDetailRow(
                  'Floor',
                  '${floorInfo.floorNumber ?? 0} of ${floorInfo.totalFloors ?? 0}',
                ),
              if (details.propertyBuiltUpArea != null)
                _buildDetailRow(
                  'Built-up Area',
                  '${details.propertyBuiltUpArea} sq.ft',
                ),
              if (details.propertyCarpetArea != null)
                _buildDetailRow(
                  'Carpet Area',
                  '${details.propertyCarpetArea} sq.ft',
                ),
              if (furnishInfo?.furnishType != null)
                _buildDetailRow(
                  'Furnishing',
                  furnishInfo!.furnishType!.toUpperCase(),
                ),
              if (furnishInfo?.furnishDetails?.ac != null)
                _buildDetailRow(
                  'AC Installed',
                  furnishInfo!.furnishDetails!.ac! > 0
                      ? furnishInfo!.furnishDetails!.ac!.toString()
                      : 'No',
                ),
              if (details.parkingInfo != null)
                _buildDetailRow(
                  'Parking',
                  '${details.parkingInfo!.open == true ? "Open" : ""}${details.parkingInfo!.open == true && details.parkingInfo!.covered == true ? " & " : ""}${details.parkingInfo!.covered == true ? "Covered" : ""}',
                ),
              if (possessionInfo?.possessionStatus != null)
                _buildDetailRow(
                  'Possession',
                  possessionInfo!.possessionStatus!.capitalize
                      .toString()
                      .replaceAll("_", " "),
                ),
              if (possessionInfo?.propertyAgeInYear != null)
                _buildDetailRow(
                  'Property Age',
                  '${possessionInfo?.propertyAgeInYear != null && possessionInfo?.propertyAgeInYear != "null" ? possessionInfo?.propertyAgeInYear : "Not define"} years',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.leadGreyColor[600],
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
    final amenities = propertyDetails?.amenities ?? [];
    if (amenities.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Amenities', Icons.star_outline, true),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities.map((amenity) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconManager.getAmenitiesIcon(amenity),
                          size: 16,
                          color: ColorRes.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          capitalizeEachWord(amenity),
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.primary,
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

  // Widget _buildFinancialSection(BuildContext context, bool isCompact) {
  //   final financialInfo = _resolvedFinancialInfo;
  //   final priceManager = PropertyPriceManager(
  //     listingType: widget.lead?.customFields?.listingType ?? '',
  //     financialInfo: widget.lead?.customFields?.propertyDetails?.financialInfo,
  //   );
  //   if (financialInfo == null) return SizedBox.shrink();
  //
  //   return Padding(
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildSectionHeader(
  //           'Financial Information',
  //           Icons.currency_rupee_outlined,
  //           isCompact,
  //         ),
  //         SizedBox(height: 16),
  //         Container(
  //           padding: EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(16),
  //             border: Border.all(color: ColorRes.success.shade200, width: 1),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Property Price Section
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               'Property Price',
  //                               style: TextStyle(
  //                                 fontSize: AppFontSizes.medium,
  //                                 fontWeight: AppFontWeights.semiBold,
  //                                 color: ColorRes.leadGreyColor[700],
  //                                 letterSpacing: 0.3,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: 8),
  //                         Text(
  //                           priceManager.displayPrice,
  //                           style: TextStyle(
  //                             fontSize: isCompact ? AppFontSizes.large : 32,
  //                             fontWeight: AppFontWeights.semiBold,
  //                             color: ColorRes.success.shade800,
  //                             height: 1.2,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   if (financialInfo.negotiable)
  //                     Container(
  //                       padding: EdgeInsets.symmetric(
  //                         horizontal: 14,
  //                         vertical: 8,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: (widget.isFromLead
  //                                 ? _getStatusColor(widget.lead!.status!)
  //                                 : Colors.green)
  //                             .withOpacity(0.08),
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(
  //                           color: (widget.isFromLead
  //                                   ? _getStatusColor(widget.lead!.status!)
  //                                   : Colors.green)
  //                               .withOpacity(0.3),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Text(
  //                             'Negotiable',
  //                             style: TextStyle(
  //                               fontSize: AppFontSizes.extraSmall,
  //                               color:
  //                                   widget.isFromLead
  //                                       ? _getStatusColor(widget.lead!.status!)
  //                                       : Colors.green,
  //                               fontWeight: AppFontWeights.extraBold,
  //                               letterSpacing: 0.5,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //
  //               SizedBox(height: 16),
  //               Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.4)),
  //               SizedBox(height: 16),
  //
  //               // Broker Commission Section
  //               Container(
  //                 padding: EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: ColorRes.white,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(
  //                     color: ColorRes.leadGreyColor.shade300,
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Container(
  //                           padding: EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: ColorRes.primary.withOpacity(0.1),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: Icon(
  //                             Icons.account_balance_wallet_outlined,
  //                             size: 20,
  //                             color: ColorRes.primary,
  //                           ),
  //                         ),
  //                         SizedBox(width: 12),
  //                         Text(
  //                           'Broker Commission',
  //                           style: TextStyle(
  //                             fontSize: AppFontSizes.small,
  //                             color: ColorRes.leadGreyColor[700],
  //                             fontWeight: AppFontWeights.semiBold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Text(
  //                       priceManager.brokerCommission ?? '0.00',
  //                       style: TextStyle(
  //                         fontSize:
  //                             isCompact
  //                                 ? AppFontSizes.medium
  //                                 : AppFontSizes.large,
  //                         fontWeight: AppFontWeights.semiBold,
  //                         color: ColorRes.primary,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               // Reactive Section with Obx
  //               Obx(() {
  //                 final hasOffer = controller.submittedOfferAmount.value != 0.0;
  //
  //                 return Column(
  //                   children: [
  //                     // Submitted Offer Section
  //                     if (hasOffer) ...[
  //                       SizedBox(height: 16),
  //                       Container(
  //                         padding: EdgeInsets.all(14),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(12),
  //                           border: Border.all(
  //                             color: ColorRes.leadGreyColor.shade300, bchdbbnsdiun cnjsn 
  //                             width: 1,
  //                           ),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                       padding: EdgeInsets.all(8),
  //                                       decoration: BoxDecoration(
  //                                         color: ColorRes.orangeColor.shade50,
  //                                         borderRadius: BorderRadius.circular(
  //                                           8,
  //                                         ),
  //                                       ),
  //                                       child: Icon(
  //                                         Icons.handshake_rounded,
  //                                         size: 20,
  //                                         color: ColorRes.orangeColor.shade700,
  //                                       ),
  //                                     ),
  //                                     SizedBox(width: 12),
  //                                     SizedBox(
  //                                       width: 150,
  //                                       child: Text(
  //                                         'Negotiable Price',
  //                                         style: TextStyle(
  //                                           fontSize: AppFontSizes.small,
  //                                           fontWeight: AppFontWeights.semiBold,
  //                                         ),
  //                                         maxLines: 1,
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 Text(
  //                                   Formatter.formatPrice(
  //                                     controller.submittedOfferAmount.value,
  //                                   ),
  //                                   style: TextStyle(
  //                                     fontSize:
  //                                         isCompact
  //                                             ? AppFontSizes.medium
  //                                             : AppFontSizes.large,
  //                                     fontWeight: AppFontWeights.extraBold,
  //                                     color: ColorRes.orangeColor,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(height: 10),
  //                             Container(
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: 12,
  //                                 vertical: 6,
  //                               ),
  //                               decoration: BoxDecoration(
  //                                 color: ColorRes.orangeColor.withOpacity(0.08),
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 border: Border.all(
  //                                   color: ColorRes.orangeColor.withOpacity(
  //                                     0.3,
  //                                   ),
  //                                   width: 1,
  //                                 ),
  //                               ),
  //                               child: Row(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: [
  //                                   Icon(
  //                                     Icons.pending_outlined,
  //                                     size: 14,
  //                                     color: ColorRes.orangeColor.shade700,
  //                                   ),
  //                                   SizedBox(width: 6),
  //                                   Text(
  //                                     'Pending Review',
  //                                     style: TextStyle(
  //                                       fontSize: AppFontSizes.extraSmall,
  //                                       color: ColorRes.orangeColor.shade700,
  //                                       fontWeight: AppFontWeights.semiBold,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),,
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //
  //                     // Negotiation Button
  //                     if (financialInfo.negotiable) ...[
  //                       SizedBox(height: 16),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: ElevatedButton.icon(
  //                           onPressed:
  //                               !hasOffer
  //                                   ? () => _handleNegotiation(context)
  //                                   : null,
  //                           icon: Icon(
  //                             !hasOffer
  //                                 ? Icons.chat_bubble_outline
  //                                 : Icons.check_circle_outline,
  //                             size: 18,
  //                           ),
  //                           label: Text(
  //                             !hasOffer
  //                                 ? 'Start Negotiation'
  //                                 : 'Offer Submitted',
  //                             style: TextStyle(
  //                               fontSize: AppFontSizes.medium,
  //                               fontWeight: FontWeight.bold,
  //                               letterSpacing: 0.5,
  //                             ),
  //                           ),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 !hasOffer
  //                                     ? ColorRes.success.shade600
  //                                     : ColorRes.leadGreyColor.shade400,
  //                             foregroundColor: ColorRes.white,
  //                             padding: EdgeInsets.symmetric(vertical: 14),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             elevation: 0,
  //                             shadowColor: ColorRes.success.withOpacity(0.3),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ],
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFinancialSection(BuildContext context, bool isCompact) {
  //   final financialInfo = _resolvedFinancialInfo;
  //   if (financialInfo == null) return const SizedBox.shrink();
  //
  //   final priceManager = PropertyPriceManager(
  //     listingType: propertyType,
  //     financialInfo: financialInfo,
  //   );
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildSectionHeader(
  //           'Financial Information',
  //           Icons.currency_rupee_outlined,
  //           isCompact,
  //         ),
  //         const SizedBox(height: 16),
  //
  //         Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(16),
  //             border: Border.all(color: ColorRes.success.shade200, width: 1),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // 🔹 PROPERTY PRICE
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Property Price',
  //                           style: TextStyle(
  //                             fontSize: AppFontSizes.medium,
  //                             fontWeight: AppFontWeights.semiBold,
  //                             color: ColorRes.leadGreyColor[700],
  //                             letterSpacing: 0.3,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text(
  //                           priceManager.displayPrice,
  //                           style: TextStyle(
  //                             fontSize: isCompact ? AppFontSizes.large : 32,
  //                             fontWeight: AppFontWeights.semiBold,
  //                             color: ColorRes.success.shade800,
  //                             height: 1.2,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //
  //                   // 🔹 Negotiable Chip
  //                   if (financialInfo.negotiable)
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 14,
  //                         vertical: 8,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: (widget.isFromLead
  //                                 ? _getStatusColor(widget.lead!.status!)
  //                                 : Colors.green)
  //                             .withOpacity(0.08),
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(
  //                           color: (widget.isFromLead
  //                                   ? _getStatusColor(widget.lead!.status!)
  //                                   : Colors.green)
  //                               .withOpacity(0.3),
  //                           width: 1,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         'Negotiable',
  //                         style: TextStyle(
  //                           fontSize: AppFontSizes.extraSmall,
  //                           color:
  //                               widget.isFromLead
  //                                   ? _getStatusColor(widget.lead!.status!)
  //                                   : Colors.green,
  //                           fontWeight: AppFontWeights.extraBold,
  //                           letterSpacing: 0.5,
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 16),
  //               Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.4)),
  //               const SizedBox(height: 16),
  //
  //               // 🔹 Additional Financial Info dynamically from PriceManager
  //               ...priceManager.priceSummary.entries
  //                   .where((e) => e.value != null)
  //                   .map(
  //                     (e) => Padding(
  //                       padding: const EdgeInsets.only(bottom: 10),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Icon(
  //                                 _getFinancialIcon(e.key),
  //                                 size: 20,
  //                                 color: ColorRes.primary,
  //                               ),
  //                               const SizedBox(width: 10),
  //                               Text(
  //                                 e.key,
  //                                 style: TextStyle(
  //                                   fontSize: AppFontSizes.small,
  //                                   color: ColorRes.leadGreyColor[700],
  //                                   fontWeight: AppFontWeights.semiBold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Flexible(
  //                             child: Text(
  //                               e.value!,
  //                               style: TextStyle(
  //                                 fontSize:
  //                                     isCompact
  //                                         ? AppFontSizes.medium
  //                                         : AppFontSizes.large,
  //                                 fontWeight: AppFontWeights.semiBold,
  //                                 color: ColorRes.primary,
  //                               ),
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //
  //               const SizedBox(height: 10),
  //               Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.3)),
  //               const SizedBox(height: 10),
  //
  //               // 🔹 Total Price
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'Total Value',
  //                     style: TextStyle(
  //                       fontSize: AppFontSizes.medium,
  //                       fontWeight: AppFontWeights.bold,
  //                       color: ColorRes.leadGreyColor[800],
  //                     ),
  //                   ),
  //                   Text(
  //                     priceManager.totalPriceDisplay,
  //                     style: TextStyle(
  //                       fontSize: isCompact ? AppFontSizes.large : 22,
  //                       fontWeight: AppFontWeights.extraBold,
  //                       color: ColorRes.success.shade700,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               // 🔹 Negotiation + Offer Handling (Reactive)
  //               Obx(() {
  //                 final hasOffer = controller.submittedOfferAmount.value != 0.0;
  //
  //                 return Column(
  //                   children: [
  //                     if (hasOffer) ...[
  //                       const SizedBox(height: 16),
  //                       _buildOfferCard(isCompact),
  //                     ],
  //
  //                     if (financialInfo.negotiable) ...[
  //                       const SizedBox(height: 16),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: ElevatedButton.icon(
  //                           onPressed:
  //                               !hasOffer
  //                                   ? () => _handleNegotiation(context)
  //                                   : null,
  //                           icon: Icon(
  //                             !hasOffer
  //                                 ? Icons.chat_bubble_outline
  //                                 : Icons.check_circle_outline,
  //                             size: 18,
  //                           ),
  //                           label: Text(
  //                             !hasOffer
  //                                 ? 'Start Negotiation'
  //                                 : 'Offer Submitted',
  //                             style: TextStyle(
  //                               fontSize: AppFontSizes.medium,
  //                               fontWeight: FontWeight.bold,
  //                               letterSpacing: 0.5,
  //                             ),
  //                           ),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 !hasOffer
  //                                     ? ColorRes.success.shade600
  //                                     : ColorRes.leadGreyColor.shade400,
  //                             foregroundColor: ColorRes.white,
  //                             padding: const EdgeInsets.symmetric(vertical: 14),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             elevation: 0,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ],
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFinancialSection(BuildContext context, bool isCompact) {
    final financialInfo = _resolvedFinancialInfo;
    if (financialInfo == null) return const SizedBox.shrink();

    print("financial Informtion : ${financialInfo.toJson()}");

    final priceManager = PropertyPriceManager(
      listingType: propertyType,
      financialInfo: financialInfo,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Financial Information',
            Icons.currency_rupee_outlined,
            isCompact,
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
                // 🔹 PROPERTY PRICE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertyType.toLowerCase() == "rent"
                                ? 'Monthly Rent'
                                : 'Property Price',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.leadGreyColor[700],
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            priceManager.displayPrice,
                            style: TextStyle(
                              fontSize: isCompact ? AppFontSizes.large : 32,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.success.shade800,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Negotiable Chip
                    if (financialInfo.negotiable == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: (widget.isFromLead
                                  ? _getStatusColor(widget.lead!.status!)
                                  : Colors.green)
                              .withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (widget.isFromLead
                                    ? _getStatusColor(widget.lead!.status!)
                                    : Colors.green)
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Negotiable',
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color:
                                widget.isFromLead
                                    ? _getStatusColor(widget.lead!.status!)
                                    : Colors.green,
                            fontWeight: AppFontWeights.extraBold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.4)),
                const SizedBox(height: 16),

                // 🔹 Additional Financial Info dynamically from PriceManager
                ...priceManager.priceSummary.entries.map((e) {
                  final value = e.value?.trim();
                  // Skip empty or placeholder values
                  if (value == null ||
                      value.isEmpty ||
                      value.toLowerCase().contains('not available') ||
                      value == '₹0' ||
                      value == '₹0.0') {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getFinancialIcon(e.key),
                              size: 20,
                              color: ColorRes.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              e.key,
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: ColorRes.leadGreyColor[700],
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize:
                                  isCompact
                                      ? AppFontSizes.medium
                                      : AppFontSizes.large,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 10),
                Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.3)),
                const SizedBox(height: 10),

                // 🔹 Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Value',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.bold,
                        color: ColorRes.leadGreyColor[800],
                      ),
                    ),
                    Text(
                      priceManager.totalPriceDisplay,
                      style: TextStyle(
                        fontSize: isCompact ? AppFontSizes.large : 22,
                        fontWeight: AppFontWeights.extraBold,
                        color: ColorRes.success.shade700,
                      ),
                    ),
                  ],
                ),

                // 🔹 Negotiation + Offer Handling (Reactive)
                // Obx(() {
                //   final hasOffer = controller.submittedOfferAmount.value != 0.0;
                //
                //   return Column(
                //     children: [
                //       if (hasOffer) ...[
                //         const SizedBox(height: 16),
                //         _buildOfferCard(isCompact),
                //       ],
                //
                //       if (financialInfo.negotiable == true) ...[
                //         const SizedBox(height: 16),
                //         SizedBox(
                //           width: double.infinity,
                //           child: ElevatedButton.icon(
                //             onPressed:
                //                 !hasOffer
                //                     ? () => _handleNegotiation(context)
                //                     : null,
                //             icon: Icon(
                //               !hasOffer
                //                   ? Icons.chat_bubble_outline
                //                   : Icons.check_circle_outline,
                //               size: 18,
                //             ),
                //             label: Text(
                //               !hasOffer
                //                   ? 'Start Negotiation'
                //                   : 'Offer Submitted',
                //               style: TextStyle(
                //                 fontSize: AppFontSizes.medium,
                //                 fontWeight: FontWeight.bold,
                //                 letterSpacing: 0.5,
                //               ),
                //             ),
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor:
                //                   !hasOffer
                //                       ? ColorRes.success.shade600
                //                       : ColorRes.leadGreyColor.shade400,
                //               foregroundColor: ColorRes.white,
                //               padding: const EdgeInsets.symmetric(vertical: 14),
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //               elevation: 0,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ],
                //   );
                // }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(bool isCompact) {
    final offerAmount = controller.submittedOfferAmount.value;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        color: ColorRes.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorRes.orangeColor.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.handshake_rounded,
                      size: 20,
                      color: ColorRes.orangeColor.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Negotiable Price',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.leadGreyColor[800],
                    ),
                  ),
                ],
              ),
              Text(
                Formatter.formatPrice(offerAmount),
                style: TextStyle(
                  fontSize:
                      isCompact ? AppFontSizes.medium : AppFontSizes.large,
                  fontWeight: AppFontWeights.extraBold,
                  color: ColorRes.orangeColor.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorRes.orangeColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorRes.orangeColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pending_outlined,
                  size: 14,
                  color: ColorRes.orangeColor.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  'Pending Review',
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    color: ColorRes.orangeColor.shade700,
                    fontWeight: AppFontWeights.semiBold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimelineSection(BuildContext context, bool isCompact) {
    if (!widget.isFromLead) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Lead Timeline', Icons.timeline_outlined, true),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: ColorRes.leadGreyColor.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorRes.leadGreyColor.shade300,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                buildTimelineItem(
                  'Lead Created',
                  _formatDateTime(widget.lead!.createdAt!),
                  Icons.add_circle_outline,
                  ColorRes.blueColor,
                  true,
                  false,
                ),
                if (widget.lead!.lastContactedAt != null)
                  buildTimelineItem(
                    'Last Contacted',
                    _formatDateTime(
                      DateTime.tryParse(widget.lead!.lastContactedAt!) ??
                          DateTime.now(),
                    ),
                    Icons.phone_outlined,
                    ColorRes.orangeColor,
                    false,
                    false,
                  ),
                buildTimelineItem(
                  'Current Status',
                  _getStatusText(widget.lead!.status!),
                  Icons.flag_outlined,
                  _getStatusColor(widget.lead!.status!),
                  false,
                  true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isFirst,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2.5),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withOpacity(0.6), color.withOpacity(0.4)],
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: ColorRes.leadGreyColor[500],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.leadGreyColor[600],
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNegotiation(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorRes.transparentColor,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        final priceManager = PropertyPriceManager(
          listingType: listingType,
          financialInfo: _resolvedFinancialInfo,
        );
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorRes.green.shade50,
                                  ColorRes.green.shade100.withOpacity(0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: ColorRes.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ColorRes.green,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.handshake_rounded,
                                    color: ColorRes.green.shade700,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Negotiate Price',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.large,
                                          fontWeight: AppFontWeights.extraBold,
                                          color: ColorRes.leadGreyColor[900],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Make your best offer',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          color: ColorRes.leadGreyColor[600],
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // Current Price Info
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Asking Price',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.extraSmall,
                                          color: ColorRes.blueColor.shade700,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        priceManager.displayPrice,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.medium,
                                          color: ColorRes.blueColor.shade900,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Offer Amount *',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.leadGreyColor[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: controller.offerController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your offer amount';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid amount';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter amount',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Icon(
                                    Icons.currency_rupee,
                                    color: Colors.green.shade700,
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: ColorRes.primary,
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.red.shade300,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ColorRes.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Message Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Message (Optional)',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.leadGreyColor[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: controller.messageController,
                                minLines: 1,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Add a message...',
                                  hintStyle: TextStyle(
                                    fontSize: AppFontSizes.medium,
                                    color: ColorRes.leadGreyColor[400],
                                  ),
                                  prefixIcon: Icon(
                                    Icons.message_outlined,
                                    color: ColorRes.orangeColor.shade700,
                                    size: 22,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: ColorRes.leadGreyColor.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: ColorRes.leadGreyColor.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: ColorRes.primary,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ColorRes.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 28),

                          // Action Buttons
                          SafeArea(
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      controller.offerController.clear();
                                      controller.messageController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.extraBold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          ColorRes.leadGreyColor[700],
                                      side: BorderSide(
                                        color: ColorRes.leadGreyColor.shade400,
                                        width: 1.5,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        // Store the offer amount
                                        final offerAmount = double.parse(
                                          controller.offerController.text,
                                        );
                                        final message =
                                            controller.messageController.text;

                                        // Update the state to display the offer

                                        controller.submittedOfferAmount.value =
                                            offerAmount;

                                        controller.offerController.clear();
                                        controller.messageController.clear();
                                        Navigator.pop(context);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: ColorRes.white,
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    'Offer submitted successfully!',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          AppFontWeights
                                                              .semiBold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: ColorRes.primary,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                    label: Text(
                                      'Submit Offer',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorRes.primary,
                                      foregroundColor: ColorRes.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      shadowColor: ColorRes.green.withOpacity(
                                        0.3,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Notes', Icons.note_outlined, true),
          SizedBox(height: 16),
          Text(
            widget.lead!.notes!,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isCompact) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    () => ContactHelper.openDialer(
                      widget.lead?.phone ?? widget.property?.ownerPhone ?? '',
                    ),
                icon: Icon(Icons.phone),
                label: Text(
                  'Call',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.success,
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
              child: ElevatedButton.icon(
                onPressed:
                    () => ContactHelper.sendEmail(
                      widget.lead?.email ?? widget.property?.ownerEmail ?? '',
                    ),
                icon: Icon(Icons.email),
                label: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
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
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: ColorRes.leadGreyColor[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.share, color: ColorRes.blueColor),
                title: Text('Share Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.flag, color: ColorRes.orangeColor),
                title: Text('Mark as Fake'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement mark as fake
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: ColorRes.error),
                title: Text('Delete Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement delete functionality
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return ColorRes.blueColor;
      case 'contacted':
        return ColorRes.orangeColor;
      case 'qualified':
        return ColorRes.purpleColor;
      case 'negotiating':
        return ColorRes.leadIndigoColor;
      case 'sold':
        return ColorRes.success;
      case 'lost':
        return ColorRes.error;
      default:
        return ColorRes.leadGreyColor;
    }
  }

  String _getStatusText(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
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
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _launchPhone(String phone) {
    // Implement phone call functionality
    // url_launcher package: launch('tel:$phone');
  }

  void _launchEmail(String email) {
    // Implement email functionality
    // url_launcher package: launch('mailto:$email');
  }

  FinancialInfo? get _resolvedFinancialInfo {
    final Items? property = widget.propertyController?.items
        .cast<Items?>()
        .firstWhere(
          (e) => e?.propertyId == widget.lead?.propertyId,
          orElse: () => null,
        );
    if (widget.property?.propertyDetails?.financialInfo != null)
      return widget.property!.propertyDetails!.financialInfo;
    if (property?.propertyDetails?.financialInfo != null)
      return property?.propertyDetails!.financialInfo;
    return null;
  }

  IconData _getFinancialIcon(String key) {
    switch (key) {
      case "Price per Sqft":
        return Icons.square_foot_outlined;
      case "Maintenance":
        return Icons.build_outlined;
      case "Deposit":
        return Icons.lock_outline;
      case "Broker Commission":
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.currency_rupee_outlined;
    }
  }
}
