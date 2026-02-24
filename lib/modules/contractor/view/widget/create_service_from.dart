/*

import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/cotractor_active_switch.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';

import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../controller/contractor_my_service_controller.dart';

class AddServiceScreen extends StatefulWidget {
  final ContractorServiceItem? serviceToEdit;

  AddServiceScreen({super.key, this.serviceToEdit});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isShowAllSubCategory = false;
  final controller = Get.find<ContractorMyServiceController>();
  final RxString _selectedServiceNameDropdown = ''.obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ContractorMyServiceController>();
      if (widget.serviceToEdit != null) {
        // EDIT MODE – form populate karo
        controller.populateFormForEdit(widget.serviceToEdit!);
      } else {
        // ADD MODE – form clear karo
        controller.clearForm();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractorMyServiceController>();
    if (widget.serviceToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.serviceToEdit != null) {
          controller.populateFormForEdit(widget.serviceToEdit!);
        } else {
          controller.clearForm(); // Clear form for new service
        }
      });
    }
    final materialRows = [

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Cement Brand",
              options: controller.cementOptions,

              selectedValues: controller.selectedCement,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Steel Brand",
              options: controller.steelOptions,
              selectedValues: controller.selectedSteel,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Bricks",
              options: controller.brickOptions,
              selectedValues: controller.selectedBrick,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Sand",
              options: controller.sandOptions,
              selectedValues: controller.selectedSand,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Electrical Wires Brand",
              options: controller.wireOptions,
              selectedValues: controller.selectedWire,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Switches Brand",
              options: controller.switchOptions,
              selectedValues: controller.selectedSwitch,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Plumbing Pipes Brand",
              options: controller.pipeOptions,
              selectedValues: controller.selectedPipe,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Sanitary/WC Brand",
              options: controller.sanitaryOptions,
              selectedValues: controller.selectedSanitary,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Water Tank Brand",
              options: controller.tankOptions,
              selectedValues: controller.selectedTank,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Flooring Tiles Brand",
              options: controller.tileOptions,
              selectedValues: controller.selectedTile,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Interior Paint Brand",
              options: controller.interiorPaintOptions,
              selectedValues: controller.selectedInteriorPaint,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Exterior Paint Brand",
              options: controller.exteriorPaintOptions,
              selectedValues: controller.selectedExteriorPaint,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Doors Type/Brand",
              options: controller.doorOptions,
              selectedValues: controller.selectedDoor,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Windows Type/Brand",
              options: controller.windowOptions,
              selectedValues: controller.selectedWindow,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Structure",
              options: controller.structureOptions,
              selectedValues: controller.selectedStructure,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Plaster",
              options: controller.plasterOptions,
              selectedValues: controller.selectedPlaster,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Waterproofing",
              options: controller.waterproofingOptions,
              selectedValues: controller.selectedWaterproofing,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Chokhat",
              options: controller.chokhatOptions,
              selectedValues: controller.selectedChokhat,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Railing",
              options: controller.railingOptions,
              selectedValues: controller.selectedRailing,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "False Ceiling",
              options: controller.ceilingOptions,
              selectedValues: controller.selectedCeiling,
              context: context,
            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Fabrication Work",
              options: controller.fabricationOptions,
              selectedValues: controller.selectedFabrication,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "3D Design",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selected3D,

            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Modular Kitchen",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedModularKitchen,

            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Bore and Pump",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedBoreAndPump,

            ),
          ),
        ],
      ),

      Row(
        children: [
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Security Systems",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedSecuritySystems,

            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Home Automation",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedHomeAutomation,

            ),
          ),
        ],
      ),

      buildSelectableNormalDropdown(
        title: "Solar Solutions",
        options: ['Yes', "No"].obs,
        selectedValue: controller.selectedSolarSolutions,

      ),
    ];

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: Text(
          widget.serviceToEdit == null ? "Add New Service" : "Edit Service",
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: ColorRes.textPrimary),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),

                buildSectionTitle("Category"),
                // SizedBox(height: 4,),
                // Category Dropdown using NesticoPeDropdownField
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedCategory.value,
                  hintText: "Select category",
                  prefixIcon: Icons.category,
                  items:
                      controller.contractorServiceCategory.value?.data.items
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id, // only store the name
                              child: Text(e.name),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: (val) {
                    if (val == null) return;

                    controller.selectedCategory.value = val;

                    final category =
                    controller.contractorServiceCategory.value?.data.items
                        .firstWhere(
                          (e) => e.id == val,
                    );

                    controller.selectedCategoryName.value = category?.name ?? '';

                    log("Category ID: ${controller.selectedCategory.value}");
                    log("Category Name: ${controller.selectedCategoryName.value}");
                    controller.serviceNameController.clear();
                    controller.onCategoryChanged(val, category?.name ?? '');
                  },

                  darkText: true,
                ),

                if (controller
                    .isHomeConstruction(controller.selectedCategory.value)) ...[

                  SizedBox(height: 16),
                  Obx(() {
                    final visibleCount =
                        controller.showAllMaterials.value
                            ? materialRows.length
                            : 2;

                    return Column(
                      children: [
                        ...materialRows
                            .take(visibleCount)
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: e,
                              ),
                            )
                            .toList(),

                        // Show More / Less button
                        if (materialRows.length > 2)
                          GestureDetector(
                            onTap: () {
                              controller.showAllMaterials.toggle();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                controller.showAllMaterials.value
                                    ? "Show less ▲"
                                    : "Show more ▼",
                                style: TextStyle(
                                  color: ColorRes.primary,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 16),
                buildSectionTitle("Service Name *"),
                const SizedBox(height: 8),

                if (controller
                    .isHomeConstruction(controller.selectedCategory.value)) ...[
                  // ── Plain TextField ──────────────────────
                  buildTextField(
                    "Enter service name",
                    Icons.business_center,
                    controller.serviceNameController,
                  ),
                ] else ...[
                  // ── Service Name Dropdown ────────────────
                  Obx(() {
                    final options = controller
                        .getServiceNamesForCategory(
                        controller.selectedCategoryName.value)
                        .map((e) => e['label'] as String)
                        .toList();
log("fhndufhd ${options}");
                    return NesticoPeDropdownField<String>(
                      isRequired: true,
                      value: controller
                          .selectedServiceNameDropdown.value.isEmpty
                          ? null
                          : controller.selectedServiceNameDropdown.value,
                      hintText: "Select service name",
                      prefixIcon: Icons.business_center,
                      // Category change hone par dropdown rebuild ho
                      key: ValueKey(controller.selectedCategory.value),
                      items: options
                          .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        // onServiceNameSelected:
                        // selectedServiceNameDropdown set karo,
                        // serviceNameController mein text set karo,
                        // workItemOptions load karo
                        controller.onServiceNameSelected(val);
                      },
                      darkText: true,
                    );
                  }),

                  // ── Works / Items Multi-select ───────────
                  Obx(() {
                    // Jab tak service name select nahi hota, kuch mat dikhao
                    if (controller.selectedServiceNameDropdown.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        buildSectionTitle("Works / Items *"),
                        const SizedBox(height: 4),

                        // ── Selected chips ──────────────────────────────────
                        if (controller.selectedWorkItems.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: controller.selectedWorkItems
                                  .map((item) => Chip(
                                label: Text(item,
                                    style: const TextStyle(
                                        fontSize:
                                        AppFontSizes.caption)),
                                deleteIcon: const Icon(Icons.close,
                                    size: 14),
                                onDeleted: () => controller
                                    .selectedWorkItems
                                    .remove(item),
                              ))
                                  .toList(),
                            ),
                          ),

                        // ── Multi-select dropdown ───────────────────────────
                        NesticoPeDropdownField<String>(
                          value: null,
                          // Force rebuild jab selectedWorkItems change ho
                          key: ValueKey(controller.selectedWorkItems.length),
                          hintText: "Select work items",
                          prefixIcon: Icons.handyman,
                          items: controller.workItemOptions
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                Icon(
                                  controller.selectedWorkItems
                                      .contains(e)
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  size: 18,
                                  color: controller.selectedWorkItems
                                      .contains(e)
                                      ? ColorRes.primary
                                      : ColorRes.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(e)),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: (val) {
                            if (val == null) return;
                            // Toggle selection
                            if (controller.selectedWorkItems.contains(val)) {
                              controller.selectedWorkItems.remove(val);
                            } else {
                              controller.selectedWorkItems.add(val);
                            }
                          },
                          darkText: true,
                        ),
                      ],
                    );
                  }),
                ],


                SizedBox(height: 16),
                buildSectionTitle("Description *"),
                SizedBox(height: 8),
                buildTextField(
                  "Describe your service",
                  Icons.description,
                  controller.descriptionController,
                  maxLines: 3,
                  minLines: 3,
                ),
                SizedBox(height: 16),
                buildSectionTitle("Price Model"),
                // SizedBox(height: 8,),
                // Price Model Dropdown
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedPriceModel.value,
                  hintText: "Select price model",
                  prefixIcon: Icons.payments,
                  items:
                      ["Fixed", "Hourly", "Per Sq Ft", "Custom"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => controller.selectedPriceModel.value = val,
                  darkText: true,
                ),
                // if(controller.selectedPriceModel.value!="Custom")...[
                //   SizedBox(height: 16),
                //   buildSectionTitle("Price (₹) *"),
                //   SizedBox(height: 8),
                //   buildTextField(
                //     "0",
                //     Icons.currency_rupee,
                //     controller.priceController,
                //     isPhoneKey: true,
                //   ),
                // ],
                SizedBox(height: 16),
                buildSectionTitle("Minimum Price"),
                SizedBox(height: 8),
                buildTextField(
                  "e.g., 1000",
                  Icons.price_change,
                  controller.minRangeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter minimum price";
                    }
                    final min = double.tryParse(value);
                    if (min == null || min < 0) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildSectionTitle("Maximum Price"),
                SizedBox(height: 8),
                buildTextField(
                  "e.g., 5000",
                  Icons.price_change,
                  controller.maxRangeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter maximum price";
                    }
                    final max = double.tryParse(value);
                    final min = double.tryParse(
                      controller.minRangeController.text,
                    );
                    if (max == null || max < 0) {
                      return "Enter a valid number";
                    }
                    if (min != null && max < min) {
                      return "Maximum price must be greater than minimum price";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                buildSectionTitle("Visit Charge"),
                SizedBox(height: 8),
                buildTextField(
                  "e.g., 100",
                  Icons.monetization_on_outlined,
                  controller.visitChargeController,
                ),

                SizedBox(height: 16),
                buildSectionTitle("Work Availability"),
                // SizedBox(height: 8,),
                // Work Availability Dropdown
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedAvailability.value,
                  hintText: "Select availability",
                  prefixIcon: Icons.schedule,
                  items:
                      ["Immediate", "In 3 Days", "In 1 Week", "Custom"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (val) => controller.selectedAvailability.value = val,
                  darkText: true,
                ),

                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildToggle(
                        "Provide Materials",
                        controller.provideMaterials,
                      ),
                      SizedBox(height: 10),
                      _buildToggle(
                        "Equipment Provided",
                        controller.equipmentProvided,
                      ),
                      SizedBox(height: 10),
                      _buildToggle(
                        "Insurance Available",
                        controller.insuranceAvailable,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                buildSectionTitle("Brands Used (Optional)"),
                SizedBox(height: 8),
                buildTextField(
                  "Enter brand names",
                  Icons.branding_watermark,
                  controller.brandController,
                ),
                SizedBox(height: 16),
                buildSectionTitle("Accepted Payment Modes *"),
                SizedBox(height: 8),
                _buildChipSelector(controller),
                SizedBox(height: 16),
                buildSectionTitle("Advance Required (%)"),
                SizedBox(height: 8),
                buildTextField(
                  "0",
                  Icons.percent,
                  controller.advanceController,
                  isPhoneKey: true, // assuming numeric keyboard
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Please enter a value";

                    // Convert to double
                    final value = double.tryParse(v);
                    if (value == null) return "Enter a valid number";

                    if (value < 0 || value > 100)
                      return "Percentage must be between 0 and 100";

                    return null; // valid
                  },
                ),

                SizedBox(height: 16),
                buildSectionTitle("Billing Type"),
                // SizedBox(height: 8,),
                // Billing Type Dropdown
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedBillingType.value,
                  hintText: "Select billing type",
                  prefixIcon: Icons.receipt_long,
                  items:
                      ["GST", "Non GST"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (val) => controller.selectedBillingType.value = val,
                  darkText: true,
                ),

                const SizedBox(height: 24),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorRes.textSecondary,
                            side: const BorderSide(color: ColorRes.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              if (controller.editingService.value != null) {
                                controller.updateService();
                              } else {
                                controller.createService();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child:
                              controller.isCreating.value
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: ColorRes.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    controller.editingService.value != null
                                        ? "Update Service"
                                        : "Create Service",
                                    style: TextStyle(
                                      color: ColorRes.white,
                                      fontWeight: AppFontWeights.semiBold,
                                      fontSize: AppFontSizes.body,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectableNormalDropdown({
    required String title,
    required RxList<String> options,
    required RxString selectedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(title),
        Obx(() {
          return NesticoPeDropdownField<String>(
            isRequired: true,
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            hintText: "Select",
            items: options
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
                .toList(),
            onChanged: (val) {
              selectedValue.value = val ?? '';
            },
            darkText: true,
          );
        }),
      ],
    );
  }

  Widget buildSelectableDropdown({
    required String title,
    required RxList<String> options,
    required RxList<String> selectedValues,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(title),

        // 🔹 Selected chips
        Obx(() => Wrap(
          spacing: 4,
          // runSpacing: 2,
          children: selectedValues
              .map(
                (e) => Chip(
              label: Text(e,style: TextStyle(fontSize: AppFontSizes.caption),),
              deleteIcon: const Icon(Icons.close, size: 14),
              onDeleted: () => selectedValues.remove(e),
            ),
          )
              .toList(),
        )),

        const SizedBox(height: 8),

        // 🔹 Dropdown adder
        Obx(() {
          return NesticoPeDropdownField<String>(
            value: null, // 👈 IMPORTANT (reset every time)
            hintText: "Select or add",
            key: ValueKey(selectedValues.length), // 🔥 FORCE REBUILD
            items: [
              ...options.map(
                    (e) => DropdownMenuItem(value: e, child: Text(e)),
              ),
              const DropdownMenuItem(
                value: "__add_new__",
                child: Text(
                  "+ Add custom",
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            onChanged: (val) async {
              if (val == null) return;
              if(selectedValues.isEmpty)
                {
                  selectedValues.clear();
                }

              if (val == "__add_new__") {
                final customValue = await showCustomInputDialog(context);
                if (customValue != null && customValue.trim().isNotEmpty) {
                  if (!options.contains(customValue)) {
                    options.add(customValue);
                  }
                  if (!selectedValues.contains(customValue)) {
                    selectedValues.add(customValue);

                  }
                }
              } else {
                if (!selectedValues.contains(val)) {

                  selectedValues.add(val);

                  log("Catgory ${selectedValues.map((element) => element,)}");
                }
              }
            },
          );
        }),
      ],
    );
  }


  Future<String?> showCustomInputDialog(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorRes.white,
          title: Text(
            "Add custom option",
            style: TextStyle(
              fontWeight: AppFontWeights.semiBold,
              fontSize: AppFontSizes.body,
            ),
          ),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter value"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.clear();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // ---------- Helper Widgets ----------
  Widget _buildToggle(String label, RxBool observable) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textSecondary,
            ),
          ),
          CustomSwitch(
            value: observable.value,
            activeColor: ColorRes.primary,

            inactiveColor: ColorRes.leadGreyColor.shade400,
            onChanged: (val) {
              // Call controller toggle
              observable.value = val;
            },
          ),
          // Switch(
          //   value: observable.value,
          //   onChanged: (val) => observable.value = val,
          //   activeColor: ColorRes.primary,
          // ),
        ],
      ),
    );
  }

  Widget _buildChipSelector(ContractorMyServiceController controller) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 2,
        children:
            controller.allPaymentModes.map((mode) {
              final selected = controller.acceptedPaymentModes.contains(mode);
              return FilterChip(
                label: Text(
                  mode,
                  style: const TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                selected: selected,
                onSelected: (bool val) {
                  if (val) {
                    controller.acceptedPaymentModes.add(mode);
                  } else {
                    controller.acceptedPaymentModes.remove(mode);
                  }
                },
                backgroundColor: ColorRes.surface,
                selectedColor: ColorRes.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: ColorRes.border),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: TextStyle(
                  color: selected ? ColorRes.primary : ColorRes.textPrimary,
                  fontWeight: AppFontWeights.medium,
                ),
              );
            }).toList(),
      ),
    );
  }
}
*/
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/cotractor_active_switch.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';

