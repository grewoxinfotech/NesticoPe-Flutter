import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/app/manager/property_highlight_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/cards/banner_card_with_text.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/app/widgets/texts/headline_text.dart';
import 'package:housing_flutter_app/app/widgets/texts/title_with_disc.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/data/network/trending_area/model/trending_area_model.dart';
import 'package:housing_flutter_app/modules/builder/controller/builder_form_controller.dart';
import 'package:housing_flutter_app/modules/builder/view/all_project_list_screen.dart';
import 'package:housing_flutter_app/modules/contractor/controller/top_contractor_service_category_controller.dart';

//import 'package:housing_flutter_app/modules/home/controllers/home_controller/home_controller.dart';
import 'package:housing_flutter_app/modules/home/widgets/city_card.dart';
import 'package:housing_flutter_app/modules/home/widgets/contractor_profile_card.dart';
import 'package:housing_flutter_app/modules/home/widgets/home_header.dart';
import 'package:housing_flutter_app/modules/home/widgets/top_locations.dart';
import 'package:housing_flutter_app/modules/new_project/view/latest_project.dart';
import 'package:housing_flutter_app/modules/news/controllers/news_controller.dart';
import 'package:housing_flutter_app/modules/platform_service/controllers/platform_service_controller.dart';
import 'package:housing_flutter_app/modules/propert_detail/view/property_details.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/property/controllers/recommended_property_controller.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/property/views/property_list_screen.dart';

// import 'package:housing_flutter_app/modules/property/views/recommended.dart';

import 'package:housing_flutter_app/modules/property_rating/view/top_rated_property.dart';
import 'package:housing_flutter_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
import 'package:housing_flutter_app/modules/seller/view/seller_profile.dart'
    hide PropertyCard;
import 'package:housing_flutter_app/modules/seller/view/widget/seller_list.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../app/manager/compare_manager.dart' show CompareManager;
import '../../../../app/manager/project_compare_manager.dart';
import '../../../../app/utils/file_upload_section/file_upload_section.dart';

import '../../../../app/utils/validation.dart';
import '../../../../app/widgets/mic_search/search_mic.dart';
import '../../../../app/widgets/shimmer/shimmer_widget.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/input/city_selection_widget.dart';
import '../../../add_property/view/create_property.dart';
import '../../../profile/controllers/buyer_profiledata.dart';
import '../../../property/controllers/share_property_controller.dart';
import '../../../search_property/controller/search_controller.dart';
import '../../../search_property/model/search_model.dart';
import '../../controllers/contractor_profile_controller/contractor_profile_controller.dart';
import '../../widgets/top_categories_section.dart';
import '../../widgets/unified_comparison_floating_button.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../../../data/network/news/news_model.dart';
import '../../../../data/network/platform_review/model/platform_review_model.dart';
import '../../../../widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../builder/view/builder_form_screen.dart';
import '../../../builder/view/builder_main_screen.dart';
import '../../../builder/view/builder_property_listing.dart';
import '../../../builder/view/project_detail/project_detail.dart';
import '../../../dashboard/views/dashboard_screen.dart';
import '../../../filter_property/controller/property_filter_controller.dart';
import '../../../news/view/news_detail_screen.dart';
import '../../../other/trending_city/controllers/trending_city_controller.dart';
import '../../../platform_service/views/widgets/platform_service_card.dart';
import '../../../property/views/widgets/city_filter.dart';
import '../../../property/views/widgets/top_property_card.dart';
import '../../../property/views/widgets/property_card.dart';
import '../../../reseller/view/property_reseller.dart';
import '../../../review/controllers/review_controller.dart';
import '../../../top_seller/controller/top_seller_controller.dart';
import '../../controllers/home_controller/platform_review-controller.dart';

