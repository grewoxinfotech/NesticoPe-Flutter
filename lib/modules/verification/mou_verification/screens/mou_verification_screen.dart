import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../controllers/mou_controller.dart';

class MouVerificationScreen extends StatelessWidget {
  MouVerificationScreen({super.key});

  final MouController controller = Get.put(MouController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memorandum of Understanding (MOU)"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermsBox(),
                    const SizedBox(height: 12),

                    /// Checkbox
                    Obx(
                      () => CheckboxListTile(
                        value: controller.isAgreed.value,
                        onChanged:
                            (val) => controller.isAgreed.value = val ?? false,
                        title: const Text(
                          "I have read and agree to the terms of the MOU",
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Name Field
                    const Text("* Full Name"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Signature
                    const Text("* Digital Signature"),
                    const SizedBox(height: 6),

                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Signature(
                        controller: controller.signatureController,
                        backgroundColor: Colors.white,
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.clearSignature,
                        child: const Text("Clear"),
                      ),
                    ),
                  ],
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
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : controller.submitMou,
                      child:
                          controller.isLoading.value
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
