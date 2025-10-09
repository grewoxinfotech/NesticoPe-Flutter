import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
// import '../../../data/validators/project_validators.dart';
import '../../controller/builder_form_controller.dart';
// import '../../controllers/project_wizard_controller.dart';
import '../widget/common_builder_textfield.dart';
import '../widget/validation/validation.dart';

class StepLocation extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  const StepLocation({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
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
              CommonTextField(
                label: 'Address',
                hint: 'e.g. Ramkrishna society',
                controller: controller.addressController,
                prefixIcon: const Icon(Icons.home_work_outlined, size: 20,color: ColorRes.primary,),
                initialValue: p.address,
                validator: (v) => ProjectValidators.requiredText(v, field: 'Address'),
                onSaved: (v) => controller.project.update((x) => x!.address = v!.trim()),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonTextField(
                      label: 'City',
                      controller: controller.cityController,
                      hint: 'e.g. Surat ',
                      prefixIcon: const Icon(Icons.location_city_outlined,size: 20,color: ColorRes.primary),
                      initialValue: p.city,
                      validator: (v) => ProjectValidators.requiredText(v, field: 'City'),
                      onSaved: (v) => controller.project.update((x) => x!.city = v!.trim()),

                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonTextField(
                      label: 'State',
controller: controller.stateController,
                      hint: 'e.g. Gujarat',
                      prefixIcon: const Icon(Icons.map_outlined, size: 20,color: ColorRes.primary),
                      initialValue: p.state,
                      validator: (v) => ProjectValidators.requiredText(v, field: 'State'),
                      onSaved: (v) => controller.project.update((x) => x!.state = v!.trim()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonTextField(
                      label: 'Zip Code',
controller: controller.zipCodeController,
                      hint: 'e.g. 395010',
                      prefixIcon: const Icon(Icons.local_post_office_outlined, size: 20,color: ColorRes.primary),
                      initialValue: p.zipCode,
                      validator: (v) => ProjectValidators.requiredText(v, field: 'Zip Code'),
                      onSaved: (v) => controller.project.update((x) => x!.zipCode = v!.trim()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonTextField(
                      label: 'Location',
controller: controller.locationController,
                      hint: 'e.g. Location,area',
                      prefixIcon: const Icon(Icons.place_outlined, size: 20,color: ColorRes.primary),
                      initialValue: p.location,
                      validator: (v) => ProjectValidators.requiredText(v, field: 'Location'),
                      onSaved: (v) => controller.project.update((x) => x!.location = v!.trim()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}