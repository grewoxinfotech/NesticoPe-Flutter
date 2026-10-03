import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/color_res.dart';

export 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class NesticoPeSnackBar {
  static void showAwesomeSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
    Color? color,
  }) {
    final ctx = Get.context ?? Get.key.currentContext ?? Get.overlayContext;
    if (ctx == null) return;

    void dismiss() {
      try {
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).clearSnackBars();
      } catch (_) {}
      try {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
      } catch (_) {}
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorRes.transparentColor,
      duration: const Duration(seconds: 4),
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: dismiss,
            child: AwesomeSnackbarContent(
              title: title,
              message: message,
              contentType: contentType,
              color: color,
              inMaterialBanner: true,
              titleTextStyle: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.bold,
              ),
              messageTextStyle: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            width: 60,
            height: 60,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismiss,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

void showTopAwesomeSnackbar({
  required String title,
  required String message,
  required ContentType contentType,
  Color? color,
}) {
  void dismiss() {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    } catch (_) {}
  }

  Get.snackbar(
    "",
    "",
    snackPosition: SnackPosition.TOP, // 👈 TOP
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.all(12),
    padding: EdgeInsets.zero,
    duration: const Duration(seconds: 4),
    onTap: (_) => dismiss(),
    messageText: Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: dismiss,
          child: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
            color: color,
            inMaterialBanner: false,
            titleTextStyle: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.bold,
            ),
            messageTextStyle: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          width: 60,
          height: 60,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: dismiss,
            child: const SizedBox.expand(),
          ),
        ),
      ],
    ),
  );
}
