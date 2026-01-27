import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/reseller/view/reseller_success_stories/add_reseller_success_stories_screen.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/reseller/reseller_success_stories/reseller_success_stories_model.dart';
import '../../controller/reseller_success_stories_controller/reseller_success_stories_controller.dart';

class ResellerSuccessStoryScreen extends StatelessWidget {
  final ResellerSuccessStoryController controller = Get.put(
    ResellerSuccessStoryController(),
  );

  ResellerSuccessStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.bgColor,
        title: Text(
          'Partner Success Stories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return SliverFillRemaining(child: _buildLoadingState());
            }

            if (controller.items.isEmpty) {
              return SliverFillRemaining(child: _buildEmptyState());
            }

            return SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < controller.items.length) {
                      final story = controller.items[index];
                      return _buildStoryCard(story, index);
                    } else if (controller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                  childCount:
                      controller.items.length +
                      (controller.isLoading.value ? 1 : 0),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: _buildFAB(),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.purple.shade50],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories,
                size: 60,
                color: ColorRes.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Success Stories Yet",
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start celebrating achievements!\nCreate your first story story and inspire others.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => AddResellerSuccessStoryScreen());
              },
              icon: const Icon(Icons.add),
              label: const Text("Create First Story"),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(ResellerSuccessItem story, int index) {
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