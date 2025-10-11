import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import '../../login_screen.dart';

class ResellerConversionScreen extends StatelessWidget {
  const ResellerConversionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AuthController());
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ColorRes.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 24,
                  left: 16,
                  right: 24,
                ),
                decoration: const BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.only(
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
                        color: ColorRes.whiteShade,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Find Your Perfect\nLuxury Home",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: ColorRes.white,
                        fontWeight: AppFontWeights.extraBold
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Find a property that perfectly aligns with your lifestyle, needs, and aspirations",
                      style: TextStyle(
                        color: ColorRes.whiteShade,
                        fontWeight: AppFontWeights.bold,
                        // fontWeight: FontWeAght.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:  Text(
                        "Reseller Conversion",
                        style: TextStyle(
                          color: ColorRes.white,
                          fontWeight: AppFontWeights.semiBold,
                          // fontWeight: AppFontWeights.semiBold,
                          fontSize: AppFontSizes.small,
                          // fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Become a Reseller",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: ColorRes.primary,
                        fontWeight: AppFontWeights.extraBold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You're just one step away from becoming a property reseller!",
                      style: TextStyle(color: ColorRes.blackShade54, fontSize: AppFontSizes.small,),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        // color: ColorRes.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorRes.leadGreyColor.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What happens next?",
                            style: TextStyle(
                              fontWeight: AppFontWeights.extraBold,
                              // fontWeight: FontWeight.bold,
                              color: ColorRes.blackShade87,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildCheckText(
                            "Your account will be converted to a reseller account",
                          ),
                          SizedBox(height: 8),
                          _buildCheckText(
                            "Your application will be sent for admin approval",
                          ),
                          SizedBox(height: 8),
                          _buildCheckText(
                            "Once approved, you can start promoting properties",
                          ),
                          SizedBox(height: 8),
                          _buildCheckText(
                            "You'll receive email notification about your approval status",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.isLoading.value
                                    ? ColorRes.primary.withOpacity(0.3)
                                    : ColorRes.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () {
                                    controller.convertBuyerToReseller();
                                  },
                          child:
                              controller.isLoading.value
                                  ? Text(
                                    "Converting...",
                                    style: TextStyle(fontSize: AppFontSizes.body),
                                  )
                                  : Text(
                                    "Confirm - Convert to Reseller →",
                                    style: TextStyle(fontSize: AppFontSizes.body),
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                            color: ColorRes.blackShade87,
                            fontSize: AppFontSizes.medium,
                          ),
                          children: [
                            TextSpan(
                              text: "Login here",
                              style: TextStyle(
                                color: ColorRes.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorRes.primary,
                                fontWeight: AppFontWeights.semiBold,
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
    );
  }

  Widget _buildCheckText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: ColorRes.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style:  TextStyle(fontSize: AppFontSizes.small, color: ColorRes.blackShade87),
          ),
        ),
      ],
    );
  }
}
