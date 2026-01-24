//
// import 'package:flutter/material.dart';
//
// import '../../app/constants/app_font_sizes.dart';
// import '../../app/constants/color_res.dart';
// import '../../app/constants/font_res.dart';
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final String? labelText;
//   final IconData? prefixIcon;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;
//   final int maxLines;
//   final TextCapitalization textCapitalization; // Add this line
//   final double radius;
//   final bool enabled;
//   final Color? fillColor;
//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.labelText,
//     this.enabled = true,
//     this.fillColor,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.onChanged,
//     this.maxLines = 1,
//     this.textCapitalization = TextCapitalization.none, // Add with default
//     this.radius = 16.0,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       enabled: enabled,
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization, // Add this line
//       validator: validator,
//       onChanged: onChanged,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         hintText: hintText,
//
//         labelText: labelText,
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius ?? 8.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius ?? 8.0),
//           borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius ?? 8.0),
//           borderSide: BorderSide(
//             color: Theme.of(context).primaryColor,
//             width: 2.0,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius ?? 8.0),
//           borderSide: BorderSide(
//             color: Theme.of(context).colorScheme.error,
//             width: 1.0,
//           ),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius ?? 8.0),
//           borderSide: BorderSide(
//             color: Theme.of(context).colorScheme.error,
//             width: 2.0,
//           ),
//         ),
//         filled: true,
//         contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//         fillColor: fillColor ?? ColorRes.leadGreyColor.shade100,
//       ),
//       style: TextStyle(
//         fontSize: AppFontSizes.body,
//         fontFamily: FontRes.nuNunitoSans,
//         fontWeight: AppFontWeights.medium,
//       ),
//     );
//   }
// }
