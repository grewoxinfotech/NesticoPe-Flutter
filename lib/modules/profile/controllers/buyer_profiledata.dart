import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/profile/reseller_profile/service/reseller_profile_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/network/user/service/user_service.dart';
import '../../../widgets/location_permission/location_permission_method.dart';
import '../../../widgets/messages/snack_bar.dart';

class BuyerProfileDataController extends GetxController {
  final UserService _userService = UserService();
  Rxn<User> userProfile = Rxn<User>();
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxBool isSaving = false.obs;
  final RxString pendingPhone = ''.obs;
  final RxInt otpResendTimer = 0.obs;
  final RxBool isVerifyingOtp = false.obs;
  final RxBool isResendingOtp = false.obs;
  final RxBool isVerifyButtonEnabled = true.obs;
  final RxBool isLoadingIMage = false.obs;
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);
  User? pendingUserData;
  Timer? _resendTimer;
  Future<void>? _activeProfileRequest;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final cityPlaceIdController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  Future<void> getUserProfile({bool force = false}) async {
    if (isClosed) return;
    if (!force && _activeProfileRequest != null) {
      return _activeProfileRequest!;
    }
    final request = _fetchUserProfile();
    _activeProfileRequest = request;
    await request;
  }

  Future<void> _fetchUserProfile() async {
    isLoading.value = true;
    try {
      final data = await SecureStorage.getUserData();
      final userId = data?.user?.id;

      if (userId == null || userId.isEmpty) {
        userProfile.value = null;
        return;
      }

      final user = await _userService
          .getUserById(userId)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => null,
          );
      if (isClosed) return;
      if (user != null) {
        userProfile.value = user;
        _populateControllers();
        log("Buyer profile loaded ${userProfile.value?.toJson()}");
      } else {
        userProfile.value = null;
        debugPrint("Failed to fetch user profile (null user)");
      }
    } catch (e, st) {
      debugPrint("getUserProfile() failed: $e");
      debugPrint("stack: $st");
      // Avoid leaving shimmer stuck forever on errors.
      userProfile.value = null;
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
      _activeProfileRequest = null;
    }
  }

  void _populateControllers() {
    if (isClosed) return;
    final user = userProfile.value;
    firstNameController.text = user?.firstName ?? '';
    lastNameController.text = user?.lastName ?? '';
    usernameController.text = user?.username ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    cityController.text = user?.city ?? '';
    cityPlaceIdController.text = user?.state ?? '';
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (isEditing.value) {
      _populateControllers();
    }
  }

  void cancelEdit() {
    isEditing.value = false;
    _populateControllers();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    final existing = userProfile.value;
    if (existing == null) return;

    final userData = await SecureStorage.getUserData();
    final userId = userData?.user?.id;
    if (userId == null || userId.isEmpty) return;

    isSaving.value = true;

    final updatedUser = User(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      city: cityController.text.trim(),
      username: usernameController.text.trim(),
      userType: existing.userType ?? 'buyer',
      roleId: existing.roleId,
      isVerified: existing.isVerified,
      state:
          cityPlaceIdController.text.trim().isNotEmpty
              ? cityPlaceIdController.text.trim()
              : existing.state,
      address: existing.address,
      zipCode: existing.zipCode,
      profilePic: existing.profilePic,
      totalExperience: existing.totalExperience,
    );

    try {
      final response = await ProfileUpdate.profileUpdate.updateProfileDetails(
        updatedUser,
        userId,
        selectedImage.value,
      );

      final isOtpRequired =
          response['otpRequired'] == true ||
          response['otpRequired'] == 'true' ||
          (response['success'] == false &&
              response['message']?.toString().toLowerCase().contains('otp') ==
                  true);

      if (isOtpRequired) {
        pendingUserData = updatedUser;
        pendingPhone.value = updatedUser.phone ?? phoneController.text.trim();
        otpResendTimer.value = 60;
        _startResendTimer();
        isSaving.value = false;
        _showOtpVerificationDialog(
          phone: pendingPhone.value,
          message:
              response['message']?.toString() ??
              'OTP verification required for phone number change',
        );
        return;
      }

      if (response['success'] == true) {
        await _persistUpdatedProfile(updatedUser);
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: response['message']?.toString() ?? 'Failed to update profile',
          contentType: ContentType.failure,
        );
      }
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _persistUpdatedProfile(User updatedUser) async {
    final existing = userProfile.value;
    if (existing == null) return;

    userProfile.value = User(
      id: existing.id,
      createdBy: existing.createdBy,
      updatedBy: existing.updatedBy,
      username: existing.username,
      password: existing.password,
      email: updatedUser.email,
      userType: existing.userType,
      sellerType: existing.sellerType,
      roleId: existing.roleId,
      profilePic: existing.profilePic,
      firstName: updatedUser.firstName,
      lastName: updatedUser.lastName,
      phone: updatedUser.phone,
      otp: existing.otp,
      otpExpiry: existing.otpExpiry,
      address: existing.address,
      city: updatedUser.city,
      state: existing.state,
      zipCode: existing.zipCode,
      isVerified: existing.isVerified,
      isAadharVerified: existing.isAadharVerified,
      isOnline: existing.isOnline,
      lastSeen: existing.lastSeen,
      currentSubscriptionId: existing.currentSubscriptionId,
      isPremium: existing.isPremium,
      subscriptionStatus: existing.subscriptionStatus,
      totalExperience: existing.totalExperience,
      createdAt: existing.createdAt,
      updatedAt: existing.updatedAt,
    );

    final local = await SecureStorage.getUserData();
    if (local?.user != null) {
      final localUser = local!.user!;
      local.user = User(
        id: localUser.id,
        createdBy: localUser.createdBy,
        updatedBy: localUser.updatedBy,
        username: localUser.username,
        password: localUser.password,
        email: updatedUser.email,
        userType: localUser.userType,
        sellerType: localUser.sellerType,
        roleId: localUser.roleId,
        profilePic: localUser.profilePic,
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        phone: updatedUser.phone,
        otp: localUser.otp,
        otpExpiry: localUser.otpExpiry,
        address: localUser.address,
        city: updatedUser.city,
        state: localUser.state,
        zipCode: localUser.zipCode,
        isVerified: localUser.isVerified,
        isAadharVerified: localUser.isAadharVerified,
        isOnline: localUser.isOnline,
        lastSeen: localUser.lastSeen,
        currentSubscriptionId: localUser.currentSubscriptionId,
        isPremium: localUser.isPremium,
        subscriptionStatus: localUser.subscriptionStatus,
        totalExperience: localUser.totalExperience,
        createdAt: localUser.createdAt,
        updatedAt: localUser.updatedAt,
      );
      await SecureStorage.saveUserData(local);
    }

    await getUserProfile();
    selectedImage.value = null;
    isEditing.value = false;

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'Profile updated',
      contentType: ContentType.success,
    );
  }

  Future<void> pickImageFromGallery() async {
    final isGranted = await requestGalleryPermission();
    if (!isGranted) return;
    try {
      isLoadingIMage.value = true;
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } finally {
      isLoadingIMage.value = false;
    }
  }

  Future<void> pickImageFromCamera() async {
    final isGranted = await requestCameraPermission();
    if (!isGranted) return;
    try {
      isLoadingIMage.value = true;
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } finally {
      isLoadingIMage.value = false;
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
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
                if (selectedImage.value != null)
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
    // profile.value = profile.value.copyWith(avatarUrl: '');

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'Profile photo removed',
      contentType: ContentType.success,
    );
  }
  Future<void> verifyPhoneUpdateOtp(String otp) async {
    if (pendingUserData == null) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'No pending update found',
        contentType: ContentType.failure,
      );
      return;
    }

    final userData = await SecureStorage.getUserData();
    final userId = userData?.user?.id;
    if (userId == null || userId.isEmpty) return;

    isVerifyingOtp.value = true;
    final updateData = {
      'firstName': pendingUserData?.firstName,
      'lastName': pendingUserData?.lastName,
      'email': pendingUserData?.email,
      'phone': pendingUserData?.phone,
      'city': pendingUserData?.city,
      'state': pendingUserData?.state,
    };

    try {
      final response = await ProfileUpdate.profileUpdate.verifyOtpForResellerNumber(
        otp,
        updateData,
        userId,
      );

      if (response['success'] == true) {
        _resendTimer?.cancel();
        await _persistUpdatedProfile(pendingUserData!);
        pendingUserData = null;
        pendingPhone.value = '';
        Get.back();
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: response['message']?.toString() ?? 'Invalid OTP',
          contentType: ContentType.failure,
        );
      }
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  Future<void> resendOtpForPhoneUpdate() async {
    if (pendingPhone.value.isEmpty) return;

    final userData = await SecureStorage.getUserData();
    final userId = userData?.user?.id;
    if (userId == null || userId.isEmpty) return;

    isResendingOtp.value = true;
    try {
      final response = await ProfileUpdate.profileUpdate.resendPhoneUpdateOtp(
        userId,
        pendingPhone.value,
      );
      if (response['success'] == true) {
        otpResendTimer.value = 60;
        _startResendTimer();
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: response['message']?.toString() ?? 'Failed to resend OTP',
          contentType: ContentType.failure,
        );
      }
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
    final otpController = TextEditingController();

    Get.dialog(
    
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Verify Phone Number'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 12),
              Text('OTP sent to: $phone'),
              const SizedBox(height: 12),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  hintText: '0000',
                  counterText: '',
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (otpResendTimer.value > 0)
                      Text('Resend in ${otpResendTimer.value}s')
                    else
                      TextButton(
                        onPressed:
                            isResendingOtp.value ? null : resendOtpForPhoneUpdate,
                        child: const Text('Resend OTP'),
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
              _resendTimer?.cancel();
              _resendTimer = null;
              pendingUserData = null;
              pendingPhone.value = '';
              SecureStorage.deleteUpdatePhoneToken();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  isVerifyingOtp.value
                      ? null
                      : () {
                        if (otpController.text.length == 4) {
                          verifyPhoneUpdateOtp(otpController.text);
                        } else {
                          NesticoPeSnackBar.showAwesomeSnackbar(
                            title: 'Error',
                            message: 'Please enter 4-digit OTP',
                            contentType: ContentType.failure,
                          );
                        }
                      },
              child:
                  isVerifyingOtp.value
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
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
    _resendTimer?.cancel();
    selectedImage.value = null;
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    cityPlaceIdController.dispose();
    super.onClose();
  }

  void clearProfileState() {
    if (isClosed) return;
    _resendTimer?.cancel();
    _resendTimer = null;
    _activeProfileRequest = null;
    pendingUserData = null;
    pendingPhone.value = '';
    otpResendTimer.value = 0;
    isVerifyingOtp.value = false;
    isResendingOtp.value = false;
    isVerifyButtonEnabled.value = true;
    isLoadingIMage.value = false;
    selectedImage.value = null;
    userProfile.value = null;
    isEditing.value = false;
    isSaving.value = false;
    isLoading.value = false;
  }
}