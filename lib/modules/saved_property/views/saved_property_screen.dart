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
//             unselectedLabelColor: Colors.grey,
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
//                               isSelected ? ColorRes.primary : Colors.grey[400]!,
//                           width: 1,
//                         ),
//                         // color: ColorRes.white,
//                         color:
//                             isSelected
//                                 ? ColorRes.primary.withOpacity(0.1)
//                                 : Colors.white,
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
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/property/views/widgets/property_list_screen_card.dart';

import '../../../app/constants/img_res.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../propert_detail/view/property_details.dart';

//
class SavedPropertyScreen extends StatefulWidget {
  const SavedPropertyScreen({super.key});

  @override
  State<SavedPropertyScreen> createState() => _SavedPropertyScreenState();
}

class _SavedPropertyScreenState extends State<SavedPropertyScreen> {
  int selectedIndex = 0;

  final List<String> tabs = ["Saved", "Seen", "Contacted", "Recent"];

  final List<String> tabsCount = ["00", "10", "05", "12"];

  final List<IconData> tabsIcon = [
    Icons.favorite_border_rounded,
    Icons.visibility_outlined,
    Icons.phone_outlined,
    Icons.search_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          /// Custom Header
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 10,
              right: 10,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              children: List.generate(tabs.length, (index) {
                bool isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      // duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isSelected
                                ? ColorRes.primary.withOpacity(0.15)
                                : Colors.white,
                        border: Border.all(
                          color:
                              isSelected ? ColorRes.primary : Colors.grey[300]!,
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
                                isSelected ? ColorRes.primary : Colors.black54,
                          ),
                          // SizedBox(height: AppSpacing.small),
                          Text(
                            "${tabs[index]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              // fontWeight:
                              //     isSelected
                              //         ? FontWeight.w600
                              //         : FontWeight.normal,
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "(${tabsCount[index]})",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected
                                      ? ColorRes.primary
                                      : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

class SeenPropertiesTab extends StatelessWidget {
  const SeenPropertiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PropertyDetail(),
      // child: RefreshIndicator(
      //   onRefresh: () async {
      //     await Future.delayed(const Duration(seconds: 1));
      //   },
      //   child: ListView.separated(
      //     padding: const EdgeInsets.all(12),
      //     itemCount: dummyItems.length,
      //     separatorBuilder: (context, index) => const SizedBox(height: 12),
      //     itemBuilder: (context, index) {
      //       final property = dummyItems[index];
      //       return PropertyListScreenCard(items: property);
      //     },
      //   ),
      // ),
    );
  }
}

class SavedPropertiesTab extends StatelessWidget {
  const SavedPropertiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Saved Properties will appear here"));
  }
}

class ContactedPropertiesTab extends StatelessWidget {
  const ContactedPropertiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Contacted Properties will appear here"));
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
      parkingInfo: ParkingInfo(covered: 1, open: 1),
      financialInfo: FinancialInfo(price: 6500000, maintenance: 2500),
      possessionInfo: PossessionInfo(
        possessionStatus: "Ready to Move",
        possessionDate: "2025-12-01",
      ),
    ),
    address: "Vesu Main Road",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395007",
    location: Location(latitude: 21.1702, longitude: 72.8311),
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
      parkingInfo: ParkingInfo(covered: 0, open: 1),
      financialInfo: FinancialInfo(price: 15000, maintenance: 1000),
      possessionInfo: PossessionInfo(
        possessionStatus: "Immediate",
        possessionDate: "2025-09-01",
      ),
    ),
    address: "Adajan Road",
    city: "Surat",
    state: "Gujarat",
    zipCode: "395009",
    location: Location(latitude: 21.2, longitude: 72.85),
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
      financialInfo: FinancialInfo(price: 3200000, maintenance: 800),
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
      financialInfo: FinancialInfo(price: 15000000, maintenance: 0),
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
      financialInfo: FinancialInfo(price: 50000, maintenance: 3000),
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
      financialInfo: FinancialInfo(price: 8000, maintenance: 500),
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
      financialInfo: FinancialInfo(price: 20000000, maintenance: 0),
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
      financialInfo: FinancialInfo(price: 3000000, maintenance: 0),
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
      financialInfo: FinancialInfo(price: 30000000, maintenance: 5000),
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
      financialInfo: FinancialInfo(price: 8500000, maintenance: 1000),
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
//       backgroundColor: Colors.grey[100],
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
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 /// Custom pill selector
//                 Container(
//                   height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
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
//                                             ? FontWeight.w600
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
//           Icon(icon, size: 60, color: Colors.grey[400]),
//           const SizedBox(height: 12),
//           Text(
//             message,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.black54,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
