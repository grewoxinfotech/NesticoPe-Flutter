import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';

import 'package:housing_flutter_app/modules/propert_detail/view/widget/property_card_widget.dart';

import '../../../data/network/property/models/property_model.dart';

import '../../property/controllers/property_controller.dart';

class PropertyDetail extends StatelessWidget {
  List<Map<String, String>>? filters;
  final bool isAppBarShow;
  final Color backgroundColor;
  final PropertyController controller = Get.find<PropertyController>();
  // final PropertyController controller = Get.put(PropertyController());

  final List<Map<String, dynamic>> properties = [
    {
      'title': 'The White Abode',
      'imageUrl': 'https://picsum.photos/400/200',
      'location': '33, Laxmi Palace, S V Road, Near...',
      'role': ' Developer',
      'price': 'Rs. 8,00,000',
      'apartments': [
        {'bhk': '2 BHK Apartment', 'priceRange': '50 L - 1.2 Cr'},
        {'bhk': '4 BHK Apartment', 'priceRange': '92 L - 1.5 Cr'},
        {'bhk': '5 BHK Apartment', 'priceRange': '2.5 Cr - 3.2 Cr'},
      ],
      'beds': 4,
      'baths': 4,
      'area': 874,
      'ownerName': 'James Aldeio',
      'ownerAvatar': 'https://i.pravatar.cc/150?img=3',
      'images': [
        'https://picsum.photos/seed/white1/600/400',
        'https://picsum.photos/seed/white2/600/400',
        'https://picsum.photos/seed/white3/600/400',
      ],
    },
    {
      'title': 'Sunset Villa',
      'imageUrl': 'https://picsum.photos/401/200',
      'location': 'Palm Street, Ocean View',
      'price': 'Rs. 12,50,000',
      'role': ' Agents',
      'beds': 5,
      'apartments': [
        {'bhk': '2 BHK Apartment', 'priceRange': '50 L - 1.2 Cr'},
        {'bhk': '4 BHK Apartment', 'priceRange': '92 L - 1.5 Cr'},
      ],
      'baths': 3,
      'area': 1200,
      'ownerName': 'Sophia Turner',
      'ownerAvatar': 'https://i.pravatar.cc/150?img=5',
      'images': [
        'https://picsum.photos/seed/villa1/600/400',
        'https://picsum.photos/seed/villa2/600/400',
        'https://picsum.photos/seed/villa3/600/400',
        'https://picsum.photos/seed/villa4/600/400',
      ],
    },
    {
      'title': 'City Heights',
      'imageUrl': 'https://picsum.photos/402/200',
      'location': 'Metro Plaza, Downtown',
      'price': 'Rs. 6,75,000',
      'beds': 3,
      'baths': 2,
      'role': ' Owner',
      'area': 690,
      'apartments': [
        {'bhk': '2 BHK Apartment', 'priceRange': '50 L - 1.2 Cr'},
      ],
      'ownerName': 'David Smith',
      'ownerAvatar': 'https://i.pravatar.cc/150?img=7',
      'images': [
        'https://picsum.photos/seed/city1/600/400',
        'https://picsum.photos/seed/city2/600/400',
        'https://picsum.photos/seed/city3/600/400',
      ],
    },
  ];
  RxMap<String, String> selectedFilters = <String, String>{}.obs;

