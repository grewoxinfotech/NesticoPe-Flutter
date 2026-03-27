/*
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_inquiry_controller.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../add_property/view/create_property.dart';
import '../../controller/hire_contractor_controller.dart';
import '../../controller/hire_contractor_filter_controller.dart';
import '../../controller/hire_contractor_list_of_profile_controller.dart';

class HireContractorFilter extends StatefulWidget {
  const HireContractorFilter({super.key});

  @override
  State<HireContractorFilter> createState() => _HireContractorFilterState();
}

class _HireContractorFilterState extends State<HireContractorFilter> {
  final HireContractorController controller =
      Get.find<HireContractorController>();
  final controllerProfileData =
      Get.find<HireContractorFilterProfileController>();

  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;

  Map<String, String> _buildFilterResult() {
    Map<String, String> filters = {};

    // ✅ Add category filter if selected

    filters['city'] = controllerProfileData.selectedCity.value;

    filters['category_ui'] = controllerProfileData.selectedCategoryName.value;

    // ✅ Add contractor rating filter if > 0
    if (controllerProfileData.selectedContractorRating.value > 0) {
      filters['contractorMinRating'] =
          controllerProfileData.selectedContractorRating.value
              .toInt()
              .toString();
    }

    // ✅ Add service rating filter if > 0
    if (controllerProfileData.selectedServiceRating.value > 0) {
      filters['serviceMinRating'] =
          controllerProfileData.selectedServiceRating.value.toInt().toString();
    }

    if (controllerProfileData.selectedExperience.value.isNotEmpty) {
      filters['experience'] = controllerProfileData.selectedExperience.value;
    }

    if (controllerProfileData.selectedAccountType.value.isNotEmpty) {
      filters['premiumAccount'] =
          controllerProfileData.selectedAccountType.value;
    }

    return filters;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "All Contractor",
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        controllerProfileData.resetFilters();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(
                        Icons.close_rounded,
                        color: ColorRes.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Scrollable Form
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle('Service Category'),
                        NesticoPeDropdownField<String>(
                          value: controllerProfileData.selectedCategoryId.value,
                          hintText: "Select category",
                          prefixIcon: Icons.category,
                          items:
                              controller.items
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.name ?? 'Unknown Category'),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            controllerProfileData.setValue(
                              controllerProfileData.selectedCategoryId,
                              val ?? '',
                            );

                            // Assign name where id matches
                            final selectedItem = controller.items
                                .firstWhereOrNull((e) => e.id == val);
                            if (selectedItem != null) {
                              controllerProfileData.selectedCategoryName.value =
                                  selectedItem.name ?? '';
                            }
                          },
                          darkText: true,
                        ),
                        const SizedBox(height: 8),

                        buildSectionTitle('City'),
                        NesticoPeDropdownField<String>(
                          value:
                              controllerProfileData.selectedCity.value.isEmpty
                                  ? null
                                  : controllerProfileData.selectedCity.value,
                          hintText: "Select City",
                          prefixIcon: Icons.location_city,
                          items:
                              controllerProfileData.contractorCity.value?.data
                                  ?.map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e.city, // String
                                      child: Text("${e.city} (${e.count})"),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          onChanged: (val) {
                            if (val != null) {
                              controllerProfileData.setValue(
                                controllerProfileData.selectedCity,
                                val, // ✅ val is already the city string
                              );
                            }
                          },
                          darkText: true,
                        ),
                        const SizedBox(height: 20),
                        buildSectionTitle('Contractor Rating'),
                        const SizedBox(height: 8),
                        Slider(
                          min: 0,
                          max: 5,
                          divisions: 5,
                          value:
                              controllerProfileData
                                  .selectedContractorRating
                                  .value,
                          label: controllerProfileData
                              .selectedContractorRating
                              .value
                              .toStringAsFixed(1),
                          activeColor: ColorRes.primary,
                          onChanged: (val) {
                            controllerProfileData.setValue(
                              controllerProfileData.selectedContractorRating,
                              val,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text('0.0'), Text('5.0')],
                        ),

                        const SizedBox(height: 20),
                        buildSectionTitle('Service Rating'),
                        const SizedBox(height: 8),
                        Slider(
                          min: 0,
                          max: 5,
                          divisions: 5,
                          value:
                              controllerProfileData.selectedServiceRating.value,
                          label: controllerProfileData
                              .selectedServiceRating
                              .value
                              .toStringAsFixed(1),
                          activeColor: ColorRes.primary,
                          onChanged: (val) {
                            controllerProfileData.setValue(
                              controllerProfileData.selectedServiceRating,
                              val,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text('0.0'), Text('5.0')],
                        ),

                        const SizedBox(height: 20),
                        buildSectionTitle('Years of Experience'),
                        const SizedBox(height: 8),

                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children:
                              ['1', '2', '3', '4', '5', '5+'].map((exp) {
                                return Obx(() {
                                  return filterChip(
                                    label: '$exp yr${exp == '1' ? '' : 's'}',
                                    isSelected:
                                        controllerProfileData
                                            .selectedExperience
                                            .value ==
                                        exp,
                                    onTap: () {
                                      controllerProfileData
                                          .selectedExperience
                                          .value = exp;
                                    },
                                  );
                                });
                              }).toList(),
                        ),

                        const SizedBox(height: 20),
                        buildSectionTitle('Account Type'),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return filterChip(
                                  label: '⭐ Premium',
                                  isSelected:
                                      controllerProfileData
                                          .selectedAccountType
                                          .value ==
                                      'premium',
                                  onTap: () {
                                    controllerProfileData
                                        .selectedAccountType
                                        .value = 'premium';
                                  },
                                );
                              }),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(() {
                                return filterChip(
                                  label: 'Regular',
                                  isSelected:
                                      controllerProfileData
                                          .selectedAccountType
                                          .value ==
                                      'regular',
                                  onTap: () {
                                    controllerProfileData
                                        .selectedAccountType
                                        .value = 'regular';
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // 🔹 Footer Buttons
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  border: Border(
                    top: BorderSide(
                      color: ColorRes.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          controllerProfileData.resetFilters();
                          controllerProfileData.selectedCategoryId.value = '';
                          controllerProfileData.selectedCategoryName.value = '';
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: ColorRes.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        // In the Apply Filters button onPressed
                        onPressed: () {
                          final filters = _buildFilterResult();

                          // // Call the method and wait for it
                          // controllerProfileData.fetchUserByID(
                          //   controllerProfileData.selectedCategoryId.value,
                          //   // controllerProfileData.selectedCategoryName.value,
                          // );

                          filters.remove('category_ui');

                          log("Applied Filters: $filters");
                          Get.back(result: filters);
                          // DON'T reset filters here - remove this line:
                          // controllerProfileData.resetFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? ColorRes.primary : ColorRes.grey.withOpacity(0.4),
            width: isSelected ? 1.5 : 1,
          ),
          color:
              isSelected ? ColorRes.primary.withOpacity(0.08) : ColorRes.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? ColorRes.primary : ColorRes.grey,
          ),
        ),
      ),
    );
  }
}
*/

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_inquiry_controller.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../controller/hire_contractor_controller.dart';
import '../../controller/hire_contractor_filter_controller.dart';

