import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/utils/helper_function/contact_helper.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';

import '../../app/constants/color_res.dart';
import '../../app/manager/compare_manager.dart';
import '../../app/manager/project_compare_manager.dart';
import '../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../modules/property/controllers/share_property_controller.dart';
import '../../modules/property/views/property_detail_screen.dart';
import '../../modules/saved_property/controllers/property_favorite_controller.dart';
import '../bar/navigation_bar/navigation_Bar.dart';
import '../messages/snack_bar.dart';

class EntityActionButtons extends StatelessWidget {
  final String id;
  final dynamic entity; // Property, Project, Event etc.
  final int maxCompare;
  final VoidCallback? onShare;

  // Controllers (passed from outside, so fully reusable)
  final CompareManager? compareController;
  final ProjectCompareManager? projectCompareController;
  final PropertyFavoriteController favoriteController;

  const EntityActionButtons({
    super.key,
    required this.id,
    required this.entity,
    this.compareController,
    this.projectCompareController,
    required this.favoriteController,
    this.maxCompare = 2,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final SharePropertyController propertyShareController = Get.put(
      SharePropertyController(),
    );
    return Row(
      children: [
        // ------------------ COMPARE BUTTON ------------------
        Obx(() {
          bool isSelected;
          if (projectCompareController != null) {
            isSelected = projectCompareController!.isSelected(id);
          } else {
            isSelected = compareController!.isSelected(id);
          }

          return (UserHelper.isGuest || UserHelper.isBuyer)? CircularIcon(
            icon: Icons.compare_arrows_rounded,
            backgroundColor: isSelected ? ColorRes.primary : ColorRes.white,
            iconColor: isSelected ? ColorRes.white : ColorRes.primary,
            onPressed: () {
              int before;
              if (projectCompareController != null) {
                before = projectCompareController!.count;
              } else {
                before = compareController!.count;
              }

              if (compareController != null) {
                compareController!.toggle(entity, max: maxCompare);
              } else {
                projectCompareController!.toggle(entity, max: maxCompare);
              }
              // compareController.toggle(entity, max: maxCompare);
              int after;
              if (projectCompareController != null) {
                after = projectCompareController!.count;
              } else {
                after = compareController!.count;
              }
              // final after = compareController.count;

              final ctx = Get.overlayContext;
              if (ctx == null) return;

              if (after > before) {
                // Added
                CustomSnackBar.show(
                  ctx,
                  message:
                      after == maxCompare
                          ? 'Ready to compare!'
                          : 'Added to compare ($after/$maxCompare)',
                  type: SnackBarType.success,
                  actionLabel: after == maxCompare ? 'Compare Now' : null,
                  onActionPressed:
                      after == maxCompare
                          ? () {
                            Get.back();
                            if (Get.isRegistered<NavigationController>()) {
                              Get.find<NavigationController>().changeIndex(2);
                            }
                          }
                          : null,
                );
              } else if (after < before) {
                // Removed
                CustomSnackBar.show(
                  ctx,
                  message:
                      after == 0
                          ? 'Removed from compare'
                          : 'Removed from compare ($after/$maxCompare)',
                  type: SnackBarType.info,
                );
              } else {
                // Limit reached
                CustomSnackBar.show(
                  ctx,
                  message: 'You can only compare $maxCompare items',
                  type: SnackBarType.warning,
                );
              }
            },
          ):SizedBox.shrink();
        }),

        const SizedBox(width: 12),

        // ------------------ FAVORITE BUTTON ------------------
        Obx(() {
          final isFav = favoriteController.favorites.contains(id);

          return (UserHelper.isGuest || UserHelper.isBuyer)? CircularIcon(
            icon: isFav ? Icons.favorite : Icons.favorite_border_rounded,
            backgroundColor: ColorRes.white,
            iconColor: isFav ? ColorRes.redAccentColor : ColorRes.primary,
            onPressed: () => favoriteController.toggleFavorite(id),
          ):SizedBox.shrink();
        }),

        const SizedBox(width: 12),

        // ------------------ SHARE BUTTON ------------------
        CircularIcon(
          icon: Icons.share_outlined,
          backgroundColor: ColorRes.white,
          onPressed:
              onShare ??
              () async {
                await propertyShareController.getPropertyLinkById(id);
                final propertyId =
                    propertyShareController.shareProperty.value?.data?.propertyId;




                if (propertyId != null && propertyId.isNotEmpty) {
                  ContactHelper.shareContent(link: '${ApiConstants.frontendBaseUrl}/properties/$propertyId');
                } else {
                  NesticoPeSnackBar.showAwesomeSnackbar(
                    title: "Error",
                    message: "Unable to generate share link right now.",
                    contentType: ContentType.failure,
                  );
                }
              },
        ),
      ],
    );
  }
}
