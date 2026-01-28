import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
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