// import '../../widgets/property_comparison_floating_button.dart';
//
// class HomeScreen extends StatefulWidget {
//   final controller = Get.put(() => AuthController());
//
//   final List<Map<String, String>> propertyTypes;
//
//   HomeScreen({
//     super.key,
//     this.propertyTypes = const [
//       {
//         "title": "Apartment",
//         "image":
//             "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=600&q=80",
//       },
//       // {
//       //   "title": "Independent House",
//       //   "image":
//       //       "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=600&q=80",
//       // },
//       // {
//       //   "title": "Duplex",
//       //   "image":
//       //       "https://images.unsplash.com/photo-1613977257363-707ba9348227?auto=format&fit=crop&w=600&q=80",
//       // },
//       {
//         "title": "Villa",
//         "image":
//             "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=600&q=80",
//       },
//       {
//         "title": "Plot",
//         "image":
//             "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=600&q=80",
//       },
//       // {
//       //   "title": "Agricultural Land",
//       //   "image":
//       //       "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=600&q=80",
//       // },
//       {
//         "title": "Office",
//         "image":
//             "https://img.etimg.com/thumb/width-1200,height-1200,imgsize-76402,resizemode-75,msid-111456711/industry/services/property-/-cstruction/india-office-property-market-surges-with-record-gross-leasing-in-2024-first-half.jpg",
//       },
//
//       {
//         "title": "Retail Shop",
//         "image":
//             "https://5.imimg.com/data5/XH/NE/SW/SELLER-48886426/shop-for-sale-in-jaipur-commercial.jpg",
//       },
//       {
//         "title": "Showroom",
//         "image":
//             "https://www.99acres.com/microsite/articles/files/2022/08/showroom.jpg",
//       },
//       {
//         "title": "Warehouse",
//         "image":
//             "https://3.imimg.com/data3/SR/MV/MY-12088584/warehouses-for-sale-500x500.jpg",
//       },
//       {
//         "title": "Other",
//         "image":
//             "https://www.ashwinshethgroup.com/wp-content/uploads/2022/11/Commercial-property-buying-guidelines-1400x700-1.webp",
//       },
//     ],
//   });
//
//   static final List<String> images = [
//     IMGRes.home1,
//     IMGRes.home2,
//     IMGRes.home3,
//     IMGRes.home4,
//   ];
//   static final List<String> banners = [
//     IMGRes.project_1,
//     IMGRes.project_2,
//     IMGRes.project_3,
//     IMGRes.project_4,
//     IMGRes.project_5,
//     IMGRes.project_6,
//     IMGRes.project_1,
//   ];
//
//   // static final List<String> shops = [
//   //   IMGRes.shop1,
//   //   IMGRes.shop2,
//   //   IMGRes.shop3,
//   //   IMGRes.shop4,
//   // ];
//   static final List<Map<String, dynamic>> shops = [
//     {
//       "image": IMGRes.shop1,
//       "name": "Retail Space",
//       "opacity": Color(0xFFFDF6E4),
//     }, // light cream
//     {
//       "image": IMGRes.shop2,
//       "name": "Office Space",
//       "opacity": Color(0xFFE4F4FD),
//     }, // light blue
//     {
//       "image": IMGRes.shop3,
//       "name": "Land",
//       "opacity": Color(0xFFE7FDE4),
//     }, // light green
//     {
//       "image": IMGRes.shop4,
//       "name": "Warehouses",
//       "opacity": Color(0xFFEAE4FD),
//     }, // light pink
//     {
//       "image": IMGRes.shop1,
//       "name": "Commercial Space",
//       "opacity": Color(0xFFFDE4E4),
//     }, // light purple
//   ];
//
//   static final List<Map<String, dynamic>> furnishedType = [
//     {"image": IMGRes.furnished, "name": "Fully Furnished"},
//     {"image": IMGRes.semiFurnished, "name": "Semi Furnished"},
//     {"image": IMGRes.unFurnished, "name": "Unfurnished"},
//   ];
//
//   static final softColors = [
//     Color(0xFFFDE4E4),
//     Color(0xFFFDF6E4),
//     Color(0xFFE4F4FD),
//     Color(0xFFE7FDE4),
//     Color(0xFFEAE4FD),
//   ];
//
//   static final List<String> plots = [IMGRes.plot1, IMGRes.plot2, IMGRes.plot3];
//   static final List<Map<String, String>> bhk = [
//     {"image": IMGRes.bhk1, "title": "1 BHK"},
//     {"image": IMGRes.bhk2, "title": "2 BHK"},
//     {"image": IMGRes.bhk3, "title": "3 BHK"},
//     {"image": IMGRes.home1, "title": "4 BHK"},
//     {"image": IMGRes.home2, "title": "5+ BHK"},
//     // {"image": IMGRes.home2, "title": "Penthouse"},
//     // {"image": IMGRes.home3, "title": "Studio"},
//     // {"image": IMGRes.home4, "title": "Farmhouse"},
//   ];
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final PropertyController controller = Get.put(PropertyController());
//   final PropertyFavoriteController favoriteController =
//       Get.find<PropertyFavoriteController>();
//   final NewsController newsController = Get.put(NewsController());
//   final trendingCityController = Get.put(TrendingCityController());
//   final MicController micController = Get.put(MicController());
//   final GoogleMapSearchController googleMapController = Get.put(
//     GoogleMapSearchController(),
//     tag: 'city',
//   );
//   final profileController = Get.put(BuyerProfileDataController());
//   final SharePropertyController propertyShareController = Get.put(
//     SharePropertyController(),
//   );
//   final RecommendedPropertyController _recommendedPropertyController = Get.put(
//     RecommendedPropertyController(),
//   );
//   PropertyFilterControllerForFilter propertyFilterControllerForFilter = Get.put(
//     PropertyFilterControllerForFilter(),
//   );
//   final PlatformServicesController platformServicesController = Get.put(
//     PlatformServicesController(),
//   );
//   final TopContractorsController contractorServiceController = Get.put(
//     TopContractorsController(),
//   );
//   final ProjectWizardController projectController = Get.put(
//     ProjectWizardController(isBuilderView: false),
//   );
//   final reviewController = Get.put(
//     PlatformReviewController(
//       type: ['site', 'seller', 'reseller', 'contractor'],
//     ),
//   );
//
//   final TopSellerController topSellerController = Get.put(
//     TopSellerController(),
//   );
//   final CompareManager compare = Get.put(CompareManager(), permanent: true);
//
//   final TopCategoryController topCategoryController = Get.put(
//     TopCategoryController(),
//   );
//
//   final List<Map<String, dynamic>> cities = [
//     {
//       "imageUrl":
//           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgiSMhfr1LlJcuQraQeqAGmt1ma5s9tGvoVQ&s",
//       "cityName": "Delhi / NCR",
//       "propertyCount": "232,000+ Properties",
//     },
//     {
//       "imageUrl": "https://sitasurat.in/assets/images/about/surat-city.jpg",
//       "cityName": "Surat",
//       "propertyCount": "232,000+ Properties",
//     },
//     {
//       "imageUrl":
//           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgiSMhfr1LlJcuQraQeqAGmt1ma5s9tGvoVQ&s",
//       "cityName": "Bangalore",
//       "propertyCount": "63,000+ Properties",
//     },
//     {
//       "imageUrl":
//           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgiSMhfr1LlJcuQraQeqAGmt1ma5s9tGvoVQ&s",
//       "cityName": "Pune",
//       "propertyCount": "64,000+ Properties",
//     },
//     {
//       "imageUrl":
//           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgiSMhfr1LlJcuQraQeqAGmt1ma5s9tGvoVQ&s",
//       "cityName": "Hyderabad",
//       "propertyCount": "30,000+ Properties",
//     },
//   ];
//   final List<Map<String, dynamic>> dummySellerList = [
//     {
//       "seller": {
//         "name": "Ramprasad Padhi",
//         "image":
//             "https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=600&q=80",
//         "experience": 31,
//         "location": "Borivali West",
//         "properties_count": 55,
//       },
//     },
//     {
//       "seller": {
//         "name": "Meena Properties",
//         "image":
//             "https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=600&q=80",
//         "experience": 6,
//         "location": "Virar West",
//         "properties_count": 54,
//       },
//     },
//     {
//       "seller": {
//         "name": "Dhanraj Choudhary",
//         "image":
//             "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=600&q=80",
//         "experience": 13,
//         "location": "Powai",
//         "properties_count": 41,
//       },
//     },
//     {
//       "seller": {
//         "name": "Mahavastu Realty",
//         "image":
//             "https://images.unsplash.com/photo-1600566752355-35792bedcfea?auto=format&fit=crop&w=600&q=80",
//         "experience": 8,
//         "location": "Mira Road East",
//         "properties_count": 15,
//       },
//     },
//     {
//       "seller": {
//         "name": "Kohinoor Realtors",
//         "image":
//             "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=600&q=80",
//         "experience": 10,
//         "location": "Andheri East",
//         "properties_count": 29,
//       },
//     },
//     {
//       "seller": {
//         "name": "Ramprasad Padhi",
//         "image":
//             "https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=600&q=80",
//         "experience": 31,
//         "location": "Borivali West",
//         "properties_count": 55,
//       },
//     },
//     {
//       "seller": {
//         "name": "Meena Properties",
//         "image":
//             "https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=600&q=80",
//         "experience": 6,
//         "location": "Virar West",
//         "properties_count": 54,
//       },
//     },
//     {
//       "seller": {
//         "name": "Dhanraj Choudhary",
//         "image":
//             "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=600&q=80",
//         "experience": 13,
//         "location": "Powai",
//         "properties_count": 41,
//       },
//     },
//     {
//       "seller": {
//         "name": "Mahavastu Realty",
//         "image":
//             "https://images.unsplash.com/photo-1600566752355-35792bedcfea?auto=format&fit=crop&w=600&q=80",
//         "experience": 8,
//         "location": "Mira Road East",
//         "properties_count": 15,
//       },
//     },
//     {
//       "seller": {
//         "name": "Kohinoor Realtors",
//         "image":
//             "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=600&q=80",
//         "experience": 10,
//         "location": "Andheri East",
//         "properties_count": 29,
//       },
//     },
//   ];
//
//   int selectedIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//
//     ever(controller.selectedCity, (_) {
//       // When city changes, reset the selected property type index
//       if (mounted) {
//         setState(() {
//           selectedIndex = -1;
//         });
//         print("🔄 City changed, property type selection reset");
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final user = await SecureStorage.getUserData();
//       debugPrint("User Data: ${user?.toJson()}");
//       favoriteController.getFavorite(user?.user?.id ?? '');
//       await controller.getRecommendedPropertyById(user?.user?.id ?? '');
//       await profileController.getUserProfile();
//
//       log("home city ${controller.selectedCity.value}");
//       controller.fetchTradingArea(controller.selectedCity.value);
//       projectController.cityAssign(controller.selectedCity.value);
//     });
//
//     // Get.lazyPut(() => PropertyController());
//     // final PropertyController controller = Get.find();
//     return Scaffold(
//       backgroundColor: ColorRes.bgColor,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 12),
//                   Obx(
//                     () => HomeHeader(
//                       image:
//                           profileController.userProfile.value?.profilePic ?? '',
//                     ),
//                   ),
//
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // SizedBox(height: 15),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(
//                           // horizontal: 12,
//                           vertical: 4,
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: List.generate(widget.propertyTypes.length, (
//                             index,
//                           ) {
//                             final type = widget.propertyTypes[index];
//                             final isSelected = selectedIndex == index;
//
//                             return GestureDetector(
//                               onTap: () {
//                                 final filterValue = type['title']!
//                                     .toLowerCase()
//                                     .replaceAll(" ", "_");
//
//                                 print("hdfbhsd $filterValue");
//                                 controller.applyFilter(
//                                   (filterValue == "pg")
//                                       ? "listingType"
//                                       : "propertyType",
//                                   filterValue,
//                                 );
//                                 projectController.applyFilter(
//                                   (filterValue == "pg")
//                                       ? "listingType"
//                                       : "propertyType",
//                                   filterValue,
//                                 );
//
//                                 setState(() {
//                                   selectedIndex = index;
//                                 });
//                                 // controller.refreshList();
//                                 print("Selected: ${type['title']}");
//                               },
//                               child: IntrinsicWidth(
//                                 child: Container(
//                                   margin: EdgeInsets.only(
//                                     left: index == 0 ? 8 : 2,
//                                     right:
//                                         index == widget.propertyTypes.length - 1
//                                             ? 8
//                                             : 0,
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         width: 60,
//                                         height: 60,
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           border: Border.all(
//                                             color:
//                                                 isSelected
//                                                     ? ColorRes.primary
//                                                     : ColorRes
//                                                         .leadGreyColor
//                                                         .shade300,
//                                             width: 2,
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(2),
//                                           child: ClipOval(
//                                             child: FadeInImage.assetNetwork(
//                                               placeholder:
//                                                   'assets/logo/Avant.jpg',
//                                               image: type['image'] ?? '',
//                                               fit: BoxFit.cover,
//                                               imageErrorBuilder:
//                                                   (
//                                                     context,
//                                                     error,
//                                                     stackTrace,
//                                                   ) => Icon(
//                                                     Icons.home_work_rounded,
//                                                     color:
//                                                         ColorRes
//                                                             .leadGreyColor
//                                                             .shade400,
//                                                     size: 32,
//                                                   ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       SizedBox(
//                                         width:
//                                             76, // slightly larger than icon width
//                                         child: Text(
//                                           type['title'] ?? '',
//                                           textAlign: TextAlign.center,
//                                           maxLines: 2, // ✅ allow wrap
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             fontSize: AppFontSizes.caption,
//                                             fontWeight:
//                                                 isSelected
//                                                     ? AppFontWeights.semiBold
//                                                     : AppFontWeights.medium,
//                                             color:
//                                                 isSelected
//                                                     ? ColorRes.primary
//                                                     : ColorRes.black,
//                                             letterSpacing: 0.4,
//                                             height: 1.2, // better line spacing
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       // NEWLY ADDED PROPERTIES SECTION
//                       // Obx(() {
//                       //   if (controller.isLoading.value &&
//                       //       controller.items.isEmpty) {
//                       //     return const Center(
//                       //       child: CircularProgressIndicator(),
//                       //     );
//                       //   }
//                       //   final activeTopProperties =
//                       //       controller.items
//                       //           .where(
//                       //             (element) =>
//                       //                 element.approvalStatus == "approved",
//                       //           )
//                       //           .toList();
//                       //
//                       //   print(
//                       //     "Approved Property: ${activeTopProperties.length}",
//                       //   );
//                       //   if (!controller.isLoading.value &&
//                       //       activeTopProperties.isEmpty) {
//                       //     return SizedBox.shrink();
//                       //   }
//                       //
//                       //   if (controller.isRefreshing.value &&
//                       //       activeTopProperties.isEmpty) {
//                       //     return const Center(
//                       //       child: CircularProgressIndicator(),
//                       //     );
//                       //   }
//                       //
//                       //   if (!controller.isRefreshing.value &&
//                       //       activeTopProperties.isEmpty) {
//                       //     return SizedBox.shrink();
//                       //   }
//                       //
//                       //   return Column(
//                       //     children: [
//                       //       TitleWithViewAll(
//                       //         title: "Newly added properties",
//                       //         showViewAll: true,
//                       //         onViewAll: () => Get.to(PropertyDetail()),
//                       //       ),
//                       //       const SizedBox(height: 12),
//                       //       Padding(
//                       //         padding: const EdgeInsets.symmetric(
//                       //           horizontal: 12,
//                       //         ),
//                       //         child: NotificationListener<ScrollNotification>(
//                       //           onNotification: (scrollEnd) {
//                       //             final metrics = scrollEnd.metrics;
//                       //             if (metrics.atEdge && metrics.pixels != 0) {
//                       //               controller.loadMore();
//                       //             }
//                       //             return false;
//                       //           },
//                       //           child: SizedBox(
//                       //             height: 310,
//                       //             child: ClipRRect(
//                       //               child: ListView.separated(
//                       //                 scrollDirection: Axis.horizontal,
//                       //                 itemCount: activeTopProperties.length,
//                       //                 separatorBuilder:
//                       //                     (_, __) => const SizedBox(width: 12),
//                       //                 itemBuilder: (context, index) {
//                       //                   if (index >=
//                       //                       activeTopProperties.length) {
//                       //                     return const SizedBox();
//                       //                   }
//                       //                   final data = activeTopProperties[index];
//                       //                   print("Newly ${data.city}");
//                       //                   return MediaQuery(
//                       //                     data: MediaQuery.of(context).copyWith(
//                       //                       textScaler: const TextScaler.linear(
//                       //                         1.0,
//                       //                       ),
//                       //                     ),
//                       //                     child: PropertyCard(property: data),
//                       //                   );
//                       //                 },
//                       //               ),
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   );
//                       // }),
//                       Obx(() {
//                         // 1️⃣ Initial loading
//                         if (controller.isLoading.value &&
//                             controller.items.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         final activeTopProperties =
//                             controller.items.value
//                                 .where((e) => e.approvalStatus == "approved")
//                                 .toList();
//
//                         // 2️⃣ Refreshing (filter / pull-to-refresh)
//                         if (controller.isRefreshing.value) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         // 3️⃣ No data after load/refresh
//                         if (!controller.isRefreshing.value &&
//                             activeTopProperties.isEmpty) {
//                           return const SizedBox.shrink();
//                         }
//
//                         if (activeTopProperties.isEmpty) {
//                           return const SizedBox.shrink();
//                         }
//
//                         // 4️⃣ Data available
//                         return Column(
//                           children: [
//                             TitleWithViewAll(
//                               title: "Newly added properties",
//                               showViewAll: true,
//                               onViewAll: () => Get.to(PropertyDetail()),
//                             ),
//                             const SizedBox(height: 12),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                               ),
//                               child: NotificationListener<ScrollNotification>(
//                                 onNotification: (scrollEnd) {
//                                   final metrics = scrollEnd.metrics;
//                                   if (metrics.atEdge && metrics.pixels != 0) {
//                                     controller.loadMore();
//                                   }
//                                   return false;
//                                 },
//                                 child: SizedBox(
//                                   height: 310,
//                                   child: ListView.separated(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: activeTopProperties.length,
//                                     separatorBuilder:
//                                         (_, __) => const SizedBox(width: 12),
//                                     itemBuilder: (context, index) {
//                                       final data = activeTopProperties[index];
//                                       return MediaQuery(
//                                         data: MediaQuery.of(context).copyWith(
//                                           textScaler: const TextScaler.linear(
//                                             1.0,
//                                           ),
//                                         ),
//                                         child: PropertyCard(property: data),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//
//                       Obx(() {
//                         if (controller.apiLoading.value &&
//                             controller.recommendedProperties.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         if (!controller.apiLoading.value &&
//                             controller.recommendedProperties.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 12),
//                             TitleWithViewAll(title: "Recommended Properties"),
//                             SizedBox(height: 4),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 12),
//                               child: SizedBox(
//                                 height: 310,
//                                 child: ClipRRect(
//                                   child: ListView.separated(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount:
//                                         controller.recommendedProperties.length,
//                                     separatorBuilder:
//                                         (_, __) => const SizedBox(width: 12),
//                                     itemBuilder: (context, index) {
//                                       if (index >=
//                                           controller
//                                               .recommendedProperties
//                                               .length) {
//                                         return const SizedBox();
//                                       }
//                                       final data =
//                                           controller
//                                               .recommendedProperties[index];
//                                       print("Newly ${data.city}");
//                                       return MediaQuery(
//                                         data: MediaQuery.of(context).copyWith(
//                                           textScaler: const TextScaler.linear(
//                                             1.0,
//                                           ),
//                                         ),
//                                         child: PropertyCard(property: data),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                       // Top Locations
//                       // const TitleWithViewAll(
//                       //   title: "Trending Areas",
//                       //   showViewAll: true,
//                       // ),
//                       //
//                       // const SizedBox(height: 12),
//                       //
//                       // // FutureBuilder(
//                       // //   future: controller.loadInitial(),
//                       // //   builder: (context, asyncSnapshot) {
//                       // //     print('asyncSnapshot: ${asyncSnapshot.connectionState}');
//                       // //
//                       // //     if (asyncSnapshot.connectionState ==
//                       // //         ConnectionState.waiting) {
//                       // //       // Show loader while waiting
//                       // //       return const Center(child: CircularProgressIndicator());
//                       // //     } else if (asyncSnapshot.hasError) {
//                       // //       // Show error message if future fails
//                       // //       return Center(
//                       // //         child: Text(
//                       // //           'Error: ${asyncSnapshot.error}',
//                       // //           style: const TextStyle(color: Colors.red),
//                       // //         ),
//                       // //       );
//                       // //     } else if (asyncSnapshot.connectionState ==
//                       // //         ConnectionState.done) {
//                       // //       return Obx(() {
//                       // //         if (!controller.isLoading.value &&
//                       // //             controller.items.isEmpty) {
//                       // //           return const Center(
//                       // //             child: Text("No Property found."),
//                       // //           );
//                       // //         }
//                       // //
//                       // //         return SizedBox(
//                       // //           height: 180,
//                       // //           child: ClipRRect(
//                       // //             child: ListView.separated(
//                       // //               scrollDirection: Axis.horizontal,
//                       // //               itemCount: controller.items.length.clamp(0, 10),
//                       // //               padding: const EdgeInsets.symmetric(
//                       // //                 horizontal: 10,
//                       // //               ),
//                       // //               separatorBuilder:
//                       // //                   (_, __) => const SizedBox(width: 10),
//                       // //               itemBuilder: (context, index) {
//                       // //                 final property = controller.items[index];
//                       // //                 final percentage =
//                       // //                     double.tryParse(
//                       // //                       propertyPercentage[index],
//                       // //                     ) ??
//                       // //                     0.0;
//                       // //                 final isPositive = percentage >= 10.0;
//                       // //                 return TopPropertyByLocation(
//                       // //                   property: property,
//                       // //                   isPositive: isPositive,
//                       // //                   rating: percentage,
//                       // //                 );
//                       // //               },
//                       // //             ),
//                       // //           ),
//                       // //         );
//                       // //       });
//                       // //     } else {
//                       // //       return const Center(
//                       // //         child: Text('No Property Available'),
//                       // //       );
//                       // //     }
//                       // //   },
//                       // // ),
//                       // Obx(() {
//                       //   if (controller.isLoading.value) {
//                       //     return const Center(child: CircularProgressIndicator());
//                       //   } else if (controller.items.isEmpty) {
//                       //     return const Center(child: Text("No Property found."));
//                       //   } else {
//                       //     return SizedBox(
//                       //       height: 180,
//                       //       child: ListView.separated(
//                       //         scrollDirection: Axis.horizontal,
//                       //         itemCount: controller.items.length.clamp(0, 10),
//                       //         padding: EdgeInsets.symmetric(horizontal: 12),
//                       //         separatorBuilder:
//                       //             (_, __) => const SizedBox(width: 10),
//                       //         itemBuilder: (context, index) {
//                       //           final property = controller.items[index];
//                       //           final percentage =
//                       //               double.tryParse(propertyPercentage[index]) ??
//                       //               0.0;
//                       //           final isPositive = percentage >= 10.0;
//                       //           return TopPropertyByLocation(
//                       //             property: property,
//                       //             rating: percentage,
//                       //             isPositive: isPositive,
//                       //           );
//                       //         },
//                       //       ),
//                       //     );
//                       //   }
//                       // }),
//                       //
//                       // const SizedBox(height: 20),
//
//                       // const TitleWithViewAll(
//                       //   title: "Top Rated Localities",
//                       //   showViewAll: true,
//                       // ),
//                       //
//                       // const SizedBox(height: 12),
//                       //
//                       // Obx(() {
//                       //   if (!controller.isLoading.value &&
//                       //       controller.items.isEmpty) {
//                       //     return const Center(child: CircularProgressIndicator());
//                       //   }
//                       //
//                       //   if (!controller.isLoading.value &&
//                       //       controller.items.isEmpty) {
//                       //     return const Center(child: Text("No Property found."));
//                       //   }
//                       //
//                       //   return SizedBox(
//                       //     height: 100,
//                       //     child: ListView.builder(
//                       //       scrollDirection: Axis.horizontal,
//                       //       itemCount: controller.items.length,
//                       //       padding: const EdgeInsets.only(left: 10),
//                       //       itemBuilder: (context, index) {
//                       //         final property = controller.items[index];
//                       //         return Padding(
//                       //           padding: const EdgeInsets.only(right: 10), //
//                       //           child: PropertyHorizontalCard(
//                       //             imageHeight: double.infinity,
//                       //             titleFontWeight: AppFontWeights.semiBold,
//                       //
//                       //             buttonText: 'View More',
//                       //             locationFontSize: AppFontSizes.caption,
//                       //             maxLineTitle: 1,
//                       //             buttonFontWeight: AppFontWeights.semiBold,
//                       //             buttonFontSize: 10,
//                       //             buttonTextColor: ColorRes.primary,
//                       //             borderColor: ColorRes.grey,
//                       //             maxLine: 1,
//                       //             title: '${property.title}',
//                       //             imagePath:
//                       //                 (property.propertyMedia?.images != null &&
//                       //                         property
//                       //                             .propertyMedia!
//                       //                             .images!
//                       //                             .isNotEmpty)
//                       //                     ? property.propertyMedia!.images!.first
//                       //                     : 'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg',
//                       //
//                       //             location:
//                       //                 'Location : ${property.address ?? 'N/A'}',
//                       //             rating:
//                       //                 property.totalViews != null
//                       //                     ? property.totalViews?.toDouble()
//                       //                     : 0.0,
//                       //             price:
//                       //                 '${property.propertyDetails?.financialInfo?.price ?? 'N/A'}',
//                       //             priceFontSize: AppFontSizes.caption,
//                       //             priceFontWeight: AppFontWeights.semiBold,
//                       //             ratingColor: ColorRes.primary,
//                       //             accentColor: ColorRes.primary,
//                       //             onTap: () {
//                       //               Get.to(() => RatingDetail(property: property));
//                       //             },
//                       //           ),
//                       //         );
//                       //       },
//                       //     ),
//                       //   );
//                       // }),
//                       Obx(() {
//                         if (trendingCityController.isLoading.value &&
//                             trendingCityController
//                                 .allTrendingCities
//                                 .isNotEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         if (!trendingCityController.isLoading.value &&
//                             trendingCityController.allTrendingCities.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             TitleWithViewAll(
//                               title: "City",
//                               showViewAll: true,
//                               onViewAll: () {
//                                 Get.to(() => const MumbaiProjectsScreen());
//                               },
//                             ),
//                             const SizedBox(height: 12),
//                             CityFilterList(),
//                           ],
//                         );
//                       }),
//
//                       Obx(() {
//                         if (projectController.isLoading.value &&
//                             projectController.items.isNotEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         final activeTopProperties =
//                             projectController.items
//                                 .where(
//                                   (element) =>
//                                       element.approvalStatus == "approved",
//                                 )
//                                 .toList();
//                         if (!projectController.isLoading.value &&
//                             activeTopProperties.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             TitleWithViewAll(
//                               title: "Explore Projects",
//                               showViewAll: true,
//                               onViewAll: () {
//                                 Get.to(() => AllProjectListScreen());
//                               },
//                             ),
//                             const SizedBox(height: 12),
//                             SizedBox(
//                               height: 256,
//                               width: double.infinity,
//                               child: ListView.separated(
//                                 scrollDirection: Axis.horizontal,
//                                 separatorBuilder:
//                                     (_, __) => const SizedBox(width: 12),
//                                 padding: EdgeInsets.symmetric(horizontal: 12),
//                                 itemCount: activeTopProperties.length,
//                                 itemBuilder: (context, index) {
//                                   final ProjectItem data =
//                                       activeTopProperties[index];
//                                   log("Project Message ${data.toJson()}");
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Get.to(
//                                         () => ProjectDetailsScreen(
//                                           projectItem: data,
//                                         ),
//                                       );
//                                     },
//                                     child: BuilderProjectCard(
//                                       forHome: true,
//                                       project: data,
//                                       width: 250,
//                                       height: 150,
//                                       // ✅ Explicitly set height
//                                       developersName:
//                                           data.projectContactInfo?.name ??
//                                           'Unknown',
//                                       imageUrl:
//                                           (data
//                                                       .mediaGallery
//                                                       ?.images
//                                                       ?.isNotEmpty ??
//                                                   false)
//                                               ? data.mediaGallery!.images.first
//                                               : IMGRes.home3,
//                                       projectName:
//                                           data.projectName.isNotEmpty
//                                               ? data.projectName
//                                               : 'N/A',
//                                       location:
//                                           data.address.isNotEmpty
//                                               ? data.address
//                                               : 'Not specified',
//                                       price: data.getPriceRange(),
//                                       propertySize:
//                                           data.projectSize?.totalBuildings
//                                               ?.toString() ??
//                                           '—',
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//
//                       const SizedBox(height: 20),
//
//                       const TitleWithViewAll(
//                         title: "Explore by furnishing type",
//                       ),
//                       // const SizedBox(height: 12),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             children: List.generate(HomeScreen.furnishedType.length, (
//                               index,
//                             ) {
//                               final furnished = HomeScreen.furnishedType[index];
//                               return Padding(
//                                 padding: const EdgeInsets.only(right: 12),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       if (furnished['name'] ==
//                                           'Fully Furnished') {
//                                         propertyFilterControllerForFilter
//                                             .rentFurnishing
//                                             .value = 'fully-furnished';
//                                       } else if (furnished['name'] ==
//                                           'Semi Furnished') {
//                                         propertyFilterControllerForFilter
//                                             .rentFurnishing
//                                             .value = 'semi-furnished';
//                                       } else if (furnished['name'] ==
//                                           "Unfurnished") {
//                                         propertyFilterControllerForFilter
//                                             .rentFurnishing
//                                             .value = 'unfurnished';
//                                       }
//                                       print(
//                                         "Furnishing iut ${propertyFilterControllerForFilter.rentFurnishing.value}",
//                                       );
//                                       Get.to(
//                                         () => PropertyDetail(
//                                           filters: [
//                                             {
//                                               'furnish_type':
//                                                   propertyFilterControllerForFilter
//                                                       .rentFurnishing
//                                                       .value,
//                                             },
//                                           ],
//                                         ),
//                                       );
//                                     });
//                                   },
//                                   child: NesticoPeCardWithText(
//                                     height: 120,
//                                     width: 200,
//                                     imageUrl: furnished["image"]!,
//                                     // ✅ image
//                                     title: furnished["name"]!,
//
//                                     // opacity:
//                                     //     HomeScreen.softColors[(index + 4) %
//                                     //         HomeScreen.softColors.length], // ✅ name
//                                     opacity: ColorRes.black,
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//
//                       Obx(() {
//                         // ✅ Loading state
//                         if (controller.isLoading.value &&
//                             controller.topProperties.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         // ✅ Filter properties where state == true
//                         final activeTopProperties =
//                             controller.topProperties
//                                 .where(
//                                   (element) =>
//                                       element.approvalStatus == "approved",
//                                 )
//                                 .toList();
//
//                         // ✅ No properties after filtering
//                         if (!controller.isLoading.value &&
//                             activeTopProperties.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Column(
//                           children: [
//                             const SizedBox(height: 8),
//
//                             TitleWithViewAll(
//                               title:
//                                   "Top properties in ${controller.selectedCity.value}",
//                               showViewAll: true,
//                               onViewAll: () => Get.to(PropertyDetail()),
//                             ),
//                             SizedBox(height: 12),
//
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                               ),
//                               child: SizedBox(
//                                 height: 310,
//                                 child: ClipRRect(
//                                   child: ListView.separated(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: activeTopProperties.length,
//                                     separatorBuilder:
//                                         (_, __) => const SizedBox(width: 12),
//                                     itemBuilder: (context, index) {
//                                       final data = activeTopProperties[index];
//                                       print("Top Property: ${data.city}");
//                                       return MediaQuery(
//                                         data: MediaQuery.of(context).copyWith(
//                                           textScaler: const TextScaler.linear(
//                                             1.0,
//                                           ),
//                                         ),
//                                         child: TopPropertyCard(property: data),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                       Obx(() {
//                         if (projectController.isLoading.value &&
//                             projectController.topProjects.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         final activeTopProperties =
//                             projectController.topProjects
//                                 .where(
//                                   (element) =>
//                                       element.approvalStatus == "approved",
//                                 )
//                                 .toList();
//                         if (!projectController.isLoading.value &&
//                             activeTopProperties.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Column(
//                           children: [
//                             const SizedBox(height: 8),
//                             // const SizedBox(height: 20),
//
//                             // TitleWithViewAll(title: "Commercial offerings"),
//                             // const SizedBox(height: 12),
//                             // SingleChildScrollView(
//                             //   scrollDirection: Axis.horizontal,
//                             //   child: Padding(
//                             //     padding: const EdgeInsets.all(12.0),
//                             //     child: Row(
//                             //       children: List.generate(HomeScreen.shops.length, (
//                             //         index,
//                             //       ) {
//                             //         final shop = HomeScreen.shops[index];
//                             //         return Padding(
//                             //           padding: const EdgeInsets.only(right: 12),
//                             //           child: NesticoPeCardWithText(
//                             //             height: 170,
//                             //             width: 150,
//                             //             imageUrl: shop["image"]!,
//                             //             // ✅ image
//                             //             title: shop["name"]!,
//                             //             opacity:
//                             //                 HomeScreen.softColors[index % 5], // ✅ name
//                             //           ),
//                             //         );
//                             //       }),
//                             //     ),
//                             //   ),
//                             // ),
//                             //
//                             // const SizedBox(height: 20),
//
//                             // const TitleWithViewAll(title: "Find BHK?"),
//                             // const SizedBox(height: 12),
//                             //
//                             // // SingleChildScrollView(
//                             // //   scrollDirection: Axis.horizontal,
//                             // //   child: Padding(
//                             // //     padding: const EdgeInsets.all(12.0),
//                             // //     child: Row(
//                             // //       children: List.generate(HomeScreen.plots.length * 2, (
//                             // //         index,
//                             // //       ) {
//                             // //         return const Padding(
//                             // //           padding: EdgeInsets.only(right: 12),
//                             // //           child: NesticoPeBannerCardWithText(
//                             // //             height: 100,
//                             // //             width: 100,
//                             // //             imageUrl: bhk[index % 3],
//                             // //             title: "1BHK",
//                             // //             isCenterText: true,
//                             // //           ),
//                             // //
//                             // //
//                             // //         );
//                             // //       }),
//                             // //     ),
//                             // //   ),
//                             // // ),
//                             // SingleChildScrollView(
//                             //   scrollDirection: Axis.horizontal,
//                             //   child: Padding(
//                             //     padding: const EdgeInsets.all(12.0),
//                             //     child: Row(
//                             //       children: List.generate(HomeScreen.bhk.length, (index) {
//                             //         // final shop = HomeScreen.shops[index];
//                             //         return Padding(
//                             //           padding: const EdgeInsets.only(right: 12),
//                             //           child: NesticoPeCardWithText(
//                             //             height: 100,
//                             //             width: 100,
//                             //             // imageUrl:
//                             //             //     HomeScreen.bhk[index %
//                             //             //         HomeScreen.bhk.length]['image']!,
//                             //             // ✅ image
//                             //             title:
//                             //                 HomeScreen.bhk[index %
//                             //                     HomeScreen.bhk.length]['title']!,
//                             //             opacity:
//                             //                 HomeScreen.softColors[(index + 2) %
//                             //                     HomeScreen.softColors.length],
//                             //           ),
//                             //         );
//                             //       }),
//                             //     ),
//                             //   ),
//                             // ),
//                             // const SizedBox(height: 20),
//
//                             // const TitleWithViewAll(title: "Plots In Surat"),
//                             // const SizedBox(height: 12),
//                             // SingleChildScrollView(
//                             //   scrollDirection: Axis.horizontal,
//                             //   child: Padding(
//                             //     padding: const EdgeInsets.all(12.0),
//                             //     child: Row(
//                             //       children: List.generate(HomeScreen.plots.length, (
//                             //         index,
//                             //       ) {
//                             //         return const Padding(
//                             //           padding: EdgeInsets.only(right: 12),
//                             //           // child: NesticoPeBannerCardWithText(
//                             //           //   height: 125,
//                             //           //   width: 200,
//                             //           //   imageUrl: plots[index],
//                             //           //   title: "Residential Plot",
//                             //           // ),
//                             //         );
//                             //       }),
//                             //     ),
//                             //   ),
//                             // ),
//                             TitleWithViewAll(
//                               title:
//                                   "Top Project in ${projectController.selectedCity.value}",
//                               showViewAll: true,
//                               onViewAll: () => Get.to(PropertyDetail()),
//                             ),
//                             SizedBox(height: 12),
//                             SizedBox(
//                               height: 256,
//                               width: double.infinity,
//                               child: ListView.separated(
//                                 scrollDirection: Axis.horizontal,
//                                 separatorBuilder:
//                                     (_, __) => const SizedBox(width: 12),
//                                 padding: EdgeInsets.symmetric(horizontal: 12),
//                                 itemCount: activeTopProperties.length,
//                                 itemBuilder: (context, index) {
//                                   final ProjectItem data =
//                                       activeTopProperties[index];
//                                   log("Project Message ${data.toJson()}");
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Get.to(
//                                         () => ProjectDetailsScreen(
//                                           projectItem: data,
//                                         ),
//                                       );
//                                     },
//                                     child: BuilderProjectCard(
//                                       forHome: true,
//                                       project: data,
//                                       width: 250,
//                                       height: 150,
//                                       // ✅ Explicitly set height
//                                       developersName:
//                                           data.projectContactInfo?.name ??
//                                           'Unknown',
//                                       imageUrl:
//                                           (data
//                                                       .mediaGallery
//                                                       ?.images
//                                                       ?.isNotEmpty ??
//                                                   false)
//                                               ? data.mediaGallery!.images.first
//                                               : IMGRes.home3,
//                                       projectName:
//                                           data.projectName.isNotEmpty
//                                               ? data.projectName
//                                               : 'N/A',
//                                       location:
//                                           data.address.isNotEmpty
//                                               ? data.address
//                                               : 'Not specified',
//                                       price: data.getPriceRange(),
//                                       propertySize:
//                                           data.projectSize?.totalBuildings
//                                               ?.toString() ??
//                                           '—',
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                       Obx(() {
//                         if (topSellerController.isLoading.value &&
//                             topSellerController.items.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         if (!topSellerController.isLoading.value &&
//                             topSellerController.items.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//                         return Column(
//                           children: [
//                             const SizedBox(height: 8),
//                             TitleWithViewAll(title: "Recommended Sellers"),
//                             const SizedBox(height: 12),
//
//                             SellerListWidget(
//                               topSeller: topSellerController.items,
//                             ),
//                           ],
//                         );
//                       }),
//
//                       // Obx(() {
//                       //   final trendingData =
//                       //       controller.trendingAreaList.value?.data;
//                       //
//                       //   if (trendingData == null || trendingData.isEmpty) {
//                       //     // If no data, return an empty widget (to avoid build errors)
//                       //     return const SizedBox.shrink();
//                       //   }
//                       //
//                       //   // Otherwise show your widgets
//                       //   return Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     children: [
//                       //       TitleWithViewAll(
//                       //         title:
//                       //             "Trending Area (${controller.selectedCity.value})",
//                       //         showViewAll: false,
//                       //       ),
//                       //       SizedBox(height: 12),
//                       //       ExploreLocalities(trendingArea: trendingData),
//                       //       const SizedBox(height: 32),
//                       //     ],
//                       //   );
//                       // }),
//                       Obx(() {
//                         if (contractorServiceController.isLoading.value &&
//                             contractorServiceController.items.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         if (!contractorServiceController.isLoading.value &&
//                             contractorServiceController.items.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//                         return Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             const TitleWithViewAll(
//                               title: "Top Contractors",
//                               showViewAll: false,
//                             ),
//                             SizedBox(height: 6),
//                             SizedBox(
//                               height: 250,
//                               child: ListView.separated(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                 ),
//                                 separatorBuilder:
//                                     (context, index) =>
//                                         const SizedBox(width: 12),
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount:
//                                     contractorServiceController.items.length,
//                                 itemBuilder: (context, index) {
//                                   final data =
//                                       contractorServiceController.items[index];
//                                   return SizedBox(
//                                     width: 300, // 🔥 MUST SET WIDTH
//                                     child: ContractorCard(contractor: data),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//
//                       Obx(() {
//                         if (topCategoryController.isLoading.value &&
//                             topCategoryController.categories.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         if (!topCategoryController.isLoading.value &&
//                             topCategoryController.categories.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             const TitleWithViewAll(
//                               title: "Top Categories",
//                               showViewAll: false,
//                             ),
//                             SizedBox(height: 12),
//                             TopCategoriesSection(categories: topCategoryController.categories,),
//                           ],
//                         );
//                       }),
//
//                       Obx(() {
//                         if (platformServicesController.isLoading.value &&
//                             platformServicesController.items.isEmpty) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//
//                         if (!platformServicesController.isLoading.value &&
//                             platformServicesController.items.isEmpty) {
//                           return SizedBox.shrink();
//                         }
//                         return Column(
//                           children: [
//                             const SizedBox(height: 12),
//                             const TitleWithViewAll(
//                               title: "Platform Services",
//                               showViewAll: false,
//                             ),
//                             SizedBox(height: 12),
//
//                             PlatformServiceHorizontalList(
//                               services: platformServicesController.items,
//                             ),
//                           ],
//                         );
//                       }),
//                       const SizedBox(height: 20),
//                       if (newsController.items.isNotEmpty) ...[
//                         const TitleWithViewAll(
//                           title: "News & Articles",
//                           showViewAll: false,
//                         ),
//                         SizedBox(height: 12),
//
//                         Obx(() {
//                           if (newsController.isLoading.value &&
//                               newsController.items.isEmpty) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//
//                           if (!newsController.isLoading.value &&
//                               newsController.items.isEmpty) {
//                             return SizedBox.shrink();
//                           }
//                           return NewsAndArticles(
//                             articles: newsController.items,
//                           );
//                         }),
//                         const SizedBox(height: 20),
//                       ],
//
//                       const TitleWithViewAll(
//                         title: "Why Choose Us",
//                         showViewAll: false,
//                       ),
//                       SizedBox(height: 12),
//                       WhyChooseUsSection(),
//                       if (reviewController.allReviews.isNotEmpty) ...[
//                         const SizedBox(height: 20),
//                         const TitleWithViewAll(
//                           title: "Reviews & Testimonials",
//                           showViewAll: false,
//                         ),
//                         SizedBox(height: 12),
//                         ReviewsAndTestimonials(),
//                         SizedBox(height: AppSpacing.medium),
//                       ],
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         showFindPropertyDialog(
//                           controller,
//                           googleMapController,
//                           context,
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text("Find Your Property"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             UnifiedComparisonFloatingButton(bottom: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future<void> showFindPropertyDialog(
//   PropertyController controller,
//   GoogleMapSearchController googleMapController,
//   BuildContext context,
// ) async {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   Get.dialog(
//     Dialog(
//       backgroundColor: ColorRes.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           "Find Your Dream Property",
//                           style: TextStyle(
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.white,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () => Get.back(),
//                         borderRadius: BorderRadius.circular(50),
//                         child: const Icon(
//                           Icons.close_rounded,
//                           color: ColorRes.white,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Form Content
//               Flexible(
//                 flex: 1,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Stack(
//                       //   children: [
//                       //     NesticoPeTextField(
//                       //       title: "City",
//                       //       isRequired: true,
//                       //       prefixIcon: Icons.location_city_outlined,
//                       //       hintText: "Select City",
//                       //       autovalidateMode:
//                       //           AutovalidateMode.onUserInteraction,
//                       //       validator: (value) => requiredField(value, 'City'),
//                       //       onChanged: (value) async {
//                       //         if (value.isNotEmpty) {
//                       //           await googleMapController.fetchGooglePlaces(
//                       //             value,
//                       //           );
//                       //           log("City input: $value");
//                       //         } else {
//                       //           googleMapController.predictions.clear();
//                       //         }
//                       //       },
//                       //       controller: controller.selectedCityZ,
//                       //     ),
//                       //
//                       //     // City Predictions Dropdown - Below TextField
//                       //     Obx(() {
//                       //       final predictions = googleMapController.predictions;
//                       //       final parsedCities = googleMapController.cityStateList;
//                       //       final hasParsed = parsedCities.isNotEmpty;
//                       //       final items = hasParsed ? parsedCities : predictions;
//                       //
//                       //       if (items.isEmpty) return const SizedBox();
//                       //
//                       //       return Positioned(
//                       //         top: 90, // Position below the text field
//                       //         left: 0,
//                       //         right: 0,
//                       //         child: Material(
//                       //           elevation: 8,
//                       //           shadowColor: Colors.black26,
//                       //           borderRadius: BorderRadius.circular(12),
//                       //           child: Container(
//                       //             constraints: const BoxConstraints(
//                       //               maxHeight: 250,
//                       //             ),
//                       //             decoration: BoxDecoration(
//                       //               color: Colors.white,
//                       //               borderRadius: BorderRadius.circular(12),
//                       //               border: Border.all(
//                       //                 color: ColorRes.primary.withOpacity(0.2),
//                       //                 width: 1,
//                       //               ),
//                       //             ),
//                       //             child: ListView.separated(
//                       //               shrinkWrap: true,
//                       //               padding: const EdgeInsets.symmetric(
//                       //                 vertical: 4,
//                       //               ),
//                       //               itemCount:
//                       //               items.length > 3
//                       //                       ? 3
//                       //                       : items.length,
//                       //               separatorBuilder:
//                       //                   (context, index) => Divider(
//                       //                     height: 1,
//                       //                     thickness: 0.5,
//                       //                     color: ColorRes.grey.withOpacity(0.2),
//                       //                   ),
//                       //               itemBuilder: (context, index) {
//                       //                 if (hasParsed) {
//                       //                   // ✅ Cast item to Map<String, String?>
//                       //                   final cityData = items[index] as Map<String, String?>;
//                       //
//                       //                   log("djhfudfhg ${cityData}");
//                       //
//                       //                   return ListTile(
//                       //                     leading: const Icon(
//                       //                       Icons.location_city_outlined,
//                       //                       size: 20,
//                       //                       color: ColorRes.primary,
//                       //                     ),
//                       //                     title: Text(
//                       //                       cityData['city'] ?? '',
//                       //                       style: TextStyle(
//                       //                         fontSize: AppFontSizes.small,
//                       //                         color: ColorRes.homeBlackFade,
//                       //                       ),
//                       //                     ),
//                       //                     subtitle: Text(
//                       //                       '${cityData['state'] ?? ''}, ${cityData['country'] ?? ''}',
//                       //                       style: TextStyle(
//                       //                         fontSize: AppFontSizes.small,
//                       //                         color: ColorRes.leadGreyColor[700],
//                       //                       ),
//                       //                     ),
//                       //                     onTap: () {
//                       //                       controller.selectedCityZ.text = cityData['city'] ?? '';
//                       //                       googleMapController.predictions.clear();
//                       //                       googleMapController.cityStateList.clear();
//                       //                       FocusScope.of(context).unfocus();
//                       //
//                       //                     },
//                       //                   );
//                       //                 } else {
//                       //                   final city = items[index] as Prediction;
//                       //                   return ListTile(
//                       //                     leading: const Icon(
//                       //                       Icons.location_city_outlined,
//                       //                       size: 20,
//                       //                       color: ColorRes.primary,
//                       //                     ),
//                       //                     title: Text(
//                       //                       city.description ?? '',
//                       //                       style: TextStyle(
//                       //                         fontSize: AppFontSizes.small,
//                       //                         color: ColorRes.homeBlackFade,
//                       //                       ),
//                       //                     ),
//                       //                     onTap: () {
//                       //                       controller.selectedCityZ.text = city.description ?? '';
//                       //                       googleMapController.predictions.clear();
//                       //                       FocusScope.of(context).unfocus();
//                       //
//                       //                     },
//                       //                   );
//                       //                 }
//                       //
//                       //                 // return InkWell(
//                       //                 //   onTap: () {
//                       //                 //     controller.selectedCityZ.text =
//                       //                 //         city
//                       //                 //             .structuredFormatting
//                       //                 //             ?.mainText ??
//                       //                 //         '';
//                       //                 //     googleMapController.predictions
//                       //                 //         .clear();
//                       //                 //     FocusScope.of(context).unfocus();
//                       //                 //   },
//                       //                 //   child: Padding(
//                       //                 //     padding: const EdgeInsets.symmetric(
//                       //                 //       horizontal: 12,
//                       //                 //       vertical: 12,
//                       //                 //     ),
//                       //                 //     child: Row(
//                       //                 //       children: [
//                       //                 //         const Icon(
//                       //                 //           Icons.location_on,
//                       //                 //           color: ColorRes.primary,
//                       //                 //           size: 20,
//                       //                 //         ),
//                       //                 //         const SizedBox(width: 12),
//                       //                 //         Expanded(
//                       //                 //           child: Text(
//                       //                 //             city.description ?? '',
//                       //                 //             style: TextStyle(
//                       //                 //               fontSize:
//                       //                 //                   AppFontSizes.medium,
//                       //                 //               color: ColorRes.textPrimary,
//                       //                 //             ),
//                       //                 //           ),
//                       //                 //         ),
//                       //                 //       ],
//                       //                 //     ),
//                       //                 //   ),
//                       //                 // );
//                       //               },
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       );
//                       //     }),
//                       //   ],
//                       // ),
//                       _buildFieldLabel("City"),
//                       SizedBox(height: 10),
//                       CitySelectionWidget(
//                         isEditing: true,
//                         controller: controller.selectedCityZ,
//                         color: ColorRes.primary,
//                         fillColor: ColorRes.white,
//                         onCitySelected: (selectedCity) {
//                           print("✅ Selected city: ${selectedCity.description}");
//                           controller.selectedCityZ.text =
//                               selectedCity.description ?? '';
//                           // You can also store city details in your controller here
//                         },
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       // Listing Type Dropdown
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildFieldLabel('Listing Type'),
//                           const SizedBox(height: 8),
//                           Obx(
//                             () => DropdownButtonFormField<String>(
//                               value:
//                                   controller.listingTypes.contains(
//                                         controller.selectedListingType.value,
//                                       )
//                                       ? controller.selectedListingType.value
//                                       : null,
//                               isDense: true,
//                               isExpanded: true,
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.medium,
//                                 color: ColorRes.textPrimary,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: 'Select',
//                                 hintStyle: TextStyle(
//                                   color: Get.theme.colorScheme.onSurface
//                                       .withAlpha(128),
//                                   fontSize: AppFontSizes.bodyMedium,
//                                   fontWeight: AppFontWeights.regular,
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.category_outlined,
//                                   color: ColorRes.primary,
//                                   size: 20,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                   horizontal: 12,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     width: 0.8,
//                                     color: ColorRes.grey.withOpacity(0.2),
//                                   ),
//                                 ),
//                                 disabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     width: 0.8,
//                                     color: ColorRes.grey.withOpacity(0.2),
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     width: 1.2,
//                                     color: ColorRes.primary,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Get.theme.colorScheme.surface,
//                               ),
//                               icon: const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: ColorRes.primary,
//                               ),
//                               items:
//                                   controller.listingTypes
//                                       .map(
//                                         (e) => DropdownMenuItem(
//                                           value: e,
//                                           child: Text(
//                                             e,
//                                             style: TextStyle(
//                                               fontSize: AppFontSizes.medium,
//                                               color: ColorRes.textPrimary,
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                       .toList(),
//                               onChanged:
//                                   (val) =>
//                                       controller.selectedListingType.value =
//                                           val,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       // BHK Dropdown
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildFieldLabel('BHK'),
//                           const SizedBox(height: 8),
//                           Obx(
//                             () => DropdownButtonFormField<String>(
//                               value:
//                                   controller.bhkList.contains(
//                                         controller.selectedBhk.value,
//                                       )
//                                       ? controller.selectedBhk.value
//                                       : null,
//                               isDense: true,
//                               isExpanded: true,
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.medium,
//                                 color: ColorRes.textPrimary,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: 'Select',
//                                 hintStyle: TextStyle(
//                                   color: Get.theme.colorScheme.onSurface
//                                       .withAlpha(128),
//                                   fontSize: AppFontSizes.bodyMedium,
//                                   fontWeight: AppFontWeights.regular,
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.home_outlined,
//                                   color: ColorRes.primary,
//                                   size: 20,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                   horizontal: 12,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     width: 0.8,
//                                     color: ColorRes.grey.withOpacity(0.2),
//                                   ),
//                                 ),
//                                 disabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     width: 0.8,
//                                     color: ColorRes.grey.withOpacity(0.2),
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     width: 1.2,
//                                     color: ColorRes.primary,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Get.theme.colorScheme.surface,
//                               ),
//                               icon: const Icon(
//                                 Icons.keyboard_arrow_down_rounded,
//                                 color: ColorRes.primary,
//                               ),
//                               items:
//                                   controller.bhkList
//                                       .map(
//                                         (e) => DropdownMenuItem(
//                                           value: e,
//                                           child: Text(
//                                             e,
//                                             style: TextStyle(
//                                               fontSize: AppFontSizes.medium,
//                                               color: ColorRes.textPrimary,
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                       .toList(),
//                               onChanged:
//                                   (val) => controller.selectedBhk.value = val,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       // Budget Range
//                       _buildFieldLabel('Budget Range'),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: controller.minBudget,
//                               keyboardType: TextInputType.number,
//                               style: const TextStyle(
//                                 fontSize: AppFontSizes.small,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: 'Min',
//                                 hintStyle: TextStyle(
//                                   color: Get.theme.colorScheme.onSurface
//                                       .withAlpha(128),
//                                   fontSize: AppFontSizes.bodyMedium,
//                                   fontWeight: AppFontWeights.regular,
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.currency_rupee,
//                                   color: ColorRes.primary,
//                                   size: 18,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                   horizontal: 10,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     width: 0.8,
//                                     color: ColorRes.grey.withOpacity(0.3),
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     width: 1.2,
//                                     color: ColorRes.primary,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: ColorRes.white,
//                               ),
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             child: Text(
//                               'to',
//                               style: TextStyle(
//                                 color: ColorRes.textSecondary,
//                                 fontWeight: AppFontWeights.medium,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: TextField(
//                               controller: controller.maxBudget,
//                               keyboardType: TextInputType.number,
//                               style: const TextStyle(
//                                 fontSize: AppFontSizes.small,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: 'Max',
//                                 hintStyle: TextStyle(
//                                   color: Get.theme.colorScheme.onSurface
//                                       .withAlpha(128),
//                                   fontSize: AppFontSizes.bodyMedium,
//                                   fontWeight: AppFontWeights.regular,
//                                 ),
//                                 prefixIcon: const Icon(
//                                   Icons.currency_rupee,
//                                   color: ColorRes.primary,
//                                   size: 18,
//                                 ),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                   horizontal: 10,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                     width: 0.8,
//                                     color: ColorRes.grey.withOpacity(0.3),
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: const BorderSide(
//                                     width: 1.2,
//                                     color: ColorRes.primary,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: ColorRes.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Footer Buttons
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: ColorRes.white,
//                   border: Border(
//                     top: BorderSide(
//                       color: ColorRes.grey.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {
//                           controller.resetTheForm();
//                         },
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           side: const BorderSide(color: ColorRes.primary),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.medium,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       flex: 2,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             controller.findProperties();
//                           } else {
//                             print("Form is not valid");
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorRes.primary,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.search, size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               'Find Properties',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.medium,
//                                 fontWeight: AppFontWeights.semiBold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//     barrierDismissible: true,
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class HomeScreen extends StatefulWidget {
  final List<Map<String, String>> propertyTypes;

  const HomeScreen({
    super.key,
    this.propertyTypes = const [
      {
        "title": "Apartment",
        "image":
            "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=600&q=80",
      },
      {
        "title": "Villa",
        "image":
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=600&q=80",
      },
      {
        "title": "Plot",
        "image":
            "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=600&q=80",
      },
      {
        "title": "Office",
        "image":
            "https://img.etimg.com/thumb/width-1200,height-1200,imgsize-76402,resizemode-75,msid-111456711/industry/services/property-/-cstruction/india-office-property-market-surges-with-record-gross-leasing-in-2024-first-half.jpg",
      },
      {
        "title": "Retail Shop",
        "image":
            "https://5.imimg.com/data5/XH/NE/SW/SELLER-48886426/shop-for-sale-in-jaipur-commercial.jpg",
      },
      {
        "title": "Showroom",
        "image":
            "https://www.99acres.com/microsite/articles/files/2022/08/showroom.jpg",
      },
      {
        "title": "Warehouse",
        "image":
            "https://3.imimg.com/data3/SR/MV/MY-12088584/warehouses-for-sale-500x500.jpg",
      },
      {
        "title": "Other",
        "image":
            "https://www.ashwinshethgroup.com/wp-content/uploads/2022/11/Commercial-property-buying-guidelines-1400x700-1.webp",
      },
    ],
  });

  // Static data
  static final List<String> images = [
    IMGRes.home1,
    IMGRes.home2,
    IMGRes.home3,
    IMGRes.home4,
  ];

  static final List<String> banners = [
    IMGRes.project_1,
    IMGRes.project_2,
    IMGRes.project_3,
    IMGRes.project_4,
    IMGRes.project_5,
    IMGRes.project_6,
    IMGRes.project_1,
  ];

  static final List<Map<String, dynamic>> shops = [
    {
      "image": IMGRes.shop1,
      "name": "Retail Space",
      "opacity": Color(0xFFFDF6E4),
    },
    {
      "image": IMGRes.shop2,
      "name": "Office Space",
      "opacity": Color(0xFFE4F4FD),
    },
    {"image": IMGRes.shop3, "name": "Land", "opacity": Color(0xFFE7FDE4)},
    {"image": IMGRes.shop4, "name": "Warehouses", "opacity": Color(0xFFEAE4FD)},
    {
      "image": IMGRes.shop1,
      "name": "Commercial Space",
      "opacity": Color(0xFFFDE4E4),
    },
  ];

  static final List<Map<String, dynamic>> furnishedType = [
    {"image": IMGRes.furnished, "name": "Fully Furnished"},
    {"image": IMGRes.semiFurnished, "name": "Semi Furnished"},
    {"image": IMGRes.unFurnished, "name": "Unfurnished"},
  ];

  static final List<Color> softColors = [
    Color(0xFFFDE4E4),
    Color(0xFFFDF6E4),
    Color(0xFFE4F4FD),
    Color(0xFFE7FDE4),
    Color(0xFFEAE4FD),
  ];

  static final List<String> plots = [IMGRes.plot1, IMGRes.plot2, IMGRes.plot3];

  static final List<Map<String, String>> bhk = [
    {"image": IMGRes.bhk1, "title": "1 BHK"},
    {"image": IMGRes.bhk2, "title": "2 BHK"},
    {"image": IMGRes.bhk3, "title": "3 BHK"},
    {"image": IMGRes.home1, "title": "4 BHK"},
    {"image": IMGRes.home2, "title": "5+ BHK"},
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers - Lazy initialization with Get.put and proper dependency management
  late final PropertyController propertyController;
  late final PropertyFavoriteController favoriteController;
  late final NewsController newsController;
  late final TrendingCityController trendingCityController;
  late final MicController micController;
  late final GoogleMapSearchController googleMapController;
  late final BuyerProfileDataController profileController;
  late final SharePropertyController propertyShareController;
  late final RecommendedPropertyController recommendedPropertyController;
  late final PropertyFilterControllerForFilter propertyFilterController;
  late final PlatformServicesController platformServicesController;
  late final TopContractorsController contractorServiceController;
  late final ProjectWizardController projectController;
  late final PlatformReviewController reviewController;
  late final TopSellerController topSellerController;
  late final CompareManager compareManager;
  late final TopCategoryController topCategoryController;

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupCityChangeListener();
  }

  void _initializeControllers() {
    // Initialize all controllers
    propertyController = Get.put(PropertyController());
    favoriteController = Get.find<PropertyFavoriteController>();
    newsController = Get.put(NewsController());
    trendingCityController = Get.put(TrendingCityController());
    micController = Get.put(MicController());
    googleMapController = Get.put(GoogleMapSearchController(), tag: 'city');
    profileController = Get.put(BuyerProfileDataController());
    propertyShareController = Get.put(SharePropertyController());
    recommendedPropertyController = Get.put(RecommendedPropertyController());
    propertyFilterController = Get.put(PropertyFilterControllerForFilter());
    platformServicesController = Get.put(PlatformServicesController());
    contractorServiceController = Get.put(TopContractorsController());
    projectController = Get.put(ProjectWizardController(isBuilderView: false));
    reviewController = Get.put(
      PlatformReviewController(
        type: ['site', 'seller', 'reseller', 'contractor'],
      ),
    );
    topSellerController = Get.put(TopSellerController());
    compareManager = Get.put(CompareManager(), permanent: true);
    topCategoryController = Get.put(TopCategoryController());
  }

  void _setupCityChangeListener() {
    ever(propertyController.selectedCity, (_) {
      if (mounted) {
        setState(() {
          selectedIndex = -1;
        });
        debugPrint("🔄 City changed, property type selection reset");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());

    return Scaffold(
      backgroundColor: ColorRes.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  _buildContent(),
                  _buildFindPropertyButton(),
                ],
              ),
            ),
            const UnifiedComparisonFloatingButton(bottom: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _loadInitialData() async {
    try {
      final user = await SecureStorage.getUserData();
      debugPrint("User Data: ${user?.toJson()}");

      if (user?.user?.id != null) {
        await Future.wait([
          favoriteController.getFavorite(user?.user?.id ?? ''),
          propertyController.getRecommendedPropertyById(user?.user?.id ?? ''),
          profileController.getUserProfile(),
        ]);
      }

      log("home city ${propertyController.selectedCity.value}");
      propertyController.fetchTradingArea(
        propertyController.selectedCity.value,
      );
      projectController.cityAssign(propertyController.selectedCity.value);
    } catch (e) {
      debugPrint("Error loading initial data: $e");
    }
  }

  Widget _buildHeader() {
    return Obx(
      () => HomeHeader(
        image: profileController.userProfile.value?.profilePic ?? '',
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertyTypeSelector(),
        const SizedBox(height: 10),
        _buildNewlyAddedProperties(),
        _buildRecommendedProperties(),
        _buildCitySection(),
        _buildExploreProjects(),
        const SizedBox(height: 20),
        _buildFurnishingTypeSection(),
        _buildTopProperties(),
        _buildTopProjectsInCity(),
        _buildRecommendedSellers(),
        _buildTopContractors(),
        _buildTopCategories(),
        _buildPlatformServices(),
        _buildNewsAndArticles(),
        const SizedBox(height: 20),
        _buildWhyChooseUs(),
        _buildReviewsAndTestimonials(),
      ],
    );
  }

  Widget _buildPropertyTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.propertyTypes.length,
          (index) => _buildPropertyTypeItem(index),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeItem(int index) {
    final type = widget.propertyTypes[index];
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onPropertyTypeSelected(index, type),
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 8 : 2,
            right: index == widget.propertyTypes.length - 1 ? 8 : 0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPropertyTypeIcon(type, isSelected),
              const SizedBox(height: 8),
              _buildPropertyTypeLabel(type, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeIcon(Map<String, String> type, bool isSelected) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ClipOval(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/logo/Avant.jpg',
            image: type['image'] ?? '',
            fit: BoxFit.cover,
            imageErrorBuilder:
                (context, error, stackTrace) => Icon(
                  Icons.home_work_rounded,
                  color: ColorRes.leadGreyColor.shade400,
                  size: 32,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeLabel(Map<String, String> type, bool isSelected) {
    return SizedBox(
      width: 76,
      child: Text(
        type['title'] ?? '',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          fontWeight:
              isSelected ? AppFontWeights.semiBold : AppFontWeights.medium,
          color: isSelected ? ColorRes.primary : ColorRes.black,
          letterSpacing: 0.4,
          height: 1.2,
        ),
      ),
    );
  }

  void _onPropertyTypeSelected(int index, Map<String, String> type) {
    final filterValue = type['title']!.toLowerCase().replaceAll(" ", "_");
    final filterKey = (filterValue == "pg") ? "listingType" : "propertyType";

    propertyController.applyFilter(filterKey, filterValue);
    projectController.applyFilter(filterKey, filterValue);

    setState(() {
      selectedIndex = index;
    });

    debugPrint("Selected: ${type['title']}");
  }

  // Widget _buildNewlyAddedProperties() {
  //   return Obx(() {
  //     if (propertyController.isLoading.value && propertyController.items.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     final activeProperties = propertyController.items.value
  //         .where((e) => e.approvalStatus == "approved")
  //         .toList();
  //
  //     if (propertyController.isRefreshing.value) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (activeProperties.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         TitleWithViewAll(
  //           title: "Newly added properties",
  //           showViewAll: true,
  //           onViewAll: () => Get.to(() => PropertyDetail()),
  //         ),
  //         const SizedBox(height: 12),
  //         _buildHorizontalPropertyList(activeProperties),
  //       ],
  //     );
  //   });
  // }

  Widget _buildNewlyAddedProperties() {
    return Obx(() {
      if (propertyController.isLoading.value &&
          propertyController.items.isEmpty) {
        return Column(
          children: [
            TitleWithViewAll(
              title: "Newly added properties",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const HorizontalPropertyListShimmer(),
            // ✅ Shimmer instead of spinner
          ],
        );
      }

      final activeProperties =
          propertyController.items.value
              .where((e) => e.approvalStatus == "approved")
              .toList();

      if (propertyController.isRefreshing.value) {
        return const HorizontalPropertyListShimmer(); // ✅ Shimmer for refresh
      }

      if (activeProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          TitleWithViewAll(
            title: "Newly added properties",
            showViewAll: true,
            onViewAll: () => Get.to(() => PropertyDetail()),
          ),
          const SizedBox(height: 12),
          _buildHorizontalPropertyList(activeProperties),
        ],
      );
    });
  }

  // Widget _buildRecommendedProperties() {
  //   return Obx(() {
  //     if (propertyController.apiLoading.value &&
  //         propertyController.recommendedProperties.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (propertyController.recommendedProperties.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(height: 12),
  //         const TitleWithViewAll(title: "Recommended Properties"),
  //         const SizedBox(height: 4),
  //         _buildHorizontalPropertyList(propertyController.recommendedProperties),
  //       ],
  //     );
  //   });
  // }

  Widget _buildRecommendedProperties() {
    return Obx(() {
      if (propertyController.apiLoading.value &&
          propertyController.recommendedProperties.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const TitleWithViewAll(title: "Recommended Properties"),
            const SizedBox(height: 4),
            const HorizontalPropertyListShimmer(), // ✅ Shimmer
          ],
        );
      }

      if (propertyController.recommendedProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const TitleWithViewAll(title: "Recommended Properties"),
          const SizedBox(height: 4),
          _buildHorizontalPropertyList(
            propertyController.recommendedProperties,
          ),
        ],
      );
    });
  }

  Widget _buildHorizontalPropertyList(List<dynamic> properties) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SizedBox(
        height: 310,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge && metrics.pixels != 0) {
              propertyController.loadMore();
            }
            return false;
          },
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final data = properties[index];
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: PropertyCard(property: data),
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildCitySection() {
  //   return Obx(() {
  //     if (trendingCityController.isLoading.value &&
  //         trendingCityController.allTrendingCities.isNotEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (trendingCityController.allTrendingCities.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 20),
  //         TitleWithViewAll(
  //           title: "City",
  //           showViewAll: true,
  //           onViewAll: () => Get.to(() => const MumbaiProjectsScreen()),
  //         ),
  //         const SizedBox(height: 12),
  //         const CityFilterList(),
  //       ],
  //     );
  //   });
  // }

  Widget _buildCitySection() {
    return Obx(() {
      if (trendingCityController.isLoading.value &&
          trendingCityController.allTrendingCities.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 20),
            TitleWithViewAll(title: "City", showViewAll: false),
            const SizedBox(height: 12),
            const CityFilterListShimmer(), // ✅ Shimmer
          ],
        );
      }

      if (trendingCityController.allTrendingCities.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          TitleWithViewAll(
            title: "City",
            showViewAll: true,
            onViewAll: () => Get.to(() => const MumbaiProjectsScreen()),
          ),
          const SizedBox(height: 12),
          const CityFilterList(),
        ],
      );
    });
  }

  // Widget _buildExploreProjects() {
  //   return Obx(() {
  //     if (projectController.isLoading.value && projectController.items.isNotEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     final activeProjects = projectController.items
  //         .where((element) => element.approvalStatus == "approved")
  //         .toList();
  //
  //     if (activeProjects.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 20),
  //         TitleWithViewAll(
  //           title: "Explore Projects",
  //           showViewAll: true,
  //           onViewAll: () => Get.to(() => AllProjectListScreen()),
  //         ),
  //         const SizedBox(height: 12),
  //         _buildProjectList(activeProjects),
  //       ],
  //     );
  //   });
  // }

  Widget _buildExploreProjects() {
    return Obx(() {
      if (projectController.isLoading.value &&
          projectController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 20),
            TitleWithViewAll(title: "Explore Projects", showViewAll: false),
            const SizedBox(height: 12),
            const ProjectListShimmer(), // ✅ Shimmer
          ],
        );
      }

      final activeProjects =
          projectController.items
              .where((element) => element.approvalStatus == "approved")
              .toList();

      if (activeProjects.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          TitleWithViewAll(
            title: "Explore Projects",
            showViewAll: true,
            onViewAll: () => Get.to(() => AllProjectListScreen()),
          ),
          const SizedBox(height: 12),
          _buildProjectList(activeProjects),
        ],
      );
    });
  }

  Widget _buildProjectList(List<ProjectItem> projects) {
    return SizedBox(
      height: 256,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final data = projects[index];
          return GestureDetector(
            onTap: () => Get.to(() => ProjectDetailsScreen(projectItem: data)),
            child: BuilderProjectCard(
              forHome: true,
              project: data,
              width: 250,
              height: 150,
              developersName: data.projectContactInfo?.name ?? 'Unknown',
              imageUrl:
                  (data.mediaGallery?.images?.isNotEmpty ?? false)
                      ? data.mediaGallery!.images.first
                      : IMGRes.home3,
              projectName:
                  data.projectName.isNotEmpty ? data.projectName : 'N/A',
              location:
                  data.address.isNotEmpty ? data.address : 'Not specified',
              price: data.getPriceRange(),
              propertySize: data.projectSize?.totalBuildings?.toString() ?? '—',
            ),
          );
        },
      ),
    );
  }

  Widget _buildFurnishingTypeSection() {
    return Column(
      children: [
        const TitleWithViewAll(title: "Explore by furnishing type"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: List.generate(
                HomeScreen.furnishedType.length,
                (index) => _buildFurnishingTypeCard(index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFurnishingTypeCard(int index) {
    final furnished = HomeScreen.furnishedType[index];
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _onFurnishingTypeSelected(furnished),
        child: NesticoPeCardWithText(
          height: 120,
          width: 200,
          imageUrl: furnished["image"]!,
          title: furnished["name"]!,
          opacity: ColorRes.black,
        ),
      ),
    );
  }

  void _onFurnishingTypeSelected(Map<String, dynamic> furnished) {
    setState(() {
      if (furnished['name'] == 'Fully Furnished') {
        propertyFilterController.rentFurnishing.value = 'fully-furnished';
      } else if (furnished['name'] == 'Semi Furnished') {
        propertyFilterController.rentFurnishing.value = 'semi-furnished';
      } else if (furnished['name'] == "Unfurnished") {
        propertyFilterController.rentFurnishing.value = 'unfurnished';
      }

      Get.to(
        () => PropertyDetail(
          filters: [
            {'furnish_type': propertyFilterController.rentFurnishing.value},
          ],
        ),
      );
    });
  }

  // Widget _buildTopProperties() {
  //   return Obx(() {
  //     if (propertyController.isLoading.value &&
  //         propertyController.topProperties.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     final activeTopProperties = propertyController.topProperties
  //         .where((element) => element.approvalStatus == "approved")
  //         .toList();
  //
  //     if (activeTopProperties.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 8),
  //         TitleWithViewAll(
  //           title: "Top properties in ${propertyController.selectedCity.value}",
  //           showViewAll: true,
  //           onViewAll: () => Get.to(() => PropertyDetail()),
  //         ),
  //         const SizedBox(height: 12),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12),
  //           child: SizedBox(
  //             height: 310,
  //             child: ListView.separated(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: activeTopProperties.length,
  //               separatorBuilder: (_, __) => const SizedBox(width: 12),
  //               itemBuilder: (context, index) {
  //                 final data = activeTopProperties[index];
  //                 return MediaQuery(
  //                   data: MediaQuery.of(context).copyWith(
  //                     textScaler: const TextScaler.linear(1.0),
  //                   ),
  //                   child: TopPropertyCard(property: data),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   });
  // }

  Widget _buildTopProperties() {
    return Obx(() {
      if (propertyController.isLoading.value &&
          propertyController.topProperties.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 8),
            TitleWithViewAll(
              title:
                  "Top properties in ${propertyController.selectedCity.value}",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const HorizontalPropertyListShimmer(), // ✅ Shimmer
          ],
        );
      }

      final activeTopProperties =
          propertyController.topProperties
              .where((element) => element.approvalStatus == "approved")
              .toList();

      if (activeTopProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 8),
          TitleWithViewAll(
            title: "Top properties in ${propertyController.selectedCity.value}",
            showViewAll: true,
            onViewAll: () => Get.to(() => PropertyDetail()),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 310,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activeTopProperties.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final data = activeTopProperties[index];
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: TopPropertyCard(property: data),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  // Widget _buildTopProjectsInCity() {
  //   return Obx(() {
  //     if (projectController.isLoading.value && projectController.topProjects.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     final activeTopProjects = projectController.topProjects
  //         .where((element) => element.approvalStatus == "approved")
  //         .toList();
  //
  //     if (activeTopProjects.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 8),
  //         TitleWithViewAll(
  //           title: "Top Project in ${projectController.selectedCity.value}",
  //           showViewAll: true,
  //           onViewAll: () => Get.to(() => PropertyDetail()),
  //         ),
  //         const SizedBox(height: 12),
  //         _buildProjectList(activeTopProjects),
  //       ],
  //     );
  //   });
  // }

  Widget _buildTopProjectsInCity() {
    return Obx(() {
      if (projectController.isLoading.value &&
          projectController.topProjects.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 8),
            TitleWithViewAll(
              title: "Top Project in ${projectController.selectedCity.value}",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const ProjectListShimmer(), // ✅ Shimmer
          ],
        );
      }

      final activeTopProjects =
          projectController.topProjects
              .where((element) => element.approvalStatus == "approved")
              .toList();

      if (activeTopProjects.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 8),
          TitleWithViewAll(
            title: "Top Project in ${projectController.selectedCity.value}",
            showViewAll: true,
            onViewAll: () => Get.to(() => PropertyDetail()),
          ),
          const SizedBox(height: 12),
          _buildProjectList(activeTopProjects),
        ],
      );
    });
  }

  // Widget _buildRecommendedSellers() {
  //   return Obx(() {
  //     if (topSellerController.isLoading.value && topSellerController.items.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (topSellerController.items.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 8),
  //         const TitleWithViewAll(title: "Recommended Sellers"),
  //         const SizedBox(height: 12),
  //         SellerListWidget(topSeller: topSellerController.items),
  //       ],
  //     );
  //   });
  // }

  Widget _buildRecommendedSellers() {
    return Obx(() {
      if (topSellerController.isLoading.value &&
          topSellerController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 8),
            const TitleWithViewAll(title: "Recommended Sellers"),
            const SizedBox(height: 12),
            const SellerListShimmer(), // ✅ Shimmer
          ],
        );
      }

      if (topSellerController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 8),
          const TitleWithViewAll(title: "Recommended Sellers"),
          const SizedBox(height: 12),
          SellerListWidget(topSeller: topSellerController.items),
        ],
      );
    });
  }

  // Widget _buildTopContractors() {
  //   return Obx(() {
  //     if (contractorServiceController.isLoading.value &&
  //         contractorServiceController.items.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (contractorServiceController.items.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 20),
  //         const TitleWithViewAll(title: "Top Contractors", showViewAll: false),
  //         const SizedBox(height: 6),
  //         SizedBox(
  //           height: 250,
  //           child: ListView.separated(
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             separatorBuilder: (context, index) => const SizedBox(width: 12),
  //             scrollDirection: Axis.horizontal,
  //             itemCount: contractorServiceController.items.length,
  //             itemBuilder: (context, index) {
  //               final data = contractorServiceController.items[index];
  //               return SizedBox(
  //                 width: 300,
  //                 child: ContractorCard(contractor: data),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     );
  //   });
  // }

  Widget _buildTopContractors() {
    return Obx(() {
      if (contractorServiceController.isLoading.value &&
          contractorServiceController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 20),
            const TitleWithViewAll(
              title: "Top Contractors",
              showViewAll: false,
            ),
            const SizedBox(height: 6),
            const ContractorCardShimmer(), // ✅ Shimmer
          ],
        );
      }

      if (contractorServiceController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          const TitleWithViewAll(title: "Top Contractors", showViewAll: false),
          const SizedBox(height: 6),
          SizedBox(
            height: 250,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              scrollDirection: Axis.horizontal,
              itemCount: contractorServiceController.items.length,
              itemBuilder: (context, index) {
                final data = contractorServiceController.items[index];
                return SizedBox(
                  width: 300,
                  child: ContractorCard(contractor: data),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // Widget _buildTopCategories() {
  //   return Obx(() {
  //     if (topCategoryController.isLoading.value &&
  //         topCategoryController.categories.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (topCategoryController.categories.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 20),
  //         const TitleWithViewAll(title: "Top Categories", showViewAll: false),
  //         const SizedBox(height: 12),
  //         TopCategoriesSection(categories: topCategoryController.categories),
  //       ],
  //     );
  //   });
  // }

  Widget _buildTopCategories() {
    return Obx(() {
      if (topCategoryController.isLoading.value &&
          topCategoryController.categories.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 20),
            const TitleWithViewAll(title: "Top Categories", showViewAll: false),
            const SizedBox(height: 12),
            const TopCategoriesShimmer(), // ✅ Shimmer
          ],
        );
      }

      if (topCategoryController.categories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          const TitleWithViewAll(title: "Top Categories", showViewAll: false),
          const SizedBox(height: 12),
          TopCategoriesSection(categories: topCategoryController.categories),
        ],
      );
    });
  }

  // Widget _buildPlatformServices() {
  //   return Obx(() {
  //     if (platformServicesController.isLoading.value &&
  //         platformServicesController.items.isEmpty) {
  //       return const Center(child: CircularProgressIndicator());
  //     }
  //
  //     if (platformServicesController.items.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 12),
  //         const TitleWithViewAll(title: "Platform Services", showViewAll: false),
  //         const SizedBox(height: 12),
  //         PlatformServiceHorizontalList(services: platformServicesController.items),
  //       ],
  //     );
  //   });
  // }

  Widget _buildPlatformServices() {
    return Obx(() {
      if (platformServicesController.isLoading.value &&
          platformServicesController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 12),
            const TitleWithViewAll(
              title: "Platform Services",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const PlatformServiceShimmer(), // ✅ Shimmer
          ],
        );
      }

      if (platformServicesController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 12),
          const TitleWithViewAll(
            title: "Platform Services",
            showViewAll: false,
          ),
          const SizedBox(height: 12),
          PlatformServiceHorizontalList(
            services: platformServicesController.items,
          ),
        ],
      );
    });
  }

  // Widget _buildNewsAndArticles() {
  //   return Obx(() {
  //     if (newsController.items.isEmpty) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Column(
  //       children: [
  //         const SizedBox(height: 20),
  //         const TitleWithViewAll(title: "News & Articles", showViewAll: false),
  //         const SizedBox(height: 12),
  //         newsController.isLoading.value && newsController.items.isEmpty
  //             ? const Center(child: CircularProgressIndicator())
  //             : NewsAndArticles(articles: newsController.items),
  //         const SizedBox(height: 20),
  //       ],
  //     );
  //   });
  // }

  Widget _buildNewsAndArticles() {
    return Obx(() {
      if (newsController.isLoading.value && newsController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 20),
            const TitleWithViewAll(
              title: "News & Articles",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const NewsArticlesShimmer(), // ✅ Shimmer
            const SizedBox(height: 20),
          ],
        );
      }

      if (newsController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          const TitleWithViewAll(title: "News & Articles", showViewAll: false),
          const SizedBox(height: 12),
          NewsAndArticles(articles: newsController.items),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildWhyChooseUs() {
    return Column(
      children: [
        const TitleWithViewAll(title: "Why Choose Us", showViewAll: false),
        const SizedBox(height: 12),
        WhyChooseUsSection(),
      ],
    );
  }

  Widget _buildReviewsAndTestimonials() {
    return Obx(() {
      if (reviewController.isLoading.value &&
          reviewController.allReviews.isEmpty) {
        return const ReviewsTestimonialsShimmer(); // ✅ Shimmer
      }

      if (reviewController.allReviews.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 20),
          const TitleWithViewAll(
            title: "Reviews & Testimonials",
            showViewAll: false,
          ),
          const SizedBox(height: 12),
          ReviewsAndTestimonials(),
          SizedBox(height: AppSpacing.medium),
        ],
      );
    });
  }

  Widget _buildFindPropertyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        onPressed:
            () => showFindPropertyDialog(
              propertyController,
              googleMapController,
              context,
            ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text("Find Your Property"),
      ),
    );
  }
}

