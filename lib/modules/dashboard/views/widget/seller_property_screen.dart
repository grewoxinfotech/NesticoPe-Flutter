// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../data/database/secure_storage_service.dart';
// import '../../../property/controllers/property_controller.dart';
// import '../../../seller/module/seller_home_screen/views/property_overview_screen.dart';
//
// class SellerPropertyScreen extends StatefulWidget {
//   const SellerPropertyScreen({super.key});
//
//   @override
//   State<SellerPropertyScreen> createState() => _SellerPropertyScreenState();
// }
//
// class _SellerPropertyScreenState extends State<SellerPropertyScreen> {
//   final controller = Get.find<PropertyController>();
//
//   Future<void> refreshPropertyBySeller() async {
//     final user = await SecureStorage.getUserData();
//     if (user != null) {
//       controller.applyFilter(
//         "created_by",
//         user.user?.id.toString() ?? "",
//         includeCity: false,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value && controller.items.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       if (!controller.isLoading.value && controller.items.isEmpty) {
//         return const Center(child: Text("No Property found."));
//       }
//
//       return NotificationListener<ScrollEndNotification>(
//         onNotification: (notification) {
//           final metrics = notification.metrics;
//           if (metrics.pixels >= metrics.maxScrollExtent) {
//             controller.loadMore();
//           }
//           return true;
//         },
//         child: RefreshIndicator(
//           onRefresh: refreshPropertyBySeller,
//           child: PropertyOverviewScreen(
//             properties: controller.items,
//             onDelete: () => refreshPropertyBySeller(),
//           ),
//         ),
//       );
//     });
//   }
// }
