import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import '../../../../../widgets/messages/snack_bar.dart';
import '../../login_screen.dart';
import '../covert_to_reseller/convert_to_reseller.dart';

class SellerConversionScreen extends StatefulWidget {
  const SellerConversionScreen({super.key});

  @override
  State<SellerConversionScreen> createState() => _SellerConversionScreenState();
}

class _SellerConversionScreenState extends State<SellerConversionScreen> {
  String? _selectedSellerType;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AuthController());
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);
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
                  // LEFT SECTION (Top)
                  Container(
                    padding: const EdgeInsets.only(
                      top: 60,
                      bottom: 20,
                      left: 16,
                      right: 16,
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
                            color: ColorRes.whiteShade.withOpacity(0.9),
                            fontSize: AppFontSizes.bodyMedium,
                            fontWeight: AppFontWeights.regular,
                            // letterSpacing: 0.5,
                            // fontWeight: AppFontWeights.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start Selling as a Builder or Property Seller",
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
                          "Expand your market reach and connect with serious buyers effortlessly.",
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

                  // RIGHT SECTION (Bottom)
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
                        // TITLE
                        Text(
                          "Become a Seller",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontFamily: 'Exo',
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.bold,
                            fontSize: AppFontSizes.large,
                            // letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "You're just one step away from posting your properties!",
                          style: TextStyle(
                            fontFamily: 'Exo',
                            color: ColorRes.blackShade54,
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // INFO BOX
                        buildContentContainer(text, sellerOption),

                        const SizedBox(height: 16),

                        // SELLER TYPE SELECTION
                        Text(
                          "Seller Type",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            // fontSize: 14,
                            color: ColorRes.textPrimary,
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildRadioOption("Owner"),
                            const SizedBox(width: 24),
                            _buildRadioOption("Builder"),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // BUTTON
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed:
                                  controller.isLoading.value
                                      ? null
                                      : () {
                                        if (_selectedSellerType == null) {
                                          NesticoPeSnackBar.showAwesomeSnackbar(
                                            title: "Error",
                                            message:
                                                "Please choose whether you are an Owner or a Builder",
                                            contentType: ContentType.failure,
                                          );
                                        } else {
                                          controller.covertBuyerToSeller(
                                            _selectedSellerType!.toLowerCase(),
                                          );
                                        }
                                      },
                              child:
                                  controller.isLoading.value
                                      ? Text(
                                        "Converting...",
                                        style: TextStyle(
                                          fontSize: AppFontSizes.body,
                                        ),
                                      )
                                      : Text(
                                        "Convert to Seller →",
                                        style: TextStyle(
                                          fontSize: AppFontSizes.body,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // LOGIN TEXT
                        SizedBox(
                          width: double.infinity,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                color: ColorRes.blackShade87,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                              children: [
                                TextSpan(
                                  text: " Login here",
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

  Widget _buildCheckText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, color: ColorRes.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.blackShade87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          activeColor: ColorRes.primary,
          groupValue: _selectedSellerType,
          onChanged: (value) {
            setState(() {
              _selectedSellerType = value;
            });
          },
        ),
        Text(label, style: const TextStyle(fontSize: AppFontSizes.bodySmall)),
      ],
    );
  }
}
