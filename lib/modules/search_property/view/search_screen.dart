import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/widgets/mic_search/search_mic.dart';
import 'package:housing_flutter_app/data/network/city/tending_city/trending_city_model.dart';
import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';

//import 'package:housing_flutter_app/modules/home/controllers/home_controller/home_controller.dart';
import 'package:housing_flutter_app/modules/other/trending_city/controllers/trending_city_controller.dart';
import 'package:housing_flutter_app/modules/other/trending_city/views/trending_city_card.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/search_property/controller/search_controller.dart';
import 'package:housing_flutter_app/modules/search_property/widget/change_location.dart';
import 'package:housing_flutter_app/modules/search_property/widget/search_result.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_area.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggeted_card.dart';
import 'package:housing_flutter_app/utils/global.dart';
import 'package:housing_flutter_app/widgets/input/custom_text_field.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../builder/view/project_detail/project_detail.dart';
import '../../filter_property/controller/city_insigths_controller.dart';
import '../../filter_property/model/city_insigths_model.dart';
import '../../propert_detail/view/property_details.dart';
import '../../property/controllers/property_controller.dart';
import '../model/search_model.dart';

// class CommonSearchField extends StatefulWidget {
//   final Function(Prediction)? onCitySelected;
//   final bool isFromAddProperty;
//   final String? initialSearchText;
//   final String hintText;
//   final Function(String city)? onTap;
//   final bool isLocality =false;
//
//   const CommonSearchField({
//     super.key,
//     this.onCitySelected,
//     this.isFromAddProperty = false,
//     this.initialSearchText,
//     this.hintText = 'Change City...',
//     this.onTap,
//   });
//
//   @override
//   State<CommonSearchField> createState() => _CommonSearchFieldState();
// }
//
// class _CommonSearchFieldState extends State<CommonSearchField> {
//   final MicController micController = Get.put(MicController());
//
//   final GoogleMapController controller = Get.put(GoogleMapController());
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialSearchText != null &&
//         widget.initialSearchText!.isNotEmpty) {
//       micController.searchText.value.text = widget.initialSearchText!;
//       print('micro jsdewud ${micController.searchText.value.text}');
//       controller.fetchPredictionsCity(widget.initialSearchText!);
//     }
//     micController.searchText.value.addListener(() {
//       controller.fetchPredictionsCity(micController.searchText.value.text);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => CityController());
//     Get.lazyPut(() => TrendingCityController());
//     final cityController = Get.find<CityController>();
//     final trendingCityController = Get.find<TrendingCityController>();
//     final PropertyController propertyController =
//         Get.find<PropertyController>();
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         title: buildCommonText(
//           'Search',
//           20,
//           AppFontWeights.semiBold,
//           ColorRes.black,
//           1,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: ColorRes.black),
//           onPressed: () {
//             Navigator.of(context).pop();
//             micController.searchText.value.clear();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Obx(
//                       () => CustomTextField(
//                         enabled: true,
//                         fillColor: ColorRes.white,
//                         suffixIcon: const Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: AppPadding.medium,
//                           ),
//                           child: Icon(
//                             Icons.search,
//                             color: ColorRes.primary,
//                             size: 25,
//                           ),
//                         ),
//                         controller: micController.searchText.value,
//                         hintText: widget.hintText,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: () {
//                       // Open bottom sheet
//                       Get.bottomSheet(
//                         _openMicSheet(),
//                         backgroundColor: ColorRes.white,
//                         isScrollControlled: true,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(20),
//                           ),
//                         ),
//                       );
//                       micController.listen();
//                       ever(micController.isListening, (bool listening) {
//                         if (!listening) {
//                           micController.stopListening();
//                           if ((Get.isBottomSheetOpen ?? false) ||
//                               micController.searchText.value.text.isNotEmpty) {
//                             Get.back(); // Close the bottom sheet
//                           }
//                         }
//                       });
//                     },
//                     child: Container(
//                       height: 52,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 14,
//                         horizontal: 15,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Obx(
//                         () => Icon(
//                           micController.isListening.value
//                               ? Icons.mic
//                               : Icons.mic_none,
//                           color: ColorRes.primary,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             AppSpacing.verticalMedium,
//             Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: SizedBox.shrink());
//               }
//
//               if (micController.searchText.value.text.isNotEmpty) {
//                 if (controller.predictions.isEmpty) {
//                   return Center(
//                     child: buildCommonText(
//                       'No results found',
//                       AppFontSizes.medium,
//                       AppFontWeights.regular,
//                       ColorRes.leadGreyColor.shade600,
//                       1,
//                     ),
//                   );
//                 }
//
//                 return ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.predictions.length,
//                   separatorBuilder:
//                       (context, index) => Divider(
//                         color: ColorRes.leadGreyColor.shade300,
//                         height: 2,
//                         indent: 16,
//                         endIndent: 16,
//                       ),
//                   itemBuilder: (context, index) {
//                     final Prediction item = controller.predictions[index];
//                     return InkWell(
//                       // onTap:
//                       //     widget.onTap!(item.description!) ??
//                       //     () {
//                       //       if (widget.onCitySelected != null) {
//                       //         widget.onCitySelected!(item);
//                       //
//                       //         controller.predictions
//                       //             .clear(); // Clear predictions
//                       //         micController.searchText.value.clear();
//                       //       }
//                       //       // Remove navigation to RealEstateFilterScreen for city selection
//                       //
//                       //       final filters = {"city": item.description ?? ""};
//                       //       print("Applied Filters: $filters");
//                       //       Get.back(result: filters);
//                       //     },
//                       onTap: () {
//                         if (widget.onTap != null) {
//                           widget.onTap!(item.description!);
//                         } else {
//                           // Fallback if onTap is not provided
//                           if (widget.onCitySelected != null) {
//                             widget.onCitySelected!(item);
//
//                             controller.predictions.clear(); // Clear predictions
//                             micController.searchText.value.clear();
//                           }
//                         }
//                       },
//
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: AppPadding.medium,
//                           vertical: AppPadding.small,
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.apartment,
//                               color: ColorRes.primary,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Main text with highlight
//                                   highlightText(
//                                     item.description ?? "",
//                                     micController.searchText.value.text,
//                                     item.structuredFormatting?.secondaryText ??
//                                         '',
//                                     normalStyle: const TextStyle(
//                                       fontSize: AppFontSizes.bodySmall,
//                                       fontWeight: AppFontWeights.medium,
//                                       color: ColorRes.textColor,
//                                     ),
//                                     highlightStyle: const TextStyle(
//                                       fontSize: AppFontSizes.extraSmall,
//                                       fontWeight: AppFontWeights.extraBold,
//                                       color: ColorRes.error,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   // Secondary text as subtitle
//                                   Text(
//                                     item.structuredFormatting?.secondaryText ??
//                                         '',
//                                     style: const TextStyle(
//                                       fontSize: AppFontSizes.extraSmall,
//                                       fontWeight: AppFontWeights.regular,
//                                       color:
//                                           ColorRes
//                                               .grey, // Optional, lighter color
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               } else {
//                 return (widget.isFromAddProperty)
//                     ? SizedBox.shrink()
//                     : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Obx(() {
//                           if (cityController.allCities.isEmpty) {
//                             return Center(child: CircularProgressIndicator());
//                           }
//                           return buildSection(
//                             "Popular Locations",
//                             cityController.allCities,
//                           );
//                         }),
//                         Obx(() {
//                           if (trendingCityController
//                               .allTrendingCities
//                               .isEmpty) {
//                             return Center(child: CircularProgressIndicator());
//                           }
//                           return buildSectionTrending(
//                             "Nearby Places",
//                             trendingCityController.allTrendingCities,
//                           );
//                         }),
//                         AppSpacing.verticalSmall,
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(
//                         //     horizontal: AppPadding.small,
//                         //   ),
//                         //   child: Column(
//                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                         //     children: [
//                         //       GestureDetector(
//                         //         onTap: () {
//                         //           Navigator.of(context).push(
//                         //             MaterialPageRoute(
//                         //               builder:
//                         //                   (context) => const ChangeLocation(),
//                         //             ),
//                         //           );
//                         //         },
//                         //         child: Container(
//                         //           margin: const EdgeInsets.only(
//                         //             left: AppPadding.small,
//                         //           ),
//                         //           padding: const EdgeInsets.symmetric(
//                         //             horizontal: AppPadding.small,
//                         //             vertical: AppPadding.small,
//                         //           ),
//                         //           decoration: BoxDecoration(
//                         //             borderRadius: BorderRadius.circular(
//                         //               AppRadius.small,
//                         //             ),
//                         //             border: Border.all(
//                         //               color: ColorRes.leadGreyColor.shade300,
//                         //               width: 1,
//                         //             ),
//                         //             color: ColorRes.leadGreyColor.shade100,
//                         //           ),
//                         //           child: buildCommonText(
//                         //             'Change Location',
//                         //             AppFontSizes.small,
//                         //             AppFontWeights.semiBold,
//                         //             ColorRes.textColor,
//                         //             1,
//                         //           ),
//                         //         ),
//                         //       ),
//                         //       AppSpacing.verticalSmall,
//                         //       buildFilterHeadingPadding('Some Popular Cities'),
//                         //       AppSpacing.verticalSmall,
//                         //       CityDropdownResult(
//                         //         initialCity: popularCities,
//                         //         onCitySelected: (index, city) {
//                         //           setState(() {
//                         //             popularCities = city;
//                         //             popularArea =
//                         //                 popularCitiesWithAreas[city]?[0] ?? '';
//                         //           });
//                         //           print("Selected City: $city at index $index");
//                         //         },
//                         //       ),
//                         //       AppSpacing.verticalSmall,
//                         //       buildFilterHeadingPadding(
//                         //         'Suggested Area ($popularCities)',
//                         //       ),
//                         //       AppSpacing.verticalSmall,
//                         //       SelectableWrap(
//                         //         items:
//                         //             popularCitiesWithAreas[popularCities] ?? [],
//                         //         selectedItem: popularArea,
//                         //         onSelected: (value) {
//                         //           setState(() {
//                         //             popularArea = value;
//                         //             print("Selected Area: $value");
//                         //           });
//                         //         },
//                         //       ),
//                         //       AppSpacing.verticalSmall,
//                         //     ],
//                         //   ),
//                         // ),
//                       ],
//                     );
//               }
//             }),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// MARK: - Mic Bottom Sheet
//
//   Widget _openMicSheet() {
//     // // Start listening immediately
//     // micController.listen();
//     return SafeArea(
//       child: SizedBox(
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Voice Search",
//                 style: TextStyle(
//                   fontSize: AppFontSizes.large,
//                   fontWeight: AppFontWeights.extraBold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Mic Button
//               Obx(() {
//                 final isListening = micController.isListening.value;
//                 return GestureDetector(
//                   onTap: micController.listen,
//                   child: Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           isListening
//                               ? ColorRes.error.shade100
//                               : ColorRes.leadGreyColor.shade200,
//                     ),
//                     child: Icon(
//                       isListening ? Icons.mic : Icons.mic_none,
//                       color:
//                           isListening ? ColorRes.error : ColorRes.blackShade54,
//                       size: 40,
//                     ),
//                   ),
//                 );
//               }),
//
//               const SizedBox(height: 16),
//               Obx(
//                 () => Text(
//                   micController.isListening.value
//                       ? "Listening..."
//                       : "Tap mic to start",
//                   style: TextStyle(fontSize: AppFontSizes.body),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Recognized words
//               Obx(() {
//                 final words = micController.lastWords.value;
//                 return Text(
//                   words,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class CommonSearchField extends StatefulWidget {
  final Function(Prediction)? onCitySelected;
  final bool isFromAddProperty;
  final String? initialSearchText;
  final bool onlySearchCity;
  final String hintText;
  final Function(String city)? onTap;
  final bool isNavigate;
  final bool isLocality; // Add this parameter
  final String? selectedCity; // Add this for locality filtering

  const CommonSearchField({
    super.key,
    this.onCitySelected,
    this.isFromAddProperty = false,
    this.onlySearchCity = false,
    this.initialSearchText,
    this.isNavigate = false,
    this.hintText = 'Change City...',
    this.onTap,
    this.isLocality = false, // Default to city search
    this.selectedCity, // Required when isLocality = true
  });

  @override
  State<CommonSearchField> createState() => _CommonSearchFieldState();
}

class _CommonSearchFieldState extends State<CommonSearchField> {
  // final MicController micController = Get.find<MicController>();
  final MicController micController = Get.put(MicController());
  final GoogleMapSearchController controller =
      Get.find<GoogleMapSearchController>(tag: 'city');

  //final trendingArea=Get.put(HomeFeedController());

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchText != null &&
        widget.initialSearchText!.isNotEmpty) {
      micController.searchText.value.text = widget.initialSearchText!;
      print('micro jsdewud ${micController.searchText.value.text}');

      // Call appropriate search based on isLocality
      if (widget.isLocality) {
        controller.fetchPredictionsLocality(
          widget.initialSearchText!,
          widget.selectedCity ?? '',
        );
      } else {
        if (!widget.onlySearchCity) {
          print("jkfhweudfhuiefhwefhuif");
          controller.fetchPredictionsCity(widget.initialSearchText!);
        } else {
          controller.fetchGooglePlaces(widget.initialSearchText!);
        }
      }
    }

    micController.searchText.value.addListener(() {
      // Call appropriate search based on isLocality
      if (widget.isLocality) {
        controller.fetchPredictionsLocality(
          micController.searchText.value.text,
          widget.selectedCity ?? '',
        );
      } else {
        if (!widget.onlySearchCity) {
          controller.fetchPredictionsCity(micController.searchText.value.text);
        } else {
          controller.fetchGooglePlaces(micController.searchText.value.text);
        }
        // controller.fetchPredictionsCity(micController.searchText.value.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CityController());
    Get.lazyPut(() => TrendingCityController());
    final cityController = Get.find<CityController>();
    final trendingCityController = Get.find<TrendingCityController>();
    final PropertyController propertyController =
        Get.find<PropertyController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title:
            widget.isLocality && widget.selectedCity != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCommonText(
                      'Search Locality',
                      18,
                      AppFontWeights.semiBold,
                      ColorRes.black,
                      1,
                    ),
                    buildCommonText(
                      'in ${widget.selectedCity}',
                      12,
                      AppFontWeights.regular,
                      ColorRes.grey,
                      1,
                    ),
                  ],
                )
                : buildCommonText(
                  'Search',
                  20,
                  AppFontWeights.semiBold,
                  ColorRes.black,
                  1,
                ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.black),
          onPressed: () {
            Navigator.of(context).pop();
            micController.searchText.value.clear();
            print("Search filter ${widget.selectedCity}");
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => CustomTextField(
                        enabled: true,
                        fillColor: ColorRes.white,
                        suffixIcon: InkWell(
                          onTap: () {
                            final searchText =
                                micController.searchText.value.text.trim();
                            final upperSearchText = searchText.toUpperCase();

                            if (upperSearchText.contains('BHK') &&
                                searchText.isNotEmpty) {
                              final bhkMatch = RegExp(
                                r'(\d+)',
                              ).firstMatch(upperSearchText);
                              final bhkNumber = bhkMatch?.group(1) ?? '';

                              Get.to(
                                () => PropertyDetail(
                                  filters: [
                                    {
                                      'bhk': bhkNumber,
                                      "city":
                                          propertyController.selectedCity.value,
                                    },
                                  ],
                                ),
                              );
                            }
                            // } else if (searchText.isNotEmpty) {
                            //
                            //   Get.to(
                            //     () => PropertyDetail(
                            //       filters: [
                            //         {
                            //           'city': searchText.split(',').first,
                            //         },
                            //       ],
                            //     ),
                            //   );
                            // }

                            // Clear search
                            controller.predictions.clear();
                            micController.searchText.value.clear();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.medium,
                            ),
                            child: Icon(
                              Icons.search,
                              color: ColorRes.primary,
                              size: 25,
                            ),
                          ),
                        ),
                        controller: micController.searchText.value,
                        hintText:
                            widget.isLocality && widget.selectedCity != null
                                ? 'Search locality in ${widget.selectedCity}...'
                                : widget.hintText,
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Open bottom sheet
                  //     Get.bottomSheet(
                  //       _openMicSheet(),
                  //       backgroundColor: ColorRes.white,
                  //       isScrollControlled: true,
                  //       shape: const RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.vertical(
                  //           top: Radius.circular(20),
                  //         ),
                  //       ),
                  //     );
                  //     micController.listen();
                  //     ever(micController.isListening, (bool listening) {
                  //       if (!listening) {
                  //         micController.stopListening();
                  //         if ((Get.isBottomSheetOpen ?? false) ||
                  //             micController.searchText.value.text.isNotEmpty) {
                  //           Get.back(); // Close the bottom sheet
                  //         }
                  //       }
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 52,
                  //     padding: const EdgeInsets.symmetric(
                  //       vertical: 14,
                  //       horizontal: 15,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: ColorRes.leadGreyColor.shade300,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     child: Obx(
                  //       () => Icon(
                  //         micController.isListening.value
                  //             ? Icons.mic
                  //             : Icons.mic_none,
                  //         color: ColorRes.primary,
                  //         size: 24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            AppSpacing.verticalMedium,
            Obx(() {
              print(
                "Prediction LIst ${controller.predictions.map((e) => e.toJson())}",
              );
              if (controller.isLoading.value) {
                return const Center(child: SizedBox.shrink());
              }

              if (micController.searchText.value.text.isNotEmpty) {
                if (controller.predictions.isEmpty) {
                  return Center(
                    child: buildCommonText(
                      widget.isLocality
                          ? 'No localities found in ${widget.selectedCity}'
                          : 'No results found',
                      AppFontSizes.medium,
                      AppFontWeights.regular,
                      ColorRes.leadGreyColor.shade600,
                      1,
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.predictions.length,
                  separatorBuilder:
                      (context, index) => Divider(
                        color: ColorRes.leadGreyColor.shade300,
                        height: 2,
                        indent: 16,
                        endIndent: 16,
                      ),
                  itemBuilder: (context, index) {
                    final Prediction item = controller.predictions[index];

                    return InkWell(
                      // onTap:(widget.isNavigate)? () async {
                      //
                      //   final result = await showDialog<bool>(
                      //     context: context,
                      //     builder:
                      //         (context) => AlertDialog(
                      //           backgroundColor: ColorRes.white,
                      //           title: Text('Change your location'),
                      //           content: Text(
                      //             'Do you really want to change the location?',
                      //           ),
                      //           actions: [
                      //             TextButton(
                      //               onPressed:
                      //                   () => Navigator.pop(context, false),
                      //               child: const Text('No'),
                      //             ),
                      //             ElevatedButton(
                      //               onPressed:
                      //                   () => Navigator.pop(context, true),
                      //               child: const Text('Yes'),
                      //             ),
                      //           ],
                      //         ),
                      //   );
                      //   if (result == false) {
                      //     // User clicked "No" - Navigate to PropertyDetail WITHOUT changing home screen
                      //     if (!widget.isLocality) {
                      //       // Return result with applyToHome: false flag
                      //       // This tells home_header to NOT apply filter to home screen
                      //       Get.off(() => PropertyDetail(filters: [{
                      //         'city':item.description!.split(',').first
                      //       }]));
                      //       // Clear search state
                      //       controller.predictions.clear();
                      //       micController.searchText.value.clear();
                      //     }
                      //
                      //   } else if (result == true) {
                      //     // User clicked "Yes" - Change location on home screen AND navigate
                      //     if (widget.isLocality) {
                      //       // Handle locality search
                      //       if (widget.onTap != null) {
                      //         widget.onTap!(item.description!);
                      //       } else if (widget.onCitySelected != null) {
                      //         widget.onCitySelected!(item);
                      //         controller.predictions.clear();
                      //         micController.searchText.value.clear();
                      //       }
                      //     } else {
                      //       // NEW CODE: Call onTap to update home screen
                      //       // onTap will call Get.back(result: filters) which sets applyToHome: true by default
                      //       if (widget.onTap != null) {
                      //         widget.onTap!(item.description!); // ✅ Updates home screen
                      //       }
                      //
                      //       if (widget.onCitySelected != null) {
                      //         widget.onCitySelected!(item);
                      //       }
                      //       Get.to(() => PropertyDetail(filters: [{
                      //         'city':item.description!.split(',').first
                      //       }]));
                      //
                      //       // Clear search state
                      //       controller.predictions.clear();
                      //       micController.searchText.value.clear();
                      //     }
                      //   }
                      // }:(){
                      //   if(widget.isLocality)
                      //   {
                      //     if(widget.onTap!=null)
                      //     {
                      //       widget.onTap!(item.description!);
                      //     }
                      //     else{
                      //       if (widget.onCitySelected != null) {
                      //         widget.onCitySelected!(item);
                      //
                      //         controller.predictions.clear();
                      //         micController.searchText.value.clear();
                      //       }
                      //     }
                      //
                      //   }
                      //   else {
                      //     // Fallback if onTap is not provided
                      //     if (widget.onTap != null) {
                      //       widget.onTap!(item.description!);
                      //     }
                      //     else if(widget.onCitySelected != null) {
                      //       widget.onCitySelected!(item);
                      //
                      //       controller.predictions.clear(); // Clear predictions
                      //       micController.searchText.value.clear();
                      //     }
                      //   }
                      // },
                      onTap:
                          (widget.isFromAddProperty)
                              ? () {
                                if (widget.isLocality) {
                                  if (widget.onTap != null) {
                                    widget.onTap!(item.description!);
                                  } else {
                                    if (widget.onCitySelected != null) {
                                      widget.onCitySelected!(item);

                                      controller.predictions.clear();
                                      micController.searchText.value.clear();
                                    }
                                  }
                                } else {
                                  // Fallback if onTap is not provided
                                  if (widget.onTap != null) {
                                    widget.onTap!(item.description!);
                                  } else if (widget.onCitySelected != null) {
                                    widget.onCitySelected!(item);

                                    controller.predictions
                                        .clear(); // Clear predictions
                                    micController.searchText.value.clear();
                                  }
                                }
                              }
                              : () {
                                // Check if this is a BHK property search result
                                if (item.items != null) {
                                  Get.to(
                                    () => PropertyDetailScreen(
                                      propertyId: item.items!.id ?? '',
                                    ),
                                  );
                                  controller.predictions.clear();
                                  micController.searchText.value.clear();
                                }
                                if (item.projectItem != null) {
                                  Get.to(
                                    () => ProjectDetailsScreen(
                                      projectItem: item.projectItem!,
                                    ),
                                  );
                                  controller.predictions.clear();
                                  micController.searchText.value.clear();
                                } else if (widget.isLocality) {
                                  if (widget.onTap != null) {
                                    widget.onTap!(item.description!);
                                  }

                                  if (widget.onCitySelected != null) {
                                    widget.onCitySelected!(item);
                                  }

                                  Get.to(
                                    () => PropertyDetail(
                                      filters: [
                                        {
                                          'city':
                                              item.description!
                                                  .split(',')
                                                  .first,
                                        },
                                      ],
                                    ),
                                  );
                                  controller.predictions
                                      .clear(); // Clear predictions
                                  micController.searchText.value.clear();
                                } else {
                                  if (widget.onTap != null) {
                                    widget.onTap!(item.description!);
                                  }
                                  if (widget.onCitySelected != null) {
                                    widget.onCitySelected!(item);
                                  }
                                  controller.predictions
                                      .clear(); // Clear predictions
                                  micController.searchText.value.clear();
                                  Get.to(
                                    () => PropertyDetail(
                                      filters: [
                                        {
                                          'city':
                                              item.description!
                                                  .split(',')
                                                  .first,
                                        },
                                      ],
                                    ),
                                  );
                                }
                              },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.medium,
                          vertical: AppPadding.small,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              // 🏠 Property/BHK search result
                              item.items != null
                                  ? Icons.home_filled
                                  : item.projectItem != null
                                  ? Icons.apartment_outlined
                                  : Icons.location_on_outlined,
                              color: ColorRes.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Main text with highlight
                                  highlightText(
                                    item.description ?? "",
                                    micController.searchText.value.text,
                                    item.structuredFormatting?.secondaryText ??
                                        '',
                                    normalStyle: const TextStyle(
                                      fontSize: AppFontSizes.bodySmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.textColor,
                                    ),
                                    highlightStyle: const TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.extraBold,
                                      color: ColorRes.error,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // Secondary text as subtitle
                                  Text(
                                    item.structuredFormatting?.secondaryText ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.regular,
                                      color: ColorRes.grey,
                                    ),
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
              } else {
                // Show popular locations only for city search, not locality
                return (widget.isFromAddProperty || widget.isLocality)
                    ? Center(
                      child: buildCommonText(
                        widget.isLocality
                            ? 'Search for localities in ${widget.selectedCity}'
                            : '',
                        AppFontSizes.medium,
                        AppFontWeights.regular,
                        ColorRes.grey,
                        2,
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          if (cityController.allCities.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return buildSection(
                            "Popular Locations",
                            cityController.allCities,
                          );
                        }),
                        Obx(() {
                          if (trendingCityController
                              .allTrendingCities
                              .isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return buildSectionTrending(
                            "Nearby Places",
                            trendingCityController.allTrendingCities,

                            //trendingArea
                          );
                        }),
                        AppSpacing.verticalSmall,
                      ],
                    );
              }
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// MARK: - Mic Bottom Sheet
  Widget _openMicSheet() {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Voice Search",
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.extraBold,
                ),
              ),
              const SizedBox(height: 20),

              // Mic Button
              Obx(() {
                final isListening = micController.isListening.value;
                return GestureDetector(
                  onTap: micController.listen,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isListening
                              ? ColorRes.error.shade100
                              : ColorRes.leadGreyColor.shade200,
                    ),
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color:
                          isListening ? ColorRes.error : ColorRes.blackShade54,
                      size: 40,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              Obx(
                () => Text(
                  micController.isListening.value
                      ? "Listening..."
                      : "Tap mic to start",
                  style: TextStyle(fontSize: AppFontSizes.body),
                ),
              ),

              const SizedBox(height: 20),

              // Recognized words
              Obx(() {
                final words = micController.lastWords.value;
                return Text(
                  words,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.medium,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// MARK: - Highlight search query in results
Widget highlightText(
  String text,
  String secondText,
  String query, {
  TextStyle? normalStyle,
  TextStyle? highlightStyle,
}) {
  if (query.isEmpty) return Text(text, style: normalStyle);

  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();

  if (!lowerText.contains(lowerQuery)) {
    return Text(text, style: normalStyle);
  }

  final start = lowerText.indexOf(lowerQuery);
  final end = start + lowerQuery.length;

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: text.substring(0, start), style: normalStyle),
        TextSpan(text: text.substring(end), style: normalStyle),
      ],
    ),
  );
}

// Widget buildSection(String title, List<Map<String, dynamic>> data) {

///MARK: - Helpers
/// 🔹 Reusable section widget

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       SizedBox(height: AppSpacing.verticalSmall.height),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
//         child: buildCommonText(
//           title,
//           12,
//           AppFontWeights.semiBold,
//           ColorRes.textColor,
//           1,
//         ),
//       ),
//
//       SizedBox(
//         height: 100,
//         child: ListView.separated(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
//           itemCount: data.length,
//           separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.small),
//           itemBuilder: (context, index) {
//             final property = data[index];
//             return SuggestionCardList(
//               address: property['address']['city'],
//               price:
//                   '${property['price_range']['min']} - ${property['price_range']['max']}',
//               propertyType: property['type'],
//               cardHeight: 65,
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }

Widget buildSection(String title, List<CityData> data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: AppSpacing.verticalSmall.height),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
        child: buildCommonText(
          title,
          AppFontSizes.small,
          AppFontWeights.semiBold,
          ColorRes.textColor,
          1,
        ),
      ),

      SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.small),
          itemBuilder: (context, index) {
            final city = data[index];
            return SuggestionCardList(
              address: city.city,
              state: city.state,
              propertyType: city.listingTypes.join(", "),
              cardHeight: 65,
              onTap: () {
                final filters = {"city": city.city};
                print("Applied Filters: $filters");

                Get.back(result: filters);
              },
            );
          },
        ),
      ),
    ],
  );
}

Widget buildSectionTrending(String title, List<TrendingCityData> data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: AppSpacing.verticalSmall.height),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
        child: buildCommonText(
          title,
          AppFontSizes.small,
          AppFontWeights.semiBold,
          ColorRes.textColor,
          1,
        ),
      ),

      SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.small),
          itemBuilder: (context, index) {
            final city = data[index];
            return TrendingCityCard(
              city: city,
              onTap: () {
                final filters = {"city": city.city};

                print("Applied Filters: $filters");

                Get.back(result: filters);
              },
            );
          },
        ),
      ),
    ],
  );
}

///MARK: - Common Text Widget
Text buildCommonText(
  String title,
  double size,
  FontWeight weight,
  Color color,
  int maxLines,
) {
  return Text(
    title,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(fontSize: size, color: color, fontWeight: weight),
  );
}

///MARK: - City Dropdown
Padding buildFilterHeadingPadding(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: buildCommonText(
      title,
      AppFontSizes.medium,
      AppFontWeights.semiBold,
      ColorRes.textColor,
      1,
    ),
  );
}
