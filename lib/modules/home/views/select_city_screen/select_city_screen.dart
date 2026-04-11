// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/size_manager.dart';
// import 'package:nesticope_app/modules/filter_property/controller/city_insigths_controller.dart';
// import 'package:nesticope_app/modules/history/controller/search_history_controller.dart';
// import 'package:nesticope_app/modules/search_property/model/search_model.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../other/trending_city/controllers/trending_city_controller.dart';
// import '../../../search_property/controller/search_controller.dart';
// import '../../../search_property/view/search_screen.dart';

// class SelectCityScreen extends StatefulWidget {
//   bool? isFromLogin;
//   String? title;

//   SelectCityScreen({super.key, this.isFromLogin = false, this.title});

//   @override
//   State<SelectCityScreen> createState() => _SelectCityScreenState();
// }

// class _SelectCityScreenState extends State<SelectCityScreen> {
//   final GoogleMapSearchController controller = Get.put(
//     GoogleMapSearchController(),
//   );

//   final CityController cityController = Get.put(CityController());
//   final popularController = Get.put(TrendingCityController());

//   final TextEditingController searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode(); // 👈 for managing focus
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     cityController.isFromLoginSide.value = widget.isFromLogin ?? false;
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           NesticoPeSnackBar.showAwesomeSnackbar(
//             title: "Select City",
//             message: "Please select a city to continue",
//             contentType: ContentType.warning,
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: ColorRes.white,
//         appBar: AppBar(
//           title:
//               (widget.isFromLogin ?? false)
//                   ? Text(
//                     '${widget.title}',
//                     style: TextStyle(fontWeight: AppFontWeights.semiBold),
//                   )
//                   : Text(
//                     'Select City',
//                     style: TextStyle(fontWeight: AppFontWeights.semiBold),
//                   ),
//           centerTitle: true,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           backgroundColor: ColorRes.white,
//           foregroundColor: ColorRes.black,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               // 🔍 Search Field
//               TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search city...',
//                   prefixIcon: const Icon(Icons.search),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     if (value.trim().isNotEmpty) {
//                       cityController.selectedCity.value = value;
//                       controller.fetchGooglePlaces(value.trim());
//                     } else {
//                       controller.predictions.clear();
//                       _focusNode.unfocus();
//                     }
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),

//               // 📋 Results
//               Expanded(
//                 child: Obx(() {
//                   if ((cityController.isFromLoginSide.value) &&
//                       cityController.selectedCity.isEmpty) {
//                     return SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // 📍 Popular Locations
//                           /*  Obx(() {
//                             if (popularController.allTrendingCities.isEmpty) {

//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             return buildSection(
//                               "Popular Locations",
//                               cityController.allCities,
//                               isFromLoginSide: cityController.isFromLoginSide.value,
//                             );
//                           }),*/
//                           // 📍 Popular Locations
//                           Obx(() {
//                             if (popularController.allTrendingCities.isEmpty) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }

//                             final cities = popularController.allTrendingCities;

//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16.0,
//                                 vertical: 12.0,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Header Row
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                        Text(
//                                         "Popular Cities",
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600,
//                                           color: ColorRes.textColor,
//                                         ),
//                                       ),
//                                       // Container(
//                                       //   padding: const EdgeInsets.symmetric(
//                                       //     horizontal: 10,
//                                       //     vertical: 4,
//                                       //   ),
//                                       //   decoration: BoxDecoration(
//                                       //     color: Colors.orange.shade100,
//                                       //     borderRadius: BorderRadius.circular(
//                                       //       12,
//                                       //     ),
//                                       //   ),
//                                       //   child: const Text(
//                                       //     "New Hotspots",
//                                       //     style: TextStyle(
//                                       //       fontSize: 11,
//                                       //       color: Colors.deepOrange,
//                                       //       fontWeight: FontWeight.w600,
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 14),

