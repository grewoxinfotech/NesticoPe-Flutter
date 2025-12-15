// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';import 'package:get/get.dart';
//
// import '../../constants/app_font_sizes.dart';
// import '../../constants/color_res.dart';
//
// class NesticoPeSnackBar {
//   static void showAwesomeSnackbar({
//     required String title,
//     required String message,
//     required ContentType contentType,
//     Color? color,
//   }) {
//     final snackBar = SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: ColorRes.transparentColor,
//       content: AwesomeSnackbarContent(
//         title: title,
//         message: message,
//         contentType: contentType,
//         color: color,
//         inMaterialBanner: true,
//         titleTextStyle: TextStyle(fontSize: AppFontSizes.large, fontWeight: AppFontWeights.bold),
//         messageTextStyle: TextStyle(fontSize: AppFontSizes.medium, fontWeight: AppFontWeights.semiBold),
//       ),
//     );
//
//     ScaffoldMessenger.of(Get.context!)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(snackBar);
//   }
// }
