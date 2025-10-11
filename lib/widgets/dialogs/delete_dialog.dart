import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/font_res.dart';
import '../../app/constants/size_manager.dart';
import '../button/button.dart';
import '../display/card.dart';

class NesticoPeDeleteDialog extends StatelessWidget {
  final String? entityType;
  final GestureTapCallback? onConfirm;
  final VoidCallback? onCancel;

  const NesticoPeDeleteDialog({
    super.key,
    this.entityType,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        alignment: Alignment.center,
        color: Get.theme.dialogBackgroundColor,
        child: NesticoPeCard(
          padding: const EdgeInsets.all(AppPadding.medium),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  "Delete Confirmation",
                  style: TextStyle(
                    fontSize: AppFontSizes.large,
                    fontFamily: FontRes.nuNunitoSans,
                    color: Get.theme.colorScheme.error,
                    fontWeight: AppFontWeights.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              AppSpacing.verticalSmall,
              Text(
                "Are you sure you want to delete this $entityType?",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontFamily: FontRes.nuNunitoSans,
                  color: Get.theme.colorScheme.onSecondary,
                  fontWeight: AppFontWeights.semiBold,
                  decoration: TextDecoration.none,
                ),
              ),
              AppSpacing.verticalSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      onCancel?.call();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Get.theme.colorScheme.onSecondary,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.medium,
                        fontFamily: FontRes.nuNunitoSans,
                      ),
                    ),
                  ),
                  NesticoPeButton(
                    width: 100,
                    height: 35,
                    backgroundColor: Get.theme.colorScheme.error,
                    title: "Delete",
                    onTap: () {
                      Get.back();
                      onConfirm?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
