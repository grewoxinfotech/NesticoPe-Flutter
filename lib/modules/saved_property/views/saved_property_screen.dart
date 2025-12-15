// import 'package:flutter/material.dart';
//
// class SavedPropertyScreen extends StatelessWidget {
//   const SavedPropertyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4, // number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("My Properties"),
//           bottom: const TabBar(
//             isScrollable: true,
//             indicatorColor: Colors.blue,
//             labelColor: Colors.blue,
//             unselectedLabelColor: ColorRes.leadGreyColor,
//             tabs: [
//               Tab(text: "Saved Properties"),
//               Tab(text: "Seen Properties"),
//               Tab(text: "Contacted Properties"),
//               Tab(text: "Recent Searches"),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             // Tab 1 - Saved Properties
//             Center(child: Text("Saved Properties list here")),
//             // Tab 2 - Seen Properties
//             Center(child: Text("Seen Properties list here")),
//             // Tab 3 - Contacted Properties
//             Center(child: Text("Contacted Properties list here")),
//             // Tab 4 - Recent Searches
//             Center(child: Text("Recent Searches list here")),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/modules/property/views/widgets/property_list_screen_card.dart';
//
// import '../../../app/constants/img_res.dart';
// import '../../../data/network/property/models/property_model.dart';
//
// class SavedPropertyScreen extends StatefulWidget {
//   const SavedPropertyScreen({super.key});
//
//   @override
//   State<SavedPropertyScreen> createState() => _SavedPropertyScreenState();
// }
//
// class _SavedPropertyScreenState extends State<SavedPropertyScreen> {
//   int selectedIndex = 0;
//
//   final List<String> tabs = [
//     "Saved Properties",
//     "Seen Properties",
//     "Contacted Properties",
//     "Recent Searches",
//   ];
//
//   final List<String> tabsCount = ["00", "10", "05", "12"];
//
//   final List<IconData> tabsIcon = [
//     Icons.favorite_border_rounded,
//     Icons.visibility_outlined,
//     Icons.phone_outlined,
//     Icons.search_outlined,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text("My Properties")),
//       body: Column(
//         children: [
//           /// Buttons Row
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 8.0,
//               right: 8,
//               top: 30,
//               bottom: 8,
//             ),
//             child: Row(
//               children: List.generate(tabs.length, (index) {
//                 bool isSelected = selectedIndex == index;
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       margin: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color:
//                               isSelected ? ColorRes.primary : ColorRes.leadGreyColor[400]!,
//                           width: 1,
//                         ),
//                         // color: ColorRes.white,
//                         color:
//                             isSelected
//                                 ? ColorRes.primary.withOpacity(0.1)
//                                 : ColorRes.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       alignment: Alignment.center,
//                       child: Column(
//                         children: [
//                           Icon(
//                             tabsIcon[index],
//                             color: isSelected ? ColorRes.primary : Colors.black,
//                             size: 20,
//                           ),
//                           SizedBox(height: AppSpacing.small),
//                           Text(
//                             tabs[index],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color:
//                                   isSelected ? ColorRes.primary : Colors.black,
//                               // fontWeight:
//                               //     isSelected ? FontWeight.bold : FontWeight.normal,
//                             ),
//                           ),
//                           SizedBox(height: AppSpacing.small),
//
//                           Text(
//                             '(${tabsCount[index]})',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color:
//                                   isSelected ? ColorRes.primary : Colors.black,
//                               // fontWeight:
//                               //     isSelected ? FontWeight.bold : FontWeight.normal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//
//           /// Tab Content
//           Expanded(
//             child: IndexedStack(
//               index: selectedIndex,
//               children: const [
//                 SeenPropertiesTab(),
//                 Center(child: Text("Seen Properties list here")),
//                 Center(child: Text("Contacted Properties list here")),
//                 Center(child: Text("Recent Searches list here")),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SeenPropertiesTab extends StatelessWidget {
//   const SeenPropertiesTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Dummy data for now (replace with your property model later)
//     final List<String> seenProperties = [
//       "2 BHK Apartment in Mumbai",
//       "Luxury Villa in Goa",
//       "Studio Flat in Bangalore",
//       "3 BHK House in Delhi",
//       "Farmhouse in Pune",
//     ];
//
//     return ListView.separated(
//       padding: const EdgeInsets.all(12),
//       itemCount: seenProperties.length,
//       separatorBuilder: (context, index) => const Divider(),
//       itemBuilder: (context, index) {
//         final property = dummyItems[index];
//         return PropertyListScreenCard(items: property);
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:housing_flutter_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/property/views/widgets/property_list_screen_card.dart';
import 'package:housing_flutter_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:housing_flutter_app/modules/saved_property/views/widget/saved_property_card.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/img_res.dart';
import '../../../app/constants/size_manager.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../feedback/views/feedback_and_report.dart';
import '../../propert_detail/view/property_details.dart';
import '../../propert_detail/view/widget/property_card_widget.dart';
import '../../property/controllers/property_controller.dart';
import '../controllers/property_contacted_controller.dart';
import '../controllers/property_view_controller.dart';

