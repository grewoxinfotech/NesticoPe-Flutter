import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/add_property/controller/create_property_controller.dart';
import 'package:nesticope_app/modules/add_property/view/create_property.dart';
import 'package:nesticope_app/modules/search_property/model/search_model.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

class RentAdditionalDetail extends StatelessWidget {
  final CreatePropertyController controller;
  final GlobalKey<FormState>? formKey;

  const RentAdditionalDetail({
    super.key,
    required this.controller,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final sell_rent_facing = [
      'North',
      'South',
      'East',
      'West',
      'North-East',
      'North-West',
      'South-East',
      'South-West',
    ];

    return Obx(() {
      return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. Facing
            buildSectionTitle("Facing"),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    sell_rent_facing.map((option) {
                      return buildChoice(
                        title: option,
                        selected: controller.rent_facing.value == option,
                        onTap: () {
                          controller.setValue(controller.rent_facing, option);
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Address
            buildSectionTitle("Address"),
            const SizedBox(height: 8),
            buildTextField(
              "Enter Address",
              Icons.location_on_outlined,
              controller.sell_rent_Address,
              maxLines: 3,
              minLines: 1,
              isEnable: false,
              onTap: () async {
                Prediction selectedCity = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CommonSearchField(
                          onCitySelected: (city) {
                            Navigator.pop(context, city);
                          },
                          isFromAddProperty: true,
                          initialSearchText: controller.sell_rent_Address.text,
                        ),
                  ),
                );

                controller.sell_rent_Address.text =
                    selectedCity.description ?? '';
              },
            ),
            const SizedBox(height: 16),

            // 3. Servent Room
            buildSectionTitle("Servent Room"),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    ['Yes', 'No'].map((option) {
                      return buildChoice(
                        title: option,
                        selected:
                            controller.sell_rent_Servent_Room.value == option,
                        onTap: () {
                          controller.setValue(
                            controller.sell_rent_Servent_Room,
                            option,
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Sub-Registrar Office (SRO) Name
            buildSectionTitle("Sub-Registrar Office (SRO) Name"),
            const SizedBox(height: 8),
            buildTextField(
              "Enter SRO Name",
              Icons.apartment_outlined,
              controller.subRegistrarOffice,
            ),
            const SizedBox(height: 16),

            // 5. Sale Deed Document Number
            buildSectionTitle("Sale Deed Document Number"),
            const SizedBox(height: 8),
            buildTextField(
              "Enter Sale Deed Document Number",
              Icons.edit_document,
              controller.saleDeedDocumentNumber,
            ),
            const SizedBox(height: 16),

            // 6. Year of Registration
            buildSectionTitle("Year of Registration"),
            const SizedBox(height: 8),
            buildTextField(
              "Enter year of registration",
              Icons.edit_document,
              controller.yearOfRegistration,
              isEnable: false,
              onTap: () async {
                FocusScope.of(context).unfocus();
                DateTime now = DateTime.now();

                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(1),
                  lastDate: now,
                  initialDatePickerMode: DatePickerMode.year,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: ColorRes.primary,
                          onPrimary: ColorRes.white,
                          onSurface: ColorRes.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: ColorRes.primary,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  controller.yearOfRegistration.text = picked.year.toString();
                }
              },
            ),

            if (controller.rent_propertyType.value.toLowerCase() == "plot" ||
                controller.rent_propertyType.value.toLowerCase() ==
                    "agricultural land") ...[
              const SizedBox(height: 16),
              buildSectionTitle("Survey Number"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Survey Number",
                Icons.app_registration,
                isPhoneKey: true,
                controller.surveyNumberPlotAndLand,
              ),
              const SizedBox(height: 16),
              buildSectionTitle("Khata Number"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Khata Number",
                Icons.numbers_outlined,
                isPhoneKey: true,
                controller.khataNumberPlotAndLand,
              ),
            ],
            const SizedBox(height: 16),

            // 7. RERA ID
            buildSectionTitle('RERA ID'),
            const SizedBox(height: 8),
            buildTextField(
              "Enter RERA id",
              Icons.description_outlined,
              controller.sell_Rera_Id,
            ),
            const SizedBox(height: 16),

            // 8. Property Description
            buildSectionTitle('Property Description'),
            const SizedBox(height: 8),
            buildTextField(
              "Write about your property",
              Icons.description_outlined,
              controller.sell_rent_propertyDescriptionController,
              maxLines: 5,
              minLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              "Tell us more about the specific features of your property.",
              style: TextStyle(
                fontSize: AppFontSizes.extraSmall,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // 9. Property Documents (Optional)
            _buildProjectDocumentsSection(),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildProjectDocumentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade200!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.folder_outlined,
                size: 20,
                color: ColorRes.success.shade700,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Documents (Optional)',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                    Text(
                      'Max 5 files • PDF, DOC, DOCX',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        controller.documentList.isEmpty
                            ? ColorRes.leadGreyColor.shade100
                            : ColorRes.success.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.documentList.length}/5',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          controller.documentList.isEmpty
                              ? ColorRes.leadGreyColor.shade700
                              : ColorRes.success.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorRes.primary.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20, color: ColorRes.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Optional Documents for Property',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (controller.selectedIndex.value.toLowerCase() ==
                              'plot' ||
                          controller.selectedIndex.value.toLowerCase() ==
                              'agriculture_land' ||
                          controller.rent_propertyType.value.toLowerCase() ==
                              'plot' ||
                          controller.rent_propertyType.value.toLowerCase() ==
                              'agricultural land') ...[
                        _buildBulletText('Khata Copy'),
                        _buildBulletText('Patta'),
                        _buildBulletText('7/12'),
                        _buildBulletText('RTC'),
                        _buildBulletText(
                          'Ownership Proof Document (PDF / Image)',
                        ),
                      ] else ...[
                        _buildBulletText(
                          'Ownership Proof Document (PDF / Image)',
                        ),
                        _buildBulletText('Registered Sale Deed Copy (PDF)'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () =>
                controller.documentList.isEmpty
                    ? _buildUploadBox(
                      onTap: controller.builderDocumentPicker,
                      icon: Icons.cloud_upload_outlined,
                      title: 'Upload your documents here',
                      subtitle: 'Browse',
                      color: ColorRes.success,
                    )
                    : Column(
                      children: [
                        ...controller.documentList.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final filePath = entry.value;
                          return _buildDocumentTile(
                            filePath: filePath,
                            index: index,
                            onRemove:
                                () => controller.removeBuilderDocument(index),
                            onView: () async {
                              await controller.pdfPreviewByDefaultApp(filePath);
                            },
                          );
                        }),
                        if (controller.documentList.length < 5)
                          const SizedBox(height: 12),
                        if (controller.documentList.length < 5)
                          InkWell(
                            onTap: controller.builderDocumentPicker,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ColorRes.success.shade50.withOpacity(
                                  0.3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: ColorRes.success.shade300,
                                  width: 1.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                    color: ColorRes.success.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Add More Documents',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.success.shade700,
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
    );
  }

  Widget _buildUploadBox({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required MaterialColor color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color[600]),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: color[700],
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.leadGreyColor.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile({
    required String filePath,
    required int index,
    required VoidCallback onRemove,
    required VoidCallback onView,
  }) {
    final fileName = filePath.split('/').last;
    final fileExtension = fileName.split('.').last.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorRes.success.shade50!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.success.shade200!),
      ),
      child: Row(
        children: [
          // File Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorRes.success.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getDocumentIcon(fileExtension),
              size: 24,
              color: ColorRes.success.shade700,
            ),
          ),
          const SizedBox(width: 12),
          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  fileExtension,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.success.shade600,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          // View Button
          IconButton(
            onPressed: onView,
            icon: Icon(
              Icons.visibility_outlined,
              size: 20,
              color: ColorRes.success.shade700,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // Delete Button
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete_outline_outlined,
              size: 20,
              color: ColorRes.error,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String extension) {
    switch (extension) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOC':
      case 'DOCX':
        return Icons.description;
      case 'TXT':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }
}
