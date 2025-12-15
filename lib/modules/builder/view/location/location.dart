import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

// import '../../../data/validators/project_validators.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/utils/validation.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/input/city_selection_widget.dart';
import '../../../add_property/view/create_property.dart';
import '../../../search_property/controller/search_controller.dart';
import '../../../search_property/model/search_model.dart';
import '../../../search_property/view/search_screen.dart';
import '../../controller/builder_form_controller.dart';

// import '../../controllers/project_wizard_controller.dart';
import '../widget/common_builder_textfield.dart';
import '../widget/validation/validation.dart';

class StepLocation extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;

  const StepLocation({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    GoogleMapSearchController googleMapController=Get.put(GoogleMapSearchController());
    final theme = Theme.of(context);
    return Obx(() {
      final p = controller.project.value;
      return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 12),

              // CitySelectionWidget(
              //   controller: controller.cityController,
              //   onCitySelected: (selectedCity) {
              //     print("✅ Selected city: ${selectedCity.description}");
              //     controller.cityController.text =
              //         selectedCity.description ?? '';
              //     controller.stateController.text =
              //         selectedCity.reference ?? '';
              //     // You can also store city details in your controller here
              //   },
              // ),
              // Stack(
              //   // Add this to your SingleChildScrollView
              //   clipBehavior: Clip.none,
              //   children: [
              //     NesticoPeTextField(
              //       title: "City",
              //       isRequired: true,
              //       prefixIcon: Icons.location_city_outlined,
              //       hintText: "Select City",
              //       autovalidateMode:
              //       AutovalidateMode.onUserInteraction,
              //       validator: (value) => requiredField(value, 'City'),
              //       onChanged: (value) async {
              //         if (value.isNotEmpty) {
              //           await googleMapController.fetchGooglePlaces(
              //             value,
              //           );
              //           log("City input: $value");
              //         } else {
              //           googleMapController.predictions.clear();
              //
              //         }
              //       },
              //       controller: controller.cityController,
              //     ),
              //
              //     // City Predictions Dropdown - Below TextField
              //     Obx(() {
              //       final predictions = googleMapController.predictions;
              //
              //       if (predictions.isEmpty) {
              //         return const SizedBox();
              //       }
              //
              //       return Positioned(
              //         top: 90, // Position below the text field
              //         left: 0,
              //         right: 0,
              //         child: Material(
              //           elevation: 8,
              //           shadowColor: Colors.black26,
              //           borderRadius: BorderRadius.circular(12),
              //           child: Container(
              //             constraints: const BoxConstraints(
              //               maxHeight: 250,
              //             ),
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(12),
              //               border: Border.all(
              //                 color: ColorRes.primary.withOpacity(0.2),
              //                 width: 1,
              //               ),
              //             ),
              //             child: ListView.separated(
              //               shrinkWrap: true,
              //               padding: const EdgeInsets.symmetric(
              //                 vertical: 4,
              //               ),
              //               itemCount:
              //               predictions.length > 3
              //                   ? 3
              //                   : predictions.length,
              //               separatorBuilder:
              //                   (context, index) => Divider(
              //                 height: 1,
              //                 thickness: 0.5,
              //                 color: ColorRes.grey.withOpacity(0.2),
              //               ),
              //               itemBuilder: (context, index) {
              //                 final city = predictions[index];
              //                 return GestureDetector(
              //                   behavior: HitTestBehavior.opaque,
              //                   onTap: () {
              //                     controller.cityController.text =
              //                         city.structuredFormatting?.mainText ?? '';
              //                     googleMapController.predictions.clear();
              //
              //                     // optional: unfocus keyboard
              //                     FocusScope.of(context).unfocus();
              //
              //                     // optional: save value to project
              //                     controller.project.update((x) {
              //                       x!.city = controller.cityController.text;
              //                     });
              //                   },
              //                   child: Padding(
              //                     padding: const EdgeInsets.symmetric(
              //                       horizontal: 12,
              //                       vertical: 12,
              //                     ),
              //                     child: Row(
              //                       children: [
              //                         const Icon(
              //                           Icons.location_on,
              //                           color: ColorRes.primary,
              //                           size: 20,
              //                         ),
              //                         const SizedBox(width: 12),
              //                         Text(
              //                           city.description ?? '',
              //                           style: TextStyle(
              //                             fontSize:
              //                             AppFontSizes.medium,
              //                             color: ColorRes.textPrimary,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               },
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
              //   ],
              // ),
              const Text('City',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: ColorRes.textColor),),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // child: CommonTextField(
                    //   label: 'City',
                    //   controller: controller.cityController,
                    //   hint: 'e.g. Surat ',
                    //   prefixIcon: const Icon(Icons.location_city_outlined,size: 20,color: ColorRes.primary),
                    //   initialValue: p.city,
                    //   validator: (v) => ProjectValidators.requiredText(v, field: 'City'),
                    //   onSaved: (v) => controller.project.update((x) => x!.city = v!.trim()),
                    //
                    // ),
                    child: buildTextField(
                      "Search City",
                      Icons.search,
                      controller.cityController,
                      isEnable: false,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a city';
                        }
                        return null;
                      },
                      onTap: () async {
                        Prediction selectedCity = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CommonSearchField(
                                  onlySearchCity: true,
                                  onCitySelected: (city) {
                                    Navigator.pop(context, city);
                                  },
                                  isFromAddProperty: true,
                                  initialSearchText:
                                      controller.cityController.text,
                                ),
                          ),
                        );

                        controller.cityController.text =
                            selectedCity.description?.split(',')[0] ?? '';
                        p.city = controller.cityController.text;

                        // controller.cityController.text = selectedCity.split(',')[0];

                        print("city ${controller.cityController.text}");
                      },
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   //                     child: CommonTextField(
                  //   //                       label: 'State',
                  //   // controller: controller.stateController,
                  //   //                       hint: 'e.g. Gujarat',
                  //   //                       prefixIcon: const Icon(Icons.map_outlined, size: 20,color: ColorRes.primary),
                  //   //                       initialValue: p.state,
                  //   //                       validator: (v) => ProjectValidators.requiredText(v, field: 'State'),
                  //   //                       onSaved: (v) => controller.project.update((x) => x!.state = v!.trim()),
                  //   //                     ),
                  //   child: buildTextField(
                  //     "Search State",
                  //     Icons.map_outlined,
                  //     controller.stateController,
                  //     isEnable: false,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please select a State';
                  //       }
                  //       return null;
                  //     },
                  //     onTap: () async {
                  //       Prediction selectedState = await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder:
                  //               (context) => CommonSearchField(
                  //                 onCitySelected: (state) {
                  //                   Navigator.pop(context, state);
                  //                 },
                  //                 isFromAddProperty: true,
                  //                 initialSearchText:
                  //                     controller.stateController.text,
                  //               ),
                  //         ),
                  //       );
                  //
                  //       controller.stateController.text =
                  //           selectedState.description?.split(',')[0] ?? '';
                  //       p.state = controller.stateController.text;
                  //
                  //       // controller.cityController.text = selectedCity.split(',')[0];
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Locality',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: ColorRes.textColor),),
              SizedBox(height: 10,),
              buildTextField(
                "Search Locality",
                Icons.area_chart_outlined,
                controller.locationController,
                isEnable: false,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a locality';
                  }
                  return null;
                },
                onTap: () async {
                  Prediction selectedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CommonSearchField(
                        isLocality: true,

                        selectedCity: controller.cityController.text,
                        onCitySelected: (city) {
                          Navigator.pop(context, city);
                        },
                            hintText: 'Locality',
                        isFromAddProperty: true,
                        initialSearchText:
                        controller.locationController.text,
                      ),
                    ),
                  );

                  controller.locationController.text =
                      selectedCity.description??'';
                  controller.addressController.text=
                      selectedCity.description??'';

                  // controller.cityController.text = selectedCity.split(',')[0];


                  print("city ${controller.locationController.text}");
                },
              ),
              const SizedBox(height: 12),
              CommonTextField(
                label: 'Address',
                hint: 'e.g. Ramkrishna society',
                controller: controller.addressController,
                prefixIcon: const Icon(
                  Icons.home_work_outlined,
                  size: 20,
                  color: ColorRes.primary,
                ),
                initialValue: p.address,
                validator:
                    (v) => ProjectValidators.requiredText(v, field: 'Address'),
                onSaved:
                    (v) => controller.project.update(
                      (x) => x!.address = v!.trim(),
                ),
              ),
              const SizedBox(height: 12),
              // CommonTextField(
              //   label: 'Location',
              //   controller: controller.locationController,
              //
              //   hint: 'e.g. Location,area',
              //   prefixIcon: const Icon(
              //     Icons.place_outlined,
              //     size: 20,
              //     color: ColorRes.primary,
              //   ),
              //   initialValue: p.location,
              //   validator:
              //       (v) => ProjectValidators.requiredText(
              //     v,
              //     field: 'Location',
              //   ),
              //   onSaved:
              //       (v) => controller.project.update(
              //         (x) => x!.location = v!.trim(),
              //   ),
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: CommonTextField(
              //         label: 'Zip Code',
              //         keyboardType: TextInputType.number,
              //         controller: controller.zipCodeController,
              //         hint: 'e.g. 395010',
              //         prefixIcon: const Icon(
              //           Icons.local_post_office_outlined,
              //           size: 20,
              //           color: ColorRes.primary,
              //         ),
              //         initialValue: p.zipCode,
              //         validator:
              //             (v) => ProjectValidators.requiredText(
              //               v,
              //               field: 'Zip Code',
              //             ),
              //         onSaved:
              //             (v) => controller.project.update(
              //               (x) => x!.zipCode = v!.trim(),
              //             ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}