// Helper widget for field labels
Widget _buildFieldLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: AppFontSizes.medium,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textPrimary,
    ),
  );
}

// Find Property Dialog
Future<void> showFindPropertyDialog(
  PropertyController controller,
  GoogleMapSearchController googleMapController,
  BuildContext context,
) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Get.dialog(
    Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              _buildDialogContent(controller, googleMapController, context),
              _buildDialogFooter(controller, formKey),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

Widget _buildDialogHeader() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: const BoxDecoration(
      color: ColorRes.primary,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            "Find Your Dream Property",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.white,
            ),
          ),
        ),
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(50),
          child: const Icon(
            Icons.close_rounded,
            color: ColorRes.white,
            size: 20,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDialogContent(
  PropertyController controller,
  GoogleMapSearchController googleMapController,
  BuildContext context,
) {
  return Flexible(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel("City"),
          const SizedBox(height: 10),
          CitySelectionWidget(
            isEditing: true,
            controller: controller.selectedCityZ,
            color: ColorRes.primary,
            fillColor: ColorRes.white,
            onCitySelected: (selectedCity) {
              debugPrint("✅ Selected city: ${selectedCity.description}");
              controller.selectedCityZ.text = selectedCity.description ?? '';
            },
          ),
          const SizedBox(height: 16),
          _buildListingTypeDropdown(controller),
          const SizedBox(height: 12),
          _buildBHKDropdown(controller),
          const SizedBox(height: 12),
          _buildBudgetRange(controller),
        ],
      ),
    ),
  );
}

