import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

void showDeleteConfirmationDialog({
  required VoidCallback onConfirm,
  String title = "Delete",
  String message = "Are you sure you want to delete this item?",
  String confirmText = "Delete",
  String cancelText = "Cancel",
  Color confirmColor = Colors.red,
}) {
  Get.dialog(
    Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              title,
              style: TextStyle(fontSize: AppFontSizes.body, fontWeight: AppFontWeights.semiBold,color: ColorRes.textColor),
              
            ),
            const SizedBox(height: 12),

            /// MESSAGE
            Text(
              message,
              style:  TextStyle(fontSize: AppFontSizes.medium, color: ColorRes.black.withOpacity(0.6)),
            ),
            const SizedBox(height: 22),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      cancelText,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back();
                      onConfirm(); // CALL THE CALLBACK
                    },
                    child: Text(
                      confirmText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
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
