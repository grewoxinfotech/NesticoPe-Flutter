import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:housing_flutter_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:housing_flutter_app/modules/saved_property/controllers/property_favorite_controller.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
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
      if (!isLogin) {
        final data = await SecureStorage.getTermAndConditionValue();
        log("Sjhdshuh $data");
        bool isAcceptable = data == "true";
        if (!isAcceptable) {
          await SecureStorage.saveTermAndConditionValue(false.toString());
        }
      }

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
        final selected = "Surat";
        // final selected = await Get.to(() => SelectCityScreen());
        print("Selected city: ${selected}");

        if (selected != null) {
          await SecureStorage.saveSelectedCity(selected ?? "");
        }
      }

      // ✅ Continue to dashboard (guest or logged in)
      Get.put(PropertyFavoriteController(), permanent: true);

      if (UserHelper.isBuyer) {
        Get.offAll(() => const DashboardScreen());
        return;
      }
      if (UserHelper.isSellerOwner) {
        Get.offAll(() => const SellerDashboardScreen());
        return;
      }
      if (UserHelper.isSellerBuilder) {
        Get.offAll(() => const BuilderMainScreen());
        return;
      }
      if (UserHelper.isContractor) {
        Get.offAll(() => const ContractorMainScreen());
        return;
      }
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
