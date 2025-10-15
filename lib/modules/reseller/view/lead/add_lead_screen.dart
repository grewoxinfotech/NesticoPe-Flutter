import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final controller = Get.find<LeadController>(tag: "reseller");
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  // Dropdown values
  String? selectedProperty;
  String? selectedSource;
  String? selectedStatus;
  String? selectedStage;

  // Dropdown lists
  final List<String> propertyList = ['Property A', 'Property B', 'Property C'];
  // final List<String> sourceList = [
  //   'App',
  //   'Website',
  //   'Referral',
  //   'Social Media',
  //   'Direct',
  //   'Other',
  // ];
  // final List<String> statusList = [
  //   'New',
  //   'Contacted',
  //   'Qualified',
  //   'Negotiation',
  //   'Lost',
  //   'Converted',
  // ];
  // final List<String> stageList = [
  //   'New Lead',
  //   'Contacted',
  //   'Interested',
  //   'Site Visit',
  //   'Sell',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Lead"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              NesticoPeTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
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

                controller: phoneController,
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

                controller: emailController,
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
              NesticoPeDropdownField<String>(
                title: "Property",
                hintText: "Select property",
                isRequired: true,
                value: selectedProperty,
                items:
                    propertyList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => selectedProperty = val),
                validator:
                    (val) => val == null ? 'Please select a property' : null,
              ),
              const SizedBox(height: 16),

              // Source
              NesticoPeDropdownField<String>(
                title: "Source",
                hintText: "Select source",
                isRequired: true,
                value: selectedSource,
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
                onChanged: (val) => setState(() => selectedSource = val),
                validator:
                    (val) => val == null ? 'Please select a source' : null,
              ),
              const SizedBox(height: 16),

              // Status
              NesticoPeDropdownField<String>(
                title: "Status",
                hintText: "Select status",
                isRequired: true,
                value: selectedStatus,
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
                onChanged: (val) => setState(() => selectedStatus = val),
                validator:
                    (val) => val == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 16),

              // Stage
              NesticoPeDropdownField<String>(
                title: "Stage",
                hintText: "Select stage",
                isRequired: true,
                value: selectedStage,
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
                onChanged: (val) => setState(() => selectedStage = val),
                validator:
                    (val) => val == null ? 'Please select a stage' : null,
              ),
              const SizedBox(height: 16),

              // Note
              NesticoPeTextField(
                controller: noteController,
                title: 'Note',
                hintText: 'Add additional notes...',
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Lead",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await SecureStorage.getUserData();
      final leadData = LeadItem(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        propertyId: selectedProperty,
        resellerId: user?.user?.id ?? '',
        source: selectedSource,
        status: selectedStatus,
        stage: selectedStage,
        notes: noteController.text.trim(),
      );

      final success = await controller.createLead(leadData);
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Lead Uploaded Successfully",
          contentType: ContentType.success,
        );
        Get.back();
      }
    }
  }
}