//                                   // Grid of Cities
//                                   GridView.builder(
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemCount: cities.length,
//                                     gridDelegate:
//                                         const SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 3,
//                                           mainAxisSpacing: 2,
//                                           crossAxisSpacing: 10,
//                                           childAspectRatio: 0.70,
//                                         ),
//                                     itemBuilder: (context, index) {
//                                       final city = cities[index];
//                                       final isSelected =
//                                           cityController.selectedCity.value ==
//                                           city.city;

//                                       return GestureDetector(
//                                         onTap: () {
//                                           // cityController.selectedCity.value =
//                                           //     city.city;
//                                          if(cityController.isFromLoginSide.value){
//                                            final selectedCity = city.city.trim();
//                                            Get.back(result: selectedCity);
//                                          }

//                                         },
//                                         child: Column(
//                                           children: [
//                                             Stack(
//                                               alignment: Alignment.center,
//                                               children: [
//                                                 Container(
//                                                   height: 70,
//                                                   width: 70,
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     border: Border.all(
//                                                       color:
//                                                           isSelected
//                                                               ? Colors
//                                                                   .blueAccent
//                                                               : Colors
//                                                                   .transparent,
//                                                       width: 2,
//                                                     ),
//                                                     image: DecorationImage(
//                                                       image: NetworkImage(
//                                                         city.cityImage ?? '',
//                                                       ),
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.black
//                                                             .withOpacity(0.1),
//                                                         blurRadius: 6,
//                                                         offset: const Offset(
//                                                           0,
//                                                           3,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 if (isSelected)
//                                                   Container(
//                                                     height: 70,
//                                                     width: 70,
//                                                     decoration: BoxDecoration(
//                                                       shape: BoxShape.circle,
//                                                       color: Colors.black
//                                                           .withOpacity(0.4),
//                                                     ),
//                                                     child: const Icon(
//                                                       Icons.check_circle,
//                                                       color: Colors.white,
//                                                       size: 26,
//                                                     ),
//                                                   ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Text(
//                                               city.city ?? '',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600,
//                                                 color:
//                                                     isSelected
//                                                         ? Colors.blueAccent
//                                                         : Colors.black87,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),

//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     );
//                   }
//                   if (controller.isLoading.value) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (controller.predictions.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No results found.',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     );
//                   }

//                   return ListView.separated(
//                     itemCount: controller.predictions.length,
//                     separatorBuilder:
//                         (_, __) => Divider(
//                           height: 1,
//                           thickness: 1,
//                           color: Colors.grey.shade200,
//                         ),
//                     itemBuilder: (context, index) {
//                       final Prediction prediction =
//                           controller.predictions[index];
//                       final description = prediction.description.toString();
//                       final parts =
//                           description.split(',').map((e) => e.trim()).toList();
//                       final city = parts.isNotEmpty ? parts[0] : '';
//                       final location =
//                           parts.length > 1 ? parts.sublist(1).join(', ') : '';
//                       return InkWell(
//                         onTap: () async {
//                           final city =
//                               prediction.description
//                                   .toString()
//                                   .split(',')
//                                   .first
//                                   .trim();
//                           _focusNode.unfocus();
//                           Get.back(result: city);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.location_on_outlined,
//                                   size: 20,
//                                   color: Colors.grey.shade700,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       city,
//                                       style: TextStyle(
//                                         fontSize: AppFontSizes.small + 1,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     if (location.isNotEmpty) ...[
//                                       const SizedBox(height: 2),
//                                       Text(
//                                         location,
//                                         style: TextStyle(
//                                           fontSize: AppFontSizes.small - 1,
//                                           color: Colors.grey.shade600,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 14,
//                                 color: Colors.grey.shade400,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/size_manager.dart';
// import 'package:nesticope_app/modules/filter_property/controller/city_insigths_controller.dart';
// import 'package:nesticope_app/modules/history/controller/search_history_controller.dart';
// import 'package:nesticope_app/modules/search_property/model/search_model.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../other/trending_city/controllers/trending_city_controller.dart';
// import '../../../search_property/controller/search_controller.dart';
// import '../../../search_property/view/search_screen.dart';

// class SelectCityScreen extends StatefulWidget {
//   bool? isFromLogin;
//   String? title;

//   SelectCityScreen({super.key, this.isFromLogin = false, this.title});

//   @override
//   State<SelectCityScreen> createState() => _SelectCityScreenState();
// }

// class _SelectCityScreenState extends State<SelectCityScreen> {
//   final GoogleMapSearchController controller = Get.put(
//     GoogleMapSearchController(),
//   );

//   final CityController cityController = Get.put(CityController());
//   final popularController = Get.put(TrendingCityController());

//   final TextEditingController searchController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   // ✅ Plain bool — managed by setState. No Obx needed for local UI state.
//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     cityController.isFromLoginSide.value = widget.isFromLogin ?? false;
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String value) {
//     final hasText = value.trim().isNotEmpty;
//     if (hasText) {
//       cityController.selectedCity.value = value;
//       controller.fetchGooglePlaces(value.trim());
//     } else {
//       controller.predictions.clear();
//       _focusNode.unfocus();
//     }
//     // Only call setState to toggle the search/main-content switch
//     if (_isSearching != hasText) {
//       setState(() => _isSearching = hasText);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           NesticoPeSnackBar.showAwesomeSnackbar(
//             title: "Select City",
//             message: "Please select a city to continue",
//             contentType: ContentType.warning,
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: AppBar(
//           title: Text(
//             (widget.isFromLogin ?? false)
//                 ? (widget.title ?? 'Select City')
//                 : 'Select City',
//             style: const TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 18,
//               color: Colors.white,
//             ),
//           ),
//           centerTitle: true,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ─── Hero Banner ───────────────────────────────────────────────
//                 _HeroBanner(),

//                 // ─── Search Bar ────────────────────────────────────────────────
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
//                   child: _SearchBar(
//                     controller: searchController,
//                     focusNode: _focusNode,
//                     onChanged: _onSearchChanged,
//                   ),
//                 ),

//                 // ─── Search Results ─────────────────────────────────────────────
//                 // Only shown when user is typing. Uses Obx to react to
//                 // controller.isLoading and controller.predictions (both are Rx).
//                 if (_isSearching)
//                   Obx(() {
//                     if (controller.isLoading.value) {
//                       return const Padding(
//                         padding: EdgeInsets.all(32),
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }
//                     if (controller.predictions.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.all(32),
//                         child: Center(
//                           child: Text(
//                             'No results found.',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                       );
//                     }
//                     return _PredictionList(
//                       predictions: controller.predictions.toList(),
//                       focusNode: _focusNode,
//                     );
//                   }),

//                 // ─── Main Content ───────────────────────────────────────────────
//                 // Only shown when search bar is empty.
//                 if (!_isSearching) ...[
//                   _SectionHeader(title: 'Unlock Local Insights'),
//                   _InsightCards(),

//                   // Popular Cities — separate Obx only for the cities list
//                   Obx(() {
//                     final cities = popularController.allTrendingCities;
//                     if (cities.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }
//                     // selectedCity is observed here so city highlight updates
//                     final selected = cityController.selectedCity.value;
//                     return _PopularCitiesSection(
//                       cities: cities.toList(),
//                       selectedCity: selected,
//                       isFromLoginSide: cityController.isFromLoginSide.value,
//                     );
//                   }),

//                   const SizedBox(height: 32),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Hero Banner
// // ─────────────────────────────────────────────────────────────────────────────
// class _HeroBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       height: 190,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//         image: DecorationImage(
//           image: AssetImage('assets/images/banner_22.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           // 🔵 Primary gradient overlay (modern look)
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(16)),
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Colors.black.withOpacity(0.75),
//                     ColorRes.primary.withOpacity(0.75),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ✨ Soft decorative circles (more subtle)
//           Positioned(
//             right: -20,
//             top: -20,
//             child: Container(
//               width: 140,
//               height: 140,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.2),
//               ),
//             ),
//           ),
//           Positioned(
//             left: -30,
//             bottom: -30,
//             child: Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.2),
//               ),
//             ),
//           ),

