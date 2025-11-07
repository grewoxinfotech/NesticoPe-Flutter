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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/property/views/widgets/property_list_screen_card.dart';
import 'package:housing_flutter_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:housing_flutter_app/modules/saved_property/views/widget/saved_property_card.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/img_res.dart';
import '../../../app/constants/size_manager.dart';
import '../../../data/network/property/models/property_model.dart';
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
                  return GestureDetector(
                    onTap: () {
                      if (property.entityType == "property") {
                        // Property Screen
                        Get.to(
                          () => PropertyDetailScreen(
                            propertyId: property.details.id,
                          ),
                        );
                      } else {
                        // Project Screen
                        Get.to(
                          () => ProjectDetailsScreen(
                            projectId: property.details.id,
                          ),
                        );
                      }
                    },
                    child: Obx(() {
                      final PropertyFavoriteController favoriteController =
                          Get.find<PropertyFavoriteController>();

                      final isFavorite = favoriteController.favorites.contains(
                        property.details.id,
                      );
                      return SavedPropertyCard(
                        imageUrl: property.details.images ?? '',
                        isForRent: property.details.listingType == 'Rent',
                        location: property.details.location ?? '',
                        price: property.displayPrice,
                        isFavorite: isFavorite,
                      );
                    }),
                  );
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
            itemCount: manager.favoriteResponse.value!.data!.favorite.length,
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
                  return SavedPropertyCard(
                    imageUrl: property.details.images ?? '',
                    isForRent: property.details.listingType == 'Rent',
                    location: property.details.location ?? '',
                    price: property.displayPrice,
                    isFavorite: isFavorite,
                    onFavoritePressed: () {
                      final PropertyFavoriteController favoriteController =
                          Get.find<PropertyFavoriteController>();
                      favoriteController.toggleFavorite(property.details.id);
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

// class ContactedPropertiesTab extends StatelessWidget {
//   const ContactedPropertiesTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Contacted Properties will appear here"));
//   }
// }

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
    return SafeArea(
      top: false,
      child: Obx(() {
        // 🌀 Show loading spinner initially
        if (controller.isLoading.value && controller.properties.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ Empty state
        if (controller.properties.isEmpty) {
          return const Center(
            child: Text(
              "No contacted properties yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // ✅ Property List with lazy loading
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Detect scroll near bottom
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 100 &&
                !controller.isLoadingMore.value &&
                controller.currentIndex <
                    controller.contactedPropertyIds.length) {
              controller.loadNextBatch();
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
                  controller.properties.length +
                  (controller.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < controller.properties.length) {
                  final Items property = controller.properties[index];
                  return PropertyCardWidget(
                    property: property,
                    role: "",
                    isFeedbackEnabled: true,
                  );
                } else {
                  // Loader at bottom
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

List<Items> dummyItems = [
  Items(
    id: "1",
    title: "Luxury Apartment in Vesu",
    type: "Residential",
    listingType: "Sale",
    propertyMedia: PropertyMedia(images: [IMGRes.home1, IMGRes.home2]),
    propertyType: "Apartment",
    propertyDescription: "3 BHK luxury apartment with modern amenities.",
    keywords: ["3BHK", "Luxury", "Apartment"],
    propertyDetails: PropertyDetails(
      bhk: 3,
      balcony: 2,
      bathroom: 3,
      amenities: ["Gym", "Swimming Pool", "Club House"],
      propertyCarpetArea: 1250,
      propertyBuiltUpArea: 1450,
      floorInfo: FloorInfo(floorNumber: 5, totalFloors: 12),
      furnishInfo: FurnishInfo(
        furnishType: "Semi-Furnished",
        furnishDetails: FurnishDetails(
          modularKitchen: true,
          wardrobes: true,
          acInstalled: false,
        ),
      ),
      // parkingInfo: ParkingInfo(covered: 1, open: 1),
      // financialInfo: FinancialInfo(price: 6500000, maintenance: 2500),
      possessionInfo: PossessionInfo(
        possessionStatus: "Ready to Move",
        propertyAgeInYear: "2025-12-01",
      ),
    ),
    address: "Vesu Main Road",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395007",
    nearbyLocations: [
      NearbyLocations(name: "School", distance: 1.2),
      NearbyLocations(name: "Hospital", distance: 2.0),
    ],
    builderName: "ABC Builders",
    projectName: "Skyline Residency",
    ownerName: "Rahul Mehta",
    ownerPhone: "9876543210",
    ownerEmail: "rahul@example.com",
    isVerified: true,
    totalViews: 120,
    totalInquiries: 18,
    totalFavorites: 8,
    totalShares: 2,
    createdAt: "2025-08-01",
    updatedAt: "2025-08-10",
  ),

  Items(
    id: "2",
    title: "Affordable 2BHK in Adajan",
    type: "Residential",
    listingType: "Rent",
    propertyType: "Flat",
    propertyDescription: "Spacious 2BHK at prime location.",
    keywords: ["2BHK", "Affordable", "Rent"],
    propertyMedia: PropertyMedia(images: [IMGRes.home3, IMGRes.home4]),

    propertyDetails: PropertyDetails(
      bhk: 2,
      balcony: 1,
      bathroom: 2,
      amenities: ["Lift", "Security"],
      propertyCarpetArea: 950,
      propertyBuiltUpArea: 1100,
      floorInfo: FloorInfo(floorNumber: 3, totalFloors: 10),
      furnishInfo: FurnishInfo(
        furnishType: "Furnished",
        furnishDetails: FurnishDetails(
          modularKitchen: true,
          wardrobes: true,
          acInstalled: true,
        ),
      ),
      // parkingInfo: ParkingInfo(covered: 0, open: 1),
      // financialInfo: FinancialInfo(price: 15000, maintenance: 1000),
      possessionInfo: PossessionInfo(
        possessionStatus: "Immediate",
        propertyAgeInYear: "2025-09-01",
      ),
    ),
    address: "Adajan Road",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395009",
    builderName: "XYZ Developers",
    projectName: "Green Residency",
    ownerName: "Priya Shah",
    ownerPhone: "9988776655",
    ownerEmail: "priya@example.com",
    isVerified: true,
    totalViews: 90,
    totalInquiries: 12,
    totalFavorites: 4,
    createdAt: "2025-08-05",
    updatedAt: "2025-08-15",
  ),

  Items(
    id: "3",
    title: "Commercial Shop in Ring Road",
    type: "Commercial",
    listingType: "Sale",
    propertyType: "Shop",
    propertyDescription: "Prime commercial shop ideal for offices/retail.",
    keywords: ["Shop", "Commercial", "Prime Location"],
    propertyMedia: PropertyMedia(images: [IMGRes.banner1, IMGRes.banner2]),

    propertyDetails: PropertyDetails(
      bhk: 0,
      balcony: 0,
      bathroom: 1,
      amenities: ["Power Backup"],
      propertyCarpetArea: 400,
      propertyBuiltUpArea: 450,
      // financialInfo: FinancialInfo(price: 3200000, maintenance: 800),
    ),
    address: "Ring Road",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395002",
    builderName: "Surat Developers",
    ownerName: "Ketan Patel",
    ownerPhone: "9123456789",
    isVerified: false,
    totalViews: 60,
    totalInquiries: 8,
  ),

  Items(
    id: "4",
    title: "4BHK Villa in Piplod",
    type: "Residential",
    listingType: "Sale",
    propertyType: "Villa",
    propertyDescription: "Luxurious villa with private garden and parking.",
    keywords: ["Villa", "Luxury", "Garden"],
    propertyMedia: PropertyMedia(images: [IMGRes.plot1, IMGRes.plot2]),

    propertyDetails: PropertyDetails(
      bhk: 4,
      balcony: 3,
      bathroom: 4,
      amenities: ["Garden", "Private Parking", "CCTV"],
      propertyCarpetArea: 2000,
      propertyBuiltUpArea: 2500,
      // financialInfo: FinancialInfo(price: 15000000, maintenance: 0),
    ),
    address: "Piplod",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395007",
    builderName: "Elite Builders",
    ownerName: "Sunita Desai",
    ownerPhone: "9898989898",
    isVerified: true,
    totalViews: 220,
    totalInquiries: 30,
    totalFavorites: 15,
  ),

  Items(
    id: "5",
    title: "Office Space in City Light",
    type: "Commercial",
    listingType: "Rent",
    propertyType: "Office",
    propertyDescription: "Fully furnished office space with 20 workstations.",
    keywords: ["Office", "Commercial", "Furnished"],
    propertyMedia: PropertyMedia(images: [IMGRes.home2, IMGRes.home1]),
    propertyDetails: PropertyDetails(
      amenities: ["AC", "Lift", "Security"],
      propertyCarpetArea: 1200,
      // financialInfo: FinancialInfo(price: 50000, maintenance: 3000),
    ),
    address: "City Light",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395007",
    builderName: "Smart Developers",
    ownerName: "Amit Jain",
    ownerPhone: "9876001234",
    isVerified: false,
    totalViews: 75,
    totalInquiries: 10,
  ),

  Items(
    id: "6",
    title: "1BHK Studio Apartment",
    type: "Residential",
    listingType: "Rent",
    propertyType: "Studio",
    propertyDescription: "Compact studio perfect for bachelors.",
    keywords: ["Studio", "1BHK", "Affordable"],
    propertyMedia: PropertyMedia(images: [IMGRes.home4, IMGRes.home2]),

    propertyDetails: PropertyDetails(
      bhk: 1,
      bathroom: 1,
      propertyCarpetArea: 450,
      // financialInfo: FinancialInfo(price: 8000, maintenance: 500),
    ),
    address: "Pal",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395009",
    ownerName: "Ramesh Gupta",
    ownerPhone: "9825001122",
    isVerified: true,
    totalViews: 40,
    totalInquiries: 5,
  ),

  Items(
    id: "7",
    title: "Warehouse in Kadodara",
    type: "Commercial",
    listingType: "Sale",
    propertyType: "Warehouse",
    propertyDescription: "Spacious warehouse with easy highway access.",
    keywords: ["Warehouse", "Commercial"],
    propertyMedia: PropertyMedia(images: [IMGRes.banner2, IMGRes.home2]),

    propertyDetails: PropertyDetails(
      propertyBuiltUpArea: 5000,
      // financialInfo: FinancialInfo(price: 20000000, maintenance: 0),
    ),
    address: "Kadodara",
    city: "Surat",
    state: "Gujarat",
    zipCode: "394325",
    ownerName: "Manoj Yadav",
    ownerPhone: "9812345678",
    isVerified: false,
    totalViews: 30,
    totalInquiries: 3,
  ),

  Items(
    id: "8",
    title: "Plot in Dumas",
    type: "Residential",
    listingType: "Sale",
    propertyType: "Plot",
    propertyDescription: "Open NA plot near beach.",
    keywords: ["Plot", "Residential"],
    propertyMedia: PropertyMedia(images: [IMGRes.home1, IMGRes.home2]),

    propertyDetails: PropertyDetails(
      propertyBuiltUpArea: 1800,
      // financialInfo: FinancialInfo(price: 3000000, maintenance: 0),
    ),
    address: "Dumas Road",
    city: "Surat",
    state: "Gujarat",
    zipCode: "394550",
    ownerName: "Vishal Patel",
    ownerPhone: "9876541200",
    isVerified: true,
    totalViews: 100,
    totalInquiries: 14,
  ),

  Items(
    id: "9",
    title: "Penthouse in Vesu",
    type: "Residential",
    listingType: "Sale",
    propertyType: "Penthouse",
    propertyDescription: "5BHK penthouse with terrace & pool.",
    keywords: ["Penthouse", "Luxury", "Terrace"],
    propertyMedia: PropertyMedia(images: [IMGRes.home1, IMGRes.home2]),

    propertyDetails: PropertyDetails(
      bhk: 5,
      balcony: 4,
      bathroom: 5,
      propertyBuiltUpArea: 4000,
      // financialInfo: FinancialInfo(price: 30000000, maintenance: 5000),
    ),
    address: "Vesu",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395007",
    ownerName: "Rohit Shah",
    ownerPhone: "9000090000",
    isVerified: true,
    totalViews: 500,
    totalInquiries: 40,
    totalFavorites: 25,
  ),

  Items(
    id: "10",
    title: "Row House in Palanpur",
    type: "Residential",
    listingType: "Sale",
    propertyType: "Row House",
    propertyDescription: "3BHK row house with parking & terrace.",
    keywords: ["Row House", "3BHK"],
    propertyMedia: PropertyMedia(images: [IMGRes.home1, IMGRes.home2]),

    propertyDetails: PropertyDetails(
      bhk: 3,
      balcony: 2,
      bathroom: 3,
      propertyBuiltUpArea: 1600,
      // financialInfo: FinancialInfo(price: 8500000, maintenance: 1000),
    ),
    address: "Palanpur",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395005",
    ownerName: "Anjali Verma",
    ownerPhone: "9911223344",
    isVerified: false,
    totalViews: 80,
    totalInquiries: 9,
  ),
];

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
//   final List<String> tabs = ["Saved", "Seen", "Contacted", "Recent"];
//   final List<String> tabsCount = ["00", "10", "05", "12"];
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
//       backgroundColor: ColorRes.leadGreyColor[100],
//       body: Column(
//         children: [
//           /// Header
//           Container(
//             padding: const EdgeInsets.only(
//               top: 50,
//               left: 16,
//               right: 16,
//               bottom: 20,
//             ),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.8)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: const BorderRadius.vertical(
//                 bottom: Radius.circular(24),
//               ),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 8,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   "My Properties",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: ColorRes.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 /// Custom pill selector
//                 Container(
//                   height: 52,
//                   decoration: BoxDecoration(
//                     color: ColorRes.white,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     children: List.generate(tabs.length, (index) {
//                       final isSelected = selectedIndex == index;
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () => setState(() => selectedIndex = index),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 250),
//                             margin: const EdgeInsets.symmetric(
//                               vertical: 6,
//                               horizontal: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color:
//                                   isSelected
//                                       ? ColorRes.primary.withOpacity(0.1)
//                                       : Colors.transparent,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Icon(
//                                 //   tabsIcon[index],
//                                 //   size: 18,
//                                 //   color: isSelected
//                                 //       ? ColorRes.primary
//                                 //       : Colors.black54,
//                                 // ),
//                                 // const SizedBox(height: 2),
//                                 Text(
//                                   tabs[index],
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight:
//                                         isSelected
//                                             ? AppFontWeights.semiBold
//                                             : FontWeight.normal,
//                                     color:
//                                         isSelected
//                                             ? ColorRes.primary
//                                             : Colors.black87,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// Tab Content
//           Expanded(
//             child: IndexedStack(
//               index: selectedIndex,
//               children: const [
//                 SavedPropertiesTab(),
//                 SeenPropertiesTab(),
//                 ContactedPropertiesTab(),
//                 RecentSearchesTab(),
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
//     return RefreshIndicator(
//       onRefresh: () async {
//         await Future.delayed(const Duration(seconds: 1));
//       },
//       child: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: dummyItems.length,
//         separatorBuilder: (context, index) => const SizedBox(height: 14),
//         itemBuilder: (context, index) {
//           final property = dummyItems[index];
//           return PropertyListScreenCard(items: property);
//         },
//       ),
//     );
//   }
// }
//
// class SavedPropertiesTab extends StatelessWidget {
//   const SavedPropertiesTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const _EmptyState(
//       icon: Icons.favorite_border_rounded,
//       message: "Saved Properties will appear here",
//     );
//   }
// }
//
// class ContactedPropertiesTab extends StatelessWidget {
//   const ContactedPropertiesTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const _EmptyState(
//       icon: Icons.phone_outlined,
//       message: "Contacted Properties will appear here",
//     );
//   }
// }
//
// class RecentSearchesTab extends StatelessWidget {
//   const RecentSearchesTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const _EmptyState(
//       icon: Icons.search_outlined,
//       message: "Recent Searches will appear here",
//     );
//   }
// }
//
// class _EmptyState extends StatelessWidget {
//   final IconData icon;
//   final String message;
//   const _EmptyState({required this.icon, required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 60, color: ColorRes.leadGreyColor[400]),
//           const SizedBox(height: 12),
//           Text(
//             message,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.black54,
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
