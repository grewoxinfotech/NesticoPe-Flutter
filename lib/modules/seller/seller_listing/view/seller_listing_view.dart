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
    final controller = Get.put(SellerListingController());

    return SafeArea(
      child: DefaultTabController(
        length: 3, // Buy, Sell, Rent
        child: Scaffold(
          backgroundColor: ColorRes.white,
          appBar: AppBar(
            title: const Text("My Listings"),
            elevation: 0,
            actions: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to Add Listing screen
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text("Add Listing"),
                style: TextButton.styleFrom(
                  foregroundColor: ColorRes.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
          ),

          body: Column(
            children: [
              // 🔹 ToggleButtons
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Obx(
                      () => ToggleButtons(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    fillColor: ColorRes.primary.withOpacity(0.1),
                    selectedColor: ColorRes.primary,
                    color: Colors.black87,
                    borderColor: ColorRes.grey.withOpacity(0.3),
                    selectedBorderColor: ColorRes.primary,
                    constraints:
                    const BoxConstraints(minHeight: 40, minWidth: 120),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      Text('Residential'),
                      Text('Commercial'),
                    ],
                    isSelected: controller.isSelected,
                    onPressed: (index) => controller.toggle(index),
                  ),
                ),
              ),

              // 🔹 Show TabBar ONLY if Residential is selected
              Obx(() {
                if (controller.isSelected[0]) {
                  // Residential selected
                  // return Expanded(
                  //   child: Column(
                  //     children: [
                  //       const TabBar(
                  //         labelColor: Colors.black,
                  //         indicatorColor: ColorRes.primary,
                  //         splashBorderRadius: BorderRadius.only(
                  //           topLeft: Radius.circular(AppRadius.medium),
                  //           topRight: Radius.circular(AppRadius.medium),
                  //         ),
                  //         indicatorSize: TabBarIndicatorSize.tab,
                  //         indicatorPadding: EdgeInsets.symmetric(
                  //             horizontal: AppPadding.medium),
                  //         unselectedLabelColor: Colors.grey,
                  //         labelStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           color: ColorRes.primary
                  //         ),
                  //
                  //         tabs: [
                  //           Tab(text: "Buy"),
                  //           Tab(text: "Sell"),
                  //           Tab(text: "Rent"),
                  //         ],
                  //       ),
                  //       Expanded(
                  //         child: TabBarView(
                  //           children: [
                  //             _buildPropertyList(controller, "buy"),
                  //             _buildPropertyList(controller, "sell"),
                  //             _buildPropertyList(controller, "rent"),
                  //           ],
                  //         ),
                  //       ),
                  //
                  //       SingleChildScrollView(
                  //         child: Row(
                  //           children: [
                  //             ...List.generate(controller.listingFilter.length, (index) {
                  //               return Padding(
                  //                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
                  //                     borderRadius: BorderRadius.circular(AppRadius.medium),
                  //                   ),
                  //                   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                  //                   alignment: Alignment.centerLeft,
                  //
                  //                   child: Text(controller.listingFilter[index]),
                  //                 ),
                  //               );
                  //             })
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  //
                  // );

                  // inside Residential section
                  return Expanded(
                    child: Column(
                      children: [
                        // TabBar (Buy, Sell, Rent)
                        const TabBar(
                          labelColor: Colors.black,
                          indicatorColor: ColorRes.primary,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorRes.primary,
                          ),
                          tabs: [
                            Tab(text: "Buy"),
                            Tab(text: "Sell"),
                            Tab(text: "Rent"),
                          ],
                        ),

                        // Filters Row
                        SizedBox(
                          height: 60,
                          child: Obx(() => ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            itemBuilder: (context, index) {
                              final isSelected = controller.selectedFilter.value == controller.listingFilter[index];
                              return GestureDetector(
                                onTap: (){
                                  controller.selectedFilter.value = controller.listingFilter[index];
                                  // Trigger UI update by filtering properties
                                  controller.properties.refresh();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color:isSelected ? ColorRes.primary : ColorRes.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(AppRadius.medium),
                                    color: isSelected ? ColorRes.primary.withOpacity(0.1) : Colors.transparent,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(controller.listingFilter[index]),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemCount: controller.listingFilter.length,
                          )),
                        ),

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
                  // Commercial selected
                  return Expanded(
                    child: Obx(() {
                      final items = controller.properties
                          .where((e) => e["category"] == "commercial")
                          .toList();
                      if (items.isEmpty) {
                        return const Center(
                          child: Text("No Commercial listings"),
                        );
                      }
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return PropertyListCard(
                            id: item["id"].toString(),
                            location: item["location"] ?? "Unknown Location",
                            lastAddedDate: item["lastAddedDate"] ?? "N/A",
                            roomType: item["roomType"] ?? "N/A",
                            imageUrl: item["image"],
                            title: item["title"],
                            price: item["price"],
                            status: item["status"],
                            onRepost: (){},
                          );
                        },
                      );
                    }),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget to build filtered property lists
  Widget _buildPropertyList(
      SellerListingController controller, String category) {

    // Get the currently selected filter (status)
    final selectedStatus = controller.selectedFilter.value;

    // Filter by category first
    final filteredItems = controller.properties.where((e) => e["category"] == category).toList();

    // Then filter by status if not "All"
    final items = selectedStatus == "All"
        ? filteredItems
        : filteredItems.where((e) => e["status"].toString().toLowerCase() == selectedStatus.toString().toLowerCase()).toList();

    if (items.isEmpty) {
      return Center(child: Text("No $category listings"));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PropertyListCard(
          id: item["id"].toString(),
          location: item["location"] ?? "Unknown Location",
          lastAddedDate: item["lastAddedDate"] ?? "N/A",
          roomType: item["roomType"] ?? "N/A",
          imageUrl: item["image"],
          title: item["title"],
          price: item["price"],
          status: item["status"],
          onRepost: () {},
        );
      },
    );
  }

}
