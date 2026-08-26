import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import '../../../../data/network/verification/aadhar_auth/service/aadhar_auth_service.dart';
import '../screens/aadhar_verify_otp_screen.dart';

import 'package:nesticope_app/modules/profile/controllers/seller_profile_controller.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_profile_controller.dart';
import 'package:nesticope_app/modules/reseller/controller/profile/profile_controller.dart';

class AadharAuthController extends GetxController {
  final AadharAuthService _aadharAuthService = AadharAuthService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString requestId = ''.obs;
  final RxString aadharNumber = ''.obs;

  /// Initiate Aadhar Verification
  Future<void> initiateAadharVerification(String aadharNum) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _aadharAuthService.initiateAadharVerification(
        aadharNum,
      );

      if (data['success']) {
        // Extract request_id/reference_id from the nested response structure
        String? refId;
        final level1 = data['data'];
        if (level1 is Map) {
          final level2 = level1['data'];
          if (level2 is Map) {
            final level3 = level2['data'];
            if (level3 is Map) {
              refId = (level3['reference_id'] ?? level3['ref_id'])?.toString();
            }
            refId ??=
                (level2['reference_id'] ??
                        level2['ref_id'] ??
                        level2['request_id'])
                    ?.toString();
          }
          refId ??=
              (level1['reference_id'] ??
                      level1['ref_id'] ??
                      level1['request_id'])
                  ?.toString();
        }
        refId ??=
            (data['reference_id'] ?? data['ref_id'] ?? data['request_id'])
                ?.toString();

        if (refId != null) {
          requestId.value = refId;
          aadharNumber.value = aadharNum;

          // Navigate to OTP verification screen
          Get.to(() => AadharVerifyOTPScreen());
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message:
                'OTP sent successfully to your Aadhar linked mobile number',
            contentType: ContentType.success,
          );
        } else {
          String? specificError;
          final l1 = data['data'];
          if (l1 is Map) {
            final l2 = l1['data'];
            if (l2 is Map) {
              final l3 = l2['data'];
              if (l3 is Map) {
                specificError = l3['message']?.toString();
              }
              specificError ??= l2['message']?.toString();
            }
            specificError ??= l1['message']?.toString();
          }
          specificError ??= data['message']?.toString();

          errorMessage.value =
              specificError ??
              'Failed to get verification reference ID. Please try again.';
          _showErrorSnackbar(errorMessage.value);
        }
      } else {
        errorMessage.value =
            data['message'] ?? 'Failed to initiate Aadhar verification';
        _showErrorSnackbar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value =
          'An error occurred while initiating Aadhar verification';
      _showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify Aadhar OTP
  Future<bool> verifyAadharOtp(String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _aadharAuthService.verifyAadharOtp(
        requestId.value,
        otp,
      );

      if (data['success']) {
        UserHelper.setAadharVerified(true);
        _refreshProfileControllers();
        return true;
      } else {
        errorMessage.value = data['message'] ?? 'Failed to verify Aadhar OTP';
        _showErrorSnackbar(errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while verifying Aadhar OTP';
      _showErrorSnackbar(errorMessage.value);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshProfileControllers() {
    try {
      // 1. Seller Profile
      if (Get.isRegistered<SellerProfileController>()) {
        Get.find<SellerProfileController>().refreshProfile();
      }
    } catch (e) {}

    try {
      // 2. Contractor Profile
      if (Get.isRegistered<ContractorProfileController>()) {
        Get.find<ContractorProfileController>().refreshFollowUp();
      }
    } catch (e) {}

    try {
      // 3. Reseller Profile (ProfileController)
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().refreshReseller();
      }
    } catch (e) {}
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Error',
      message: message,
      contentType: ContentType.failure,
    );
  }

  /// Reset controller state
  void reset() {
    isLoading.value = false;
    errorMessage.value = '';
    requestId.value = '';
    aadharNumber.value = '';
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
