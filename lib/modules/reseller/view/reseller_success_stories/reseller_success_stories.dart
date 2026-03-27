import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:nesticope_app/modules/reseller/view/reseller_success_stories/add_reseller_success_stories_screen.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/formater/formater.dart';
import '../../../../data/network/reseller/reseller_success_stories/reseller_success_stories_model.dart';
import '../../../../utils/shimmer/contractor/success_story/contractor_success_story_screen_shimmer.dart';
import '../../../property_rating/view/widget/read_more_or_less.dart';
import '../../controller/reseller_success_stories_controller/reseller_success_stories_controller.dart';

class ContractorSuccessStoryScreen extends StatelessWidget {
  final ResellerSuccessStoryController controller = Get.put(
    ResellerSuccessStoryController(),
  );

  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );

  ContractorSuccessStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.bgColor,
        title: Text(
          'Contractor Success Stories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        // return ContractorSuccessStoryScreenShimmer();

        if (controller.isLoading.value) {
          return ContractorSuccessStoryScreenShimmer();
        }

        if (controller.items.isEmpty && !controller.isLoading.value) {
          return Center(child: _buildEmptyState());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ContractorSuccessStoryCard(
            story:
                controller.items.isNotEmpty
                    ? controller.items.first
                    : ResellerSuccessItem.fromJson({}),
            // fallback if list is empty
            controller: dashboardController,
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorRes.primary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(ColorRes.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Loading story stories...",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              color: ColorRes.leadGreyColor,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorRes.white,
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Share Your Success',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                  SizedBox(height: 12),

                  Text(
                    'Add your achievement success and inspire others in the community',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.leadGreyColor.shade700,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: ColorRes.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(
                          () =>
                              AddResellerSuccessStoryScreen(isEditMode: false),
                        );
                      },
                      icon: Icon(Icons.add_circle_outline, size: 22),
                      label: Text('Add Success Story'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        textStyle: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                        ),
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

  Widget _buildStoryCard(ResellerSuccessItem story) {
    final formattedDate = DateFormat.yMMMM().format(
      DateTime.parse(story.monthYear.toIso8601String()),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: ColorRes.transparentColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Get.to(
              () =>
                  AddResellerSuccessStoryScreen(story: story, isEditMode: true),
            );
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with trophy and status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.emoji_events,
                            color: ColorRes.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                '${story.title}' ?? "Untitled Story",
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              // const SizedBox(width: 3),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: ColorRes.leadGreyColor.shade600,
                                  fontSize: AppFontSizes.extraSmall,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              story.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(story.status),
                                size: 12,
                                color: _getStatusColor(story.status),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatStatus(story.status),
                                style: TextStyle(
                                  color: _getStatusColor(story.status),
                                  fontSize: AppFontSizes.caption,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Description with Read More
                    if (story.description != null &&
                        story.description!.isNotEmpty)
                      ReadMoreText(
                        '${story.description}',
                        trimLines: 4,
                        colorClickableText: ColorRes.primary,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' Read more',
                        trimExpandedText: ' Read less',
                        style: TextStyle(
                          color: ColorRes.leadGreyColor.shade700,
                          fontSize: AppFontSizes.extraSmall,
                          height: 1.5,
                          fontWeight: AppFontWeights.regular,
                        ),
                        lessStyle: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                        moreStyle: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Achievement Highlight
                    if (story.achievement != null &&
                        story.achievement!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: ColorRes.primary, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Key Achievement",
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.primary,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    story.achievement!,
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.leadGreyColor.shade700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Stats Section
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            Icons.handshake,
                            story.totalDeals?.toString() ?? "0",
                            "Deals",
                            ColorRes.lightPurpleColor,
                            ColorRes.leadIndigoColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            Icons.account_balance_wallet,
                            "₹${_formatCurrency(story.totalValue)}",
                            "Value",
                            ColorRes.green,
                            ColorRes.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricCard(
                            Icons.star_rounded,
                            story.rating?.toStringAsFixed(1) ?? "0.0",
                            "Rating",
                            ColorRes.homeAmber,
                            ColorRes.homeAmber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    IconData icon,
    String value,
    String label,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: AppFontWeights.medium,
              color: color,
              fontSize: AppFontSizes.bodySmall,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorRes.leadGreyColor.shade700,
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.to(() => AddResellerSuccessStoryScreen());
      },
      backgroundColor: ColorRes.primary,
      elevation: 0,
      icon: const Icon(Icons.add, color: Colors.white, size: 20),
      label: const Text(
        "New Story",
        style: TextStyle(
          color: ColorRes.white,
          fontWeight: AppFontWeights.semiBold,
          fontSize: AppFontSizes.bodySmall,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return "0";
    final numValue = double.tryParse(value.toString()) ?? 0;
    if (numValue >= 10000000) {
      return "${(numValue / 10000000).toStringAsFixed(1)}Cr";
    } else if (numValue >= 100000) {
      return "${(numValue / 100000).toStringAsFixed(1)}L";
    } else if (numValue >= 1000) {
      return "${(numValue / 1000).toStringAsFixed(1)}K";
    }
    return numValue.toStringAsFixed(0);
  }

  String _formatStatus(String? status) {
    if (status == null) return "Draft";
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'published':
        return Icons.check_circle;
      case 'draft':
        return Icons.edit_note;
      case 'archived':
        return Icons.archive;
      default:
        return Icons.pending;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'published':
        return ColorRes.green;
      case 'draft':
        return ColorRes.homeAmber;
      case 'archived':
        return ColorRes.leadGreyColor.shade700;
      default:
        return ColorRes.builderGridLightPurple;
    }
  }
}

class ContractorSuccessStoryCard extends StatefulWidget {
  final ResellerSuccessItem story;
  final DashboardController controller;

  const ContractorSuccessStoryCard({
    super.key,
    required this.story,
    required this.controller,
  });

  @override
  State<ContractorSuccessStoryCard> createState() =>
      _ContractorSuccessStoryCardState();
}

class _ContractorSuccessStoryCardState
    extends State<ContractorSuccessStoryCard> {
  @override
  Widget build(BuildContext context) {
    final isPublished = widget.story.status.toLowerCase() == 'published';
    final formattedDate = _formatMonthYear(
      widget.story.monthYear.toIso8601String(),
    );
    log("Success Story Card ${widget.story.toJson()}");

    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Card(
          color: ColorRes.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: ColorRes.leadGreyColor.shade300),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 🔹 Image Stack Section
              Stack(
                children: [
                  // Main Image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child:
                        widget.story.image != null &&
                                widget.story.image!.isNotEmpty
                            ? Image.network(
                              widget.story.image!,
                              fit: BoxFit.cover,

                              // 🌀 Add loading indicator
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: ColorRes.leadGreyColor.shade200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorRes.primary,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: ColorRes.leadGreyColor.shade700,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: ColorRes.white.withOpacity(0.7),
                                      size: 40,
                                    ),
                                  ),
                            )
                            : Container(
                              color: ColorRes.leadGreyColor.shade700,
                              child: Icon(
                                Icons.image,
                                color: ColorRes.white.withOpacity(0.7),
                                size: 40,
                              ),
                            ),
                  ),

                  // Published/Draft Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isPublished
                                  ? ColorRes.green
                                  : ColorRes.leadGreyColor.shade800,
                          width: 0.5,
                        ),
                        color:
                            isPublished
                                ? ColorRes.green
                                : ColorRes.leadGreyColor.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ColorRes.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isPublished ? 'PUBLISHED' : 'DRAFT',
                            style: const TextStyle(
                              color: ColorRes.white,
                              fontSize: AppFontSizes.caption,
                              fontWeight: AppFontWeights.semiBold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Date Badge (bottom-left)
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorRes.black, width: 0.5),
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: ColorRes.black,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: ColorRes.black,
                              fontSize: AppFontSizes.caption,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 🔹 Content Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.story.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorRes.homeAmber.shade200,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: ColorRes.homeAmber.shade50,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: ColorRes.homeAmber.shade800,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.story.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: ColorRes.homeAmber.shade800,
                                  fontSize: AppFontSizes.caption,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    /*  Text(
                      story.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor.shade600,
                        height: 1.4,
                      ),
                    ),*/
                    ReadMoreClass(
                      description: widget.story.description,
                      trimLines: 3,
                      size: AppFontSizes.caption,
                      colorClickableText: ColorRes.primary,
                    ),

                    const SizedBox(height: 8),
                    Divider(height: 1, color: ColorRes.border),
                    const SizedBox(height: 8),

                    // Achievement Box
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: ColorRes.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ACHIEVEMENT',
                              style: TextStyle(
                                color: ColorRes.green,
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.semiBold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ReadMoreClass(
                          description: widget.story.achievement,
                          trimLines: 3,
                          size: AppFontSizes.caption,
                          colorClickableText: ColorRes.primary,
                        ),
                        /* Text(
                          story.achievement,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.leadGreyColor.shade600,
                            height: 1.4,
                          ),
                        ),*/
                      ],
                    ),

                    const SizedBox(height: 8),
                    Divider(height: 1, color: ColorRes.border),
                    const SizedBox(height: 8),

                    // Performance Section
                    _buildPerformanceSection(widget.story),
                    const SizedBox(height: 8),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ResellerSuccessItem storyData =
                                  ResellerSuccessItem(
                                    id: widget.story.id,
                                    title: widget.story.title,
                                    description: widget.story.description,
                                    achievement: widget.story.achievement,
                                    totalDeals: widget.story.totalDeals,
                                    totalValue: widget.story.totalValue,
                                    monthYear: DateTime.parse(
                                      widget.story.monthYear.toIso8601String(),
                                    ),

                                    rating: widget.story.rating,
                                    status: widget.story.status,
                                    image: widget.story.image,
                                    resellerId: widget.story.resellerId,
                                  );
                              Get.to(
                                () => AddResellerSuccessStoryScreen(
                                  isEditMode: true,
                                  story: storyData,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.green.withOpacity(0.1),
                              foregroundColor: ColorRes.green,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: ColorRes.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  icon: Icon(
                                    Icons.info,
                                    color: ColorRes.homeAmber,
                                  ),
                                  title: const Text(
                                    'Delete Success Story',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.large,
                                      fontWeight: AppFontWeights.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete this story?',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.regular,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // close dialog
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: ColorRes.grey,
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                    ),
                                    Obx(() {
                                      return ElevatedButton(
                                        onPressed:
                                            widget
                                                    .controller
                                                    .deleteSuccessStory
                                                    .value
                                                ? null // disable while deleting
                                                : () {
                                                  Get.back(); // close dialog
                                                  widget.controller.deleteStory(
                                                    widget.story.id,
                                                  );
                                                },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorRes.error,
                                          foregroundColor: ColorRes.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child:
                                            widget
                                                    .controller
                                                    .deleteSuccessStory
                                                    .value
                                                ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                                : const Text(
                                                  'Yes, Delete',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        AppFontWeights.semiBold,
                                                  ),
                                                ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.error.withOpacity(0.1),
                              foregroundColor: ColorRes.error,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceSection(ResellerSuccessItem story) {
    log("Success Story Performance ${story.toJson()}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bar_chart,
              color: ColorRes.builderGridLightPurple,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'PERFORMANCE',
              style: TextStyle(
                color: ColorRes.builderGridLightPurple,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPerformanceTile(
                icon: Icons.check_circle_outline,
                iconColor: ColorRes.builderGridLightBlue,
                bgColor: ColorRes.builderGridLightBlue.withOpacity(0.1),
                label: 'TOTAL LEADS',
                value: Formatter.formatNumber(story.totalDeals),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPerformanceTile(
                icon: Icons.attach_money,
                iconColor: ColorRes.green,
                bgColor: ColorRes.green.withOpacity(0.1),
                label: 'TOTAL VALUE',
                value: Formatter.formatPrice(
                  double.tryParse(story.totalValue)?.round() ?? 0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPerformanceTile(
                icon: Icons.star_outline,
                iconColor: ColorRes.homeAmber,
                bgColor: ColorRes.homeAmber.withOpacity(0.1),
                label: 'AVG PER DEAL',
                value:
                    story.totalDeals > 0
                        ? Formatter.formatPrice(
                          ((double.tryParse(story.totalValue) ?? 0) /
                                  story.totalDeals)
                              .round(),
                        )
                        : '₹0',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorRes.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: ColorRes.leadGreyColor.shade600,
              fontSize: AppFontSizes.mini,
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: ColorRes.textColor,
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMonthYear(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  String _formatValue(int value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(0)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toString();
  }
}
