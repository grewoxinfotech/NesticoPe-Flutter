import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart'
    show UserModel, UserRole;
import 'package:housing_flutter_app/data/network/auth/service/auth_service.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/auth/views/ResetPasswordScreen.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../add_property/view/create_property.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../views/login_screen.dart';
import '../views/otp_verification_screen.dart';

enum AuthState { initial, authenticated, unauthenticated }

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final SecureStorage secureStorage = SecureStorage();

  final authState = AuthState.initial.obs;
  final errorMessage = ''.obs;
  final verificationId = ''.obs;
  final selectedRole = UserRole.seller.obs;
  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetToken = ''.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  RxString selectedSellerType = "owner".obs; // "owner" or "builder"

  String get selectedRoleString =>
      selectedRole.value.toString().split('.').last;

  @override
  void onInit() {
    super.onInit();
    //checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    super.onClose();
  }

  void fillTestCredentials() {
    emailController.text = "CRM_GrewoxAdmin@yopmail.com";
    passwordController.text = "CRM_GrewoxAdmin@123";
  }

  void setRole(UserRole role) => selectedRole.value = role;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await authService.login(email, password);

      await SecureStorage.saveToken(user.token!);
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);

      currentUser.value = user;
      print("[Debug]-> User data: ${currentUser.value!.user!.firstName}");
      authState.value = AuthState.authenticated;

      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      errorMessage.value = e.toString();
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Login Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
      print("[Debug]-> Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required BuildContext context,
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required String userType,
  }) async {
    try {
      isLoading.value = true;
      final response = await authService.register(
        username: username,
        password: password,
        email: email,
        userType: userType,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        await SecureStorage.saveToken(token);

        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.registration,
          ),
        );

        return true;
      } else {
        throw Exception(
          response['message'] ?? 'Registration failed - no token received',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("[Debug]-> Error: ${e.toString()}");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Registration Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sellerRegister({
    required String phone,
    required String userType,
    required String sellerType,
  }) async {
    try {
      isLoading.value = true;

      final response = await authService.sellerRegister(
        phone: phone,
        userType: userType,
        sellerType: sellerType,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        // await SecureStorage.saveToken(token);

        print(
          'API called successfully with phone: $phone, userType: $userType, sellerType: $sellerType, token: $token',
        );

        // Navigate to OTP screen using the passed phone
        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.sellerRegister,
            // isPasswordReset: false,
            redirectAfterOtp: CreatePropertyScreen(
              sellerType:
                  sellerType == "owner" ? SellerType.owner : SellerType.builder,
            ),
          ),
        );

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Registration successful. Please verify OTP sent to $phone.',
          contentType: ContentType.success,
        );
      } else {
        throw Exception(
          response['message'] ?? 'Registration failed - no token received',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("[Debug]-> Error: ${e.toString()}");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Registration Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp(String token) async {
    try {
      isLoading.value = true;
      await authService.resendOtp(token);
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp, String token) async {
    try {
      isLoading.value = true;
      final user = await authService.verifyOtp(otp, token);

      await SecureStorage.saveToken(user.token!);
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);

      currentUser.value = user;
      authState.value = AuthState.authenticated;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpSellerRegister(String otp, String token) async {
    try {
      isLoading.value = true;
      final data = await authService.verifyOtpSellerRegister(otp, token);
      // await SecureStorage.saveToken(user.token!);
      // await SecureStorage.saveUserData(user);
      // await SecureStorage.saveToken(data);
      // await SecureStorage.saveLoggedIn(true);

      authState.value = AuthState.authenticated;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword({required String id}) async {
    try {
      isLoading.value = true;
      final token = await authService.forgotPassword(id);
      isLoading.value = false;

      Get.to(
        () => OtpVerificationScreen(
          phone: id,
          token: token,
          verifyOTPFor: VerifyOTPFor.passwordReset,
          // isPasswordReset: true,
        ),
      );

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'OTP sent to your email or Phone.$token',
        contentType: ContentType.success,
      );
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString().replaceAll('Exception:', '').trim(),
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyPasswordResetOtp(String otp, String token) async {
    try {
      isLoading.value = true;
      final newResetToken = await authService.verifyPasswordResetOtp(
        otp,
        token,
      );
      resetToken.value = newResetToken;

      Get.to(() => ResetPasswordScreen());

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'OTP verified. Please set your new password.',
        contentType: ContentType.success,
      );
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString().replaceAll('Exception:', '').trim(),
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    try {
      if (newPasswordController.text != confirmPasswordController.text) {
        throw Exception("Passwords do not match");
      }

      isLoading.value = true;
      await authService.resetPassword(
        newPasswordController.text,
        resetToken.value,
      );

      Get.offAll(() => const LoginScreen());

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message:
            'Password reset successful. Please login with your new password.',
        contentType: ContentType.success,
      );
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString().replaceAll('Exception:', '').trim(),
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await SecureStorage.getToken();
      final isLoggedIn = await SecureStorage.getLoggedIn();

      if (token != null && isLoggedIn) {
        final user = await SecureStorage.getUserData();
        if (user != null) {
          currentUser.value = user;
          authState.value = AuthState.authenticated;
          Get.offAll(() => const DashboardScreen());
        } else {
          authState.value = AuthState.unauthenticated;
        }
      } else {
        authState.value = AuthState.unauthenticated;
      }
    } catch (e) {
      authState.value = AuthState.unauthenticated;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    currentUser.value = null;
    authState.value = AuthState.unauthenticated;
    Get.offAll(() => const LoginScreen());
  }
}