//           // 📌 Content
//           Padding(
//             padding: const EdgeInsets.all(22),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Discover Your\nPerfect Space',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                     height: 1.3,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Buy or rent properties with NesticoPe',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.85),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 14),

//                 // 🚀 CTA Button
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.4),
//                       width: 1,
//                     ),
//                   ),
//                   child: const Text(
//                     'Connecting You to Better Homes',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Search Bar
// // ─────────────────────────────────────────────────────────────────────────────
// class _SearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final ValueChanged<String> onChanged;

//   const _SearchBar({
//     required this.controller,
//     required this.focusNode,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         onChanged: onChanged,
//         style: const TextStyle(fontSize: 14, color: Colors.black87),
//         decoration: InputDecoration(
//           hintText: 'Search city, area, or project',
//           hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
//           prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Prediction List
// // ─────────────────────────────────────────────────────────────────────────────
// class _PredictionList extends StatelessWidget {
//   final List<Prediction> predictions;
//   final FocusNode focusNode;

//   const _PredictionList({required this.predictions, required this.focusNode});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: predictions.length,
//         separatorBuilder:
//             (_, __) =>
//                 Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
//         itemBuilder: (context, index) {
//           final prediction = predictions[index];
//           final description = prediction.description.toString();
//           final parts = description.split(',').map((e) => e.trim()).toList();
//           final city = parts.isNotEmpty ? parts[0] : '';
//           final location = parts.length > 1 ? parts.sublist(1).join(', ') : '';