Widget _buildListingTypeDropdown(PropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildFieldLabel('Listing Type'),
      const SizedBox(height: 8),
      Obx(
        () => DropdownButtonFormField<String>(
          value:
              controller.listingTypes.contains(
                    controller.selectedListingType.value,
                  )
                  ? controller.selectedListingType.value
                  : null,
          isDense: true,
          isExpanded: true,
          decoration: _getDropdownDecoration('Select', Icons.category_outlined),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorRes.primary,
          ),
          items:
              controller.listingTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: (val) => controller.selectedListingType.value = val,
        ),
      ),
    ],
  );
}

Widget _buildBHKDropdown(PropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildFieldLabel('BHK'),
      const SizedBox(height: 8),
      Obx(
        () => DropdownButtonFormField<String>(
          value:
              controller.bhkList.contains(controller.selectedBhk.value)
                  ? controller.selectedBhk.value
                  : null,
          isDense: true,
          isExpanded: true,
          decoration: _getDropdownDecoration('Select', Icons.home_outlined),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorRes.primary,
          ),
          items:
              controller.bhkList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: (val) => controller.selectedBhk.value = val,
        ),
      ),
    ],
  );
}

Widget _buildBudgetRange(PropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildFieldLabel('Budget Range'),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.minBudget,
              keyboardType: TextInputType.number,
              decoration: _getTextFieldDecoration('Min'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'to',
              style: TextStyle(fontWeight: AppFontWeights.medium),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.maxBudget,
              keyboardType: TextInputType.number,
              decoration: _getTextFieldDecoration('Max'),
            ),
          ),
        ],
      ),
    ],
  );
}

