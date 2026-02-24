// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
//
// import '../../app/constants/app_font_sizes.dart';
// import '../../app/constants/color_res.dart';
// import '../../app/constants/size_manager.dart';
// import '../../modules/search_property/controller/search_controller.dart';
// import '../New folder/inputs/dropdown_field.dart';
//
// class CitySelectionWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final bool isEditing;
//   final Function(Prediction)? onCitySelected; // ✅ callback for selected city
//   final InputDecoration? decoration;
//   final Color? color;
//   final Color? fillColor;
//
//   const CitySelectionWidget({
//     super.key,
//     required this.controller,
//
//     this.onCitySelected,
//     this.isEditing = true,
//     this.decoration,  this.color, this.fillColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final googleMapController = Get.put(GoogleMapSearchController(), tag: "city");
//
//     return Column(
//       children: [
//         // 🔹 Custom TextField
//         TextFormField(
//           controller: controller,
//           enabled: isEditing,
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             color: ColorRes.homeBlackFade,
//           ),
//           decoration:
//               decoration ??
//               InputDecoration(
//                 labelText: "Select City",
//                 labelStyle: TextStyle(
//                   fontSize: AppFontSizes.small,
//                   color: ColorRes.leadGreyColor[500],
//                 ),
//                 prefixIcon: Icon(
//                   Icons.apartment_outlined,
//                   size: 20,
//                   color: color??ColorRes.leadGreyColor[600],
//
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: ColorRes.leadGreyColor.withOpacity(0.3),
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: ColorRes.leadGreyColor.withOpacity(0.3),
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     color: ColorRes.blueColor,
//                     width: 1.5,
//                   ),
//                 ),
//                 disabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: ColorRes.leadGreyColor.withOpacity(0.2),
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: ColorRes.error, width: 1),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     color: ColorRes.error,
//                     width: 1.5,
//                   ),
//                 ),
//                 filled: true,
//                 fillColor:fillColor?? ColorRes.leadGreyColor[50],
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//               ),
//           onChanged: (value) async {
//             if (value.isNotEmpty) {
//               await googleMapController.fetchGooglePlaces(value);
//               log("City input: $value");
//             } else {
//               googleMapController.predictions.clear();
//             }
//           },
//         ),
//
//         const SizedBox(height: 8),
//
//         // 🔹 City Suggestions (Obx listens for updates)
//         // Obx(() {
//         //   final predictions = googleMapController.predictions;
//         //
//         //   if (predictions.isEmpty) {
//         //     return const SizedBox(); // hide when no suggestions
//         //   }
//         //
//         //   return Container(
//         //     constraints: const BoxConstraints(maxHeight: 250),
//         //     margin: const EdgeInsets.only(top: 4),
//         //     decoration: BoxDecoration(
//         //       color: Colors.white,
//         //       borderRadius: BorderRadius.circular(12),
//         //     ),
//         //     child: ListView.builder(
//         //       shrinkWrap: true,
//         //       itemCount: predictions.length > 3 ? 3 : predictions.length,
//         //       itemBuilder: (context, index) {
//         //         final city = predictions[index];
//         //         return ListTile(
//         //           leading: const Icon(Icons.location_city_outlined,size: 20,color: ColorRes.primary,),
//         //           title: Text(city.description ?? '',style: TextStyle(
//         //             fontSize: AppFontSizes.small,
//         //             color: ColorRes.homeBlackFade,
//         //           ),),
//         //           onTap: () {
//         //             controller.text = city.description ?? '';
//         //             googleMapController.predictions.clear();
//         //             FocusScope.of(context).unfocus(); // hide keyboard
//         //
//         //             // ✅ Return selected city via callback
//         //             if (onCitySelected != null) {
//         //               onCitySelected!(city);
//         //             }
//         //           },
//         //         );
//         //       },
//         //     ),
//         //   );
//         // }),
//         Obx(() {
//           final predictions = googleMapController.predictions;
//           final parsedCities = googleMapController.cityStateList;
//
//           // choose which list to show
//           final hasParsed = parsedCities.isNotEmpty;
//           final items = hasParsed ? parsedCities : predictions;
//
//           if (items.isEmpty) return const SizedBox();
//
//           return Container(
//             constraints: const BoxConstraints(maxHeight: 250),
//             margin: const EdgeInsets.only(top: 4),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: items.length > 3 ? 3 : items.length,
//               itemBuilder: (context, index) {
//                 if (hasParsed) {
//                   // ✅ Cast item to Map<String, String?>
//                   final cityData = items[index] as Map<String, String?>;
//
//                   log("djhfudfhg ${cityData}");
//
//                   return ListTile(
//                     leading: const Icon(
//                       Icons.location_city_outlined,
//                       size: 20,
//                       color: ColorRes.primary,
//                     ),
//                     title: Text(
//                       cityData['city'] ?? '',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: ColorRes.homeBlackFade,
//                       ),
//                     ),
//                     subtitle: Text(
//                       '${cityData['state'] ?? ''}, ${cityData['country'] ?? ''}',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: ColorRes.leadGreyColor[700],
//                       ),
//                     ),
//                     onTap: () {
//                       controller.text = cityData['city'] ?? '';
//                       googleMapController.predictions.clear();
//                       googleMapController.cityStateList.clear();
//                       FocusScope.of(context).unfocus();
//
//                       if (onCitySelected != null) {
//                         onCitySelected!(
//                           Prediction(
//                             description: cityData['city'],
//                             reference: cityData['state'],
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 } else {
//                   final city = items[index] as Prediction;
//                   return ListTile(
//                     leading: const Icon(
//                       Icons.location_city_outlined,
//                       size: 20,
//                       color: ColorRes.primary,
//                     ),
//                     title: Text(
//                       city.description ?? '',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: ColorRes.homeBlackFade,
//                       ),
//                     ),
//                     onTap: () {
//                       controller.text = city.description ?? '';
//                       googleMapController.predictions.clear();
//                       FocusScope.of(context).unfocus();
//
//                       if (onCitySelected != null) onCitySelected!(city);
//                     },
//                   );
//                 }
//               },
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
//
// class LocationSelectionWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final Function(Prediction)? onLocationSelected;
//   final String? cityFilter; // 🔹 Pass the selected city to filter results
//
//   const LocationSelectionWidget({
//     super.key,
//     required this.controller,
//     this.onLocationSelected,
//     this.cityFilter, // 🔹 City context for filtering
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final googleMapController = Get.put(GoogleMapSearchController(), tag: "location");
//
//     return Column(
//       children: [
//         Row(
//           children: [
//             Text(
//               'Location',
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 color: ColorRes.textSecondary,
//                 fontWeight: AppFontWeights.bold,
//               ),
//             ),
//             Text(
//               ' *',
//               style: TextStyle(
//                 color: Get.theme.colorScheme.error,
//                 fontSize: AppFontSizes.medium,
//                 fontWeight: AppFontWeights.bold,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8),
//
//         // ===========================
//         // 🔹 Input field
//         // ===========================
//         TextFormField(
//           controller: controller,
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             color: ColorRes.homeBlackFade,
//           ),
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.all(AppPadding.small),
//             filled: true,
//             fillColor: Get.theme.colorScheme.surface,
//             hintText:
//                 cityFilter != null
//                     ? 'Search locality, area in $cityFilter'
//                     : 'Select Location',
//             hintStyle: TextStyle(
//               color: Get.theme.colorScheme.onSurface.withAlpha(128),
//               fontSize: AppFontSizes.bodyMedium,
//               fontWeight: AppFontWeights.regular,
//             ),
//             prefixIcon: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Icon(
//                 Icons.location_on_outlined,
//                 size: 20,
//                 color: Get.theme.colorScheme.primary,
//               ),
//             ),
//             prefixIconConstraints: const BoxConstraints(minWidth: 40),
//             enabledBorder: tile(Get.theme.dividerColor),
//             focusedBorder: tile(Get.theme.colorScheme.primary),
//             errorBorder: tile(Get.theme.colorScheme.error),
//             focusedErrorBorder: tile(Get.theme.colorScheme.error),
//             disabledBorder: tile(Get.theme.dividerColor),
//             errorStyle: TextStyle(
//               color: Get.theme.colorScheme.error,
//               fontSize: AppFontSizes.small,
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//           onChanged: (value) async {
//             if (value.isNotEmpty) {
//               // 🔥 FIXED: Fetch localities/areas within the selected city
//               if (cityFilter != null && cityFilter!.isNotEmpty) {
//                 // Search for locality/area within specific city
//                 await googleMapController.fetchPredictionsLocality(
//                   value,
//                   cityFilter!,
//                 );
//               } else {
//                 // Fallback to general area search if no city filter
//                 await googleMapController.fetchPredictionsArea(value);
//               }
//             } else {
//               googleMapController.predictions.clear();
//               googleMapController.cityStateList.clear();
//             }
//           },
//         ),
//         const SizedBox(height: 8),
//
//         // ===========================
//         // 🔹 Suggestions Box
//         // ===========================
//         Obx(() {
//           final predictions = googleMapController.predictions;
//
//           if (predictions.isEmpty) return const SizedBox();
//
//           return Container(
//             constraints: const BoxConstraints(maxHeight: 250),
//             margin: const EdgeInsets.only(top: 4),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: predictions.length > 3 ? 3 : predictions.length,
//               itemBuilder: (context, index) {
//                 final prediction = predictions[index];
//
//                 // 🔹 Icon for locality/area/landmark results
//                 IconData leadingIcon = Icons.place_outlined;
//
//                 // Determine specific icon based on prediction types
//                 final desc = prediction.description?.toLowerCase() ?? '';
//                 if (desc.contains('area') || desc.contains('sector')) {
//                   leadingIcon = Icons.map_outlined;
//                 } else if (desc.contains('road') || desc.contains('street')) {
//                   leadingIcon = Icons.route_outlined;
//                 } else if (desc.contains('landmark')) {
//                   leadingIcon = Icons.location_city_outlined;
//                 }
//
//                 return ListTile(
//                   leading: Icon(leadingIcon, size: 20, color: ColorRes.primary),
//                   title: Text(
//                     prediction.structuredFormatting?.mainText ??
//                         prediction.description ??
//                         '',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       color: ColorRes.homeBlackFade,
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                   subtitle:
//                       prediction.structuredFormatting?.secondaryText != null
//                           ? Text(
//                             prediction.structuredFormatting!.secondaryText!,
//                             style: TextStyle(
//                               fontSize: AppFontSizes.small,
//                               color: ColorRes.leadGreyColor[700],
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           )
//                           : null,
//                   onTap: () {
//                     // ✅ Fill location field with the selected prediction
//                     controller.text = prediction.description ?? "";
//
//                     // ✅ Clear predictions and close dropdown
//                     googleMapController.predictions.clear();
//                     googleMapController.cityStateList.clear();
//
//                     // ✅ Dismiss keyboard
//                     FocusScope.of(context).unfocus();
//
//                     // ✅ Notify parent widget if callback provided
//                     if (onLocationSelected != null) {
//                       onLocationSelected!(prediction);
//                     }
//                   },
//                 );
//               },
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart'
    hide tile;

