import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../../app/constants/app_font_sizes.dart';

/// Common reusable TextFormField with border type support.
class CommonTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final int minLine;
  final int maxLine;

  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;

  final Widget? suffixIcon;
  final String? suffixText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool enabled;
  final bool obscureText;

  /// borderType: 'outline', 'underline', 'none', 'filled'
  final String borderType;

  const CommonTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.validator,
    this.onSaved,
    this.enabled = true,
    this.obscureText = false,
    this.borderType = 'outline',
    this.minLine = 1,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    InputBorder getBorder() {
      switch (borderType) {
        case 'underline':
          return const UnderlineInputBorder();
        case 'none':
          return InputBorder.none;
        case 'filled':
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          );
        default: // 'outline'
          return OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(12),
          );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ((label?.isNotEmpty ?? false))
            ? SizedBox(height: 10)
            : SizedBox.shrink(),
        (label?.isNotEmpty ?? false)
            ? Text(
              label ?? '',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textPrimary,
              ),
            )
            : SizedBox.shrink(),
        ((label?.isNotEmpty ?? false))
            ? SizedBox(height: 8)
            : SizedBox.shrink(),
        TextFormField(
          controller: controller,
          maxLines: maxLine,
          minLines: minLine,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: controller == null ? initialValue : null,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.textPrimary,
          ),
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onSaved,
          obscureText: obscureText,
          enabled: enabled,

          decoration: InputDecoration(
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              maxHeight: 20,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: AppFontSizes.medium,
              color: Colors.grey.shade500,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            border: getBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 0.8,
                color: ColorRes.grey.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1.2, color: ColorRes.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1.2, color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1.2, color: Colors.red),
            ),
            filled: borderType == 'filled',
            fillColor: Colors.grey.shade50,
            errorStyle: TextStyle(
              color: Colors.red.shade700,
              fontSize: AppFontSizes.small,
            ),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../widgets/New folder/inputs/text_field.dart';
//
// class CommonTextField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final TextEditingController? controller;
//   final String? initialValue;
//   final TextInputType keyboardType;
//   final TextCapitalization textCapitalization;
//   final TextInputAction textInputAction;
//   final int minLine;
//   final int maxLine;
//
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final String? suffixText;
//
//   final ValueChanged<String>? onChanged;
//   final FormFieldValidator<String>? validator;
//   final FormFieldSetter<String>? onSaved;
//
//   final bool enabled;
//   final bool obscureText;
//
//   /// 'outline', 'underline', 'none', 'filled'
//   final String borderType;
//
//   const CommonTextField({
//     super.key,
//     required this.label,
//     this.hint,
//     this.controller,
//     this.initialValue,
//     this.onChanged,
//     this.keyboardType = TextInputType.text,
//     this.textCapitalization = TextCapitalization.none,
//     this.textInputAction = TextInputAction.next,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.suffixText,
//     this.validator,
//     this.onSaved,
//     this.enabled = true,
//     this.obscureText = false,
//     this.borderType = 'outline',
//     this.minLine = 1,
//     this.maxLine = 1,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return NesticoPeTextField(
//       controller: controller,
//       title: (label?.isNotEmpty ?? false) ? label : null,
//       style: TextStyle(
//         fontSize: AppFontSizes.caption,
//         fontWeight: AppFontWeights.medium,
//         color: ColorRes.textPrimary,
//       ),
//       hintText: hint,
//       enabled: enabled,
//       obscureText: obscureText,
//       validator: validator,
//       onChanged: onChanged ?? onSaved,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization,
//       textInputAction: textInputAction,
//       maxLines: maxLine,
//       prefixIcon: prefixIcon is Icon ? (prefixIcon as Icon).icon : null,
//       suffixIcon:
//           suffixIcon ??
//           (suffixText != null
//               ? Padding(
//                 padding: const EdgeInsets.only(right: 12),
//                 child: Center(
//                   heightFactor: 0.5,
//                   widthFactor: 0,
//                   child: Text(
//                     suffixText!,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       color: ColorRes.textSecondary,
//                     ),
//                   ),
//                 ),
//               )
//               : null),
//     );
//   }
// }
