import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

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
  final Color? iconColor;
  final TextStyle style;
  final List<TextInputFormatter>? formatter;
  final String? initialValue;
  final int? minLines;

  const NesticoPeTextField({
    super.key,
    this.controller,
    this.title,
    this.validator,
    this.hintText,
    this.iconColor = ColorRes.primary,
    this.obscureText = false,
    this.style = const TextStyle(
      fontSize: AppFontSizes.medium,
      color: ColorRes.textSecondary,
      fontWeight: AppFontWeights.bold,

    ),
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
    this.formatter = const [],
    this.initialValue,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     if (title != null) Text(title!, style: style),
        //     if (isRequired)
        //       Text(
        //         ' *',
        //         style: TextStyle(
        //           color: Get.theme.colorScheme.error,
        //           fontSize: AppFontSizes.medium,
        //           fontWeight: AppFontWeights.bold,
        //         ),
        //       ),
        //   ],
        // ),
        if (title != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Tooltip(
                  message: title!,
                  waitDuration: const Duration(milliseconds: 500),
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
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
          onTap: onTap,
          maxLines: maxLines,
          enabled: enabled,
          readOnly: readOnly,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          inputFormatters: formatter,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            color: Get.theme.colorScheme.onSurface,
            fontWeight: AppFontWeights.medium,
          ),
          decoration: InputDecoration(
            counterText: "", // <--- Hide the character counter
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
                      child: Icon(prefixIcon, size: 20, color: iconColor),
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
