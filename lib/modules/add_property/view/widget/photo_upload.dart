import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart'
    hide Obx;
import '../../controller/create_property_controller.dart';

class PhotoUpload extends StatelessWidget {
  final CreatePropertyController controller;

  const PhotoUpload({super.key, required this.controller, required GlobalKey<FormState> formKey});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(
        "vfsdgytgfgsdytfgydy ===========${controller.propertyType.value}  djhfiuw ${controller.lookingTo.value}",
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          buildSectionTitle('Upload Photos'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed:
                    controller.selectedImages.length >= controller.maxImages
                        ? null
                        : () => showImageSourceSheet(context, controller),
                icon: Icon(
                  Icons.add_a_photo,
                  color:
                      controller.selectedImages.length >= controller.maxImages
                          ? Colors.grey
                          : Colors.white,
                ),
                label: Text(
                  controller.selectedImages.length >= controller.maxImages
                      ? "Max ${controller.maxImages} reached"
                      : "Add Photo",
                  style: TextStyle(
                    color:
                        controller.selectedImages.length >= controller.maxImages
                            ? Colors.grey
                            : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  backgroundColor:
                      controller.selectedImages.length >= controller.maxImages
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                ),
              ),
              Text(
                "${controller.selectedImages.length} / ${controller.maxImages} photos selected",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          controller.selectedImages.isEmpty
              ? const Text(
                "No images selected yet.",
                style: TextStyle(color: Colors.grey),
              )
              : Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(controller.selectedImages.length, (
                  index,
                ) {
                  final img = controller.selectedImages[index];
                  return Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                img.isCover
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                            width: img.isCover ? 2 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Image.file(
                                File(img.path),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              // Label overlay at bottom, tap to change label
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap:
                                      () => showLabelBottomSheet(
                                        context,
                                        index,
                                        controller,
                                      ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            img.label.isEmpty
                                                ? "Set Label"
                                                : img.label,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        // if (img.isCover)
                                        //   const Icon(
                                        //     Icons.star,
                                        //     color: Colors.amber,
                                        //     size: 18,
                                        //   ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Remove button
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => controller.removeImageByPath(img.path),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}

void showLabelBottomSheet(
  BuildContext context,
  int imageIndex,
  CreatePropertyController controller,
) {
  //rent
  // Temp selected label stored in controller

  controller.labelOfPhoto.value =
      controller.selectedImages[imageIndex].label.isEmpty
          ? "Others"
          : controller.selectedImages[imageIndex].label;

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select photo label",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Wrap inside Obx so it reacts
            Obx(() {
              return Wrap(
                spacing: 10,
                children:
                    controller.labelsPhoto.map((label) {
                      final isSelected = controller.labelOfPhoto.value == label;
                      return ChoiceChip(
                        label: Text(label),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                          width: 1,
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          controller.labelOfPhoto.value = label;
                          controller.setImageLabel(imageIndex, label);
                          Get.back(); // Close the bottom sheet immediately
                        },
                        selectedColor:
                            isSelected
                                ? ColorRes.primary.withOpacity(0.1)
                                : Colors.white,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? ColorRes.primary
                                  : ColorRes.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}

extension on bool {
  operator [](String other) {}
}

void showImageSourceSheet(
  BuildContext context,
  CreatePropertyController controller,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromCamera();
                },
              ),
            ],
          ),
        ),
  );
}
