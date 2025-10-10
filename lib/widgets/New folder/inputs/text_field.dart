import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

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
              style: const TextStyle(
                fontSize: 14,
                color: ColorRes.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Get.theme.colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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
            fontSize: 15,
            color: Get.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
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
              fontSize: 15,
              fontWeight: FontWeight.w400,
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
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