import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../controller/contractor_my_service_controller.dart';

class AddServiceScreen extends StatefulWidget {
  final ContractorServiceItem? serviceToEdit;

  AddServiceScreen({super.key, this.serviceToEdit});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isShowAllSubCategory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ContractorMyServiceController>();
      if (widget.serviceToEdit != null) {
        controller.populateFormForEdit(widget.serviceToEdit!);
      } else {
        controller.clearForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractorMyServiceController>();

    final materialRows = [
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Cement Brand",
              options: controller.cementOptions,
              selectedValues: controller.selectedCement,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Steel Brand",
              options: controller.steelOptions,
              selectedValues: controller.selectedSteel,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Bricks",
              options: controller.brickOptions,
              selectedValues: controller.selectedBrick,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Sand",
              options: controller.sandOptions,
              selectedValues: controller.selectedSand,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Electrical Wires Brand",
              options: controller.wireOptions,
              selectedValues: controller.selectedWire,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Switches Brand",
              options: controller.switchOptions,
              selectedValues: controller.selectedSwitch,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Plumbing Pipes Brand",
              options: controller.pipeOptions,
              selectedValues: controller.selectedPipe,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Sanitary/WC Brand",
              options: controller.sanitaryOptions,
              selectedValues: controller.selectedSanitary,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Water Tank Brand",
              options: controller.tankOptions,
              selectedValues: controller.selectedTank,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Flooring Tiles Brand",
              options: controller.tileOptions,
              selectedValues: controller.selectedTile,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Interior Paint Brand",
              options: controller.interiorPaintOptions,
              selectedValues: controller.selectedInteriorPaint,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Exterior Paint Brand",
              options: controller.exteriorPaintOptions,
              selectedValues: controller.selectedExteriorPaint,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Doors Type/Brand",
              options: controller.doorOptions,
              selectedValues: controller.selectedDoor,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Windows Type/Brand",
              options: controller.windowOptions,
              selectedValues: controller.selectedWindow,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Solar Panel Brand",
              options: controller.solarPanelOptions,
              selectedValues: controller.selectedSolarPanel,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Solar Inverter Brand",
              options: controller.solarInverterOptions,
              selectedValues: controller.selectedSolarInverter,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Security Brand",
              options: controller.securityOptions,
              selectedValues: controller.selectedSecurity,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Smart Home Brand",
              options: controller.smartHomeOptions,
              selectedValues: controller.selectedSmartHome,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Machine Brand",
              options: controller.machineOptions,
              selectedValues: controller.selectedMachine,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Cladding Brand",
              options: controller.claddingOptions,
              selectedValues: controller.selectedCladding,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Structure",
              options: controller.structureOptions,
              selectedValues: controller.selectedStructure,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Plaster",
              options: controller.plasterOptions,
              selectedValues: controller.selectedPlaster,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Waterproofing",
              options: controller.waterproofingOptions,
              selectedValues: controller.selectedWaterproofing,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "Chokhat",
              options: controller.chokhatOptions,
              selectedValues: controller.selectedChokhat,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Railing",
              options: controller.railingOptions,
              selectedValues: controller.selectedRailing,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableDropdown(
              title: "False Ceiling",
              options: controller.ceilingOptions,
              selectedValues: controller.selectedCeiling,
              context: context,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableDropdown(
              title: "Fabrication Work",
              options: controller.fabricationOptions,
              selectedValues: controller.selectedFabrication,
              context: context,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "3D Design",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selected3D,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Modular Kitchen",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedModularKitchen,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Bore and Pump",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedBoreAndPump,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Security Systems",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedSecuritySystems,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildSelectableNormalDropdown(
              title: "Home Automation",
              options: ['Yes', "No"].obs,
              selectedValue: controller.selectedHomeAutomation,
            ),
          ),
        ],
      ),
      buildSelectableNormalDropdown(
        title: "Solar Solutions",
        options: ['Yes', "No"].obs,
        selectedValue: controller.selectedSolarSolutions,
      ),
    ];

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: Text(
          widget.serviceToEdit == null ? "Add New Service" : "Edit Service",
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: ColorRes.textPrimary),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),

                // ── CATEGORY ─────────────────────────────────────────────────
                buildSectionTitle("Category"),
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value:
                      controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value,
                  hintText: "Select category",
                  prefixIcon: Icons.category,
                  items:
                      controller.contractorServiceCategory.value?.data.items
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: (val) {
                    if (val == null) return;
                    final category = controller
                        .contractorServiceCategory
                        .value
                        ?.data
                        .items
                        .firstWhere((e) => e.id == val);
                    controller.onCategoryChanged(val, category?.name ?? '');
                  },
                  darkText: true,
                ),

                // ── HOME CONSTRUCTION MATERIALS ──────────────────────────────

                const SizedBox(height: 16),

                // ── SERVICE NAME ─────────────────────────────────────────────
                buildSectionTitle("Service Name *"),
                const SizedBox(height: 8),


                  // OTHER CATEGORIES → Dropdown
                  Obx(() {
                    final options = controller.getServiceNamesForCategory(
                      controller.selectedCategoryName.toLowerCase().replaceAll(
                        " ",
                        "_",
                      ), // pass ID directly
                    );
                    log("option ${options}");
                    return NesticoPeDropdownField<String>(
                      isRequired: true,
                      value:
                          controller.selectedServiceNameDropdown.value.isEmpty
                              ? null
                              : controller.selectedServiceNameDropdown.value,
                      hintText: "Select service name",
                      prefixIcon: Icons.business_center,

                      // ✅ FIX: include selectedServiceNameDropdown in key
                      // so widget rebuilds when edit mode pre-populates the value
                      key: ValueKey(
                        '${controller.selectedCategoryName.value}_${controller.selectedServiceNameDropdown.value}',
                      ),
                      items:
                          options
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e['value'] as String,
                                  child: Text(e['label'] as String),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        log("Checkfehfhuewh ${val}   ${controller.selectedServiceNameDropdown.value}");
                        if(val==controller.selectedServiceNameDropdown.value)return;
                        controller.onServiceNameSelected(val);
                      },
                      darkText: true,
                    );
                  }),

                  // ── Works / Items (service name select hone ke baad) ───────
                  Obx(() {
                    if (controller.selectedServiceNameDropdown.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (controller.workItemOptions.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        buildSectionTitle("Works / Items *"),
                        const SizedBox(height: 4),

                        // Selected chips
                        if (controller.selectedWorkItems.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children:
                                  controller.selectedWorkItems
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
                                              () => controller.selectedWorkItems
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
                            '${controller.selectedServiceNameDropdown.value}_${controller.selectedWorkItems.length}',
                          ),
                          hintText:
                              controller.selectedWorkItems.isEmpty
                                  ? "Select work items"
                                  : "${controller.selectedWorkItems.length} item(s) selected",
                          prefixIcon: Icons.handyman,
                          items:
                              controller.workItemOptions
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        children: [
                                          Icon(
                                            controller.selectedWorkItems
                                                    .contains(e)
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            size: 18,
                                            color:
                                                controller.selectedWorkItems
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
                            if (controller.selectedWorkItems.contains(val)) {
                              controller.selectedWorkItems.remove(val);
                            } else {
                              controller.selectedWorkItems.add(val);
                            }
                          },
                          darkText: true,
                        ),
                      ],
                    );
                  }),
                SizedBox(height: 16),

                if (controller.isHomeConstruction(
                  controller.selectedCategoryName.value,
                )) ...[
                  SizedBox(height: 16),
                  Obx(() {
                    final visibleCount =
                    controller.showAllMaterials.value
                        ? materialRows.length
                        : 2;
                    return Column(
                      children: [
                        ...materialRows
                            .take(visibleCount)
                            .map(
                              (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: e,
                          ),
                        )
                            .toList(),
                        if (materialRows.length > 2)
                          GestureDetector(
                            onTap: () {
                              controller.showAllMaterials.toggle();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                controller.showAllMaterials.value
                                    ? "Show less ▲"
                                    : "Show more ▼",
                                style: TextStyle(
                                  color: ColorRes.primary,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],



                SizedBox(height: 16),
                buildSectionTitle("Description *"),
                SizedBox(height: 8),
                buildTextField(
                  "Describe your service",
                  Icons.description,
                  controller.descriptionController,
                  maxLines: 3,
                  minLines: 3,
                ),

                SizedBox(height: 16),
                buildSectionTitle("Price Model"),
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedPriceModel.value,
                  hintText: "Select price model",
                  prefixIcon: Icons.payments,
                  items:
                      ["Fixed", "Hourly", "Per Sq Ft", "Custom"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => controller.selectedPriceModel.value = val,
                  darkText: true,
                ),

                SizedBox(height: 16),
                buildSectionTitle("Minimum Price"),
                SizedBox(height: 8),
                buildTextField(
                  "e.g., 1000",
                  Icons.price_change,
                  controller.minRangeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter minimum price";
                    }
                    final min = double.tryParse(value);
                    if (min == null || min < 0) return "Enter a valid number";
                    return null;
                  },
                ),

                SizedBox(height: 16),
                buildSectionTitle("Maximum Price"),
                SizedBox(height: 8),
                buildTextField(
                  "e.g., 5000",
                  Icons.price_change,
                  controller.maxRangeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter maximum price";
                    }
                    final max = double.tryParse(value);
                    final min = double.tryParse(
                      controller.minRangeController.text,
                    );
                    if (max == null || max < 0) return "Enter a valid number";
                    if (min != null && max < min) {
                      return "Maximum price must be greater than minimum price";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                buildSectionTitle("Visit Charge"),
                SizedBox(height: 8),
                buildTextField(
                  "e.g., 100",
                  Icons.monetization_on_outlined,
                  controller.visitChargeController,
                ),

                SizedBox(height: 16),
                buildSectionTitle("Work Availability"),
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedAvailability.value,
                  hintText: "Select availability",
                  prefixIcon: Icons.schedule,
                  items:
                      ["Immediate", "In 3 Days", "In 1 Week", "Custom"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (val) => controller.selectedAvailability.value = val,
                  darkText: true,
                ),

                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildToggle(
                        "Provide Materials",
                        controller.provideMaterials,
                      ),
                      SizedBox(height: 10),
                      _buildToggle(
                        "Equipment Provided",
                        controller.equipmentProvided,
                      ),
                      SizedBox(height: 10),
                      _buildToggle(
                        "Insurance Available",
                        controller.insuranceAvailable,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                buildSectionTitle("Brands Used (Optional)"),
                SizedBox(height: 8),
                buildTextField(
                  "Enter brand names",
                  Icons.branding_watermark,
                  controller.brandController,
                ),

                SizedBox(height: 16),
                buildSectionTitle("Accepted Payment Modes *"),
                SizedBox(height: 8),
                _buildChipSelector(controller),

                SizedBox(height: 16),
                buildSectionTitle("Advance Required (%)"),
                SizedBox(height: 8),
                buildTextField(
                  "0",
                  Icons.percent,
                  controller.advanceController,
                  isPhoneKey: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Please enter a value";
                    final value = double.tryParse(v);
                    if (value == null) return "Enter a valid number";
                    if (value < 0 || value > 100)
                      return "Percentage must be between 0 and 100";
                    return null;
                  },
                ),

                SizedBox(height: 16),
                buildSectionTitle("Billing Type"),
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedBillingType.value,
                  hintText: "Select billing type",
                  prefixIcon: Icons.receipt_long,
                  items:
                      ["GST", "Non GST"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (val) => controller.selectedBillingType.value = val,
                  darkText: true,
                ),

                const SizedBox(height: 24),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorRes.textSecondary,
                            side: const BorderSide(color: ColorRes.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              if (controller.editingService.value != null) {
                                controller.updateService();
                              } else {
                                controller.createService();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child:
                              controller.isCreating.value
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: ColorRes.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    controller.editingService.value != null
                                        ? "Update Service"
                                        : "Create Service",
                                    style: TextStyle(
                                      color: ColorRes.white,
                                      fontWeight: AppFontWeights.semiBold,
                                      fontSize: AppFontSizes.body,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectableNormalDropdown({
    required String title,
    required RxList<String> options,
    required RxString selectedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(title),
        Obx(() {
          return NesticoPeDropdownField<String>(
            isRequired: true,
            value: selectedValue.value.isEmpty ? null : selectedValue.value,
            hintText: "Select",
            items:
                options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) {
              selectedValue.value = val ?? '';
            },
            darkText: true,
          );
        }),
      ],
    );
  }

  Widget buildSelectableDropdown({
    required String title,
    required RxList<String> options,
    required RxList<String> selectedValues,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(title),
        Obx(
          () => Wrap(
            spacing: 4,
            children:
                selectedValues
                    .map(
                      (e) => Chip(
                        label: Text(
                          e,
                          style: TextStyle(fontSize: AppFontSizes.caption),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () => selectedValues.remove(e),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return NesticoPeDropdownField<String>(
            value: null,
            hintText: "Select or add",
            key: ValueKey(selectedValues.length),
            items: [
              ...options.map((e) => DropdownMenuItem(value: e, child: Text(e))),
              const DropdownMenuItem(
                value: "__add_new__",
                child: Text(
                  "+ Add custom",
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            onChanged: (val) async {
              if (val == null) return;
              if (val == "__add_new__") {
                final customValue = await showCustomInputDialog(context);
                if (customValue != null && customValue.trim().isNotEmpty) {
                  if (!options.contains(customValue)) options.add(customValue);
                  if (!selectedValues.contains(customValue))
                    selectedValues.add(customValue);
                }
              } else {
                if (!selectedValues.contains(val)) selectedValues.add(val);
              }
            },
          );
        }),
      ],
    );
  }

  Future<String?> showCustomInputDialog(BuildContext context) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorRes.white,
          title: Text(
            "Add custom option",
            style: TextStyle(
              fontWeight: AppFontWeights.semiBold,
              fontSize: AppFontSizes.body,
            ),
          ),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(hintText: "Enter value"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ctrl.clear();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggle(String label, RxBool observable) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textSecondary,
            ),
          ),
          CustomSwitch(
            value: observable.value,
            activeColor: ColorRes.primary,
            inactiveColor: ColorRes.leadGreyColor.shade400,
            onChanged: (val) => observable.value = val,
          ),
        ],
      ),
    );
  }

  Widget _buildChipSelector(ContractorMyServiceController controller) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 2,
        children:
            controller.allPaymentModes.map((mode) {
              final selected = controller.acceptedPaymentModes.contains(mode);
              return FilterChip(
                label: Text(
                  mode,
                  style: const TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                selected: selected,
                onSelected: (bool val) {
                  if (val) {
                    controller.acceptedPaymentModes.add(mode);
                  } else {
                    controller.acceptedPaymentModes.remove(mode);
                  }
                },
                backgroundColor: ColorRes.surface,
                selectedColor: ColorRes.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: ColorRes.border),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: TextStyle(
                  color: selected ? ColorRes.primary : ColorRes.textPrimary,
                  fontWeight: AppFontWeights.medium,
                ),
              );
            }).toList(),
      ),
    );
  }
}
