import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../data/validators/project_validators.dart';
import '../../controller/builder_form_controller.dart';
// import '../../controllers/project_wizard_controller.dart';
import '../widget/validation/validation.dart';

class StepBasicInfo extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  const StepBasicInfo({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall;
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final p = controller.project.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Basic Info', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),

              Text('Project Name', style: labelStyle),
              TextFormField(
                initialValue: p.projectName,
                decoration: const InputDecoration(hintText: 'e.g. Sunrise Residency'),
                validator: (v) => ProjectValidators.requiredText(v, field: 'Project Name'),
                onSaved: (v) => controller.project.update((x) => x!.projectName = v!.trim()),
              ),
              const SizedBox(height: 12),

              Text('Project Area (sq.ft)', style: labelStyle),
              TextFormField(
                initialValue: p.projectArea == 0 ? '' : p.projectArea.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'e.g. 125000'),
                validator: (v) => ProjectValidators.positiveNumber(num.tryParse(v ?? ''), field: 'Project Area'),
                onSaved: (v) => controller.project.update((x) => x!.projectArea = double.tryParse(v ?? '') ?? 0),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Buildings', style: labelStyle),
                        TextFormField(
                          initialValue: p.projectSize.totalBuildings.toString(),
                          keyboardType: TextInputType.number,
                          validator: (v) => ProjectValidators.minNumber(num.tryParse(v ?? ''), 1, field: 'Total Buildings'),
                          onSaved: (v) => controller.project.update((x) => x!.projectSize.totalBuildings = int.tryParse(v ?? '') ?? 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Units', style: labelStyle),
                        TextFormField(
                          initialValue: p.projectSize.totalUnits.toString(),
                          keyboardType: TextInputType.number,
                          validator: (v) => ProjectValidators.minNumber(num.tryParse(v ?? ''), 1, field: 'Total Units'),
                          onSaved: (v) => controller.project.update((x) => x!.projectSize.totalUnits = int.tryParse(v ?? '') ?? 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'Launch Date',
                      date: p.launchDate,
                      onSaved: (d) => controller.project.update((x) => x!.launchDate = d),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateField(
                      label: 'Possession Date',
                      date: p.possessionDate,
                      onSaved: (d) => controller.project.update((x) => x!.possessionDate = d),
                      extraValidator: (d) => ProjectValidators.possessionAfterLaunch(d, p.launchDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text('RERA ID', style: labelStyle),
              TextFormField(
                initialValue: p.reraId,
                validator: (v) => ProjectValidators.requiredText(v, field: 'RERA ID'),
                onSaved: (v) => controller.project.update((x) => x!.reraId = v!.trim()),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DateField extends StatefulWidget {
  final String label;
  final DateTime date;
  final void Function(DateTime) onSaved;
  final String? Function(DateTime?)? extraValidator;

  const _DateField({
    required this.label,
    required this.date,
    required this.onSaved,
    this.extraValidator,
  });

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: (v) {
        final base = v == null ? 'તારીખ જરૂરી છે' : null;
        if (base != null) return base;
        if (widget.extraValidator != null) return widget.extraValidator!(v);
        return null;
      },
      initialValue: _value,
      onSaved: (v) {
        if (v != null) widget.onSaved(v);
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label),
            const SizedBox(height: 6),
            InkWell(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 30),
                  lastDate: DateTime(now.year + 30),
                  initialDate: state.value ?? now,
                );
                if (picked != null) {
                  state.didChange(picked);
                  setState(() => _value = picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: state.errorText,
                  hintText: 'Select date',
                ),
                child: Text(
                  (state.value ?? widget.date).toLocal().toString().split(' ').first,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}