//
class SavedPropertyScreen extends StatefulWidget {
  const SavedPropertyScreen({super.key});

  @override
  State<SavedPropertyScreen> createState() => _SavedPropertyScreenState();
}

class _SavedPropertyScreenState extends State<SavedPropertyScreen> {
  int selectedIndex = 0;

  final List<String> tabs = ["Saved", "Seen", "Contacted", "Recent"];
  final List<IconData> tabsIcon = [
    Icons.favorite_border_rounded,
    Icons.visibility_outlined,
    Icons.phone_outlined,
    Icons.search_outlined,
  ];

  // Controllers
  final PropertyViewController viewController = Get.put(
    PropertyViewController(),
  );
  final PropertyFavoriteController favoriteManager =
      Get.find<PropertyFavoriteController>();

  // final FavoriteManager favoriteManager = FavoriteManager();
  final PropertyContactedController contactedController = Get.put(
    PropertyContactedController(),
  );

  @override
  void initState() {
    super.initState();
    // Load seen properties once
    viewController.fetchViewedProperties();
    contactedController.fetchContactedProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Column(
        children: [
          /// Header Tabs
          Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 10,
                right: 10,
                bottom: 16,
              ),
              decoration: const BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Obx(() {
                // Reactive counts from GetX observables
                final savedCount = favoriteManager.favorites.length;
                final seenCount = viewController.viewedProperties.length;
                final contactedCount =
                    contactedController.contactedPropertyIds.length;
                final recentCount = 0; // TODO: link with recent searches

                final List<int> tabsCount = [
                  savedCount,
                  seenCount,
                  contactedCount,
                  recentCount,
                ];

                return Row(
                  children: List.generate(tabs.length, (index) {
                    final bool isSelected = selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                isSelected
                                    ? ColorRes.primary.withOpacity(0.15)
                                    : ColorRes.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : ColorRes.leadGreyColor[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                tabsIcon[index],
                                size: 20,
                                color:
                                    isSelected
                                        ? ColorRes.primary
                                        : ColorRes.blackShade54,
                              ),
                              Text(
                                tabs[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  color:
                                      isSelected
                                          ? ColorRes.primary
                                          : ColorRes.blackShade87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "(${tabsCount[index]})",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  color:
                                      isSelected
                                          ? ColorRes.primary
                                          : ColorRes.blackShade87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),

          /// Tab Content
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: const [
                SavedPropertiesTab(),
                SeenPropertiesTab(),
                ContactedPropertiesTab(),
                RecentSearchesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SeenPropertiesTab extends StatefulWidget {
  const SeenPropertiesTab({super.key});

  @override
  State<SeenPropertiesTab> createState() => _SeenPropertiesTabState();
}

class _SeenPropertiesTabState extends State<SeenPropertiesTab> {
  final PropertyViewController controller = Get.put(PropertyViewController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(() {
        if (controller.isLoading.value && controller.viewedProperties.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.viewedProperties.isEmpty) {
          return const Center(
            child: Text(
              "No viewed properties yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // detect when user reaches near the bottom
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 100 &&
                !controller.isLoadingMore.value &&
                controller.currentIndex < controller.viewedProperties.length) {
              // controller.loadNextBatch();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.fetchViewedProperties,
            color: ColorRes.primary,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount:
                  controller.viewedProperties.length +
                  (controller.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < controller.viewedProperties.length) {
                  final property = controller.viewedProperties[index];
                  log("Most View ${property.toJson()}");
                  return Obx(() {
                    final PropertyFavoriteController favoriteController =
                        Get.find<PropertyFavoriteController>();

                    final isFavorite = favoriteController.favorites.contains(
                      property.details.id,
                    );

                    // Calculate days ago
                    int? daysAgo;
                    if (property.viewedAt != null) {
                      final difference = DateTime.now().difference(
                        property.viewedAt!,
                      );
                      daysAgo = difference.inDays;
                    }

                    // Format price based on entity type
                    String formattedPrice = '';
                    if (property.entityType == 'property') {
                      // For properties - format monthly rent or sale price
                      final price = property.details.price;
                      if (price != null) {
                        formattedPrice = Formatter.formatPrice(price);
                      }
                    } else {
                      // For projects - format price range
                      final range = property.details.priceRange;
                      if (range != null) {
                        final minPrice = range.minPrice;
                        final maxPrice = range.maxPrice;

                        if (minPrice == maxPrice) {
                          formattedPrice = Formatter.formatPrice(minPrice);
                        } else {
                          formattedPrice =
                              '${Formatter.formatPrice(minPrice)} - ${Formatter.formatNumber(maxPrice)}';
                        }
                      } else {
                        formattedPrice = 'Price on Request';
                      }
                    }

                    // Property type display
                    String? displayPropertyType;
                    String? displayBhk;

                    if (property.entityType == 'project') {
                      displayPropertyType = property.details.projectName;
                      displayBhk =
                          property.details.propertyTypes?.toUpperCase();
                    } else {
                      displayPropertyType =
                          property.details.propertyType?.toUpperCase();
                      displayBhk = property.details.propertyType?.toUpperCase();
                    }

                    // Location formatting
                    String displayLocation = property.details.location ?? '';
                    if (property.details.city != null &&
                        property.details.city!.isNotEmpty) {
                      if (displayLocation.isNotEmpty) {
                        displayLocation = '${property.details.city}';
                      } else {
                        displayLocation = property.details.city!;
                      }
                    }

                    return HorizontalPropertyCard(
                      // Image
                      imageUrl: property.details.images ?? '',

                      // Basic info
                      isForRent: property.details.listingType == 'Rent',
                      location: property.details.location ?? '',
                      price: formattedPrice,

                      // Entity type and names
                      entityType: property.entityType,
                      projectName: property.details.projectName,
                      propertyType: displayPropertyType,

                      // Listing details
                      listingType: property.details.listingType,
                      priceType: property.details.priceType,
                      status: property.details.status,
                      city: property.details.city,

                      // Verification and timing
                      isVerified: property.details.status == 'approved',
                      postedDaysAgo: daysAgo,

                      // Actions
                      isFavorite: isFavorite,
                      onTap: () {
                        if (property.entityType == "property") {
                          Get.to(
                            () => PropertyDetailScreen(
                              propertyId: property.details.id,
                            ),
                          );
                        } else {
                          Get.to(
                            () => ProjectDetailsScreen(
                              projectId: property.details.id,
                            ),
                          );
                        }
                      },
                      onFavoritePressed: () {
                        favoriteController.toggleFavorite(property.details.id);
                      },
                      onContactPressed: () async {
                        generateInquiry(property.details.id);
                      },
                    );
                  });
                } else {
                  // loader at bottom when loading next batch
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class SavedPropertiesTab extends StatefulWidget {
  const SavedPropertiesTab({super.key});

  @override
  State<SavedPropertiesTab> createState() => _SavedPropertiesTabState();
}

class _SavedPropertiesTabState extends State<SavedPropertiesTab> {
  final controller = Get.find<PropertyController>();
  final manager = Get.find<PropertyFavoriteController>();

  // final RxList<Items> favoriteProperties = <Items>[].obs;

  @override
  void initState() {
    super.initState();
    // loadFavorite();
    manager.loadData();
    // Listen to favorite changes globally
    // ever(manager.favorites, (_) => loadFavorite());
  }

  // Future<void> loadFavorite() async {
  //   favoriteProperties.assignAll(
  //     manager.items.where((item) => manager.favorites.contains(item.id)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(() {
        if (manager.isLoading.value && manager.favorites.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!manager.isLoading.value && manager.favorites.isEmpty) {
          return const Center(child: Text("No Property found."));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshList();
            await manager.loadData();
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: AppPadding.small,
              horizontal: AppPadding.small,
            ),
            itemCount:
                (manager.favoriteResponse.value?.data?.favorite.length) ?? 0,
            itemBuilder: (context, index) {
              final property =
                  manager.favoriteResponse.value!.data!.favorite[index];

              return GestureDetector(
                onTap: () {
                  if (property.entityType == "property") {
                    // Property Screen
                    Get.to(
                      () =>
                          PropertyDetailScreen(propertyId: property.details.id),
                    );
                  } else {
                    // Project Screen
                    Get.to(
                      () =>
                          ProjectDetailsScreen(projectId: property.details.id),
                    );
                  }
                },
                child: Obx(() {
                  final PropertyFavoriteController favoriteController =
                      Get.find<PropertyFavoriteController>();

                  final isFavorite = favoriteController.favorites.contains(
                    property.details.id,
                  );

                  // Format price based on entity type
                  String formattedPrice = '';
                  if (property.entityType == 'property') {
                    // For properties - format monthly rent or sale price
                    final price = property.details.price;
                    if (price != null) {
                      // Crore
                      formattedPrice = Formatter.formatPrice(price);
                    }
                  } else {
                    // For projects - format price range
                    final range = property.details.priceRange;
                    if (range != null) {
                      final minPrice = range.minPrice;
                      final maxPrice = range.maxPrice;

                      if (minPrice == maxPrice) {
                        formattedPrice = Formatter.formatPrice(minPrice);
                      } else {
                        formattedPrice =
                            '${Formatter.formatPrice(minPrice)} - ${Formatter.formatNumber(maxPrice)}';
                      }
                    } else {
                      formattedPrice = 'Price on Request';
                    }
                  }

                  // Property type display
                  String? displayPropertyType;
                  String? displayBhk;

                  if (property.entityType == 'project') {
                    displayPropertyType = property.details.projectName;
                    displayBhk = property.details.propertyTypes?.toUpperCase();
                  } else {
                    displayPropertyType =
                        property.details.propertyType?.toUpperCase();
                    displayBhk = property.details.propertyType?.toUpperCase();
                  }

                  // Location formatting
                  String displayLocation = property.details.location ?? '';
                  if (property.details.city != null &&
                      property.details.city!.isNotEmpty) {
                    if (displayLocation.isNotEmpty) {
                      displayLocation = '${property.details.city}';
                    } else {
                      displayLocation = property.details.city!;
                    }
                  }
                  return HorizontalPropertyCard(
                    // Image
                    imageUrl: property.details.images ?? '',

                    // Basic info
                    isForRent: property.details.listingType == 'Rent',
                    location: property.details.location ?? '',
                    price: formattedPrice,

                    // Entity type and names
                    entityType: property.entityType,
                    projectName: property.details.projectName,
                    propertyType: displayPropertyType,

                    // Listing details
                    listingType: property.details.listingType,
                    priceType: property.details.priceType,
                    status: property.details.status,
                    city: property.details.city,

                    // Verification and timing
                    isVerified: property.details.status == 'approved',

                    // Actions
                    isFavorite: isFavorite,
                    onTap: () {
                      if (property.entityType == "property") {
                        Get.to(
                          () => PropertyDetailScreen(
                            propertyId: property.details.id,
                          ),
                        );
                      } else {
                        Get.to(
                          () => ProjectDetailsScreen(
                            projectId: property.details.id,
                          ),
                        );
                      }
                    },
                    onFavoritePressed: () {
                      favoriteController.toggleFavorite(property.details.id);
                    },
                    onContactPressed: () async {
                      generateInquiry(property.details.id);
                    },
                  );
                }),
              );
            },
          ),
        );
      }),
    );
  }
}

class ContactedPropertiesTab extends StatefulWidget {
  const ContactedPropertiesTab({super.key});

  @override
  State<ContactedPropertiesTab> createState() => _ContactedPropertiesTabState();
}

class _ContactedPropertiesTabState extends State<ContactedPropertiesTab> {
  final PropertyContactedController controller = Get.put(
    PropertyContactedController(),
  );

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   top: false,
    //   child: Obx(() {
    //     // 🌀 Show loading spinner initially
    //     if (controller.isLoading.value && controller.properties.isEmpty) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //
    //     // ❌ Empty state
    //     if (controller.properties.isEmpty) {
    //       return const Center(
    //         child: Text(
    //           "No contacted properties yet",
    //           style: TextStyle(fontSize: 16, color: Colors.grey),
    //         ),
    //       );
    //     }
    //
    //     // ✅ Property List with lazy loading
    //     return NotificationListener<ScrollNotification>(
    //       onNotification: (ScrollNotification scrollInfo) {
    //         // Detect scroll near bottom
    //         if (scrollInfo.metrics.pixels >=
    //                 scrollInfo.metrics.maxScrollExtent - 100 &&
    //             !controller.isLoadingMore.value &&
    //             controller.currentIndex <
    //                 controller.contactedPropertyIds.length) {
    //           controller.loadNextBatch();
    //         }
    //         return false;
    //       },
    //       child: RefreshIndicator(
    //         onRefresh: controller.fetchContactedProperties,
    //         color: ColorRes.primary,
    //         child: ListView.builder(
    //           physics: const AlwaysScrollableScrollPhysics(),
    //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    //           itemCount:
    //               controller.properties.length +
    //               (controller.isLoadingMore.value ? 1 : 0),
    //           itemBuilder: (context, index) {
    //             if (index < controller.properties.length) {
    //               final Items property = controller.properties[index];
    //               return PropertyCardWidget(
    //                 property: property,
    //                 role: "",
    //                 isFeedbackEnabled: true,
    //               );
    //             } else {
    //               // Loader at bottom
    //               return const Padding(
    //                 padding: EdgeInsets.all(16.0),
    //                 child: Center(child: CircularProgressIndicator()),
    //               );
    //             }
    //           },
    //         ),
    //       ),
    //     );
    //   }),
    // );
    return SafeArea(
      top: false,
      child: Obx(() {
        if (controller.isLoading.value && controller.inquiries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isLoading.value && controller.inquiries.isEmpty) {
          return const Center(
            child: Text(
              "No viewed properties yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // detect when user reaches near the bottom
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 100 &&
                !controller.isLoadingMore.value &&
                controller.currentIndex < controller.inquiries.length) {
              // controller.loadNextBatch();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.fetchContactedProperties,
            color: ColorRes.primary,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount:
                  controller.inquiries.length +
                  (controller.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < controller.inquiries.length) {
                  final property = controller.inquiries[index];
                  log("Most View ${property.toJson()}");
                  return Obx(() {
                    final PropertyFavoriteController favoriteController =
                        Get.find<PropertyFavoriteController>();

                    final isFavorite = favoriteController.favorites.contains(
                      property.details?.id,
                    );

                    // Calculate days ago
                    int? daysAgo;
                    if (property.inquiredAt != null) {
                      final difference = DateTime.now().difference(
                        property.inquiredAt!,
                      );
                      daysAgo = difference.inDays;
                    }

                    // Format price based on entity type
                    String formattedPrice = '';
                    if (property.entityType == 'property') {
                      // For properties - format monthly rent or sale price
                      final price = property.details?.price;
                      if (price != null) {
                        formattedPrice = Formatter.formatPrice(price);
                      }
                    } else {
                      // For projects - format price range
                      final range = property.details?.priceRange;
                      if (range != null) {
                        final minPrice = range.minPrice;
                        final maxPrice = range.maxPrice;

                        if (minPrice == maxPrice) {
                          formattedPrice = Formatter.formatPrice(minPrice);
                        } else {
                          formattedPrice =
                              '${Formatter.formatPrice(minPrice)} - ${Formatter.formatNumber(maxPrice)}';
                        }
                      } else {
                        formattedPrice = 'Price on Request';
                      }
                    }

                    // Property type display
                    String? displayPropertyType;
                    String? displayBhk;

                    if (property.entityType == 'project') {
                      displayPropertyType = property.details?.projectName;
                      displayBhk =
                          property.details?.propertyTypes?.toUpperCase();
                    } else {
                      displayPropertyType =
                          property.details?.propertyType?.toUpperCase();
                      displayBhk =
                          property.details?.propertyType?.toUpperCase();
                    }

                    // Location formatting
                    String displayLocation = property.details?.location ?? '';
                    if (property.details?.city != null &&
                        property.details!.city!.isNotEmpty) {
                      if (displayLocation.isNotEmpty) {
                        displayLocation = '${property.details?.city}';
                      } else {
                        displayLocation = property.details!.city!;
                      }
                    }

                    return HorizontalPropertyCard(
                      // Image
                      imageUrl: property.details?.images ?? '',

                      // Basic info
                      isForRent: property.details?.listingType == 'Rent',
                      location: property.details?.location ?? '',
                      price: formattedPrice,

                      // Entity type and names
                      entityType: property.entityType,
                      projectName: property.details?.projectName,
                      propertyType: displayPropertyType,

                      // Listing details
                      listingType: property.details?.listingType,
                      priceType: property.details?.priceType,
                      status: property.details?.status,
                      city: property.details?.city,

                      // Verification and timing
                      isVerified: property.details?.status == 'approved',
                      postedDaysAgo: daysAgo,

                      // Actions
                      isFavorite: isFavorite,
                      onTap: () {
                        if (property.entityType == "property") {
                          Get.to(
                            () => PropertyDetailScreen(
                              propertyId: property.details?.id,
                            ),
                          );
                        } else {
                          Get.to(
                            () => ProjectDetailsScreen(
                              projectId: property.details?.id,
                            ),
                          );
                        }
                      },
                      onFavoritePressed: () {
                        favoriteController.toggleFavorite(
                          property.details?.id ?? '',
                        );
                      },

                      ifFeedbackEnable: true,
                      onFeedbackPressed: () {
                        Get.to(
                          () => FeedBackAndReportScreen(
                            propertyId: property.details?.id ?? '',
                          ),
                          transition: Transition.cupertino,
                        );
                      },
                    );
                  });
                } else {
                  // loader at bottom when loading next batch
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class RecentSearchesTab extends StatelessWidget {
  const RecentSearchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Recent Searches will appear here"));
  }
}

Future<void> generateInquiry(String propertyId) async {
  if (UserHelper.isGuest) {
    Get.to(() => LoginScreen());
  } else {
    final user = await SecureStorage.getUserData();
    final inquiry = {
      "name": user?.user?.username ?? "",
      "phone": user?.user?.phone ?? "",
      "email": user?.user?.email ?? "",
    };
    final PropertyContactedController contactedCtrl =
        Get.isRegistered<PropertyContactedController>()
            ? Get.find<PropertyContactedController>()
            : Get.put(PropertyContactedController());
    contactedCtrl.addInquiry(inquiry, propertyId);
  }
}