class HireContractorFilterScreen extends StatefulWidget {
  const HireContractorFilterScreen({super.key});

  @override
  State<HireContractorFilterScreen> createState() =>
      _HireContractorFilterScreenState();
}

class _HireContractorFilterScreenState
    extends State<HireContractorFilterScreen> {
  final HireContractorController controller =
      Get.find<HireContractorController>();
  final controllerProfileData =
      Get.find<HireContractorFilterProfileController>();

  final _formKey = GlobalKey<FormState>();

  Map<String, String> _buildFilterResult() {
    Map<String, String> filters = {};

    filters['city'] = controllerProfileData.selectedCity.value;
    filters['category_ui'] = controllerProfileData.selectedCategoryName.value;

    if (controllerProfileData.selectedContractorRating.value > 0) {
      filters['contractorMinRating'] =
          controllerProfileData.selectedContractorRating.value
              .toInt()
              .toString();
    }

    if (controllerProfileData.selectedServiceRating.value > 0) {
      filters['serviceMinRating'] =
          controllerProfileData.selectedServiceRating.value.toInt().toString();
    }

    if (controllerProfileData.selectedExperience.value.isNotEmpty) {
      filters['experience'] = controllerProfileData.selectedExperience.value;
    }

    if (controllerProfileData.selectedAccountType.value.isNotEmpty) {
      filters['premiumAccount'] =
          controllerProfileData.selectedAccountType.value;
    }


    if (controllerProfileData.selectedServiceNames.value.isNotEmpty) {
      filters['serviceNames'] = controllerProfileData.selectedServiceNames.value
          .map((e) => e.trim())
          .join(', ');
    }
    if (controllerProfileData.selectedWorkItems.value.isNotEmpty) {

      filters['works'] = controllerProfileData.selectedWorkItems.value
          .map((e) => e.trim())
          .join(', ');
    }


    return filters;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        elevation: 10,

        leading: IconButton(
          onPressed: () {
            Get.back();
          
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'All Contractor',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔹 Scrollable Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle('Service Category'),
                        NesticoPeDropdownField<String>(
                          value: controllerProfileData.selectedCategoryId.value,
                          hintText: "Select category",
                          prefixIcon: Icons.category,
                          items:
                              controller.items
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.name ?? 'Unknown Category'),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            controllerProfileData.setValue(
                              controllerProfileData.selectedCategoryId,
                              val ?? '',
                            );
                            final selectedItem = controller.items
                                .firstWhereOrNull((e) => e.id == val);
                            if (selectedItem != null) {
                              controllerProfileData.selectedCategoryName.value =
                                  selectedItem.name ?? '';
                              controllerProfileData
                                  .selectedServiceNameDropdown
                                  .value = '';
                              controllerProfileData.selectedServiceNames.clear();
                              controllerProfileData.selectedWorkItems.clear();
                              controllerProfileData.workItemOptions.clear();
                            }
                          },
                          darkText: true,
                        ),
                        const SizedBox(height: 16),
                        buildSectionTitle('Sub Category'),
                        Obx(() {
                          final options = controllerProfileData.getServiceNamesForCategory(
                            controllerProfileData.selectedCategoryName.value
                                .trim()
        .toLowerCase()
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_'),
                          );
                          log("Sub-category options: $options");
        
                          if (controllerProfileData.selectedCategoryId.value.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: ColorRes.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.business_center, size: 20, color: ColorRes.grey.withOpacity(0.5)),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Select a category first",
                                    style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.grey.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            );
                          }
        
                          if (options.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: ColorRes.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 20, color: ColorRes.grey.withOpacity(0.5)),
                                  const SizedBox(width: 10),
                                  Text(
                                    "No sub-categories available",
                                    style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.grey.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            );
                          }
        
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ Selected chips above dropdown
                              Obx(() {
                                final selected = controllerProfileData.selectedServiceNames;
                                if (selected.isEmpty) return const SizedBox.shrink();
        
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: selected.map((serviceName) {
                                      return Chip(
                                        label: Text(
                                          serviceName,
                                          style: const TextStyle(fontSize: AppFontSizes.caption),
                                        ),
                                        deleteIcon: const Icon(Icons.close, size: 14),
                                        onDeleted: () => controllerProfileData.removeServiceName(serviceName),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),
        
                              // ✅ Multi-select dropdown with checkbox icons
                              Obx(() {
                                final selected = controllerProfileData.selectedServiceNames;
                                return NesticoPeDropdownField<String>(
                                  value: null,
                                  key: ValueKey(
                                    '${controllerProfileData.selectedCategoryName.value}_${selected.length}',
                                  ),
                                  hintText: selected.isEmpty
                                      ? "Select service name"
                                      : "${selected.length} service(s) selected",
                                  prefixIcon: Icons.business_center,
                                  items: options.map((e) {
                                    final label = e['label'] as String;
                                    final value = e['value'] as String;
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Obx(() {
                                        final isSelected = controllerProfileData.selectedServiceNames.contains(label);
                                        return Row(
                                          children: [
                                            Icon(
                                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                              size: 18,
                                              color: isSelected ? ColorRes.primary : ColorRes.textSecondary,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(label)),
                                          ],
                                        );
                                      }),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val == null) return;
                                    // Find label for the selected value
                                    final match = options.firstWhereOrNull((e) => e['value'] == val);
                                    if (match == null) return;
                                    final label = match['label'] as String;
        
                                    // ✅ Toggle: add if not present, remove if already selected
                                    if (controllerProfileData.selectedServiceNames.contains(label)) {
                                      controllerProfileData.removeServiceName(label);
                                    } else {
                                      controllerProfileData.onServiceNameSelected(val, label: label);
                                    }
                                  },
                                  darkText: true,
                                );
                              }),
                            ],
                          );
                        }),
                      
                         Obx(() {
                      if (controllerProfileData.selectedServiceNames.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      if (controllerProfileData.workItemOptions.isEmpty) {
                        return const SizedBox.shrink();
                        
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const SizedBox(height: 16),
                          buildSectionTitle('Works / Specific Services'),
                        
                          const SizedBox(height: 4),
        
                          // Selected chips
                          if (controllerProfileData.selectedWorkItems.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children:
                                    controllerProfileData.selectedWorkItems
                                        .map(
                                          (item) => Chip(
                                            label: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: AppFontSizes.caption,
                                              ),
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              size: 14,
                                            ),
                                            onDeleted:
                                                () => controllerProfileData.selectedWorkItems
                                                    .remove(item),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
        
                          // ✅ Multi-select dropdown
                          // key includes selectedWorkItems.length to rebuild on add/remove
                          NesticoPeDropdownField<String>(
                            value: null,
                            key: ValueKey(
                              '${controllerProfileData.selectedServiceNameDropdown.value}_${controllerProfileData.selectedWorkItems.length}',
                            ),
                            hintText:
                                controllerProfileData.selectedWorkItems.isEmpty
                                    ? "Select work items"
                                    : "${controllerProfileData.selectedWorkItems.length} item(s) selected",
                            prefixIcon: Icons.handyman,
                            items:
                                controllerProfileData.workItemOptions
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          children: [
                                            Icon(
                                              controllerProfileData.selectedWorkItems
                                                      .contains(e)
                                                  ? Icons.check_box
                                                  : Icons.check_box_outline_blank,
                                              size: 18,
                                              color:
                                                  controllerProfileData.selectedWorkItems
                                                          .contains(e)
                                                      ? ColorRes.primary
                                                      : ColorRes.textSecondary,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(e)),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val == null) return;
                              // ✅ Toggle: add if not present, remove if already selected
                              if (controllerProfileData.selectedWorkItems.contains(val)) {
                                controllerProfileData.selectedWorkItems.remove(val);
                              } else {
                                controllerProfileData.selectedWorkItems.add(val);
                              }
                            },
                            darkText: true,
                          ),
                        ],
                      );
                    }),
                  SizedBox(height: 16),
                        buildSectionTitle('City'),
                        NesticoPeDropdownField<String>(
                          value:
                              controllerProfileData.selectedCity.value.isEmpty
                                  ? null
                                  : controllerProfileData.selectedCity.value,
                          hintText: "Select City",
                          prefixIcon: Icons.location_city,
                          items:
                              controllerProfileData.contractorCity.value?.data
                                  ?.map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e.city,
                                      child: Text("${e.city} (${e.count})"),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          onChanged: (val) {
                            if (val != null) {
                              controllerProfileData.setValue(
                                controllerProfileData.selectedCity,
                                val,
                              );
                            }
                          },
                          darkText: true,
                        ),
                        const SizedBox(height: 20),
        
                        buildSectionTitle('Contractor Rating'),
                        const SizedBox(height: 8),
                        Slider(
                          min: 0,
                          max: 5,
                          divisions: 5,
                          value:
                              controllerProfileData
                                  .selectedContractorRating
                                  .value,
                          label: controllerProfileData
                              .selectedContractorRating
                              .value
                              .toStringAsFixed(1),
                          activeColor: ColorRes.primary,
                          onChanged: (val) {
                            controllerProfileData.setValue(
                              controllerProfileData.selectedContractorRating,
                              val,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text('0.0'), Text('5.0')],
                        ),
        
                        const SizedBox(height: 20),
                        buildSectionTitle('Service Rating'),
                        const SizedBox(height: 8),
                        Slider(
                          min: 0,
                          max: 5,
                          divisions: 5,
                          value:
                              controllerProfileData.selectedServiceRating.value,
                          label: controllerProfileData.selectedServiceRating.value
                              .toStringAsFixed(1),
                          activeColor: ColorRes.primary,
                          onChanged: (val) {
                            controllerProfileData.setValue(
                              controllerProfileData.selectedServiceRating,
                              val,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text('0.0'), Text('5.0')],
                        ),
        
                        const SizedBox(height: 20),
                        buildSectionTitle('Years of Experience'),
                        const SizedBox(height: 8),
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.2,
                          // better visual balance
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children:
                              ['1', '2', '3', '4', '5', '5+'].map((exp) {
                                return Obx(() {
                                  return filterChip(
                                    label: '$exp yr${exp == '1' ? '' : 's'}',
                                    isSelected:
                                        controllerProfileData
                                            .selectedExperience
                                            .value ==
                                        exp,
                                    onTap: () {
                                      controllerProfileData
                                          .selectedExperience
                                          .value = exp;
                                    },
                                  );
                                });
                              }).toList(),
                        ),
        
                        const SizedBox(height: 20),
                        buildSectionTitle('Account Type'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return filterChip(
                                  label: '⭐ Premium',
                                  isSelected:
                                      controllerProfileData
                                          .selectedAccountType
                                          .value ==
                                      'premium',
                                  onTap: () {
                                    controllerProfileData
                                        .selectedAccountType
                                        .value = 'premium';
                                  },
                                );
                              }),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(() {
                                return filterChip(
                                  label: 'Regular',
                                  isSelected:
                                      controllerProfileData
                                          .selectedAccountType
                                          .value ==
                                      'regular',
                                  onTap: () {
                                    controllerProfileData
                                        .selectedAccountType
                                        .value = 'regular';
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
        
                        const SizedBox(height: 24),
                      ],
                    );
                  }),
                ),
              ),
        
              // 🔹 Footer Buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  border: Border(
                    top: BorderSide(
                      color: ColorRes.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controllerProfileData.selectedCategoryId.value = '';
                        controllerProfileData.selectedCategoryName.value = '';
                        controllerProfileData.resetFilters(); // keep category; clear other filters
                        Get.back(result: <String, String>{});
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: ColorRes.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          final filters = _buildFilterResult();
                          filters.remove('category_ui');
                          Get.back(result: filters);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: AppFontSizes.medium,
        fontWeight: AppFontWeights.semiBold,
        color: ColorRes.textPrimary,
      ),
    ),
  );

  Widget filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? ColorRes.primary : ColorRes.grey.withOpacity(0.4),
            width: isSelected ? 1.5 : 1,
          ),
          color:
              isSelected ? ColorRes.primary.withOpacity(0.08) : ColorRes.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.small,
            color: isSelected ? ColorRes.primary : ColorRes.grey,
          ),
        ),
      ),
    );
  }
}
