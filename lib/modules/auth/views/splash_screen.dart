import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../home/views/select_city_screen/select_city_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();

    splash();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // void splash() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   bool isLogin = await SecureStorage.getLoggedIn();
  //   String? token = await SecureStorage.getToken();
  //
  //   print("DEBUG >> isLogin=$isLogin, token=$token");
  //
  //   if (isLogin == true && token != null && token.isNotEmpty) {
  //     if (isLogin == true && token.isNotEmpty) {
  //       // ✅ Token exists, go to dashboard
  //       Get.offAll(() => const DashboardScreen());
  //     } else {
  //       // ❌ No token, go to login
  //       // Get.offAll(() => const DashboardScreen());
  //
  //       Get.offAll(() => const LoginScreen());
  //     }
  //   } else {
  //     // Get.offAll(() => const DashboardScreen());
  //     Get.offAll(() => const LoginScreen());
  //     print("login_new_token $token");
  //   }
  // }

  // Future<void> splash() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   try {
  //     // Initialize user type once (can be guest if not logged in)
  //     await UserHelper.initUserType();
  //
  //     // Fetch login info from secure storage
  //     final bool isLogin = await SecureStorage.getLoggedIn();
  //     final String? token = await SecureStorage.getToken();
  //
  //     print(
  //       "DEBUG >> isLogin=$isLogin, token=$token, role=${UserHelper.userType}",
  //     );
  //
  //     // If user is logged in but token missing/invalid → clear data
  //     if (isLogin && (token == null || token.isEmpty)) {
  //       await SecureStorage.clearAll();
  //       UserHelper.clearUserType();
  //     }
  //
  //     // ⚙️ Your logic: Allow guest mode / show onboarding / etc.
  //     // Instead of forcing login, navigate to a neutral screen
  //     // like Home or Explore
  //     Get.offAll(() => const DashboardScreen());
  //
  //     // Optional: if you still want to send logged-in users differently
  //     // if (isLogin && token != null && token.isNotEmpty) {
  //     //   Get.offAll(() => const DashboardScreen());
  //     // } else {
  //     //   Get.offAll(() => const LoginScreen());
  //     // }
  //   } catch (e) {
  //     print("Error during splash init: $e");
  //     Get.offAll(() => const LoginScreen());
  //   }
  // }

  Future<void> splash() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Initialize user type (can be guest if not logged in)
      await UserHelper.initUserType();

      // Fetch login info from secure storage
      final bool isLogin = await SecureStorage.getLoggedIn();
      final String? token = await SecureStorage.getToken();
      final String? selectedCity =
          await SecureStorage.getSelectedCity(); // 🆕 store selected city locally

      print(
        "DEBUG >> isLogin=$isLogin, token=$token, role=${UserHelper.userType}, city=$selectedCity",
      );

      // 🔹 Handle invalid login state (logged in but token missing)
      if (isLogin && (token == null || token.isEmpty)) {
        await SecureStorage.clearAll();
        UserHelper.clearUserType();
      }

      // 🔹 City selection logic
      if (selectedCity == null || selectedCity.isEmpty) {
        // Ask user to select city before going to dashboard
        final selected = await Get.to(() => SelectCityScreen());
        print("Selected city: ${selected}");

        if (selected != null) {
          await SecureStorage.saveSelectedCity(selected ?? "");
        }
      }

      // ✅ Continue to dashboard (guest or logged in)
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      print("❌ Error during splash init: $e");
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorRes.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            ScaleTransition(
              scale: _animation,
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.home_work,
                          size: 60,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'NesticoPe',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: AppFontSizes.displaySmall,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tagline with fade animation
            FadeTransition(
              opacity: _animation,
              child: Text(
                'House Cleaning Service',
                style: TextStyle(
                  color: ColorRes.leadGreyColor.shade700,
                  fontSize: AppFontSizes.body,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // Loading indicator
            const SizedBox(height: 60),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.secondary,
              ),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
