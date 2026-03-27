import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_project_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contracto_project_model.dart';

class ContractorProjectPhotosScreen extends StatefulWidget {
  final ContractorProjectItem project;

  final String projectId;

  const ContractorProjectPhotosScreen({
    super.key,
    required this.project, required this.projectId,
  });

  @override
  State<ContractorProjectPhotosScreen> createState() =>
      _ContractorProjectPhotosScreenState();
}

class _ContractorProjectPhotosScreenState
    extends State<ContractorProjectPhotosScreen> {
  final ContractorProjectController controller=Get.find<ContractorProjectController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Project Photos",
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        backgroundColor: ColorRes.surface,
        elevation: 0.5,
      ),
      body: Obx(
        () {
          final project = controller.items.firstWhereOrNull(
                (p) => p.id == widget.projectId,
          );
          if (project == null) {
            return Center(child: Text('Project not found'));
          }
          return  SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotoSection(
                  title: "Before Photos",
                  key: "beforePhotos",
                  photos: project?.meta.beforePhoto??<ContractorProjectPhoto>[],
                  onUpload: () {
                    setState(() {
                    /*  controller.pickAndUploadPhotos(widget.projectId, 'before_photos',project.meta.beforePhoto.length);*/
                      controller.  showImagePickerOptions(
                        context,
                        projectId: widget.projectId,
                        key: "before_photos",
                        imageLength: project.meta.beforePhoto.length,
                      );
                    });
                  },
                ),
                /*  const SizedBox(height: 24),*/
                _buildPhotoSection(
                    title: "After Photos",
                    key: "afterPhotos",
                    photos:project.meta.afterPhoto,
                    onUpload: () {
                      setState(() {
                        controller.  showImagePickerOptions(
                          context,
                          projectId: widget.projectId,
                          key: "after_photos",
                          imageLength: project.meta.afterPhoto.length,
                        );
                        // controller.pickAndUploadPhotos(widget.projectId, 'after_photos',project.meta.afterPhoto.length);
                      });
                    }
                ),
              ],
            ),
          );
        }

      ),
    );
  }

  Widget _buildPhotoSection({
    required String title,
    required List<ContractorProjectPhoto> photos,
    required VoidCallback onUpload,
    required String key,
  }) {
    return StatefulBuilder(
builder: (context, setState) =>
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title (${photos.length}/3)',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textColor,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary, // your theme color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.upload, size: 18, color: Colors.white),
                label: const Text(
                  "Upload",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (photos.isEmpty)
            Container(
              height: 120,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorRes.leadGreyColor.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "No photos uploaded",
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textColor,
                ),
              ),
            )
          else
            _buildPhotoGrid(photos,
                key,
                widget.projectId),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(List<ContractorProjectPhoto> photos, String key, String projectId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photo.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  // 🔄 Shimmer while loading
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.grey.shade300,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),

            // 🗑️ Delete Button
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => _confirmDelete(photo, projectId, key),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> _confirmDelete(
      ContractorProjectPhoto photo,
      String projectId,
      String key,
      ) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text("Delete Photo"),
        content: const Text("Are you sure you want to delete this photo?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await controller. deleteProjectPhoto(
      projectId: projectId,
      photoId: photo.uid,
      key: key,
    );
  }

}
