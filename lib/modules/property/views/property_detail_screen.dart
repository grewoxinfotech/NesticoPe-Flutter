// import 'dart:developer';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/img_res.dart';
// import 'package:nesticope_app/app/constants/size_manager.dart';
// import 'package:nesticope_app/app/manager/data_masker.dart';
// import 'package:nesticope_app/app/manager/icon_manager.dart';
// import 'package:nesticope_app/app/manager/property/property_pricemanager.dart';
// import 'package:nesticope_app/app/manager/string_manager.dart';
// import 'package:nesticope_app/app/utils/bottom_sheet_form.dart';
// import 'package:nesticope_app/app/utils/formater/formater.dart';
// import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
// import 'package:nesticope_app/app/widgets/video_player/custom_video_player.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/modules/auth/views/login_screen.dart';
// import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
// import 'package:nesticope_app/modules/property/controllers/share_property_controller.dart';
// import 'package:nesticope_app/modules/property/views/recommended_property.dart';
// import 'package:nesticope_app/modules/property/views/widgets/investment_insigths_graph.dart';
// import 'package:nesticope_app/modules/property/views/widgets/overall_rating_widget.dart';
// import 'package:nesticope_app/modules/review/controllers/review_controller.dart';
// import 'package:nesticope_app/modules/review/views/widget/add_property_review.dart';
// import 'package:nesticope_app/modules/review/views/widget/property_review_card.dart';
// import 'package:nesticope_app/app/manager/compare_manager.dart';
// import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
// import 'package:nesticope_app/widgets/bar/bottom_bar/customer_bottom_bar.dart';
// import 'package:nesticope_app/widgets/bar/navigation_bar/navigation_Bar.dart';
//
// import 'package:nesticope_app/modules/search_property/view/search_screen.dart';
// import 'package:nesticope_app/widgets/button/button.dart';
// import 'package:timeago/timeago.dart' as timeFormatter;
// import 'package:video_player/video_player.dart';
//
// import '../../../app/constants/enum.dart';
// import '../../../app/manager/property_detail_manager.dart';
// import '../../../app/manager/property_highlight_manager.dart';
// import '../../../app/utils/helper_function/contact_helper.dart';
// import '../../../app/widgets/expandable_tile/expandable_widget.dart';
// import '../../../app/widgets/texts/headline_text.dart';
// import '../../../data/network/overall_rating/model/overall_rating_model.dart';
// import '../../../data/network/property/models/property_model.dart';
// import '../../../utils/common_widget/rera_widget.dart';
// import '../../../widgets/button/property_action_button.dart';
// import '../../../widgets/map/address_and_map_detail.dart';
// import '../../../widgets/map/near_by_location_map_section.dart';
// import '../../../widgets/property/furnishing_details.dart';
// import '../../home/widgets/unified_comparison_floating_button.dart';
// import '../../location_price_matrix/controllers/location_price_matrix_controller.dart';
// import '../../review/views/widget/property_project_review_section.dart';
// import '../../search_property/controller/search_controller.dart';
// import '../controllers/overall_rating_controller.dart';
//
// class PropertyDetailScreen extends StatefulWidget {
//   // final Items? property;
//   final String? propertyId;
//
//   const PropertyDetailScreen({super.key, this.propertyId});
//
//   @override
//   State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
// }
//
// class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
//   late final PropertyController controller;
//   late final PropertyFavoriteController favoriteController;
//   late final GoogleMapSearchController mapController;
//   late final OverallRatingController _overallRatingController;
//   late final ReviewController reviewController;
//   final RxBool canAddReview = true.obs;
//
//   final Rxn<Items> _property = Rxn<Items>();
//
//   final RxBool _isLoading = true.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     log('[PropertyDetail] initState called');
//
//     // Get property ID
//     final propertyId = widget.propertyId ?? '';
//     log('[PropertyDetail] propertyId => $propertyId');
//
//     // Initialize controllers
//     log('[PropertyDetail] Initializing PropertyController');
//     controller = Get.put(PropertyController(), tag: 'property_$propertyId');
//
//     log('[PropertyDetail] Initializing GoogleMapSearchController');
//     mapController = Get.put(
//       GoogleMapSearchController(),
//       tag: 'map_$propertyId',
//     );
//
//     log('[PropertyDetail] Initializing OverallRatingController');
//     _overallRatingController = Get.put(
//       OverallRatingController(),
//       tag: 'rating_$propertyId',
//     );
//
//     log('[PropertyDetail] Initializing ReviewController');
//     reviewController = Get.put(ReviewController(), tag: 'review_$propertyId');
//
//     log('[PropertyDetail] Finding PropertyFavoriteController');
//     favoriteController = Get.find<PropertyFavoriteController>();
//
//     // Load data after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       log('[PropertyDetail] Post frame callback → calling _loadData()');
//       _loadData();
//     });
//   }
//
//   Future<void> _loadData() async {
//     log('[PropertyDetail] _loadData started');
//
//     try {
//       if (!mounted) return;
//
//       _isLoading.value = true;
//       log('[PropertyDetail] Loading state set to TRUE');
//
//       final propertyId = widget.propertyId ?? '';
//       await controller.getAllInQuireData(propertyId);
//
//       final fetchedProperty = await controller.getPropertyById(
//         widget.propertyId!,
//       );
//
//       if (!mounted) return;
//
//       if (fetchedProperty == null) {
//         log('[PropertyDetail] Property NOT FOUND', level: 1000);
//         _isLoading.value = false;
//
//         if (mounted) {
//           Get.snackbar(
//             'Error',
//             'Property not found',
//             snackPosition: SnackPosition.BOTTOM,
//           );
//           Get.back();
//         }
//         return;
//       }
//
//       log(
//         '[PropertyDetail] Property fetched successfully → ID: ${fetchedProperty.id}',
//       );
//
//       // ✅ Set property BEFORE setting loading to false
//       _property.value = fetchedProperty;
//
//       final currentProperty = _property.value!;
//
//       // Set review filter
//       reviewController.filters.value = {"entity_id": currentProperty.id ?? ""};
//       reviewController.filters.refresh();
//
//       // Fetch nearby landmarks
//       if (currentProperty.address?.isNotEmpty ?? false) {
//         await mapController.fetchAllCategoriesData(currentProperty.address!);
//       }
//
//       // Check review permission
//       final user = await SecureStorage.getUserData();
//       final userId = user?.user?.id ?? '';
//
//       if (currentProperty.id != null) {
//         final exists = await reviewController.isReviewExist(
//           entityId: currentProperty.id!,
//           reviewerId: userId,
//         );
//         canAddReview.value = !exists;
//       }
//
//       // Track view
//       controller.addView(currentProperty.id ?? '');
//
//       // Fetch overall rating
//       _overallRatingController.fetchOverallRating(currentProperty.id ?? '');
//
//       Get.put(
//         LocationPriceMatrixController(
//           city: currentProperty.city ?? '',
//           propertyType: currentProperty.propertyType ?? '',
//           location: currentProperty.location ?? '',
//           state: currentProperty.state ?? '',
//         ),
//       );
//     } catch (e, s) {
//       log(
//         '[PropertyDetail] ERROR in _loadData',
//         error: e,
//         stackTrace: s,
//         level: 1000,
//       );
//     } finally {
//       if (mounted) {
//         _isLoading.value = false;
//         log(
//           '[PropertyDetail] Loading state set to FALSE - UI should update now',
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     final propertyId = widget.propertyId ?? '';
//
//     // Clean up controllers
//     Get.delete<PropertyController>(tag: 'property_$propertyId');
//     Get.delete<GoogleMapSearchController>(tag: 'map_$propertyId');
//     Get.delete<OverallRatingController>(tag: 'rating_$propertyId');
//     Get.delete<ReviewController>(tag: 'review_$propertyId');
//
//     // Clean up observables
//     canAddReview.close();
//     _property.close();
//     _isLoading.close();
//
//     super.dispose();
//   }
//
//   // Convenience getter
//   Items? get property => _property.value;
//
//   final CompareManager compare = Get.find<CompareManager>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       extendBody: true,
//       body: Obx(() {
//         log(
//           '[PropertyDetail] 🔄 Obx rebuild - isLoading: ${_isLoading.value}, property: ${_property.value?.id}',
//         );
//
//         // Show loading while fetching property
//         if (_isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         // Get current property value
//         final currentProperty = _property.value;
//
//         // Show error if property not found
//         if (currentProperty == null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 64,
//                   color: ColorRes.leadGreyColor,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Property not found',
//                   style: TextStyle(
//                     fontSize: AppFontSizes.body,
//                     color: ColorRes.leadGreyColor,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => Get.back(),
//                   child: const Text('Go Back'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // Create priceManager with fresh data
//         log('[PropertyDetail] 📊 Creating priceManager');
//         final priceManager = PropertyPriceManager(
//           financialInfo:
//               currentProperty.propertyDetails?.financialInfo ?? FinancialInfo(),
//           listingType: currentProperty.listingType ?? '',
//         );
//         log('[PropertyDetail] ✅ priceManager created');
//
//         return SafeArea(
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 padding: const EdgeInsets.only(
//                   bottom: kBottomNavigationBarHeight / 2,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Builder(
//                       builder: (context) {
//                         log('[PropertyDetail] 🖼️ Building MediaBanner');
//                         return _buildMediaBanner(
//                           currentProperty.propertyMedia ?? PropertyMedia(),
//                           currentProperty.id ?? '',
//                         );
//                       },
//                     ),
//
//                     Builder(
//                       builder: (context) {
//                         log('[PropertyDetail] 📝 Building TitleSection');
//                         return _buildTitleSection(currentProperty);
//                       },
//                     ),
//                     if ((currentProperty
//                                 .propertyDetails
//                                 ?.financialInfo
//                                 ?.is_for_sellorrent ??
//                             false) &&
//                         (currentProperty.listingType?.toLowerCase() ==
//                             'sell')) ...[
//                       if (currentProperty
//                               .propertyDetails
//                               ?.financialInfo
//                               ?.propertyRentPerMonth !=
//                           null) ...[
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                         //   child: Container(
//                         //     padding: const EdgeInsets.all(12),
//                         //     decoration: BoxDecoration(
//                         //       color: ColorRes.primary.withOpacity(0.05),
//                         //       borderRadius: BorderRadius.circular(10),
//                         //       border: Border.all(
//                         //         color: ColorRes.primary.withOpacity(0.2),
//                         //       ),
//                         //     ),
//                         //     child: Row(
//                         //       children: [
//                         //         const Icon(
//                         //           Icons.house,
//                         //           color: ColorRes.primary,
//                         //         ),
//                         //         const SizedBox(width: 8),
//                         //         Expanded(
//                         //           child: Text(
//                         //             'This property is also available for rent at '
//                         //             '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month.',
//                         //             style: const TextStyle(
//                         //               fontSize: AppFontSizes.bodySmall,
//                         //               fontWeight: AppFontWeights.medium,
//                         //               color: ColorRes.textPrimary,
//                         //             ),
//                         //           ),
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//                         Divider(
//                           indent: 18,
//                           endIndent: 18,
//                           color: ColorRes.leadGreyColor.shade300,
//                         ),
//                         const SizedBox(height: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const TitleWithViewAll(title: 'Also for Rent'),
//                             const SizedBox(height: 8),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: ColorRes.primary.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: ColorRes.primary.withOpacity(0.3),
//                                     width: 0.8,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Available Rent Price',
//                                           style: const TextStyle(
//                                             fontSize: AppFontSizes.caption,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: ColorRes.textPrimary,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
//                                           style: const TextStyle(
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.semiBold,
//                                             color: ColorRes.textPrimary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Divider(
//                           indent: 18,
//                           endIndent: 18,
//                           color: ColorRes.leadGreyColor.shade300,
//                         ),
//                       ] else ...[
//                         SizedBox.shrink(),
//                       ],
//                     ],
//                     if ((currentProperty
//                                 .propertyDetails
//                                 ?.financialInfo
//                                 ?.is_for_sellorrent ??
//                             false) &&
//                         (currentProperty.listingType?.toLowerCase() ==
//                             'rent')) ...[
//                       if (currentProperty
//                               .propertyDetails
//                               ?.financialInfo
//                               ?.price !=
//                           null) ...[
//                         const SizedBox(height: 12),
//                         Divider(
//                           indent: 18,
//                           endIndent: 18,
//                           color: ColorRes.leadGreyColor.shade300,
//                         ),
//                         const SizedBox(height: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const TitleWithViewAll(title: 'Also for Sell'),
//                             const SizedBox(height: 8),
//                             // Padding(
//                             //   padding: const EdgeInsets.symmetric(
//                             //     horizontal: 16,
//                             //   ),
//                             //   child: Container(
//                             //     padding: const EdgeInsets.all(12),
//                             //     decoration: BoxDecoration(
//                             //       color: ColorRes.white,
//                             //       borderRadius: BorderRadius.circular(12),
//                             //       border: Border.all(
//                             //         color: ColorRes.leadGreyColor.shade300,
//                             //         width: 0.8,
//                             //       ),
//                             //     ),
//                             //     child: Row(
//                             //       crossAxisAlignment: CrossAxisAlignment.center,
//                             //       children: [
//                             //         Expanded(
//                             //           child: Text.rich(
//                             //             TextSpan(
//                             //               text:
//                             //                   'This property is also available for sell at ',
//                             //               style: TextStyle(
//                             //                 fontSize: AppFontSizes.caption,
//                             //                 fontWeight: AppFontWeights.medium,
//                             //                 color: ColorRes.leadGreyColor[700],
//                             //               ),
//                             //               children: [
//                             //                 TextSpan(
//                             //                   text:
//                             //                       '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.price ?? 0)}',
//                             //                   style: const TextStyle(
//                             //                     fontSize:
//                             //                         AppFontSizes.bodySmall,
//                             //                     fontWeight:
//                             //                         AppFontWeights.semiBold,
//                             //                     color: ColorRes.textPrimary,
//                             //                   ),
//                             //                 ),
//                             //                 const TextSpan(text: '.'),
//                             //               ],
//                             //             ),
//                             //           ),
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: ColorRes.primary.withOpacity(0.15),
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: ColorRes.primary.withOpacity(0.3),
//                                     width: 0.8,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Available Sell Price',
//                                           style: const TextStyle(
//                                             fontSize: AppFontSizes.caption,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: ColorRes.textPrimary,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.price ?? 0)}',
//                                           style: const TextStyle(
//                                             fontSize: AppFontSizes.body,
//                                             fontWeight: AppFontWeights.semiBold,
//                                             color: ColorRes.textPrimary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 12),
//                         Divider(
//                           indent: 18,
//                           endIndent: 18,
//                           color: ColorRes.leadGreyColor.shade300,
//                         ),
//                       ] else ...[
//                         SizedBox.shrink(),
//                       ],
//                     ],
//
//                     if (currentProperty.propertyDetails?.amenities != null) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Amenities'),
//                       Builder(
//                         builder: (context) {
//                           log('[PropertyDetail] 🏠 Building AmenitiesSection');
//                           return AmenitiesSection(
//                             amenities:
//                                 currentProperty.propertyDetails!.amenities ??
//                                 [],
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 8),
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                     ],
//
//                     if (currentProperty.propertyDetails != null) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Property Details'),
//                       const SizedBox(height: 8),
//                       Builder(
//                         builder: (context) {
//                           log('[PropertyDetail] 📋 Building Details');
//                           return Details(property: currentProperty);
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                     ],
//
//                     if ((currentProperty
//                                 .propertyDetails
//                                 ?.financialInfo
//                                 ?.is_for_sellorrent ??
//                             false) &&
//                         (currentProperty.listingType?.toLowerCase() ==
//                             'sell')) ...[
//                       if (currentProperty
//                               .propertyDetails
//                               ?.financialInfo
//                               ?.propertyRentPerMonth !=
//                           null) ...[
//                         const SizedBox(height: 12),
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                         //   child: Container(
//                         //     padding: const EdgeInsets.all(12),
//                         //     decoration: BoxDecoration(
//                         //       color: ColorRes.primary.withOpacity(0.05),
//                         //       borderRadius: BorderRadius.circular(10),
//                         //       border: Border.all(
//                         //         color: ColorRes.primary.withOpacity(0.2),
//                         //       ),
//                         //     ),
//                         //     child: Row(
//                         //       children: [
//                         //         const Icon(
//                         //           Icons.house,
//                         //           color: ColorRes.primary,
//                         //         ),
//                         //         const SizedBox(width: 8),
//                         //         Expanded(
//                         //           child: Text(
//                         //             'This property is also available for rent at '
//                         //             '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month.',
//                         //             style: const TextStyle(
//                         //               fontSize: AppFontSizes.bodySmall,
//                         //               fontWeight: AppFontWeights.medium,
//                         //               color: ColorRes.textPrimary,
//                         //             ),
//                         //           ),
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const TitleWithViewAll(title: 'Also for rent'),
//                             const SizedBox(height: 8),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: ColorRes.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: ColorRes.leadGreyColor.shade300,
//                                     width: 0.8,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.1),
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Text.rich(
//                                         TextSpan(
//                                           text:
//                                               'This property is also available for rent at ',
//                                           style: TextStyle(
//                                             fontSize: AppFontSizes.caption,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: ColorRes.leadGreyColor[700],
//                                           ),
//                                           children: [
//                                             TextSpan(
//                                               text:
//                                                   '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
//                                               style: const TextStyle(
//                                                 fontSize:
//                                                     AppFontSizes.bodySmall,
//                                                 fontWeight:
//                                                     AppFontWeights.semiBold,
//                                                 color: ColorRes.textPrimary,
//                                               ),
//                                             ),
//                                             const TextSpan(text: '.'),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Divider(
//                           indent: 18,
//                           endIndent: 18,
//                           color: ColorRes.leadGreyColor.shade300,
//                         ),
//                       ] else ...[
//                         SizedBox.shrink(),
//                       ],
//                     ],
//                     if ((currentProperty
//                                 .propertyDetails
//                                 ?.financialInfo
//                                 ?.is_for_sellorrent ??
//                             false) &&
//                         (currentProperty.listingType?.toLowerCase() ==
//                             'rent')) ...[
//                       if (currentProperty
//                               .propertyDetails
//                               ?.financialInfo
//                               ?.price !=
//                           null) ...[
//                         const SizedBox(height: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const TitleWithViewAll(title: 'Also for Sell'),
//                             const SizedBox(height: 8),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: ColorRes.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: ColorRes.leadGreyColor.shade300,
//                                     width: 0.8,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.1),
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Text.rich(
//                                         TextSpan(
//                                           text:
//                                               'This property is also available for sell at ',
//                                           style: TextStyle(
//                                             fontSize: AppFontSizes.caption,
//                                             fontWeight: AppFontWeights.medium,
//                                             color: ColorRes.leadGreyColor[700],
//                                           ),
//                                           children: [
//                                             TextSpan(
//                                               text:
//                                                   '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.price ?? 0)}',
//                                               style: const TextStyle(
//                                                 fontSize:
//                                                     AppFontSizes.bodySmall,
//                                                 fontWeight:
//                                                     AppFontWeights.semiBold,
//                                                 color: ColorRes.textPrimary,
//                                               ),
//                                             ),
//                                             const TextSpan(text: '.'),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 12),
//                         Divider(
//                           indent: 18,
//                           endIndent: 18,
//                           color: ColorRes.leadGreyColor.shade300,
//                         ),
//                       ] else ...[
//                         SizedBox.shrink(),
//                       ],
//                     ],
//
//                     if (currentProperty
//                             .propertyDetails
//                             ?.furnishInfo
//                             ?.furnishDetails !=
//                         null) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Furnishing'),
//                       Builder(
//                         builder: (context) {
//                           log(
//                             '[PropertyDetail] 🛋️ Building FurnishingDetails',
//                           );
//                           return FurnishingDetails(
//                             property: currentProperty,
//                             bgColor: ColorRes.propertyBg,
//                             txtColor: ColorRes.propertyText,
//                           );
//                         },
//                       ),
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                     ],
//
//                     if (currentProperty.listingType?.toUpperCase() == "PG" &&
//                         currentProperty.propertyDetails?.pgInfo?.pgRules !=
//                             null) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'PG Rules'),
//                       const SizedBox(height: 8),
//                       _buildPgRulesSection(
//                         currentProperty.propertyDetails!.pgInfo!.pgRules!,
//                       ),
//                       const SizedBox(height: 12),
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                     ],
//
//                     if (currentProperty.listingType?.toUpperCase() == "PG" &&
//                         currentProperty.propertyDetails?.pgInfo?.pgRoomInfo !=
//                             null &&
//                         currentProperty
//                             .propertyDetails!
//                             .pgInfo!
//                             .pgRoomInfo!
//                             .isNotEmpty) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Room Options & Pricing'),
//                       const SizedBox(height: 8),
//                       _buildRoomOptionsSection(
//                         currentProperty.propertyDetails!.pgInfo!.pgRoomInfo!,
//                       ),
//                       const SizedBox(height: 12),
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                     ],
//
//                     if (currentProperty.propertyDescription != null) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Description'),
//                       const SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text(
//                           currentProperty.propertyDescription ?? '-',
//                           style: const TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                     ],
//
//                     if (currentProperty.propertyDetails?.financialInfo !=
//                         null) ...[
//                       const SizedBox(height: 12),
//                       ExpandableTile(
//                         title: "Investment Insights",
//                         subtitle: "Show Trends of Property",
//                         leadingIcon: Icons.trending_up_outlined,
//                         trailingIcon: Icons.keyboard_arrow_down_rounded,
//                         children: [
//                           const TitleWithViewAll(title: 'Investment Insight'),
//                           const SizedBox(height: 8),
//                           Builder(
//                             builder: (context) {
//                               log(
//                                 '[PropertyDetail] 📊 Building InvestmentInsightChart',
//                               );
//                               return InvestmentInsightChart(
//                                 currentProperty: currentProperty,
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//
//                     if (currentProperty.location?.isNotEmpty ?? false) ...[
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Location'),
//                       const SizedBox(height: 8),
//                       Builder(
//                         builder: (context) {
//                           log(
//                             '[PropertyDetail] 🗺️ Building AddressAndMapDetails',
//                           );
//                           return AddressAndMapDetails(
//                             address: currentProperty.address ?? '',
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//
//                     Builder(
//                       builder: (context) {
//                         log('[PropertyDetail] 🗺️ Building Map Section Obx');
//                         return Obx(() {
//                           if (mapController.isLoading.value) {
//                             return const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.all(16.0),
//                                 child: CircularProgressIndicator(),
//                               ),
//                             );
//                           }
//
//                           final hasData = mapController.allCategoriesData.values
//                               .any((places) => places.isNotEmpty);
//
//                           if (!hasData ||
//                               mapController.propertyLatLng.value == null) {
//                             print('No data found');
//                             return const SizedBox.shrink();
//                           }
//
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Divider(
//                                 indent: 18,
//                                 endIndent: 18,
//                                 color: ColorRes.leadGreyColor.shade300,
//                               ),
//                               const SizedBox(height: 12),
//                               NearbyLocationMapSection(
//                                 address: currentProperty.address ?? '',
//                                 mapController: mapController,
//                               ),
//                               const SizedBox(height: 12),
//                             ],
//                           );
//                         });
//                       },
//                     ),
//
//                     if (currentProperty.ownerName?.isNotEmpty ?? false) ...[
//                       Divider(
//                         indent: 18,
//                         endIndent: 18,
//                         color: ColorRes.leadGreyColor.shade300,
//                       ),
//                       const SizedBox(height: 12),
//                       const TitleWithViewAll(title: 'Owner Details'),
//                       const SizedBox(height: 8),
//                       Builder(
//                         builder: (context) {
//                           log(
//                             '[PropertyDetail] 👤 Building OwnerInformation - START',
//                           );
//                           final widget = OwnerInformation(
//                             property: currentProperty,
//                             controller: controller,
//                           );
//                           log(
//                             '[PropertyDetail] 👤 Building OwnerInformation - END',
//                           );
//                           return widget;
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//
//                     Builder(
//                       builder: (context) {
//                         log(
//                           '[PropertyDetail] ⭐ Building ReviewSection - START',
//                         );
//                         final widget = ReviewSection(
//                           canAddReview: canAddReview,
//                           overallController: _overallRatingController,
//                           reviewController: reviewController,
//                           entityType: "property",
//                           entityId: currentProperty.id ?? '',
//                           reviewCardBuilder:
//                               (context, item) =>
//                                   PropertyReviewCard(reviewItem: item),
//                           overallWidgetBuilder: (total, rating, details) {
//                             return OverallRatingWidget(
//                               totalReviews: total,
//                               overallRating: rating,
//                               detailedRatings: details,
//                             );
//                           },
//                         );
//                         log('[PropertyDetail] ⭐ Building ReviewSection - END');
//                         return widget;
//                       },
//                     ),
//
//                     Divider(
//                       indent: 18,
//                       endIndent: 18,
//                       color: ColorRes.leadGreyColor.shade300,
//                     ),
//                     const SizedBox(height: 12),
//                     const TitleWithViewAll(
//                       title: 'Recommended Properties',
//                       showViewAll: true,
//                     ),
//                     const SizedBox(height: 12),
//                     Builder(
//                       builder: (context) {
//                         log(
//                           '[PropertyDetail] 🏘️ Building RecommendedProperty - START',
//                         );
//                         const widget = RecommendedProperty();
//                         log(
//                           '[PropertyDetail] 🏘️ Building RecommendedProperty - END',
//                         );
//                         return widget;
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                 ),
//               ),
//               Builder(
//                 builder: (context) {
//                   log('[PropertyDetail] 🔘 Building ComparisonFloatingButton');
//                   return UnifiedComparisonFloatingButton(bottom: 16);
//                 },
//               ),
//             ],
//           ),
//         );
//       }),
//
//       bottomNavigationBar: Obx(() {
//         log(
//           '[PropertyDetail] 🔄 BottomBar Obx rebuild - isLoading: ${_isLoading.value}',
//         );
//
//         if (_isLoading.value) {
//           return const SizedBox.shrink();
//         }
//
//         final currentProperty = _property.value;
//         if (currentProperty == null) {
//           return const SizedBox.shrink();
//         }
//
//         log('[PropertyDetail] 📊 Creating BottomBar priceManager');
//         final priceManager = PropertyPriceManager(
//           financialInfo:
//               currentProperty.propertyDetails?.financialInfo ?? FinancialInfo(),
//           listingType: currentProperty.listingType ?? '',
//         );
//
//         return SafeArea(
//           child: ReusableBottomBar(
//             mainPriceText: priceManager.totalPriceDisplay,
//             priceBreakdown: priceManager.propertyPriceSummary,
//             onPrimaryAction: () {
//               if (UserHelper.isGuest) {
//                 Get.to(() => LoginScreen());
//               } else {
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(20),
//                     ),
//                   ),
//                   builder:
//                       (context) => DraggableScrollableSheet(
//                         expand: false,
//                         minChildSize: 0.45,
//                         initialChildSize:
//                             controller.hasSubmittedInquiry.value ? 0.45 : 0.85,
//                         maxChildSize:
//                             controller.hasSubmittedInquiry.value ? 0.45 : 0.85,
//                         builder:
//                             (
//                               context,
//                               scrollController,
//                             ) => SingleChildScrollView(
//                               controller: scrollController,
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   bottom:
//                                       MediaQuery.of(context).viewInsets.bottom,
//                                   left: 16,
//                                   right: 16,
//                                   top: 16,
//                                 ),
//                                 child: ContactOwnerBottom(
//                                   price: priceManager.actualPrice,
//                                   listingType:
//                                       currentProperty.listingType
//                                           ?.toLowerCase() ??
//                                       '',
//                                   forRentPrice:
//                                       currentProperty
//                                           .propertyDetails
//                                           ?.financialInfo
//                                           ?.propertyRentPerMonth ??
//                                       0,
//                                   forSellPrice:
//                                       currentProperty
//                                           .propertyDetails
//                                           ?.financialInfo
//                                           ?.price ??
//                                       0,
//                                   isForSell:
//                                       currentProperty
//                                           .propertyDetails
//                                           ?.financialInfo
//                                           ?.is_for_sellorrent ??
//                                       false,
//
//                                   inQuireSubmitted:
//                                       controller.hasSubmittedInquiry.value,
//                                   titleText: "Contact the Owner",
//                                   chatButtonText: "Chat via WhatsApp",
//                                   formTitle: "Quick Contact Form",
//                                   contactButtonText: "Send Request",
//                                   nameIcon: Icons.person,
//                                   phoneIcon: Icons.phone,
//                                   emailIcon: Icons.email,
//                                   allowSellerContact: false,
//                                   negotiable: false,
//
//                                   bookSiteVisit: false,
//                                   onChatPressed: () {
//                                     print("WhatsApp button clicked!");
//                                   },
//                                   onContactPressed: (
//                                     name,
//                                     phone,
//                                     email,
//                                     price,
//                                     isNegotiable,
//
//                                     isAllowAllCondition,
//                                     inquiryListing,
//                                     isBookSiteVisit,
//                                     planningToBuy,
//                                     date,
//                                     time,
//                                   ) async {
//                                     final inquiry = {
//                                       "name": name ?? "",
//                                       "phone": phone ?? "",
//                                       "email": email ?? "",
//                                       "agreeToContact":
//                                           isAllowAllCondition ?? false,
//                                       "meta": {
//                                         if (price != null)
//                                           "negotiablePrice": price,
//                                         if (inquiryListing != null &&
//                                             (inquiryListing?.isNotEmpty ??
//                                                 false))
//                                           "inquiryType":
//                                               inquiryListing.toLowerCase(),
//                                         if (isNegotiable != null)
//                                           "isNegotiable": isNegotiable,
//                                         if (planningToBuy != null)
//                                           "timePeriod": planningToBuy,
//                                         if (date != null)
//                                           "visitDate":
//                                               '${date.day}-${date.month}-${date.year}',
//                                         if (time != null)
//                                           "visitTime":
//                                               '${time.hour.toString().padLeft(2, '0')}:'
//                                               '${time.minute.toString().padLeft(2, '0')}',
//                                       },
//                                     };
//
//                                     print('Submitting inquiry: ${inquiry}');
//
//                                     final success = await controller.addInquiry(
//                                       inquiry,
//                                       currentProperty.id ?? '',
//                                     );
//
//                                     if (success) {
//                                       controller.hasSubmittedInquiry.value =
//                                           true;
//                                       CustomSnackBar.show(
//                                         Get.overlayContext!,
//                                         message: "Inquiry Added Successfully",
//                                         type: SnackBarType.success,
//                                       );
//                                       Get.back();
//                                       await controller.getAllInQuireData(
//                                         widget.propertyId ?? '',
//                                       );
//                                     } else {
//                                       CustomSnackBar.show(
//                                         Get.overlayContext!,
//                                         message: "Failed to Submit Inquiry",
//                                         type: SnackBarType.error,
//                                       );
//                                     }
//                                   },
//                                   onAllowSellerContactChanged: (value) {
//                                     print("Allow sellers changed: $value");
//                                   },
//                                   onHomeLoanInterestChanged: (value) {
//                                     print("Home loan interest changed: $value");
//                                   },
//                                 ),
//                               ),
//                             ),
//                       ),
//                 );
//               }
//             },
//             primaryTitle: "View Contact",
//           ),
//         );
//       }),
//     );
//   }
//
//   // Also remove this getter since we're using _property.value directly
//   // Items? get property => _property.value;
//
//   Widget _buildMediaBanner(PropertyMedia media, String id) {
//     final PageController pageController = PageController();
//     final images = media.images ?? [];
//     final videos = media.videos ?? [];
//     final List<Map<String, String>> mediaList = [
//       ...images.map((e) => {"type": "image", "url": e}),
//       ...videos.map((e) => {"type": "video", "url": e}),
//     ];
//
//     int currentPage = 0;
//
//     return SafeArea(
//       child: StatefulBuilder(
//         builder: (context, setState) {
//           return Stack(
//             children: [
//               /// Media (Image / Video)
//               SizedBox(
//                 height: 300,
//                 width: double.infinity,
//                 child: PageView.builder(
//                   controller: pageController,
//                   itemCount: mediaList.length,
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentPage = index;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     final item = mediaList[index];
//                     if (item["type"] == "image") {
//                       return Image.network(
//                         item["url"]!,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       );
//                     } else if (item["type"] == "video") {
//                       return CustomVideoPlayer(url: item["url"]!);
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ),
//
//               /// Back button
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 child: CircularIcon(
//                   icon: Icons.arrow_back_rounded,
//                   backgroundColor: ColorRes.white,
//                   onPressed: () => Get.back(),
//                 ),
//               ),
//
//               /// Right side icons (compare, favorite, share)
//               // Positioned(
//               //   top: 16,
//               //   right: 16,
//               //   child: Row(
//               //     children: [
//               //       // Compare button
//               //       Obx(() {
//               //         final selected = compare.isSelected(id);
//               //         return CircularIcon(
//               //           icon: Icons.compare_arrows,
//               //           backgroundColor:
//               //               selected ? ColorRes.primary : ColorRes.white,
//               //           iconColor: selected ? ColorRes.white : ColorRes.primary,
//               //           onPressed: () {
//               //             final before = compare.count;
//               //             compare.toggle(property!, max: 2);
//               //             final after = compare.count;
//               //
//               //             final ctx = Get.overlayContext;
//               //             if (ctx != null) {
//               //               if (after > before) {
//               //                 CustomSnackBar.show(
//               //                   ctx,
//               //                   message:
//               //                       after == 2
//               //                           ? 'Ready to compare!'
//               //                           : 'Added to compare (${after}/2)',
//               //                   type: SnackBarType.success,
//               //                   actionLabel: after == 2 ? 'Compare Now' : null,
//               //                   onActionPressed:
//               //                       after == 2
//               //                           ? () {
//               //                             Get.back(); // Close snackbar first
//               //                             if (Get.isRegistered<
//               //                               NavigationController
//               //                             >()) {
//               //                               Get.find<NavigationController>()
//               //                                   .changeIndex(2);
//               //                             }
//               //                           }
//               //                           : null,
//               //                 );
//               //               } else if (after < before) {
//               //                 CustomSnackBar.show(
//               //                   ctx,
//               //                   message:
//               //                       after == 0
//               //                           ? 'Removed from compare'
//               //                           : 'Removed from compare (${after}/2)',
//               //                   type: SnackBarType.info,
//               //                 );
//               //               } else if (after == before && before >= 2) {
//               //                 CustomSnackBar.show(
//               //                   ctx,
//               //                   message: 'You can only compare 2 properties',
//               //                   type: SnackBarType.warning,
//               //                 );
//               //               }
//               //             }
//               //           },
//               //         );
//               //       }),
//               //       const SizedBox(width: 12),
//               //       // Favorite button
//               //       Obx(() {
//               //         final isFavorite = favoriteController.favorites.contains(
//               //           id,
//               //         );
//               //         return CircularIcon(
//               //           icon:
//               //               isFavorite
//               //                   ? Icons.favorite
//               //                   : Icons.favorite_border_rounded,
//               //           backgroundColor: ColorRes.white,
//               //           iconColor:
//               //               isFavorite
//               //                   ? ColorRes.redAccentColor
//               //                   : ColorRes.black,
//               //           onPressed: () {
//               //             favoriteController.toggleFavorite(id);
//               //           },
//               //         );
//               //       }),
//               //       const SizedBox(width: 12),
//               //       // Share button
//               //       CircularIcon(
//               //         icon: Icons.share_outlined,
//               //         onPressed: () {},
//               //         backgroundColor: ColorRes.white,
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Positioned(
//                 top: 16,
//                 right: 16,
//                 child: EntityActionButtons(
//                   id: property?.id ?? '',
//                   entity: property,
//                   compareController: compare,
//                   favoriteController: favoriteController,
//                 ),
//               ),
//
//               /// Page indicator
//               Positioned(
//                 bottom: 16,
//                 right: 16,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: ColorRes.blackShade54,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     '${currentPage + 1}/${mediaList.length}',
//                     style: const TextStyle(
//                       color: ColorRes.white,
//                       fontSize: AppFontSizes.small,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// 🔹 RERA Tag (Bottom Left inside image)
//               // Positioned(
//               //   bottom: 16,
//               //   left: 16,
//               //   child: Container(
//               //     padding: const EdgeInsets.symmetric(
//               //       horizontal: 8,
//               //       vertical: 4,
//               //     ),
//               //     decoration: BoxDecoration(
//               //       color: ColorRes.green.withOpacity(0.9),
//               //       borderRadius: BorderRadius.circular(6),
//               //     ),
//               //     child: Row(
//               //       mainAxisSize: MainAxisSize.min,
//               //       children: [
//               //         const Icon(Icons.verified, size: 14, color: ColorRes.white),
//               //         const SizedBox(width: 4),
//               //         const Text(
//               //           "RERA",
//               //           style: TextStyle(
//               //             fontSize: 12,
//               //             fontWeight: AppFontWeights.semiBold,
//               //             color: ColorRes.white,
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               Obx(() {
//                 return Positioned(
//                   left: 16,
//                   bottom: 16,
//                   child: Row(
//                     children: [
//                       ReraComponent(
//                         text:
//                             (!controller.isDeveloper.value)
//                                 ? "Verified"
//                                 : "rera",
//                         backgroundColor: ColorRes.black.withOpacity(0.7),
//                         textColor: ColorRes.background,
//                         fontSize: AppFontSizes.small,
//
//                         borderRadius: AppRadius.small,
//                         fontWeight: AppFontWeights.bold,
//                         showIcon: true,
//                         iconColor: ColorRes.success,
//                         iconSize: 14,
//                       ),
//                       const SizedBox(width: 8),
//                       if (property
//                               ?.scoreBreakdown
//                               ?.components
//                               .premium
//                               .isPremium ??
//                           false)
//                         ReraComponent(
//                           text: "NesticoPe Assured",
//                           backgroundColor: ColorRes.black.withOpacity(0.7),
//                           textColor: ColorRes.background,
//
//                           iconColor: ColorRes.primary,
//                           fontSize: AppFontSizes.small,
//                           borderRadius: AppRadius.small,
//                           fontWeight: AppFontWeights.bold,
//                           showIcon: true,
//                         ),
//                     ],
//                   ),
//                 );
//               }),
//               // Obx(() {
//               //   return Positioned(
//               //     left: 16,
//               //     bottom: 16,
//               //     child: ReraComponent(
//               //       text: (!controller.isDeveloper.value) ? "Verified" : "rera",
//               //       backgroundColor: ColorRes.black.withOpacity(0.7),
//               //       textColor: ColorRes.background,
//               //       fontSize: AppFontSizes.small,
//               //
//               //       borderRadius: AppRadius.small,
//               //       fontWeight: AppFontWeights.bold,
//               //       showIcon: true,
//               //       iconColor: ColorRes.success,
//               //       iconSize: 14,
//               //     ),
//               //   );
//               // }),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTitleSection(Items property) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 🔹 RERA Tag + Rating Row
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     // Left: RERA Tag
//           //     Container(
//           //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           //       decoration: BoxDecoration(
//           //         color: Colors.green.withOpacity(0.1),
//           //         borderRadius: BorderRadius.circular(6),
//           //         border: Border.all(color: Colors.green.shade400, width: 0.8),
//           //       ),
//           //       child: Row(
//           //         mainAxisSize: MainAxisSize.min,
//           //         children: [
//           //           Icon(Icons.verified, size: 14, color: Colors.green.shade600),
//           //           const SizedBox(width: 4),
//           //           Text(
//           //             "RERA",
//           //             style: TextStyle(
//           //               fontSize: 12,
//           //               fontWeight: AppFontWeights.semiBold,
//           //               color: Colors.green.shade700,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //
//           //     // Right: ⭐ Rating
//           //     Container(
//           //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           //       // decoration: BoxDecoration(
//           //       //   color: ColorRes.leadGreyColor[200], // light gray background
//           //       //   borderRadius: BorderRadius.circular(6), // rounded corners
//           //       // ),
//           //       child: Row(
//           //         mainAxisSize: MainAxisSize.min,
//           //         children:  [
//           //           Icon(Icons.star, size: 16, color: Colors.amber),
//           //           SizedBox(width: 4),
//           //           Text(
//           //             "4.5",
//           //             style: TextStyle(
//           //               fontSize: 14,
//           //               fontWeight: AppFontWeights.semiBold,
//           //               color: Colors.black,
//           //             ),
//           //           ),
//           //           SizedBox(width: 4),
//           //           Text(
//           //             "(14 reviews)",
//           //             style: TextStyle(
//           //               fontSize: 11,
//           //               fontWeight: AppFontWeights.medium,
//           //               color: Colors.black.withOpacity(0.6),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //
//           //
//           //
//           //   ],
//           // ),
//
//           //  const SizedBox(height: 6),
//
//           // 🔹 Title
//           if (property.type!.toLowerCase() == "residential")
//             Text(
//               "${property.propertyDetails?.bhk ?? 0} BHK ${property.propertyType!.capitalize}",
//               style: const TextStyle(
//                 fontWeight: AppFontWeights.semiBold,
//
//                 fontSize: AppFontSizes.body,
//                 color: ColorRes.blackShade87,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           if (property.type!.toLowerCase() == "commercial")
//             Text(
//               "${property.propertyType!.capitalize}",
//               style: const TextStyle(
//                 fontWeight: AppFontWeights.semiBold,
//
//                 fontSize: AppFontSizes.body,
//                 color: ColorRes.blackShade87,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//
//           const SizedBox(height: 4),
//
//           // 📍 Location Row
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Icon(
//               //   Icons.location_on_rounded,
//               //   size: 16,
//               //   color: ColorRes.leadGreyColor[600],
//               // ),
//               // const SizedBox(width: 4),
//               Expanded(
//                 child: Text(
//                   '${property.city ?? '-'}, ${property.state ?? "-"}',
//                   style: TextStyle(
//                     fontSize: AppFontSizes.bodySmall,
//                     color: ColorRes.leadGreyColor[600],
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 4),
//
//           // 🔹 Type + See on Map
//           Row(
//             children: [
//               if (property.listingType != null)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: ColorRes.primary.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(AppRadius.small),
//                   ),
//                   child: Text(
//                     property.listingType!.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.primary,
//                     ),
//                   ),
//                 ),
//
//               const Spacer(),
//
//               GestureDetector(
//                 onTap: () {
//                   if (property.location != null) {
//                     ContactHelper.openInGoogleMaps(property.address!);
//                   }
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: ColorRes.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(AppRadius.small),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.location_pin,
//                         size: 16,
//                         color: ColorRes.primary,
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         "See on Map",
//                         style: TextStyle(
//                           fontSize: AppFontSizes.small,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Inline video player builder
//   Widget _buildVideoPlayer(String url) {
//     final VideoPlayerController videoController = VideoPlayerController.network(
//       url,
//     );
//
//     return FutureBuilder(
//       future: videoController.initialize(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           videoController.setLooping(true);
//           videoController.play();
//           return AspectRatio(
//             aspectRatio: videoController.value.aspectRatio,
//             child: VideoPlayer(videoController),
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
//
//   /// PG Rules Section Builder
//   Widget _buildPgRulesSection(PgRules rules) {
//     final rulesList = <Map<String, dynamic>>[];
//
//     if (rules.nonVegAllowed != null) {
//       rulesList.add({
//         'label': 'Non-Veg',
//         'allowed': rules.nonVegAllowed!,
//         'icon': Icons.restaurant,
//       });
//     }
//     if (rules.petsAllowed != null) {
//       rulesList.add({
//         'label': 'Pets',
//         'allowed': rules.petsAllowed!,
//         'icon': Icons.pets,
//       });
//     }
//     if (rules.lateEntryAllowed != null) {
//       rulesList.add({
//         'label': 'Late Entry',
//         'allowed': rules.lateEntryAllowed!,
//         'icon': Icons.access_time,
//       });
//     }
//     if (rules.smokingAllowed != null) {
//       rulesList.add({
//         'label': 'Smoking',
//         'allowed': rules.smokingAllowed!,
//         'icon': Icons.smoke_free,
//       });
//     }
//     if (rules.drinkingAllowed != null) {
//       rulesList.add({
//         'label': 'Drinking',
//         'allowed': rules.drinkingAllowed!,
//         'icon': Icons.no_drinks,
//       });
//     }
//     if (rules.visitorAllowed != null) {
//       rulesList.add({
//         'label': 'Visitor',
//         'allowed': rules.visitorAllowed!,
//         'icon': Icons.people,
//       });
//     }
//
//     if (rulesList.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: Text(
//           'No rules specified',
//           style: TextStyle(
//             fontSize: AppFontSizes.bodySmall,
//             color: ColorRes.leadGreyColor,
//           ),
//         ),
//       );
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 12,
//         children:
//             rulesList.map((rule) {
//               final isAllowed = rule['allowed'] as bool;
//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color:
//                       isAllowed
//                           ? ColorRes.green.withOpacity(0.02)
//                           : ColorRes.error.withOpacity(0.02),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color:
//                         isAllowed
//                             ? ColorRes.green.withOpacity(0.8)
//                             : ColorRes.error.withOpacity(0.8),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       rule['icon'] as IconData,
//                       size: 16,
//                       color:
//                           isAllowed
//                               ? ColorRes.green.withOpacity(0.8)
//                               : ColorRes.error.withOpacity(0.8),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       rule['label'] as String,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.bodySmall,
//                         fontWeight: AppFontWeights.medium,
//                         color:
//                             isAllowed
//                                 ? ColorRes.green.withOpacity(0.8)
//                                 : ColorRes.error.withOpacity(0.8),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Icon(
//                       isAllowed ? Icons.check_circle : Icons.cancel,
//                       size: 14,
//                       color:
//                           isAllowed
//                               ? ColorRes.green.withOpacity(0.8)
//                               : ColorRes.error.withOpacity(0.8),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }
//
//   /// Room Options & Pricing Section Builder
//   Widget _buildRoomOptionsSection(List<PgRoomInfo> rooms) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children:
//             rooms.map((room) {
//               return Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: ColorRes.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: ColorRes.leadGreyColor.shade300),
//                   boxShadow: [
//                     BoxShadow(
//                       color: ColorRes.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           room.roomType?.toUpperCase() ?? 'Room',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: ColorRes.textPrimary,
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: ColorRes.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${Formatter.formatPrice(room.rent ?? 0)} / month',
//                             style: const TextStyle(
//                               fontSize: AppFontSizes.small,
//                               fontWeight: AppFontWeights.semiBold,
//                               color: ColorRes.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     if (room.securityDeposit != null &&
//                         room.securityDeposit! > 0) ...[
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.security,
//                             size: 14,
//                             color: ColorRes.leadGreyColor,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Security Deposit: ${Formatter.formatPrice(room.securityDeposit ?? 0)}',
//                             style: TextStyle(
//                               fontSize: AppFontSizes.small,
//                               color: ColorRes.leadGreyColor.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//
//                     // Room Facilities
//                     if (room.roomFacilityInfo != null) ...[
//                       const SizedBox(height: 12),
//                       const Text(
//                         'Facilities:',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.bodySmall,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.blackShade87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _buildFacilityChips(room.roomFacilityInfo!),
//                       ),
//                     ],
//                   ],
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }
//
//   /// Build facility chips for room
//   List<Widget> _buildFacilityChips(RoomFacilityInfo facilities) {
//     final chips = <Widget>[];
//
//     if (facilities.wifi == true) {
//       chips.add(_buildFacilityChip('WiFi', Icons.wifi));
//     }
//     if (facilities.ac == true) {
//       chips.add(_buildFacilityChip('AC', Icons.ac_unit));
//     }
//     if (facilities.tv == true) {
//       chips.add(_buildFacilityChip('TV', Icons.tv));
//     }
//     if (facilities.geyser == true) {
//       chips.add(_buildFacilityChip('Geyser', Icons.hot_tub));
//     }
//     if (facilities.fridge == true) {
//       chips.add(_buildFacilityChip('Fridge', Icons.kitchen));
//     }
//     if (facilities.cupboard == true) {
//       chips.add(_buildFacilityChip('Cupboard', Icons.door_sliding));
//     }
//     if (facilities.other != null && facilities.other!.isNotEmpty) {
//       chips.add(_buildFacilityChip(facilities.other!, Icons.more_horiz));
//     }
//
//     if (chips.isEmpty) {
//       chips.add(
//         const Text(
//           'No facilities specified',
//           style: TextStyle(
//             fontSize: AppFontSizes.caption,
//             color: ColorRes.leadGreyColor,
//           ),
//         ),
//       );
//     }
//
//     return chips;
//   }
//
//   /// Build individual facility chip
//   Widget _buildFacilityChip(String label, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: ColorRes.primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: ColorRes.primary),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: AppFontSizes.caption,
//               fontWeight: AppFontWeights.medium,
//               color: ColorRes.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CircularIcon extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onPressed;
//   final Color? backgroundColor; // add this
//   final Color? iconColor;
//   final double sizeContainer;
//   final double iconSize; // add this
//
//   const CircularIcon({
//     super.key,
//     required this.icon,
//     this.onPressed,
//     this.backgroundColor, // add this
//     this.iconColor,
//     this.sizeContainer = 40,
//     this.iconSize = 24,
//     // add this
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: sizeContainer,
//         width: sizeContainer,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           color: backgroundColor ?? ColorRes.leadGreyColor.shade300, // fallback
//         ),
//         child: Icon(icon, color: iconColor ?? ColorRes.black, size: iconSize),
//       ),
//     );
//   }
// }
//
// class Facilities extends StatelessWidget {
//   final Items property;
//   final Color bgColor;
//   final Color txtColor;
//
//   const Facilities({
//     super.key,
//     required this.property,
//     this.bgColor = ColorRes.propertyBg,
//     this.txtColor = ColorRes.propertyText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final highlights = PropertyHighlightManager(property).getHighlights();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 12,
//         children:
//             highlights.map((item) {
//               // final key = item.keys.first;
//               // final value = item.values.first;
//               // final icon = iconMap[key] ?? Icons.info_outline;
//
//               return FacilitiesCard(
//                 label: item.value,
//                 icon: item.icon ?? Icons.info_outline,
//                 bgColor: bgColor,
//                 foreColor: txtColor,
//               );
//             }).toList(),
//       ),
//     );
//   }
// }
//
// class FacilitiesCard extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Color bgColor;
//   final Color foreColor;
//
//   const FacilitiesCard({
//     Key? key,
//     required this.label,
//     required this.icon,
//     required this.bgColor,
//     required this.foreColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(
//         minWidth: 80,
//       ), // 👈 ensures small labels don't shrink too much
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: ColorRes.primary, width: 1),
//         borderRadius: BorderRadius.circular(20), // pill-like
//         color: ColorRes.white,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 16, color: ColorRes.primary),
//           const SizedBox(width: 6),
//           Flexible(
//             child: Text(
//               label,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis, // prevent overflow
//               style: TextStyle(
//                 fontSize: AppFontSizes.bodySmall,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.leadGreyColor.shade800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Details extends StatelessWidget {
//   final Items property;
//   final PropertyController controller = Get.put(PropertyController());
//
//   Details({super.key, required this.property});
//
//   @override
//   Widget build(BuildContext context) {
//     final manager = PropertyDetailManager(property);
//     final details = manager.getDetails();
//
//     return Obx(() {
//       final isExpanded = controller.isExpanded.value;
//       final visibleDetails = details;
//       // final visibleDetails = isExpanded ? details : details.take(4).toList();
//
//       final screenWidth = MediaQuery.of(context).size.width;
//       final itemWidth = (screenWidth / 2) - 26;
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 🔹 Details Grid
//           Center(
//             child: Wrap(
//               crossAxisAlignment: WrapCrossAlignment.start,
//               spacing: 20,
//               runSpacing: 12,
//               children:
//                   visibleDetails.map((entry) {
//                     final title = entry.keys.first;
//                     final value = entry.values.first;
//
//                     return SizedBox(
//                       width: itemWidth,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             title,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: AppFontSizes.caption,
//                               fontWeight: AppFontWeights.medium,
//                               color: ColorRes.leadGreyColor[700],
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             value,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: const TextStyle(
//                               fontSize: AppFontSizes.small,
//                               fontWeight: AppFontWeights.semiBold,
//                               color: ColorRes.blackShade87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
//
// class AmenitiesSection extends StatelessWidget {
//   final List<String> amenities;
//
//   AmenitiesSection({super.key, required this.amenities});
//
//   Color bgColor = ColorRes.propertyBg; // single background color
//   Color txtColor = ColorRes.propertyText; // single text/icon color
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 12,
//         children:
//             amenities.map((item) {
//               print("Items: $item");
//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   // color: bgColor,
//                   color: ColorRes.overlay.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       IconManager.getAmenitiesIcon(item),
//                       size: 16,
//                       color: txtColor,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       StringManager.formatLabel(item) ?? ' -',
//                       style: const TextStyle(
//                         fontSize: AppFontSizes.small,
//                         fontWeight: AppFontWeights.medium,
//                         // color: txtColor,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }
// }
//
// class NearbyPropertyDetails extends StatelessWidget {
//   final List<NearbyLocations> nearbyLocations;
//
//   const NearbyPropertyDetails({super.key, required this.nearbyLocations});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
//       child: SizedBox(
//         height: 75, // slightly taller for balance
//         child: ListView.separated(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: nearbyLocations.length,
//           separatorBuilder: (context, index) => const SizedBox(width: 12),
//           itemBuilder: (context, index) {
//             final loc = nearbyLocations[index];
//
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppPadding.small,
//                 vertical: AppPadding.small,
//               ),
//               decoration: BoxDecoration(
//                 color: ColorRes.white, // ✅ soft background
//                 borderRadius: BorderRadius.circular(AppRadius.medium),
//                 border: Border.all(
//                   color: ColorRes.leadGreyColor.shade300,
//                   width: 0.8,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildCommonText(
//                     loc.name ?? "-",
//                     AppFontSizes.caption,
//                     AppFontWeights.medium,
//                     ColorRes.textColor,
//                     1,
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: ColorRes.grey.withOpacity(0.7),
//                       ),
//                       const SizedBox(width: 4),
//                       buildCommonText(
//                         (loc.distance != null) ? '${loc.distance}' : "2.5 Km",
//                         AppFontSizes.extraSmall,
//                         AppFontWeights.semiBold,
//                         ColorRes.leadGreyColor.shade600,
//                         1,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class RecommendedInsights extends StatelessWidget {
//   final List<NearbyLocations> nearbyLocations;
//
//   const RecommendedInsights({super.key, required this.nearbyLocations});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
//       child: SizedBox(
//         height: 75, // slightly taller for balance
//         child: ListView.separated(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: nearbyLocations.length,
//           separatorBuilder: (context, index) => const SizedBox(width: 12),
//           itemBuilder: (context, index) {
//             final loc = nearbyLocations[index];
//
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: AppPadding.small,
//                 vertical: AppPadding.small,
//               ),
//               decoration: BoxDecoration(
//                 color: ColorRes.white, // ✅ soft background
//                 borderRadius: BorderRadius.circular(AppRadius.medium),
//                 border: Border.all(
//                   color: ColorRes.leadGreyColor.shade300,
//                   width: 0.8,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildCommonText(
//                     loc.name ?? "-",
//                     AppFontSizes.caption,
//                     AppFontWeights.medium,
//                     ColorRes.textColor,
//                     1,
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: ColorRes.grey.withOpacity(0.7),
//                       ),
//                       const SizedBox(width: 4),
//                       buildCommonText(
//                         (loc.distance != null) ? '${loc.distance}' : "2.5 Km",
//                         AppFontSizes.extraSmall,
//                         AppFontWeights.semiBold,
//                         ColorRes.leadGreyColor.shade600,
//                         1,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // Category-based Nearby Location Section with Google Map UI
//
// class OwnerInformation extends StatelessWidget {
//   final Items property;
//   final PropertyController controller;
//
//   const OwnerInformation({
//     super.key,
//     required this.property,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage: AssetImage(
//                       IMGRes.home2,
//                     ), // Use a real image or placeholder
//                     // backgroundColor: ColorRes.leadGreyColor[300], // fallback if no image
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           DataMasker.maskName(property.ownerName),
//                           style: const TextStyle(
//                             fontSize: AppFontSizes.small,
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         if (property.ownerPhone != null)
//                           Row(
//                             children: [
//                               // Icon(
//                               //   Icons.phone_outlined,
//                               //   size: 12,
//                               //   color: ColorRes.leadGreyColor,
//                               // ),
//                               // SizedBox(width: 6),
//                               Text(
//                                 DataMasker.maskPhone(property.ownerPhone),
//                                 style: const TextStyle(
//                                   color: ColorRes.grey,
//                                   fontSize: AppFontSizes.extraSmall,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         if (property.ownerEmail != null)
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   DataMasker.maskEmail(property.ownerEmail),
//                                   style: const TextStyle(
//                                     color: ColorRes.grey,
//                                     fontSize: AppFontSizes.extraSmall,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ContactSellerCard extends StatelessWidget {
//   final Items property;
//   final PropertyController controller = Get.put(PropertyController());
//
//   ContactSellerCard({super.key, required this.property});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Owner Info
//           Container(
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage: AssetImage(IMGRes.home2),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           property.ownerName ?? "-",
//                           style: const TextStyle(
//                             fontSize: AppFontSizes.small,
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         if (property.ownerPhone != null)
//                           Text(
//                             "+91 ${property.ownerPhone ?? '-'}",
//                             style: const TextStyle(
//                               color: ColorRes.grey,
//                               fontSize: AppFontSizes.extraSmall,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           // Checkboxes using Obx
//           Obx(
//             () => Row(
//               children: [
//                 Checkbox(
//                   value: controller.allowContact.value,
//                   onChanged:
//                       (val) => controller.allowContact.value = val ?? false,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   side: const BorderSide(color: ColorRes.grey, width: 1),
//                   activeColor: ColorRes.primary,
//                 ),
//                 const Expanded(
//                   child: Text(
//                     "Allow sellers to get in touch",
//                     style: TextStyle(fontSize: AppFontSizes.caption),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Obx(
//             () => Row(
//               children: [
//                 Checkbox(
//                   value: controller.interestedInHomeLoan.value,
//                   onChanged:
//                       (val) =>
//                           controller.interestedInHomeLoan.value = val ?? false,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   side: const BorderSide(color: ColorRes.grey, width: 1),
//                   activeColor: ColorRes.primary,
//                 ),
//                 const Expanded(
//                   child: Text(
//                     "I am interested in Home loans",
//                     style: TextStyle(fontSize: AppFontSizes.caption),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           // Info Row
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.thumb_up, size: 15, color: ColorRes.blackShade54),
//               SizedBox(width: 6),
//               Text(
//                 "Perfect Choice! Users like you also liked this",
//                 style: TextStyle(
//                   fontSize: AppFontSizes.extraSmall,
//                   color: ColorRes.blackShade54,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // Button
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(double.infinity, 40),
//               backgroundColor: ColorRes.primary,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             onPressed: () {},
//             child: const Text(
//               "Check availability with seller",
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.white,
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }
//
// class ProjectBrochure extends StatelessWidget {
//   final String brochureImageUrl;
//   final String brochureUrl;
//   final int totalPages;
//
//   const ProjectBrochure({
//     super.key,
//     required this.brochureImageUrl,
//     required this.brochureUrl,
//     this.totalPages = 9,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   "Project Brochure",
//           //   style: Theme.of(context).textTheme.titleMedium,
//           // ),
//           // const SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: ColorRes.leadGreyColor.shade200,
//               border: Border.all(
//                 color: ColorRes.grey.withOpacity(0.6),
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: AspectRatio(
//                 aspectRatio: 16 / 8,
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Image.network(
//                         brochureImageUrl,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         errorBuilder:
//                             (context, error, stackTrace) => const Icon(
//                               Icons.broken_image,
//                               size: 50,
//                               color: ColorRes.leadGreyColor,
//                             ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 8,
//                       left: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColorRes.blackShade54,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           "1/$totalPages",
//                           style: const TextStyle(
//                             color: ColorRes.white,
//                             fontSize: AppFontSizes.extraSmall,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: ColorRes.primary,
//                     ), // outline like OutlinedButton
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       // Share action
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 8,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.share, size: 15, color: ColorRes.primary),
//                           SizedBox(width: 8),
//                           Text(
//                             "Share",
//                             style: TextStyle(
//                               color: ColorRes.primary,
//                               fontSize: AppFontSizes.small,
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: ColorRes.blueColor, // same as ElevatedButton
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       // TODO: Open PDF viewer or download
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 8,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.download, size: 15, color: ColorRes.white),
//                           SizedBox(width: 8),
//                           Text(
//                             "Download",
//                             style: TextStyle(
//                               color: ColorRes.white,
//                               fontSize: AppFontSizes.small,
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProjectDetails extends StatelessWidget {
//   final String projectName;
//   final double minPrice;
//   final double maxPrice;
//   final String launchedDate;
//   final int units;
//   final double projectArea;
//   final String reraId;
//   final List<NearbyLocations> nearbyProjects;
//
//   const ProjectDetails({
//     super.key,
//     required this.projectName,
//     required this.minPrice,
//     required this.maxPrice,
//     required this.launchedDate,
//     required this.units,
//     required this.projectArea,
//     required this.reraId,
//     required this.nearbyProjects,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 80,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: nearbyProjects.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 12),
//               itemBuilder: (context, index) {
//                 final project = nearbyProjects[index];
//                 return Container(
//                   margin: const EdgeInsets.symmetric(
//                     vertical: AppPadding.small,
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: AppPadding.small,
//                     vertical: AppPadding.small,
//                   ),
//                   decoration: BoxDecoration(
//                     color: ColorRes.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color:
//                           project.name == projectName
//                               ? ColorRes.deepPurpleColor
//                               : ColorRes.leadGreyColor.shade300,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         project.name!,
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.caption,
//                           color: ColorRes.textColor,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${project.distance ?? '2.1 Km'}',
//                         style: const TextStyle(
//                           color: ColorRes.grey,
//                           fontSize: AppFontSizes.extraSmall,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           const SizedBox(height: 16),
//           // Additional Details
//           Row(
//             spacing: 25,
//             children: [
//               _detailItem("Launched in", 'Jul,2024'),
//               _verticalDivider(),
//               _detailItem("Units", units.toString()),
//               _verticalDivider(),
//               _detailItem("Project area", "$projectArea Acres"),
//             ],
//           ),
//           const SizedBox(height: 12),
//           // Text(
//           //   "RERA ID: $reraId",
//           //   style: TextStyle(
//           //     color: Colors.black54,
//           //     fontSize: AppFontSizes.small,
//           //   ),
//           // ),
//           _detailItem("RERA ID", reraId),
//           const SizedBox(height: 16),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.info_outline,
//                   color: ColorRes.primary,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.share,
//                   color: ColorRes.primary,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorRes.white,
//                     foregroundColor: ColorRes.primary,
//                     side: const BorderSide(color: ColorRes.primary, width: 1.5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: const Text(
//                     "View More Details",
//                     style: TextStyle(
//                       fontWeight: AppFontWeights.semiBold,
//                       fontSize: AppFontSizes.caption,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _detailItem(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 11, color: ColorRes.blackShade54),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontWeight: AppFontWeights.semiBold,
//             fontSize: AppFontSizes.small,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _verticalDivider() =>
//       Container(height: 20, width: 1, color: ColorRes.leadGreyColor);
// }
//
// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String? subText;
//   final IconData? icon;
//   final Color? iconColor;
//
//   const StatCard({
//     super.key,
//     required this.title,
//     required this.value,
//     this.subText,
//     this.icon,
//     this.iconColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       width: 165, // fixed width for balance
//       decoration: BoxDecoration(
//         color: ColorRes.leadGreyColor.shade200,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           /// Title
//           buildCommonText(
//             title,
//             AppFontSizes.caption,
//             AppFontWeights.semiBold,
//             ColorRes.textColor,
//             1,
//           ),
//           const SizedBox(height: 6),
//
//           /// Value + optional icon + subtext
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (icon != null) ...[
//                 Icon(icon, color: iconColor ?? ColorRes.black, size: 15),
//                 const SizedBox(width: 4),
//               ],
//               buildCommonText(
//                 value,
//                 AppFontSizes.extraSmall,
//                 AppFontWeights.semiBold,
//                 iconColor ?? ColorRes.black,
//                 1,
//               ),
//               if (subText != null) ...[
//                 const SizedBox(width: 4),
//                 buildCommonText(
//                   subText ?? '',
//                   AppFontSizes.extraSmall,
//                   FontWeight.normal,
//                   ColorRes.leadGreyColor,
//                   1,
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class PropertyFeedbackComponent extends StatefulWidget {
//   final Function(int rating, String feedback) onSubmit;
//
//   const PropertyFeedbackComponent({super.key, required this.onSubmit});
//
//   @override
//   State<PropertyFeedbackComponent> createState() =>
//       _PropertyFeedbackComponentState();
// }
//
// class _PropertyFeedbackComponentState extends State<PropertyFeedbackComponent> {
//   int _rating = 0;
//   final TextEditingController _feedbackController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         // width: MediaQuery.of(context).size.width * 0.9,
//         decoration: BoxDecoration(
//           border: Border.all(color: ColorRes.leadGreyColor.shade400, width: 1),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Feedback Property",
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               style: TextStyle(
//                 fontSize: AppFontSizes.subtitle,
//                 fontWeight: AppFontWeights.bold,
//                 color: ColorRes.primary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Rating ($_rating/5)",
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.leadGreyColor,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 return IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _rating = index + 1;
//                     });
//                   },
//                   icon: Icon(
//                     Icons.star,
//                     size: 32,
//                     color:
//                         index < _rating
//                             ? ColorRes.primary
//                             : ColorRes.leadGreyColor.shade400,
//                   ),
//                 );
//               }),
//             ),
//             // Text(
//             //   _rating == 0
//             //       ? "Tap stars to rate"
//             //       : "You rated $_rating star${_rating > 1 ? 's' : ''}",
//             //   style: TextStyle(
//             //     color: ColorRes.leadGreyColor[800],
//             //     fontSize: 13,
//             //     fontWeight: FontWeight.w400,
//             //   ),
//             // ),
//             const SizedBox(height: 10),
//
//             TextField(
//               controller: _feedbackController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: "Write your feedback...",
//                 hintStyle: const TextStyle(
//                   fontSize: 14,
//                   color: ColorRes.leadGreyColor,
//                 ),
//                 filled: true,
//                 fillColor: ColorRes.leadGreyColor[100],
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: ColorRes.leadGreyColor),
//                 ),
//                 border: OutlineInputBorder(
//                   borderSide: const BorderSide(color: ColorRes.leadGreyColor),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: ColorRes.primary),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 18),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_rating != 0 ||
//                       _feedbackController.text.trim().isNotEmpty) {
//                     widget.onSubmit(_rating, _feedbackController.text.trim());
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Feedback Submitted'),
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please add rating & feedback'),
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                     // toastification.show(
//                     //   context: context,
//                     //   title: Text('Please add rating & feedback'),
//                     //   type: ToastificationType.error,
//                     //   style: ToastificationStyle.flat,
//                     //   autoCloseDuration: Duration(seconds: 2),
//                     //   alignment: Alignment.topRight,
//                     //   direction: TextDirection.ltr,
//                     // );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColorRes.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   "Submit",
//                   style: TextStyle(
//                     fontSize: AppFontSizes.body,
//                     color: ColorRes.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/manager/data_masker.dart';
import 'package:nesticope_app/app/manager/icon_manager.dart';
import 'package:nesticope_app/app/manager/property/property_pricemanager.dart';
import 'package:nesticope_app/app/manager/string_manager.dart';
import 'package:nesticope_app/app/utils/bottom_sheet_form.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/app/widgets/video_player/custom_video_player.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/auth/views/login_screen.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/property/controllers/share_property_controller.dart';
import 'package:nesticope_app/modules/property/views/recommended_property.dart';
import 'package:nesticope_app/modules/property/views/widgets/investment_insigths_graph.dart';
import 'package:nesticope_app/modules/property/views/widgets/overall_rating_widget.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/read_more_or_less.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'package:nesticope_app/modules/review/controllers/review_controller.dart';
import 'package:nesticope_app/modules/review/views/widget/add_property_review.dart';
import 'package:nesticope_app/modules/review/views/widget/property_review_card.dart';
import 'package:nesticope_app/app/manager/compare_manager.dart';
import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:nesticope_app/modules/saved_property/controllers/property_contacted_controller.dart';
import 'package:nesticope_app/modules/saved_property/controllers/property_view_controller.dart';
import 'package:nesticope_app/widgets/bar/bottom_bar/customer_bottom_bar.dart';
import 'package:nesticope_app/widgets/bar/navigation_bar/navigation_Bar.dart';

import 'package:nesticope_app/modules/search_property/view/search_screen.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:timeago/timeago.dart' as timeFormatter;
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../app/constants/enum.dart';
import '../../../app/manager/property/property_name_manager.dart';
import '../../../app/manager/property_detail_manager.dart';
import '../../../app/manager/property_highlight_manager.dart';
import '../../../app/utils/helper_function/contact_helper.dart';
import '../../../app/widgets/expandable_tile/expandable_widget.dart';
import '../../../app/widgets/texts/headline_text.dart';
import '../../../data/network/overall_rating/model/overall_rating_model.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../../utils/common_widget/rera_widget.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/button/property_action_button.dart';
import '../../../widgets/map/address_and_map_detail.dart';
import '../../../widgets/map/near_by_location_map_section.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../../widgets/property/furnishing_details.dart';
import '../../home/widgets/unified_comparison_floating_button.dart';
import '../../location_price_matrix/controllers/location_price_matrix_controller.dart';
import '../../review/views/widget/property_project_review_section.dart';
import '../../search_property/controller/search_controller.dart';
import '../controllers/overall_rating_controller.dart';
import '../../../app/utils/helper_function/contact_helper.dart';
import '../../home/controllers/contact_controller.dart';

class PropertyDetailScreen extends StatefulWidget {
  // final Items? property;
  final String? propertyId;

  const PropertyDetailScreen({super.key, this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late final PropertyController controller;
  late final PropertyFavoriteController favoriteController;
  late final GoogleMapSearchController mapController;
  late final OverallRatingController _overallRatingController;
  late final ReviewController reviewController;
  final RxBool canAddReview = true.obs;

  final Rxn<Items> _property = Rxn<Items>();

  final RxBool _isLoading = true.obs;






  @override
  void initState() {
    super.initState();

    // Get property ID
    final propertyId = widget.propertyId ?? '';

    controller = Get.put(PropertyController(), tag: 'property_$propertyId');
    controller.checkTermsAndConditionApplyOrNot();

    mapController = Get.put(
      GoogleMapSearchController(),
      tag: 'map_$propertyId',
    );

    _overallRatingController = Get.put(
      OverallRatingController(),
      tag: 'rating_$propertyId',
    );

    reviewController = Get.put(ReviewController(), tag: 'review_$propertyId');

    favoriteController = Get.find<PropertyFavoriteController>();

    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _refreshUserActivityData() async {
    final PropertyFavoriteController favoriteController =
        Get.find<PropertyFavoriteController>();

    await favoriteController.loadData();

    if (Get.isRegistered<PropertyViewController>()) {
      final PropertyViewController viewController =
          Get.find<PropertyViewController>();
      await viewController.fetchViewedProperties();
      await favoriteController.loadViews(viewController.viewedProperties);
    }

    if (Get.isRegistered<PropertyContactedController>()) {
      final PropertyContactedController contactedController =
          Get.find<PropertyContactedController>();
      await contactedController.fetchContactedProperties();
    }
  }
  Future<void> _loadData() async {
    try {
      if (!mounted) return;

      _isLoading.value = true;

      final propertyId = widget.propertyId ?? '';
      // await controller.getAllInQuireData(propertyId);
      // await controller.getHasInQuireData(propertyId);
      await Future.wait([
        controller.getAllInQuireData(propertyId),
        controller.getHasInQuireData(propertyId),
      ]);

      final fetchedProperty = await controller.getPropertyById(
        widget.propertyId!,
      );

      if (!mounted) return;

      if (fetchedProperty == null) {
        _isLoading.value = false;

        if (mounted) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Error",
            message: 'Property not found',
            contentType: ContentType.failure,
          );
          Get.back();
        }
        return;
      }

      // --- FIX START: Register Controller BEFORE assigning _property.value ---
      Get.put(
        LocationPriceMatrixController(
          city: fetchedProperty.city ?? '',
          propertyType: fetchedProperty.propertyType ?? '',
          location: fetchedProperty.location ?? '',
          state: fetchedProperty.state ?? '',
        ),
        tag: 'matrix_${fetchedProperty.id}',
      );
      // --- FIX END ---

      // ✅ Set property BEFORE setting loading to false
      _property.value = fetchedProperty;

      final currentProperty = _property.value!;

      // Set review filter
      reviewController.filters.value = {"entity_id": currentProperty.id ?? ""};
      reviewController.filters.refresh();

      // Fetch nearby landmarks
      if (currentProperty.address?.isNotEmpty ?? false) {
        // await mapController.fetchAllCategoriesData(currentProperty.address!);
        await Future.wait([
          mapController.fetchAllCategoriesData(currentProperty.address!),
        ]);
      }

      // Check review permission
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      if (currentProperty.id != null) {
        final exists = await reviewController.isReviewExist(
          entityId: currentProperty.id!,
          reviewerId: userId,
        );
        canAddReview.value = !exists;
      }

      // Track view
      controller.addView(currentProperty.id ?? '');
      await Future.wait([
        _overallRatingController.fetchOverallRating(currentProperty.id ?? ''),
      ]);
      // Fetch overall rating
    } catch (e, s) {
    } finally {
      if (mounted) {
        _isLoading.value = false;
      }
    }
  }

  Widget _buildQuickContactBar(Items property) {
    final cc =
        Get.isRegistered<ContactController>()
            ? Get.find<ContactController>()
            : Get.put(ContactController());
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              if (cc.primaryPhone.value.isEmpty) {
                await cc.loadContacts(reset: true);
              }
              final number = cc.primaryPhone.value;
              if (number.isNotEmpty) {
                await ContactHelper.openDialer(number);
              }
            },
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final id = property.id ?? '';
              if (cc.primaryPhone.value.isEmpty) {
                await cc.loadContacts(reset: true);
              }
              final number = cc.primaryPhone.value;
              if (number.isNotEmpty) {
                await ContactHelper.openWhatsApp(
                  number,
                  message:
                      'Hi, I want to know more about this property ${ApiConstants.frontendBaseUrl}/properties/${id}',
                );
              }
            },
            icon: Image.asset(
              'assets/images/whatsapp.png',
              width: 18,
              height: 18,
            ),
            label: const Text('Chat with Us'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: ColorRes.primary),
              foregroundColor: ColorRes.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportContactSection(Items property) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Contact Support Team',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickContactBar(property),
        ],
      ),
    );
  }
  

  @override
  void dispose() {
    final propertyId = widget.propertyId ?? '';

    // Clean up controllers
    Get.delete<PropertyController>(tag: 'property_$propertyId');
    Get.delete<GoogleMapSearchController>(tag: 'map_$propertyId');
    Get.delete<OverallRatingController>(tag: 'rating_$propertyId');
    Get.delete<ReviewController>(tag: 'review_$propertyId');

    // --- FIX START: Clean up Matrix Controller with tag ---
    Get.delete<LocationPriceMatrixController>(tag: 'matrix_$propertyId');
    // --- FIX END ---

    // Clean up observables
    canAddReview.close();
    _property.close();
    _isLoading.close();

    super.dispose();
  }

  // Convenience getter
  Items? get property => _property.value;

  final CompareManager compare = Get.find<CompareManager>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Keep default system back behavior to reuse existing previous route.
      },
      child: Scaffold(
        backgroundColor: ColorRes.white,
        extendBody: true,
        body: Obx(() {
        // Show loading while fetching property
        if (_isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get current property value
        final currentProperty = _property.value;

        // Show error if property not found
        if (currentProperty == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ColorRes.leadGreyColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Property not found',
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    color: ColorRes.leadGreyColor,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _goToDashboard,
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        return _buildMediaBanner(
                          currentProperty.propertyMedia ?? PropertyMedia(),
                          currentProperty.id ?? '',
                          currentProperty,
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        return _buildTitleSection(currentProperty);
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSupportContactSection(currentProperty),
                    ),
                    if ((currentProperty
                                .propertyDetails
                                ?.financialInfo
                                ?.is_for_sellorrent ??
                            false) &&
                        (currentProperty.listingType?.toLowerCase() ==
                            'sell')) ...[
                      if (currentProperty
                              .propertyDetails
                              ?.financialInfo
                              ?.propertyRentPerMonth !=
                          null) ...[
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(12),
                        //     decoration: BoxDecoration(
                        //       color: ColorRes.primary.withOpacity(0.05),
                        //       borderRadius: BorderRadius.circular(10),
                        //       border: Border.all(
                        //         color: ColorRes.primary.withOpacity(0.2),
                        //       ),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         const Icon(
                        //           Icons.house,
                        //           color: ColorRes.primary,
                        //         ),
                        //         const SizedBox(width: 8),
                        //         Expanded(
                        //           child: Text(
                        //             'This property is also available for rent at '
                        //             '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month.',
                        //             style: const TextStyle(
                        //               fontSize: AppFontSizes.bodySmall,
                        //               fontWeight: AppFontWeights.medium,
                        //               color: ColorRes.textPrimary,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
            
                        //   ),
                        // ),
                        Divider(
                          indent: 18,
                          endIndent: 18,
                          color: ColorRes.leadGreyColor.shade300,
                        ),
                        
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleWithViewAll(title: 'Also for Rent'),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColorRes.primary.withOpacity(0.3),
                                    width: 0.8,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Available Rent Price',
                                          style: const TextStyle(
                                            fontSize: AppFontSizes.caption,
                                            fontWeight: AppFontWeights.medium,
                                            color: ColorRes.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
                                          style: const TextStyle(
                                            fontSize: AppFontSizes.body,
                                            fontWeight: AppFontWeights.semiBold,
                                            color: ColorRes.textPrimary,
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
                        const SizedBox(height: 12),
                        Divider(
                          indent: 18,
                          endIndent: 18,
                          color: ColorRes.leadGreyColor.shade300,
                        ),
                      ] else ...[
                        SizedBox.shrink(),
                      ],
                    ],
                    if ((currentProperty
                                .propertyDetails
                                ?.financialInfo
                                ?.is_for_sellorrent ??
                            false) &&
                        (currentProperty.listingType?.toLowerCase() ==
                            'rent')) ...[
                      if (currentProperty
                              .propertyDetails
                              ?.financialInfo
                              ?.price !=
                          null) ...[
                        const SizedBox(height: 12),
                        Divider(
                          indent: 18,
                          endIndent: 18,
                          color: ColorRes.leadGreyColor.shade300,
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleWithViewAll(title: 'Also for Sell'),
                            const SizedBox(height: 8),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColorRes.primary.withOpacity(0.3),
                                    width: 0.8,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Available Sell Price',
                                          style: const TextStyle(
                                            fontSize: AppFontSizes.caption,
                                            fontWeight: AppFontWeights.medium,
                                            color: ColorRes.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.price ?? 0)}',
                                          style: const TextStyle(
                                            fontSize: AppFontSizes.body,
                                            fontWeight: AppFontWeights.semiBold,
                                            color: ColorRes.textPrimary,
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

                        const SizedBox(height: 12),
                        Divider(
                          indent: 18,
                          endIndent: 18,
                          color: ColorRes.leadGreyColor.shade300,
                        ),
                      ] else ...[
                        SizedBox.shrink(),
                      ],
                    ],

                    if (currentProperty.propertyDetails?.amenities != null) ...[
                      const SizedBox(height: 12),
                      const TitleWithViewAll(title: 'Amenities'),
                      Builder(
                        builder: (context) {
                          return AmenitiesSection(
                            amenities:
                                currentProperty.propertyDetails!.amenities ??
                                [],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      // Divider(
                      //   indent: 18,
                      //   endIndent: 18,
                      //   color: ColorRes.leadGreyColor.shade300,
                      // ),
                    ],

                    if (currentProperty.propertyDetails != null) ...[
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: ColorRes.leadGreyColor.shade50,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            TitleWithViewAll(
                              title: 'Property Details',
                              icon: Icons.apartment,
                              iconBgColor: ColorRes.white,
                              iconColor: ColorRes.primary,

                              showIcon: true,
                            ),
                            const SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                print('[PropertyDetail] 📋 Building Details');
                                return Details(property: currentProperty);
                              },
                            ),
                            const SizedBox(height: 12),
                            // Divider(
                            //   indent: 18,
                            //   endIndent: 18,
                            //   color: ColorRes.leadGreyColor.shade300,
                            // ),
                          ],
                        ),
                      ),
                    ],

                    if ((currentProperty
                                .propertyDetails
                                ?.financialInfo
                                ?.is_for_sellorrent ??
                            false) &&
                        (currentProperty.listingType?.toLowerCase() ==
                            'sell')) ...[
                      if (currentProperty
                              .propertyDetails
                              ?.financialInfo
                              ?.propertyRentPerMonth !=
                          null) ...[
                        const SizedBox(height: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleWithViewAll(title: 'Also for rent'),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ColorRes.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColorRes.leadGreyColor.shade300,
                                    width: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text:
                                              'This property is also available for rent at ',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.caption,
                                            fontWeight: AppFontWeights.medium,
                                            color: ColorRes.leadGreyColor[700],
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
                                              style: const TextStyle(
                                                fontSize:
                                                    AppFontSizes.bodySmall,
                                                fontWeight:
                                                    AppFontWeights.semiBold,
                                                color: ColorRes.textPrimary,
                                              ),
                                            ),
                                            const TextSpan(text: '.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          indent: 18,
                          endIndent: 18,
                          color: ColorRes.leadGreyColor.shade300,
                        ),
                      ] else ...[
                        SizedBox.shrink(),
                      ],
                    ],
                    if ((currentProperty
                                .propertyDetails
                                ?.financialInfo
                                ?.is_for_sellorrent ??
                            false) &&
                        (currentProperty.listingType?.toLowerCase() ==
                            'rent')) ...[
                      if (currentProperty
                              .propertyDetails
                              ?.financialInfo
                              ?.price !=
                          null) ...[
                        // const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const TitleWithViewAll(title: 'Also for Sell'),
                            // const SizedBox(height: 8),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 12,
                            //   ),

                            //   child: Container(
                            //     padding: const EdgeInsets.all(12),
                            //     decoration: BoxDecoration(
                            //       color: ColorRes.white,
                            //       borderRadius: BorderRadius.circular(12),
                            //       border: Border.all(
                            //         color: ColorRes.leadGreyColor.shade300,
                            //         width: 0.8,
                            //       ),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.1),
                            //           blurRadius: 6,
                            //           offset: const Offset(0, 2),
                            //         ),
                            //       ],
                            //     ),
                            //     child: Row(
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         Expanded(
                            //           child: Text.rich(
                            //             TextSpan(
                            //               text:
                            //                   'This property is also available for sell at ',
                            //               style: TextStyle(
                            //                 fontSize: AppFontSizes.caption,
                            //                 fontWeight: AppFontWeights.medium,
                            //                 color: ColorRes.leadGreyColor[700],
                            //               ),
                            //               children: [
                            //                 TextSpan(
                            //                   text:
                            //                       '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.price ?? 0)}',
                            //                   style: const TextStyle(
                            //                     fontSize:
                            //                         AppFontSizes.bodySmall,
                            //                     fontWeight:
                            //                         AppFontWeights.semiBold,
                            //                     color: ColorRes.textPrimary,
                            //                   ),
                            //                 ),
                            //                 const TextSpan(text: '.'),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),

                        // const SizedBox(height: 12),
                        // Divider(
                        //   indent: 18,
                        //   endIndent: 18,
                        //   color: ColorRes.leadGreyColor.shade300,
                        // ),
                      ] else ...[
                        SizedBox.shrink(),
                      ],
                    ],

                    // if ((currentProperty
                    //             .propertyDetails
                    //             ?.financialInfo
                    //             ?.is_for_sellorrent ??
                    //         false) &&
                    //     (currentProperty.listingType?.toLowerCase() ==
                    //         'sell')) ...[
                    //   if (currentProperty
                    //           .propertyDetails
                    //           ?.financialInfo
                    //           ?.propertyRentPerMonth !=
                    //       null) ...[
                    //     const SizedBox(height: 12),
                    //     // Padding(
                    //     //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //     //   child: Container(
                    //     //     padding: const EdgeInsets.all(12),
                    //     //     decoration: BoxDecoration(
                    //     //       color: ColorRes.primary.withOpacity(0.05),
                    //     //       borderRadius: BorderRadius.circular(10),
                    //     //       border: Border.all(
                    //     //         color: ColorRes.primary.withOpacity(0.2),
                    //     //       ),
                    //     //     ),
                    //     //     child: Row(
                    //     //       children: [
                    //     //         const Icon(
                    //     //           Icons.house,
                    //     //           color: ColorRes.primary,
                    //     //         ),
                    //     //         const SizedBox(width: 8),
                    //     //         Expanded(
                    //     //           child: Text(
                    //     //             'This property is also available for rent at '
                    //     //             '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month.',
                    //     //             style: const TextStyle(
                    //     //               fontSize: AppFontSizes.bodySmall,
                    //     //               fontWeight: AppFontWeights.medium,
                    //     //               color: ColorRes.textPrimary,
                    //     //             ),
                    //     //           ),
                    //     //         ),
                    //     //       ],
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const TitleWithViewAll(title: 'Also for rent'),
                    //         const SizedBox(height: 8),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 16,
                    //           ),
                    //           child: Container(
                    //             padding: const EdgeInsets.all(12),
                    //             decoration: BoxDecoration(
                    //               color: ColorRes.white,
                    //               borderRadius: BorderRadius.circular(12),
                    //               border: Border.all(
                    //                 color: ColorRes.leadGreyColor.shade300,
                    //                 width: 0.8,
                    //               ),
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Colors.grey.withOpacity(0.1),
                    //                   blurRadius: 6,
                    //                   offset: const Offset(0, 2),
                    //                 ),
                    //               ],
                    //             ),
                    //             child: Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Expanded(
                    //                   child: Text.rich(
                    //                     TextSpan(
                    //                       text:
                    //                           'This property is also available for rent at ',
                    //                       style: TextStyle(
                    //                         fontSize: AppFontSizes.caption,
                    //                         fontWeight: AppFontWeights.medium,
                    //                         color: ColorRes.leadGreyColor[700],
                    //                       ),
                    //                       children: [
                    //                         TextSpan(
                    //                           text:
                    //                               '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.propertyRentPerMonth ?? 0)}/month',
                    //                           style: const TextStyle(
                    //                             fontSize:
                    //                                 AppFontSizes.bodySmall,
                    //                             fontWeight:
                    //                                 AppFontWeights.semiBold,
                    //                             color: ColorRes.textPrimary,
                    //                           ),
                    //                         ),
                    //                         const TextSpan(text: '.'),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     const SizedBox(height: 12),
                    //     Divider(
                    //       indent: 18,
                    //       endIndent: 18,
                    //       color: ColorRes.leadGreyColor.shade300,
                    //     ),
                    //   ] else ...[
                    //     SizedBox.shrink(),
                    //   ],
                    // ],
                    // if ((currentProperty
                    //             .propertyDetails
                    //             ?.financialInfo
                    //             ?.is_for_sellorrent ??
                    //         false) &&
                    //     (currentProperty.listingType?.toLowerCase() ==
                    //         'rent')) ...[
                    //   if (currentProperty
                    //           .propertyDetails
                    //           ?.financialInfo
                    //           ?.price !=
                    //       null) ...[
                    //     const SizedBox(height: 12),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const TitleWithViewAll(title: 'Also for Sell'),
                    //         const SizedBox(height: 8),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 16,
                    //           ),
                    //           child: Container(
                    //             padding: const EdgeInsets.all(12),
                    //             decoration: BoxDecoration(
                    //               color: ColorRes.white,
                    //               borderRadius: BorderRadius.circular(12),
                    //               border: Border.all(
                    //                 color: ColorRes.leadGreyColor.shade300,
                    //                 width: 0.8,
                    //               ),
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Colors.grey.withOpacity(0.1),
                    //                   blurRadius: 6,
                    //                   offset: const Offset(0, 2),
                    //                 ),
                    //               ],
                    //             ),
                    //             child: Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Expanded(
                    //                   child: Text.rich(
                    //                     TextSpan(
                    //                       text:
                    //                           'This property is also available for sell at ',
                    //                       style: TextStyle(
                    //                         fontSize: AppFontSizes.caption,
                    //                         fontWeight: AppFontWeights.medium,
                    //                         color: ColorRes.leadGreyColor[700],
                    //                       ),
                    //                       children: [
                    //                         TextSpan(
                    //                           text:
                    //                               '${Formatter.formatPrice(currentProperty.propertyDetails?.financialInfo?.price ?? 0)}',
                    //                           style: const TextStyle(
                    //                             fontSize:
                    //                                 AppFontSizes.bodySmall,
                    //                             fontWeight:
                    //                                 AppFontWeights.semiBold,
                    //                             color: ColorRes.textPrimary,
                    //                           ),
                    //                         ),
                    //                         const TextSpan(text: '.'),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //
                    //     const SizedBox(height: 12),
                    //     Divider(
                    //       indent: 18,
                    //       endIndent: 18,
                    //       color: ColorRes.leadGreyColor.shade300,
                    //     ),
                    //   ] else ...[
                    //     SizedBox.shrink(),
                    //   ],
                    // ],
                    if (currentProperty
                            .propertyDetails
                            ?.furnishInfo
                            ?.furnishDetails !=
                        null) ...[
                      const SizedBox(height: 12),
                      const TitleWithViewAll(title: 'Furnishing'),
                      Builder(
                        builder: (context) {
                          return FurnishingDetails(
                            property: currentProperty,
                            bgColor: ColorRes.propertyBg,
                            txtColor: ColorRes.primary,
                          );
                        },
                      ),
                      // Divider(
                      //   indent: 18,
                      //   endIndent: 18,
                      //   color: ColorRes.leadGreyColor.shade300,
                      // ),
                    ],
                    if (currentProperty.listingType?.toUpperCase() == "PG" &&
                        currentProperty.propertyDetails?.pgInfo?.pgRules !=
                            null) ...[
                      const SizedBox(height: 12),
                      const TitleWithViewAll(title: 'PG Rules'),
                      const SizedBox(height: 8),
                      _buildPgRulesSection(
                        currentProperty.propertyDetails!.pgInfo!.pgRules!,
                      ),
                      const SizedBox(height: 20),
                      // Divider(
                      //   indent: 18,
                      //   endIndent: 18,
                      //   color: ColorRes.leadGreyColor.shade300,
                      // ),
                    ],

                    if (currentProperty.listingType?.toUpperCase() == "PG" &&
                        currentProperty.propertyDetails?.pgInfo?.pgRoomInfo !=
                            null &&
                        currentProperty
                            .propertyDetails!
                            .pgInfo!
                            .pgRoomInfo!
                            .isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: ColorRes.leadGreyColor.shade50,

                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            const TitleWithViewAll(
                              title: 'Room Options & Pricing',
                              showIcon: true,
                              icon: Icons.room_outlined,
                              iconBgColor: ColorRes.white,
                              iconColor: ColorRes.primary,
                            ),
                            const SizedBox(height: 15),
                            _buildRoomOptionsSection(
                              currentProperty
                                  .propertyDetails!
                                  .pgInfo!
                                  .pgRoomInfo!,
                            ),
                            const SizedBox(height: 15),
                            // Divider(
                            //   indent: 18,
                            //   endIndent: 18,
                            //   color: ColorRes.leadGreyColor.shade300,
                            // ),
                          ],
                        ),
                      ),
                    ],

                    if (currentProperty.propertyDescription != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: ColorRes.homeYellowDark.withOpacity(0.06),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            const TitleWithViewAll(
                              title: 'Description',
                              icon: Icons.description_outlined,
                              iconBgColor: ColorRes.white,
                              iconColor: ColorRes.orangeColor,
                              showIcon: true,
                            ),
                            const SizedBox(height: 8),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            //   child: Text(
                            //     currentProperty.propertyDescription ?? '-',
                            //     style: const TextStyle(
                            //       fontSize: 11,
                            //       fontWeight: FontWeight.w400,
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: ReadMoreClass(
                                description:
                                    currentProperty.propertyDescription ?? '',
                                trimLines: 5,
                                size: 12,

                                colorClickableText: ColorRes.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Divider(
                            //   indent: 18,
                            //   endIndent: 18,
                            //   color: ColorRes.leadGreyColor.shade300,
                            // ),
                          ],
                        ),
                      ),
                    ],

                    if (currentProperty
                                .propertyDetails
                                ?.financialInfo
                                ?.propertyPriceTrend !=
                            null &&
                        currentProperty.investmentInsightModel != null &&
                        currentProperty.listingType!.toLowerCase() ==
                            "sell") ...[
                      if (currentProperty
                              .propertyDetails
                              ?.financialInfo
                              ?.propertyPriceTrend
                              .isNotEmpty ??
                          false) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          color: ColorRes.primary.withOpacity(0.05),

                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              TitleWithViewAll(
                                title: 'Investment Insight',
                                icon: Icons.auto_graph,
                                iconBgColor: ColorRes.white,
                                iconColor: ColorRes.primary,
                                showIcon: true,
                              ),
                              const SizedBox(height: 8),
                              Builder(
                                builder: (context) {
                                  // ✅ Check if controller exists before building chart
                                  if (Get.isRegistered<
                                    LocationPriceMatrixController
                                  >(tag: 'matrix_${currentProperty.id}')) {
                                    return InvestmentInsightChart(
                                      currentProperty: currentProperty,
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ],

                    if (currentProperty.location?.isNotEmpty ?? false) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: ColorRes.leadGreyColor.shade100,

                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            TitleWithViewAll(
                              title: 'Location',
                              icon: Icons.location_on_outlined,
                              iconBgColor: ColorRes.white,
                              iconColor: ColorRes.success,
                              showIcon: true,
                            ),
                            const SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                return AddressAndMapDetails(
                                  address: currentProperty.address ?? '',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],

                    Builder(
                      builder: (context) {
                        return Obx(() {
                          if (mapController.isLoading.value) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final hasData = mapController.allCategoriesData.values
                              .any((places) => places.isNotEmpty);

                          if (!hasData ||
                              mapController.propertyLatLng.value == null) {
                            print('No data found');
                            return const SizedBox.shrink();
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: ColorRes.leadGreyColor.shade50.withOpacity(
                              0.5,
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                TitleWithViewAll(
                                  title: 'Nearby Locations',
                                  icon: Icons.near_me_outlined,
                                  iconBgColor: ColorRes.white,
                                  iconColor: ColorRes.deepPurpleColor,
                                  showIcon: true,
                                ),
                                const SizedBox(height: 20),
                                NearbyLocationMapSection(
                                  address: currentProperty.address ?? '',
                                  mapController: mapController,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          );
                        });
                      },
                    ),

                    // if (currentProperty.ownerName?.isNotEmpty ?? false) ...[
                    //   // Divider(
                    //   //   indent: 18,
                    //   //   endIndent: 18,
                    //   //   color: ColorRes.leadGreyColor.shade300,
                    //   // ),
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(vertical: 12),
                    //     color: ColorRes.homeYellowDark.withOpacity(0.08),
                    //     child: Column(
                    //       children: [
                    //         const SizedBox(height: 12),

                    //         Row(
                    //           children: [
                    //             Expanded(
                    //               child: TitleWithViewAll(
                    //                 title: 'Owner Details',
                    //                 icon: Icons.person_outlined,
                    //                 iconBgColor: ColorRes.white,
                    //                 iconColor: ColorRes.deepPurpleColor,
                    //                 showIcon: true,
                    //               ),
                    //             ),
                    //             SizedBox(width: 12),
                    //             GestureDetector(
                    //               onTap: () async {
                    //                 if (!canAddReview.value) return;
                    //                 final result = await Get.to(
                    //                   () => AddReviewScreen(
                    //                     entityType: "property",
                    //                     entityId: currentProperty.id ?? '',
                    //                   ),
                    //                 );
                    //                 if (result == true) {
                    //                   canAddReview.value = false;
                    //                   reviewController.refreshList();
                    //                   _overallRatingController
                    //                       .fetchOverallRating(
                    //                         currentProperty.id ?? '',
                    //                       );
                    //                 }
                    //               },
                    //               child: Obx(() {
                    //                 final enabled = canAddReview.value;
                    //                 final label =
                    //                     enabled ? "Add Review" : "Reviewed";
                    //                 final color =
                    //                     enabled
                    //                         ? ColorRes.deepPurpleColor
                    //                         : ColorRes.green;
                    //                 return Container(
                    //                   padding: const EdgeInsets.symmetric(
                    //                     horizontal: 12,
                    //                     vertical: 8,
                    //                   ),
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     border: Border.all(color: color),
                    //                   ),
                    //                   child: Row(
                    //                     children: [
                    //                       Text(
                    //                         label,
                    //                         style: TextStyle(
                    //                           color: color,
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize: 11,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 );
                    //               }),
                    //             ),
                    //             SizedBox(width: 12),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 8),
                    //         Builder(
                    //           builder: (context) {
                    //             log(
                    //               '[PropertyDetail] 👤 Building OwnerInformation - START',
                    //             );
                    //             final widget = OwnerInformation(
                    //               property: currentProperty,
                    //               controller: controller,
                    //             );
                    //             log(
                    //               '[PropertyDetail] 👤 Building OwnerInformation - END',
                    //             );
                    //             return widget;
                    //           },
                    //         ),
                    //         const SizedBox(height: 12),
                    //       ],
                    //     ),
                    //   ),
                    // ],
                    Builder(
                      builder: (context) {
                        final widget = ReviewSection(
                          canAddReview: canAddReview,
                          overallController: _overallRatingController,
                          reviewController: reviewController,
                          entityType: "property",
                          entityId: currentProperty.id ?? '',
                          reviewCardBuilder:
                              (context, item) =>
                                  PropertyReviewCard(reviewItem: item,showFullDetails: false,),
                          overallWidgetBuilder: (total, rating, details) {
                            return OverallRatingWidget(
                              totalReviews: total,
                              overallRating: rating,
                              detailedRatings: details,
                            );
                          },
                        );

                        return widget;
                      },
                    ),
                    if (property?.propertyStatus?.toLowerCase() != "sold") ...[
                      // Divider(
                      //   indent: 18,
                      //   endIndent: 18,
                      //   color: ColorRes.leadGreyColor.shade300,
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: ColorRes.leadGreyColor.shade200,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            const SizedBox(height: 15),
                        
                            Text(
                              ' Limited Time Offer!',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                            Text(
                              "Limited-time! Get an exclusive offer on this property.",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.medium,
                                color: ColorRes.textColor.withOpacity(0.65),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 15),
                            Obx(() {
                              if (controller.hasSubmittedInquiry.value) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: OfferCountdown(
                                  propertyId: currentProperty.id ?? '',
                                ),
                              );
                            }),
                            Obx(
                              () => controller.hasSubmittedInquiry.value
                                  ? const SizedBox.shrink()
                                  : const SizedBox(height: 8),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Offer Text
                                  const SizedBox(height: 12),

                                  // Conditional Area
                                  Obx(() {
                                    if (controller.hasSubmittedInquiry.value) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            NesticoPeSnackBar.showAwesomeSnackbar(
                                              title: 'Already Inquired',
                                              message:
                                                  'You have already submitted inquiry',
                                              contentType: ContentType.warning,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorRes.error,
                                            foregroundColor: ColorRes.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                            ),
                                          ),
                                          child: const Text(
                                            'Already Inquired',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.medium,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return NesticoPeButton(
                                        title: 'Get Offer',
                                        backgroundColor: ColorRes.error,
                                        height: 48,
                                        width: double.infinity,
                                        borderRadius: BorderRadius.circular(10),
                                        titleTextStyle: TextStyle(
                                          color: ColorRes.white,
                                          fontSize: AppFontSizes.medium,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                        onTap: () async {
                                          try {
                                            if (UserHelper.isGuest) {
                                              Get.to(() => OtpLoginScreen());
                                              return;
                                            }
                                            final user =
                                                await SecureStorage.getUserData();
                                            if (user == null) {
                                              NesticoPeSnackBar.showAwesomeSnackbar(
                                                title: "Error",
                                                message:
                                                    'No user data found. Please log in.',
                                                contentType:
                                                    ContentType.failure,
                                              );
                                              return;
                                            }
                                            final fullName =
                                                user.user?.fullName ?? '';
                                            final firstName =
                                                user.user?.firstName ?? '';
                                            final username =
                                                user.user?.username ?? '';
                                            final email =
                                                user.user?.email ?? '';
                                            final phone =
                                                user.user?.phone ?? '';
                                            final displayName =
                                                (firstName.isEmpty
                                                        ? username
                                                        : fullName)
                                                    .trim();
                                            final listing =
                                                currentProperty.listingType
                                                    ?.toLowerCase()
                                                    .replaceAll(" ", "_") ??
                                                '';
                                            final inquiry = {
                                              "name": displayName,
                                              "phone": phone,
                                              "email": email,
                                              "agreeToContact": true,
                                              "meta": {
                                                "inquiryType": listing,
                                                "type": "property",
                                              },
                                            };
                                            final success = await controller
                                                .addInquiry(
                                                  inquiry,
                                                  currentProperty.id ?? '',
                                                );
                                            if (success) {
                                              controller
                                                  .hasSubmittedInquiry
                                                  .value = true;
                                              NesticoPeSnackBar.showAwesomeSnackbar(
                                                title: 'Success',
                                                message:
                                                    'Inquiry Added Successfully',
                                                contentType:
                                                    ContentType.success,
                                              );
                                              await controller
                                                  .getAllInQuireData(
                                                    widget.propertyId ?? '',
                                                  );
                                              await controller
                                                  .getHasInQuireData(
                                                    widget.propertyId ?? '',
                                                  );
                                              await _refreshUserActivityData();
                                            } else {
                                              NesticoPeSnackBar.showAwesomeSnackbar(
                                                title: 'Error',
                                                message:
                                                    'Failed to Submit Inquiry',
                                                contentType:
                                                    ContentType.failure,
                                              );
                                            }
                                          } catch (e, s) {
                                            debugPrint(
                                              '❌ Error in Get Offer button: $e',
                                            );
                                            debugPrint('$s');
                                            NesticoPeSnackBar.showAwesomeSnackbar(
                                              title: "Error",
                                              message:
                                                  'Something went wrong. Please try again.',
                                              contentType: ContentType.failure,
                                            );
                                          }
                                        },
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],

                    if (!UserHelper.isGuest) ...[
                      if (controller.items.isNotEmpty) ...[
                        // Divider(
                        //   indent: 18,
                        //   endIndent: 18,
                        //   color: ColorRes.leadGreyColor.shade300,
                        // ),
                        Builder(
                          builder: (context) {
                            const widget = RecommendedProperty();

                            return widget;
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  return UnifiedComparisonFloatingButton(bottom: 16);
                },
              ),
            ],
          ),
        );
      }),

      bottomNavigationBar: Obx(() {
        if (_isLoading.value) {
          return const SizedBox.shrink();
        }

        final currentProperty = _property.value;
        if (currentProperty == null) {
          return const SizedBox.shrink();
        }

        final priceManager = PropertyPriceManager(
          financialInfo:
              currentProperty.propertyDetails?.financialInfo ?? FinancialInfo(),
          listingType: currentProperty.listingType ?? '',
          pgInfo: currentProperty.propertyDetails?.pgInfo,
        );

        return SafeArea(
          child: ReusableBottomBar(
            mainPriceText:
                priceManager.isPG
                    ? priceManager.maxPgPriceDisplay
                    : priceManager.totalPriceDisplay,
            priceBreakdown: priceManager.propertyPriceSummary,
            onPrimaryAction: () {
              if (UserHelper.isGuest) {
                Get.to(() => OtpLoginScreen());
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    final hasSubmitted = controller.hasSubmittedInquiry.value;
                    final propertySold =
                        (currentProperty.propertyStatus ?? '').toLowerCase() ==
                        "sold";

                    // Decide which section is showing
                    final bool isCompactView = hasSubmitted || propertySold;

                    return DraggableScrollableSheet(
                      expand: false,
                      minChildSize: 0.45,
                      initialChildSize: isCompactView ? 0.45 : 0.85,
                      maxChildSize: isCompactView ? 0.45 : 0.85,
                      builder:
                          (context, scrollController) => SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 16,
                                right: 16,
                                top: 16,
                              ),
                              child: ContactOwnerBottom(
                                isProject: 'property',
                                propertyStatus:
                                    currentProperty.propertyStatus ?? '',
                                pgRoomData:
                                    currentProperty
                                        .propertyDetails
                                        ?.pgInfo
                                        ?.pgRoomInfo ??
                                    [],

                                price: priceManager.actualPrice,
                                listingType:
                                    currentProperty.listingType
                                        ?.toLowerCase() ??
                                    '',
                                forRentPrice:
                                    currentProperty
                                        .propertyDetails
                                        ?.financialInfo
                                        ?.propertyRentPerMonth ??
                                    0,
                                forSellPrice:
                                    currentProperty
                                        .propertyDetails
                                        ?.financialInfo
                                        ?.price ??
                                    0,
                                isForSell:
                                    currentProperty
                                        .propertyDetails
                                        ?.financialInfo
                                        ?.is_for_sellorrent ??
                                    false,

                                inQuireSubmitted:
                                    controller.hasSubmittedInquiry.value,
                                titleText: "Contact the Owner",
                                chatButtonText: "Chat via WhatsApp",
                                formTitle: "Quick Contact Form",
                                contactButtonText: "Send Request",
                                nameIcon: Icons.person,
                                phoneIcon: Icons.phone,
                                emailIcon: Icons.email,
                                allowSellerContact: false,
                                negotiable: false,

                                bookSiteVisit: false,
                                onChatPressed: () {
                                  print("WhatsApp button clicked!");
                                },
                                onContactPressed: (
                                  name,
                                  phone,
                                  email,
                                  price,
                                  isNegotiable,

                                  isAllowAllCondition,
                                  inquiryListing,
                                  isBookSiteVisit,
                                  planningToBuy,
                                  date,
                                  time,
                                  roomInfo,
                                  selectedVariant,
                                ) async {
                                  final inquiry = {
                                    "name": name ?? "",
                                    "phone": phone ?? "",
                                    "email": email ?? "",
                                    "agreeToContact":
                                        isAllowAllCondition ?? false,
                                    "meta": {
                                      if (price != null)
                                        "negotiablePrice": price,
                                      if (inquiryListing != null &&
                                          (inquiryListing?.isNotEmpty ?? false))
                                        "inquiryType":
                                            inquiryListing.toLowerCase(),
                                      if (isNegotiable != null)
                                        "isNegotiable": isNegotiable,
                                      if (planningToBuy != null)
                                        "timePeriod": planningToBuy,
                                      if (date != null)
                                        "visitDate":
                                            '${date.day}-${date.month}-${date.year}',
                                      if (roomInfo != null)
                                        "selectedRoomType": roomInfo,
                                      if (time != null)
                                        "visitTime":
                                            '${time.hour.toString().padLeft(2, '0')}:'
                                            '${time.minute.toString().padLeft(2, '0')}',
                                    },
                                  };

                                  print('Submitting inquiry: ${inquiry}');

                                  final success = await controller.addInquiry(
                                    inquiry,
                                    currentProperty.id ?? '',
                                  );

                                  if (success) {
                                    controller.hasSubmittedInquiry.value = true;

                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: "Success",
                                      message: "Inquiry Added Successfully",
                                      contentType: ContentType.success,
                                    );
                                    await controller.getAllInQuireData(
                                      widget.propertyId ?? '',
                                    );
                                    await controller.getHasInQuireData(
                                      widget.propertyId ?? '',
                                    );
                                    await _refreshUserActivityData();
                                    Get.back();
                                  } else {
                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                      title: "Error",
                                      message: "Failed to Submit Inquiry",
                                      contentType: ContentType.failure,
                                    );
                                  }
                                },
                                onAllowSellerContactChanged: (value) {},
                                onHomeLoanInterestChanged: (value) {},
                              ),
                            ),
                          ),
                    );
                  },
                );
              }
            },
            primaryTitle:
                (currentProperty.propertyStatus?.toLowerCase() == "sold")
                    ? "Property Sold"
                    : (controller.hasSubmittedInquiry.value)
                    ? "Submitted"
                    : "View Contact",
          ),
        );
        }),
      ),
    );
  }

  void _goToDashboard() {
    if (Navigator.of(context).canPop()) {
      Get.back();
      return;
    }
    Get.offAllNamed('/dashboard', predicate: (route) => false);
  }

  void addInquiryFromApp(
    String name,
    String email,
    String phone,
    String propertyID,
    String propertyType,
    String type,
  ) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);

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
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Get Offer Price",
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
                ),

                // Body
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NesticoPeTextField(
                          controller: nameController,
                          title: "Name",
                          hintText: 'Enter your name',
                          prefixIcon: Icons.person_outline,
                          isRequired: true,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Name is required'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        NesticoPeTextField(
                          controller: emailController,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          title: "Email",
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!GetUtils.isEmail(value.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        NesticoPeTextField(
                          controller: phoneController,
                          hintText: 'Enter your phone number',
                          title: "Phone",
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isRequired: true,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone is required';
                            }
                            if (!GetUtils.isPhoneNumber(value.trim())) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border(
                      top: BorderSide(
                        color: ColorRes.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: ColorRes.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // perform your submission logic here
                              final inquiry = {
                                "name": nameController.text ?? "",
                                "phone": phoneController.text ?? "",
                                "email": emailController.text ?? "",
                                "agreeToContact": true,
                                "meta": {
                                  "inquiryType": "$propertyType",
                                  "type": "$type",
                                },
                              };

                              final success = await controller.addInquiry(
                                inquiry,
                                propertyID ?? '',
                              );

                              if (success) {
                                if (UserHelper.isGuest) {
                                  controller.hasSubmittedInquiry.value = true;
                                  var inquiryData = {
                                    'property': propertyID,
                                    "email": emailController.text ?? "",
                                    "success": success,
                                  };
                                  final exists =
                                      await SecureStorage.hasPropertyInquiry(
                                        propertyID,
                                      );

                                  if (!exists) {
                                    await SecureStorage.addPropertyInquiry(
                                      inquiryData,
                                    );
                                  }
                                }
                                controller.hasSubmittedInquiry.value = true;
                                /*   CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Inquiry Added Successfully",
                                  type: SnackBarType.success,
                                );*/
                                Get.back();
                                await controller.getAllInQuireData(
                                  widget.propertyId ?? '',
                                );
                                await controller.getHasInQuireData(
                                  widget.propertyId ?? '',
                                );
                              } else {
                                Get.back();
                                /* CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Failed to Submit Inquiry",
                                  type: SnackBarType.error,
                                );*/
                              }
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
                              Icon(Icons.send, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Request Offer Price',

                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

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

  // Also remove this getter since we're using _property.value directly
  // Items? get property => _property.value;

  Widget _buildMediaBanner(
    PropertyMedia media,
    String id,
    Items currentProperty,
  ) {
    final PageController pageController = PageController();
    String _sanitize(String s) => s.replaceAll('`', '').trim();

    List<String> images =
        (media.images ?? []).map(_sanitize).where((e) => e.isNotEmpty).toList();
    if (images.isEmpty &&
        (currentProperty.propertyImages?.isNotEmpty ?? false)) {
      images =
          currentProperty.propertyImages!
              .map(_sanitize)
              .where((e) => e.isNotEmpty)
              .toList();
    }
    final List<String> videos =
        (media.videos ?? []).map(_sanitize).where((e) => e.isNotEmpty).toList();

    final List<Map<String, String>> mediaList = [
      ...images.map((e) => {"type": "image", "url": e}),
      ...videos.map((e) => {"type": "video", "url": e}),
    ];

    int currentPage = 0;

    return SafeArea(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              /// Media (Image / Video)
              /*     SizedBox(
                height: 300,
                width: double.infinity,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: mediaList.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = mediaList[index];
                    if (item["type"] == "image") {
                      return Image.network(
                        item["url"]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    } else if (item["type"] == "video") {
                      return CustomVideoPlayer(url: item["url"]!);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),*/
              SizedBox(
                height: 300,
                width: double.infinity,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: mediaList.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = mediaList[index];
                    final url = _sanitize(item["url"] ?? '');
                    const imageOfNotAvailable =
                        "assets/images/not_available_image.png";

                    if (item["type"] == "image") {
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder:
                            (context, _) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, _, __) => Image.asset(
                              imageOfNotAvailable,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                      );
                    } else if (item["type"] == "video") {
                      return CustomVideoPlayer(url: url);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              /// Back button
              Positioned(
                top: 16,
                left: 16,
                child: CircularIcon(
                  icon: Icons.arrow_back_rounded,
                  backgroundColor: ColorRes.white,
                  onPressed: _goToDashboard,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: EntityActionButtons(
                  id: property?.id ?? '',
                  entity: property,
                  compareController: compare,
                  favoriteController: favoriteController,
                ),
              ),

              /// Page indicator
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.blackShade54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${currentPage + 1}/${mediaList.length}',
                    style: const TextStyle(
                      color: ColorRes.white,
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ),
              ),

              if ((currentProperty.reraId?.isNotEmpty ?? false) &&
                  currentProperty.reraId != null) ...[
                Obx(() {
                  return Positioned(
                    left: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            ReraComponent(
                              text: "rera",
                              backgroundColor: ColorRes.black.withOpacity(0.7),
                              textColor: ColorRes.background,
                              fontSize: AppFontSizes.small,

                              borderRadius: AppRadius.small,
                              fontWeight: AppFontWeights.bold,
                              showIcon: true,
                              iconColor: ColorRes.success,
                              iconSize: 14,
                            ),
                            const SizedBox(width: 8),
                            if (property
                                    ?.scoreBreakdown
                                    ?.components
                                    .premium
                                    .isPremium ??
                                false)
                              ReraComponent(
                                text: "NesticoPe Assured",
                                backgroundColor: ColorRes.black.withOpacity(
                                  0.7,
                                ),
                                textColor: ColorRes.background,

                                iconColor: ColorRes.primary,
                                fontSize: AppFontSizes.small,
                                borderRadius: AppRadius.small,
                                fontWeight: AppFontWeights.bold,
                                showIcon: true,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitleSection(Items property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title
          Row(
            children: [
              Expanded(
                child: Text(
                  PropertyNameManager(property).displayName,
                  style: const TextStyle(
                    fontWeight: AppFontWeights.semiBold,

                    fontSize: AppFontSizes.body,
                    color: ColorRes.blackShade87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12),
              if (property.propertyStatus?.toLowerCase() != "sold") ...[
                if (property.listingType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      property.listingType!.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.primary,
                      ),
                    ),
                  ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    property.propertyStatus!.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.error,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 4),

          // 📍 Location Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${property.city ?? '-'}, ${property.state ?? "-"}',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.leadGreyColor[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // 🔹 Type + See on Map
          GestureDetector(
            onTap: () {
              if (property.location != null) {
                ContactHelper.openInGoogleMaps(property.address!);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin, size: 16, color: ColorRes.primary),
                  SizedBox(width: 4),
                  Text(
                    "See on Map",
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (property?.reraId != null &&
              property!.reraId!.isNotEmpty &&
              property!.reraId != "null") ...[
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width - 32,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_moon_outlined,
                    size: 20,
                    color:
                        // ? ColorRes.primary
                        ColorRes.success,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "RERA ID",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${property?.reraId ?? 'N/A'}",

                          style: TextStyle(
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: 14,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Inline video player builder
  Widget _buildVideoPlayer(String url) {
    final VideoPlayerController videoController = VideoPlayerController.network(
      url,
    );

    return FutureBuilder(
      future: videoController.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          videoController.setLooping(true);
          videoController.play();
          return AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// PG Rules Section Builder
  Widget _buildPgRulesSection(PgRules rules) {
    final rulesList = <Map<String, dynamic>>[];

    if (rules.nonVegAllowed != null) {
      rulesList.add({
        'label': 'Non-Veg',
        'allowed': rules.nonVegAllowed!,
        'icon': Icons.restaurant,
      });
    }
    if (rules.petsAllowed != null) {
      rulesList.add({
        'label': 'Pets',
        'allowed': rules.petsAllowed!,
        'icon': Icons.pets,
      });
    }
    if (rules.lateEntryAllowed != null) {
      rulesList.add({
        'label': 'Late Entry',
        'allowed': rules.lateEntryAllowed!,
        'icon': Icons.access_time,
      });
    }
    if (rules.smokingAllowed != null) {
      rulesList.add({
        'label': 'Smoking',
        'allowed': rules.smokingAllowed!,
        'icon': Icons.smoke_free,
      });
    }
    if (rules.drinkingAllowed != null) {
      rulesList.add({
        'label': 'Drinking',
        'allowed': rules.drinkingAllowed!,
        'icon': Icons.no_drinks,
      });
    }
    if (rules.visitorAllowed != null) {
      rulesList.add({
        'label': 'Visitor',
        'allowed': rules.visitorAllowed!,
        'icon': Icons.people,
      });
    }

    if (rulesList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'No rules specified',
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            color: ColorRes.leadGreyColor,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            rulesList.map((rule) {
              final isAllowed = rule['allowed'] as bool;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isAllowed
                          ? ColorRes.green.withOpacity(0.02)
                          : ColorRes.error.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isAllowed
                            ? ColorRes.green.withOpacity(0.8)
                            : ColorRes.error.withOpacity(0.8),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      rule['icon'] as IconData,
                      size: 16,
                      color:
                          isAllowed
                              ? ColorRes.green.withOpacity(0.8)
                              : ColorRes.error.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rule['label'] as String,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.medium,
                        color:
                            isAllowed
                                ? ColorRes.green.withOpacity(0.8)
                                : ColorRes.error.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isAllowed ? Icons.check_circle : Icons.cancel,
                      size: 14,
                      color:
                          isAllowed
                              ? ColorRes.green.withOpacity(0.8)
                              : ColorRes.error.withOpacity(0.8),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Room Options & Pricing Section Builder
  Widget _buildRoomOptionsSection(List<PgRoomInfo> rooms) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children:
            rooms.map((room) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: ColorRes.leadGreyColor.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: ColorRes.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room.roomType?.toUpperCase() ?? 'Room',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${Formatter.formatPrice(room.rent ?? 0)} / month',
                            style: const TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (room.securityDeposit != null &&
                        room.securityDeposit! > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.security,
                            size: 14,
                            color: ColorRes.leadGreyColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Security Deposit: ${Formatter.formatPrice(room.securityDeposit ?? 0)}',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: ColorRes.leadGreyColor.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Room Facilities
                    if (room.roomFacilityInfo != null) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Facilities:',
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.blackShade87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _buildFacilityChips(room.roomFacilityInfo!),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Build facility chips for room
  List<Widget> _buildFacilityChips(RoomFacilityInfo facilities) {
    final chips = <Widget>[];

    if (facilities.wifi == true) {
      chips.add(_buildFacilityChip('WiFi', Icons.wifi));
    }
    if (facilities.ac == true) {
      chips.add(_buildFacilityChip('AC', Icons.ac_unit));
    }
    if (facilities.tv == true) {
      chips.add(_buildFacilityChip('TV', Icons.tv));
    }
    if (facilities.geyser == true) {
      chips.add(_buildFacilityChip('Geyser', Icons.hot_tub));
    }
    if (facilities.fridge == true) {
      chips.add(_buildFacilityChip('Fridge', Icons.kitchen));
    }
    if (facilities.cupboard == true) {
      chips.add(_buildFacilityChip('Cupboard', Icons.door_sliding));
    }
    if (facilities.other != null && facilities.other!.isNotEmpty) {
      chips.addAll(
        facilities.other!
            .split("\n\n")
            .map((e) => _buildFacilityChip(e, Icons.more_horiz))
            .toList(),
      );
    }

    if (chips.isEmpty) {
      chips.add(
        const Text(
          'No facilities specified',
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor,
          ),
        ),
      );
    }

    return chips;
  }

  /// Build individual facility chip
  Widget _buildFacilityChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorRes.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor; // add this
  final Color? iconColor;
  final double sizeContainer;
  final double iconSize; // add this

  const CircularIcon({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor, // add this
    this.iconColor,
    this.sizeContainer = 40,
    this.iconSize = 24,
    // add this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: sizeContainer,
        width: sizeContainer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: backgroundColor ?? ColorRes.leadGreyColor.shade300, // fallback
        ),
        child: Icon(icon, color: iconColor ?? ColorRes.primary, size: iconSize),
      ),
    );
  }
}

class Facilities extends StatefulWidget {
  final Items property;
  final Color bgColor;
  final Color txtColor;

  const Facilities({
    super.key,
    required this.property,
    this.bgColor = ColorRes.propertyBg,
    this.txtColor = ColorRes.propertyText,
  });

  @override
  State<Facilities> createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    final highlights =
        PropertyHighlightManager(widget.property).getHighlights();

    const int maxVisible = 4;

    final visibleItems =
        showAll ? highlights : highlights.take(maxVisible).toList();

    final remainingCount = highlights.length - maxVisible;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          /// ✅ Facilities
          ...visibleItems.map(
            (item) => FacilitiesCard(
              label: item.value,
              icon: item.icon ?? Icons.info_outline,
              bgColor: widget.bgColor,
              foreColor: widget.txtColor,
            ),
          ),

          /// ✅ + Remaining Button
          if (!showAll && remainingCount > 0)
            GestureDetector(
              onTap: () {
                setState(() => showAll = true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ColorRes.primary),
                  color: ColorRes.primary.withOpacity(0.08),
                ),
                child: Text(
                  "+$remainingCount more",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.primary,
                  ),
                ),
              ),
            ),

          /// ✅ Show Less Button
          if (showAll && highlights.length > maxVisible)
            GestureDetector(
              onTap: () {
                setState(() => showAll = false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ColorRes.primary),
                ),
                child: Text(
                  "Show Less",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MoreFacilitiesCard extends StatelessWidget {
  final int count;

  const _MoreFacilitiesCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorRes.primary),
      ),
      child: Text(
        "+$count more",
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.primary,
        ),
      ),
    );
  }
}

class FacilitiesCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color foreColor;

  const FacilitiesCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.foreColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 80,
      ), // 👈 ensures small labels don't shrink too much
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.primary, width: 1),
        borderRadius: BorderRadius.circular(20), // pill-like
        color: ColorRes.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: ColorRes.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label.capitalize?.replaceAll("_", " ") ?? "",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // prevent overflow
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Details extends StatelessWidget {
  final Items property;
  final PropertyController controller = Get.put(PropertyController());

  Details({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final manager = PropertyDetailManager(property);
    final details = manager.getDetails();

    return Obx(() {
      final isExpanded = controller.isExpanded.value;
      final visibleDetails = details;
      // final visibleDetails = isExpanded ? details : details.take(4).toList();

      final screenWidth = MediaQuery.of(context).size.width;
      final itemWidth = (screenWidth / 2) - 26;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          // 🔹 Details Grid
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 20,
              runSpacing: 12,
              children:
                  visibleDetails.map((entry) {
                    final title = entry.keys.first;
                    final value = entry.values.first;

                    return SizedBox(
                      width: itemWidth,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorRes.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              getpropertyIcon(title),
                              size: 16,
                              color: ColorRes.primary,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    fontWeight: AppFontWeights.medium,
                                    color: ColorRes.leadGreyColor[700],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: AppFontSizes.small,
                                    fontWeight: AppFontWeights.semiBold,
                                    color: ColorRes.blackShade87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.update, size: 16, color: ColorRes.primary),
                ),

                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.leadGreyColor[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Formatter.formatDate(property.updatedAt) ?? '-',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.blackShade87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class AmenitiesSection extends StatefulWidget {
  final List<String> amenities;

  AmenitiesSection({super.key, required this.amenities});

  @override
  State<AmenitiesSection> createState() => _AmenitiesSectionState();
}

class _AmenitiesSectionState extends State<AmenitiesSection> {
  bool _expanded = false;
  final Color bgColor = ColorRes.propertyBg;
  final Color txtColor = ColorRes.propertyText;

  @override
  Widget build(BuildContext context) {
    final items = widget.amenities;
    final total = items.length;
    final visibleCount = _expanded ? total : (total >= 6 ? 6 : total);
    final amenityColors = [
      ColorRes.blueColor,
      ColorRes.error,
      ColorRes.leadIndigoColor,
      ColorRes.orangeColor,
      ColorRes.leadTealColor,
      ColorRes.primary,
      ColorRes.purpleColor,
      ColorRes.green,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.99,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: visibleCount,
            itemBuilder: (context, index) {
              final raw = items[index];
              final amenity = raw
                  .toLowerCase()
                  .replaceAll(" ", "_")
                  .replaceAll("-", "_");
              final color = amenityColors[index % amenityColors.length];
              final iconData = IconManager.getAmenitiesIcon(amenity);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconData, color: color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    capitalizeEachWord(amenity),
                    style: const TextStyle(
                      fontSize: AppFontSizes.extraSmall,

                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
          if (total > 6)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Center(
                  child: Text(
                    _expanded ? 'Show Less' : 'Show More',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OfferCountdown extends StatefulWidget {
  final Duration? duration;
  final String? propertyId;
  final VoidCallback? onFinished;
  const OfferCountdown({super.key, this.duration, this.propertyId, this.onFinished});
  @override
  State<OfferCountdown> createState() => _OfferCountdownState();
}

class _OfferCountdownState extends State<OfferCountdown>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _countdownController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    Duration initialDuration;
    int initialDays = 0;
    if (widget.propertyId != null && widget.propertyId!.isNotEmpty) {
      final seed = widget.propertyId!.hashCode;
      initialDays = 5 + (seed.abs() % 11);
      initialDuration = Duration(days: initialDays);
    } else {
      initialDuration = widget.duration ?? const Duration(days: 1);
    }

    _countdownController = AnimationController(
      vsync: this,
      duration: initialDuration,
    )..forward();

    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        try { widget.onFinished?.call(); } catch (_) {}
        if (widget.propertyId != null && widget.propertyId!.isNotEmpty) {
          final rnd = Random();
          final newDays = 5 + rnd.nextInt(11);
          _countdownController.duration = Duration(days: newDays);
          _countdownController.reset();
          _countdownController.forward();
        } else {
          _countdownController.reset();
          _countdownController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdownController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _countdownController,
      builder: (context, _) {
        final elapsed = _countdownController.lastElapsedDuration ?? Duration.zero;
        final duration = _countdownController.duration ?? Duration.zero;
        final left = duration - elapsed;
        final totalLeftSeconds = left.inSeconds.clamp(0, duration.inSeconds == 0 ? left.inSeconds : duration.inSeconds);
        final daysLeft = (totalLeftSeconds + 86399) ~/ 86400;
        final hoursLeft = (totalLeftSeconds % 86400) ~/ 3600;
        final minsLeft = (totalLeftSeconds % 3600) ~/ 60;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF5F7), Color(0xFFFFFBFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: const Color(0xFFFFD6DE), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: ColorRes.error.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Subtle shimmer overlay
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, _) {
                    return Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(
                              -1.5 + _shimmerController.value * 3.5,
                              -0.5,
                            ),
                            end: Alignment(
                              -0.5 + _shimmerController.value * 3.5,
                              0.5,
                            ),
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    children: [
                      // Flame icon with pulse
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                        ),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [ColorRes.error, Color(0xFFFF3D5E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: ColorRes.error.withOpacity(0.30),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 24),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'LIMITED OFFER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: ColorRes.error,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Offer expires soon',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Time units
                      Row(
                        children: [
                          _TimeUnit(value: daysLeft, label: 'DAYS'),
                          _Divider(),
                          _TimeUnit(value: hoursLeft, label: 'HRS'),
                          _Divider(),
                          _TimeUnit(value: minsLeft, label: 'MIN'),
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
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;
  const _TimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFD6DE), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: ColorRes.error,
          height: 1.2,
        ),
      ),
    );
  }
}

class NearbyPropertyDetails extends StatelessWidget {
  final List<NearbyLocations> nearbyLocations;

  const NearbyPropertyDetails({super.key, required this.nearbyLocations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
      child: SizedBox(
        height: 75, // slightly taller for balance
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: nearbyLocations.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final loc = nearbyLocations[index];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.small,
                vertical: AppPadding.small,
              ),
              decoration: BoxDecoration(
                color: ColorRes.white, // ✅ soft background
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommonText(
                    loc.name ?? "-",
                    AppFontSizes.caption,
                    AppFontWeights.medium,
                    ColorRes.textColor,
                    1,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: ColorRes.grey.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      buildCommonText(
                        (loc.distance != null) ? '${loc.distance}' : "2.5 Km",
                        AppFontSizes.extraSmall,
                        AppFontWeights.semiBold,
                        ColorRes.leadGreyColor.shade600,
                        1,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RecommendedInsights extends StatelessWidget {
  final List<NearbyLocations> nearbyLocations;

  const RecommendedInsights({super.key, required this.nearbyLocations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
      child: SizedBox(
        height: 75, // slightly taller for balance
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: nearbyLocations.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final loc = nearbyLocations[index];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: AppPadding.small),
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.small,
                vertical: AppPadding.small,
              ),
              decoration: BoxDecoration(
                color: ColorRes.white, // ✅ soft background
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommonText(
                    loc.name ?? "-",
                    AppFontSizes.caption,
                    AppFontWeights.medium,
                    ColorRes.textColor,
                    1,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: ColorRes.grey.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      buildCommonText(
                        (loc.distance != null) ? '${loc.distance}' : "2.5 Km",
                        AppFontSizes.extraSmall,
                        AppFontWeights.semiBold,
                        ColorRes.leadGreyColor.shade600,
                        1,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OwnerInformation extends StatelessWidget {
  final Items property;
  final PropertyController controller;

  const OwnerInformation({
    super.key,
    required this.property,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,

            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorRes.leadGreyColor[200],
                        border: Border.all(
                          color: ColorRes.deepPurpleColor, // border color
                          width: 2, // border thickness
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: ColorRes.deepPurpleColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DataMasker.maskName(property.ownerName),
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              color: ColorRes.textPrimary,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (property.ownerPhone != null)
                            Row(
                              children: [
                                // Icon(
                                //   Icons.phone_outlined,
                                //   size: 12,
                                //   color: ColorRes.leadGreyColor,
                                // ),
                                // SizedBox(width: 6),
                                Text(
                                  DataMasker.maskPhone(property.ownerPhone),
                                  style: TextStyle(
                                    color: ColorRes.grey,
                                    fontSize: AppFontSizes.small,
                                    fontWeight: AppFontWeights.medium,
                                  ),
                                ),
                              ],
                            ),
                          if (property.ownerEmail != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    DataMasker.maskEmail(property.ownerEmail),
                                    style: TextStyle(
                                      color: ColorRes.grey,
                                      fontSize: AppFontSizes.small,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
            ),
          ],
        ),
      ),
    );
  }
}

class ContactSellerCard extends StatelessWidget {
  final Items property;
  final PropertyController controller = Get.put(PropertyController());

  ContactSellerCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner Info
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(IMGRes.home2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.ownerName ?? "-",
                          style: const TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (property.ownerPhone != null)
                          Text(
                            "+91 ${property.ownerPhone ?? '-'}",
                            style: const TextStyle(
                              color: ColorRes.grey,
                              fontSize: AppFontSizes.extraSmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Checkboxes using Obx
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: controller.allowContact.value,
                  onChanged:
                      (val) => controller.allowContact.value = val ?? false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: ColorRes.grey, width: 1),
                  activeColor: ColorRes.primary,
                ),
                const Expanded(
                  child: Text(
                    "Allow sellers to get in touch",
                    style: TextStyle(fontSize: AppFontSizes.caption),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: controller.interestedInHomeLoan.value,
                  onChanged:
                      (val) =>
                          controller.interestedInHomeLoan.value = val ?? false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: ColorRes.grey, width: 1),
                  activeColor: ColorRes.primary,
                ),
                const Expanded(
                  child: Text(
                    "I am interested in Home loans",
                    style: TextStyle(fontSize: AppFontSizes.caption),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Info Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thumb_up, size: 15, color: ColorRes.blackShade54),
              SizedBox(width: 6),
              Text(
                "Perfect Choice! Users like you also liked this",
                style: TextStyle(
                  fontSize: AppFontSizes.extraSmall,
                  color: ColorRes.blackShade54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              backgroundColor: ColorRes.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Check availability with seller",
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class ProjectBrochure extends StatelessWidget {
  final String brochureImageUrl;
  final String brochureUrl;
  final int totalPages;

  const ProjectBrochure({
    super.key,
    required this.brochureImageUrl,
    required this.brochureUrl,
    this.totalPages = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorRes.leadGreyColor.shade200,
              border: Border.all(
                color: ColorRes.grey.withOpacity(0.6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 16 / 8,
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        brochureImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: ColorRes.leadGreyColor,
                            ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.blackShade54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "1/$totalPages",
                          style: const TextStyle(
                            color: ColorRes.white,
                            fontSize: AppFontSizes.extraSmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorRes.primary,
                    ), // outline like OutlinedButton
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Share action
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, size: 15, color: ColorRes.primary),
                          SizedBox(width: 8),
                          Text(
                            "Share",
                            style: TextStyle(
                              color: ColorRes.primary,
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorRes.blueColor, // same as ElevatedButton
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Open PDF viewer or download
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, size: 15, color: ColorRes.white),
                          SizedBox(width: 8),
                          Text(
                            "Download",
                            style: TextStyle(
                              color: ColorRes.white,
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectDetails extends StatelessWidget {
  final String projectName;
  final double minPrice;
  final double maxPrice;
  final String launchedDate;
  final int units;
  final double projectArea;
  final String reraId;
  final List<NearbyLocations> nearbyProjects;

  const ProjectDetails({
    super.key,
    required this.projectName,
    required this.minPrice,
    required this.maxPrice,
    required this.launchedDate,
    required this.units,
    required this.projectArea,
    required this.reraId,
    required this.nearbyProjects,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: nearbyProjects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final project = nearbyProjects[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppPadding.small,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.small,
                    vertical: AppPadding.small,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          project.name == projectName
                              ? ColorRes.deepPurpleColor
                              : ColorRes.leadGreyColor.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        project.name!,
                        style: const TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.textColor,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${project.distance ?? '2.1 Km'}',
                        style: const TextStyle(
                          color: ColorRes.grey,
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // Additional Details
          Row(
            spacing: 25,
            children: [
              _detailItem("Launched in", 'Jul,2024'),
              _verticalDivider(),
              _detailItem("Units", units.toString()),
              _verticalDivider(),
              _detailItem("Project area", "$projectArea Acres"),
            ],
          ),
          const SizedBox(height: 12),
          // Text(
          //   "RERA ID: $reraId",
          //   style: TextStyle(
          //     color: Colors.black54,
          //     fontSize: AppFontSizes.small,
          //   ),
          // ),
          _detailItem("RERA ID", reraId),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: ColorRes.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.share,
                  color: ColorRes.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.white,
                    foregroundColor: ColorRes.primary,
                    side: const BorderSide(color: ColorRes.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "View More Details",
                    style: TextStyle(
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: AppFontSizes.caption,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: ColorRes.blackShade54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: AppFontWeights.semiBold,
            fontSize: AppFontSizes.small,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() =>
      Container(height: 20, width: 1, color: ColorRes.leadGreyColor);
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subText;
  final IconData? icon;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subText,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 165, // fixed width for balance
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Title
          buildCommonText(
            title,
            AppFontSizes.caption,
            AppFontWeights.semiBold,
            ColorRes.textColor,
            1,
          ),
          const SizedBox(height: 6),

          /// Value + optional icon + subtext
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? ColorRes.black, size: 15),
                const SizedBox(width: 4),
              ],
              buildCommonText(
                value,
                AppFontSizes.extraSmall,
                AppFontWeights.semiBold,
                iconColor ?? ColorRes.black,
                1,
              ),
              if (subText != null) ...[
                const SizedBox(width: 4),
                buildCommonText(
                  subText ?? '',
                  AppFontSizes.extraSmall,
                  FontWeight.normal,
                  ColorRes.leadGreyColor,
                  1,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyFeedbackComponent extends StatefulWidget {
  final Function(int rating, String feedback) onSubmit;

  const PropertyFeedbackComponent({super.key, required this.onSubmit});

  @override
  State<PropertyFeedbackComponent> createState() =>
      _PropertyFeedbackComponentState();
}

class _PropertyFeedbackComponentState extends State<PropertyFeedbackComponent> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        // width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.leadGreyColor.shade400, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Feedback Property",
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
            //     color: ColorRes.leadGreyColor[800],
            //     fontSize: 13,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            const SizedBox(height: 10),

            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your feedback...",
                hintStyle: const TextStyle(
                  fontSize: 14,
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
                child: Text(
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
