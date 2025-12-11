import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../add_property/view/create_property.dart';
import '../../controller/hire_contractor_controller.dart';
import '../../controller/hire_contractor_list_of_profile_controller.dart';



class HireContractorFilter extends StatefulWidget {
  const HireContractorFilter({super.key});

  @override
  State<HireContractorFilter> createState() =>
      _HireContractorFilterState();
}

class _HireContractorFilterState extends State<HireContractorFilter> {

  final HireContractorController controller =
  Get.find<HireContractorController>();
  final controllerProfileData = Get.find<HireContractorListOfProfileController>();

  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;

  Map<String, String> _buildFilterResult() {
    return {
      // if (controller.leadStatus.value.isNotEmpty)
      //   'status': controller.leadStatus.value.toLowerCase().replaceAll(" ", "_"),
      // if (controller.leadStage.value.isNotEmpty)
      //   'stage': controller.leadStage.value.toLowerCase().replaceAll(" ", "_"),
      // if (controller.leadSource.value.isNotEmpty)
      //   'source': controller.leadSource.value.toLowerCase().replaceAll(" ", "_"),
    };
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      onTap: () { Get.back();controllerProfileData.resetFilters();},
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle('Service Category'),
                        const SizedBox(height: 8),
                        NesticoPeDropdownField<String>(
                          value: controllerProfileData.selectedCategoryId.value.isEmpty
                              ? null
                              : controllerProfileData.selectedCategoryId.value,
                          hintText: "Select category",
                          prefixIcon: Icons.category,
                          items: controller.categories
                              .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name ?? 'Unknown Category')))
                              .toList(),
                          onChanged: (val) {
                            controllerProfileData.setValue(controllerProfileData.selectedCategoryId, val ?? '');
                            controllerProfileData.setValue(
                                controllerProfileData.selectedCategoryName,
                                controller.categories
                                    .firstWhereOrNull((c) => c.id == val)
                                    ?.name ??
                                    '');
                          },
                          darkText: true,
                        ),

                        const SizedBox(height: 20),
                        buildSectionTitle('Minimum Rating'),
                        const SizedBox(height: 8),
                        Slider(
                          min: 0,
                          max: 5,
                          divisions: 5,
                          value: controllerProfileData.selectedMinRating.value,
                          label: controllerProfileData.selectedMinRating.value.toStringAsFixed(1),
                          activeColor: ColorRes.primary,
                          onChanged: (val) {
                            controllerProfileData.setValue(controllerProfileData.selectedMinRating, val);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0.0'),
                            Text('5.0'),
                          ],
                        ),
                      ],
                    );
                  }),

                ),
              ),

              // 🔹 Footer Buttons
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

                          Get.back(result: {});
                          controllerProfileData.resetFilters();

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

                          log("Applied Filters: $filters");
                          Get.back(result: filters);
                          controllerProfileData.resetFilters();
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

}