  PropertyDetail({
    super.key,
    this.isAppBarShow = true,
    this.backgroundColor = ColorRes.white,
    this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          isAppBarShow
              ? AppBar(
                elevation: 0,
                backgroundColor: ColorRes.white,
                leading: GestureDetector(
                  onTap: () {
                    controller.filters = null;
                    controller.loadInitial();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: ColorRes.textColor,
                  ),
                ),
                title: const Text(
                  "Property List",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorRes.textColor,
                  ),
                ),
                actions: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Get.to<Map<String, String>>(
                                () => RealEstateFilterScreen(
                                  initialFilters: selectedFilters,
                                ),
                                transition: Transition.rightToLeft,
                              );
                              if (result != null) {
                                selectedFilters.clear();
                                selectedFilters.addAll(result);
                                controller.applyFilters(selectedFilters);
                              }
                            },
                            child: const Icon(
                              Icons.filter_list,
                              color: ColorRes.textColor,
                            ),
                          ),
                          if (selectedFilters.isNotEmpty)
                            Positioned(
                              top: 10,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: ColorRes.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${selectedFilters.length}',
                                  style: const TextStyle(
                                    color: ColorRes.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                // bottom:
                //     selectedFilters.isEmpty
                //         ? PreferredSize(
                //           preferredSize: const Size.fromHeight(0),
                //           child: SizedBox.shrink(),
                //         )
                //         : PreferredSize(
                //           preferredSize: const Size.fromHeight(50),
                //           child: Obx(() {
                //             if (selectedFilters.isEmpty)
                //               return const SizedBox.shrink();
                //
                //             return Container(
                //               padding: const EdgeInsets.symmetric(
                //                 horizontal: 12,
                //                 vertical: 8,
                //               ),
                //               width: double.infinity,
                //               decoration: BoxDecoration(
                //                 color: ColorRes.white,
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.black.withOpacity(0.05),
                //                     blurRadius: 2,
                //                   ),
                //                 ],
                //               ),
                //               child: SingleChildScrollView(
                //                 scrollDirection: Axis.horizontal,
                //                 child: Row(
                //                   children: [
                //                     if (selectedFilters.isNotEmpty)
                //                       GestureDetector(
                //                         onTap: () {
                //                           selectedFilters.clear();
                //                           controller.applyFilters(
                //                             selectedFilters,
                //                           );
                //                         },
                //                         child: Container(
                //                           margin: const EdgeInsets.only(
                //                             right: 8,
                //                           ),
                //                           padding: const EdgeInsets.symmetric(
                //                             horizontal: 10,
                //                             vertical: 6,
                //                           ),
                //                           decoration: BoxDecoration(
                //                             color: ColorRes.primary.withOpacity(
                //                               0.1,
                //                             ),
                //                             borderRadius: BorderRadius.circular(
                //                               8,
                //                             ),
                //                             border: Border.all(
                //                               color: ColorRes.primary
                //                                   .withOpacity(0.3),
                //                             ),
                //                           ),
                //                           child: const Row(
                //                             mainAxisSize: MainAxisSize.min,
                //                             children: [
                //                               Text(
                //                                 "Clear All",
                //                                 style: TextStyle(
                //                                   fontSize: 12,
                //                                   color: ColorRes.primary,
                //                                   fontWeight: FontWeight.w500,
                //                                 ),
                //                               ),
                //                               SizedBox(width: 4),
                //                               Icon(
                //                                 Icons.close,
                //                                 size: 16,
                //                                 color: ColorRes.primary,
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       ),
                //                     ...selectedFilters.entries.map((entry) {
                //                       final key = entry.key;
                //                       final value = entry.value;
                //
                //                       if (value == null ||
                //                           (value is String &&
                //                               value.trim().isEmpty) ||
                //                           (value is Map && value.isEmpty)) {
                //                         return const SizedBox.shrink();
                //                       }
                //
                //                       return Container(
                //                         margin: const EdgeInsets.only(right: 8),
                //                         padding: const EdgeInsets.symmetric(
                //                           horizontal: 10,
                //                           vertical: 6,
                //                         ),
                //                         decoration: BoxDecoration(
                //                           color: ColorRes.primary.withOpacity(
                //                             0.1,
                //                           ),
                //                           borderRadius: BorderRadius.circular(
                //                             8,
                //                           ),
                //                           border: Border.all(
                //                             color: ColorRes.primary.withOpacity(
                //                               0.3,
                //                             ),
                //                           ),
                //                         ),
                //                         child: Row(
                //                           mainAxisSize: MainAxisSize.min,
                //                           children: [
                //                             Text(
                //                               "$key: $value",
                //                               style: const TextStyle(
                //                                 fontSize: 12,
                //                                 color: ColorRes.primary,
                //                                 fontWeight: FontWeight.w500,
                //                               ),
                //                             ),
                //                             const SizedBox(width: 6),
                //                             GestureDetector(
                //                               onTap: () {
                //                                 selectedFilters.remove(key);
                //                                 controller.applyFilters(
                //                                   selectedFilters,
                //                                 );
                //                               },
                //                               child: const Icon(
                //                                 Icons.close,
                //                                 size: 16,
                //                                 color: ColorRes.primary,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       );
                //                     }).toList(),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           }),
                //         ),
              )
              : null,
      // body: Obx(() {
      //   if (controller.isLoading.value && controller.items.isEmpty) {
      //     return const Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           CircularProgressIndicator(),
      //           SizedBox(height: 16),
      //           Text(
      //             "Loading properties...",
      //             style: TextStyle(color: ColorRes.textColor, fontSize: 14),
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      //
      //   if (controller.isLoading.value) {
      //     return Stack(
      //       children: [
      //         ListView.builder(
      //           padding: const EdgeInsets.symmetric(
      //             vertical: AppPadding.small,
      //             horizontal: AppPadding.small,
      //           ),
      //           itemCount: controller.items.length,
      //           itemBuilder: (context, index) {
      //             final property = properties[index % properties.length];
      //             final data = controller.items[index];
      //             return PropertyCardWidget(
      //               property: data,
      //               role: property['role'],
      //             );
      //           },
      //         ),
      //         Positioned.fill(
      //           child: Container(
      //             color: ColorRes.white.withOpacity(0.7),
      //             child: const Center(child: CircularProgressIndicator()),
      //           ),
      //         ),
      //       ],
      //     );
      //   }
      //
      //   if (!controller.isLoading.value && controller.items.isEmpty) {
      //     return Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Icon(
      //             Icons.search_off_rounded,
      //             size: 64,
      //             color: ColorRes.primary,
      //           ),
      //           const SizedBox(height: 16),
      //           const Text(
      //             "No properties found",
      //             style: TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.w600,
      //               color: ColorRes.textColor,
      //             ),
      //           ),
      //           const SizedBox(height: 8),
      //           Text(
      //             selectedFilters.isEmpty
      //                 ? "Try adjusting your search criteria"
      //                 : "Try removing some filters",
      //             style: TextStyle(
      //               fontSize: 14,
      //               color: ColorRes.textColor.withOpacity(0.7),
      //             ),
      //           ),
      //           if (selectedFilters.isNotEmpty) ...[
      //             const SizedBox(height: 24),
      //             ElevatedButton(
      //               onPressed: () {
      //                 selectedFilters.clear();
      //                 controller.applyFilters(selectedFilters);
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: ColorRes.primary,
      //                 foregroundColor: ColorRes.white,
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 24,
      //                   vertical: 12,
      //                 ),
      //               ),
      //               child: const Text("Clear All Filters"),
      //             ),
      //           ],
      //         ],
      //       ),
      //     );
      //   }
      //
      //   return NotificationListener<ScrollNotification>(
      //     onNotification: (scrollEnd) {
      //       final metrics = scrollEnd.metrics;
      //       if (metrics.atEdge && metrics.pixels != 0) {
      //         controller.loadMore();
      //       }
      //       return false;
      //     },
      //     child: RefreshIndicator(
      //       onRefresh: controller.refreshList,
      //       child: ListView.builder(
      //         padding: const EdgeInsets.symmetric(
      //           vertical: AppPadding.small,
      //           horizontal: AppPadding.small,
      //         ),
      //         itemCount: controller.items.length,
      //         itemBuilder: (context, index) {
      //           final property = properties[index % properties.length];
      //           final data = controller.items[index];
      //           return PropertyCardWidget(
      //             property: data,
      //             role: property['role'],
      //           );
      //         },
      //       ),
      //     ),
      //   );
      // }),

