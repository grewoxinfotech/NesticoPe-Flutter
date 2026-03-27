import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/builder/view/additional_deatil/additional_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../controller/builder_form_controller.dart';

class UploadMediaScreen extends GetView<ProjectWizardController> {


  UploadMediaScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildProjectImagesSection(),
          const SizedBox(height: 16),
          _buildProjectVideosSection(),

          const SizedBox(height: 16),
          _buildProjectDocumentsSection(),
          const SizedBox(height: 16),
          _buildProjectBrochureSection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProjectImagesSection() {
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
                    buildBuilderDefaultHeaderText('Project Images'),
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
                        controller.project.value.imageList.isEmpty
                            ? ColorRes.orangeColor.shade50
                            : ColorRes.success.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.project.value.imageList.length}/5',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          controller.project.value.imageList.isEmpty
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
                controller.project.value.imageList.isEmpty
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
                            ...controller.project.value.imageList
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final filePath = entry.value;
                                  return _buildMediaThumbnail(
                                    filePath: filePath,
                                    isVideo: false,
                                    onRemove:
                                        () => controller.removeBuilderImage(
                                          index,
                                        ),
                                  );
                                }),
                            if (controller.project.value.imageList.length < 5)
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
                      'Project Videos',
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
                    '${controller.project.value.videoList.length}/5',
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
                controller.project.value.videoList.isEmpty
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
                            ...controller.project.value.videoList
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final filePath = entry.value;
                                  return _buildMediaThumbnail(
                                    filePath: filePath,
                                    isVideo: true,
                                    onRemove:
                                        () => controller.removeBuilderVideo(
                                          index,
                                        ),
                                  );
                                }),
                            if (controller.project.value.videoList.length < 5)
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

  Widget _buildProjectBrochureSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor[200]!),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 20,
                  color:
                      (controller.uploadBrocherPath.value.isNotEmpty)
                          ? ColorRes.primary
                          : ColorRes.error[700],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Brochure',
                            style: TextStyle(
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          Text(
                            'Optional • PDF only • Max 10MB',
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.leadGreyColor[600],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      (controller.uploadBrocherPath.value.isNotEmpty)
                          ? IconButton(
                            onPressed: () {
                              controller.removeBuilderBrocher();
                            },
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: ColorRes.error,
                              size: 20,
                            ),
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            (controller.project.value.brochure?.isNotEmpty ?? false)
                ? InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorRes.primary, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        // PDF Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.picture_as_pdf,
                            size: 28,
                            color: ColorRes.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // File Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uploaded Document',
                                style: TextStyle(
                                  fontSize: AppFontSizes.caption,
                                  fontWeight: AppFontWeights.medium,
                                  color: ColorRes.primary.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.uploadBrocherName.value,
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // View/Action Icon
                        InkWell(
                          onTap: () async {
                            await controller.pdfPreviewByDefaultApp(
                              controller.project.value.brochure ?? '',
                            );
                          },

                          child: Icon(
                            Icons.visibility_outlined,
                            size: 22,
                            color: ColorRes.primary.withOpacity(0.98),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : _buildUploadBox(
                  onTap: controller.pickFileInBuilder,
                  icon: Icons.cloud_upload_outlined,
                  title: 'Upload your files here',
                  subtitle: 'Browse',
                  color: ColorRes.error,
                ),
          ],
        ),
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

  /// Generates a safe video thumbnail to a temporary directory.

  //
  // Widget _buildMediaThumbnail({
  //   required String filePath,
  //   bool isVideo = false,
  //   String? videoName,
  //   required VoidCallback onRemove,
  // }) {
  //   return Stack(
  //     children: [
  //       Container(
  //         width: 90,
  //         height: 90,
  //         decoration: BoxDecoration(
  //           color: isVideo ? Colors.purple[50] : Colors.grey[100],
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(
  //             color: isVideo ? Colors.purple[200]! : Colors.grey[300]!,
  //           ),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(10),
  //           child: isVideo
  //               ? FutureBuilder<String?>(
  //             future: VideoThumbnail.thumbnailFile(
  //               video: filePath,
  //               imageFormat: ImageFormat.JPEG,
  //               maxWidth: 128, // thumbnail width
  //               quality: 50,
  //             ),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Center(
  //                   child: CircularProgressIndicator(strokeWidth: 2),
  //                 );
  //               }
  //               if (!snapshot.hasData || snapshot.data == null) {
  //                 return const Center(child: Icon(Icons.videocam_off));
  //               }
  //               return Stack(
  //                 fit: StackFit.expand,
  //                 children: [
  //                   Image.file(
  //                     File(snapshot.data!),
  //                     fit: BoxFit.cover,
  //                   ),
  //                   const Center(
  //                     child: Icon(
  //                       Icons.play_circle_fill,
  //                       color: ColorRes.white,
  //                       size: 32,
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           )
  //               : Image.file(
  //             File(filePath),
  //             fit: BoxFit.cover,
  //             errorBuilder: (_, __, ___) =>
  //             const Icon(Icons.broken_image, size: 32),
  //           ),
  //         ),
  //       ),
  //       // Remove button
  //       Positioned(
  //         top: 4,
  //         right: 4,
  //         child: GestureDetector(
  //           onTap: onRemove,
  //           child: Container(
  //             padding: const EdgeInsets.all(4),
  //             decoration: BoxDecoration(
  //               color: Colors.red[600],
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.close, size: 12, color: ColorRes.white),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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

  // Widget _buildProjectDocumentsSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: ColorRes.white,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: ColorRes.leadGreyColor.shade200!),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.folder_outlined,
  //               size: 20,
  //               color: ColorRes.success.shade700,
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   buildBuilderDefaultHeaderText('Project Documents'),
  //                   Text(
  //                     'Optional • Max 2 files • PDF, DOC, DOCX',
  //                     style: TextStyle(
  //                       fontSize: AppFontSizes.caption,
  //                       color: ColorRes.leadGreyColor.shade600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Obx(
  //               () => Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 8,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color:
  //                       controller.project.value.documentList.isEmpty
  //                           ? ColorRes.leadGreyColor.shade100
  //                           : ColorRes.success.shade50,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Text(
  //                   '${controller.project.value.documentList.length}/2',
  //                   style: TextStyle(
  //                     fontSize: AppFontSizes.caption,
  //                     fontWeight: AppFontWeights.semiBold,
  //                     color:
  //                         controller.project.value.documentList.isEmpty
  //                             ? ColorRes.leadGreyColor.shade700
  //                             : ColorRes.success.shade700,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Obx(
  //           () =>
  //               controller.project.value.documentList.isEmpty
  //                   ? _buildUploadBox(
  //                     onTap: controller.builderDocumentPicker,
  //                     icon: Icons.cloud_upload_outlined,
  //                     title: 'Upload your documents here',
  //                     subtitle: 'Browse',
  //                     color: ColorRes.success,
  //                   )
  //                   : Column(
  //                     children: [
  //                       ...controller.project.value.documentList
  //                           .asMap()
  //                           .entries
  //                           .map((entry) {
  //                             final index = entry.key;
  //                             final filePath = entry.value;
  //                             return _buildDocumentTile(
  //                               filePath: filePath,
  //                               index: index,
  //                               onRemove:
  //                                   () =>
  //                                       controller.removeBuilderDocument(index),
  //                               onView: () async {
  //                                 await controller.pdfPreviewByDefaultApp(
  //                                   filePath,
  //                                 );
  //                               },
  //                             );
  //                           }),
  //                       if (controller.project.value.documentList.length < 2)
  //                         const SizedBox(height: 12),
  //                       if (controller.project.value.documentList.length < 2)
  //                         InkWell(
  //                           onTap: controller.builderDocumentPicker,
  //                           borderRadius: BorderRadius.circular(12),
  //                           child: Container(
  //                             width: double.infinity,
  //                             padding: const EdgeInsets.all(16),
  //                             decoration: BoxDecoration(
  //                               color: ColorRes.success.shade50!.withOpacity(
  //                                 0.3,
  //                               ),
  //                               borderRadius: BorderRadius.circular(12),
  //                               border: Border.all(
  //                                 color: ColorRes.success.shade300!,
  //                                 width: 1.5,
  //                                 style: BorderStyle.solid,
  //                               ),
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Icon(
  //                                   Icons.add_circle_outline,
  //                                   size: 20,
  //                                   color: ColorRes.success.shade700,
  //                                 ),
  //                                 const SizedBox(width: 8),
  //                                 Text(
  //                                   'Add More Documents',
  //                                   style: TextStyle(
  //                                     fontSize: AppFontSizes.medium,
  //                                     fontWeight: AppFontWeights.semiBold,
  //                                     color: ColorRes.success.shade700,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
          /// 🔹 Mandatory documents info (WEB → MOBILE)

          /// 🔹 Header + counter
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
                    buildBuilderDefaultHeaderText('Project Documents'),
                    Text(
                      'PDF, DOC, JPG, PNG • Max 5 files • 5MB each',
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
                        controller.project.value.documentList.isEmpty
                            ? ColorRes.leadGreyColor.shade100
                            : ColorRes.success.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.project.value.documentList.length}/5',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          controller.project.value.documentList.isEmpty
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
                        'Mandatory Documents for Builder Project',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildBulletText('RERA Registration Certificate'),
                      _buildBulletText('Approved Layout / Building Plan'),
                      _buildBulletText('Floor Plan'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Upload box / Documents list
          Obx(
            () =>
                controller.project.value.documentList.isEmpty
                    ? _buildUploadBox(
                      onTap: controller.builderDocumentPicker,
                      icon: Icons.cloud_upload_outlined,
                      title: 'Upload property documents',
                      subtitle: 'Tap to browse files',
                      color: ColorRes.success,
                    )
                    : Column(
                      children: [
                        ...controller.project.value.documentList
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final filePath = entry.value;

                              return _buildDocumentTile(
                                filePath: filePath,
                                index: index,
                                onRemove:
                                    () =>
                                        controller.removeBuilderDocument(index),
                                onView: () async {
                                  await controller.pdfPreviewByDefaultApp(
                                    filePath,
                                  );
                                },
                              );
                            }),

                        if (controller.project.value.documentList.length < 5)
                          const SizedBox(height: 12),

                        if (controller.project.value.documentList.length < 5)
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
