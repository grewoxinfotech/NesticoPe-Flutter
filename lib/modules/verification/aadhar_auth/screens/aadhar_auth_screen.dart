import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../controllers/aadhar_auth_controller.dart';

class AadharAuthScreen extends StatelessWidget {
  final TextEditingController aadharNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AadharAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AadharAuthController controller = Get.put(AadharAuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhar Authentication'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Header section
                  Image.asset(IMGRes.aadhaar, height: 100, fit: BoxFit.contain),
                  // const Icon(
                  //   Icons.credit_card,
                  //   size: 80,
                  //   color: ColorRes.primary,
                  // ),
                  const SizedBox(height: 24),

                  Text(
                    'Verify Your Aadhar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Enter your 12-digit Aadhar number to receive OTP',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),

                  // Aadhar input field
                  NesticoPeTextField(
                    title: 'Aadhar Number',
                    hintText: 'Enter 12-digit Aadhar Number',
                    controller: aadharNumberController,
                    keyboardType: TextInputType.number,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Aadhar Number';
                      }
                      if (value.length != 12) {
                        return 'Aadhar Number must be 12 digits';
                      }
                      if (!RegExp(r'^[2-9][0-9]{11}$').hasMatch(value)) {
                        return 'Please enter a valid Aadhar Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  Obx(() {
                    final isLoading = controller.isLoading.value;
                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.initiateAadharVerification(
                                      aadharNumberController.text.trim(),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isLoading
                                  ? ColorRes.primary.withOpacity(0.6)
                                  : ColorRes.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Info section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: ColorRes.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'OTP will be sent to your Aadhar registered mobile number',
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorRes.primary,
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
        ),
      ),
    );
  }
}
