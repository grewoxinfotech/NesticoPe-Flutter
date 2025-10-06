import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/builder_form_controller.dart';
// import '../../controllers/project_wizard_controller.dart';

class StepReview extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  const StepReview({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Obx(() {
        final p = controller.project.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Review your details'),
            const SizedBox(height: 8),
            _kv('Project Name', p.projectName),
            _kv('Area', '${p.projectArea}'),
            _kv('Buildings', '${p.projectSize.totalBuildings}'),
            _kv('Units', '${p.projectSize.totalUnits}'),
            _kv('Launch', p.launchDate.toLocal().toString().split(' ').first),
            _kv('Possession', p.possessionDate.toLocal().toString().split(' ').first),
            _kv('RERA', p.reraId),
            const Divider(),
            const Text('Configurations:'),
            ...p.configurations.map((c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${c.bhk} BHK - ${c.variants.length} variants'),
            )),
            const Divider(),
            _kv('Address', p.address),
            _kv('City/State', '${p.city}, ${p.state}'),
            _kv('Zip', p.zipCode),
            _kv('Location', p.location),
            const Divider(),
            _kv('Property Type', p.propertyTypes ?? ''),
            _kv('Status', p.status),
            _kv('Amenities', p.amenities.join(', ')),
            _kv('Highlights', p.projectHighlights.join(', ')),
            _kv('Contact', '${p.projectContactInfo?.name ?? ''} | ${p.projectContactInfo?.phone ?? ''} | ${p.projectContactInfo?.email ?? ''}'),
          ],
        );
      }),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(v)),
        ],
      ),
    );
  }
}