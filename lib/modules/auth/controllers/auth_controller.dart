import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart'
    show UserModel, UserRole, User;
import 'package:housing_flutter_app/data/network/auth/service/auth_service.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/auth/views/ResetPasswordScreen.dart';
import 'package:housing_flutter_app/modules/auth/views/seller_registration_complete.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../add_property/view/create_property.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../views/login_screen.dart';
import '../views/otp_verification_screen.dart';
import '../views/splash_screen.dart';

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
    // emailController.text = "abc@gmail.com";
    // emailController.text = "d.doe@example.com";
    // passwordController.text = "password123";
    // passwordController.text = "CRM_GrewoxAdmin@123";
    // emailController.text = "avesh"; // seller password : 123456
    // passwordController.text = "123456";

    /// localhost
    /// Builder
    // emailController.text = "sellerbuilde@yopmail.com";
    // passwordController.text = "sellerbuilde@yopmail.com";
    /// Reseller
    // emailController.text = "admin11@example.com";
    // passwordController.text = "CRM_GrewoxAdmin@123";
    /// Seller
    emailController.text = "pls1@yopmail.com";
    passwordController.text = "pls1@yopmail.com";
  }

  void setRole(UserRole role) => selectedRole.value = role;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await authService.login(email, password);

      await SecureStorage.saveToken(user.token!);
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);
      await UserHelper.setUserType(
        user.user?.userType,
        sellerType: user.user?.sellerType,
      );

      currentUser.value = user;
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
    String? referralCode,
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
        referCode: referralCode,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        await SecureStorage.saveToken(token);

        print("API called successfully with phone: $phone, token: $token");

        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.registration,
            redirectAfterOtp: LoginScreen(),
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
    required BuildContext context,
    required Map<String, dynamic>? data,
    required String username,
    required String phone,
    required String sellerType,
    String? referralCode,
  }) async {
    try {
      isLoading.value = true;

      final response = await authService.sellerRegister(
        userType: "seller",
        phone: phone,
        referCode: referralCode,
        sellerType: sellerType,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        await SecureStorage.saveToken(token);

        // Navigate to OTP screen using the passed phone
        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.sellerRegister,
            data: data,
            redirectAfterOtp: LoginScreen(),
            // redirectAfterOtp: CreatePropertyScreen(
            //   sellerType:
            //       sellerType == "owner" ? SellerType.owner : SellerType.builder,
            //   isLogin: true,
            // ),
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

  Future<bool> completeSellerRegistration(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      print("Received data: $data");
      final receivedToken = await authService.sellerRegistrationComplete(data);
      if (receivedToken != null) {
        await SecureStorage.saveToken(receivedToken);

        // final user = UserModel(
        //   token: receivedToken,
        //   user: User(
        //     address: data[''],
        //     city: data[''],
        //     email: data[''],
        //     firstName: data[''],
        //     lastName: data[''],
        //     state: data[''],
        //     zipCode: data[''],
        //     address: data[''],
        //     address: data[''],
        //     address: data[''],
        //
        //   )
        // );
        // await SecureStorage.saveUserData(user);
        return true;
      } else {
        print("Registration failed or token not received");
        return false;
      }
    } catch (e) {
      print("Error in completeSellerRegistration: $e");
      return false;
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
      final user = await SecureStorage.getUserData();
      if (user != null) {
        user.user!.userType = "seller";
        await SecureStorage.saveUserData(user);
      }
      print("Token data: ${data}");
      await SecureStorage.saveToken(data);
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
      print('ferefydgetydgwewgdhgtgywvdwyg   hdgetyd hudb      $token');
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

  Future<void> covertBuyerToSeller(String sellerType) async {
    try {
      isLoading.value = true;
      final user = await authService.convertBuyerToSeller(sellerType);
      if (user) {
        Get.offAll(() => LoginScreen());
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Conversion Failed",
          message: "Failed to Convert Buyer to Seller",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Conversion Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
      print("[Debug]-> Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> convertBuyerToReseller() async {
    try {
      isLoading.value = true;
      final user = await authService.convertBuyerToReseller();
      if (user) {
        Get.offAll(() => LoginScreen());
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Conversion Failed",
          message: "Failed to Convert Buyer to Reseller",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Conversion Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
      print("[Debug]-> Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> convertBuyerToContractor() async {
    try {
      isLoading.value = true;
      final user = await authService.convertBuyerToContractor();
      if (user) {
        Get.offAll(() => LoginScreen());
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Conversion Failed",
          message: "Failed to Convert Buyer to Contractor",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Conversion Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
      print("[Debug]-> Error: $e");
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

  Future<bool> deleteAccount(String reason) async {
    try {
      isLoading.value = true;
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';
      final success = await authService.deleteAccount(userId, reason);
      if (success) {
        return true;
      }
      return false;
    } catch (e) {
      print("[Debug]-> Error: $e");

      return false;
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
    UserHelper.clearUserType();
    currentUser.value = null;
    authState.value = AuthState.unauthenticated;
    // Get.offAll(() => const LoginScreen());
    Get.offAll(() => const SplashScreen());
  }
}
