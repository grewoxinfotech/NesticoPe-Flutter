import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/builder/view/property_detail/widget/variation_media_upload_widget.dart';
import 'package:housing_flutter_app/modules/saved_property/views/saved_property_screen.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// import '../../../data/validators/project_validators.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../controller/builder_form_controller.dart';

// import '../../controllers/project_wizard_controller.dart';
// import '../../../data/models/project_model.dart';
import '../media/upload_media_screen.dart';
import '../widget/common_builder_textfield.dart';
import '../widget/validation/validation.dart';

class StepConfigurations extends GetView<ProjectWizardController> {
  final GlobalKey<FormState> formKey;
  final bool isFromEdit;

  const StepConfigurations({
    super.key,
    required this.formKey,
    this.isFromEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final p = controller.project.value;
      log("Logger of Total Unit ${controller.totalUnitsController.text}");
      log("Logger of Total Unit ${p.projectSize.totalUnits}");
      return Form(
        key: formKey,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorRes.primary.withOpacity(0.2),
                    width: 1.2,
                  ),
                ),
                child: Builder(
                  builder: (_) {
                    final totalUnits = p.projectSize.totalUnits ?? 0;
                    final usedUnits = p.configurations
                        .expand((cfg) => cfg.variants)
                        .fold<int>(0, (sum, v) => sum + (v.totalUnits ?? 0));
                    final remainingUnits = totalUnits - usedUnits;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.domain_outlined,
                              size: 22,
                              color: ColorRes.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Total Units:',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodySmall,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$totalUnits',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.bold,
                                color: ColorRes.primary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                remainingUnits > 0
                                    ? ColorRes.green.withOpacity(0.1)
                                    : ColorRes.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  remainingUnits > 0
                                      ? ColorRes.green.withOpacity(0.3)
                                      : ColorRes.error.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                remainingUnits > 0
                                    ? Icons.hourglass_bottom_rounded
                                    : Icons.check_circle_outline_rounded,
                                size: 16,
                                color:
                                    remainingUnits > 0
                                        ? ColorRes.green
                                        : ColorRes.error,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                remainingUnits > 0
                                    ? 'Pending: $remainingUnits'
                                    : 'All Assigned',
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                  color:
                                      remainingUnits > 0
                                          ? ColorRes.green
                                          : ColorRes.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

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
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: controller.addConfiguration,
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: ColorRes.white,
                      ),
                      label: Text(
                        'Add BHK',
                        style: TextStyle(
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: AppFontSizes.medium,
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
                AppLogger("Configuration Logical Bug", cfg.toJson());

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
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.textPrimary,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed:
                                        () =>
                                            controller.removeConfiguration(ci),
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 20,
                                    ),
                                    color: ColorRes.error.shade600,
                                    tooltip: 'Remove Configuration',
                                    style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(8),
                                      minimumSize: const Size(36, 36),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // BHK Input Field
                                  CommonTextField(
                                    label: 'BHK Type',
                                    initialValue: cfg.bhk.toString(),
                                    hint: 'e.g., 5 BHK',
                                    keyboardType: TextInputType.number,
                                    validator:
                                        (v) => ProjectValidators.minNumber(
                                          num.tryParse(v ?? ''),
                                          1,
                                          field: 'BHK',
                                        ),
                                    onSaved:
                                        (v) => controller.project.update(
                                          (x) =>
                                              x!.configurations[ci].bhk =
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
                                          fontWeight: AppFontWeights.semiBold,
                                          color: ColorRes.textPrimary,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const Spacer(),
                                      FilledButton.tonalIcon(
                                        onPressed:
                                            () => controller.addVariant(ci),
                                        icon: const Icon(
                                          Icons.add_rounded,
                                          size: 20,
                                          color: ColorRes.white,
                                        ),
                                        label: Text(
                                          'Add Variant',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.medium,
                                            fontWeight: AppFontWeights.semiBold,
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                      theme.colorScheme.primary.withOpacity(
                                        0.02,
                                      ),
                                      theme.colorScheme.primary.withOpacity(
                                        0.03,
                                      ),
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
                                      'Variant ${vi + 1}',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.textPrimary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed:
                                          () =>
                                              controller.removeVariant(ci, vi),

                                      // color: Colors.red.shade600,
                                      // tooltip: 'Remove Configuration',
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(8),
                                        minimumSize: const Size(36, 36),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(
                                          color: ColorRes.redAccentColor,
                                          fontSize: AppFontSizes.small,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .builtUpArea =
                                                          double.tryParse(
                                                            n ?? '',
                                                          ) ??
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
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .carpetArea =
                                                          double.tryParse(
                                                            n ?? '',
                                                          ) ??
                                                          0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            /*   validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter monthly rent';
                                              }

                                              final rent =
                                                  int.tryParse(value) ?? 0;

                                              if (rent > 0) {
                                                final platformFee = rent * 0.05;
                                                final brokerCommission =
                                                    platformFee * 0.02;

                                                v.platformFees =
                                                    double.tryParse(
                                                      platformFee
                                                          .toStringAsFixed(2),
                                                    );
                                                v.brokerCommission =
                                                    double.tryParse(
                                                      brokerCommission
                                                          .toStringAsFixed(2),
                                                    );

                                                // ✅ Add these lines to update the text fields
                                                controller
                                                    .platformFees
                                                    .text = platformFee
                                                    .toStringAsFixed(2);
                                                controller
                                                    .brokerRageCommission
                                                    .text = brokerCommission
                                                    .toStringAsFixed(2);

                                                log(
                                                  'Platform Fees: ${v.platformFees}, Broker Commission: ${v.brokerCommission}',
                                                );
                                                return null;
                                              }

                                              return null;
                                            },*/
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter monthly rent';
                                              }

                                              final rent =
                                                  int.tryParse(value) ?? 0;

                                              if (rent > 0) {
                                                final platformFee = rent * 0.05;
                                                final brokerCommission =
                                                    platformFee * 0.02;

                                                v.platformFees =
                                                    double.tryParse(
                                                      platformFee
                                                          .toStringAsFixed(2),
                                                    );
                                                v.brokerCommission =
                                                    double.tryParse(
                                                      brokerCommission
                                                          .toStringAsFixed(2),
                                                    );

                                                // 🔒 Schedule controller update AFTER build phase
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                      controller
                                                          .platformFees
                                                          .text = platformFee
                                                          .toStringAsFixed(2);
                                                      controller
                                                          .brokerRageCommission
                                                          .text = brokerCommission
                                                          .toStringAsFixed(2);
                                                    });

                                                return null;
                                              }

                                              return null;
                                            },

                                            onSaved:
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .price =
                                                          double.tryParse(
                                                            n ?? '',
                                                          ) ??
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
                                                v.pricePerSqFt?.toString() ??
                                                '',
                                            keyboardType: TextInputType.number,
                                            onSaved:
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .pricePerSqFt =
                                                          double.tryParse(
                                                            n ?? '',
                                                          ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CommonTextField(
                                            label:
                                                'Platform Fees (5% of Price)',
                                            controller: controller.platformFees,
                                            hint: 'Platform Fees',
                                            prefixIcon: const Icon(
                                              Icons.aspect_ratio_outlined,
                                              size: 16,
                                            ),

                                            // initialValue:
                                            //     v.platformFees == 0
                                            //         ? ''
                                            //         : v.platformFees.toString(),
                                            keyboardType: TextInputType.number,
                                            validator:
                                                (n) =>
                                                    ProjectValidators.positiveNumber(
                                                      num.tryParse(n ?? ''),
                                                      field: 'Platform fees',
                                                    ),
                                            onSaved:
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .platformFees =
                                                          double.tryParse(
                                                            n ?? '',
                                                          ) ??
                                                          0,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: CommonTextField(
                                            label:
                                                'Broker Commission (2% of Platform  Fees)',
                                            hint: 'Broker Commission',
                                            controller:
                                                controller.brokerRageCommission,
                                            prefixIcon: const Icon(
                                              Icons.straighten,
                                              size: 16,
                                            ),
                                            // initialValue:
                                            //     v.brokerCommission == 0
                                            //         ? ''
                                            //         : v.brokerCommission.toString(),
                                            keyboardType: TextInputType.number,
                                            validator:
                                                (n) =>
                                                    ProjectValidators.positiveNumber(
                                                      num.tryParse(n ?? ''),
                                                      field:
                                                          'Broker Commission',
                                                    ),
                                            onSaved:
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .brokerCommission =
                                                          double.tryParse(
                                                            n ?? '',
                                                          ) ??
                                                          0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            /*  validator:
                                                (n) =>
                                                    ProjectValidators.minNumber(
                                                      num.tryParse(n ?? ''),
                                                      1,
                                                      field: 'Total Units',
                                                    ),*/
                                            validator: (n) {
                                              final entered =
                                                  int.tryParse(n ?? '') ?? 0;
                                              final config =
                                                  p.configurations[ci]; // Current BHK configuration
                                              final projectTotalUnits =
                                                  p.projectSize.totalUnits ?? 0;

                                              // Sum total units from all other variants
                                              final otherUnits = config.variants
                                                  .asMap()
                                                  .entries
                                                  .where(
                                                    (entry) => entry.key != vi,
                                                  )
                                                  .map(
                                                    (entry) =>
                                                        entry
                                                            .value
                                                            .totalUnits ??
                                                        0,
                                                  )
                                                  .fold<int>(
                                                    0,
                                                    (sum, val) => sum + val,
                                                  );

                                              // Remaining units available for this variant
                                              final remaining =
                                                  projectTotalUnits -
                                                  otherUnits;

                                              if (entered <= 0) {
                                                return 'Please enter a valid number of units';
                                              }

                                              if (entered > remaining) {
                                                return '⚠️ Only $remaining units are available (Total $projectTotalUnits)';
                                              }

                                              return null;
                                            },

                                            onSaved:
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .totalUnits =
                                                          int.tryParse(
                                                            n ?? '',
                                                          ) ??
                                                          0,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                       /* Expanded(
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
                                                    : v.availableUnits
                                                        .toString(),
                                            keyboardType: TextInputType.number,
                                            validator:
                                                (n) =>
                                                    ProjectValidators.minNumber(
                                                      num.tryParse(n ?? ''),
                                                      0,
                                                      field: 'Available Units',
                                                    ),
                                            onSaved:
                                                (
                                                  n,
                                                ) => controller.project.update(
                                                  (x) =>
                                                      x!
                                                              .configurations[ci]
                                                              .variants[vi]
                                                              .availableUnits =
                                                          int.tryParse(
                                                            n ?? '',
                                                          ) ??
                                                          0,
                                                ),
                                          ),
                                        ),*/
                                        Expanded(
                                          child: CommonTextField(
                                            hint: 'e.g 2500',
                                            label: 'Available Units',
                                            prefixIcon: const Icon(
                                              Icons.inventory_2_outlined,
                                              size: 16,
                                            ),
                                            initialValue: v.availableUnits == 0 ? '' : v.availableUnits.toString(),
                                            keyboardType: TextInputType.number,
                                            validator: (n) {
                                              final available = int.tryParse(n ?? '') ?? 0;
                                              final totalUnits = v.totalUnits ?? 0;

                                              if (available < 0) {
                                                return 'Available units cannot be negative';
                                              }

                                              if (available > totalUnits) {
                                                return '⚠️ Cannot exceed total units ($totalUnits)';
                                              }

                                              return null;
                                            },
                                            onSaved: (n) => controller.project.update(
                                                  (x) => x!.configurations[ci].variants[vi].availableUnits =
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
                                                        .where(
                                                          (e) => e.isNotEmpty,
                                                        )
                                                        .toList(),
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (isFromEdit) ...[
                                      VariantMediaUploadWidget(
                                        projectId: p.id ?? '',
                                        variantId: v.variantId ?? '',
                                        variant: v,
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
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

// class VariantMediaUploadWidget extends StatefulWidget {
//   final String projectId;
//   final String variantId;
//
//   const VariantMediaUploadWidget({
//     super.key,
//     required this.projectId,
//     required this.variantId,
//   });
//
//   @override
//   State<VariantMediaUploadWidget> createState() =>
//       _VariantMediaUploadWidgetState();
// }
//
// class _VariantMediaUploadWidgetState extends State<VariantMediaUploadWidget> {
//   final ImagePicker _picker = ImagePicker();
//   List<File> _images = [];
//   List<File> _videos = [];
//   bool _isUploading = false;
//
//   Future<void> _pickImages() async {
//     final List<XFile>? pickedFiles = await _picker.pickMultiImage(
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 80,
//     );
//
//     if (pickedFiles != null) {
//       setState(() {
//         _images.addAll(pickedFiles.map((x) => File(x.path)));
//         if (_images.length > 5) _images = _images.sublist(0, 5);
//       });
//     }
//   }
//
//   Future<void> _pickVideo() async {
//     final XFile? pickedFile = await _picker.pickVideo(
//       source: ImageSource.gallery,
//     );
//
//     if (pickedFile != null) {
//       setState(() {
//         _videos.add(File(pickedFile.path));
//         if (_videos.length > 3) _videos = _videos.sublist(0, 3);
//       });
//     }
//   }
//
//   Future<void> _uploadMedia() async {
//     setState(() => _isUploading = true);
//     try {
//       final uri = Uri.parse(
//         'https://your-backend.com/${widget.projectId}/${widget.variantId}/media',
//       );
//
//       var request = http.MultipartRequest('POST', uri);
//
//       for (var image in _images) {
//         request.files.add(
//           await http.MultipartFile.fromPath('variant_images', image.path),
//         );
//       }
//
//       for (var video in _videos) {
//         request.files.add(
//           await http.MultipartFile.fromPath('variant_videos', video.path),
//         );
//       }
//
//       request.headers.addAll({'Authorization': 'Bearer YOUR_TOKEN'});
//
//       final response = await request.send();
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Upload successful!')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Upload failed: ${response.statusCode}')),
//         );
//       }
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }
//
//   Widget _buildMediaPreview(List<File> files, {bool isVideo = false}) {
//     if (files.isEmpty) {
//       return Container(
//         height: 120,
//         decoration: BoxDecoration(
//           color: Colors.grey[50],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isVideo
//                   ? Icons.video_library_outlined
//                   : Icons.photo_library_outlined,
//               size: 32,
//               color: Colors.grey[400],
//             ),
//             SizedBox(height: 8),
//             Text(
//               'No ${isVideo ? 'videos' : 'images'} selected',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               isVideo ? 'Add up to 3 videos' : 'Add up to 5 images',
//               style: TextStyle(color: Colors.grey[400], fontSize: 12),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Container(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: files.length,
//         itemBuilder: (context, index) {
//           return Hero(
//             tag: files[index].path,
//             child: Material(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 120,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey[200]!),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey[200]!,
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       clipBehavior: Clip.antiAlias,
//                       child: Stack(
//                         children: [
//                           isVideo
//                               ? Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   Container(
//                                     color: Colors.black87,
//                                     child: Image.asset(
//                                       'assets/images/video_placeholder.jpg',
//                                       fit: BoxFit.cover,
//                                       width: 120,
//                                       height: 120,
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.9),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.play_arrow_rounded,
//                                       color: Theme.of(context).primaryColor,
//                                       size: 24,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                               : InkWell(
//                                 onTap: () {
//                                   // Preview image in full screen
//                                   showDialog(
//                                     context: context,
//                                     builder:
//                                         (context) => Dialog(
//                                           child: Stack(
//                                             children: [
//                                               InteractiveViewer(
//                                                 child: Image.file(
//                                                   files[index],
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 8,
//                                                 right: 8,
//                                                 child: IconButton(
//                                                   onPressed:
//                                                       () => Navigator.pop(
//                                                         context,
//                                                       ),
//                                                   icon: Icon(Icons.close),
//                                                   color: Colors.white,
//                                                   style: IconButton.styleFrom(
//                                                     backgroundColor:
//                                                         Colors.black54,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                   );
//                                 },
//                                 child: Image.file(
//                                   files[index],
//                                   fit: BoxFit.cover,
//                                   width: 120,
//                                   height: 120,
//                                 ),
//                               ),
//                           Positioned(
//                             bottom: 4,
//                             right: 4,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.black54,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 '${index + 1}/${files.length}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: Container(
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                           color: Colors.black54,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 if (isVideo) {
//                                   _videos.removeAt(index);
//                                 } else {
//                                   _images.removeAt(index);
//                                 }
//                               });
//                             },
//                             child: Center(
//                               child: Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey[200]!),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.perm_media_rounded,
//                   size: 24,
//                   color: theme.primaryColor,
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Media Upload',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Icon(
//                   Icons.photo_library_outlined,
//                   size: 20,
//                   color: Colors.grey[600],
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   'Images',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: theme.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${_images.length}/5',
//                     style: TextStyle(
//                       color: theme.primaryColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             _buildMediaPreview(_images),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Icon(
//                   Icons.video_library_outlined,
//                   size: 20,
//                   color: Colors.grey[600],
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   'Videos',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: theme.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${_videos.length}/3',
//                     style: TextStyle(
//                       color: theme.primaryColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             _buildMediaPreview(_videos, isVideo: true),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _images.length >= 5 ? null : _pickImages,
//                     icon: Icon(Icons.add_rounded),
//                     label: Text('Images'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme.primaryColor.withOpacity(0.1),
//                       foregroundColor: theme.primaryColor,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         side: BorderSide(
//                           color:
//                               _images.length >= 5
//                                   ? Colors.grey[300]!
//                                   : theme.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _videos.length >= 3 ? null : _pickVideo,
//                     icon: Icon(Icons.add_rounded),
//                     label: Text('Video'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme.primaryColor.withOpacity(0.1),
//                       foregroundColor: theme.primaryColor,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         side: BorderSide(
//                           color:
//                               _videos.length >= 3
//                                   ? Colors.grey[300]!
//                                   : theme.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (_images.isNotEmpty || _videos.isNotEmpty) ...[
//               SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: AnimatedSwitcher(
//                   duration: Duration(milliseconds: 300),
//                   child: ElevatedButton(
//                     onPressed:
//                         _isUploading
//                             ? null
//                             : () async {
//                               showMediaPickerBottomSheet(
//                                 context,
//                                 maxImages: 5,
//                                 maxVideos: 3,
//                                 onSelected: (images, videos) {
//                                   setState(() {
//                                     _images = images;
//                                     _videos = videos;
//                                   });
//                                 },
//                               ).then((_) async {
//                                 await _uploadMedia();
//                               });
//                             },
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       backgroundColor: theme.primaryColor,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child:
//                         _isUploading
//                             ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 12),
//                                 Text(
//                                   'Uploading...',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             )
//                             : Text(
//                               'Upload Media',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//     // return NesticoPeButton(
//     //   width: double.infinity,
//     //   boxShadow: [],
//     //   title: "+Upload Media",
//     //   onTap: () {
//     //     showMediaPickerBottomSheet(
//     //       context,
//     //       maxImages: 5,
//     //       maxVideos: 3,
//     //       onSelected: (images, videos) {
//     //         setState(() {
//     //           _images = images;
//     //           _videos = videos;
//     //         });
//     //       },
//     //     );
//     //   },
//     // );
//   }
// }
//
// Future<void> showMediaPickerBottomSheet(
//   BuildContext context, {
//   required Function(List<File> images, List<File> videos) onSelected,
//   int maxImages = 5,
//   int maxVideos = 3,
// }) async {
//   final ImagePicker picker = ImagePicker();
//   List<File> selectedImages = [];
//   List<File> selectedVideos = [];
//
//   await showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     isScrollControlled: true,
//     builder: (ctx) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           Future<void> pickImages() async {
//             if (selectedImages.length >= maxImages) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('You can select up to $maxImages images only'),
//                 ),
//               );
//               return;
//             }
//
//             final pickedFiles = await picker.pickMultiImage();
//             if (pickedFiles != null) {
//               final newImages = pickedFiles.map((e) => File(e.path)).toList();
//               setState(() {
//                 selectedImages.addAll(
//                   newImages.take(maxImages - selectedImages.length),
//                 );
//               });
//             }
//           }
//
//           Future<void> pickVideos() async {
//             if (selectedVideos.length >= maxVideos) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('You can select up to $maxVideos videos only'),
//                 ),
//               );
//               return;
//             }
//
//             final pickedFile = await picker.pickVideo(
//               source: ImageSource.gallery,
//             );
//             if (pickedFile != null) {
//               setState(() {
//                 selectedVideos.add(File(pickedFile.path));
//               });
//             }
//           }
//
//           void removeFile(List<File> list, int index) {
//             setState(() => list.removeAt(index));
//           }
//
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//               left: 16,
//               right: 16,
//               top: 20,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 50,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Upload Media',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 _MediaSection(
//                   title: 'Images',
//                   icon: Icons.image,
//                   onPick: pickImages,
//                   files: selectedImages,
//                   onRemove: (index) => removeFile(selectedImages, index),
//                   color: ColorRes.primary.withOpacity(0.1),
//                   maxCount: maxImages,
//                 ),
//                 const SizedBox(height: 20),
//
//                 _MediaSection(
//                   title: 'Videos',
//                   isVideo: true,
//                   icon: Icons.videocam,
//                   onPick: pickVideos,
//                   files: selectedVideos,
//                   onRemove: (index) => removeFile(selectedVideos, index),
//                   color: ColorRes.primary.withOpacity(0.1),
//                   maxCount: maxVideos,
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // FIX APPLIED HERE
//                 ElevatedButton(
//                   onPressed: () {
//                     onSelected(selectedImages, selectedVideos);
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 48),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text('Done'),
//                 ),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
//
// class _MediaSection extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final bool isVideo;
//   final List<File> files;
//   final VoidCallback onPick;
//   final Function(int) onRemove;
//   final Color color;
//   final int maxCount;
//
//   const _MediaSection({
//     required this.title,
//     required this.icon,
//     required this.files,
//     required this.onPick,
//     required this.onRemove,
//     required this.color,
//     required this.maxCount,
//     this.isVideo = false,
//   });
//
//   // ✅ Generate video thumbnail
//   Future<String?> generateVideoThumbnail(String videoPath) async {
//     try {
//       final thumbPath = await VideoThumbnail.thumbnailFile(
//         video: videoPath,
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 90,
//         quality: 75,
//       );
//       return thumbPath;
//     } catch (e) {
//       debugPrint('❌ Error generating thumbnail: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ---------- Header Row ----------
//         Row(
//           children: [
//             Icon(icon, color: Colors.black87),
//             const SizedBox(width: 8),
//             Text(
//               '$title (${files.length}/$maxCount)',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const Spacer(),
//             TextButton.icon(
//               onPressed: onPick,
//               icon: const Icon(Icons.add),
//               label: const Text('Add'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//
//         // ---------- Empty Placeholder ----------
//         if (files.isEmpty)
//           Container(
//             height: 120,
//             width: double.infinity,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color, width: 1.2),
//             ),
//             child: Text(
//               'No $title selected',
//               style: const TextStyle(color: Colors.black54),
//             ),
//           )
//         // ---------- Media Preview List ----------
//         else
//           SizedBox(
//             height: 100,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: files.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 10),
//               itemBuilder: (_, index) {
//                 final filePath = files[index].path;
//                 final isNetwork = Uri.tryParse(filePath)?.isAbsolute ?? false;
//
//                 return Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     // ---------- Thumbnail Preview ----------
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: SizedBox(
//                         width: 100,
//                         height: 100,
//                         child:
//                             isVideo
//                                 ? FutureBuilder<String?>(
//                                   future: generateVideoThumbnail(filePath),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const Center(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                         ),
//                                       );
//                                     }
//
//                                     final thumbPath = snapshot.data;
//                                     if (thumbPath == null ||
//                                         !File(thumbPath).existsSync()) {
//                                       return Container(
//                                         color: Colors.grey.shade200,
//                                         alignment: Alignment.center,
//                                         child: const Icon(
//                                           Icons.videocam,
//                                           size: 40,
//                                           color: Colors.grey,
//                                         ),
//                                       );
//                                     }
//
//                                     return Stack(
//                                       fit: StackFit.expand,
//                                       children: [
//                                         Image.file(
//                                           File(thumbPath),
//                                           fit: BoxFit.cover,
//                                         ),
//                                         const Center(
//                                           child: Icon(
//                                             Icons.play_circle_fill,
//                                             color: Colors.white,
//                                             size: 36,
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 )
//                                 : isNetwork
//                                 ? Image.network(
//                                   filePath,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return const Center(
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                       ),
//                                     );
//                                   },
//                                   errorBuilder:
//                                       (_, __, ___) => const Icon(
//                                         Icons.broken_image,
//                                         size: 40,
//                                         color: Colors.grey,
//                                       ),
//                                 )
//                                 : Image.file(
//                                   File(filePath),
//                                   fit: BoxFit.cover,
//                                   errorBuilder:
//                                       (_, __, ___) => const Icon(
//                                         Icons.broken_image,
//                                         size: 40,
//                                         color: Colors.grey,
//                                       ),
//                                 ),
//                       ),
//                     ),
//
//                     // ---------- Remove Button ----------
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: GestureDetector(
//                         onTap: () => onRemove(index),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.5),
//                             shape: BoxShape.circle,
//                           ),
//                           padding: const EdgeInsets.all(3),
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