InputDecoration _getDropdownDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Get.theme.colorScheme.onSurface.withAlpha(128),
      fontSize: AppFontSizes.bodyMedium,
    ),
    prefixIcon: Icon(icon, color: ColorRes.primary, size: 20),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorRes.primary, width: 1.2),
    ),
    filled: true,
    fillColor: ColorRes.white,
  );
}

InputDecoration _getTextFieldDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Get.theme.colorScheme.onSurface.withAlpha(128),
      fontSize: AppFontSizes.bodyMedium,
    ),
    prefixIcon: const Icon(
      Icons.currency_rupee,
      color: ColorRes.primary,
      size: 18,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorRes.primary, width: 1.2),
    ),
    filled: true,
    fillColor: ColorRes.white,
  );
}

Widget _buildDialogFooter(
  PropertyController controller,
  GlobalKey<FormState> formKey,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: ColorRes.white,
      border: Border(top: BorderSide(color: ColorRes.grey.withOpacity(0.2))),
    ),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => controller.resetTheForm(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: ColorRes.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorRes.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.findProperties();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 20),
                SizedBox(width: 8),
                Text('Find Properties'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class CityDropdown extends StatefulWidget {
  const CityDropdown({super.key});

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  final List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
  ];

  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorRes.white,
        ),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            // Remove borders
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: selectedCity,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorRes.leadGreyColor,
          ),
          // Custom arrow icon
          items:
              cities.map((String city) {
                return DropdownMenuItem<String>(value: city, child: Text(city));
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCity = newValue!;
            });
          },
        ),
      ),
    );
  }
}

