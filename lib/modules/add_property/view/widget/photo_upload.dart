import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/add_property/view/create_property.dart'
    hide Obx;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../builder/view/additional_deatil/additional_detail.dart';
import '../../../builder/view/media/upload_media_screen.dart';
import '../../controller/create_property_controller.dart';

// class PhotoUpload extends StatelessWidget {
//   final CreatePropertyController controller;
//
//   const PhotoUpload({super.key, required this.controller, required GlobalKey<FormState> formKey});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       print(
//         "vfsdgytgfgsdytfgydy ===========${controller.propertyType.value}  djhfiuw ${controller.lookingTo.value}",
//       );
//
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 12),
//           buildSectionTitle('Upload Photos'),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton.icon(
//                 onPressed:
//                     controller.selectedImages.length >= controller.maxImages
//                         ? null
//                         : () =>  controller.pickImagesFromGallery(),
//                 icon: Icon(
//                   Icons.add_a_photo,
//                   color:
//                       controller.selectedImages.length >= controller.maxImages
//                           ? ColorRes.leadGreyColor
//                           : ColorRes.white,
//                 ),
//                 label: Text(
//                   controller.selectedImages.length >= controller.maxImages
//                       ? "Max ${controller.maxImages} reached"
//                       : "Add Photo",
//                   style: TextStyle(
//                     color:
//                         controller.selectedImages.length >= controller.maxImages
//                             ? ColorRes.leadGreyColor
//                             : ColorRes.white,
//                     fontWeight: AppFontWeights.medium,
//                     fontSize: AppFontSizes.small,
//                     // fontSize: 12,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8,
//                     horizontal: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   backgroundColor:
//                       controller.selectedImages.length >= controller.maxImages
//                           ? ColorRes.leadGreyColor
//                           : Theme.of(context).primaryColor,
//                 ),
//               ),
//               Text(
//                 "${controller.selectedImages.length} / ${controller.maxImages} photos selected",
//                 style: TextStyle(color: ColorRes.leadGreyColor.shade600, fontSize: AppFontSizes.small),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           controller.selectedImages.isEmpty
//               ? const Text(
//                 "No images selected yet.",
//                 style: TextStyle(color: ColorRes.leadGreyColor),
//               )
//               : Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: List.generate(controller.selectedImages.length, (
//                   index,
//                 ) {
//                   final img = controller.selectedImages[index];
//                   return Stack(
//                     children: [
//                       Container(
//                         width: 150,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color:
//                                 img.isCover
//                                     ? Theme.of(context).primaryColor
//                                     : ColorRes.leadGreyColor.shade300,
//                             width: img.isCover ? 2 : 1,
//                           ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Stack(
//                             children: [
//                               Image.file(
//                                 File(img.path),
//                                 width: double.infinity,
//                                 height: double.infinity,
//                                 fit: BoxFit.cover,
//                               ),
//                               // Label overlay at bottom, tap to change label
//                               // Positioned(
//                               //   bottom: 0,
//                               //   left: 0,
//                               //   right: 0,
//                               //   child: GestureDetector(
//                               //     onTap:
//                               //         () => showLabelBottomSheet(
//                               //           context,
//                               //           index,
//                               //           controller,
//                               //         ),
//                               //     child: Container(
//                               //       padding: const EdgeInsets.symmetric(
//                               //         vertical: 6,
//                               //         horizontal: 8,
//                               //       ),
//                               //       decoration: BoxDecoration(
//                               //         color: ColorRes.textColor,
//                               //         borderRadius: const BorderRadius.only(
//                               //           bottomLeft: Radius.circular(12),
//                               //           bottomRight: Radius.circular(12),
//                               //         ),
//                               //       ),
//                               //       child: Row(
//                               //         mainAxisAlignment:
//                               //             MainAxisAlignment.spaceBetween,
//                               //         children: [
//                               //           Expanded(
//                               //             child: Text(
//                               //               img.label.isEmpty
//                               //                   ? "Set Label"
//                               //                   : img.label,
//                               //               overflow: TextOverflow.ellipsis,
//                               //               maxLines: 1,
//                               //               style:  TextStyle(
//                               //                 color: ColorRes.white,
//                               //                 fontSize: AppFontSizes.medium,
//                               //                 // fontSize: 14,
//                               //                 fontWeight: AppFontWeights.medium,
//                               //               ),
//                               //             ),
//                               //           ),
//                               //           // if (img.isCover)
//                               //           //   const Icon(
//                               //           //     Icons.star,
//                               //           //     color: Colors.amber,
//                               //           //     size: 18,
//                               //           //   ),
//                               //         ],
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Remove button
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: GestureDetector(
//                           onTap: () => controller.removeImageByPath(img.path),
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: ColorRes.blackShade54,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.close,
//                               size: 20,
//                               color: ColorRes.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//               ),
//           const SizedBox(height: 16),
//         ],
//       );
//     });
//   }
// }

// void showLabelBottomSheet(
//   BuildContext context,
//   int imageIndex,
//   CreatePropertyController controller,
// ) {
//   //rent
//   // Temp selected label stored in controller
//
//   controller.labelOfPhoto.value =
//       controller.selectedImages[imageIndex].label.isEmpty
//           ? "Others"
//           : controller.selectedImages[imageIndex].label;
//
//   Get.bottomSheet(
//     Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Select photo label",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//
//             // Wrap inside Obx so it reacts
//             Obx(() {
//               return Wrap(
//                 spacing: 10,
//                 children:
//                     controller.labelsPhoto.map((label) {
//                       final isSelected = controller.labelOfPhoto.value == label;
//                       return ChoiceChip(
//                         label: Text(label),
//                         side: BorderSide(
//                           color:
//                               isSelected
//                                   ? ColorRes.transparentColor
//                                   : ColorRes.leadGreyColor.shade300,
//                           width: 1,
//                         ),
//                         selected: isSelected,
//                         onSelected: (_) {
//                           controller.labelOfPhoto.value = label;
//                           controller.setImageLabel(imageIndex, label);
//                           Get.back(); // Close the bottom sheet immediately
//                         },
//                         selectedColor:
//                             isSelected
//                                 ? ColorRes.primary.withOpacity(0.1)
//                                 : ColorRes.white,
//                         labelStyle: TextStyle(
//                           color:
//                               isSelected
//                                   ? ColorRes.primary
//                                   : ColorRes.textPrimary,
//                           fontWeight: AppFontWeights.medium,
//                           fontSize: AppFontSizes.small,
//                           // fontSize: 12,
//                         ),
//                       );
//                     }).toList(),
//               );
//             }),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// void showImageSourceSheet(
//   BuildContext context,
//   CreatePropertyController controller,
// ) {
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder:
//         (context) => SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Pick from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   controller.pickImagesFromGallery();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   controller.pickImageFromCamera();
//                 },
//               ),
//             ],
//           ),
//         ),
//   );
// }

class PhotoUpload extends StatelessWidget {
  final CreatePropertyController controller;

  const PhotoUpload({
    super.key,
    required this.controller,
    required GlobalKey<FormState> formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(
        "vfsdgytgfgsdytfgydy ===========${controller.propertyType.value}  djhfiuw ${controller.lookingTo.value}",
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildPropertyImagesSection(),
          const SizedBox(height: 16),
          _buildProjectVideosSection(),
          const SizedBox(height: 16),
          _buildProjectDocumentsSection(),
          const SizedBox(height: 80),
        ],
      );
    });
  }

  Widget _buildPropertyImagesSection() {
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
                Icons.image_outlined,
                size: 20,
                color: ColorRes.blueColor.shade700,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBuilderDefaultHeaderText('Property Images'),
                    Text(
                      'Required • Max 5MB each',
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
                        controller.imageList.value.isEmpty
                            ? ColorRes.orangeColor.shade50
                            : ColorRes.success.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.imageList.value.length}/5',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          controller.imageList.value.isEmpty
                              ? ColorRes.orangeColor.shade700
                              : ColorRes.success.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () =>
                controller.imageList.value.isEmpty
                    ? _buildUploadBox(
                      onTap: controller.builderImagePicker,
                      icon: Icons.cloud_upload_outlined,
                      title: 'Upload your files here',
                      subtitle: 'Browse',
                      color: ColorRes.blueColor,
                    )
                    : Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...controller.imageList.value.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final filePath = entry.value;
                              return _buildMediaThumbnail(
                                filePath: filePath,
                                isVideo: false,
                                onRemove:
                                    () => controller.removeBuilderImage(index),
                              );
                            }),
                            if (controller.imageList.value.length < 5)
                              _buildAddMoreButton(
                                onTap: controller.builderImagePicker,
                                icon: Icons.add_photo_alternate_outlined,
                              ),
                          ],
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectVideosSection() {
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
                Icons.videocam_outlined,
                size: 20,
                color: ColorRes.purpleColor[700],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Videos',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                    Text(
                      'Optional • Max 50MB each',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
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
                    color: ColorRes.leadGreyColor[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.videoList.value.length}/5',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.leadGreyColor[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () =>
                controller.videoList.value.isEmpty
                    ? _buildUploadBox(
                      onTap: controller.builderVideoPicker,
                      icon: Icons.cloud_upload_outlined,
                      title: 'Upload your files here',
                      subtitle: 'Browse',
                      color: ColorRes.purpleColor,
                    )
                    : Column(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...controller.videoList.value.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final filePath = entry.value;
                              return _buildMediaThumbnail(
                                filePath: filePath,
                                isVideo: true,
                                onRemove:
                                    () => controller.removeBuilderVideo(index),
                              );
                            }),
                            if (controller.videoList.value.length < 5)
                              _buildAddMoreButton(
                                onTap: controller.builderVideoPicker,
                                icon: Icons.add_photo_alternate_outlined,
                              ),
                          ],
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

  Widget _buildMediaThumbnail({
    required String filePath,
    bool isVideo = false,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color:
                isVideo
                    ? ColorRes.purpleColor[50]
                    : ColorRes.leadGreyColor[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isVideo
                      ? ColorRes.purpleColor[200]!
                      : ColorRes.leadGreyColor[300]!,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                isVideo
                    ? FutureBuilder<String?>(
                      future: generateVideoThumbnail(filePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        final thumbPath = snapshot.data;
                        if (thumbPath == null ||
                            !File(thumbPath).existsSync()) {
                          return const Center(
                            child: Icon(
                              Icons.videocam,
                              size: 32,
                              color: ColorRes.leadGreyColor,
                            ),
                          );
                        }
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(File(thumbPath), fit: BoxFit.cover),
                            const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: ColorRes.white,
                                size: 32,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                    // : Image.file(
                    //   File(filePath),
                    //   fit: BoxFit.cover,
                    //   errorBuilder:
                    //       (_, __, ___) =>
                    //           const Icon(Icons.broken_image, size: 32),
                    // ),
                    : Uri.tryParse(filePath)?.isAbsolute ?? false
                    ? Image.network(
                      filePath,
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 32),
                    )
                    : Image.file(
                      File(filePath),
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 32),
                    ),
          ),
        ),
        // ❌ remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: ColorRes.error[600],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: ColorRes.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorRes.leadGreyColor[300]!, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 28,
              color: ColorRes.blueColor[600],
            ),
            const SizedBox(height: 4),
            Text(
              'Add More',
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDocumentsSection() {
    print("jbdvksjfdbsknblkvfdjnvglskd: ${controller.selectedIndex.value}");
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
                    buildBuilderDefaultHeaderText('Property Documents'),
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
                        controller.documentList.value.isEmpty
                            ? ColorRes.leadGreyColor.shade100
                            : ColorRes.success.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.documentList.value.length}/5',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          controller.documentList.value.isEmpty
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
                        'Mandatory Documents for Property',
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
                              'agriculture_land') ...[
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
                controller.documentList.value.isEmpty
                    ? _buildUploadBox(
                      onTap: controller.builderDocumentPicker,
                      icon: Icons.cloud_upload_outlined,
                      title: 'Upload your documents here',
                      subtitle: 'Browse',
                      color: ColorRes.success,
                    )
                    : Column(
                      children: [
                        ...controller.documentList.value.asMap().entries.map((
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
                        if (controller.documentList.value.length < 5)
                          const SizedBox(height: 12),
                        if (controller.documentList.value.length < 5)
                          InkWell(
                            onTap: controller.builderDocumentPicker,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ColorRes.success.shade50!.withOpacity(
                                  0.3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: ColorRes.success.shade300!,
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

Future<String?> generateVideoThumbnail(String videoPath) async {
  try {
    final tempDir = await getTemporaryDirectory();
    return await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 50,
    );
  } catch (e) {
    debugPrint('Thumbnail error: $e');
    return null;
  }
}
