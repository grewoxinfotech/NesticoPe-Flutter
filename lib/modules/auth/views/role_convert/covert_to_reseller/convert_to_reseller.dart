import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';

import '../../../../../app/constants/color_res.dart';
import '../../../controllers/auth_controller.dart';
import '../../login_screen.dart';
import '../../widget/city_zip_code_selector.dart';

class ResellerConversionScreen extends StatelessWidget {
  const ResellerConversionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _cityController = TextEditingController();
    final _zipcodeController = TextEditingController();
    Get.lazyPut(() => AuthController());
    final controller = Get.find<AuthController>();
    final List<String> options = [
      "Your account will be converted to a reseller account",
      "Your application will be sent for admin approval",
      "You'll receive email notification about your approval status",
      "Once approved, you can start promoting properties",
    ];
    final text = "What happens next?";
    final List<String> sellerOption = [
      "Your account will be converted to a seller account",
      "You can immediately start posting properties",
      "Access to seller dashboard and analytic",
      "Manage your property listings",
    ];

    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.only(
                      top: 60,
                      bottom: 20,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorRes.primary,
                          ColorRes.primary.withOpacity(0.85),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            // fontFamily: 'Exo',
                            color: ColorRes.whiteShade.withOpacity(0.9),
                            fontSize: AppFontSizes.bodyMedium,
                            fontWeight: AppFontWeights.regular,
                            // letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Find Your Perfect Luxury Home",
                          style: TextStyle(
                            // fontFamily: 'Exo',
                            color: ColorRes.white,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: AppFontSizes.large,
                            // letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Find a property that perfectly aligns with your lifestyle, needs, and aspirations",
                          style: TextStyle(
                            fontFamily: 'Exo',
                            color: ColorRes.whiteShade.withOpacity(0.85),
                            fontWeight: AppFontWeights.regular,
                            fontSize: AppFontSizes.small,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: ColorRes.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "Become a Partner",
                          style: TextStyle(
                            fontFamily: 'Exo',
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.bold,
                            fontSize: AppFontSizes.large,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Subtitle
                        Text(
                          "You're just one step away from becoming a property reseller!",
                          style: TextStyle(
                            fontFamily: 'Exo',
                            color: ColorRes.blackShade54,
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.regular,

                            // letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // What happens next section
                        buildContentContainer("What happens next?", options),
                        const SizedBox(height: 32),

                        CityZipcodeSelector(
                          onSelected: (city, zipcode) {
                            _cityController.text = city;
                            _zipcodeController.text = zipcode;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Convert Button
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.isLoading.value
                                        ? ColorRes.primary.withOpacity(0.5)
                                        : ColorRes.primary,
                                foregroundColor: ColorRes.white,
                                elevation: controller.isLoading.value ? 0 : 2,
                                shadowColor: ColorRes.primary.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                              onPressed:
                                  controller.isLoading.value
                                      ? null
                                      : () {
                                        if (_cityController.text.isEmpty ||
                                            _zipcodeController.text.isEmpty) {
                                          controller.convertBuyerToReseller(
                                            city: _cityController.text.trim(),
                                            zipCode:
                                                _zipcodeController.text.trim(),
                                          );
                                        } else {
                                          NesticoPeSnackBar.showAwesomeSnackbar(
                                            title: 'Error',
                                            message:
                                                'Please select a city and zipcode',
                                            contentType: ContentType.failure,
                                          );
                                        }
                                      },
                              child:
                                  controller.isLoading.value
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    ColorRes.white.withOpacity(
                                                      0.7,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "Converting...",
                                            style: TextStyle(
                                              fontFamily: 'Exo',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Confirm - Convert to Partner",
                                            style: TextStyle(
                                              fontFamily: 'Exo',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.arrow_forward, size: 20),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Link
                        SizedBox(
                          width: double.infinity,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontFamily: 'Exo',
                                color: ColorRes.blackShade87,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login here",
                                  style: TextStyle(
                                    fontFamily: 'Exo',
                                    color: ColorRes.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: ColorRes.primary,
                                    fontWeight: AppFontWeights.semiBold,
                                    // letterSpacing: 0.2,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => const LoginScreen());
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 16,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Container buildContentContainer(String title, List<String> textList) {
  return Container(
    decoration: BoxDecoration(
      color: ColorRes.white.withOpacity(0.02),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.shade300.withOpacity(0.5),
        width: 1,
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Exo',
            fontWeight: FontWeight.w500,
            fontSize: AppFontSizes.small,
            color: ColorRes.blackShade87,
            // letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          textList.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index < textList.length - 1 ? 12 : 0,
            ),
            child: buildCheckText(textList[index]),
          ),
        ),
      ],
    ),
  );
}

Widget buildCheckText(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: ColorRes.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: ColorRes.primary, size: 14),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Exo',
            fontSize: AppFontSizes.small,
            color: ColorRes.blackShade87,
            fontWeight: FontWeight.w400,
            // height: 1.5,
            // letterSpacing: 0.1,
          ),
        ),
      ),
    ],
  );
}
