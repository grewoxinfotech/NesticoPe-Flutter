import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../data/validators/project_validators.dart';
import '../../controller/builder_form_controller.dart';
// import '../../controllers/project_wizard_controller.dart';
// import '../../../data/models/project_model.dart';
import '../widget/validation/validation.dart';

class StepConfigurations extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  const StepConfigurations({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Obx(() {
        final p = controller.project.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Text('Configurations'),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: controller.addConfiguration,
                  icon: const Icon(Icons.add),
                  label: const Text('Add BHK'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(p.configurations.length, (ci) {
              final cfg = p.configurations[ci];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('BHK'),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: cfg.bhk.toString(),
                              keyboardType: TextInputType.number,
                              validator: (v) => ProjectValidators.minNumber(num.tryParse(v ?? ''), 1, field: 'BHK'),
                              onSaved: (v) => controller.project.update((x) => x!.configurations[ci].bhk = int.tryParse(v ?? '') ?? 1),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => controller.removeConfiguration(ci),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text('Variants'),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => controller.addVariant(ci),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Variant'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(cfg.variants.length, (vi) {
                        final v = cfg.variants[vi];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.name,
                                        decoration: const InputDecoration(labelText: 'Name'),
                                        validator: (t) => ProjectValidators.requiredText(t, field: 'Variant Name'),
                                        onSaved: (t) => controller.project.update((x) => x!.configurations[ci].variants[vi].name = t!.trim()),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => controller.removeVariant(ci, vi),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.builtUpArea == 0 ? '' : v.builtUpArea.toString(),
                                        decoration: const InputDecoration(labelText: 'Built-up Area'),
                                        keyboardType: TextInputType.number,
                                        validator: (n) => ProjectValidators.positiveNumber(num.tryParse(n ?? ''), field: 'Built-up Area'),
                                        onSaved: (n) => controller.project.update((x) => x!.configurations[ci].variants[vi].builtUpArea = double.tryParse(n ?? '') ?? 0),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.carpetArea == 0 ? '' : v.carpetArea.toString(),
                                        decoration: const InputDecoration(labelText: 'Carpet Area'),
                                        keyboardType: TextInputType.number,
                                        validator: (n) => ProjectValidators.positiveNumber(num.tryParse(n ?? ''), field: 'Carpet Area'),
                                        onSaved: (n) => controller.project.update((x) => x!.configurations[ci].variants[vi].carpetArea = double.tryParse(n ?? '') ?? 0),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.price == 0 ? '' : v.price.toString(),
                                        decoration: const InputDecoration(labelText: 'Price'),
                                        keyboardType: TextInputType.number,
                                        validator: (n) => ProjectValidators.positiveNumber(num.tryParse(n ?? ''), field: 'Price'),
                                        onSaved: (n) => controller.project.update((x) => x!.configurations[ci].variants[vi].price = double.tryParse(n ?? '') ?? 0),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.pricePerSqFt?.toString() ?? '',
                                        decoration: const InputDecoration(labelText: 'Price / Sq.Ft (optional)'),
                                        keyboardType: TextInputType.number,
                                        onSaved: (n) => controller.project.update((x) => x!.configurations[ci].variants[vi].pricePerSqFt = double.tryParse(n ?? '')),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.totalUnits == 0 ? '' : v.totalUnits.toString(),
                                        decoration: const InputDecoration(labelText: 'Total Units'),
                                        keyboardType: TextInputType.number,
                                        validator: (n) => ProjectValidators.minNumber(num.tryParse(n ?? ''), 1, field: 'Total Units'),
                                        onSaved: (n) => controller.project.update((x) => x!.configurations[ci].variants[vi].totalUnits = int.tryParse(n ?? '') ?? 0),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: v.availableUnits == 0 ? '' : v.availableUnits.toString(),
                                        decoration: const InputDecoration(labelText: 'Available Units'),
                                        keyboardType: TextInputType.number,
                                        validator: (n) => ProjectValidators.minNumber(num.tryParse(n ?? ''), 0, field: 'Available Units'),
                                        onSaved: (n) => controller.project.update((x) => x!.configurations[ci].variants[vi].availableUnits = int.tryParse(n ?? '') ?? 0),
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  initialValue: v.specifications.join(', '),
                                  decoration: const InputDecoration(labelText: 'Specifications (comma separated)'),
                                  onSaved: (t) => controller.project.update((x) => x!.configurations[ci].variants[vi].specifications = (t ?? '').split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        );
      }),
    );
  }
}