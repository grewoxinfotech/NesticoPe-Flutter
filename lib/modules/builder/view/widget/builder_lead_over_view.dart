import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart' hide capitalizeEachWord;
import 'package:housing_flutter_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/svg_res.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../../../app/widgets/media/media_preview.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../../common/lead_components/lead_helpers.dart';
import '../../../reseller/view/lead_overview/widget/lead_negotiable_price_screen.dart';
import '../../../reseller/view/lead_overview/widget/lead_visit.dart';
import '../../../seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
import '../../../seller/module/lead_screen/controllers/lead_property_negotiable_price_controller.dart';
import '../../../seller/module/lead_screen/controllers/lead_visit_controller.dart';
import '../../../seller/module/lead_screen/model/lead_model.dart';
import '../../controller/builder_lead_over_view_controller.dart';
import '../../controller/project_controller.dart';
import '../project_detail/project_detail.dart';

class BuilderLeadOverView extends StatelessWidget {
  final LeadItem lead;
  final ProjectItem project;
  final bool isFromResellerProject;

  BuilderLeadOverView({super.key, required this.lead, required this.project, this.isFromResellerProject=false});

  final BuilderLeadOverviewController controller = Get.put(
    BuilderLeadOverviewController(),
  );
  final LeadPropertyInquiryController leadPropertyInquiryController=Get.find<LeadPropertyInquiryController>();
  final LeadVisitController leadVisitController=Get.find<LeadVisitController>();
  final LeadPropertyNegotiablePriceController leadPropertyNegotiablePriceController=Get.find<LeadPropertyNegotiablePriceController>();