import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/color_res.dart';
import '../../app/constants/size_manager.dart';
import '../../modules/search_property/controller/search_controller.dart';
import '../New folder/inputs/dropdown_field.dart';

class CitySelectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;
  final Function(Prediction)? onCitySelected;
  final InputDecoration? decoration;
  final bool isRequired;
  final Color? color;
  final Color? iconColor;
  final Color? fillColor;
  final TextStyle? style;
  final bool isRequiredTitle;

  const CitySelectionWidget({
    super.key,
    required this.controller,
    this.onCitySelected,
    this.isRequired = false,
    this.isEditing = true,
    this.decoration,
    this.iconColor = ColorRes.primary,
    this.style = const TextStyle(
      fontSize: AppFontSizes.medium,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textPrimary,
    ),
    this.isRequiredTitle = true,
    this.color,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Use unique tag for city controller
    final googleMapController = Get.put(
      GoogleMapSearchController(),
      tag: "city_selector",
    );

    return Column(
      children: [
        // 🔹 Custom TextField
        // TextFormField(
        //   controller: controller,
        //   enabled: isEditing,
        //   style: TextStyle(
        //     fontSize: AppFontSizes.small,
        //     color: ColorRes.homeBlackFade,
        //   ),
        //   decoration:
        //       decoration ??
        //       InputDecoration(
        //         labelText: "Select City",
        //         labelStyle: TextStyle(
        //           fontSize: AppFontSizes.small,
        //           color: ColorRes.leadGreyColor[500],
        //         ),
        //         prefixIcon: Icon(
        //           Icons.apartment_outlined,
        //           size: 20,
        //           color: color ?? ColorRes.leadGreyColor[600],
        //         ),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: BorderSide(
        //             color: ColorRes.leadGreyColor.withOpacity(0.3),
        //           ),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: BorderSide(
        //             color: ColorRes.leadGreyColor.withOpacity(0.3),
        //           ),
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: const BorderSide(
        //             color: ColorRes.blueColor,
        //             width: 1.5,
        //           ),
        //         ),
        //         disabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: BorderSide(
        //             color: ColorRes.leadGreyColor.withOpacity(0.2),
        //           ),
        //         ),
        //         errorBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: const BorderSide(color: ColorRes.error, width: 1),
        //         ),
        //         focusedErrorBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           borderSide: const BorderSide(
        //             color: ColorRes.error,
        //             width: 1.5,
        //           ),
        //         ),
        //         filled: true,
        //         fillColor: fillColor ?? ColorRes.leadGreyColor[50],
        //         contentPadding: const EdgeInsets.symmetric(
        //           horizontal: 16,
        //           vertical: 14,
        //         ),
        //       ),
        //   onChanged: (value) async {
        //     if (value.isNotEmpty) {
        //       // ✅ Only search for cities, not general places
        //       await googleMapController.fetchGooglePlaces(value);
        //       log("City input: $value");
        //     } else {
        //       googleMapController.predictions.clear();
        //       googleMapController.cityStateList.clear();
        //     }
        //   },
        // ),
        if (isRequiredTitle) ...[
          NesticoPeTextField(
            hintText: 'Select City',
            title: "City",
            style: style??TextStyle(),
            controller: controller,
            iconColor: iconColor,
            isRequired: isRequired,
            enabled: isEditing,

            prefixIcon: Icons.apartment_outlined,

            autovalidateMode: AutovalidateMode.onUserInteraction,

            // ✅ City input handler
            onChanged: (value) async {
              if (value.isNotEmpty) {
                await googleMapController.fetchGooglePlaces(value);
                log("City input: $value");
              } else {
                googleMapController.predictions.clear();
                googleMapController.cityStateList.clear();
              }
            },

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
          ),
        ] else ...[
          NesticoPeTextField(
            hintText: 'Select City',
            iconColor: iconColor,
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
            controller: controller,
            enabled: isEditing,

            prefixIcon: Icons.apartment_outlined,

            autovalidateMode: AutovalidateMode.onUserInteraction,

            // ✅ City input handler
            onChanged: (value) async {
              if (value.isNotEmpty) {
                await googleMapController.fetchGooglePlaces(value);
                log("City input: $value");
              } else {
                googleMapController.predictions.clear();
                googleMapController.cityStateList.clear();
              }
            },

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
          ),
        ],

        const SizedBox(height: 8),

        // 🔹 City Suggestions
        Obx(() {
          final predictions = googleMapController.predictions;
          final parsedCities = googleMapController.cityStateList;

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
                  final cityData = items[index] as Map<String, String?>;

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
                          Prediction(
                            description: cityData['city'],
                            reference: cityData['state'],
                          ),
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
                      googleMapController.cityStateList.clear();
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

class LocationSelectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(Prediction)? onLocationSelected;
  final RxString? cityFilter; // Changed to RxString for reactivity

  const LocationSelectionWidget({
    super.key,
    required this.controller,
    this.onLocationSelected,
    this.cityFilter,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Use unique tag for location controller
    final googleMapController = Get.put(
      GoogleMapSearchController(),
      tag: "location_selector",
    );

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.textSecondary,
                fontWeight: AppFontWeights.bold,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                color: Get.theme.colorScheme.error,
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ===========================
        // 🔹 Input field - Now wrapped in Obx for reactivity
        // ===========================
        Obx(() {
          final city = cityFilter?.value ?? '';

          return TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.homeBlackFade,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(AppPadding.small),
              filled: true,
              fillColor: Get.theme.colorScheme.surface,
              hintText:
                  city.isNotEmpty
                      ? 'Search locality, area in $city'
                      : 'Select a city first',
              hintStyle: TextStyle(
                color: Get.theme.colorScheme.onSurface.withAlpha(128),
                fontSize: AppFontSizes.bodyMedium,
                fontWeight: AppFontWeights.regular,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 40),
              enabledBorder: tile(Get.theme.dividerColor),
              focusedBorder: tile(Get.theme.colorScheme.primary),
              errorBorder: tile(Get.theme.colorScheme.error),
              focusedErrorBorder: tile(Get.theme.colorScheme.error),
              disabledBorder: tile(Get.theme.dividerColor),
              errorStyle: TextStyle(
                color: Get.theme.colorScheme.error,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
            // ✅ Disable input if no city is selected
            enabled: city.isNotEmpty,
            onChanged: (value) async {
              if (value.isNotEmpty && city.isNotEmpty) {
                // ✅ Search for localities within the selected city
                await googleMapController.fetchPredictionsLocality(value, city);
                log("Location input: $value in city: $city");
              } else {
                googleMapController.predictions.clear();
              }
            },
          );
        }),
        const SizedBox(height: 8),

        // ===========================
        // 🔹 Suggestions Box
        // ===========================
        Obx(() {
          final predictions = googleMapController.predictions;

          if (predictions.isEmpty) return const SizedBox();

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
              itemCount: predictions.length > 5 ? 5 : predictions.length,
              itemBuilder: (context, index) {
                final prediction = predictions[index];

                // 🔹 Determine icon based on place type
                IconData leadingIcon = Icons.place_outlined;
                final desc = prediction.description?.toLowerCase() ?? '';

                if (desc.contains('area') || desc.contains('sector')) {
                  leadingIcon = Icons.map_outlined;
                } else if (desc.contains('road') || desc.contains('street')) {
                  leadingIcon = Icons.route_outlined;
                } else if (desc.contains('landmark')) {
                  leadingIcon = Icons.location_city_outlined;
                }

                return ListTile(
                  leading: Icon(leadingIcon, size: 20, color: ColorRes.primary),
                  title: Text(
                    prediction.structuredFormatting?.mainText ??
                        prediction.description ??
                        '',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.homeBlackFade,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  subtitle:
                      prediction.structuredFormatting?.secondaryText != null
                          ? Text(
                            prediction.structuredFormatting!.secondaryText!,
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: ColorRes.leadGreyColor[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                          : null,
                  onTap: () {
                    controller.text =
                        prediction.structuredFormatting?.mainText ??
                        prediction.description ??
                        "";

                    googleMapController.predictions.clear();
                    FocusScope.of(context).unfocus();

                    if (onLocationSelected != null) {
                      onLocationSelected!(prediction);
                    }
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
