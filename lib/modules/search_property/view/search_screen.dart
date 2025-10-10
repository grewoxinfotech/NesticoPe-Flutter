import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/widgets/mic_search/search_mic.dart';
import 'package:housing_flutter_app/data/network/city/tending_city/trending_city_model.dart';
import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';
import 'package:housing_flutter_app/modules/other/trending_city/controllers/trending_city_controller.dart';
import 'package:housing_flutter_app/modules/other/trending_city/views/trending_city_card.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/search_property/controller/search_controller.dart';
import 'package:housing_flutter_app/modules/search_property/widget/change_location.dart';
import 'package:housing_flutter_app/modules/search_property/widget/search_result.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_area.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggeted_card.dart';
import 'package:housing_flutter_app/utils/global.dart';
import 'package:housing_flutter_app/widgets/input/custom_text_field.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../filter_property/controller/city_insigths_controller.dart';
import '../../filter_property/model/city_insigths_model.dart';
import '../model/search_model.dart';

class CommonSearchField extends StatefulWidget {
  final Function(Prediction)? onCitySelected;
  final bool isFromAddProperty;
  final String? initialSearchText;
  final String hintText;
  final Function(String city)? onTap;

  const CommonSearchField({
    super.key,
    this.onCitySelected,
    this.isFromAddProperty = false,
    this.initialSearchText,
    this.hintText = 'Surat , Gujarat , 395010',
    this.onTap,
  });

  @override
  State<CommonSearchField> createState() => _CommonSearchFieldState();
}

class _CommonSearchFieldState extends State<CommonSearchField> {
  final MicController micController = Get.put(MicController());