      body: Column(
        children: [
          // 🔹 Fixed Filter Bar at Top of Body
          Obx(() {
            if (selectedFilters.isEmpty) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorRes.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectedFilters.clear();
                        controller.applyFilters(selectedFilters);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.primary.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Clear All",
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorRes.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.close,
                              size: 16,
                              color: ColorRes.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...selectedFilters.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value;
                      if (value.trim().isEmpty) return const SizedBox.shrink();

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorRes.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$key: $value",
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorRes.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                selectedFilters.remove(key);
                                controller.applyFilters(selectedFilters);
                              },
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: ColorRes.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }),

          // 🔹 Property List Below Filter Bar
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        "Loading properties...",
                        style: TextStyle(color: ColorRes.textColor, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              if (!controller.isLoading.value && controller.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: ColorRes.primary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No properties found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorRes.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedFilters.isEmpty
                            ? "Try adjusting your search criteria"
                            : "Try removing some filters",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorRes.textColor.withOpacity(0.7),
                        ),
                      ),
                      if (selectedFilters.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            selectedFilters.clear();
                            controller.applyFilters(selectedFilters);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            foregroundColor: ColorRes.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text("Clear All Filters"),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge && metrics.pixels != 0) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: controller.refreshList,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.small,
                      horizontal: AppPadding.small,
                    ),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final property = properties[index % properties.length];
                      final data = controller.items[index];
                      return PropertyCardWidget(
                        property: data,
                        role: property['role'],
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),

    );
  }
}
