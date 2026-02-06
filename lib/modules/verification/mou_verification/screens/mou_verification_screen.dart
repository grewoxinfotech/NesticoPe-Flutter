import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:signature/signature.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../controllers/mou_verification_controller.dart';

class MouVerificationScreen extends StatelessWidget {
  final DigitalSignatureController? controller;

  MouVerificationScreen({
    super.key,
    this.controller,
  });

  // Use the passed controller or try to find it
  DigitalSignatureController get _controller =>
      controller ?? Get.find<DigitalSignatureController>(tag: 'signature');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorRes.white,
        title: const Text(
          "Memorandum of Understanding",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ColorRes.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                      () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermsBox(),
                        const SizedBox(height: 12),

                        /// Checkbox
                        Obx(
                              () => CheckboxListTile(
                            value: _controller.isAgreed.value,
                            onChanged: (val) =>
                            _controller.isAgreed.value = val ?? false,
                            title: const Text(
                              "I have read and agree to the terms of the MOU",
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),

                        const SizedBox(height: 8),
                        if (_controller.isAgreed.value) ...[
                          /// Name Field
                          NesticoPeTextField(
                            title: "Full Name",
                            isRequired: true,
                            hintText: "Enter your full name",
                            controller: _controller.nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icons.person,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter your full name";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          /// Signature
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Digital Signature',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      color: ColorRes.textSecondary,
                                      fontWeight: AppFontWeights.bold,
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(color: ColorRes.error),
                                  )
                                ],
                              ),
                              TextButton(
                                onPressed: _controller.clearSignature,
                                child: const Text("Clear"),
                              ),
                            ],
                          ),

                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorRes.leadGreyColor.shade300,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: ColorRes.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Signature(
                                controller: _controller.signatureController,
                                height: double.infinity,
                                width: double.infinity,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(height: 24),
                        ]
                      ],
                    );
                  },
                ),
              ),
            ),

            /// Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                        () => ElevatedButton(
                      onPressed: _controller.isUploadLoading.value
                          ? null
                          : _controller.submitMou,
                      child: _controller.isUploadLoading.value
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text("Agree & Sign"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Terms and Conditions\n\n"
            "This Memorandum of Understanding (MOU) sets forth the terms and understanding "
            "between the Seller and our platform regarding the listing and management of properties.\n\n"
            "1. The Seller confirms that all information provided regarding the property is accurate.\n"
            "2. The Seller holds the legal right to sell or rent the property.\n"
            "3. The Seller agrees to service fees and commission structure.\n"
            "4. Disputes will be subject to jurisdiction of local courts.\n\n"
            "By signing this document, you acknowledge that you have read and agreed.",
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}