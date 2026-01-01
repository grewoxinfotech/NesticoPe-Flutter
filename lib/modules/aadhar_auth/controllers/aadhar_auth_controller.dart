import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import '../../../data/network/aadhar_auth/service/aadhar_auth_service.dart';
import '../screens/aadhar_verify_otp_screen.dart';

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
        print('Aadhar verification initiated successfully');

        // Extract request_id from the nested response structure
        final responseData = data['data']['data'];
        if (responseData['data']['otp_sent'] == true) {
          requestId.value = responseData['request_id'].toString();
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
          errorMessage.value = 'Failed to send OTP. Please try again.';
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
      print('Error in initiateAadharVerification: $e');
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
        print('Aadhar OTP verified successfully');
        UserHelper.setAadharVerified(true);
        return true;
      } else {
        errorMessage.value = data['message'] ?? 'Failed to verify Aadhar OTP';
        _showErrorSnackbar(errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred while verifying Aadhar OTP';
      _showErrorSnackbar(errorMessage.value);
      print('Error in verifyAadharOtp: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
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