//           return InkWell(
//             borderRadius: BorderRadius.circular(14),
//             onTap: () {
//               final cityName = description.split(',').first.trim();
//               focusNode.unfocus();
//               Get.back(result: cityName);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFEEF0FB),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.location_on_outlined,
//                       size: 20,
//                       color: Color(0xFF3949AB),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           city,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         if (location.isNotEmpty) ...[
//                           const SizedBox(height: 2),
//                           Text(
//                             location,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade500,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     size: 13,
//                     color: Colors.grey.shade400,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Section Header
// // ─────────────────────────────────────────────────────────────────────────────
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final String? actionLabel;
//   final VoidCallback? onAction;

//   const _SectionHeader({required this.title, this.actionLabel, this.onAction});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Insight Cards
// // ─────────────────────────────────────────────────────────────────────────────
// class _InsightCards extends StatelessWidget {
//   final _insights = const [
//     _InsightData(
//       icon: Icons.home_work_outlined,
//       title: 'Find Better Properties',
//       subtitle: 'Discover exclusive listings tailored to the area.',
//     ),
//     _InsightData(
//       icon: Icons.apartment_outlined,
//       title: 'Top Projects',
//       subtitle: 'Access information on the most sought-after developments.',
//     ),
//     _InsightData(
//       icon: Icons.lightbulb_outline,
//       title: 'Local Expertise',
//       subtitle: 'Get insights from local market experts.',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: _insights.map((item) => _InsightCard(data: item)).toList(),
//       ),
//     );
//   }
// }

// class _InsightData {
//   final IconData icon;
//   final String title;
//   final String subtitle;

//   const _InsightData({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });
// }

// class _InsightCard extends StatelessWidget {
//   final _InsightData data;

//   const _InsightCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: ColorRes.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(data.icon, size: 22, color: ColorRes.primary),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data.title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   data.subtitle,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Popular Cities Section (horizontal scroll)
// // ─────────────────────────────────────────────────────────────────────────────
// class _PopularCitiesSection extends StatelessWidget {
//   final List cities;
//   final String selectedCity;
//   final bool isFromLoginSide;

