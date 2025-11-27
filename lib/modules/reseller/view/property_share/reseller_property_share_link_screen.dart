import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/network/property_share/property_share_service.dart';
import '../../controller/property_share/reseller_property_share_controller.dart';

class ResellerPropertyShareLinkScreen extends StatelessWidget {
  final String shareId;
  final String? propertyId; // made nullable
  final String? resellerId; // made nullable
  final bool isMultiShare;
  final String shareUrl;
  final controller = Get.put(ReSellerPropertyShareController());

  ResellerPropertyShareLinkScreen({
    super.key,
    this.shareUrl = "dhfshdfbgd",
    this.propertyId,
    this.resellerId,
    this.isMultiShare = false,
    required this.shareId,
  }) : assert(
         isMultiShare || (propertyId != null && resellerId != null),
         "❌ propertyId and resellerId are required when isMultiShare is false.",
       );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Share Link',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share Link',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Copy or open the generated link.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              // URL Container
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shareUrl,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: shareUrl));
                      },
                      child: Icon(
                        Icons.copy,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(shareUrl));
                      },
                      child: Icon(
                        Icons.open_in_new,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Delete Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: ColorRes.white,
                        title: Text(
                          "Delete Share Link",
                          style: TextStyle(
                            fontSize: AppFontSizes.large,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        content: Text("Are You Sure To Delete Link"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              final controller =
                                  Get.find<ReSellerPropertyShareController>();
                              controller.deletePropertyShare(shareId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.error,
                            ),
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    // Handle delete
                  },
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text(
                    'Delete Share Link & Form',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              // const SizedBox(height: 32),
              // const Text(
              //   'This property is not added to any group link yet.',
              //   style: TextStyle(fontSize: 14, color: Colors.black87),
              // ),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 24),
              // Generate Group Link Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       // Handle generate group link
              //     },
              //     icon: const Icon(Icons.share, size: 20),
              //     label: const Text(
              //       'Generate Group Link (Includes this property)',
              //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFF3B82F6),
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       elevation: 0,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 24),
              // Social Share Options
              if (!isMultiShare) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 20,
                        runSpacing: 16,
                        children: [
                          _buildShareOption(
                            icon: Icons.chat,
                            label: 'Story',
                            color: const Color(0xFF25D366),
                            onTap: _onWhatsAppStoryTap,
                          ),
                          _buildShareOption(
                            icon: Icons.chat_bubble_outline,
                            label: 'Chat',
                            color: const Color(0xFF25D366),
                            onTap: _onWhatsAppChatTap,
                          ),
                          // _buildShareOption(
                          //   icon: Icons.camera_alt,
                          //   label: 'Story',
                          //   color: const Color(0xFFE4405F),
                          //   onTap: _onInstagramStoryTap,
                          // ),
                          // _buildShareOption(
                          //   icon: Icons.send,
                          //   label: 'Chat',
                          //   color: const Color(0xFFE4405F),
                          //   onTap: _onInstagramChatTap,
                          // ),
                          _buildShareOption(
                            icon: Icons.facebook,
                            label: 'Story',
                            color: const Color(0xFF1877F2),
                            onTap: _onFacebookStoryTap,
                          ),
                          _buildShareOption(
                            icon: Icons.facebook_outlined,
                            label: 'Chat',
                            color: const Color(0xFF1877F2),
                            onTap: _onFacebookChatTap,
                          ),
                          _buildShareOption(
                            icon: Icons.share,
                            label: 'Share',
                            color: Colors.black,
                            onTap: _onGeneralShareTap,
                          ),
                          // _buildShareOption(
                          //   icon: Icons.business_center,
                          //   label: 'Share',
                          //   color: const Color(0xFF0A66C2),
                          //   onTap: _onLinkedInShareTap,
                          // ),
                          _buildShareOption(
                            icon: Icons.email_outlined,
                            label: 'Share',
                            color: const Color(0xFFEF4444),
                            onTap: _onEmailShareTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // 🔗 Centralized Redirect Method
  // -----------------------------
  Future<void> redirectToShare({
    required String platform,
    required String shareType,
  }) async {
    try {
      Get.snackbar("Sharing", "Generating share link for $platform...");

      // 🔹 Call createPropertyShare method that handles share creation & redirection
      await controller.createPropertyShare(
        propertyId: propertyId ?? '',
        resellerId: resellerId ?? '',
        platform: platform,
        shareType: shareType,
      );
    } catch (e) {
      debugPrint("⚠️ redirectToShare Error: $e");
      Get.snackbar("Error", "Something went wrong while sharing: $e");
    }
  }

  // -----------------------------
  // TAP HANDLERS (simple + clean)
  // -----------------------------
  void _onWhatsAppStoryTap() =>
      redirectToShare(platform: "whatsapp", shareType: "success");

  void _onWhatsAppChatTap() =>
      redirectToShare(platform: "whatsapp", shareType: "chat");

  void _onInstagramStoryTap() =>
      redirectToShare(platform: "instagram", shareType: "success");

  void _onInstagramChatTap() =>
      redirectToShare(platform: "instagram", shareType: "chat");

  void _onFacebookStoryTap() =>
      redirectToShare(platform: "facebook", shareType: "success");

  void _onFacebookChatTap() =>
      redirectToShare(platform: "facebook", shareType: "chat");

  void _onLinkedInShareTap() =>
      redirectToShare(platform: "linkedin", shareType: "share");

  void _onEmailShareTap() =>
      redirectToShare(platform: "email", shareType: "share");

  void _onGeneralShareTap() =>
      redirectToShare(platform: "general", shareType: "share");
}
