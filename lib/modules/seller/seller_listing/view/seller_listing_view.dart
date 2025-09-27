// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
//
// import '../controller/seller_listing_controller.dart';
// import '../widget/property_card.dart';
//
// class SellerListingView extends GetView<SellerListingController> {
//   const SellerListingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SellerListingController());
//
//     return SafeArea(
//       child: DefaultTabController(
//         length: 3, // Buy, Sell, Rent
//         child: Scaffold(
//           backgroundColor: ColorRes.white,
//           appBar: AppBar(
//             title: const Text("My Listings"),
//             elevation: 0,
//             actions: [
//               TextButton.icon(
//                 onPressed: () {
//                   // TODO: Navigate to Add Listing screen
//                 },
//                 icon: const Icon(Icons.add, size: 20),
//                 label: const Text("Add Listing"),
//                 style: TextButton.styleFrom(
//                   foregroundColor: ColorRes.primary,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                 ),
//               ),
//             ],
//           ),
//
//           body: Column(
//             children: [
//               // 🔹 ToggleButtons
//               Obx(
//                 () => ToggleButtons(
//                   borderRadius: BorderRadius.circular(AppRadius.medium),
//                   fillColor: ColorRes.primary.withOpacity(0.1),
//                   selectedColor: ColorRes.primary,
//                   color: Colors.black87,
//                   borderColor: ColorRes.grey.withOpacity(0.3),
//                   selectedBorderColor: ColorRes.primary,
//                   constraints: const BoxConstraints(
//                     minHeight: 40,
//                     minWidth: 120,
//                   ),
//                   textStyle: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   children: const [Text('Residential'), Text('Commercial')],
//                   isSelected: controller.isSelected,
//                   onPressed: (index) => controller.toggle(index),
//                 ),
//               ),
//
//               // 🔹 Show TabBar ONLY if Residential is selected
//               Obx(() {
//                 if (controller.isSelected[0]) {
//                   return Expanded(
//                     child: Column(
//                       children: [
//                         // TabBar (Buy, Sell, Rent)
//                         const TabBar(
//                           labelColor: Colors.black,
//                           indicatorColor: ColorRes.primary,
//                           unselectedLabelColor: Colors.grey,
//                           indicatorSize: TabBarIndicatorSize.tab,
//                           indicatorPadding: EdgeInsets.symmetric(
//                             horizontal: AppPadding.medium,
//                           ),
//                           labelStyle: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: ColorRes.primary,
//                           ),
//                           tabs: [
//                             Tab(text: "Buy"),
//                             Tab(text: "Sell"),
//                             Tab(text: "Rent"),
//                           ],
//                         ),
//
//                         // Filters Row
//                         SizedBox(
//                           height: 60,
//                           child: Obx(
//                             () => ListView.separated(
//                               scrollDirection: Axis.horizontal,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final isSelected =
//                                     controller.selectedFilter.value ==
//                                     controller.listingFilter[index];
//                                 return GestureDetector(
//                                   onTap: () {
//                                     controller.selectedFilter.value =
//                                         controller.listingFilter[index];
//                                     // Trigger UI update by filtering properties
//                                     controller.properties.refresh();
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color:
//                                             isSelected
//                                                 ? ColorRes.primary
//                                                 : ColorRes.grey.withOpacity(
//                                                   0.3,
//                                                 ),
//                                       ),
//                                       borderRadius: BorderRadius.circular(
//                                         AppRadius.medium,
//                                       ),
//                                       color:
//                                           isSelected
//                                               ? ColorRes.primary.withOpacity(
//                                                 0.1,
//                                               )
//                                               : Colors.transparent,
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 12.0,
//                                       horizontal: 16,
//                                     ),
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       controller.listingFilter[index],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               separatorBuilder:
//                                   (_, __) => const SizedBox(width: 8),
//                               itemCount: controller.listingFilter.length,
//                             ),
//                           ),
//                         ),
//
//                         // Listings per Tab
//                         Expanded(
//                           child: TabBarView(
//                             children: [
//                               _buildPropertyList(controller, "buy"),
//                               _buildPropertyList(controller, "sell"),
//                               _buildPropertyList(controller, "rent"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   // Commercial selected
//                   return Expanded(
//                     child: Obx(() {
//                       final items =
//                           controller.properties
//                               .where((e) => e["category"] == "commercial")
//                               .toList();
//                       if (items.isEmpty) {
//                         return const Center(
//                           child: Text("No Commercial listings"),
//                         );
//                       }
//                       return ListView.builder(
//                         itemCount: items.length,
//                         itemBuilder: (context, index) {
//                           final item = items[index];
//                           return PropertyListCard(
//                             id: item["id"].toString(),
//                             location: item["location"] ?? "Unknown Location",
//                             lastAddedDate: item["lastAddedDate"] ?? "N/A",
//                             roomType: item["roomType"] ?? "N/A",
//                             imageUrl: item["image"],
//                             title: item["title"],
//                             price: item["price"],
//                             status: item["status"],
//                             onRepost: () {},
//                           );
//                         },
//                       );
//                     }),
//                   );
//                 }
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Helper widget to build filtered property lists
//   Widget _buildPropertyList(
//     SellerListingController controller,
//     String category,
//   ) {
//     // Get the currently selected filter (status)
//     final selectedStatus = controller.selectedFilter.value;
//
//     // Filter by category first
//     final filteredItems =
//         controller.properties.where((e) => e["category"] == category).toList();
//
//     // Then filter by status if not "All"
//     final items =
//         selectedStatus == "All"
//             ? filteredItems
//             : filteredItems
//                 .where(
//                   (e) =>
//                       e["status"].toString().toLowerCase() ==
//                       selectedStatus.toString().toLowerCase(),
//                 )
//                 .toList();
//
//     if (items.isEmpty) {
//       return Center(child: Text("No $category listings"));
//     }
//
//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return PropertyListCard(
//           id: item["id"].toString(),
//           location: item["location"] ?? "Unknown Location",
//           lastAddedDate: item["lastAddedDate"] ?? "N/A",
//           roomType: item["roomType"] ?? "N/A",
//           imageUrl: item["image"],
//           title: item["title"],
//           price: item["price"],
//           status: item["status"],
//           onRepost: () {},
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
//
// import '../controller/seller_listing_controller.dart';
// import '../widget/property_card.dart';
//
// class SellerListingView extends GetView<SellerListingController> {
//   const SellerListingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SellerListingController());
//
//     return SafeArea(
//       child: DefaultTabController(
//         length: 3, // Residential tabs: Buy, Sell, Rent
//         child: Scaffold(
//           backgroundColor: ColorRes.white,
//
//           // appBar: AppBar(
//           //   title: const Text("My Listings"),
//           //   elevation: 0,
//           //   actions: [
//           //     TextButton.icon(
//           //       onPressed: () {
//           //         // TODO: Navigate to Add Listing screen
//           //       },
//           //       icon: const Icon(Icons.add, size: 20),
//           //       label: const Text("Add Listing"),
//           //       style: TextButton.styleFrom(
//           //         foregroundColor: ColorRes.primary,
//           //         padding: const EdgeInsets.symmetric(horizontal: 12),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           body: CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 pinned: false,
//                 snap: true,
//                 floating: true,
//                 expandedHeight: 160.0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("My Listings"),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.add, size: 20),
//                         label: Text("Add Listing"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // SliverToBoxAdapter(
//               //   child: Obx(() => Row(
//               //     mainAxisSize: MainAxisSize.min,
//               //     children: List.generate(2, (index) {
//               //       final isSelected = controller.isSelected[index];
//               //       return GestureDetector(
//               //         onTap: () => controller.toggle(index),
//               //         child: Container(...),
//               //       );
//               //     }),
//               //   )),
//               // ),
//               SliverFillRemaining(
//                 child: Column(
//                   children: [
//                     Obx(
//                       () => Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: List.generate(2, (index) {
//                           final isSelected = controller.isSelected[index];
//                           return GestureDetector(
//                             onTap: () => controller.toggle(index),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color:
//                                     isSelected
//                                         ? ColorRes.primary.withOpacity(0.1)
//                                         : Colors.transparent,
//                                 border: Border.all(
//                                   color:
//                                       isSelected
//                                           ? ColorRes.primary
//                                           : ColorRes.grey.withOpacity(0.3),
//                                 ),
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft:
//                                       index == 0
//                                           ? Radius.circular(AppRadius.medium)
//                                           : Radius.circular(0),
//                                   topLeft:
//                                       index == 0
//                                           ? Radius.circular(AppRadius.medium)
//                                           : Radius.circular(0),
//                                   bottomRight:
//                                       index != 0
//                                           ? Radius.circular(AppRadius.medium)
//                                           : Radius.circular(0),
//                                   topRight:
//                                       index != 0
//                                           ? Radius.circular(AppRadius.medium)
//                                           : Radius.circular(0),
//                                 ),
//                               ),
//                               child: Text(
//                                 index == 0 ? 'Residential' : 'Commercial',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color:
//                                       isSelected
//                                           ? ColorRes.primary
//                                           : Colors.black87,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//
//                     // 🔹 Show TabBar for Residential OR Commercial
//                     Obx(() {
//                       if (controller.isSelected[0]) {
//                         // ---------------- Residential ----------------
//                         return Expanded(
//                           child: Column(
//                             children: [
//                               const TabBar(
//                                 labelColor: Colors.black,
//                                 indicatorColor: ColorRes.primary,
//                                 unselectedLabelColor: Colors.grey,
//                                 indicatorSize: TabBarIndicatorSize.tab,
//                                 indicatorPadding: EdgeInsets.symmetric(
//                                   horizontal: AppPadding.medium,
//                                 ),
//                                 labelStyle: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: ColorRes.primary,
//                                 ),
//                                 tabs: [
//                                   Tab(text: "Buy"),
//                                   Tab(text: "Sell"),
//                                   Tab(text: "Rent"),
//                                 ],
//                               ),
//
//                               // 🔹 Filters Row
//                               _buildFilterRow(controller),
//
//                               // 🔹 Listings per Tab
//                               Expanded(
//                                 child: TabBarView(
//                                   children: [
//                                     _buildPropertyList(controller, "buy"),
//                                     _buildPropertyList(controller, "sell"),
//                                     _buildPropertyList(controller, "rent"),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       } else {
//                         // ---------------- Commercial ----------------
//                         return Expanded(
//                           child: DefaultTabController(
//                             length: 2, // Sell, Rent
//                             child: Column(
//                               children: [
//                                 const TabBar(
//                                   labelColor: Colors.black,
//                                   indicatorColor: ColorRes.primary,
//                                   unselectedLabelColor: Colors.grey,
//                                   indicatorSize: TabBarIndicatorSize.tab,
//                                   indicatorPadding: EdgeInsets.symmetric(
//                                     horizontal: AppPadding.medium,
//                                   ),
//                                   labelStyle: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: ColorRes.primary,
//                                   ),
//                                   tabs: [Tab(text: "Sell"), Tab(text: "Rent")],
//                                 ),
//
//                                 // 🔹 Filters Row
//                                 _buildFilterRow(controller),
//
//                                 // 🔹 Listings per Commercial Tab
//                                 Expanded(
//                                   child: TabBarView(
//                                     children: [
//                                       _buildCommercialList(controller, "sell"),
//                                       _buildCommercialList(controller, "rent"),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }
//                     }),
//                   ],
//                 ),
//               ),
//             ],
//             // child: Column(
//             //   children: [
//             //     Obx(
//             //       () => Row(
//             //         mainAxisSize: MainAxisSize.min,
//             //         children: List.generate(2, (index) {
//             //           final isSelected = controller.isSelected[index];
//             //           return GestureDetector(
//             //             onTap: () => controller.toggle(index),
//             //             child: Container(
//             //               padding: const EdgeInsets.symmetric(
//             //                 horizontal: 20,
//             //                 vertical: 10,
//             //               ),
//             //               decoration: BoxDecoration(
//             //                 color:
//             //                     isSelected
//             //                         ? ColorRes.primary.withOpacity(0.1)
//             //                         : Colors.transparent,
//             //                 border: Border.all(
//             //                   color:
//             //                       isSelected
//             //                           ? ColorRes.primary
//             //                           : ColorRes.grey.withOpacity(0.3),
//             //                 ),
//             //                 borderRadius: BorderRadius.only(
//             //                   bottomLeft:
//             //                       index == 0
//             //                           ? Radius.circular(AppRadius.medium)
//             //                           : Radius.circular(0),
//             //                   topLeft:
//             //                       index == 0
//             //                           ? Radius.circular(AppRadius.medium)
//             //                           : Radius.circular(0),
//             //                   bottomRight:
//             //                       index != 0
//             //                           ? Radius.circular(AppRadius.medium)
//             //                           : Radius.circular(0),
//             //                   topRight:
//             //                       index != 0
//             //                           ? Radius.circular(AppRadius.medium)
//             //                           : Radius.circular(0),
//             //                 ),
//             //               ),
//             //               child: Text(
//             //                 index == 0 ? 'Residential' : 'Commercial',
//             //                 style: TextStyle(
//             //                   fontSize: 14,
//             //                   fontWeight: FontWeight.w500,
//             //                   color:
//             //                       isSelected
//             //                           ? ColorRes.primary
//             //                           : Colors.black87,
//             //                 ),
//             //               ),
//             //             ),
//             //           );
//             //         }),
//             //       ),
//             //     ),
//             //
//             //     // 🔹 Show TabBar for Residential OR Commercial
//             //     Obx(() {
//             //       if (controller.isSelected[0]) {
//             //         // ---------------- Residential ----------------
//             //         return Expanded(
//             //           child: Column(
//             //             children: [
//             //               const TabBar(
//             //                 labelColor: Colors.black,
//             //                 indicatorColor: ColorRes.primary,
//             //                 unselectedLabelColor: Colors.grey,
//             //                 indicatorSize: TabBarIndicatorSize.tab,
//             //                 indicatorPadding: EdgeInsets.symmetric(
//             //                   horizontal: AppPadding.medium,
//             //                 ),
//             //                 labelStyle: TextStyle(
//             //                   fontSize: 14,
//             //                   fontWeight: FontWeight.w600,
//             //                   color: ColorRes.primary,
//             //                 ),
//             //                 tabs: [
//             //                   Tab(text: "Buy"),
//             //                   Tab(text: "Sell"),
//             //                   Tab(text: "Rent"),
//             //                 ],
//             //               ),
//             //
//             //               // 🔹 Filters Row
//             //               _buildFilterRow(controller),
//             //
//             //               // 🔹 Listings per Tab
//             //               Expanded(
//             //                 child: TabBarView(
//             //                   children: [
//             //                     _buildPropertyList(controller, "buy"),
//             //                     _buildPropertyList(controller, "sell"),
//             //                     _buildPropertyList(controller, "rent"),
//             //                   ],
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //         );
//             //       } else {
//             //         // ---------------- Commercial ----------------
//             //         return Expanded(
//             //           child: DefaultTabController(
//             //             length: 2, // Sell, Rent
//             //             child: Column(
//             //               children: [
//             //                 const TabBar(
//             //                   labelColor: Colors.black,
//             //                   indicatorColor: ColorRes.primary,
//             //                   unselectedLabelColor: Colors.grey,
//             //                   indicatorSize: TabBarIndicatorSize.tab,
//             //                   indicatorPadding: EdgeInsets.symmetric(
//             //                     horizontal: AppPadding.medium,
//             //                   ),
//             //                   labelStyle: TextStyle(
//             //                     fontSize: 14,
//             //                     fontWeight: FontWeight.w600,
//             //                     color: ColorRes.primary,
//             //                   ),
//             //                   tabs: [Tab(text: "Sell"), Tab(text: "Rent")],
//             //                 ),
//             //
//             //                 // 🔹 Filters Row
//             //                 _buildFilterRow(controller),
//             //
//             //                 // 🔹 Listings per Commercial Tab
//             //                 Expanded(
//             //                   child: TabBarView(
//             //                     children: [
//             //                       _buildCommercialList(controller, "sell"),
//             //                       _buildCommercialList(controller, "rent"),
//             //                     ],
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //           ),
//             //         );
//             //       }
//             //     }),
//             //   ],
//             // ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Filters Row Widget
//   Widget _buildFilterRow(SellerListingController controller) {
//     return SizedBox(
//       height: 60,
//       child: Obx(
//         () => ListView.separated(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           itemBuilder: (context, index) {
//             final isSelected =
//                 controller.selectedFilter.value ==
//                 controller.listingFilter[index];
//             return GestureDetector(
//               onTap: () {
//                 controller.selectedFilter.value =
//                     controller.listingFilter[index];
//                 controller.properties.refresh();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color:
//                         isSelected
//                             ? ColorRes.primary
//                             : ColorRes.grey.withOpacity(0.3),
//                   ),
//                   borderRadius: BorderRadius.circular(AppRadius.medium),
//                   color:
//                       isSelected
//                           ? ColorRes.primary.withOpacity(0.1)
//                           : Colors.transparent,
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12.0,
//                   horizontal: 16,
//                 ),
//                 alignment: Alignment.centerLeft,
//                 child: Text(controller.listingFilter[index]),
//               ),
//             );
//           },
//           separatorBuilder: (_, __) => const SizedBox(width: 8),
//           itemCount: controller.listingFilter.length,
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Residential List Builder
//   Widget _buildPropertyList(
//     SellerListingController controller,
//     String category,
//   ) {
//     final selectedStatus = controller.selectedFilter.value;
//
//     final filteredItems =
//         controller.properties.where((e) => e["category"] == category).toList();
//
//     final items =
//         selectedStatus == "All"
//             ? filteredItems
//             : filteredItems
//                 .where(
//                   (e) =>
//                       e["status"].toString().toLowerCase() ==
//                       selectedStatus.toString().toLowerCase(),
//                 )
//                 .toList();
//
//     if (items.isEmpty) {
//       return Center(child: Text("No $category listings"));
//     }
//
//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return PropertyListCard(
//           id: item["id"].toString(),
//           location: item["location"] ?? "Unknown Location",
//           lastAddedDate: item["lastAddedDate"] ?? "N/A",
//           roomType: item["roomType"] ?? "N/A",
//           imageUrl: item["image"],
//           title: item["title"],
//           price: item["price"],
//           status: item["status"],
//           onRepost: () {},
//         );
//       },
//     );
//   }
//
//   /// 🔹 Commercial List Builder
//   Widget _buildCommercialList(
//     SellerListingController controller,
//     String category,
//   ) {
//     final selectedStatus = controller.selectedFilter.value;
//
//     final filteredItems =
//         controller.properties.where((e) => e["category"] == category).toList();
//
//     final items =
//         selectedStatus == "All"
//             ? filteredItems
//             : filteredItems
//                 .where(
//                   (e) =>
//                       e["status"].toString().toLowerCase() ==
//                       selectedStatus.toString().toLowerCase(),
//                 )
//                 .toList();
//
//     if (items.isEmpty) {
//       return Center(child: Text("No Commercial $category listings"));
//     }
//
//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return PropertyListCard(
//           id: item["id"].toString(),
//           location: item["location"] ?? "Unknown Location",
//           lastAddedDate: item["lastAddedDate"] ?? "N/A",
//           roomType: item["roomType"] ?? "N/A",
//           imageUrl: item["image"],
//           title: item["title"],
//           price: item["price"],
//           status: item["status"],
//           onRepost: () {},
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
//
// import '../controller/seller_listing_controller.dart';
// import '../widget/property_card.dart';
//
// class SellerListingView extends GetView<SellerListingController> {
//   const SellerListingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorRes.white,
//         body: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) {
//             return [
//               SliverAppBar(
//                 pinned: false,
//                 snap: true,
//                 floating: true,
//                 // expandedHeight: 50,
//                 backgroundColor: ColorRes.white,
//                 elevation: 0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "My Listings",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//
//                       GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.add,
//                               size: 20,
//                               color: ColorRes.primary,
//                             ),
//                             Text(
//                               "Add Listing",
//                               style: TextStyle(
//                                 color: ColorRes.primary,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   titlePadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 16,
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: Column(
//             children: [
//               // Property Type Selector (Residential/Commercial)
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 child: Obx(
//                   () => Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(2, (index) {
//                       final isSelected = controller.isSelected[index];
//                       return GestureDetector(
//                         onTap: () => controller.toggle(index),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 isSelected
//                                     ? ColorRes.primary.withOpacity(0.1)
//                                     : Colors.transparent,
//                             border: Border.all(
//                               color:
//                                   isSelected
//                                       ? ColorRes.primary
//                                       : ColorRes.grey.withOpacity(0.3),
//                             ),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft:
//                                   index == 0
//                                       ? Radius.circular(AppRadius.medium)
//                                       : Radius.zero,
//                               topLeft:
//                                   index == 0
//                                       ? Radius.circular(AppRadius.medium)
//                                       : Radius.zero,
//                               bottomRight:
//                                   index != 0
//                                       ? Radius.circular(AppRadius.medium)
//                                       : Radius.zero,
//                               topRight:
//                                   index != 0
//                                       ? Radius.circular(AppRadius.medium)
//                                       : Radius.zero,
//                             ),
//                           ),
//                           child: Text(
//                             index == 0 ? 'Residential' : 'Commercial',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color:
//                                   isSelected
//                                       ? ColorRes.primary
//                                       : Colors.black87,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//
//               // TabBar and Content
//               Expanded(
//                 child: Obx(() {
//                   if (controller.isSelected[0]) {
//                     // Residential Section
//                     return DefaultTabController(
//                       length: 3,
//                       child: Column(
//                         children: [
//                           const TabBar(
//                             labelColor: ColorRes.primary,
//                             indicatorColor: ColorRes.primary,
//                             unselectedLabelColor: Colors.grey,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             indicatorPadding: EdgeInsets.symmetric(
//                               horizontal: AppPadding.medium,
//                             ),
//                             labelStyle: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             unselectedLabelStyle: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             tabs: [
//                               Tab(text: "Buy"),
//                               Tab(text: "Sell"),
//                               Tab(text: "Rent"),
//                             ],
//                           ),
//
//                           // Filters Row
//                           _buildFilterRow(controller),
//
//                           // Listings per Tab
//                           Expanded(
//                             child: TabBarView(
//                               children: [
//                                 _buildPropertyList(controller, "buy"),
//                                 _buildPropertyList(controller, "sell"),
//                                 _buildPropertyList(controller, "rent"),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     // Commercial Section
//                     return DefaultTabController(
//                       length: 2,
//                       child: Column(
//                         children: [
//                           const TabBar(
//                             labelColor: ColorRes.primary,
//                             indicatorColor: ColorRes.primary,
//                             unselectedLabelColor: Colors.grey,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             indicatorPadding: EdgeInsets.symmetric(
//                               horizontal: AppPadding.medium,
//                             ),
//                             labelStyle: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             unselectedLabelStyle: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             tabs: [Tab(text: "Sell"), Tab(text: "Rent")],
//                           ),
//
//                           // Filters Row
//                           _buildFilterRow(controller),
//
//                           // Listings per Commercial Tab
//                           Expanded(
//                             child: TabBarView(
//                               children: [
//                                 _buildCommercialList(controller, "sell"),
//                                 _buildCommercialList(controller, "rent"),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Filters Row Widget
//   Widget _buildFilterRow(SellerListingController controller) {
//     return SizedBox(
//       height: 60,
//       child: Obx(
//         () => ListView.separated(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           itemBuilder: (context, index) {
//             final isSelected =
//                 controller.selectedFilter.value ==
//                 controller.listingFilter[index];
//             return GestureDetector(
//               onTap: () {
//                 controller.selectedFilter.value =
//                     controller.listingFilter[index];
//                 controller.properties.refresh();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color:
//                         isSelected
//                             ? ColorRes.primary
//                             : ColorRes.grey.withOpacity(0.3),
//                   ),
//                   borderRadius: BorderRadius.circular(AppRadius.medium),
//                   color:
//                       isSelected
//                           ? ColorRes.primary.withOpacity(0.1)
//                           : Colors.transparent,
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12.0,
//                   horizontal: 16,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   controller.listingFilter[index],
//                   style: TextStyle(
//                     color: isSelected ? ColorRes.primary : Colors.black87,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             );
//           },
//           separatorBuilder: (_, __) => const SizedBox(width: 8),
//           itemCount: controller.listingFilter.length,
//         ),
//       ),
//     );
//   }
//
//   /// Residential List Builder
//   Widget _buildPropertyList(
//     SellerListingController controller,
//     String category,
//   ) {
//     return Obx(() {
//       final selectedStatus = controller.selectedFilter.value;
//
//       final filteredItems =
//           controller.properties
//               .where((e) => e["category"] == category)
//               .toList();
//
//       final items =
//           selectedStatus == "All"
//               ? filteredItems
//               : filteredItems
//                   .where(
//                     (e) =>
//                         e["status"].toString().toLowerCase() ==
//                         selectedStatus.toString().toLowerCase(),
//                   )
//                   .toList();
//
//       if (items.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.home_outlined, size: 64, color: Colors.grey[400]),
//               const SizedBox(height: 16),
//               Text(
//                 "No $category listings found",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return ListView.builder(
//         // padding: const EdgeInsets.all(16),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 2),
//             child: PropertyListCard(
//               id: item["id"]?.toString() ?? "",
//               location: item["location"] ?? "Unknown Location",
//               lastAddedDate: item["lastAddedDate"] ?? "N/A",
//               roomType: item["roomType"] ?? "N/A",
//               imageUrl: item["image"],
//               title: item["title"] ?? "No Title",
//               price: item["price"]?.toString() ?? "0",
//               status: item["status"]?.toString() ?? "Unknown",
//               onRepost: () {
//                 // Add repost logic here
//                 if (item["id"] != null) {
//                   // controller.repostProperty(item["id"]);
//                 }
//               },
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   /// Commercial List Builder
//   Widget _buildCommercialList(
//     SellerListingController controller,
//     String category,
//   ) {
//     return Obx(() {
//       final selectedStatus = controller.selectedFilter.value;
//
//       final filteredItems =
//           controller.properties
//               .where(
//                 (e) =>
//                     e["category"] == category &&
//                     (e["type"] == "commercial" ||
//                         e["propertyType"] == "commercial"),
//               )
//               .toList();
//
//       final items =
//           selectedStatus == "All"
//               ? filteredItems
//               : filteredItems
//                   .where(
//                     (e) =>
//                         e["status"].toString().toLowerCase() ==
//                         selectedStatus.toString().toLowerCase(),
//                   )
//                   .toList();
//
//       if (items.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.business_outlined, size: 64, color: Colors.grey[400]),
//               const SizedBox(height: 16),
//               Text(
//                 "No commercial $category listings found",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: PropertyListCard(
//               id: item["id"]?.toString() ?? "",
//               location: item["location"] ?? "Unknown Location",
//               lastAddedDate: item["lastAddedDate"] ?? "N/A",
//               roomType: item["roomType"] ?? "N/A",
//               imageUrl: item["image"],
//               title: item["title"] ?? "No Title",
//               price: item["price"]?.toString() ?? "0",
//               status: item["status"]?.toString() ?? "Unknown",
//               onRepost: () {
//                 // Add repost logic here
//                 if (item["id"] != null) {
//                   // controller.repostProperty(item["id"]);
//                 }
//               },
//             ),
//           );
//         },
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';

import '../controller/seller_listing_controller.dart';
import '../widget/property_card.dart';

class SellerListingView extends GetView<SellerListingController> {
  const SellerListingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(SellerListingController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorRes.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // SliverAppBar(
              //   pinned: false,
              //   snap: true,
              //   floating: true,
              //   expandedHeight: 160.0,
              //   backgroundColor: ColorRes.white,
              //   elevation: 0,
              //   flexibleSpace: FlexibleSpaceBar(
              //     title: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         const Text(
              //           "My Listings",
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         TextButton.icon(
              //           onPressed: () {
              //             // Add your navigation logic here
              //           },
              //           icon: const Icon(
              //             Icons.add,
              //             size: 20,
              //             color: ColorRes.primary,
              //           ),
              //           label: const Text(
              //             "Add Listing",
              //             style: TextStyle(color: ColorRes.primary),
              //           ),
              //         ),
              //       ],
              //     ),
              //     titlePadding: const EdgeInsets.symmetric(
              //       horizontal: 16,
              //       vertical: 16,
              //     ),
              //   ),
              // ),
              SliverAppBar(
                pinned: false,
                snap: true,
                floating: true,
                // expandedHeight: 50,
                backgroundColor: ColorRes.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Listings",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              size: 20,
                              color: ColorRes.primary,
                            ),
                            Text(
                              "Add Listing",
                              style: TextStyle(
                                color: ColorRes.primary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              // Property Type Selector (Residential/Commercial)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      final isSelected =
                          index < controller.isSelected.length
                              ? controller.isSelected[index]
                              : false;
                      return GestureDetector(
                        onTap: () => controller.toggle(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? ColorRes.primary.withOpacity(0.1)
                                    : Colors.transparent,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : ColorRes.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  index == 0
                                      ? Radius.circular(AppRadius.medium)
                                      : Radius.zero,
                              topLeft:
                                  index == 0
                                      ? Radius.circular(AppRadius.medium)
                                      : Radius.zero,
                              bottomRight:
                                  index != 0
                                      ? Radius.circular(AppRadius.medium)
                                      : Radius.zero,
                              topRight:
                                  index != 0
                                      ? Radius.circular(AppRadius.medium)
                                      : Radius.zero,
                            ),
                          ),
                          child: Text(
                            index == 0 ? 'Residential' : 'Commercial',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // TabBar and Content - wrapped in Expanded to prevent overflow
              Expanded(
                child: Obx(() {
                  // Safe check for isSelected list
                  if (controller.isSelected.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.isSelected.length > 0 &&
                      controller.isSelected[0]) {
                    // Residential Section
                    return DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: ColorRes.primary,
                            indicatorColor: ColorRes.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: EdgeInsets.symmetric(
                              horizontal: AppPadding.medium,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            tabs: [
                              Tab(text: "Buy"),
                              Tab(text: "Sell"),
                              Tab(text: "Rent"),
                            ],
                          ),

                          // Filters Row
                          _buildFilterRow(controller),

                          // Listings per Tab
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildPropertyList(controller, "buy"),
                                _buildPropertyList(controller, "sell"),
                                _buildPropertyList(controller, "rent"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Commercial Section
                    return DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: ColorRes.primary,
                            indicatorColor: ColorRes.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: EdgeInsets.symmetric(
                              horizontal: AppPadding.medium,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            tabs: [Tab(text: "Sell"), Tab(text: "Rent")],
                          ),

                          // Filters Row
                          _buildFilterRow(controller),

                          // Listings per Commercial Tab
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildCommercialList(controller, "sell"),
                                _buildCommercialList(controller, "rent"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Filters Row Widget
  Widget _buildFilterRow(SellerListingController controller) {
    return Container(
      height: 60,
      child: Obx(() {
        // Safe check for listingFilter
        if (controller.listingFilter.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemBuilder: (context, index) {
            final isSelected =
                controller.selectedFilter.value ==
                controller.listingFilter[index];
            return GestureDetector(
              onTap: () {
                controller.selectedFilter.value =
                    controller.listingFilter[index];
                controller.properties.refresh();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isSelected
                            ? ColorRes.primary
                            : ColorRes.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  color:
                      isSelected
                          ? ColorRes.primary.withOpacity(0.1)
                          : Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16,
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.listingFilter[index],
                  style: TextStyle(
                    color: isSelected ? ColorRes.primary : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: controller.listingFilter.length,
        );
      }),
    );
  }

  /// Residential List Builder
  Widget _buildPropertyList(
    SellerListingController controller,
    String category,
  ) {
    return Obx(() {
      // Safe check for controller properties
      if (controller.properties == null || controller.selectedFilter == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final selectedStatus = controller.selectedFilter.value;

      final filteredItems =
          controller.properties
              .where((e) => e["category"] == category)
              .toList();

      final items =
          selectedStatus == "All"
              ? filteredItems
              : filteredItems
                  .where(
                    (e) =>
                        e["status"].toString().toLowerCase() ==
                        selectedStatus.toString().toLowerCase(),
                  )
                  .toList();

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No $category listings found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        // padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: PropertyListCard(
              id: item["id"]?.toString() ?? "",
              location: item["location"] ?? "Unknown Location",
              lastAddedDate: item["lastAddedDate"] ?? "N/A",
              roomType: item["roomType"] ?? "N/A",
              imageUrl: item["image"],
              title: item["title"] ?? "No Title",
              price: item["price"]?.toString() ?? "0",
              status: item["status"]?.toString() ?? "Unknown",
              onRepost: () {
                // Add repost logic here
                if (item["id"] != null) {
                  // controller.repostProperty(item["id"]);
                }
              },
            ),
          );
        },
      );
    });
  }

  /// Commercial List Builder
  Widget _buildCommercialList(
    SellerListingController controller,
    String category,
  ) {
    return Obx(() {
      // Safe check for controller properties
      if (controller.properties == null || controller.selectedFilter == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final selectedStatus = controller.selectedFilter.value;

      final filteredItems =
          controller.properties
              .where(
                (e) => e["category"] == "commercial" && (e["type"] == category),
              )
              .toList();

      final items =
          selectedStatus == "All"
              ? filteredItems
              : filteredItems
                  .where(
                    (e) =>
                        e["status"].toString().toLowerCase() ==
                        selectedStatus.toString().toLowerCase(),
                  )
                  .toList();

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.business_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "No commercial $category listings found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        // padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: PropertyListCard(
              id: item["id"]?.toString() ?? "",
              location: item["location"] ?? "Unknown Location",
              lastAddedDate: item["lastAddedDate"] ?? "N/A",
              roomType: item["roomType"] ?? "N/A",
              imageUrl: item["image"],
              title: item["title"] ?? "No Title",
              price: item["price"]?.toString() ?? "0",
              status: item["status"]?.toString() ?? "Unknown",
              onRepost: () {
                // Add repost logic here
                if (item["id"] != null) {
                  // controller.repostProperty(item["id"]);
                }
              },
            ),
          );
        },
      );
    });
  }
}
