import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
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
        title:  Text(
          "Memorandum of Understanding",
          style: TextStyle(
            color: Colors.white,
            fontWeight: AppFontWeights.semiBold,
            // fontSize: 18,
          ),
        ),
        backgroundColor: ColorRes.primary,
      ),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                  color: ColorRes.textPrimary
                                ),
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
      ),
    );
  }

  Widget _buildTermsBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          const Text(
            "Terms and Conditions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorRes.textColor
            ),
          ),
          const SizedBox(height: 8),

          /// Intro text
          Text(
            "Please review the following legal agreement carefully before proceeding with your property listing. "
                "This document constitutes a binding agreement between you and the platform.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 16),

          _termItem(
            index: "1",
            title: "Property Accuracy",
            description:
            "The seller confirms all property details provided, including location, dimensions, and amenities, are accurate and truthful.",
          ),

          _termItem(
            index: "2",
            title: "Legal Rights",
            description:
            "The seller warrants they have the full legal right and authorization to list and sell the property described in this application.",
          ),

          _termItem(
            index: "3",
            title: "Fees and Commission",
            description:
            "Agreement to the standard platform commission of 2.5% of the final sale price upon successful closing of the transaction.",
          ),

          _termItem(
            index: "4",
            title: "Validity",
            description:
            "This MOU is valid for a period of 6 months from the date of digital signing, after which it may be renewed.",
          ),
        ],
      ),
    );
  }
  Widget _termItem({
    required String index,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Number Circle
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              index,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: ColorRes.primary,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                      color: ColorRes.textColor
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}