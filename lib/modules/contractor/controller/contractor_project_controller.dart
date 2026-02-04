import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import 'package:housing_flutter_app/data/network/contractor/service/project/contractor_project_service.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../widgets/location_permission/location_permission_method.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';

class ContractorProjectController
    extends PaginatedController<ContractorProjectItem> {
  RxMap<String, String> filters = <String, String>{}.obs;
  final expandedCards = <String, bool>{}.obs;
  RxString changeStatus = ''.obs;
  final txtTime = TextEditingController();
  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  RxString statusChange = "".obs;
  DateTime? selectedDate;

  void toggleCard(String id) {
    expandedCards[id] = !(expandedCards[id] ?? false);
    print("toggle Card $id");
    expandedCards.refresh();
  }

  Future<void> fetchContractorProjects() async {
    try {
      isLoading.value = true;
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final response = await ContractorProjectService.contractorProjectService
          .getContractorProjectData(contractorId: userId, filter: filters);

      if (response.items.isNotEmpty) {
        items.assignAll(response.items); // ✅ reactive update
        items.refresh(); // ensure UI rebuild
        log("✅ Projects list updated: ${items.length} projects loaded");
      } else {
        items.clear();
      }
    } catch (e, s) {
      log("❌ Error fetching projects: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    txtStartDate.clear();
    txtEndDate.clear();
    startDate = DateTime.now();
    endDate = DateTime.now();

    statusChange.value = '';
    // update();
  }

  Future<void> refreshProject() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  final picker = ImagePicker();

  bool isUploading = false;

  Future<void> pickAndUploadPhotos(
    String projectId,
    String key,
    int imageLength,
  ) async {
    bool isGranted = await requestGalleryPermission();
    if (!isGranted) return;

    if (isUploading) return; // Prevent multiple uploads

    const int maxImages = 3;
    final remaining = maxImages - imageLength;

    if (remaining <= 0) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "⚠️ You have already uploaded the maximum of 3 photos.",
          ),
        ),
      );
      return;
    }

    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    // Restrict new picks to remaining count
    if (picked.length > remaining) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            "⚠️ You can upload only $remaining more photo${remaining > 1 ? 's' : ''}.",
          ),
        ),
      );
      return;
    }

    // Convert picked images to File and compress if > 3MB
    final files = <File>[];
    for (final e in picked) {
      File file = File(e.path);
      file = await compressImageIfNeeded(
        file,
        maxSizeInMB: 3,
      ); // compress if needed
      files.add(file);
    }

    try {
      isUploading = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await ContractorProjectService.contractorProjectService
          .uploadBeforePhotos(
            projectId: projectId,
            beforePhotos: files,
            key: key,
          );

      Get.back(); // close loader

      if (success) {
        refreshList();
        items.refresh();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("✅ Photos uploaded successfully")),
        );
      } else {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(const SnackBar(content: Text("❌ Upload failed")));
      }
    } catch (e) {
      Get.back(); // ensure loader closes on error
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    } finally {
      isUploading = false;
    }
  }

  void showImagePickerOptions(
    BuildContext context, {
    required String projectId,
    required String key,
    required int imageLength,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorRes.transparentColor,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Upload Project Photos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickAndUploadPhotos(projectId, key, imageLength);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.green),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pickAndUploadSinglePhotoFromCamera(
                      projectId,
                      key,
                      imageLength,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickAndUploadSinglePhotoFromCamera(
    String projectId,
    String key,
    int imageLength,
  ) async {
    bool isGranted = await requestCameraPermission();
    if (isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.camera);

      if (picked == null) return;

      if (imageLength >= 3) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("⚠️ You already have 3 photos uploaded."),
          ),
        );
        return;
      }

      final file = File(picked.path);

      try {
        isUploading = true;

        // 🌀 Show loader
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        File finalPhoto = await compressImageIfNeeded(file);
        final success = await ContractorProjectService.contractorProjectService
            .uploadBeforePhotos(
              projectId: projectId,
              beforePhotos: [finalPhoto],
              key: key,
            );

        Get.back(); // close loader

        if (success) {
          refreshList();
          items.refresh();
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("✅ Photo uploaded successfully")),
          );
        } else {
          ScaffoldMessenger.of(
            Get.context!,
          ).showSnackBar(const SnackBar(content: Text("❌ Upload failed")));
        }
      } catch (e) {
        Get.back();
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      } finally {
        isUploading = false;
      }
    }
  }

  Future<File> compressImageIfNeeded(
    File file, {
    int maxSizeInMB = 3,
    int quality = 70,
  }) async {
    // Get file size in MB
    final fileSizeInMB = file.lengthSync() / (1024 * 1024);

    if (fileSizeInMB <= maxSizeInMB) {
      // No compression needed
      return file;
    }

    try {
      // Generate a unique path for compressed image
      final dir = file.parent.path;
      final targetPath =
          '$dir/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      // Compress the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
        // optional: set minWidth/minHeight if you want to reduce dimensions too
        // minWidth: 800,
        // minHeight: 800,
      );

      // Return compressed file if successful
      if (compressedFile != null) {
        return File(compressedFile.path);
      } else {
        return file; // fallback to original if compression fails
      }
    } catch (e) {
      print("Image compression failed: $e");
      return file; // fallback to original in case of error
    }
  }

  Future<void> deleteProjectPhoto({
    required String projectId,
    required String photoId,
    required String key, // "before_photos" or "after_photos"
  }) async {
    try {
      // 🌀 Show loader
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await ContractorProjectService.contractorProjectService
          .deletedProjectPhoto({
            "projectId": projectId,
            "photoUid": photoId,
            "type": key,
          });

      // ✅ Close loader
      Get.back();

      if (success) {
        refreshList();
        items.refresh();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("🗑️ Photo deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("❌ Failed to delete photo")),
        );
      }
    } catch (e, stack) {
      Get.back(); // Close loader if error occurs
      log("🚨 Error deleting photo: $e\n$stack");
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);
    log("Apply Filter in Inquiry Contractor Section ${filters} ");
    // await loadInitial();
    refreshList();
  }

  bool isExpanded(String id) => expandedCards[id] ?? false;

  @override
  void onInit() {
    super.onInit();
    ever(filters, (_) => refreshList());

    loadInitial();
  }

  void resetChangeStatus() {
    selectedDate = null;
    changeStatus.value = '';
  }

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }

  void populatedProjectData(ContractorProjectItem project) {
    if (project.deadline != null && project.deadline!.isNotEmpty) {
      selectedDate = DateTime.tryParse(project.deadline!);
      log(
        "String Date Timer Convert $selectedDate  ============ ${project.deadline}",
      );

      if (selectedDate != null) {
        // 👇 Update the text controller so the UI shows it
        txtTime.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      }
    } else {
      txtTime.clear();
    }

    changeStatus.value = capitalizeEachWord(project.status);
  }

  Future<void> deleteFollowUpByID(String id) async {
    final response = await ContractorProjectService.contractorProjectService
        .deletedProject(id);
    if (response) {
      refreshList();
    }
  }

  void deleteLead(String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text(
          'Delete Follow Up',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        content: Text('Are you sure you want to delete Project for $name?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.error),
            onPressed: () {
              Get.back();
              Get.back();
              deleteFollowUpByID(id);

              NesticoPeSnackBar.showAwesomeSnackbar(
                title: 'Deleted',
                message: 'Follow Up deleted successfully',
                contentType: ContentType.success,
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Future<void> updateChangeStatus(String id,String status,String dateUpdate)
  // async {
  //   log("dgfysgfysdgfysd ${dateUpdate}");
  //   // 🟦 Prepare payload with only non-null, non-empty values
  //   final Map<String, dynamic> payload = {};
  //
  //   if (status != null && status.trim().isNotEmpty) {
  //     payload['status'] = status.trim().toLowerCase().replaceAll(" ", "_");
  //   }
  //   if (dateUpdate != null && dateUpdate.isNotEmpty) {
  //     payload['deadline'] = dateUpdate;
  //   }
  //
  //   if (payload.isEmpty) {
  //     print("⚠️ No valid status or date provided to update.");
  //     Get.snackbar(
  //       "Warning",
  //       "Please select at least one value to update.",
  //       backgroundColor: Colors.orange.shade100,
  //       colorText: Colors.black87,
  //     );
  //     return;
  //   }
  //
  //   print("🟩 Payload ready for update: $payload");
  //
  //   final date=await ContractorProjectService.contractorProjectService.updateStatus(payload, id);
  //   if(date){
  //     refreshList();
  //   }
  // }
  // In ContractorProjectController
  Future<void> updateChangeStatus(
    String id,
    String status,
    String dateUpdate,
  ) async {
    log("Updating project: $dateUpdate");

    final Map<String, dynamic> payload = {};

    if (status.trim().isNotEmpty) {
      payload['status'] = status.trim().toLowerCase().replaceAll(" ", "_");
    }
    if (dateUpdate.isNotEmpty) {
      payload['deadline'] = dateUpdate;
    }

    if (payload.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Warning',
        message: "Please select at least one value to update.",
        contentType: ContentType.warning,
      );
      return;
    }

    final success = await ContractorProjectService.contractorProjectService
        .updateStatus(payload, id);

    if (success) {
      // Option A: Refresh entire list
      await refreshList();

      // Option B: Update specific item locally (faster UI update)
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        // Create updated project object
        final updatedProject = items[index].copyWith(
          status: payload['status'],
          deadline: payload['deadline'],
        );
        items[index] = updatedProject;
        items.refresh(); // Trigger Obx update
      }

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: "Project updated successfully",
        contentType: ContentType.success,
      );
    }
  }

  @override
  Future<PaginationResponse<ContractorProjectItem>> fetchItems(int page) async {
    // TODO: implement fetchItems
    final UserModel user = await SecureStorage.getUserData() ?? UserModel();
    final userId = user.user?.id;
    final response = await ContractorProjectService.contractorProjectService
        .getContractorProjectData(contractorId: userId ?? '', filter: filters);

    AppLogger.structured(
      "App Logger for Contractor Project",
      response.items.map((e) => e.toJson()),
    );

    return response;
  }
}
