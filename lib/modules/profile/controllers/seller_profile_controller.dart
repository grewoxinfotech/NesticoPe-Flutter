import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/getProfile/service/getProfile_service.dart';
import 'package:nesticope_app/data/network/profile/reseller_profile/service/reseller_profile_service.dart';
import 'package:nesticope_app/widgets/location_permission/location_permission_method.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/network/getProfile/model/getProfile_model.dart';
import '../../../../data/network/profile/reseller_profile/model/reseller_update_profile_model.dart';
import '../../../data/network/profile/seller/service/seller_service.dart';
import '../../../data/network/user/service/user_service.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../reseller/model/user/user_model.dart';
import '../model/seller_profile.dart';
import 'package:nesticope_app/modules/profile/controllers/buyer_profiledata.dart';

class SellerProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isLoadingIMage = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingImage = false.obs;
  UserService _userService = UserService();
  final Rxn<ProfileSellerModel> resellerProfile = Rxn<ProfileSellerModel>();
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

  // Form controllers - Contact Info
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController(); // City
  final companyController = TextEditingController(); // State
  final addressController = TextEditingController();
  final totalExperience = TextEditingController();
  final zipController = TextEditingController();

  // Form controllers - Business Details
  final contactPersonController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final companyNameController = TextEditingController();
  final reraNumberController = TextEditingController();
  final gstNumberController = TextEditingController();

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

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () async {
      await getUserProfileData();
      _populateControllers();
      isLoading.value = false;
    });
  }

  Future<User> getUserProfile() async {
    final data = await SecureStorage.getUserData();
    final userId = data?.user?.id;
    debugPrint('Fetched User Seller: ${userId}');
    User? user = await _userService.getUserById(userId ?? '');

    if (user != null) {
      return user;
    } else {
      print("Failed to fetch user profile");
      return User();
    }
  }

  Future<void> getUserProfileData() async {
    final user = await getUserProfile();

    // Initialize profileData with fetched user so subsequent `.user` reads work
    profileData.value = UserModel(user: user);

    if (profileData.value?.user?.userType == 'seller') {
      print("vkjbhfjgi ${profileData.value?.toJson()}");
      final data = await SellerProfileUpdate.profileUpdate.getUserProfileData(
        profileData.value?.user?.id ?? '',
      );
      print("Seller kgokjgij${data}");
      resellerProfile.value = ProfileSellerModel.fromJson(data ?? {});
      print("Seller efgryfgrfyy${resellerProfile.value?.toJson()}");
    }
    _populateControllers();
    print("Lok ${resellerProfile.value?.id}");
  }

  Future<void> refreshProfile() async {
    try {
      await getUserProfileData();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Failed to refresh ",
        contentType: ContentType.failure,
      );
    } finally {}
  }

  Future<Map<String, dynamic>> updateResellerProfile(
    UserUpdateProfile userProfile,
  ) async {
    profileData.value?.user = await getUserProfile();
    if (profileData.value?.user?.userType == 'seller') {
      print("jfhfhh ${profileData.value?.toJson()}");
      print(
        "🟫 Sending Update Request for User ID: ${profileData.value?.user?.id}",
      );
      print("🟩 Payloadshfdufhdu: ${userProfile.toMap()}");

      final data = await SellerProfileUpdate.profileUpdate
          .updateSellerProfileDetails(
            userProfile,
            profileData.value?.user?.id ?? '',
            profileImageFile: selectedImage.value,
          );

      return data;
    }
    return {'success': false, 'message': 'Invalid user type'};
  }

  void _populateControllers() {
    // Contact Info fields
    nameController.text = profileData.value?.user?.firstName ?? "";

    lastNameController.text = profileData.value?.user?.lastName ?? "";
    emailController.text = profileData.value?.user?.email ?? "";
    phoneController.text = profileData.value?.user?.phone ?? "";
    positionController.text = profileData.value?.user?.city ?? "";
    companyController.text = profileData.value?.user?.state ?? "";
    addressController.text = profileData.value?.user?.address ?? "";
    zipController.text = profileData.value?.user?.zipCode ?? "";

    if ((profileData.value?.user?.totalExperience != null)) {
      totalExperience.text =
          profileData.value?.user?.totalExperience.toString() ?? '';
    } else {
      totalExperience.text = "0";
    }
    // Business Details fields from seller profile
    contactPersonController.text = resellerProfile.value?.contactName ?? "";
    contactPhoneController.text = resellerProfile.value?.contactPhone ?? "";
    companyNameController.text = resellerProfile.value?.companyName ?? "";
    reraNumberController.text = resellerProfile.value?.reraNumber ?? "";
    gstNumberController.text = resellerProfile.value?.gstNumber ?? "";
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
    bool isGranted = await requestGalleryPermission();
    if (isGranted) {
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

          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: "Image selected successfully",
            contentType: ContentType.success,
          );
        }
      } catch (e) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: "Failed to pick image: ${e.toString()}",
          contentType: ContentType.failure,
        );
      } finally {
        isLoadingIMage.value = false;
      }
    }
  }

  Future<void> pickImageFromCamera() async {
    bool isGranted = await requestCameraPermission();
    if (isGranted) {
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
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: "Image captured successfully",
            contentType: ContentType.success,
          );
        }
      } catch (e) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to capture image: ${e.toString()}',
          contentType: ContentType.failure,
        );
      } finally {
        isLoadingIMage.value = false;
      }
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
                    (profile.value.avatarUrl.isNotEmpty ?? false))
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
    // Note: Removing profile pic from server would require an API call
    // For now, just clear the local selection

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: "Profile photo removed. Save changes to update.",
      contentType: ContentType.success,
    );
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      isUploadingImage.value = true;

      await Future.delayed(const Duration(seconds: 1));

      return imageFile.path;
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Failed to upload image: ${e.toString()}",
        contentType: ContentType.failure,
      );

      return null;
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> saveProfile() async {
    print('🔵 saveProfile() called');
    print('🔵 formKey.currentState: ${formKey.currentState}');

    try {
      // Validate form if in editing mode
      if (formKey.currentState != null && !formKey.currentState!.validate()) {
        print('⚠️ Form validation failed');
        return;
      }

      isSaving.value = true;
      String? image;
      if (selectedImage.value != null) {
        image = await _uploadImage(selectedImage.value!);
        if (image == null) {
          // Upload failed, stop here
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Error',
            message: "Failed to upload image",
            contentType: ContentType.failure,
          );

          isSaving.value = false;
          return;
        }
      }

      print(" fdjnfjudfhur $image");
      // Build user object from form data
      UserUpdateProfile user = UserUpdateProfile(
        city: positionController.text,
        state: companyController.text,
        email: emailController.text,
        totalExperience: totalExperience.text,
        firstName: nameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        address: addressController.text,

        profileData: SellerProfileData(
          contactName: contactPersonController.text,
          contactPhone: contactPhoneController.text,
          companyName: companyNameController.text,
          gstNumber: gstNumberController.text,
          reraNumber: reraNumberController.text,
        ),
      );

      print("🟢 User data prepared: ${user.toMap()}");

      // Call API to update profile
      print('🔵 Calling updateResellerProfile API...');
      final response = await updateResellerProfile(user);
      print('🟢 API response received');

      // DEBUG: Print full response
      print('🔍 FULL API RESPONSE: $response');
      print('🔍 otpRequired value: ${response['otpRequired']}');
      print('🔍 otpRequired type: ${response['otpRequired'].runtimeType}');
      print('🔍 success value: ${response['success']}');
      print('🔍 message value: ${response['message']}');

      final isOtpRequired =
          response['otpRequired'] == true ||
          response['otpRequired'] == 'true' ||
          (response['success'] == false &&
              response['message']?.toString().toLowerCase().contains('otp') ==
                  true);

      if (isOtpRequired) {
        print('🔵 OTP Required detected!');

        pendingUserData = User(
          id: profileData.value?.user?.id,
          firstName: nameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          phone: phoneController.text,
          totalExperience: int.tryParse(totalExperience.text),
          city: positionController.text,
          zipCode: zipController.text,
          state: companyController.text,
          username: profileData.value?.user?.username,
          userType: profileData.value?.user?.userType,
          roleId: profileData.value?.user?.roleId,
          isVerified: profileData.value?.user?.isVerified,
          address: addressController.text,
        );

        pendingPhone.value = response['phone'] ?? phoneController.text;
        print('🔵 Pending phone: ${pendingPhone.value}');

        if (response['updatePhoneToken'] == null) {
          print(
            '⚠️ Warning: API did not send updatePhoneToken in initial response',
          );
          print('⚠️ Triggering resend OTP to obtain token...');

          isSaving.value = false;
          _showOtpVerificationDialog(
            phone: pendingPhone.value,
            message:
                response['message'] ??
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
                response['message'] ??
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
              profilePic: image ?? profileData.value?.user?.profilePic,
              username: profileData.value?.user?.username,
              userType: profileData.value?.user?.userType,
              roleId: profileData.value?.user?.roleId,
              isVerified: profileData.value?.user?.isVerified,
              address: addressController.text,
            ),
            token: profileData.value?.token,
          );
          await SecureStorage.saveUserData(profileData.value!);
          BuyerProfileDataController b =
              Get.isRegistered<BuyerProfileDataController>()
                  ? Get.find<BuyerProfileDataController>()
                  : Get.put(BuyerProfileDataController());
          b.userProfile.value = profileData.value?.user;
          b.userProfile.refresh();
        }

        await getUserProfileData();

        _populateControllers();

        selectedImage.value = null;
        isEditing.value = false;

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: response['message'] ?? 'Profile updated successfully',
          contentType: ContentType.success,
        );
      } else {
        // API returned error
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: response['message'] ?? 'Failed to update profile',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print('Error saving profile: $e');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'An error occurred while updating profile',
        contentType: ContentType.failure,
      );
    } finally {
      isSaving.value = false;
    }
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

    isVerifyingOtp.value = true;
    final Map<String, dynamic> userDataMap = {
      'firstName': pendingUserData?.firstName,
      'lastName': pendingUserData?.lastName,
      'phone': pendingUserData?.phone,
      'email': pendingUserData?.email,
      'city': pendingUserData?.city,
      'state': pendingUserData?.state,
      'address': pendingUserData?.address,
      "totalExperience": pendingUserData?.totalExperience,
      'profiledata': {
        'contactName': contactPersonController.text,
        'contactPhone': contactPhoneController.text,
        'companyName': companyNameController.text,
        'gstNumber': gstNumberController.text,
        'reraNumber': reraNumberController.text,
      },
    };

    try {
      final response = await SellerProfileUpdate.profileUpdate
          .verifyOtpForSellerNumber(
            otp,
            userDataMap!,
            profileData.value?.user?.id ?? '',
          );

      if (response['success'] == true) {
        _resendTimer?.cancel();

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
          BuyerProfileDataController b =
              Get.isRegistered<BuyerProfileDataController>()
                  ? Get.find<BuyerProfileDataController>()
                  : Get.put(BuyerProfileDataController());
          b.userProfile.value = profileData.value?.user;
          b.userProfile.refresh();

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

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: response['message'] ?? 'Phone number updated successfully',
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: response['message'] ?? 'Invalid OTP',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to verify OTP',
        contentType: ContentType.failure,
      );
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  Future<void> resendOtpForPhoneUpdate() async {
    if (pendingPhone.value.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'No pending phone number',
        contentType: ContentType.failure,
      );
      return;
    }

    isResendingOtp.value = true;

    try {
      final response = await SellerProfileUpdate.profileUpdate
          .resendPhoneSellerUpdateOtp(
            profileData.value?.user?.id ?? '',
            pendingPhone.value,
          );

      if (response['success'] == true) {
        otpResendTimer.value = 60;
        _startResendTimer();
        isVerifyButtonEnabled.value = true;

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: response['message'] ?? 'OTP sent successfully',
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: response['message'] ?? 'Failed to resend OTP',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print('Error resending OTP: $e');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to resend OTP',
        contentType: ContentType.failure,
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

        /// 🛑 Verify button disable
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
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  hintText: '0000',
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
              _resendTimer?.cancel();
              _resendTimer = null;
              pendingUserData = null;
              pendingPhone.value = '';
              SecureStorage.deleteUpdatePhoneToken();
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                otpController.dispose();
              });
            },
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  (!isVerifyButtonEnabled.value || isVerifyingOtp.value)
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
    _resendTimer?.cancel();
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    companyController.dispose();
    totalExperience.dispose();
    addressController.dispose();
    zipController.dispose();
    contactPersonController.dispose();
    contactPhoneController.dispose();
    companyNameController.dispose();
    reraNumberController.dispose();
    gstNumberController.dispose();

    super.onClose();
  }
}