//   const _PopularCitiesSection({
//     required this.cities,
//     required this.selectedCity,
//     required this.isFromLoginSide,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(title: 'Popular Cities', actionLabel: 'View All'),
//         SizedBox(
//           height: 110,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: cities.length,
//             itemBuilder: (context, index) {
//               final city = cities[index];
//               // ✅ Compare against plain String — no Rx reads here
//               final isSelected = selectedCity == city.city;

//               return GestureDetector(
//                 onTap: () {
//                   if (isFromLoginSide) {
//                     Get.back(result: (city.city as String).trim());
//                   }
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(right: 14),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: 68,
//                             height: 68,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color:
//                                     isSelected
//                                         ? const Color(0xFF3949AB)
//                                         : Colors.transparent,
//                                 width: 2.5,
//                               ),
//                               image: DecorationImage(
//                                 image: NetworkImage(city.cityImage ?? ''),
//                                 fit: BoxFit.cover,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.12),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (isSelected)
//                             Container(
//                               width: 68,
//                               height: 68,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black.withOpacity(0.4),
//                               ),
//                               child: const Icon(
//                                 Icons.check_circle,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 7),
//                       Text(
//                         city.city ?? '',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color:
//                               isSelected
//                                   ? const Color(0xFF3949AB)
//                                   : Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Curated Collections
// // ─────────────────────────────────────────────────────────────────────────────
// class _CuratedCollections extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(title: 'Curated Collections', actionLabel: 'View All'),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             'Discover spaces designed by award-winning architects.',
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//           ),
//         ),
//         const SizedBox(height: 14),
//         SizedBox(
//           height: 160,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               final collections = [
//                 _CollectionData(
//                   tag: 'EDITORIAL',
//                   title: "The Minimalist's Dream in NYC",
//                   color: const Color(0xFFE8EAF6),
//                 ),
//                 _CollectionData(
//                   tag: 'FEATURED',
//                   title: 'Modern Villas in LA',
//                   color: const Color(0xFFE3F2FD),
//                 ),
//                 _CollectionData(
//                   tag: 'TRENDING',
//                   title: 'Skyline Penthouses Chicago',
//                   color: const Color(0xFFE8F5E9),
//                 ),
//               ];
//               final item = collections[index];
//               return _CollectionCard(data: item);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _CollectionData {
//   final String tag;
//   final String title;
//   final Color color;

//   const _CollectionData({
//     required this.tag,
//     required this.title,
//     required this.color,
//   });
// }

// class _CollectionCard extends StatelessWidget {
//   final _CollectionData data;

//   const _CollectionCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 180,
//       margin: const EdgeInsets.only(right: 14),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: data.color,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.7),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               data.tag,
//               style: const TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF3949AB),
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//           const Spacer(),
//           Text(
//             data.title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: Colors.black87,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/filter_property/controller/city_insigths_controller.dart';
import 'package:nesticope_app/modules/search_property/model/search_model.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import '../../../../app/constants/color_res.dart';
import '../../../other/trending_city/controllers/trending_city_controller.dart';
import '../../../search_property/controller/search_controller.dart';

class SelectCityScreen extends StatefulWidget {
  bool? isFromLogin;
  String? title;

