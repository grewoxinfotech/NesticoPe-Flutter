import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:intl/intl.dart';

import '../../controller/builder_form_controller.dart';

import '../widget/common_builder_textfield.dart';
import '../widget/validation/validation.dart';

class StepBasicInfo extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;

  const StepBasicInfo({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium;
    return Form(
      key: formKey,
      child: Obx(() {
        final p = controller.project.value;
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CommonTextField(
                label: 'Project Name',
                hint: 'e.g. Sunrise Residency',
                controller: controller.projectNameController,
                prefixIcon: const Icon(
                  Icons.apartment_outlined,
                  size: 20,
                  color: ColorRes.primary,
                ),
                initialValue: p.projectName,
                validator:
                    (v) => ProjectValidators.requiredText(
                      v,
                      field: 'Project Name',
                    ),
                onSaved:
                    (v) => controller.project.update(
                      (x) => x!.projectName = v!.trim(),
                    ),
                borderType: 'outline', // or 'underline', 'none', 'filled'
              ),

              const SizedBox(height: 12),

              CommonTextField(
                label: 'Project Area (sq.ft)',
                controller: controller.projectAreaController,
                hint: 'e.g. 125000',
                suffixText: 'sq.ft',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(
                  Icons.square_foot_outlined,
                  size: 20,
                  color: ColorRes.primary,
                ),
                initialValue:
                    p.projectArea == 0 ? '' : p.projectArea.toString(),
                validator:
                    (v) => ProjectValidators.positiveNumber(
                      num.tryParse(v ?? ''),
                      field: 'Project Area',
                    ),
                onSaved:
                    (v) => controller.project.update(
                      (x) => x!.projectArea = double.tryParse(v ?? '') ?? 0,
                    ),
                borderType: 'outline', // or 'underline', 'none', 'filled'
              ),

              const SizedBox(height: 12),

              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextField(
                            label: 'Total Building',
                            controller: controller.totalBuildingsController,
                            initialValue:
                                p.projectSize.totalBuildings.toString(),
                            keyboardType: TextInputType.number,
                            prefixIcon: Icon(
                              Icons.domain_outlined,
                              size: 20,
                              color: ColorRes.primary,
                            ),
                            textInputAction: TextInputAction.next,
                            /*  onChanged: (v) {
                      controller.generateBuildingFields(v);
                    },*/
                            validator:
                                (v) => ProjectValidators.minNumber(
                                  num.tryParse(v ?? ''),
                                  1,
                                  field: 'Total Buildings',
                                ),
                            onSaved: (v) {
                              controller.generateBuildingFields(v ?? '0');

                              controller.project.update(
                                (x) =>
                                    x!.projectSize.totalBuildings =
                                        int.tryParse(v ?? '') ?? 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextField(
                            label: 'Total Units',
                            controller: controller.totalUnitsController,
                            initialValue: p.projectSize.totalUnits.toString(),
                            keyboardType: TextInputType.number,
                            prefixIcon: Icon(
                              Icons.apartment_rounded,
                              size: 20,
                              color: ColorRes.primary,
                            ),

                            validator:
                                (v) => ProjectValidators.minNumber(
                                  num.tryParse(v ?? ''),
                                  1,
                                  field: 'Total Units',
                                ),
                            onSaved:
                                (v) => controller.project.update(
                                  (x) =>
                                      x!.projectSize.totalUnits =
                                          int.tryParse(v ?? '') ?? 1,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 🆕 Dynamic Building Name Fields (2 per row)
              Obx(() {
                final controllers = controller.buildingNameControllers;

                if (controllers.isEmpty) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Building Names", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: List.generate(controllers.length, (index) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          child: CommonTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Building name is required';
                              }
                              return null;
                            },
                            label: "Building Name #${index + 1}",
                            controller: controllers[index],
                            initialValue:
                                p.buildingNames?['buildingName#$index'],

                            hint:
                                "e.g. Tower ${String.fromCharCode(65 + index)}",
                            prefixIcon: const Icon(
                              Icons.home_work_outlined,
                              size: 18,
                              color: ColorRes.primary,

                            ),
                            borderType: 'outline',
                            onSaved: (v) {
                              controller.saveBuildingNames();
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),

              Obx(() {
                final project = controller.project.value;

                return Row(
                  children: [
                    Expanded(
                      child: _CommonDatePickerField(
                        label: 'Launch Date',
                        date: project.launchDate,
                        onSaved: (pickedDate) {
                          print('Lunched Date: ${p.launchDate}');
                          controller.project.update(
                            (p) => p!.launchDate = pickedDate,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CommonDatePickerField(
                        label: 'Possession Date',
                        date: project.possessionDate,
                        onSaved: (pickedDate) {
                          controller.project.update(
                            (p) => p!.possessionDate = pickedDate,
                          );
                        },
                        extraValidator:
                            (pickedDate) =>
                                ProjectValidators.possessionAfterLaunch(
                                  pickedDate,
                                  project.launchDate,
                                ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 12),
              CommonTextField(
                label: 'RERA ID',
                initialValue: p.reraId,
                textCapitalization: TextCapitalization.characters,
                controller: controller.reraIdController,
                hint: 'e.g. PR/GJ/123456/0000',
                prefixIcon: Icon(
                  Icons.verified_outlined,
                  size: 20,
                  color: ColorRes.primary,
                ),

                validator:
                    (v) => ProjectValidators.requiredText(v, field: 'RERA ID'),
                onSaved:
                    (v) =>
                        controller.project.update((x) => x!.reraId = v!.trim()),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CommonDatePickerField extends StatefulWidget {
  final String label;
  final DateTime date;
  final void Function(DateTime) onSaved;
  final String? Function(DateTime?)? extraValidator;

  const _CommonDatePickerField({
    required this.label,
    required this.date,
    required this.onSaved,
    this.extraValidator,
  });

  @override
  State<_CommonDatePickerField> createState() => _CommonDatePickerFieldState();
}

// class _CommonDatePickerFieldState extends State<_CommonDatePickerField> {
//   late TextEditingController _controller;
//   DateTime? _selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.date;
//     _controller = TextEditingController(
//       text:
//           _selectedDate != null
//               ? _selectedDate.toString().split(' ').first
//               : '',
//     );
//   }
//
//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(now.year - 30),
//       lastDate: DateTime(now.year + 30),
//       initialDate: _selectedDate ?? now,
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _controller.text = picked.toString().split(' ').first;
//         widget.onSaved(_selectedDate!);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _pickDate,
//       child: AbsorbPointer(
//         child: CommonTextField(
//           label: widget.label,
//           prefixIcon: Icon(
//             Icons.calendar_month_outlined,
//             size: 20,
//             color: ColorRes.primary,
//           ),
//           enabled: false,
//           controller: _controller,
//           validator: (_) {
//             if (_selectedDate == null) return 'Required date';
//             if (widget.extraValidator != null)
//               return widget.extraValidator!(_selectedDate);
//             return null;
//           },
//         ),
//       ),
//     );
//   }
// }

class _CommonDatePickerFieldState extends State<_CommonDatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _controller = TextEditingController(
      text:
          _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : '',
    );
  }

  @override
  /*  void didUpdateWidget(covariant _CommonDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date) {
      _selectedDate = widget.date;
      _controller.text =
          _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : '';
    }
  }*/
  @override
  void didUpdateWidget(covariant _CommonDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.date != oldWidget.date) {
      _selectedDate = widget.date;

      // ✅ Delay updating controller until after build is done
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.text =
            _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : '';
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 30),
      initialDate: _selectedDate ?? now,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('yyyy-MM-dd').format(picked);
        widget.onSaved(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: CommonTextField(
          label: widget.label,
          prefixIcon: Icon(
            Icons.calendar_month_outlined,
            size: 20,
            color: ColorRes.primary,
          ),
          enabled: false,
          controller: _controller,
          validator: (_) {
            if (_selectedDate == null) return 'Required date';
            if (widget.extraValidator != null)
              return widget.extraValidator!(_selectedDate);
            return null;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
