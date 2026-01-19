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
    GoogleMapSearchController googleMapController=Get.put(GoogleMapSearchController(),tag: 'city');

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

              const Text('City',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: ColorRes.textColor),),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(
                  //
                  //   child: buildTextField(
                  //     "Search City",
                  //     Icons.search,
                  //     controller.cityController,
                  //     isEnable: false,
                  //
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please select a city';
                  //       }
                  //       return null;
                  //     },
                  //     onTap: () async {
                  //       Prediction selectedCity = await Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder:
                  //               (context) => CommonSearchField(
                  //                 onlySearchCity: true,
                  //                 onCitySelected: (city) {
                  //                   Navigator.pop(context, city);
                  //                 },
                  //                 isFromAddProperty: true,
                  //                 initialSearchText:
                  //                     controller.cityController.text,
                  //               ),
                  //         ),
                  //       );
                  //
                  //       controller.cityController.text =
                  //           selectedCity.description?.split(',')[0] ?? '';
                  //       p.city = controller.cityController.text;
                  //       controller.project.update((x) {
                  //         x!.city = controller.cityController.text;
                  //       });
                  //
                  //
                  //       // controller.cityController.text = selectedCity.split(',')[0];
                  //
                  //       print("city ${controller.cityController.text}");
                  //     },
                  //   ),
                  // ),
                  Expanded(
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
                            builder: (context) => CommonSearchField(
                              onlySearchCity: true,
                              onCitySelected: (city) {
                                Navigator.pop(context, city);
                              },
                              isFromAddProperty: true,
                              initialSearchText: controller.cityController.text,
                            ),
                          ),
                        );

                        // ✅ Extract city from description
                        String city = selectedCity.description?.split(',')[0].trim() ?? '';

                        // ✅ Extract state from terms array (second-to-last item before country)
                        String state = '';
                        if (selectedCity.terms != null && selectedCity.terms!.length >= 2) {
                          state = selectedCity.terms![selectedCity.terms!.length - 2].value ?? '';
                        }

                        // ✅ Update controllers
                        controller.cityController.text = city;
                        controller.stateController.text = state;

                        // ✅ Update project model
                        controller.project.update((x) {
                          x!.city = city;
                          x!.state = state;
                        });

                        print("✅ City: $city");
                        print("✅ State: $state");
                      },
                    ),
                  ),
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
                  controller.project.update((x) {
                    x!.location = selectedCity.description ?? '';
                    x!.address = selectedCity.description ?? '';
                  });


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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonTextField(
                      label: 'Zip Code',
                      keyboardType: TextInputType.number,
                      controller: controller.zipCodeController,
                      hint: 'e.g. 395010',
                      prefixIcon: const Icon(
                        Icons.local_post_office_outlined,
                        size: 20,
                        color: ColorRes.primary,
                      ),
                      initialValue: p.zipCode,
                      validator:
                          (v) => ProjectValidators.requiredText(
                            v,
                            field: 'Zip Code',
                          ),
                      onSaved:
                          (v) => controller.project.update(
                            (x) => x!.zipCode = v!.trim(),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),

                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
