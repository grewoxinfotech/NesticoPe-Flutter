import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/getProfile/service/getProfile_service.dart';
import 'package:housing_flutter_app/data/network/profile/reseller_profile/service/reseller_profile_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/network/getProfile/model/getProfile_model.dart';
import '../../../../data/network/profile/reseller_profile/model/reseller_update_profile_model.dart';
import '../../../../data/network/user/service/user_service.dart';
import '../../model/user/user_model.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingImage = false.obs;
  final RxBool isLoadingIMage=false.obs;
  UserService _userService = UserService();
  final Rxn<ResellerProfile> resellerProfile = Rxn<ResellerProfile>();
  final Rx<UserProfile> profile =
      UserProfile(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@company.com',
        phone: '+1-555-0123',
        position: 'Sales Manager',
        company: 'Tech Solutions Inc.',
        bio:
            'Experienced sales professional with over 10 years in the industry.',
        avatarUrl: '',
        totalSales: 2500000.0,
        leadsCount: 156,
        rating: 4.9,
        joinedDate: DateTime.now().subtract(const Duration(days: 365)),
      ).obs;

  final Rxn<UserModel> profileData = Rxn<UserModel>();
  final Rxn<ResellerUpdateProfile> profileUpdateData =
      Rxn<ResellerUpdateProfile>();

  // OTP verification data
  final RxString pendingPhone = ''.obs;
  final RxInt otpResendTimer = 0.obs;
  final RxBool isVerifyingOtp = false.obs;
  final RxBool isResendingOtp = false.obs;
  User? pendingUserData; // Store user data for OTP verification
  Timer? _resendTimer; // Timer instance to prevent multiple timers
  final RxBool isVerifyButtonEnabled = true.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();
  final companyController = TextEditingController();
  final expController = TextEditingController();
  final totalExperience=TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    getUserProfile();
    getUserProfileData();
  }

  void loadProfile() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      _populateControllers();
      isLoading.value = false;
    });
  }

  Future<User> getUserProfile() async {
    final data = await SecureStorage.getUserData();
    final userId = data?.user?.id;
    User? user = await _userService.getUserById(userId ?? '');
    if (user != null) {
      return user;
    } else {
      print("Failed to fetch user profile");
      return User();
    }
  }
  Future<void> refreshReseller() async {
    try {

      await getUserProfileData();

      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh ',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {

    }
  }

  Future<void> getUserProfileData() async {
    // Fetch user and ensure profileData is initialized before assigning
    final user = await getUserProfile();

    // Initialize profileData with fetched user so subsequent `.user` reads work
    profileData.value = UserModel(user: user);

    if (profileData.value?.user?.userType == 'reseller') {
      print("jfhfhh ${profileData.value?.toJson()}");
      final data = await GetProfileService.getProfileService.getUserProfileData(
        profileData.value?.user?.id ?? '',
      );
      resellerProfile.value = ResellerProfile.fromJson(data ?? {});
    }
    _populateControllers();
    print("Lok ${resellerProfile.value?.data}");
  }

  Future<Map<String, dynamic>> updateResellerProfile(User userProfile) async {
    profileData.value?.user = await getUserProfile();
    if (profileData.value?.user?.userType == 'reseller') {
      print("jfhfhh ${profileData.value?.toJson()}");
      print(
        "🟫 Sending Update Request for User ID: ${profileData.value?.user?.id}",
      );
      print("🟩 Payload: ${userProfile.toJson()}");

      final data = await ProfileUpdate.profileUpdate.updateProfileDetails(
        userProfile,
        profileData.value?.user?.id ?? '',
        selectedImage.value,
      );

      return data;
    }
    return {'success': false, 'message': 'Invalid user type'};
  }

  void _populateControllers() {
    nameController.text = profileData.value?.user?.firstName ?? "";
    lastNameController.text = profileData.value?.user?.lastName ?? "";
    emailController.text = profileData.value?.user?.email ?? "";
    phoneController.text = profileData.value?.user?.phone ?? "";
    positionController.text = profileData.value?.user?.city ?? "";
    companyController.text = profileData.value?.user?.state ?? "";
    addressController.text = profileData.value?.user?.address ?? "";
    zipController.text = profileData.value?.user?.zipCode ?? "";
    totalExperience.text=profileData.value?.user?.totalExperience.toString()??"";
    
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    log("jfsdgdyhfg ndhfdhgf ${isEditing.value}");
    if (isEditing.value) {
      _populateControllers();
    }
  }

  void cancelEdit() {
    isEditing.value = false;
    selectedImage.value = null; // Reset selected image
    _populateControllers(); // Reset to original values
  }

  Future<void> pickImageFromGallery() async {
    try {
      isLoadingIMage.value=true;
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
          colorText: ColorRes.white,
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
        colorText: ColorRes.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
    finally{
      isLoadingIMage.value=false;
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      isLoadingIMage.value=true;
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
          colorText: ColorRes.white,
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
        colorText: ColorRes.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
    finally{
      isLoadingIMage.value=false;
    }
  }

  void showImagePickerOptions(BuildContext context) {
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
                  'Choose Profile Photo',
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
                if (selectedImage.value != null ||
                    profile.value.avatarUrl.isNotEmpty)
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
      colorText: ColorRes.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      isUploadingImage.value = true;

      await Future.delayed(const Duration(seconds: 1));

      return imageFile.path;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
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

    String? image;
    if (selectedImage.value != null) {
      image = await _uploadImage(selectedImage.value!);
      if (image == null) {
        // Upload failed, stop here
        Get.snackbar('Error', 'Failed to upload image');
        isSaving.value = false;
        return;
      }
    }
    User user = User(
      city: positionController.text,
      state: companyController.text,
      email: emailController.text,
      firstName: nameController.text,
      lastName: lastNameController.text,
      address: addressController.text,
      zipCode: zipController.text,
      totalExperience: int.tryParse(totalExperience.text),
      
      username: profileData.value?.user?.username,
      userType: "reseller",
      roleId: profileData.value?.user?.roleId,
      phone: phoneController.text,
      isVerified: profileData.value?.user?.isVerified,
    );
    final Map userDataMap = {
      'city': positionController.text,
      'state': companyController.text,
      'email': emailController.text,
      'firstName': nameController.text,
      'lastName': lastNameController.text,
      'address': addressController.text,
      'phone': phoneController.text,
    };
    print("usr data ${user.toJson()}");

    try {
      final response = await updateResellerProfile(user);
      print('🔍 FULL API RESPONSE: $response');
      print('🔍 Response Type: ${response.runtimeType}');

      // Check if response is valid Map
      if (response is! Map<String, dynamic>) {
        print('⚠️ ERROR: Response is not a Map! Type: ${response.runtimeType}');
        throw Exception('Invalid response format');
      }

      print('🔍 otpRequired value: ${response['otpRequired']}');
      print('🔍 otpRequired type: ${response['otpRequired'].runtimeType}');
      print('🔍 success value: ${response['success']}');
      print('🔍 message value: ${response['message']}');

      final isOtpRequired =
          response['otpRequired'] == true ||
          response['otpRequired'] == 'true' ||
          (response['success'] == false &&
              response['message']?.toString().toLowerCase().contains('otp') == true);

      if (isOtpRequired) {
        print('🔵 OTP Required detected!');

        pendingUserData = user;

        // Safely extract phone number
        String phoneNumber = phoneController.text;
        if (response['phone'] != null && response['phone'] is String) {
          phoneNumber = response['phone'] as String;
        }
        pendingPhone.value = phoneNumber;
        print('🔵 Pending phone: ${pendingPhone.value}');

        if (response['updatePhoneToken'] == null) {
          print(
            '⚠️ Warning: API did not send updatePhoneToken in initial response',
          );
          print('⚠️ Triggering resend OTP to obtain token...');

          // Show dialog first
          isSaving.value = false;
          _showOtpVerificationDialog(
            phone: pendingPhone.value,
            message:
                response['message']?.toString() ??
                'OTP verification required for phone number change',
          );

          otpResendTimer.value = 0;
          await resendOtpForPhoneUpdate();
        } else {
          otpResendTimer.value = 60;
          _startResendTimer();

          isSaving.value = false;

          _showOtpVerificationDialog(
            phone: pendingPhone.value,
            message:
                response['message']?.toString() ??
                'OTP verification required for phone number change',
          );
        }
        return;
      }


      if (response['success'] == true) {
        if (profileData.value?.user != null) {
          profileData.value = UserModel(
            user: User(
              id: profileData.value?.user?.id,
              firstName: nameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              phone: phoneController.text,
              city: positionController.text,
              totalExperience: int.tryParse(totalExperience.text),
              zipCode: zipController.text,
              state: companyController.text,
              profilePic: image ?? '',
              username: profileData.value?.user?.username,
              userType: profileData.value?.user?.userType,
              roleId: profileData.value?.user?.roleId,
              isVerified: profileData.value?.user?.isVerified,
              address: addressController.text,
            ),
            token: profileData.value?.token,
          );
          await SecureStorage.saveUserData(profileData.value!);
        }

        // Refresh user profile data from API
        await getUserProfileData();

        // Refresh controllers with updated data
        _populateControllers();

        selectedImage.value = null;
        isEditing.value = false;

        Get.snackbar(
          'Success',
          response['message']?.toString() ?? 'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        // API returned error
        Get.snackbar(
          'Error',
          response['message']?.toString() ?? 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e, stackTrace) {
      print('❌ Error saving profile: $e');
      print('❌ Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'An error occurred while updating profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> verifyPhoneUpdateOtp(String otp) async {
    if (pendingUserData == null) {
      Get.snackbar(
        'Error',
        'No pending update found',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isVerifyingOtp.value = true;
    final Map userDataMap = {
      'city': pendingUserData?.city,
      'state': pendingUserData?.state,
      'email': pendingUserData?.email,
      'firstName': pendingUserData?.firstName,
      'lastName': pendingUserData?.lastName,
      'address': pendingUserData?.address,
      'phone': pendingUserData?.phone,
    };

    try {
      final response = await ProfileUpdate.profileUpdate
          .verifyOtpForResellerNumber(
            otp,
        userDataMap!,
            profileData.value?.user?.id ?? '',
          );

      if (response['success'] == true) {
        _resendTimer?.cancel();
        // Update local profileData with new values
        if (response['data']?['user'] != null) {
          final updatedUser = response['data']['user'];

          profileData.value = UserModel(
            user: User(
              id: updatedUser['id'],
              firstName: updatedUser['firstName'],
              lastName: updatedUser['lastName'],
              email: updatedUser['email'],
              phone: updatedUser['phone'],
              city: positionController.text,
              state: companyController.text,
              totalExperience: int.tryParse(totalExperience.text),
              profilePic: profileData.value?.user?.profilePic,
              username: updatedUser['username'],
              userType: profileData.value?.user?.userType,
              roleId: profileData.value?.user?.roleId,
              isVerified: profileData.value?.user?.isVerified,
              address: profileData.value?.user?.address,
            ),
            token: profileData.value?.token,
          );

          await SecureStorage.saveUserData(profileData.value!);

          await getUserProfileData();
        }

        _populateControllers();

        // Clear pending data
        pendingUserData = null;
        pendingPhone.value = '';
        selectedImage.value = null;
        isEditing.value = false;

        // Close dialog
        Get.back();

        Get.snackbar(
          'Success',
          response['message'] ?? 'Phone number updated successfully',
          backgroundColor: Colors.green,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Invalid OTP',
          backgroundColor: Colors.red,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      Get.snackbar(
        'Error',
        'Failed to verify OTP',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  Future<void> resendOtpForPhoneUpdate() async {
    if (pendingPhone.value.isEmpty) {
      Get.snackbar(
        'Error',
        'No pending phone number',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
      return;
    }

    isResendingOtp.value = true;

    try {
      final response = await ProfileUpdate.profileUpdate.resendPhoneUpdateOtp(
        profileData.value?.user?.id ?? '',
        pendingPhone.value,
      );

      if (response['success'] == true) {
        // Start resend timer (60 seconds)
        otpResendTimer.value = 60;
        _startResendTimer();
        isVerifyButtonEnabled.value = true;

        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP sent successfully',
          backgroundColor: Colors.green,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to resend OTP',
          backgroundColor: Colors.red,
          colorText: ColorRes.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      print('Error resending OTP: $e');
      Get.snackbar(
        'Error',
        'Failed to resend OTP',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isResendingOtp.value = false;
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpResendTimer.value > 0) {
        otpResendTimer.value--;
      } else {
        timer.cancel();
        _resendTimer = null;
        isVerifyButtonEnabled.value = false;
      }
    });
  }

  void _showOtpVerificationDialog({
    required String phone,
    required String message,
  }) {
    print('🟢 Opening OTP Dialog for phone: $phone');
    print('🟢 Message: $message');

    final otpController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: ColorRes.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.blueColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.phone_android, color: ColorRes.blueColor),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Verify Phone Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorRes.leadGreyColor[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'OTP sent to: $phone',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  hintText: '000000',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (otpResendTimer.value > 0)
                      Text(
                        'Resend in ${otpResendTimer.value}s',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorRes.leadGreyColor[600],
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed:
                            isResendingOtp.value
                                ? null
                                : resendOtpForPhoneUpdate,
                        icon:
                            isResendingOtp.value
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.refresh, size: 18),
                        label: const Text('Resend OTP'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              otpController.dispose();
              pendingUserData = null;
              _resendTimer?.cancel();
              pendingPhone.value = '';
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  (!isVerifyButtonEnabled.value || isVerifyingOtp.value)
                      ? null
                      : () {
                        if (otpController.text.length == 6) {
                          verifyPhoneUpdateOtp(otpController.text);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please enter 6-digit OTP',
                            backgroundColor: Colors.red,
                            colorText: ColorRes.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.blueColor,
                foregroundColor: ColorRes.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  isVerifyingOtp.value
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorRes.white,
                        ),
                      )
                      : const Text('Verify'),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    // Cancel timer to prevent memory leaks
    _resendTimer?.cancel();
totalExperience.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    companyController.dispose();
    expController.dispose();
    super.onClose();
  }
}