  final GoogleMapController controller = Get.put(GoogleMapController());
  String popularArea = 'Mumbai';
  late stt.SpeechToText _speech;
  final bool _isListening = false;
  final String _lastWords = " ";

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchText != null &&
        widget.initialSearchText!.isNotEmpty) {
      micController.searchText.value.text = widget.initialSearchText!;
      print('micro jsdewud ${micController.searchText.value.text}');
      // Fetch predictions for initial text
      controller.fetchPredictions(widget.initialSearchText!);
    }
    micController.searchText.value.addListener(() {
      controller.fetchPredictions(micController.searchText.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CityController());
    Get.lazyPut(() => TrendingCityController());
    final cityController = Get.find<CityController>();
    final trendingCityController = Get.find<TrendingCityController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: buildCommonText(
          'Search in Surat',
          20,
          FontWeight.w600,
          ColorRes.black,
          1,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.black),
          onPressed: () {
            Navigator.of(context).pop();
            micController.searchText.value.clear();
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
                        suffixIcon: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.medium,
                          ),
                          child: Icon(
                            Icons.search,
                            color: ColorRes.primary,
                            size: 25,
                          ),
                        ),
                        controller: micController.searchText.value,
                        hintText: widget.hintText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Open bottom sheet
                      Get.bottomSheet(
                        _openMicSheet(),
                        backgroundColor: ColorRes.white,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      );
                      micController.listen();
                      ever(micController.isListening, (bool listening) {
                        if (!listening) {
                          micController.stopListening();
                          if ((Get.isBottomSheetOpen ?? false) ||
                              micController.searchText.value.text.isNotEmpty) {
                            Get.back(); // Close the bottom sheet
                          }
                        }
                      });
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Obx(
                        () => Icon(
                          micController.isListening.value
                              ? Icons.mic
                              : Icons.mic_none,
                          color: ColorRes.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalMedium,
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: SizedBox.shrink());
              }

              if (micController.searchText.value.text.isNotEmpty) {
                if (controller.predictions.isEmpty) {
                  return Center(
                    child: buildCommonText(
                      'No results found',
                      AppFontSizes.medium,
                      FontWeight.w400,
                      Colors.grey.shade600,
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
                        color: Colors.grey.shade300,
                        height: 2,
                        indent: 16,
                        endIndent: 16,
                      ),
                  itemBuilder: (context, index) {
                    final Prediction item = controller.predictions[index];
                    return InkWell(
                      // onTap:
                      //     widget.onTap!(item.description!) ??
                      //     () {
                      //       if (widget.onCitySelected != null) {
                      //         widget.onCitySelected!(item);
                      //
                      //         controller.predictions
                      //             .clear(); // Clear predictions
                      //         micController.searchText.value.clear();
                      //       }
                      //       // Remove navigation to RealEstateFilterScreen for city selection
                      //
                      //       final filters = {"city": item.description ?? ""};
                      //       print("Applied Filters: $filters");
                      //       Get.back(result: filters);
                      //     },
                      onTap: () {
                        if (widget.onTap != null) {
                          widget.onTap!(item.description!);
                        } else {
                          // Fallback if onTap is not provided
                          if (widget.onCitySelected != null) {
                            widget.onCitySelected!(item);

                            controller.predictions.clear(); // Clear predictions
                            micController.searchText.value.clear();
                          }
                        }
                      },

                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.medium,
                          vertical: AppPadding.small,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.apartment,
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
                                      fontWeight: FontWeight.w500,
                                      color: ColorRes.textColor,
                                    ),
                                    highlightStyle: const TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: FontWeight.bold,
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
                                      fontWeight: FontWeight.w400,
                                      color:
                                          ColorRes
                                              .grey, // Optional, lighter color
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
                return (widget.isFromAddProperty)
                    ? SizedBox.shrink()
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
                          );
                        }),
                        AppSpacing.verticalSmall,
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: AppPadding.small,
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //               builder:
                        //                   (context) => const ChangeLocation(),
                        //             ),
                        //           );
                        //         },
                        //         child: Container(
                        //           margin: const EdgeInsets.only(
                        //             left: AppPadding.small,
                        //           ),
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: AppPadding.small,
                        //             vertical: AppPadding.small,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(
                        //               AppRadius.small,
                        //             ),
                        //             border: Border.all(
                        //               color: Colors.grey.shade300,
                        //               width: 1,
                        //             ),
                        //             color: Colors.grey.shade100,
                        //           ),
                        //           child: buildCommonText(
                        //             'Change Location',
                        //             AppFontSizes.small,
                        //             FontWeight.w600,
                        //             ColorRes.textColor,
                        //             1,
                        //           ),
                        //         ),
                        //       ),
                        //       AppSpacing.verticalSmall,
                        //       buildFilterHeadingPadding('Some Popular Cities'),
                        //       AppSpacing.verticalSmall,
                        //       CityDropdownResult(
                        //         initialCity: popularCities,
                        //         onCitySelected: (index, city) {
                        //           setState(() {
                        //             popularCities = city;
                        //             popularArea =
                        //                 popularCitiesWithAreas[city]?[0] ?? '';
                        //           });
                        //           print("Selected City: $city at index $index");
                        //         },
                        //       ),
                        //       AppSpacing.verticalSmall,
                        //       buildFilterHeadingPadding(
                        //         'Suggested Area ($popularCities)',
                        //       ),
                        //       AppSpacing.verticalSmall,
                        //       SelectableWrap(
                        //         items:
                        //             popularCitiesWithAreas[popularCities] ?? [],
                        //         selectedItem: popularArea,
                        //         onSelected: (value) {
                        //           setState(() {
                        //             popularArea = value;
                        //             print("Selected Area: $value");
                        //           });
                        //         },
                        //       ),
                        //       AppSpacing.verticalSmall,
                        //     ],
                        //   ),
                        // ),
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
    // // Start listening immediately
    // micController.listen();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Voice Search",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              ? Colors.red.shade100
                              : Colors.grey.shade200,
                    ),
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : Colors.black54,
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
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              // Recognized words
              Obx(() {
                final words = micController.lastWords.value;
                return Text(
                  words,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

///MARK: - Helpers
/// 🔹 Reusable section widget
// Widget buildSection(String title, List<Map<String, dynamic>> data) {
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
//           FontWeight.w600,
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
          12,
          FontWeight.w600,
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
          12,
          FontWeight.w600,
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
      FontWeight.w600,
      ColorRes.textColor,
      1,
    ),
  );
}