  @override
  Widget build(BuildContext context) {
    controller.initConfigs(project.configuration.length);

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        title: Text(
          "Lead Overview",
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),

        elevation: 0,
        iconTheme: const IconThemeData(color: ColorRes.textPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= Lead Header =================
            _buildLeadHeader(),
            SizedBox(height: 10),
            _buildLeadDetailsCard(),
            SizedBox(height: 16),

            _buildSectionTitle("Project Details"),
            SizedBox(height: 10),
            _buildProjectDetailsCard(),

            /// ================= Media Gallery =================
            if (project.mediaGallery != null &&
                project.mediaGallery!.images.isNotEmpty)
              SizedBox(height: 15),
              _buildMediaGallery(

                project
              ),

            /// ================= Configurations =================
              SizedBox(height: 15),
            _buildSectionTitle("Configurations"),
            SizedBox(height: 10),
            _buildConfigurations(),

            /// ================= Amenities =================
            if (project.amenities.isNotEmpty)

              _buildAmenities(),

            if (project?.brochures.isNotEmpty ?? false) ...[
              _buildDocuments(controller, project!),
            ],
            /// ================= Project Highlights =================
            if (project.projectHighlights.isNotEmpty)
              const SizedBox(height: 15),
              _buildProjectHighlights(),

            /// ================= Interest & Documents =================
            _buildInterestSection(),
            const SizedBox(height: 8),
           if(!isFromResellerProject)...[
             ListTile(
               tileColor: ColorRes.white,
               title: Text(
                 'Visit',
                 style: TextStyle(
                   fontSize: AppFontSizes.medium,
                   fontWeight: AppFontWeights.semiBold,
                 ),
               ),
               leading: Icon(Icons.history, color: ColorRes.primary),
               trailing: Icon(Icons.arrow_forward_ios_rounded),
               onTap: () {
                 debugPrint('Fetching lead details for ${lead.id}');
                 leadVisitController.getLeadId(lead.id);


                 // final buyerId=propertyInquiryController?.selectedInquiry.value?.userId;
                 // final propertyId=propertyInquiryController?.selectedInquiry.value?.propertyId;

                 print(
                   "Buyer Data ${leadPropertyInquiryController?.selectedInquiry.value?.userId}============== ${leadPropertyInquiryController?.selectedInquiry.value?.propertyId}",
                 );

                 Get.to(
                       () => LeadVisit(
                     leadVisitController: leadVisitController,
                     propertyInquiryController:

                     leadPropertyInquiryController,
                     buyerID: leadPropertyInquiryController?.selectedInquiry.value?.userId,
                     propertyId:
                     project.id,
                   ),
                 );
               },
             ),
             const SizedBox(height: 8),
             ListTile(
               tileColor: ColorRes.white,
               title: Text(
                 'Negotiable',
                 style: TextStyle(
                   fontSize: AppFontSizes.medium,
                   fontWeight: AppFontWeights.semiBold,
                 ),
               ),
               leading: Icon(Icons.currency_rupee_outlined, color: ColorRes.primary),
               trailing: Icon(Icons.arrow_forward_ios_rounded),
               onTap: () {
                 final selectedInquiry =
                     leadPropertyInquiryController?.selectedInquiry.value;

                 if (selectedInquiry != null) {
                   // Set visit id
                   print(
                     'Setting visit ID for user ${selectedInquiry.userId} and property ${selectedInquiry.propertyId}',
                   );
                   leadPropertyNegotiablePriceController.setLeadNegotiablePriceId(
                     selectedInquiry.propertyId ?? '',
                     buyerID:  selectedInquiry.userId ?? '',
                   );
                   print(
                     'Negotiable Price ID set: ${leadPropertyNegotiablePriceController.items.map((e) => e.toMap())}',
                   );
                 }
                 Get.to(
                       () => LeadNegotiablePriceScreen(
                     controller: leadPropertyNegotiablePriceController,
                   ),
                 );
               },
             ),
             const SizedBox(height: 8),
           ],

            SafeArea(

              child: ListTile(
                tileColor: ColorRes.white,
                title: Text(
                  'Follow Ups',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
                leading: Icon(Icons.follow_the_signs, color: ColorRes.primary),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  final selectedInquiry =
                      leadPropertyInquiryController?.selectedInquiry.value;
                  if (selectedInquiry != null) {
                    // Set visit id
                    print(
                      'Setting visit ID for user ${selectedInquiry.userId} and property ${selectedInquiry.propertyId}',
                    );
                    leadPropertyNegotiablePriceController.setLeadNegotiablePriceId(
                      selectedInquiry.propertyId ?? '',
                      buyerID:   selectedInquiry.userId??'',
                    );
                    print(
                      'Negotiable Price ID set: ${leadPropertyNegotiablePriceController.items.map((e) => e.toMap())}',
                    );
                  }
                  Get.to(() => LeadFollowUpScreen(controller: leadVisitController));
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  Widget _buildDocuments(BuilderLeadOverviewController controller, ProjectItem project) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: ColorRes.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Brochures',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (project.brochures.isNotEmpty)
            ...project.brochures.map((brochure) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDocumentItem(
                  icon: Icons.description,
                  title: brochure.name ?? '-',
                  onTap: () => controller.downloadDocument(brochure.url),
                ),
              );
            }).toList(),
          if (project.mediaGallery?.documents != null &&
              project.mediaGallery!.documents.isNotEmpty) ...[
            SizedBox(height: 12),
            const Text(
              'Documents',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            ...project.mediaGallery!.documents.map((document) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDocumentItem(
                  icon: Icons.description,
                  title: "Document" ?? '-',
                  onTap: () => controller.downloadDocument(document),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );

  }
  Widget _buildDocumentItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: ColorRes.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textPrimary,
                ),
              ),
            ),
            const Text(
              'View',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.primary,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLeadHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name ?? "No Name",
                      style: const TextStyle(
                        fontSize: AppFontSizes.large,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Lead ID: #${lead.id?.substring(0, 8) ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(
                    getLeadStatusFromString(lead.status!),
                  ).withOpacity(0.1),
                  border: Border.all(
                    color: getStatusColor(
                      getLeadStatusFromString(lead.status!),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${capitalizeEachWord(lead.status)}",
                  style: TextStyle(
                    color: getStatusColor(
                      getLeadStatusFromString(lead.status!),
                    ),
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadge(
                Icons.verified_user,
                "${lead.source}",
                ColorRes.success,
              ),
              const SizedBox(width: 8),
              _buildBadge(
                Icons.check_circle,
                "${lead.stage}",
                getStageColor(getLeadStageFromString(lead.stage)),
              ),
              const SizedBox(width: 8),
              _buildBadge(
                Icons.warning,
                (lead?.isFake ?? false) ? "Fake" : "Real",
                ColorRes.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            capitalizeEachWord(label),
            style: TextStyle(
              color: color,
              fontSize: AppFontSizes.extraSmall,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppFontSizes.body,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLeadDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead Details',
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          SizedBox(height: 8),

          _buildDivider(),

          SizedBox(height: 8),
          _buildDetailRow(Icons.email, "EMAIL", lead.email ?? "-"),
          SizedBox(height: 4),
          _buildDivider(),
          SizedBox(height: 4),
          _buildDetailRow(Icons.phone, "PHONE", lead.phone ?? "-"),
          SizedBox(height: 4),
          _buildDivider(),
          SizedBox(height: 4),
          _buildDetailRow(
            Icons.source,
            "SOURCE",
            capitalizeEachWord(lead.source) ?? "-",
          ),
          SizedBox(height: 4),
          _buildDivider(),
          SizedBox(height: 4),
          _buildDetailRow(
            Icons.trending_up,
            "STAGE",
            capitalizeEachWord(lead.stage) ?? "-",
          ),
          SizedBox(height: 4),
          _buildDivider(),
          SizedBox(height: 4),
          _buildDetailRow(Icons.notes, "NOTES", lead.notes ?? "-"),
          SizedBox(height: 4),
          _buildDivider(),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildDetailRow(
                  Icons.calendar_today,
                  "CREATED",
                  formatDateForGlobal(lead.createdAt.toString()),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 60,
                width: 1,
                color: ColorRes.leadGreyColor.shade300,
              ),
              Expanded(
                child: _buildDetailRow(
                  Icons.update,
                  "UPDATED",
                  formatTime(lead.updatedAt!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        children: [
          // Project Image Header
          if (project.mediaGallery?.images.isNotEmpty ?? false)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    project.mediaGallery!.images.first,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // 🔴 Top-right Project ID Tag
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "ID: PRJ-${project.projectId.substring(0, 4)}",
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),

          // Project Info
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [

                    Expanded(
                      child: Text(
                        "${project.city}, ${project.state}",
                        style:  TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        "Property Type",
                        project.propertyTypes,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInfoChip("Status", project.status)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        "Area Range",
                        "${Formatter.formatNumber(num.tryParse(project.projectArea) ?? 0)} sqft",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInfoChip("RERA ID", project.reraId)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDivider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // const Icon(
                    //   Icons.location_on,
                    //   size: 16,
                    //   color: ColorRes.primary,
                    // ),
                    // const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Full Address",
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${project.address}, ${project.city}, ${project.state} ${project.zipCode}",
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGallery(ProjectItem projectItem) {
    if (projectItem.mediaGallery == null) {
      return const SizedBox.shrink();
    }

    final gallery = projectItem.mediaGallery!;
    final allMedia = [
      ...gallery.images.map((e) => {'type': 'image', 'url': e}),
      ...gallery.videos.map((e) => {'type': 'video', 'url': e}),
    ];

    if (allMedia.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,),


      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gallery',
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          /// ✅ Single Horizontal List for both Images & Videos
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allMedia.length,
              itemBuilder: (context, index) {
                final media = allMedia[index];
                final isVideo = media['type'] == 'video';
                final url = media['url'] ?? '';

                return GestureDetector(
                  onTap: () {
                    // Navigate to preview screen (image or video)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MediaPreviewScreen(url: url),
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),

                          border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1)

                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          isVideo
                              ? buildVideoThumbnail(
                            url,
                            height: 120,
                            width: 160,
                          )
                              : Image.network(
                            url,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 160,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),

                          /// ✅ Play icon overlay for videos
                          if (isVideo)
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildConfigurations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
            () => Column(
          children: List.generate(project.configuration.length, (index) {
            final config = project.configuration[index];
            final expanded = controller.isConfigExpanded[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Configuration Header
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: ColorRes.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "${config.bhk} BHK",
                      style: TextStyle(
                        color: ColorRes.textPrimary,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    subtitle: Text(
                      "${config.variants.length} variant${config.variants.length != 1 ? 's' : ''}",
                      style: const TextStyle(
                        color: ColorRes.textSecondary,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                    trailing: Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: ColorRes.textSecondary,
                    ),
                    onTap: () => controller.toggleConfig(index),
                  ),

                  // Expanded Variants List
                  if (expanded && config.variants.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: List.generate(
                          config.variants.length,
                              (variantIndex) {
                            final variant = config.variants[variantIndex];
                            final isLastVariant = variantIndex == config.variants.length - 1;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Divider before each variant
                                _buildDivider(),
                                const SizedBox(height: 12),

                                // Variant Name and Details
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        variant.name,
                                        style: const TextStyle(
                                          fontWeight: AppFontWeights.semiBold,
                                          color: ColorRes.textPrimary,
                                          fontSize: AppFontSizes.medium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Area Information
                                Text(
                                  "${Formatter.formatNumber(variant.builtUpArea)} sqft Built-up  -  ${Formatter.formatNumber(variant.carpetArea.toInt())} sqft Carpet",
                                  style: const TextStyle(
                                    color: ColorRes.textSecondary,
                                    fontSize: AppFontSizes.small,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Price Information
                                Text(
                                  "${Formatter.formatPrice(variant.price)}",
                                  style: const TextStyle(
                                    color: ColorRes.primary,
                                    fontSize: AppFontSizes.body,
                                    fontWeight: AppFontWeights.semiBold,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Units Information
                                Text(
                                  "${variant.availableUnits} available of ${variant.totalUnits} units",
                                  style: const TextStyle(
                                    color: ColorRes.textSecondary,
                                    fontSize: AppFontSizes.caption,
                                  ),
                                ),

                                // Specifications
                                if (variant.specifications.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Text(
                                    "SPECIFICATIONS",
                                    style: TextStyle(
                                      color: ColorRes.textSecondary,
                                      fontSize: AppFontSizes.caption,
                                      fontWeight: AppFontWeights.semiBold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: variant.specifications.map((spec) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorRes.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          spec,
                                          style: const TextStyle(
                                            color: ColorRes.textPrimary,
                                            fontSize: AppFontSizes.caption,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],

                                // Gallery Images
                                if (variant.images.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Text(
                                    "GALLERY",
                                    style: TextStyle(
                                      color: ColorRes.textSecondary,
                                      fontSize: AppFontSizes.caption,
                                      fontWeight: AppFontWeights.semiBold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: variant.images.length > 3
                                          ? 3
                                          : variant.images.length,
                                      itemBuilder: (context, imgIndex) {
                                        final img = variant.images[imgIndex];
                                        final remainingCount = variant.images.length - 3;

                                        return Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: ColorRes.border,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  img,
                                                  width: 100,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      width: 100,
                                                      height: 80,
                                                      color: ColorRes.leadGreyColor.shade200,
                                                      child: const Icon(
                                                        Icons.image_not_supported,
                                                        color: ColorRes.textSecondary,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            // Show "+X" overlay on last image if more images exist
                                            if (imgIndex == 2 && remainingCount > 0)
                                              Positioned.fill(
                                                child: Container(
                                                  margin: const EdgeInsets.only(right: 8),
                                                  decoration: BoxDecoration(
                                                    color: ColorRes.overlay,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "+$remainingCount",
                                                      style: const TextStyle(
                                                        color: ColorRes.white,
                                                        fontSize: AppFontSizes.body,
                                                        fontWeight: AppFontWeights.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],

                                // Bottom spacing (only if not last variant)
                                if (!isLastVariant) const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

// Helper method for divider


  // Widget _buildConfigurations() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Obx(
  //       () => Column(
  //         children: List.generate(project.configuration.length, (index) {
  //           final config = project.configuration[index];
  //           final expanded = controller.isConfigExpanded[index];
  //           return Container(
  //             margin: const EdgeInsets.only(bottom: 12),
  //             decoration: BoxDecoration(
  //               color: ColorRes.white,
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1),
  //             ),
  //             child: Column(
  //               children: [
  //                 ListTile(
  //                   leading: Container(
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: ColorRes.primary.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: const Icon(
  //                       Icons.home,
  //                       color: ColorRes.primary,
  //                       size: 20,
  //                     ),
  //                   ),
  //                   title: Text(
  //                     "${config.bhk} BHK",
  //                     style:  TextStyle(
  //                       color: ColorRes.textPrimary,
  //                       fontSize: AppFontSizes.bodySmall,
  //                       fontWeight: AppFontWeights.semiBold,
  //                     ),
  //                   ),
  //                   subtitle: Text(
  //                     "${config.variants.length} variants",
  //                     style: const TextStyle(
  //                       color: ColorRes.textSecondary,
  //                       fontSize: AppFontSizes.caption,
  //                     ),
  //                   ),
  //                   trailing: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(
  //                         "${config.variants}",
  //                         style: const TextStyle(
  //                           color: ColorRes.error,
  //                           fontWeight: AppFontWeights.bold,
  //                           fontSize: AppFontSizes.body,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 8),
  //                       Icon(
  //                         expanded
  //                             ? Icons.keyboard_arrow_up
  //                             : Icons.keyboard_arrow_down,
  //                         color: ColorRes.textSecondary,
  //                       ),
  //                     ],
  //                   ),
  //                   onTap: () => controller.toggleConfig(index),
  //                 ),
  //                 if (expanded)
  //                   Padding(
  //                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children:
  //                           config.variants.map((variant) {
  //                             return Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 _buildDivider(),
  //                                 const SizedBox(height: 12),
  //                                 Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: Text(
  //                                         variant.name,
  //                                         style: const TextStyle(
  //                                           fontWeight: AppFontWeights.bold,
  //                                           color: ColorRes.textPrimary,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(height: 8),
  //                                 Text(
  //                                   "${variant.builtUpArea.toInt()} sqft • Extra Parking",
  //                                   style: const TextStyle(
  //                                     color: ColorRes.textSecondary,
  //                                     fontSize: AppFontSizes.bodySmall,
  //                                   ),
  //                                 ),
  //                                 const SizedBox(height: 12),
  //                                 if (variant.images.isNotEmpty)
  //                                   Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       const Text(
  //                                         "GALLERY",
  //                                         style: TextStyle(
  //                                           color: ColorRes.textSecondary,
  //                                           fontSize: AppFontSizes.caption,
  //                                           fontWeight: AppFontWeights.semiBold,
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 8),
  //                                       SizedBox(
  //                                         height: 80,
  //                                         child: ListView.builder(
  //                                           scrollDirection: Axis.horizontal,
  //                                           itemCount:
  //                                               variant.images.length > 2
  //                                                   ? 2
  //                                                   : variant.images.length,
  //                                           itemBuilder: (context, imgIndex) {
  //                                             final img =
  //                                                 variant.images[imgIndex];
  //                                             return Stack(
  //                                               children: [
  //                                                 Container(
  //                                                   margin:
  //                                                       const EdgeInsets.only(
  //                                                         right: 8,
  //                                                       ),
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius:
  //                                                         BorderRadius.circular(
  //                                                           8,
  //                                                         ),
  //                                                     border: Border.all(
  //                                                       color: ColorRes.border,
  //                                                     ),
  //                                                   ),
  //                                                   child: ClipRRect(
  //                                                     borderRadius:
  //                                                         BorderRadius.circular(
  //                                                           8,
  //                                                         ),
  //                                                     child: Image.network(
  //                                                       img,
  //                                                       width: 100,
  //                                                       height: 80,
  //                                                       fit: BoxFit.cover,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 if (imgIndex == 1 &&
  //                                                     variant.images.length > 2)
  //                                                   Positioned.fill(
  //                                                     child: Container(
  //                                                       margin:
  //                                                           const EdgeInsets.only(
  //                                                             right: 8,
  //                                                           ),
  //                                                       decoration: BoxDecoration(
  //                                                         color:
  //                                                             ColorRes.overlay,
  //                                                         borderRadius:
  //                                                             BorderRadius.circular(
  //                                                               8,
  //                                                             ),
  //                                                       ),
  //                                                       child: Center(
  //                                                         child: Text(
  //                                                           "+${variant.images.length - 2}",
  //                                                           style: const TextStyle(
  //                                                             color:
  //                                                                 ColorRes
  //                                                                     .white,
  //                                                             fontSize:
  //                                                                 AppFontSizes
  //                                                                     .body,
  //                                                             fontWeight:
  //                                                                 AppFontWeights
  //                                                                     .bold,
  //                                                           ),
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                               ],
  //                                             );
  //                                           },
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 const SizedBox(height: 12),
  //                               ],
  //                             );
  //                           }).toList(),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAmenities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Amenities",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.99,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: project.amenities.length,
            itemBuilder: (context, index) {
              final amenity = project.amenities[index].toLowerCase().replaceAll(" ", "_");
              print("Project deatils ${project.amenities.map((e) => e)}");
              /*final Map<String, String> amenityIcons = {
                'Swimming Pool': AppSvgRes.swimming,
                "Fire Safety": AppSvgRes.fire_extinguisher,
                "CCTV": AppSvgRes.cctv,
                "Club House": AppSvgRes.club,
                "Gymnasium": AppSvgRes.gym,
                "Children Play Area": AppSvgRes.playground,
                "Power Backup": AppSvgRes.battery,
                "Lift": AppSvgRes.elevator,
                "Service Lift": AppSvgRes.elevator,
                "Garden": AppSvgRes.garden,
                "Ev Charging": AppSvgRes.dg,
                "Wifi Connectivity": AppSvgRes.internet_connectivity,
                "Covered Parking": AppSvgRes.covered_parking,
                "Visitor Parking": AppSvgRes.visitor_parking,
                "Maintenance Staff": AppSvgRes.maintenanace_staff,
                "Meditation Area": AppSvgRes.meditation_area,
                "MultiPurpose Hall": AppSvgRes.multi_purpose_hall,
                "Solar Panel": AppSvgRes.solar_panel,
                "Waste Disposal": AppSvgRes.waste_disposal,
                "24x7 Security": AppSvgRes.security,
                "Laundry Service": AppSvgRes.washing,
                "Temple": AppSvgRes.hall,
                "Jogging Track": AppSvgRes.sports,
                "Amphitheatre Theater": AppSvgRes.home_theater,
              };*/
              final Map<String, String> amenityIcons = {
                // 🏊 Lifestyle
                'swimming_pool': AppSvgRes.swimming,
                'gym': AppSvgRes.gym,
                'gymnasium': AppSvgRes.gym,
                'club_house': AppSvgRes.club,
                'community_hall': AppSvgRes.hall,
                'multipurpose_hall': AppSvgRes.multi_purpose_hall,
                'children_play_area': AppSvgRes.playground,
                'meditation_area': AppSvgRes.meditation_area,
                'garden': AppSvgRes.garden,
                'gardens': AppSvgRes.garden,
                'gated_community': AppSvgRes.security,
                'jogging_track': AppSvgRes.jogging,
                'amphitheatre': AppSvgRes.home_theater,
                'temple': AppSvgRes.temple ?? AppSvgRes.hall,

                // 🔐 Safety & Security
                '24x7_security': AppSvgRes.security,
                'cctv': AppSvgRes.cctv,
                'cctv_surveillance': AppSvgRes.cctv,
                'intercom': AppSvgRes.intercom ?? AppSvgRes.security,
                'fire_safety': AppSvgRes.fire_extinguisher,

                // ⚡ Utilities
                'power_backup': AppSvgRes.battery,
                'lift': AppSvgRes.elevator,
                'service_lift': AppSvgRes.elevator,
                'solar_panels': AppSvgRes.solar_panel,
                'ev_charging': AppSvgRes.dg,
                'wi-fi_connectivity': AppSvgRes.internet_connectivity,

                // 🚗 Parking
                'covered_parking': AppSvgRes.covered_parking,
                'visitor_parking': AppSvgRes.visitor_parking,

                // 🧹 Services
                'maintenance_staff': AppSvgRes.maintenanace_staff,
                'waste_disposal': AppSvgRes.waste_disposal,
                'laundry_service': AppSvgRes.washing,
              };

              final List<Color> amenityColors = [
                ColorRes.blueColor,
                ColorRes.error,
                ColorRes.leadIndigoColor,
                ColorRes.orangeColor,
                ColorRes.leadTealColor,
                ColorRes.lightpurple,
                ColorRes.purpleColor,
                ColorRes.green,
              ];

              // Use a color in sequence or wrap around using modulo
              final color = amenityColors[index % amenityColors.length];
              final icon = amenityIcons[amenity] ?? AppSvgRes.sports;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppSvgIcon(assetName: icon, color: color, folder: 'amenities'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    capitalizeEachWord(amenity),
                    style: const TextStyle(
                      fontSize: AppFontSizes.mini,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );

            },
          ),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children: List.generate(
          //     project.amenities.take(6).length,
          //         (index) {
          //       final amenity = project.amenities[index];
          //
          //
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildProjectHighlights() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1),
          borderRadius: BorderRadius.circular(12),
          color: ColorRes.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Project Highlights",
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children:
                  project.projectHighlights.take(3).map((highlight) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: ColorRes.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              highlight,
                              style:  TextStyle(
                                fontSize: AppFontSizes.small,
                                color: ColorRes.textColor,
                                fontWeight:AppFontWeights.regular ,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1),

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorRes.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: ColorRes.success,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Launch",
                          style: TextStyle(
                            color: ColorRes.textPrimary,
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatDateForGlobal(project.launchDate.toString()) ?? "Jan 10, 2024",
                    style: const TextStyle(
                      color: ColorRes.textSecondary,
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorRes.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.verified_outlined,
                          color: ColorRes.success,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Status",
                          style: TextStyle(
                            color: ColorRes.textPrimary,
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                   Text(
                    "${project.isActive?"Active":"Inactive"}",
                    style: TextStyle(
                      color: ColorRes.textSecondary,
                      fontWeight: AppFontWeights.medium,
                      fontSize: AppFontSizes.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(icon, size: 16, color: ColorRes.textSecondary),
          // const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: AppFontWeights.medium,
                fontSize: AppFontSizes.caption,
                color: ColorRes.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return  Divider(color:  ColorRes.leadGreyColor.shade200, height: 1);
  }
}
