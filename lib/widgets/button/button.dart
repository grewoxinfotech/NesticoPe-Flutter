import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/color_res.dart';
import '../../app/constants/font_res.dart';
import '../../app/constants/size_manager.dart';
import '../display/card.dart';

class NesticoPeButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String title;
  final double? width;
  final double? height;
  final TextStyle? titleTextStyle;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final String? heroTag;

  const NesticoPeButton({
    super.key,
    required this.title,
    required this.onTap,
    this.width,
    this.height,
    this.titleTextStyle,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final button = NesticoPeCard(
      width: width ?? 150,
      height: height ?? 48,
      color: backgroundColor ?? Get.theme.colorScheme.primary,
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.medium),
      boxShadow: boxShadow,
      child: Center(
        child: Text(
          title,
          style:
              titleTextStyle ??
              TextStyle(
                fontSize: AppFontSizes.body,
                fontFamily: FontRes.poppins,
                fontWeight: AppFontWeights.bold,
                color: Get.theme.colorScheme.surface,
              ),
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child:
          heroTag != null
              ? Hero(
                tag: heroTag!,
                child: Material(color: ColorRes.transparentColor, child: button),
              )
              : Material(color: ColorRes.transparentColor, child: button),
    );
  }
}
