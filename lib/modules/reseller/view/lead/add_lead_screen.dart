import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';

class AddLeadScreen extends StatelessWidget {
  final LeadItem? lead;
  final bool isEditMode;
  final controller = Get.find<LeadController>(tag: "reseller");
  final resellerDashboard = Get.find<DashboardController>();
  final _formKey = GlobalKey<FormState>();

  AddLeadScreen({super.key, this.lead, this.isEditMode = false});
  @override
  Widget build(BuildContext context) {
    if (isEditMode && lead != null) {
      controller.populateLeadData(lead!);
    } else {
      controller.resetForm();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Lead" : "Add Lead"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                NesticoPeTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.nameController,
                  title: 'Name',
                  hintText: 'Enter full name',
                  isRequired: true,
                  validator:
                      (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),

                // Phone
                NesticoPeTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  controller: controller.phoneController,
                  title: 'Phone',
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? 'Phone number is required'
                              : null,
                ),
                const SizedBox(height: 16),

                // Email
                NesticoPeTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  isRequired: true,
                  controller: controller.emailController,
                  title: 'Email',
                  hintText: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!GetUtils.isEmail(v)) return 'Invalid email format';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Property
                Obx(
                  () => NesticoPeDropdownField(
                    title: "Property",
                    hintText: "Select property",
                    isRequired: true,
                    value: controller.selectedProperty.value,
                    items:
                        controller.propertyList.map((e) {
                          final propertyManager = PropertyNameManager(e);
                          return DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                if (e.propertyMedia?.images != null &&
                                    e.propertyMedia!.images!.isNotEmpty) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CustomImage(
                                      type: CustomImageType.network,
                                      src: e.propertyMedia!.images!.first,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                                Text(propertyManager.displayName),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (val) => controller.selectedProperty.value = val,
                    validator:
                        (val) =>
                            val == null ? 'Please select a property' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Source
                Obx(
                  () => NesticoPeDropdownField<String>(
                    title: "Source",
                    hintText: "Select source",
                    isRequired: true,
                    value: controller.selectedSource.value,
                    items:
                        controller.sourceList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.replaceAll("_", " ").capitalize.toString(),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => controller.selectedSource.value = val,
                    validator:
                        (val) => val == null ? 'Please select a source' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Status
                Obx(
                  () => NesticoPeDropdownField<String>(
                    title: "Status",
                    hintText: "Select status",
                    isRequired: true,
                    value: controller.selectedStatus.value,
                    items:
                        controller.statusList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.replaceAll("_", " ").capitalize.toString(),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => controller.selectedStatus.value = val,
                    validator:
                        (val) => val == null ? 'Please select a status' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Stage
                Obx(
                  () => NesticoPeDropdownField<String>(
                    title: "Stage",
                    hintText: "Select stage",
                    isRequired: true,
                    value: controller.selectedStage.value,
                    items:
                        controller.stageList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.replaceAll("_", " ").capitalize.toString(),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => controller.selectedStage.value = val,
                    validator:
                        (val) => val == null ? 'Please select a stage' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Note
                NesticoPeTextField(
                  controller: controller.noteController,
                  title: 'Note',
                  hintText: 'Add additional notes...',
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : isEditMode
                            ? _updateForm
                            : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor:
                          controller.isLoading.value
                              ? ColorRes.grey
                              : ColorRes.primary,
                    ),
                    child: Text(
                      isEditMode
                          ? !controller.isLoading.value
                              ? "Update Lead"
                              : "Updating..."
                          : !controller.isLoading.value
                          ? "Add Lead"
                          : "Adding...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await SecureStorage.getUserData();
      final leadData = LeadItem(
        name: controller.nameController.text.trim(),
        phone: controller.phoneController.text.trim(),
        email: controller.emailController.text.trim(),
        propertyId: controller.selectedProperty.value?.id ?? '',
        resellerId: user?.user?.id ?? '',
        source: controller.selectedSource.value,
        status: controller.selectedStatus.value,
        stage: controller.selectedStage.value,
        notes: controller.noteController.text.trim(),
      );

      final success = await controller.createLead(leadData);
      if (success) {
        resellerDashboard.fetchResellerDashboardDataFromApi();
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Lead Uploaded Successfully",
          contentType: ContentType.success,
        );
        Get.back();
      }
    }
  }

  Future<void> _updateForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await SecureStorage.getUserData();
      final leadData = LeadItem(
        name: controller.nameController.text.trim(),
        phone: controller.phoneController.text.trim(),
        email: controller.emailController.text.trim(),
        propertyId: controller.selectedProperty.value?.id ?? '',
        resellerId: user?.user?.id ?? '',
        source: controller.selectedSource.value,
        status: controller.selectedStatus.value,
        stage: controller.selectedStage.value,
        notes: controller.noteController.text.trim(),
      );

      final success = await controller.updateLead(lead?.id ?? '', leadData);
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Lead Updated Successfully",
          contentType: ContentType.success,
        );
        Get.back();
      }
    }
  }
}
