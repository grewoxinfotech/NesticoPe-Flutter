// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../model/user/user_model.dart';
//
// class ProfileController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxBool isEditing = false.obs;
//   final RxBool isSaving = false.obs;
//
//   final Rx<UserProfile> profile = UserProfile(
//     id: '1',
//     name: 'John Doe',
//     email: 'john.doe@company.com',
//     phone: '+1-555-0123',
//     position: 'Sales Manager',
//     company: 'Tech Solutions Inc.',
//     bio: 'Experienced sales professional with over 10 years in the industry.',
//     avatarUrl: '',
//     totalSales: 2500000.0,
//     leadsCount: 156,
//     rating: 4.9,
//     joinedDate: DateTime.now().subtract(const Duration(days: 365)),
//   ).obs;
//
//   // Form controllers
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final positionController = TextEditingController();
//   final companyController = TextEditingController();
//   final bioController = TextEditingController();
//
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadProfile();
//   }
//
//   void loadProfile() {
//     isLoading.value = true;
//
//     // Simulate API call
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _populateControllers();
//       isLoading.value = false;
//     });
//   }
//
//   void _populateControllers() {
//     nameController.text = profile.value.name;
//     emailController.text = profile.value.email;
//     phoneController.text = profile.value.phone;
//     positionController.text = profile.value.position;
//     companyController.text = profile.value.company;
//     bioController.text = profile.value.bio;
//   }
//
//   void toggleEdit() {
//     isEditing.value = !isEditing.value;
//     if (isEditing.value) {
//       _populateControllers();
//     }
//   }
//
//   void cancelEdit() {
//     isEditing.value = false;
//     _populateControllers(); // Reset to original values
//   }
//
//   Future<void> saveProfile() async {
//     if (!formKey.currentState!.validate()) return;
//
//     isSaving.value = true;
//
//     // Simulate API call
//     await Future.delayed(const Duration(milliseconds: 800));
//
//     profile.value = profile.value.copyWith(
//       name: nameController.text,
//       email: emailController.text,
//       phone: phoneController.text,
//       position: positionController.text,
//       company: companyController.text,
//       bio: bioController.text,
//     );
//
//     isEditing.value = false;
//     isSaving.value = false;
//
//     Get.snackbar('Success', 'Profile updated successfully',
//         backgroundColor: Colors.green, colorText: Colors.white);
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     positionController.dispose();
//     companyController.dispose();
//     bioController.dispose();
//     super.onClose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../model/user/user_model.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingImage = false.obs;

  final Rx<UserProfile> profile = UserProfile(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@company.com',
    phone: '+1-555-0123',
    position: 'Sales Manager',
    company: 'Tech Solutions Inc.',
    bio: 'Experienced sales professional with over 10 years in the industry.',
    avatarUrl: '',
    totalSales: 2500000.0,
    leadsCount: 156,
    rating: 4.9,
    joinedDate: DateTime.now().subtract(const Duration(days: 365)),
  ).obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();
  final companyController = TextEditingController();
  final bioController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      _populateControllers();
      isLoading.value = false;
    });
  }

  void _populateControllers() {
    nameController.text = profile.value.name;
    emailController.text = profile.value.email;
    phoneController.text = profile.value.phone;
    positionController.text = profile.value.position;
    companyController.text = profile.value.company;
    bioController.text = profile.value.bio;
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (isEditing.value) {
      _populateControllers();
    }
  }

  void cancelEdit() {
    isEditing.value = false;
    selectedImage.value = null; // Reset selected image
    _populateControllers(); // Reset to original values
  }

  // Image picker methods
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Image selected successfully',
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Image captured successfully',
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                    pickImageFromGallery();
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
                    pickImageFromCamera();
                  },
                ),
                if (selectedImage.value != null || profile.value.avatarUrl.isNotEmpty)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      removeProfileImage();
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeProfileImage() {
    selectedImage.value = null;
    profile.value = profile.value.copyWith(avatarUrl: '');
    Get.snackbar(
      'Success',
      'Profile photo removed',
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
  Future<String?> _uploadImage(File imageFile) async {
    try {
      isUploadingImage.value = true;

      // TODO: Replace this with your actual API upload logic
      // Example:
      // final request = http.MultipartRequest('POST', Uri.parse('your-api-url'));
      // request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      // final response = await request.send();
      // if (response.statusCode == 200) {
      //   final responseData = await response.stream.bytesToString();
      //   final jsonData = json.decode(responseData);
      //   return jsonData['imageUrl'];
      // }

      await Future.delayed(const Duration(seconds: 1));

      // For now, return null to keep the local file
      // When you integrate real API, return the actual URL from server
      return null;

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return null;
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    String avatarUrl = profile.value.avatarUrl;
    File? localImageFile;

    // Upload image if a new one is selected
    if (selectedImage.value != null) {
      final uploadedUrl = await _uploadImage(selectedImage.value!);

      if (uploadedUrl != null) {
        // Server upload successful - use the URL
        avatarUrl = uploadedUrl;
        localImageFile = null;
      } else {
        // Server upload failed or not implemented - keep local file
        localImageFile = selectedImage.value;
        avatarUrl = ''; // Clear URL to use local file
      }
    }

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    profile.value = profile.value.copyWith(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      position: positionController.text,
      company: companyController.text,
      bio: bioController.text,
      avatarUrl: avatarUrl,
    );

    // Keep the local file reference if no server URL
    if (localImageFile != null) {
      selectedImage.value = localImageFile;
    } else {
      selectedImage.value = null;
    }

    isEditing.value = false;
    isSaving.value = false;

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    companyController.dispose();
    bioController.dispose();
    super.onClose();
  }
}