class ReviewsAndTestimonials extends StatelessWidget {
  const ReviewsAndTestimonials({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.find<PlatformReviewController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          // Show loading indicator
          if (reviewController.isLoading.value &&
              reviewController.siteReviewWithUsers.isEmpty) {
            return SizedBox(
              height: 280,
              child: Center(
                child: CircularProgressIndicator(color: ColorRes.homeGreenFade),
              ),
            );
          }

          // Show empty state
          if (reviewController.allReviews.isEmpty) {
            return SizedBox(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: ColorRes.leadGreyColor.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews available',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        color: ColorRes.leadGreyColor.shade600,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show reviews list
          return SizedBox(
            height: 215,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reviewController.allReviews.length,
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 12),
              separatorBuilder:
                  (_, __) => const SizedBox(width: AppSpacing.medium),
              itemBuilder: (context, index) {
                // UserItem userData=reviewController.listOfUser.map((element) => element.toMap(),).toString();
                return _buildReviewCard(
                  context,
                  reviewController.allReviews[index],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewCard(BuildContext context, ReviewItem review) {
    final rating = review.rating ?? 0.0;
    final isVerified = review.isVerified ?? false;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with avatar and rating
              Row(
                children: [
                  /// Avatar (placeholder since we don't have reviewer details)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          ColorRes.homeGreenFade.withOpacity(0.08),
                          ColorRes.homeGreenDarkFade.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Color(0xFF2E7D63).withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (review?.entityUser?.username?.isNotEmpty ?? false)
                          ? review!.entityUser!.username![1]
                              .toUpperCase() // ensure uppercase letter
                          : '?', // fallback if username is null/empty
                      style: TextStyle(
                        fontSize: AppFontSizes.large,
                        fontWeight: AppFontWeights.semiBold,
                        color:
                            ColorRes.homeGreenDarkFade, // contrast text color
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Reviewer ID and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${review.entityUser?.username}',
                                      maxLines: 1,

                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.homeBlackFade,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _formatDate(review.createdAt),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.leadGreyColor.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: ColorRes.homeGreenDarkFade,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: ColorRes.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${review.entityType}',
                          maxLines: 1,

                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.regular,
                            color: ColorRes.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(5, (starIndex) {
                              if (starIndex < rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else if (starIndex < rating) {
                                return const Icon(
                                  Icons.star_half,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else {
                                return Icon(
                                  Icons.star_outline,
                                  color: ColorRes.leadGreyColor.shade300,
                                  size: 16,
                                );
                              }
                            }),
                            const SizedBox(width: 8),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.homeBlackFade,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (review.title != null && review.title!.isNotEmpty) ...[
                SizedBox(
                  width: 280,
                  child: Text(
                    review.title!,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.homeBlackFade,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: 280,
                child: Text(
                  '"${review.content ?? 'No review content'}"',
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade700,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get status color

  /// Helper method to get status icon

  /// Helper method to format date
  String _formatDate(String? dateString) {
    if (dateString == null) return 'Recently';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  /// Show review details in a bottom sheet
}

class NewsAndArticles extends StatelessWidget {
  final List<NewsItem> articles;

  const NewsAndArticles({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    // List<NewsItem> articles = [
    //   NewsItem(
    //     id: '1',
    //     createdBy: 'admin',
    //     updatedBy: 'editor',
    //     title: 'Flutter 4.0 Released: What You Need to Know',
    //     slug: 'flutter-4-0-released',
    //     content:
    //         'Flutter 4.0 brings major improvements in performance, desktop support, and tooling...',
    //     summary:
    //         'Flutter 4.0 is here with exciting updates for developers across platforms.',
    //     coverImage: 'https://picsum.photos/800/400?random=1',
    //     category: 'Technology',
    //     tags: ['Flutter', 'Mobile', 'Cross-platform'],
    //     author: 'Jane Doe',
    //     authorDesignation: 'Senior Developer',
    //     readTime: 5,
    //     publishDate: '2025-10-08',
    //     status: 'published',
    //     featured: true,
    //     metaTitle: 'Flutter 4.0 Release Notes',
    //     metaDescription:
    //         'All you need to know about Flutter 4.0 and its features.',
    //     viewCount: 1024,
    //     shareCount: 150,
    //     createdAt: '2025-10-01T12:00:00Z',
    //     updatedAt: '2025-10-05T15:30:00Z',
    //   ),
    //   NewsItem(
    //     id: '2',
    //     createdBy: 'editor',
    //     updatedBy: 'editor',
    //     title: 'Top 10 AI Tools to Boost Productivity in 2025',
    //     slug: 'top-10-ai-tools-2025',
    //     content:
    //         'Artificial Intelligence tools are transforming the way we work. Here are the top 10 AI tools...',
    //     summary:
    //         'Explore the best AI tools for productivity, automation, and innovation in 2025.',
    //     coverImage: 'https://picsum.photos/800/400?random=2',
    //     category: 'Business',
    //     tags: ['AI', 'Productivity', 'Tools'],
    //     author: 'John Smith',
    //     authorDesignation: 'Tech Analyst',
    //     readTime: 7,
    //     publishDate: '2025-09-28',
    //     status: 'published',
    //     featured: false,
    //     metaTitle: 'Top 10 AI Tools in 2025',
    //     metaDescription:
    //         'Discover the most effective AI tools to improve efficiency and productivity.',
    //     viewCount: 2048,
    //     shareCount: 320,
    //     createdAt: '2025-09-25T10:00:00Z',
    //     updatedAt: '2025-09-27T14:45:00Z',
    //   ),
    //   NewsItem(
    //     id: '3',
    //     createdBy: 'admin',
    //     updatedBy: 'admin',
    //     title: 'Climate Change: Global Initiatives and Local Impact',
    //     slug: 'climate-change-global-local',
    //     content:
    //         'Climate change continues to affect communities worldwide. Local initiatives are key to sustainable solutions...',
    //     summary:
    //         'A detailed look at how climate change is tackled globally and locally.',
    //     coverImage: 'https://picsum.photos/800/400?random=3',
    //     category: 'Environment',
    //     tags: ['Climate', 'Environment', 'Sustainability'],
    //     author: 'Alice Green',
    //     authorDesignation: 'Environmental Journalist',
    //     readTime: 6,
    //     publishDate: '2025-10-01',
    //     status: 'draft',
    //     featured: false,
    //     metaTitle: 'Climate Change: Initiatives & Impact',
    //     metaDescription:
    //         'Learn about global and local efforts to combat climate change.',
    //     viewCount: 512,
    //     shareCount: 80,
    //     createdAt: '2025-09-20T09:30:00Z',
    //     updatedAt: '2025-09-30T11:15:00Z',
    //   ),
    // ];

    // Function to check if an article is "new" (published in last 7 days)
    bool isNewArticle(String? publishDate) {
      if (publishDate == null) return false;
      final published = DateTime.tryParse(publishDate);
      if (published == null) return false;
      return DateTime.now().difference(published).inDays <= 7;
    }

    // return SizedBox(
    //   height: 270,
    //   child: ListView.separated(
    //     shrinkWrap: true,
    //     scrollDirection: Axis.horizontal,
    //     padding: const EdgeInsets.symmetric(horizontal: 12),
    //     clipBehavior: Clip.none,
    //     itemCount: articles.length,
    //     separatorBuilder: (_, __) => const SizedBox(width: 12),
    //     itemBuilder: (context, index) {
    //       final article = articles[index];
    //       final isNew = isNewArticle(article.publishDate);
    //       print("Image ------------------> ${article.coverImage}");
    //       return GestureDetector(
    //         onTap: () {
    //           Get.to(() => NewsDetailScreen(newsItem: article));
    //         },
    //         child: Container(
    //           width: 280,
    //           decoration: BoxDecoration(
    //             color: ColorRes.white,
    //             borderRadius: BorderRadius.circular(16),
    //             border: Border.all(
    //               color: ColorRes.leadGreyColor.shade300,
    //               width: 0.5,
    //             ),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               /// Top image section
    //               Stack(
    //                 children: [
    //                   // ClipRRect(
    //                   //   borderRadius: const BorderRadius.vertical(
    //                   //     top: Radius.circular(16),
    //                   //   ),
    //                   //   child: Image.network(
    //                   //     article.coverImage ?? '',
    //                   //     height: 120,
    //                   //     width: double.infinity,
    //                   //     fit: BoxFit.cover,
    //                   //     errorBuilder: (context, error, stackTrace) {
    //                   //       return Container(
    //                   //         height: 120,
    //                   //         color: Colors.grey.shade200,
    //                   //         child: Icon(
    //                   //           Icons.image_not_supported_outlined,
    //                   //           color: Colors.grey.shade400,
    //                   //           size: 32,
    //                   //         ),
    //                   //       );
    //                   //     },
    //                   //   ),
    //                   // ),
    //                   CustomImage(
    //                     type: CustomImageType.network,
    //                     src: article.coverImage,
    //                     height: 120,
    //                     width: double.infinity,
    //                   ),
    //
    //                   /// Category badge
    //                   if (article.category != null)
    //                     Positioned(
    //                       top: 12,
    //                       left: 12,
    //                       child: Container(
    //                         padding: const EdgeInsets.symmetric(
    //                           horizontal: 8,
    //                           vertical: 4,
    //                         ),
    //                         decoration: BoxDecoration(
    //                           color: ColorRes.green,
    //                           borderRadius: BorderRadius.circular(8),
    //                         ),
    //                         child: Text(
    //                           article.category!.capitalize
    //                               .toString()
    //                               .replaceAll("_", " "),
    //                           style: TextStyle(
    //                             color: ColorRes.white,
    //                             fontSize: AppFontSizes.extraSmall,
    //                             fontWeight: AppFontWeights.semiBold,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //
    //                   /// "NEW" badge
    //                   if (isNew)
    //                     Positioned(
    //                       top: 12,
    //                       right: 12,
    //                       child: Container(
    //                         padding: const EdgeInsets.symmetric(
    //                           horizontal: 6,
    //                           vertical: 3,
    //                         ),
    //                         decoration: BoxDecoration(
    //                           color: ColorRes.homeRed,
    //                           borderRadius: BorderRadius.circular(8),
    //                         ),
    //                         child: Text(
    //                           "NEW",
    //                           style: TextStyle(
    //                             color: ColorRes.white,
    //                             fontSize: AppFontSizes.mini,
    //                             fontWeight: AppFontWeights.extraBold,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                 ],
    //               ),
    //
    //               /// Content section
    //               // Expanded(
    //               //   child: Padding(
    //               //     padding: const EdgeInsets.all(16),
    //               //     child: Column(
    //               //       crossAxisAlignment: CrossAxisAlignment.start,
    //               //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               //       children: [
    //               //         Column(
    //               //           crossAxisAlignment: CrossAxisAlignment.start,
    //               //           children: [
    //               //             Text(
    //               //               article.title ?? '',
    //               //               maxLines: 2,
    //               //               overflow: TextOverflow.ellipsis,
    //               //               style: TextStyle(
    //               //                 fontSize: AppFontSizes.medium,
    //               //                 fontWeight: AppFontWeights.bold,
    //               //                 color: ColorRes.homeBlackFade,
    //               //               ),
    //               //             ),
    //               //             const SizedBox(height: 6),
    //               //             Text(
    //               //               article.summary ?? '',
    //               //               maxLines: 2,
    //               //               overflow: TextOverflow.ellipsis,
    //               //               style: TextStyle(
    //               //                 fontSize: AppFontSizes.caption,
    //               //                 color: Colors.grey.shade600,
    //               //               ),
    //               //             ),
    //               //           ],
    //               //         ),
    //               //
    //               //         /// Footer: author + read time + arrow
    //               //         Row(
    //               //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               //           children: [
    //               //             Expanded(
    //               //               child: Column(
    //               //                 crossAxisAlignment: CrossAxisAlignment.start,
    //               //                 children: [
    //               //                   Text(
    //               //                     article.author ?? '',
    //               //                     style: TextStyle(
    //               //                       fontSize: AppFontSizes.caption,
    //               //                       color: ColorRes.leadGreyColor.shade700,
    //               //                       fontWeight: AppFontWeights.medium,
    //               //                     ),
    //               //                     overflow: TextOverflow.ellipsis,
    //               //                   ),
    //               //                   const SizedBox(height: 2),
    //               //                   Text(
    //               //                     '${article.readTime ?? 0} min read',
    //               //                     style: TextStyle(
    //               //                       fontSize: AppFontSizes.extraSmall,
    //               //                       color: ColorRes.leadGreyColor.shade500,
    //               //                     ),
    //               //                   ),
    //               //                 ],
    //               //               ),
    //               //             ),
    //               //             Container(
    //               //               padding: const EdgeInsets.all(6),
    //               //               decoration: BoxDecoration(
    //               //                 color: ColorRes.homeGreenFade.withOpacity(
    //               //                   0.1,
    //               //                 ),
    //               //                 borderRadius: BorderRadius.circular(8),
    //               //               ),
    //               //               child: const Icon(
    //               //                 Icons.arrow_forward_ios,
    //               //                 size: 12,
    //               //                 color: ColorRes.homeGreenFade,
    //               //               ),
    //               //             ),
    //               //           ],
    //               //         ),
    //               //       ],
    //               //     ),
    //               //   ),
    //               // ),
    //               Expanded(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(24),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             article.title ?? '',
    //                             maxLines: 2,
    //                             overflow: TextOverflow.ellipsis,
    //                             style: const TextStyle(
    //                               fontSize: 20,
    //                               fontWeight: FontWeight.w600,
    //                               color: Colors.white,
    //                               height: 1.3,
    //                             ),
    //                           ),
    //                           const SizedBox(height: 12),
    //                           Text(
    //                             article.summary ?? '',
    //                             maxLines: 2,
    //                             overflow: TextOverflow.ellipsis,
    //                             style: TextStyle(
    //                               fontSize: 14,
    //                               color: Colors.grey.shade400,
    //                               height: 1.4,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //
    //                       /// Footer: author info and stats
    //                       Row(
    //                         children: [
    //                           // Author avatar
    //                           Container(
    //                             width: 40,
    //                             height: 40,
    //                             decoration: BoxDecoration(
    //                               color: Colors.grey.shade700,
    //                               shape: BoxShape.circle,
    //                             ),
    //                             child: const Icon(
    //                               Icons.person,
    //                               color: Colors.white,
    //                               size: 20,
    //                             ),
    //                           ),
    //                           const SizedBox(width: 12),
    //                           // Author name and date
    //                           Expanded(
    //                             child: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text(
    //                                   article.author ?? '',
    //                                   style: const TextStyle(
    //                                     fontSize: 14,
    //                                     color: Colors.white,
    //                                     fontWeight: FontWeight.w600,
    //                                   ),
    //                                   overflow: TextOverflow.ellipsis,
    //                                 ),
    //                                 const SizedBox(height: 2),
    //                                 Text(
    //                                   _formatDate(article.publishDate),
    //                                   style: TextStyle(
    //                                     fontSize: 12,
    //                                     color: Colors.grey.shade500,
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           const SizedBox(width: 16),
    //                           // Stats
    //                           Row(
    //                             children: [
    //                               Icon(
    //                                 Icons.access_time_rounded,
    //                                 size: 16,
    //                                 color: Colors.grey.shade500,
    //                               ),
    //                               const SizedBox(width: 4),
    //                               Text(
    //                                 '${article.readTime ?? 0} min read',
    //                                 style: TextStyle(
    //                                   fontSize: 12,
    //                                   color: Colors.grey.shade500,
    //                                 ),
    //                               ),
    //                               const SizedBox(width: 16),
    //                               Icon(
    //                                 Icons.remove_red_eye_outlined,
    //                                 size: 16,
    //                                 color: Colors.grey.shade500,
    //                               ),
    //                               const SizedBox(width: 4),
    //                               Text(
    //                                 _formatViewCount(article.viewCount ?? 0),
    //                                 style: TextStyle(
    //                                   fontSize: 12,
    //                                   color: Colors.grey.shade500,
    //                                 ),
    //                               ),
    //                               const SizedBox(width: 16),
    //                               Container(
    //                                 padding: const EdgeInsets.all(8),
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.white.withOpacity(0.1),
    //                                   borderRadius: BorderRadius.circular(8),
    //                                 ),
    //                                 child: const Icon(
    //                                   Icons.share_outlined,
    //                                   size: 16,
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );

    return SizedBox(
      height: 270,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        clipBehavior: Clip.none,
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          final isNew = isNewArticle(article.publishDate);
          print("Image ------------------> ${article.coverImage}");
          return GestureDetector(
            onTap: () {
              Get.to(() => NewsDetailScreen(newsItem: article));
            },
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorRes.leadGreyColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top image section - No rounded top corners
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.black,
                      child: CustomImage(
                        type: CustomImageType.network,
                        src: article.coverImage,
                        height: 120,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  /// Content section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            article.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            article.content ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              height: 1.5,
                              color: ColorRes.leadGreyColor.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),

                          /// Footer: author info and stats
                          Row(
                            children: [
                              // Author avatar
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Author name and date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.author ?? '',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.small,
                                        color: ColorRes.textPrimary,
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            article.slug ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: AppFontSizes.extraSmall,
                                              color:
                                                  ColorRes
                                                      .leadGreyColor
                                                      .shade700,
                                              fontWeight:
                                                  AppFontWeights.regular,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          _formatDate(article.publishDate),
                                          style: TextStyle(
                                            fontSize: AppFontSizes.caption,
                                            color: ColorRes.leadGreyColor,
                                            fontWeight: AppFontWeights.medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatViewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class ExploreLocalities extends StatelessWidget {
  final List<TrendingArea> trendingArea;

  const ExploreLocalities({super.key, required this.trendingArea});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // height for one row of cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
        itemCount: trendingArea.length,
        itemBuilder: (context, index) {
          final locality = trendingArea[index];

          // Calculate trend based on inquiries
          final bool isUp = locality.totalInquiries > 0;

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.small),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                // Handle locality tap - navigate to properties in this area
                // You can pass locality.area and locality.city to the next screen
              },
              child: Container(
                width: 180, // fixed card width for horizontal list
                padding: const EdgeInsets.all(AppSpacing.small),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorRes.leadGreyColor.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Locality name
                    Text(
                      locality.area,
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    /// Property Count
                    Text(
                      '${locality.propertyCount} ${locality.propertyCount == 1 ? 'Property' : 'Properties'}',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.leadGreyColor.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Inquiries + Trend Arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${locality.totalInquiries} ${locality.totalInquiries == 1 ? 'inquiry' : 'inquiries'}',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color:
                                  isUp
                                      ? ColorRes.green.shade600
                                      : ColorRes.leadGreyColor.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (locality.totalInquiries > 0)
                          Icon(
                            Icons.trending_up_rounded,
                            size: 16,
                            color: ColorRes.green.shade600,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrendingInsights extends StatelessWidget {
  TrendingInsights({super.key});

  final trendingInsights = [
    {
      "title": "Price Trends",
      "subtitle": "Find property rates & price trends of top locations",
      "image": IMGRes.news_1,
      "tag": "Trending",
      "isHot": true,
    },
    {
      "title": "City Insights",
      "subtitle": "Get to know about top cities before you invest",
      "image": IMGRes.news_2,
      "tag": "Hot Topic",
      "isHot": false,
    },
    {
      "title": "NesticoPe Research",
      "subtitle": "Find reports on Indian residential market",
      "image": IMGRes.news_3,
      "tag": "Eco Trend",
      "isHot": true,
    },
    {
      "title": "Reviews",
      "subtitle": "Read authentic reviews from property buyers and renters",
      "image": IMGRes.news_1,
      "tag": "Tech",
      "isHot": false,
    },
  ];

  final List<IconData> icons = [
    Icons.trending_up,
    Icons.apartment,
    Icons.eco,
    Icons.rate_review,
  ];

  final List<Color> iconColors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trendingInsights.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final insight = trendingInsights[index];

          return SizedBox(
            width: 200,
            child: CompactInsightCard(
              tag: insight["tag"]?.toString() ?? "",
              title: insight["title"]?.toString() ?? "No Title",
              value: insight["subtitle"]?.toString() ?? "",
              icon: icons[index],
              // color: iconColors[index],
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

class CompactInsightCard extends StatelessWidget {
  // final Color color;
  final IconData icon;
  final String tag;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const CompactInsightCard({
    super.key,
    required this.tag,
    required this.title,
    required this.value,
    this.onTap,
    required this.icon,
    // required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Tag
            // Row(
            //   children: [
            //     Icon(icon, size: 16, color: ColorRes.primary),
            //     const SizedBox(width: 4),
            //     Text(
            //       tag,
            //       style: TextStyle(
            //         fontSize: 10,
            //         color: Colors.grey.shade600,
            //         fontWeight: AppFontWeights.medium,
            //       ),
            //     ),
            //     const Spacer(),
            //     Icon(
            //       Icons.arrow_forward_ios,
            //       size: 12,
            //       color: Colors.grey.shade400,
            //     ),
            //   ],
            // ),
            //
            // const SizedBox(height: 6),

            /// Title
            Row(
              children: [
                Container(child: Icon(icon, size: 16, color: ColorRes.primary)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.primary,
                      // color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 6),
              ],
            ),

            const SizedBox(height: 8),

            /// Value / detail
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.leadGreyColor.shade600,
                fontWeight: AppFontWeights.medium,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class WhyChooseUsSection extends StatelessWidget {
  final items = [
    {
      "title": "Over 7 Properties",
      "subtitle": "10,000+ properties added every day",
      "icon": Icons.home_outlined,
    },
    {
      "title": "Verified by Our Team",
      "subtitle": "Photos, videos and details verified on location",
      "icon": Icons.verified_outlined,
    },
    {
      "title": "Large User Base",
      "subtitle": "High active user count and engagement",
      "icon": Icons.group_outlined,
    },
    {
      "title": "Instant Updates",
      "subtitle": "Real-time notifications for new listings",
      "icon": Icons.notifications_active_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of columns
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4, // controls height/width ratio
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorRes.leadGreyColor.shade300,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item["icon"] as IconData, size: 28, color: ColorRes.primary),
              const SizedBox(height: 4),
              Text(
                "${item['title']}",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "${item['subtitle']}",
                style: TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: ColorRes.leadGreyColor.shade600,
                  fontWeight: AppFontWeights.medium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class RecommendedInsights extends StatelessWidget {
  const RecommendedInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final insights = [
      {
        "title": "Real Estate Market Trends 2025",
        "description":
            "An in-depth analysis of the current real estate market trends.",
        "imageUrl":
            "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?cs=srgb&dl=pexels-pixabay-106399.jpg&fm=jpg",
      },
      {
        "title": "Top 10 Cities for Property Investment",
        "description":
            "Discover the best cities to invest in real estate in 2025.",
        "imageUrl":
            "https://images.pexels.com/photos/221457/pexels-photo-221457.jpeg?cs=srgb&dl=pexels-pixabay-221457.jpg&fm=jpg",
      },
      {
        "title": "Tips for First-Time Home Buyers",
        "description":
            "Essential tips and advice for those buying their first home.",
        "imageUrl":
            "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?cs=srgb&dl=pexels-pixabay-259588.jpg&fm=jpg",
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = insights[index];
          return InsightsCard(
            title: item["title"]!,
            description: item["description"]!,
            imageUrl: item["imageUrl"]!,
            onReadMore: () {
              // Handle read more
            },
          );
        },
      ),
    );
  }
}

class InsightsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onReadMore;

  const InsightsCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade200,
        //     blurRadius: 6,
        //     offset: const Offset(2, 3),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: double.infinity,
                  color: ColorRes.leadGreyColor.shade300,
                  child: const Icon(Icons.broken_image, color: ColorRes.white),
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.leadGreyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onReadMore,
                    child: Text(
                      "Read More",
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: Theme.of(context).primaryColor,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> propertyPercentage = [
  "9.6",
  "10.2",
  "7.8",
  "15.4",
  "12.0",
  "8.9",
  "11.5",
  "14.3",
  "9.0",
  "16.8",
];

class ReferralCard extends StatelessWidget {
  final String referralCode;

  const ReferralCard({Key? key, required this.referralCode}) : super(key: key);

  void _shareReferral(BuildContext context) {
    final String shareText =
        "Hey! Use my referral code 👉 $referralCode to sign up and enjoy benefits! \n\nDownload the app here: https://example.com/app";

    Share.share(shareText, subject: "Join with my referral code");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: ColorRes.primary.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Refer Friends",
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: const Text(
                  "Share app and help your friends discover great real estate options!",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.normal,
                    color: ColorRes.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _shareReferral(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.share),
                label: const Text(
                  "Share Code",
                  style: TextStyle(color: ColorRes.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerSupport extends StatelessWidget {
  final String phoneNumber;

  const CustomerSupport({Key? key, required this.phoneNumber})
    : super(key: key);

  Future<void> _callSupport() async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(
      launchUri,
      mode: LaunchMode.externalNonBrowserApplication, // 👈 important
    )) {
      throw "Could not launch dialer for $phoneNumber";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: ColorRes.homeYellowDark.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Support",
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: const Text(
                  "Need help? Call our support team for assistance anytime.",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.normal,
                    color: ColorRes.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _callSupport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.white,
                  foregroundColor: ColorRes.homeYellowDark.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: Icon(Icons.call, color: ColorRes.homeYellowDark.shade900),
                label: Text(
                  "Call Support",
                  style: TextStyle(color: ColorRes.homeYellowDark.shade900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackComponent extends StatefulWidget {
  final Function(int rating, String feedback) onSubmit;

  const FeedbackComponent({super.key, required this.onSubmit});

  @override
  State<FeedbackComponent> createState() => _FeedbackComponentState();
}

class _FeedbackComponentState extends State<FeedbackComponent> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.leadGreyColor.shade400, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rate Our App",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: AppFontWeights.bold,
                color: ColorRes.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Rating ($_rating/5)",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                // fontSize: ,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    size: 32,
                    color:
                        index < _rating
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor.shade400,
                  ),
                );
              }),
            ),
            // Text(
            //   _rating == 0
            //       ? "Tap stars to rate"
            //       : "You rated $_rating star${_rating > 1 ? 's' : ''}",
            //   style: TextStyle(
            //     color: Colors.grey[800],
            //     fontSize: 13,
            //     fontWeight: AppFontWeights.regular,
            //   ),
            // ),
            const SizedBox(height: 10),

            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your feedback...",
                hintStyle: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.leadGreyColor,
                ),
                filled: true,
                fillColor: ColorRes.leadGreyColor[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorRes.leadGreyColor),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorRes.leadGreyColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorRes.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_rating != 0 ||
                      _feedbackController.text.trim().isNotEmpty) {
                    widget.onSubmit(_rating, _feedbackController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feedback Submitted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please add rating & feedback'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // toastification.show(
                    //   context: context,
                    //   title: Text('Please add rating & feedback'),
                    //   type: ToastificationType.error,
                    //   style: ToastificationStyle.flat,
                    //   autoCloseDuration: Duration(seconds: 2),
                    //   alignment: Alignment.topRight,
                    //   direction: TextDirection.ltr,
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    color: ColorRes.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyHorizontalCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String location;
  final String price;

  // ✅ Font Weights
  final FontWeight priceFontWeight;
  final FontWeight locationWeight;
  final FontWeight titleFontWeight;

  // ✅ Layout
  final int maxLineTitle;
  final int maxLineSubtitle;
  final int maxLine;

  // ✅ Styling properties
  final Color borderColor;
  final Color textColor;
  final Color accentColor;
  final Color titleColor;
  final Color dividerColor;
  final Color locationColor;

  // ✅ Layout properties
  final double width;
  final double imageHeight;
  final double imageWidth;

  // ✅ Font sizes
  final double titleFontSize;
  final double locationFontSize;
  final double priceFontSize;

  // ✅ Rating
  final double? rating;
  final IconData ratingIcon;
  final Color ratingColor;

  // ✅ Button Row
  final String buttonText;
  final Color buttonTextColor;
  final double buttonFontSize;
  final FontWeight buttonFontWeight;
  final Color priceColor;
  final double ratingFont;
  final FontWeight ratingFontWeight;
  final IconData actionIcon;
  final Color iconColor;

  final bool showRowLayout;

  final VoidCallback? onTap;

  const PropertyHorizontalCard({
    super.key,
    required this.title,
    this.ratingFont = AppFontSizes.caption,
    this.ratingFontWeight = AppFontWeights.semiBold,
    this.locationColor = ColorRes.textSecondary,
    required this.imagePath,
    required this.location,
    this.price = '2020',
    this.priceColor = ColorRes.textPrimary,
    this.priceFontWeight = AppFontWeights.bold,
    this.locationWeight = AppFontWeights.regular,
    this.titleFontWeight = AppFontWeights.semiBold,
    this.maxLine = 2,
    this.maxLineTitle = 1,
    this.maxLineSubtitle = 1,

    // styling
    this.borderColor = ColorRes.leadGreyColor,
    this.textColor = ColorRes.black,
    this.accentColor = ColorRes.blueColor,
    this.titleColor = ColorRes.black,
    this.dividerColor = ColorRes.leadGreyColor,

    // layout (smaller container)
    this.width = 250,
    this.imageHeight = 60,
    this.imageWidth = 70,

    // font sizes (slightly smaller)
    this.titleFontSize = AppFontSizes.small,
    this.locationFontSize = AppFontSizes.mini,
    this.priceFontSize = AppFontSizes.small,

    // rating
    this.rating,
    this.ratingIcon = Icons.star,
    this.ratingColor = ColorRes.homeAmber,

    // button row
    this.buttonText = "View",
    this.buttonTextColor = ColorRes.leadIndigoColor,
    this.buttonFontSize = AppFontSizes.caption,
    this.buttonFontWeight = AppFontWeights.medium,
    this.actionIcon = Icons.arrow_forward_ios,
    this.iconColor = ColorRes.leadIndigoColor,

    this.showRowLayout = true,

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor.withOpacity(0.3), width: 0.8),
          color: ColorRes.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imagePath,
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommonText(
                    title,
                    titleFontSize,
                    titleFontWeight,
                    textColor,
                    maxLineTitle,
                  ),
                  const SizedBox(height: 2),
                  buildCommonText(
                    location,
                    locationFontSize,
                    locationWeight,
                    locationColor,
                    maxLineSubtitle,
                  ),
                  const SizedBox(height: 4),
                  if (showRowLayout) ...[
                    Row(
                      children: [
                        buildCommonText(
                          Formatter.formatPrice(
                            double.tryParse(
                                  price.replaceAll(RegExp(r'[^\d.]'), ''),
                                )?.toInt() ??
                                0,
                          ),
                          priceFontSize,
                          priceFontWeight,
                          priceColor,
                          1,
                        ),
                        const Spacer(),
                        if (rating != null) ...[
                          Icon(ratingIcon, color: ratingColor, size: 14),
                          const SizedBox(width: 3),
                          buildCommonText(
                            rating.toString(),
                            ratingFont,
                            ratingFontWeight,
                            titleColor,
                            maxLine,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Divider(
                      color: dividerColor.withOpacity(0.35),
                      thickness: 0.5,
                      height: 6,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCommonText(
                          buttonText,
                          buttonFontSize,
                          buttonFontWeight,
                          buttonTextColor,
                          1,
                        ),
                        const SizedBox(width: 3),
                        Icon(actionIcon, color: iconColor, size: 12),
                      ],
                    ),
                  ] else ...[
                    buildCommonText(
                      Formatter.formatPrice(
                        double.tryParse(
                              price.replaceAll(RegExp(r'[^\d.]'), ''),
                            )?.toInt() ??
                            0,
                      ),
                      priceFontSize,
                      priceFontWeight,
                      priceColor,
                      1,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewHighlights extends StatefulWidget {
  final List<String> goodThings;
  final List<String> improvements;

  const ReviewHighlights({
    super.key,
    required this.goodThings,
    required this.improvements,
  });

  @override
  State<ReviewHighlights> createState() => _ReviewHighlightsState();
}

class _ReviewHighlightsState extends State<ReviewHighlights> {
  bool showAllGood = false;
  bool showAllImprovements = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.goodThings.isNotEmpty)
            _buildTagSection(
              "Good Things",
              widget.goodThings,
              showAllGood,
              (value) => setState(() => showAllGood = value),
            ),
          if (widget.goodThings.isNotEmpty && widget.improvements.isNotEmpty)
            const SizedBox(height: 16),
          if (widget.improvements.isNotEmpty)
            _buildTagSection(
              "Need to Improve",
              widget.improvements,
              showAllImprovements,
              (value) => setState(() => showAllImprovements = value),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTagSection(
    String title,
    List<String> items,
    bool expanded,
    Function(bool) toggleExpand,
  ) {
    // show first 4 items unless expanded
    final displayItems = expanded ? items : items.take(3).toList();
    final remainingCount = items.length - displayItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: AppFontWeights.semiBold,
            fontSize: AppFontSizes.small,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...displayItems.map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.grey.withOpacity(0.090),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.grey,
                  ),
                ),
              ),
            ),
            if (!expanded && remainingCount > 0)
              GestureDetector(
                onTap: () => toggleExpand(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "+$remainingCount more",
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget buildHeading(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppFontSizes.body,
        fontWeight: AppFontWeights.extraBold,
      ),
    );
  }
}

class StateSelectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;
  final Function(Prediction)? onCitySelected; // ✅ callback for selected city

  const StateSelectionWidget({
    super.key,
    required this.controller,

    this.onCitySelected,
    this.isEditing = true,
  });

  @override
  Widget build(BuildContext context) {
    final googleMapController = Get.put(GoogleMapSearchController());
    return Column(
      children: [
        // 🔹 Custom TextField
        TextFormField(
          controller: controller,
          enabled: isEditing,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.homeBlackFade,
          ),
          decoration: InputDecoration(
            labelText: "Select State",
            labelStyle: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[500],
            ),
            prefixIcon: Icon(
              Icons.location_city_outlined,
              size: 20,
              color: ColorRes.leadGreyColor[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorRes.leadGreyColor.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorRes.leadGreyColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ColorRes.blueColor,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorRes.leadGreyColor.withOpacity(0.2),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorRes.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorRes.error, width: 1.5),
            ),
            filled: true,
            fillColor: ColorRes.leadGreyColor[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) async {
            if (value.isNotEmpty) {
              await googleMapController.fetchGooglePlaces(value);
              log("City input: $value");
            } else {
              googleMapController.predictions.clear();
            }
          },
        ),

        const SizedBox(height: 8),

        // 🔹 City Suggestions (Obx listens for updates)
        Obx(() {
          final predictions = googleMapController.predictions;
          final parsedCities = googleMapController.cityStateList;

          // choose which list to show
          final hasParsed = parsedCities.isNotEmpty;
          final items = hasParsed ? parsedCities : predictions;

          if (items.isEmpty) return const SizedBox();

          return Container(
            constraints: const BoxConstraints(maxHeight: 250),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length > 3 ? 3 : items.length,
              itemBuilder: (context, index) {
                if (hasParsed) {
                  // ✅ Cast item to Map<String, String?>
                  final cityData = items[index] as Map<String, String?>;

                  log("djhfudfhg ${cityData}");

                  return ListTile(
                    leading: const Icon(
                      Icons.location_city_outlined,
                      size: 20,
                      color: ColorRes.primary,
                    ),
                    title: Text(
                      cityData['city'] ?? '',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.homeBlackFade,
                      ),
                    ),
                    subtitle: Text(
                      '${cityData['state'] ?? ''}, ${cityData['country'] ?? ''}',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.leadGreyColor[700],
                      ),
                    ),
                    onTap: () {
                      controller.text = cityData['city'] ?? '';
                      googleMapController.predictions.clear();
                      googleMapController.cityStateList.clear();
                      FocusScope.of(context).unfocus();

                      if (onCitySelected != null) {
                        onCitySelected!(
                          Prediction(description: cityData['state']),
                        );
                      }
                    },
                  );
                } else {
                  final city = items[index] as Prediction;
                  return ListTile(
                    leading: const Icon(
                      Icons.location_city_outlined,
                      size: 20,
                      color: ColorRes.primary,
                    ),
                    title: Text(
                      city.description ?? '',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.homeBlackFade,
                      ),
                    ),
                    onTap: () {
                      controller.text = city.description ?? '';
                      googleMapController.predictions.clear();
                      FocusScope.of(context).unfocus();

                      if (onCitySelected != null) onCitySelected!(city);
                    },
                  );
                }
              },
            ),
          );
        }),
      ],
    );
  }
}

// ========================================
// SHIMMER COMPONENTS FOR HOME SCREEN
// ========================================

/// Shimmer for Property Type Selector
class PropertyTypeSelectorShimmer extends StatelessWidget {
  const PropertyTypeSelectorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(
          8,
          (index) => Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 8 : 2,
              right: index == 7 ? 8 : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerWidget(width: 60, height: 60, shape: BoxShape.circle),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 76, height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for Horizontal Property List
class HorizontalPropertyListShimmer extends StatelessWidget {
  const HorizontalPropertyListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SizedBox(
        height: 310,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerShapes.rounded(
                    width: 280,
                    height: 180,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 12),
                  ShimmerShapes.text(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  ShimmerShapes.text(width: 200, height: 14),
                  const SizedBox(height: 8),
                  ShimmerShapes.text(width: 200, height: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Shimmer for Project List
class ProjectListShimmer extends StatelessWidget {
  const ProjectListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerShapes.rounded(
                  width: 250,
                  height: 150,
                  borderRadius: 12,
                ),
                const SizedBox(height: 12),
                ShimmerShapes.text(width: double.infinity, height: 16),
                const SizedBox(height: 6),
                ShimmerShapes.text(width: 180, height: 14),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ShimmerShapes.text(width: 80, height: 14),
                    const Spacer(),
                    ShimmerShapes.text(width: 60, height: 14),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for City Filter List
class CityFilterListShimmer extends StatelessWidget {
  const CityFilterListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: Column(
              children: [
                ShimmerShapes.rounded(width: 160, height: 80, borderRadius: 12),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 120, height: 14),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Seller List
class SellerListShimmer extends StatelessWidget {
  const SellerListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 120,
            child: Column(
              children: [
                ShimmerShapes.circle(size: 80),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 100, height: 14),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 80, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Contractor Cards
class ContractorCardShimmer extends StatelessWidget {
  const ContractorCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 300,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerShapes.circle(size: 60),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerShapes.text(
                              width: double.infinity,
                              height: 16,
                            ),
                            const SizedBox(height: 6),
                            ShimmerShapes.text(width: 120, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ShimmerShapes.text(width: double.infinity, height: 14),
                  const SizedBox(height: 6),
                  ShimmerShapes.text(width: 200, height: 14),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ShimmerShapes.text(width: 80, height: 12),
                      const Spacer(),
                      ShimmerShapes.rounded(
                        width: 100,
                        height: 32,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Top Categories
class TopCategoriesShimmer extends StatelessWidget {
  const TopCategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ShimmerShapes.circle(size: 60),
            const SizedBox(height: 8),
            ShimmerShapes.text(width: 80, height: 12),
          ],
        );
      },
    );
  }
}

/// Shimmer for Platform Services
class PlatformServiceShimmer extends StatelessWidget {
  const PlatformServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 140,
            child: Column(
              children: [
                ShimmerShapes.rounded(width: 140, height: 80, borderRadius: 12),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 120, height: 14),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for News and Articles
class NewsArticlesShimmer extends StatelessWidget {
  const NewsArticlesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: ShimmerShapes.rectangle(
                      width: double.infinity,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerShapes.text(width: double.infinity, height: 16),
                        const SizedBox(height: 8),
                        ShimmerShapes.text(width: double.infinity, height: 14),
                        const SizedBox(height: 6),
                        ShimmerShapes.text(width: 180, height: 14),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ShimmerShapes.circle(size: 35),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerShapes.text(
                                    width: double.infinity,
                                    height: 12,
                                  ),
                                  const SizedBox(height: 4),
                                  ShimmerShapes.text(width: 100, height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Reviews and Testimonials
class ReviewsTestimonialsShimmer extends StatelessWidget {
  const ReviewsTestimonialsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerShapes.circle(size: 50),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerShapes.text(
                            width: double.infinity,
                            height: 14,
                          ),
                          const SizedBox(height: 6),
                          ShimmerShapes.text(width: 100, height: 12),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: ShimmerWidget(
                                  width: 16,
                                  height: 16,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ShimmerShapes.text(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                ShimmerShapes.text(width: 200, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Furnishing Type Cards
class FurnishingTypeShimmer extends StatelessWidget {
  const FurnishingTypeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ShimmerShapes.rounded(
                width: 200,
                height: 120,
                borderRadius: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for Explore Localities
class ExploreLocalitiesShimmer extends StatelessWidget {
  const ExploreLocalitiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerShapes.text(width: 140, height: 14),
                const Spacer(),
                ShimmerShapes.text(width: 100, height: 12),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 120, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Trending Insights
class TrendingInsightsShimmer extends StatelessWidget {
  const TrendingInsightsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerShapes.circle(size: 16),
                    const SizedBox(width: 6),
                    ShimmerShapes.text(width: 120, height: 14),
                  ],
                ),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: double.infinity, height: 12),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 150, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
