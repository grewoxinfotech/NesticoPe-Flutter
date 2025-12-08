// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
//
// import '../../controller/contractor_my_service_controller.dart';
//
// class AddServiceScreen extends StatelessWidget {
//   const AddServiceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ContractorMyServiceController());
//
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         title: const Text(
//           "Add New Service",
//           style: TextStyle(
//             color: ColorRes.textPrimary,
//             fontWeight: AppFontWeights.semiBold,
//             fontSize: AppFontSizes.subtitle,
//           ),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: ColorRes.textPrimary),
//       ),
//       body: Obx(() => SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16,),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 8,),
//             buildSectionTitle("Service Name *"),
//             SizedBox(height: 8,),
//             buildTextField(
//               "Enter service name",
//               Icons.business_center,
//               controller.serviceNameController,
//             ),
//             SizedBox(height: 16,),
//             buildSectionTitle("Category *"),
//             SizedBox(height: 8,),
//             _buildDropdown(controller.selectedCategory, [
//               "Renovation & Remodeling",
//               "Painting",
//               "Electrical",
//               "Plumbing",
//             ]),
//             SizedBox(height: 16,),
//             buildSectionTitle("Description *"),
//             SizedBox(height: 8,),
//             buildTextField(
//               "Describe your service",
//               Icons.description,
//               controller.descriptionController,
//               maxLines: 3,
//               minLines: 3,
//             ),
//             SizedBox(height: 16,),
//             buildSectionTitle("Price Model *"),
//             SizedBox(height: 8,),
//             _buildDropdown(controller.selectedPriceModel, ["Fixed", "Hourly"]),
//             SizedBox(height: 16,),
//             buildSectionTitle("Price (₹) *"),
//             SizedBox(height: 8,),
//             buildTextField(
//               "0",
//               Icons.currency_rupee,
//               controller.priceController,
//               isPhoneKey: true,
//             ),
//             SizedBox(height: 16,),
//             buildSectionTitle("Starting Range"),
//             SizedBox(height: 8,),
//             buildTextField(
//               "e.g., 100",
//               Icons.price_change,
//               controller.startingRangeController,
//               isPhoneKey: true,
//             ),
//             SizedBox(height: 16,),
//             buildSectionTitle("Work Availability *"),
//             SizedBox(height: 8,),
//             _buildDropdown(controller.selectedAvailability, ["Immediate", "Within a week", "Later"]),
//
//             const SizedBox(height: 10),
//             _buildToggle("Provide Materials", controller.provideMaterials),
//             _buildToggle("Equipment Provided", controller.equipmentProvided),
//             _buildToggle("Insurance Available", controller.insuranceAvailable),
//
//             const SizedBox(height: 16),
//             buildSectionTitle("Brands Used (Optional)"),
//             SizedBox(height: 8,),
//             buildTextField(
//               "Enter brand names",
//               Icons.branding_watermark,
//               controller.brandController,
//             ),
//             SizedBox(height: 16,),
//             buildSectionTitle("Accepted Payment Modes *"),
//             SizedBox(height: 8,),
//             _buildChipSelector(controller),
//             SizedBox(height: 16,),
//             buildSectionTitle("Advance Required (%)"),
//             SizedBox(height: 8,),
//             buildTextField(
//               "0",
//               Icons.percent,
//               controller.advanceController,
//               isPhoneKey: true,
//             ),
//             SizedBox(height: 16,),
//             buildSectionTitle("Billing Type *"),
//             SizedBox(height: 8,),
//             _buildDropdown(controller.selectedBillingType, ["GST", "Non-GST"]),
//
//             const SizedBox(height: 24),
//             SafeArea(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Get.back(),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: ColorRes.textSecondary,
//                         side: const BorderSide(color: ColorRes.border),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: const Text("Cancel"),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (controller.validateForm()) controller.createService();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorRes.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: controller.isCreating.value
//                           ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(color: ColorRes.white, strokeWidth: 2))
//                           : const Text(
//                         "Create Service",
//                         style: TextStyle(
//                           color: ColorRes.white,
//                           fontWeight: AppFontWeights.semiBold,
//                           fontSize: AppFontSizes.body,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
//
//   // ---------- Helper Widgets ----------
//
//
//   //
//   // Widget _buildDropdown(RxString selectedValue, List<String> items) {
//   //   return Obx(() => DropdownButtonFormField<String>(
//   //     value: selectedValue.value,
//   //     decoration: InputDecoration(
//   //       enabledBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 1),
//   //       ) ,
//   //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 1),
//   //       ),
//   //     ),
//   //     items: items
//   //         .map((e) => DropdownMenuItem(
//   //
//   //       value: e,
//   //       child: Text(e,  style: TextStyle(
//   //         fontSize: AppFontSizes.medium,
//   //         color: ColorRes.textPrimary,
//   //       ),),
//   //     ))
//   //         .toList(),
//   //     onChanged: (val) => selectedValue.value = val!,
//   //   ));
//   // }
//   Widget _buildDropdown(RxString selectedValue, List<String> items) {
//     return Obx(() => DropdownButtonFormField<String>(
//       value: selectedValue.value,
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 1),
//         ) ,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 1),
//         ),
//       ),
//       items: items
//           .map((e) => DropdownMenuItem(
//
//         value: e,
//         child: Text(e,  style: TextStyle(
//           fontSize: AppFontSizes.medium,
//           color: ColorRes.textPrimary,
//         ),),
//       ))
//           .toList(),
//       onChanged: (val) => selectedValue.value = val!,
//     ));
//   }
//
//   Widget _buildToggle(String label, RxBool observable) {
//     return Obx(() => Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: AppFontSizes.bodySmall,
//             fontWeight: AppFontWeights.medium,
//             color: ColorRes.textSecondary,
//           ),
//         ),
//         Switch(
//           value: observable.value,
//           onChanged: (val) => observable.value = val,
//           activeColor: ColorRes.primary,
//         ),
//       ],
//     ));
//   }
//
//   Widget _buildChipSelector(ContractorMyServiceController controller) {
//     return Obx(() => Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: controller.allPaymentModes.map((mode) {
//         final selected = controller.acceptedPaymentModes.contains(mode);
//         return FilterChip(
//           label: Text(mode,
//               style: const TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//               )),
//           selected: selected,
//           onSelected: (bool val) {
//             if (val) {
//               controller.acceptedPaymentModes.add(mode);
//             } else {
//               controller.acceptedPaymentModes.remove(mode);
//             }
//           },
//           backgroundColor: ColorRes.surface,
//           selectedColor: ColorRes.primary.withOpacity(0.1),
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(color: ColorRes.border),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           labelStyle: TextStyle(
//             color: selected ? ColorRes.primary : ColorRes.textPrimary,
//             fontWeight: AppFontWeights.medium,
//           ),
//         );
//       }).toList(),
//     ));
//   }
// }
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

class AddServiceScreen extends StatelessWidget {
  final ContractorServiceItem? serviceToEdit;
   AddServiceScreen({super.key, this.serviceToEdit});

  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractorMyServiceController>();
    if (serviceToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (serviceToEdit != null) {
          controller.populateFormForEdit(serviceToEdit!);
        } else {
          controller.clearForm(); // Clear form for new service
        }
      });
    }
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title:  Text(
          serviceToEdit == null ? "Add New Service" : "Edit Service",
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
                buildSectionTitle("Service Name *"),
                SizedBox(height: 8),
                buildTextField(
                  "Enter service name",
                  Icons.business_center,
                  controller.serviceNameController,
                ),
                SizedBox(height: 16),
                buildSectionTitle("Category"),
                // SizedBox(height: 4,),
                // Category Dropdown using NesticoPeDropdownField
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedCategory.value,
                  hintText: "Select category",
                  prefixIcon: Icons.category,
                  items: controller.contractorServiceCategory.value?.data.items
                      .map((e) => DropdownMenuItem(
                    value: e.id, // only store the name
                    child: Text(e.name),
                  ))
                      .toList()??[],
                  onChanged: (val) => controller.selectedCategory.value = val ?? '',
                  darkText: true,
                ),

                SizedBox(height: 16),
                buildSectionTitle("Description *"),
                SizedBox(height: 8,),
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
                      ["Fixed", "Hourly","Per Sq Ft","Custom"]

                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                  onChanged: (val) => controller.selectedPriceModel.value = val,
                  darkText: true,
                ),

               if(controller.selectedPriceModel.value!="Custom")...[
                 SizedBox(height: 16),
                 buildSectionTitle("Price (₹) *"),
                 SizedBox(height: 8),
                 buildTextField(
                   "0",
                   Icons.currency_rupee,
                   controller.priceController,
                   isPhoneKey: true,
                 ),
               ],
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
                    final min = double.tryParse(controller.minRangeController.text);
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
                buildSectionTitle("Work Availability"),
                // SizedBox(height: 8,),
                // Work Availability Dropdown
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedAvailability.value,
                  hintText: "Select availability",
                  prefixIcon: Icons.schedule,
                  items:
                      ["Immediate", "In 3 Days", "In 1 Week","Custom"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                  onChanged: (val) => controller.selectedAvailability.value = val,
                  darkText: true,
                ),

                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade200,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      _buildToggle(
                        "Provide Materials",
                        controller.provideMaterials,
                      ),
                      SizedBox(height: 10,),
                      _buildToggle(
                        "Equipment Provided",
                        controller.equipmentProvided,
                      ),
                      SizedBox(height: 10,),
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

                    if (value < 0 || value > 100) return "Percentage must be between 0 and 100";

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
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                  onChanged: (val) => controller.selectedBillingType.value = val,
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
                            if (formKey.currentState?.validate()??false) {
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
                                  :  Text(
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
              ],
            ),
          ),
        ),
      ),
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
          )
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
