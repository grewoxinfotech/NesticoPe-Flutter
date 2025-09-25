// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
// import '../../../app/constants/ic_res.dart';
// import '../../../app/constants/size_manager.dart';
// import '../../display/app_logo.dart';
// import '../../display/ic.dart';
//
// class NesticoPeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final Widget? leading;
//   final Widget? title;
//   final String? hintText;
//   final List<Widget>? action;
//
//   const NesticoPeAppBar({
//     super.key,
//     this.leading,
//     this.title,
//     this.hintText,
//     this.action,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         // margin: const EdgeInsets.symmetric(horizontal: AppMargin.small),
//         child: AppBar(
//           toolbarHeight: kToolbarHeight,
//           elevation: 5.0,
//           scrolledUnderElevation: 5.0,
//           automaticallyImplyLeading: false,
//           backgroundColor: Get.theme.colorScheme.surface,
//           foregroundColor: Get.theme.colorScheme.surface,
//           shadowColor: ColorRes.primary.withAlpha(40),
//           surfaceTintColor: Colors.transparent,
//           actionsPadding: const EdgeInsets.only(right: AppPadding.medium),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(AppRadius.extraLarge),
//               bottomRight: Radius.circular(AppRadius.extraLarge),
//             ),
//             // BorderRadius.circular(AppRadius.large),
//           ),
//           leading:
//               leading ??
//               const Align(alignment: Alignment.center, child: NesticoPeAppLogo()),
//
//           title: title,
//           actions:
//               action ??
//               [
//                 NesticoPeIc(
//                   iconPath: ICRes.search,
//                   color: Get.theme.colorScheme.onPrimary,
//                 ),
//
//                 AppSpacing.horizontalMedium,
//                 NesticoPeIc(
//                   iconPath: ICRes.notifications,
//                   color: Get.theme.colorScheme.onPrimary,
//                 ),
//                 AppSpacing.horizontalMedium,
//                 GestureDetector(
//                   onTap: () => Get.to(const ProfileScreen()),
//                   child: const CircleAvatar(
//                     radius: 15,
//                     child: Text(
//                       "G",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(150);
// }
