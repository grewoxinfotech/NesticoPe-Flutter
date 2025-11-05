import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/size_manager.dart';

class NesticoPeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final AutovalidateMode? autovalidateMode;
  final bool isRequired;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final int? maxLength;

  const NesticoPeTextField({
    super.key,
    this.controller,
    required this.title,
    this.validator,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired = false,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title!,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.black,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Get.theme.colorScheme.error,
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.bold,
                ),
              ),
          ],
        ),
        AppSpacing.verticalSmall,
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          enabled: enabled,
          readOnly: readOnly,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          onTap: onTap,
          style: TextStyle(
            fontSize: AppFontSizes.bodyMedium,
            color: Get.theme.colorScheme.onSurface,
            fontWeight: AppFontWeights.medium,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(AppPadding.small),
            filled: true,
            fillColor:
                enabled
                    ? Get.theme.colorScheme.surface
                    : Get.theme.colorScheme.surface.withAlpha(128),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Get.theme.colorScheme.onSurface.withAlpha(128),
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: AppFontWeights.regular,
            ),
            prefixIcon:
                prefixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        prefixIcon,
                        size: 20,
                        color: Get.theme.colorScheme.primary,
                      ),
                    )
                    : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            suffixIcon: suffixIcon,
            enabledBorder: tile(Get.theme.dividerColor),
            focusedBorder: tile(Get.theme.colorScheme.primary),
            errorBorder: tile(Get.theme.colorScheme.error),
            focusedErrorBorder: tile(Get.theme.colorScheme.error),
            disabledBorder: tile(Get.theme.dividerColor),
            errorStyle: TextStyle(
              color: Get.theme.colorScheme.error,
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}

InputBorder? tile(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.medium),
    borderSide: BorderSide(color: color, width: 1),
  );
}
