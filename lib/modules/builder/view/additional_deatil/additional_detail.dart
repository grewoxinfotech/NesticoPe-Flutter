import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../data/validators/project_validators.dart';
import '../../controller/builder_form_controller.dart';import '../../model/config_model.dart';
import '../widget/validation/validation.dart';

class StepAdditional extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  const StepAdditional({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Obx(() {
        final p = controller.project.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: p.propertyTypes?.isEmpty == true ? null : p.propertyTypes,
              items: const [
                DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                DropdownMenuItem(value: 'house', child: Text('House')),
                DropdownMenuItem(value: 'villa', child: Text('Villa')),
                DropdownMenuItem(value: 'plot', child: Text('Plot')),
                DropdownMenuItem(value: 'office', child: Text('Office')),
                DropdownMenuItem(value: 'shop', child: Text('Shop')),
                DropdownMenuItem(value: 'showroom', child: Text('Showroom')),
                DropdownMenuItem(value: 'warehouse', child: Text('Warehouse')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              decoration: const InputDecoration(labelText: 'Property Type'),
              onChanged: (v) => controller.project.update((x) => x!.propertyTypes = v),
            ),
            DropdownButtonFormField<String>(
              value: p.status,
              items: const [
                DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                DropdownMenuItem(value: 'ongoing', child: Text('Ongoing')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              decoration: const InputDecoration(labelText: 'Status'),
              onChanged: (v) => controller.project.update((x) => x!.status = v ?? 'upcoming'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Amenities (comma separated)'),
              initialValue: p.amenities.join(', '),
              onSaved: (v) => controller.project.update((x) => x!.amenities = (v ?? '').split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Project Highlights (comma separated)'),
              initialValue: p.projectHighlights.join(', '),
              onSaved: (v) => controller.project.update((x) => x!.projectHighlights = (v ?? '').split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()),
            ),
            const SizedBox(height: 12),
            // Brochure / Media placeholder (UI only)
            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar('Info', 'Brochure upload UI-only placeholder');
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Brochure (UI only)'),
            ),
            const SizedBox(height: 12),
            Text('Contact Info'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    initialValue: p.projectContactInfo?.name ?? '',
                    onSaved: (v) {
                      controller.project.update((x) {
                        x!.projectContactInfo ??= ProjectContactInfo();
                        x.projectContactInfo!.name = v?.trim();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone'),
                    initialValue: p.projectContactInfo?.phone ?? '',
                    onSaved: (v) {
                      controller.project.update((x) {
                        x!.projectContactInfo ??= ProjectContactInfo();
                        x.projectContactInfo!.phone = v?.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: p.projectContactInfo?.email ?? '',
              validator: ProjectValidators.email,
              onSaved: (v) {
                controller.project.update((x) {
                  x!.projectContactInfo ??= ProjectContactInfo();
                  x.projectContactInfo!.email = v?.trim();
                });
              },
            ),
          ],
        );
      }),
    );
  }
}