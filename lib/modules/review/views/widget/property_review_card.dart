import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/review/model/review_model.dart';
import 'package:housing_flutter_app/modules/user/controllers/user_controller.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/img_res.dart';
import '../../../../app/constants/size_manager.dart';

class PropertyReviewCard extends StatefulWidget {
  final ReviewItem reviewItem;
  const PropertyReviewCard({super.key, required this.reviewItem});

  @override
  State<PropertyReviewCard> createState() => _PropertyReviewCardState();
}

class _PropertyReviewCardState extends State<PropertyReviewCard> {
  late final UserController userController;

  @override
  void initState() {
    super.initState();

    final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';

    Get.put(UserController(), tag: tag);
    userController = Get.find<UserController>(tag: tag);

    userController.fetchUserById(widget.reviewItem.createdBy ?? "");
  }

  @override
  void dispose() {
    // Clean up: Delete the controller when this card is disposed
    final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
    Get.delete<UserController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorRes.leadGreyColor.shade200.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER — Avatar + Reviewer Info
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(child: _buildReviewerInfo()),
              ],
            ),

            const SizedBox(height: 16),

            /// RATING
            _buildRatingRow(),

            const SizedBox(height: 16),

            /// REVIEW CONTENT
            Text(
              '"${widget.reviewItem.content}"',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.leadGreyColor.shade700,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),
            const Spacer(),

            /// FOOTER — Property Type & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.reviewItem.entityType!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.homeGreenFade.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.reviewItem.entityType!,
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.homeGreenFade,
                      ),
                    ),
                  ),
                Text(
                  _formatDate(widget.reviewItem.createdAt!),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Avatar widget
  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF2E7D63).withOpacity(0.2),
          width: 2,
        ),
        gradient: LinearGradient(
          colors: [
            ColorRes.homeGreenFade.withOpacity(0.1),
            ColorRes.homeGreenDarkFade.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Image.asset(
          IMGRes.user_2,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Icon(
                Icons.person,
                color: ColorRes.leadGreyColor.shade300,
                size: 28,
              ),
        ),
      ),
    );
  }

  /// Reviewer info (name + verification)
  Widget _buildReviewerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value &&
                    userController.user.value == null) {
                  return const Text('-');
                }
                return Text(
                  userController.user.value?.username ?? "Anonymous",
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.extraBold,
                    color: ColorRes.homeBlackFade,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
            if (widget.reviewItem.isVerified ?? false)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ColorRes.homeGreenDarkFade,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.check, color: ColorRes.white, size: 12),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.reviewItem.verificationType ?? "Verified User",
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.leadGreyColor.shade600,
          ),
        ),
      ],
    );
  }

  /// Rating row
  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < widget.reviewItem.rating!.floor()) {
            return const Icon(Icons.star, color: ColorRes.homeYellow, size: 16);
          } else if (index < widget.reviewItem.rating!) {
            return const Icon(
              Icons.star_half,
              color: ColorRes.homeYellow,
              size: 16,
            );
          } else {
            return Icon(
              Icons.star_outline,
              color: ColorRes.leadGreyColor.shade300,
              size: 16,
            );
          }
        }),
        const SizedBox(width: 8),
        Text(
          widget.reviewItem.rating!.toStringAsFixed(1),
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.homeBlackFade,
          ),
        ),
      ],
    );
  }

  /// Format date for readability
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}
