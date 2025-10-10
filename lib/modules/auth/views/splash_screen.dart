import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../dashboard/views/dashboard_screen.dart';

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
  //   bool isLogin = await SecureStorage.getLoggedIn();
  //   String? token = await SecureStorage.getToken();
  //
  //   print("DEBUG >> isLogin=$isLogin, token=$token");
  //
  //   if (isLogin == true && token != null && token.isNotEmpty) {
  //     Get.offAll(() => const DashboardScreen());
  //     print("dashboard_old_token $token");
  //   } else {
  //     Get.offAll(() => const LoginScreen());
  //     print("login_new_token $token");
  //   }
  // }

  void splash() async {
    await Future.delayed(const Duration(seconds: 1));

    bool isLogin = await SecureStorage.getLoggedIn();
    String? token = await SecureStorage.getToken();

    print("DEBUG >> isLogin=$isLogin, token=$token");

    if (isLogin == true && token != null && token.isNotEmpty) {
      if (isLogin == true && token.isNotEmpty) {
        // ✅ Token exists, go to dashboard
        Get.offAll(() => const DashboardScreen());
      } else {
        // ❌ No token, go to login
        // Get.offAll(() => const DashboardScreen());

        Get.offAll(() => const LoginScreen());
      }
    } else {
      // Get.offAll(() => const DashboardScreen());
      Get.offAll(() => const LoginScreen());
      print("login_new_token $token");
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
                        fontSize: 28,
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
                  fontSize: 16,
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
