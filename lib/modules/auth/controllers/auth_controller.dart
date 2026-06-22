import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart'
    show UserModel, UserRole;
import 'package:nesticope_app/data/network/auth/service/auth_service.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/auth/views/ResetPasswordScreen.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:nesticope_app/modules/builder/view/builder_main_screen.dart';
import 'package:nesticope_app/modules/contractor/view/contractor_main.dart';
import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:nesticope_app/modules/profile/controllers/buyer_profiledata.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../../data/network/user/service/notification_sync_service.dart';
import '../../../services/notification_service.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../views/otp_verification_screen.dart';
import '../views/splash_screen.dart';

enum AuthState { initial, authenticated, unauthenticated }

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final SecureStorage secureStorage = SecureStorage();

  var selectedCityZ = TextEditingController();
  RxString city = ''.obs;
  RxString contractorType = ''.obs;

  void setContractorType(String type) {
    contractorType.value = type;
    log("Contractor type set to: $type");
  }

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
    emailController.text = "dev_seed_seller_1@test.local";
    passwordController.text = "123456";
  }

  void setCity(String value) {
    city.value = value;
  }

  void setRole(UserRole role) => selectedRole.value = role;

  // Future<void> login(String email, String password) async {
  //   try {
  //     isLoading.value = true;
  //     final user = await authService.login(email, password);
  //
  //     await SecureStorage.saveToken(user.token!);
  //     await SecureStorage.saveUserData(user);
  //     await SecureStorage.saveLoggedIn(true);
  //     await SecureStorage.saveTermAndConditionValue(false.toString());
  //     await UserHelper.setUserType(
  //       user.user?.userType,
  //       sellerType: user.user?.sellerType,
  //       isAadharVerified: user.user?.isAadharVerified,
  //     );
  //
  //     currentUser.value = user;
  //     authState.value = AuthState.authenticated;
  //
  //     Get.offAll(() => const DashboardScreen());
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     NesticoPeSnackBar.showAwesomeSnackbar(
  //       title: "Login Failed",
  //       message: e.toString(),
  //       contentType: ContentType.failure,
  //     );
  //     print("[Debug]-> Error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      // 1️⃣ Login API
      final user = await authService.login(email, password);

      // 2️⃣ Save auth data
      await SecureStorage.saveToken(user.token!);
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);
      await SecureStorage.saveTermAndConditionValue(false.toString());

      // 3️⃣ Set user role/type
      await UserHelper.setUserType(
        user.user?.userType,
        sellerType: user.user?.sellerType,
        isAadharVerified: user.user?.isAadharVerified,
      );

      currentUser.value = user;
      authState.value = AuthState.authenticated;

      // 4️⃣ 🔔 NOTIFICATION SYNC
      final userId = user.user?.id?.toString();
      final role = UserHelper.userType?.name ?? 'buyer';

      if (userId != null && userId.isNotEmpty) {
        await NotificationService.instance.attachLoggedInUser(
          userId: userId,
          role: role,
          syncToBackend: (playerId) async {
            // ✅ THIS IS THE SYNC POINT
            await NotificationSyncService.instance.syncToBackend(
              deviceToken: playerId,
              metadata: {'user_id': userId, 'role': role},
            );
          },
        );
      }

      // 5️⃣ Navigate (always LAST)
      if (UserHelper.userType == UserType.buyer) {
        Get.offAll(() => const DashboardScreen());
      } else if (UserHelper.userType == UserType.seller &&
          UserHelper.sellerType == SellerType.owner) {
        Get.offAll(() => const SellerDashboardScreen());
      } else if (UserHelper.userType == UserType.reseller) {
        Get.offAll(() => const MainNavigationScreen());
      } else if (UserHelper.userType == UserType.contractor) {
        Get.offAll(() => ContractorMainScreen());
      } else if (UserHelper.userType == UserType.seller &&
          UserHelper.sellerType == SellerType.builder) {
        Get.offAll(() => const BuilderMainScreen());
      }
    } catch (e) {
      errorMessage.value = e.toString();

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Login Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );

      debugPrint("[Login Error] $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required BuildContext context,

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
            redirectAfterOtp: OtpLoginScreen(),
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

  Future<void> contractorRegister({
    required Map<String, dynamic> data,
    // required String username,
    required String phone,
    // required String contractorType,
    String? referralCode,
  }) async {
    try {
      isLoading.value = true;

      final response = await authService.contractorRegister(
        userType: "contractor",
        data: data,
        // phone: phone,
        // referCode: referralCode,
        // contractorType: contractorType,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        await SecureStorage.saveToken(token);

        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.registration,
            data: data,
            redirectAfterOtp: OtpLoginScreen(),
          ),
        );

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Registration successful. Please verify OTP sent to $phone.',
          contentType: ContentType.success,
        );
        await SecureStorage.setAppLaunched();
      } else {
        throw Exception(
          response['message'] ?? 'Registration failed - no token received',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resellerRegister({
    required Map<String, dynamic> data,
    required String phone,
    String? referralCode,
  }) async {
    try {
      isLoading.value = true;

      final response = await authService.resellerRegister(
        userType: "reseller",
        data: data,
        // phone: phone,
        // referCode: referralCode,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        await SecureStorage.saveToken(token);

        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.registration,
            data: data,
            redirectAfterOtp: OtpLoginScreen(),
          ),
        );
        await SecureStorage.setAppLaunched();

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
    } finally {
      isLoading.value = false;
    }
  }

  /*  Future<void> generateResellerApi(Map<String,dynamic> user) async {

    AppLogger.structured("Fetch User Data After otp verification", user);

      try {
        final Map<String, dynamic> userData = {
         */ /* 'userId': user?.id,
          "certificateData": {
            "firstName": "",
            "lastName": "",
            "username": user?.user?.username,
            "email": user?.user?.email,
            "phone": user?.user?.phone,
          },*/ /*
        };

        final result = await authService.generateResellerCertificate(userData);

        // ✅ Check success based on your API response
        if (result != null && result == true) {
          Fluttertoast.showToast(
            msg: "🎉 Certificate generated successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "⚠️ Failed to generate certificate",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        // Handle unexpected errors
        Fluttertoast.showToast(
          msg: "❌ Error: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
    }
  }*/

  Future<void> sellerRegister({
    required BuildContext context,
    required Map<String, dynamic>? data,

    required String phone,
    required String sellerType,
    required String propertyType,
    required String lookingTo,
    String? referralCode,
  }) async {
    try {
      isLoading.value = true;

      final response = await authService.sellerRegister(
        userType: "seller",
        phone: phone,
        referCode: referralCode,
        sellerType: sellerType,
        propertyType: propertyType,
        lookingTo: lookingTo,
      );

      if (response['success'] == true && response['data']['token'] != null) {
        final token = response['data']['token'];
        await SecureStorage.saveToken(token);
        final otpData = {
          ...?data,
          'phone': phone,
          'userType': 'seller',
          'sellerType': sellerType,
          'referralCode': referralCode ?? '',
          'propertyType': propertyType,
          'lookingTo': lookingTo,
        };

        // Navigate to OTP screen using the passed phone
        Get.to(
          () => OtpVerificationScreen(
            phone: phone,
            token: token,
            verifyOTPFor: VerifyOTPFor.sellerRegister,
            data: otpData,
            redirectAfterOtp: OtpLoginScreen(),
          ),
        );
        await SecureStorage.setAppLaunched();
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
      final user = await authService.sellerRegistrationComplete(data);
      if (user != null) {
        final fallbackSellerType = data['sellerType']?.toString();
        if ((user.user?.sellerType == null || user.user!.sellerType!.isEmpty) &&
            fallbackSellerType != null &&
            fallbackSellerType.isNotEmpty) {
          user.user?.sellerType = fallbackSellerType;
        }

        await SecureStorage.saveToken(user.token!);
        await SecureStorage.saveUserData(user);
        await SecureStorage.saveLoggedIn(true);
        await SecureStorage.saveTermAndConditionValue(false.toString());

        currentUser.value = user;
        await UserHelper.setUserType(
          user.user?.userType,
          sellerType: user.user?.sellerType,
          isAadharVerified: user.user?.isAadharVerified,
        );

        authState.value = AuthState.authenticated;

        // 4️⃣ 🔔 NOTIFICATION SYNC
        final userId = user.user?.id?.toString();
        final role = UserHelper.userType?.name ?? 'buyer';

        if (userId != null && userId.isNotEmpty) {
          await NotificationService.instance.attachLoggedInUser(
            userId: userId,
            role: role,
            syncToBackend: (playerId) async {
              // ✅ THIS IS THE SYNC POINT
              await NotificationSyncService.instance.syncToBackend(
                deviceToken: playerId,
                metadata: {'user_id': userId, 'role': role},
              );
            },
          );
        }

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
      debugPrint(
        "User: ${user.user?.toJson()} =================================================",
      );

      // 2️⃣ Save auth dat
      await SecureStorage.saveTermAndConditionValue(false.toString());

      // 3️⃣ Set user role/type
      await UserHelper.setUserType(
        user.user?.userType,
        sellerType: user.user?.sellerType,
        isAadharVerified: user.user?.isAadharVerified,
      );

      currentUser.value = user;
      authState.value = AuthState.authenticated;

      // 4️⃣ 🔔 NOTIFICATION SYNC

      await UserHelper.setUserType(
        user.user?.userType,
        sellerType: user.user?.sellerType,
        isAadharVerified: user.user?.isAadharVerified,
      );

      final userId = user.user?.id?.toString();
      final role = UserHelper.userType?.name ?? 'buyer';
      if (userId != null && userId.isNotEmpty) {
        await NotificationService.instance.attachLoggedInUser(
          userId: userId,
          role: role,
          syncToBackend: (playerId) async {
            await NotificationSyncService.instance.syncToBackend(
              deviceToken: playerId,
              metadata: {'user_id': userId, 'role': role},
            );
          },
        );
      }

      authState.value = AuthState.authenticated;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToUserPanel() {
    if (UserHelper.userType == UserType.buyer) {
      Get.offAll(() => const DashboardScreen());
    } else if (UserHelper.userType == UserType.seller &&
        UserHelper.sellerType == SellerType.owner) {
      Get.offAll(() => const SellerDashboardScreen());
    } else if (UserHelper.userType == UserType.reseller) {
      Get.offAll(() => const MainNavigationScreen());
    } else if (UserHelper.userType == UserType.contractor) {
      Get.offAll(() => ContractorMainScreen());
    } else if (UserHelper.userType == UserType.seller &&
        UserHelper.sellerType == SellerType.builder) {
      Get.offAll(() => const BuilderMainScreen());
    } else {
      Get.offAll(() => const DashboardScreen());
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
      print("Token data: $data");
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
        Get.offAll(() => OtpLoginScreen());
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

  Future<void> convertBuyerToReseller({
    required String city,
    required String zipCode,
  }) async {
    try {
      isLoading.value = true;
      final user = await authService.convertBuyerToReseller(
        city: city,
        zipCode: zipCode,
      );
      if (user) {
        Get.offAll(() => OtpLoginScreen());
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Conversion Failed",
          message: "Failed to Convert Buyer to Partner",
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

  Future<void> convertBuyerToContractor(String city, String type) async {
    try {
      isLoading.value = true;
      final user = await authService.convertBuyerToContractor(city, type);
      if (user) {
        Get.offAll(() => OtpLoginScreen());
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

      Get.offAll(() => const OtpLoginScreen());

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
    // IMPORTANT: Logout must never hang the UI thread.
    // We do local teardown first, and run network cleanups best-effort.
    try {
      isLoading.value = true;

      final deviceToken =
          await SecureStorage.getFcmToken() ??
          await SecureStorage.getNotificationToken();
      if (deviceToken != null && deviceToken.isNotEmpty) {
        unawaited(
          NotificationSyncService.instance
              .removeNotificationToken(deviceToken)
              .timeout(
                const Duration(seconds: 2),
                onTimeout: () {
                  debugPrint(
                    '⏱️ removeNotificationToken() timed out (continuing)',
                  );
                },
              )
              .catchError((e) {
                debugPrint('❌ removeNotificationToken() failed: $e');
              }),
        );
      }

      await SecureStorage.clearAll().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('⏱️ SecureStorage.clearAll() timed out (continuing)');
        },
      );

      if (Get.isRegistered<PropertyFavoriteController>()) {
        final favoriteController = Get.find<PropertyFavoriteController>();
        favoriteController.clearAllFavoriteState();
        Get.delete<PropertyFavoriteController>(force: true);
      }

      if (Get.isRegistered<BuyerProfileDataController>()) {
        final buyerProfileController = Get.find<BuyerProfileDataController>();
        buyerProfileController.clearProfileState();
        Get.delete<BuyerProfileDataController>(force: true);
      }

      UserHelper.clearUserType();
      currentUser.value = null;
      authState.value = AuthState.unauthenticated;

      unawaited(NotificationService.instance.resetToGuest());
    } catch (e, st) {
      debugPrint('❌ Logout failed: $e');
      debugPrint('Stack: $st');
    } finally {
      isLoading.value = false;
    }

    Get.offAll(() => SplashScreen());
  }
}
