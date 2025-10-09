import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import '../../login_screen.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT SECTION (Top)
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
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Find Your Perfect\nLuxury Home",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Find a property that perfectly aligns with your lifestyle, needs, and aspirations",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TAG
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Seller Conversion",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TITLE
                    Text(
                      "Become a Seller",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: ColorRes.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You're just one step away from posting your properties!",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(height: 24),

                    // INFO BOX
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "What happens next?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildCheckText(
                            "Your account will be converted to a seller account",
                          ),
                          const SizedBox(height: 8),
                          _buildCheckText(
                            "You can immediately start posting properties",
                          ),
                          const SizedBox(height: 8),
                          _buildCheckText(
                            "Access to seller dashboard and analytics",
                          ),
                          const SizedBox(height: 8),
                          _buildCheckText("Manage your property listings"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SELLER TYPE SELECTION
                    const Text(
                      "Seller Type*",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () {
                                    if (_selectedSellerType == null) {
                                      Get.snackbar(
                                        "Select Seller Type",
                                        "Please choose whether you are an Owner or a Builder",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
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
                                    style: TextStyle(fontSize: 16),
                                  )
                                  : Text(
                                    "Convert to Seller →",
                                    style: TextStyle(fontSize: 16),
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
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: "Login here",
                              style: const TextStyle(
                                color: ColorRes.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorRes.primary,
                                fontWeight: FontWeight.w600,
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
        const Icon(Icons.check, color: ColorRes.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
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
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
