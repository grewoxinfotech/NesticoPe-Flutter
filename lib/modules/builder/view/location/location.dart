import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../data/validators/project_validators.dart';
import '../../controller/builder_form_controller.dart';
// import '../../controllers/project_wizard_controller.dart';
import '../widget/validation/validation.dart';

class StepLocation extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  const StepLocation({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Obx(() {
        final p = controller.project.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              initialValue: p.address,
              validator: (v) => ProjectValidators.requiredText(v, field: 'Address'),
              onSaved: (v) => controller.project.update((x) => x!.address = v!.trim()),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'City'),
                    initialValue: p.city,
                    validator: (v) => ProjectValidators.requiredText(v, field: 'City'),
                    onSaved: (v) => controller.project.update((x) => x!.city = v!.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'State'),
                    initialValue: p.state,
                    validator: (v) => ProjectValidators.requiredText(v, field: 'State'),
                    onSaved: (v) => controller.project.update((x) => x!.state = v!.trim()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Zip Code'),
                    initialValue: p.zipCode,
                    validator: (v) => ProjectValidators.requiredText(v, field: 'Zip Code'),
                    onSaved: (v) => controller.project.update((x) => x!.zipCode = v!.trim()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    initialValue: p.location,
                    validator: (v) => ProjectValidators.requiredText(v, field: 'Location'),
                    onSaved: (v) => controller.project.update((x) => x!.location = v!.trim()),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}