import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:intl/intl.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/reseller/reseller_success_stories/reseller_success_stories_model.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../controller/reseller_success_stories_controller/reseller_success_stories_controller.dart';

class AddResellerSuccessStoryScreen extends StatelessWidget {
  final ResellerSuccessItem? story;
  final bool isEditMode;

  AddResellerSuccessStoryScreen({
    super.key,
    this.story,
    this.isEditMode = false,
  });
  final ResellerSuccessStoryController controller = Get.put(
    ResellerSuccessStoryController(),
  );

  // final formKey = GlobalKey<FormState>();
  //
  // // --- Text Controllers ---
  // final TextEditingController titleController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController achievementController = TextEditingController();
  // final TextEditingController monthYearController = TextEditingController();
  // final TextEditingController totalDealsController = TextEditingController();
  // final TextEditingController totalValueController = TextEditingController();
  //
  // // --- Dropdown & Slider ---
  // final List<String> statusOptions = ['published', 'blocked', 'draft'];
  // String? selectedStatus = 'draft';
  // int rating = 0;
  //
  // DateTime? selectedMonthYear;

  // @override
  // void dispose() {
  //   controller.titleController.dispose();
  //   controller.descriptionController.dispose();
  //   controller.achievementController.dispose();
  //   controller.monthYearController.dispose();
  //   controller.totalDealsController.dispose();
  //   controller.totalValueController.dispose();
  //   super.dispose();
  // }

  Future<void> _pickMonthYear(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedMonthYear.value ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "Select Month and Year",
      fieldHintText: "Month/Year",
    );

    if (picked != null) {
      controller.selectedMonthYear.value = picked;
      controller.monthYearController.text = DateFormat(
        'MMMM yyyy',
      ).format(picked);
    }
  }

  Future<void> _submit() async {
    if (!controller.formKey.currentState!.validate()) return;

    final story = ResellerSuccessItem(
      resellerId: "",
      id: '',
      title: controller.titleController.text.trim(),
      description: controller.descriptionController.text.trim(),
      achievement: controller.achievementController.text.trim(),
      monthYear: controller.selectedMonthYear.value ?? DateTime.now(),
      totalDeals:
          int.tryParse(controller.totalDealsController.text.trim()) ?? 0,
      totalValue: controller.totalValueController.text.trim(),
      rating: controller.rating.value,
      status: controller.selectedStatus.value ?? 'draft',
    );

    final success = await controller.createStory(
      story,
      imageFilePath:
          controller.imagePath.value != null
              ? controller.imagePath.value!.path
              : null,
    ); // you can implement API call in controller
    if (!success) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Failed To Create Story",
        contentType: ContentType.failure,
      );
      return;
    }
    Get.back();

    controller.resetForm();
  }

  Future<void> _update() async {
    if (!controller.formKey.currentState!.validate()) return;

    final data = ResellerSuccessItem(
      resellerId: story?.resellerId ?? "",
      id: story?.id ?? '',
      title: controller.titleController.text.trim(),
      description: controller.descriptionController.text.trim(),
      achievement: controller.achievementController.text.trim(),
      monthYear: controller.selectedMonthYear.value ?? DateTime.now(),
      image: controller.imagePath.value?.path,
      totalDeals:
          int.tryParse(controller.totalDealsController.text.trim()) ?? 0,
      totalValue: controller.totalValueController.text.trim(),
      rating: controller.rating.value,
      status: controller.selectedStatus.value ?? 'draft',
      createdAt: story?.createdAt,
      createdBy: story?.createdBy,
      updatedAt: DateTime.now(),
      updatedBy: null,
    );

    final success = await controller.updateStory(
      story?.id ?? '',
      data,
      imageFilePath:
          controller.imagePath.value != null
              ? controller.imagePath.value!.path
              : null,
    ); // you can implement API call in controller
    if (!success) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Failed To Create Story",
        contentType: ContentType.failure,
      );
      return;
    }
    Get.back();

    controller.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    if (isEditMode && story != null) {
      controller.populateForm(story!);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Update Success Story" : "Add Success Story"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Title ---
              NesticoPeTextField(
                title: "Title",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.titleController,
                isRequired: true,
                hintText: "Enter story title",
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 16),

              // --- Description ---
              NesticoPeTextField(
                title: "Description",
                controller: controller.descriptionController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                isRequired: true,
                hintText: "Enter story description",
                maxLines: 3,
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? "Description is required"
                            : null,
              ),
              const SizedBox(height: 16),

              // --- Achievement ---
              NesticoPeTextField(
                title: "Achievement",
                controller: controller.achievementController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                hintText: "Enter main achievement",
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? "Achievement is required"
                            : null,
              ),
              const SizedBox(height: 16),

              // --- Month/Year ---
              NesticoPeTextField(
                title: "Month / Year",
                controller: controller.monthYearController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                hintText: "Select month & year",
                readOnly: true,
                onTap: () => _pickMonthYear(context),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? "Please select month and year"
                            : null,
              ),

              const SizedBox(height: 16),

              // --- Status Dropdown ---
              Text(
                "Status *",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => NesticoPeDropdownField<String>(
                  value: controller.selectedStatus.value,

                  items:
                      controller.statusOptions
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                  onChanged: (val) => controller.selectedStatus.value = val,
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? "Please select a status"
                              : null,
                ),
              ),
              const SizedBox(height: 16),

              // --- Total Deals ---
              NesticoPeTextField(
                title: "Total Deals",
                controller: controller.totalDealsController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                hintText: "Enter total number of deals",
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter total deals";
                  if (int.tryParse(val) == null) return "Enter valid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Total Value ---
              NesticoPeTextField(
                title: "Total Value (₹)",
                controller: controller.totalValueController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                hintText: "Enter total sales value",
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter total value";
                  if (double.tryParse(val) == null) return "Enter valid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- Rating Slider ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Rating (0 - 5)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    controller.rating.value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Slider(
                  value: controller.rating.value.toDouble(),
                  // Slider needs a double
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: controller.rating.value.toString(),
                  onChanged: (value) => controller.rating.value = value.round(),
                  // convert back to int
                ),
              ),
              const SizedBox(height: 24),

              Obx(
                () => GestureDetector(
                  onTap: controller.builderImagePicker,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Get.theme.dividerColor),
                    ),
                    child: _buildImageContent(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Submit Button ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      isEditMode
                          ? controller.isLoading.value
                              ? "Updating..."
                              : "Update Story"
                          : controller.isLoading.value
                          ? "Creating..."
                          : "Create Story",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : isEditMode
                            ? _update
                            : _submit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    final file = controller.imagePath.value; // Rxn<File>
    final networkImage = story?.image; // URL from API if edit mode

    // 🧠 Case 1: No image (neither picked nor from network)
    if ((file == null || file.path.isEmpty) &&
        (networkImage == null || networkImage.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, size: 40, color: ColorRes.primary),
            const SizedBox(height: 8),
            Text(
              "Add Image",
              style: TextStyle(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // 🧠 Case 2: Local image selected (from gallery)
    if (file != null && file.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    // 🧠 Case 3: Network image (editing existing story)
    if (networkImage != null && networkImage.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomImage(
          type: CustomImageType.network,
          src: networkImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    // Default fallback (shouldn’t reach here)
    return const SizedBox.shrink();
  }
}