  SelectCityScreen({super.key, this.isFromLogin = false, this.title});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final GoogleMapSearchController controller = Get.put(
    GoogleMapSearchController(),
  );
  final CityController cityController = Get.put(CityController());
  final popularController = Get.put(TrendingCityController());

  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    cityController.isFromLoginSide.value = widget.isFromLogin ?? false;
    // White status bar icons to show against the dark banner
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final hasText = value.trim().isNotEmpty;
    if (hasText) {
      cityController.selectedCity.value = value;
      controller.fetchGooglePlaces(value.trim());
    } else {
      controller.predictions.clear();
      _focusNode.unfocus();
    }
    if (_isSearching != hasText) {
      setState(() => _isSearching = hasText);
    }
  }

  void _onSearchSubmit() {
    final value = searchController.text.trim();
    if (value.isNotEmpty) {
      _focusNode.unfocus();
      Get.back(result: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Select City",
            message: "Please select a city to continue",
            contentType: ContentType.warning,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        // ✅ No AppBar — banner fills from top behind status bar
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Full-width hero banner with embedded search ───────────────
              _HeroBanner(
                searchController: searchController,
                focusNode: _focusNode,
                onSearchChanged: _onSearchChanged,
                onSearchSubmit: _onSearchSubmit,
              ),

              // ─── Search Results (shown while typing) ──────────────────────
              if (_isSearching)
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (controller.predictions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return _PredictionList(
                    predictions: controller.predictions.toList(),
                    focusNode: _focusNode,
                  );
                }),

              // ─── Main Content (shown when not searching) ───────────────────
          if (!_isSearching) ...[
  Stack(
    children: [
      // ── Background image ──────────────────────────────────────
      Positioned.fill(
        child: Image.asset(
          'assets/images/login_background.jpg',
          fit: BoxFit.cover,
        ),
      ),

      // ── Semi-transparent overlay for readability ───────────────
      Positioned.fill(
        child: Container(
          color: Colors.white.withOpacity(0.70),
        ),
      ),

      // ── Foreground content ─────────────────────────────────────
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final cities = popularController.allTrendingCities;
            if (cities.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final selected = cityController.selectedCity.value;
            return _PopularCitiesSection(
              cities: cities.toList(),
              selectedCity: selected,
              isFromLoginSide: cityController.isFromLoginSide.value,
            );
          }),
          _SectionHeader(title: 'Unlock Local Insights'),
          _InsightCards(),
          const SizedBox(height: 50),
        ],
      ),
    ],
  ),
],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Banner — dark indigo/purple, dot-grid texture, embedded search at bottom
// ─────────────────────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchSubmit;

  const _HeroBanner({
    required this.searchController,
    required this.focusNode,
    required this.onSearchChanged,
    required this.onSearchSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/banner_22.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // ── Dot grid texture ──────────────────────────────────────────────
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.30),
                        Colors.white.withOpacity(0.02),
                          Colors.black.withOpacity(0.40),
                    ColorRes.black.withOpacity(0.40),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorRes.black.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          // ── Glowing circle accent (top-right) ─────────────────────────────
          Positioned(
            left: -50,
            top: topPadding,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(24, topPadding + 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "PREMIUM CURATOR" badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: ColorRes.primary,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black.withOpacity(0.22)),
                  ),
                  child: const Text(
                    'TRUSTED ON NESTICOPE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Headline
                const Text(
                  'Find Your Dream Property\nwith NesticoPe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 14),

                // Subtitle
                Text(
                  'Browse verified listings, explore top locations,\nand find homes tailored to your lifestyle.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.65,
                  ),
                ),

                const SizedBox(height: 25),

                // ── Embedded search bar ─────────────────────────────────────
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          focusNode: focusNode,
                          onChanged: onSearchChanged,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search city',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // SEARCH button
                      GestureDetector(
                        onTap: onSearchSubmit,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.primary,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Text(
                            'SEARCH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dot grid texture to replicate the screenshot's dark dotted background
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.045)
          ..style = PaintingStyle.fill;
    const spacing = 18.0;
    const radius = 1.3;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Prediction List
// ─────────────────────────────────────────────────────────────────────────────
class _PredictionList extends StatelessWidget {
  final List<Prediction> predictions;
  final FocusNode focusNode;

  const _PredictionList({required this.predictions, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: predictions.length,
        separatorBuilder:
            (_, __) =>
                Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          final description = prediction.description.toString();
          final parts = description.split(',').map((e) => e.trim()).toList();
          final city = parts.isNotEmpty ? parts[0] : '';
          final location = parts.length > 1 ? parts.sublist(1).join(', ') : '';

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              focusNode.unfocus();
              Get.back(result: description.split(',').first.trim());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF0FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Color(0xFF3730A3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (location.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 13,
                    color: Colors.grey.shade400,
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

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Insight Cards
// ─────────────────────────────────────────────────────────────────────────────
class _InsightCards extends StatelessWidget {
  final _insights = const [
    _InsightData(
      icon: Icons.home_work_outlined,
      title: 'Find Better Properties',
      subtitle: 'Discover exclusive listings tailored to the area.',
    ),
    _InsightData(
      icon: Icons.apartment_outlined,
      title: 'Top Projects',
      subtitle: 'Access information on the most sought-after developments.',
    ),
    _InsightData(
      icon: Icons.lightbulb_outline,
      title: 'Local Expertise',
      subtitle: 'Get insights from local market experts.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _insights.map((e) => _InsightCard(data: e)).toList(),
      ),
    );
  }
}

class _InsightData {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InsightData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _InsightCard extends StatelessWidget {
  final _InsightData data;

  const _InsightCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 22, color: ColorRes.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Popular Cities Section
// ─────────────────────────────────────────────────────────────────────────────
// class _PopularCitiesSection extends StatelessWidget {
//   final List cities;
//   final String selectedCity;
//   final bool isFromLoginSide;

//   const _PopularCitiesSection({
//     required this.cities,
//     required this.selectedCity,
//     required this.isFromLoginSide,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(title: 'Popular Cities', actionLabel: 'View All'),
//         SizedBox(
//           height: 110,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: cities.length,
//             itemBuilder: (context, index) {
//               final city = cities[index];
//               final isSelected = selectedCity == city.city;

//               return GestureDetector(
//                 onTap: () {
//                   if (isFromLoginSide) {
//                     Get.back(result: (city.city as String).trim());
//                   }
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(right: 14),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: 68,
//                             height: 68,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color:
//                                     isSelected
//                                         ? const Color(0xFF3730A3)
//                                         : Colors.transparent,
//                                 width: 2.5,
//                               ),
//                               image: DecorationImage(
//                                 image: NetworkImage(city.cityImage ?? ''),
//                                 fit: BoxFit.cover,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.12),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (isSelected)
//                             Container(
//                               width: 68,
//                               height: 68,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black.withOpacity(0.4),
//                               ),
//                               child: const Icon(
//                                 Icons.check_circle,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 7),
//                       Text(
//                         city.city ?? '',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color:
//                               isSelected
//                                   ? const Color(0xFF3730A3)
//                                   : Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
class _PopularCitiesSection extends StatelessWidget {
  final List cities;
  final String selectedCity;
  final bool isFromLoginSide;

  const _PopularCitiesSection({
    required this.cities,
    required this.selectedCity,
    required this.isFromLoginSide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Popular Cities', actionLabel: 'View All'),
        SizedBox(
          height: 100, // fixed height for all cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              final isSelected = selectedCity == city.city;

              return GestureDetector(
                onTap: () {
                  if (isFromLoginSide) {
                    Get.back(result: (city.city as String).trim());
                  }
                },
                child: Container(
                  width: 100,          // ✅ fixed width — all cards same size
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3730A3)
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0xFF3730A3).withOpacity(0.18)
                            : Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // ── City image fills the full square card ──────────
                        Positioned.fill(
                          child: Image.network(
                            city.cityImage ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: Icon(Icons.location_city,
                                  color: Colors.grey.shade400, size: 32),
                            ),
                          ),
                        ),

                        // ── Gradient overlay for text readability ──────────
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.55),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ── Selected checkmark badge ───────────────────────
                        if (isSelected)
                          Positioned(
                            top: 7,
                            right: 7,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3730A3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),

                        // ── City name at bottom ────────────────────────────
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Text(
                            city.city ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // SizedBox(
        //   height: 210, // adjust height for 2 rows
        //   child: GridView.builder(
        //     scrollDirection: Axis.horizontal,
        //     padding: EdgeInsets.zero,
        //     itemCount: cities.length,
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       crossAxisSpacing: 6,
        //       // mainAxisSpacing: 8,
        //       // childAspectRatio: 1,
        //       mainAxisSpacing: 12,
        //       childAspectRatio: 0.75,
        //       //square cards
        //     ),
        //     itemBuilder: (context, index) {
        //       final city = cities[index];
        //       final isSelected = selectedCity == city.city;

        //       return GestureDetector(
        //         onTap: () {
        //           if (isFromLoginSide) {
        //             Get.back(result: (city.city as String).trim());
        //           }
        //         },
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(14),
        //             border: Border.all(
        //               color:
        //                   isSelected
        //                       ? const Color(0xFF3730A3)
        //                       : Colors.transparent,
        //               width: 2,
        //             ),
        //             boxShadow: [
        //               BoxShadow(
        //                 color:
        //                     isSelected
        //                         ? const Color(0xFF3730A3).withOpacity(0.18)
        //                         : Colors.black.withOpacity(0.06),
        //                 blurRadius: 10,
        //                 offset: const Offset(0, 4),
        //               ),
        //             ],
        //           ),
        //           child: ClipRRect(
        //             borderRadius: BorderRadius.circular(12),
        //             child: Stack(
        //               children: [
        //                 Positioned.fill(
        //                   child: Image.network(
        //                     city.cityImage ?? '',
        //                     fit: BoxFit.cover,
        //                     errorBuilder:
        //                         (_, __, ___) => Container(
        //                           color: Colors.grey.shade200,
        //                           child: Icon(
        //                             Icons.location_city,
        //                             color: Colors.grey.shade400,
        //                             size: 32,
        //                           ),
        //                         ),
        //                   ),
        //                 ),

        //                 Positioned.fill(
        //                   child: DecoratedBox(
        //                     decoration: BoxDecoration(
        //                       gradient: LinearGradient(
        //                         begin: Alignment.topCenter,
        //                         end: Alignment.bottomCenter,
        //                         colors: [
        //                           Colors.transparent,
        //                           Colors.black.withOpacity(0.55),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),

        //                 if (isSelected)
        //                   Positioned(
        //                     top: 7,
        //                     right: 7,
        //                     child: Container(
        //                       width: 22,
        //                       height: 22,
        //                       decoration: const BoxDecoration(
        //                         color: Color(0xFF3730A3),
        //                         shape: BoxShape.circle,
        //                       ),
        //                       child: const Icon(
        //                         Icons.check,
        //                         color: Colors.white,
        //                         size: 13,
        //                       ),
        //                     ),
        //                   ),

        //                 Positioned(
        //                   bottom: 8,
        //                   left: 0,
        //                   right: 0,
        //                   child: Text(
        //                     city.city ?? '',
        //                     textAlign: TextAlign.center,
        //                     maxLines: 1,
        //                     overflow: TextOverflow.ellipsis,
        //                     style: const TextStyle(
        //                       fontSize: 11,
        //                       fontWeight: FontWeight.w700,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Curated Collections
// ─────────────────────────────────────────────────────────────────────────────
class _CuratedCollections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final collections = [
      _CollectionData(
        tag: 'EDITORIAL',
        title: "The Minimalist's Dream in NYC",
        color: const Color(0xFFE8EAF6),
      ),
      _CollectionData(
        tag: 'FEATURED',
        title: 'Modern Villas in LA',
        color: const Color(0xFFE3F2FD),
      ),
      _CollectionData(
        tag: 'TRENDING',
        title: 'Skyline Penthouses Chicago',
        color: const Color(0xFFE8F5E9),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Curated Collections', actionLabel: 'View All'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Text(
            'Discover spaces designed by award-winning architects.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: collections.length,
            itemBuilder: (_, i) => _CollectionCard(data: collections[i]),
          ),
        ),
      ],
    );
  }
}

class _CollectionData {
  final String tag;
  final String title;
  final Color color;

  const _CollectionData({
    required this.tag,
    required this.title,
    required this.color,
  });
}

class _CollectionCard extends StatelessWidget {
  final _CollectionData data;

  const _CollectionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              data.tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3730A3),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Spacer(),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
