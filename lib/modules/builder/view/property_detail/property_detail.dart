import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/saved_property/views/saved_property_screen.dart';

// import '../../../data/validators/project_validators.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../controller/builder_form_controller.dart';


// import '../../controllers/project_wizard_controller.dart';
// import '../../../data/models/project_model.dart';
import '../widget/common_builder_textfield.dart';
import '../widget/validation/validation.dart';

class StepConfigurations extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;

  const StepConfigurations({super.key, required this.formKey});

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
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.tune_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Configurations',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: ColorRes.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: controller.addConfiguration,
                      icon: const Icon(Icons.add_rounded, size: 20,color: ColorRes.white,),
                      label: const Text(
                        'Add BHK',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: ColorRes.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...List.generate(p.configurations.length, (ci) {
                final cfg = p.configurations[ci];
                return Column(
                  children: [
                    SizedBox(height: 8),
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: ColorRes.grey.withOpacity(0.15),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            // Header Section
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.02),
                                    theme.colorScheme.primary.withOpacity(0.03),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                    color: ColorRes.grey.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.apartment_rounded,
                                    size: 20,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'BHK Configuration',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: FontWeight.w600,
                                      color: ColorRes.textPrimary,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => controller.removeConfiguration(ci),
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 20,
                                    ),
                                    color: ColorRes.error.shade600,
                                    tooltip: 'Remove Configuration',
                                    style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(8),
                                      minimumSize: const Size(36, 36),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // BHK Input Field
                                  CommonTextField(
                                    label: 'BHK Type',
                                    initialValue: cfg.bhk.toString(),
                                    hint: 'e.g., 5 BHK',
                                    keyboardType: TextInputType.number,
                                    validator: (v) => ProjectValidators.minNumber(
                                      num.tryParse(v ?? ''),
                                      1,
                                      field: 'BHK',
                                    ),
                                    onSaved: (v) => controller.project.update(
                                          (x) => x!.configurations[ci].bhk =
                                          int.tryParse(v ?? '') ?? 1,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Divider with subtle design
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          ColorRes.transparentColor,
                                          ColorRes.grey.withOpacity(0.3),
                                          ColorRes.grey.withOpacity(0.3),
                                          ColorRes.grey.withOpacity(0.3),
                                          ColorRes.transparentColor,
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Variants Section
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.layers_outlined,
                                        size: 18,
                                        color: ColorRes.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Variants ${cfg.variants.length}',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.bodySmall,
                                          fontWeight: FontWeight.w600,
                                          color: ColorRes.textPrimary,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const Spacer(),
                                      FilledButton.tonalIcon(
                                        onPressed: () => controller.addVariant(ci),
                                        icon: const Icon(Icons.add_rounded, size: 20,color: ColorRes.white,),
                                        label: const Text(
                                          'Add Variant',
                                          style: TextStyle(

                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: ColorRes.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(cfg.variants.length, (vi) {
                      final v = cfg.variants[vi];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: ColorRes.grey.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(0.02),
                                      theme.colorScheme.primary.withOpacity(0.03),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorRes.grey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.layers_outlined,
                                      size: 20,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Variant ${vi+1}',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: FontWeight.w600,
                                        color: ColorRes.textPrimary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () => controller.removeVariant(ci, vi),
                                    child: Text('Remove',style: TextStyle(color: ColorRes.redAccentColor,fontSize: 12),),

                                      // color: Colors.red.shade600,
                                      // tooltip: 'Remove Configuration',
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(8),
                                        minimumSize: const Size(36, 36),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                              child: Column(
                                children: [
                                  CommonTextField(
                                    label: 'Name',
                                    hint: 'Variant Name',
                                    prefixIcon: const Icon(
                                      Icons.badge_outlined,
                                      size: 16,
                                    ),
                                    initialValue: v.name,
                                    validator:
                                        (t) => ProjectValidators.requiredText(
                                      t,
                                      field: 'Variant Name',
                                    ),
                                    onSaved:
                                        (t) => controller.project.update(
                                          (x) =>
                                      x!
                                          .configurations[ci]
                                          .variants[vi]
                                          .name = t!.trim(),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CommonTextField(
                                          label: 'Built-up Area',
                                          hint: 'e.g sqft',
                                          prefixIcon: const Icon(
                                            Icons.aspect_ratio_outlined,
                                            size: 16,
                                          ),
                                          suffixText: 'sq.ft',
                                          initialValue:
                                          v.builtUpArea == 0
                                              ? ''
                                              : v.builtUpArea.toString(),
                                          keyboardType: TextInputType.number,
                                          validator:
                                              (n) =>
                                              ProjectValidators.positiveNumber(
                                                num.tryParse(n ?? ''),
                                                field: 'Built-up Area',
                                              ),
                                          onSaved:
                                              (n) => controller.project.update(
                                                (x) =>
                                            x!
                                                .configurations[ci]
                                                .variants[vi]
                                                .builtUpArea =
                                                double.tryParse(n ?? '') ??
                                                    0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: CommonTextField(
                                          label: 'Carpet Area',
                                          hint: 'e.g sqft',
                                          prefixIcon: const Icon(
                                            Icons.straighten,
                                            size: 16,
                                          ),
                                          suffixText: 'sq.ft',
                                          initialValue:
                                          v.carpetArea == 0
                                              ? ''
                                              : v.carpetArea.toString(),
                                          keyboardType: TextInputType.number,
                                          validator:
                                              (n) =>
                                              ProjectValidators.positiveNumber(
                                                num.tryParse(n ?? ''),
                                                field: 'Carpet Area',
                                              ),
                                          onSaved:
                                              (n) => controller.project.update(
                                                (x) =>
                                            x!
                                                .configurations[ci]
                                                .variants[vi]
                                                .carpetArea =
                                                double.tryParse(n ?? '') ??
                                                    0,
                                          ),
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
                                          label: 'Price',
                                          hint: '2.5 L',
                                          prefixIcon: const Icon(
                                            Icons.currency_rupee_outlined,
                                            size: 16,
                                          ),
                                          initialValue:
                                          v.price == 0
                                              ? ''
                                              : v.price.toString(),
                                          keyboardType: TextInputType.number,
                                          validator:
                                              (n) =>
                                              ProjectValidators.positiveNumber(
                                                num.tryParse(n ?? ''),
                                                field: 'Price',
                                              ),
                                          onSaved:
                                              (n) => controller.project.update(
                                                (x) =>
                                            x!
                                                .configurations[ci]
                                                .variants[vi]
                                                .price =
                                                double.tryParse(n ?? '') ??
                                                    0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: CommonTextField(
                                          hint: 'e.g 2.4 per sq.ft',
                                          label: 'Price / Sq.Ft (optional)',
                                          prefixIcon: const Icon(
                                            Icons.price_change_outlined,
                                            size: 16,
                                          ),
                                          initialValue:
                                          v.pricePerSqFt?.toString() ?? '',
                                          keyboardType: TextInputType.number,
                                          onSaved:
                                              (n) => controller.project.update(
                                                (x) =>
                                            x!
                                                .configurations[ci]
                                                .variants[vi]
                                                .pricePerSqFt =
                                                double.tryParse(n ?? ''),
                                          ),
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
                                          label: 'Total Units',

                                          hint: 'e.g 2500',
                                          prefixIcon: const Icon(
                                            Icons.numbers_outlined,
                                            size: 16,
                                          ),
                                          initialValue:
                                          v.totalUnits == 0
                                              ? ''
                                              : v.totalUnits.toString(),
                                          keyboardType: TextInputType.number,
                                          validator:
                                              (n) => ProjectValidators.minNumber(
                                            num.tryParse(n ?? ''),
                                            1,
                                            field: 'Total Units',
                                          ),
                                          onSaved:
                                              (n) => controller.project.update(
                                                (x) =>
                                            x!
                                                .configurations[ci]
                                                .variants[vi]
                                                .totalUnits =
                                                int.tryParse(n ?? '') ?? 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: CommonTextField(
                                          hint: 'e.g 2500',
                                          label: 'Available Units',
                                          prefixIcon: const Icon(
                                            Icons.inventory_2_outlined,
                                            size: 16,
                                          ),
                                          initialValue:
                                          v.availableUnits == 0
                                              ? ''
                                              : v.availableUnits.toString(),
                                          keyboardType: TextInputType.number,
                                          validator:
                                              (n) => ProjectValidators.minNumber(
                                            num.tryParse(n ?? ''),
                                            0,
                                            field: 'Available Units',
                                          ),
                                          onSaved:
                                              (n) => controller.project.update(
                                                (x) =>
                                            x!
                                                .configurations[ci]
                                                .variants[vi]
                                                .availableUnits =
                                                int.tryParse(n ?? '') ?? 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  CommonTextField(
                                    label: 'Specifications (comma separated)',

                                    hint: 'e.g Security,water supply',
                                    prefixIcon: const Icon(
                                      Icons.list_alt_outlined,
                                      size: 16,
                                    ),
                                    initialValue: v.specifications.join(', '),
                                    onSaved:
                                        (t) => controller.project.update(
                                          (x) =>
                                      x!
                                          .configurations[ci]
                                          .variants[vi]
                                          .specifications = (t ?? '')
                                          .split(',')
                                          .map((e) => e.trim())
                                          .where((e) => e.isNotEmpty)
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
