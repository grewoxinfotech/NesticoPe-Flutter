import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/in_app_messaging/model/in_app_messaging_model.dart';
import '../controller/in_app_message_controller.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationItem notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    NotificationController notificationController =
        Get.find<NotificationController>();
    final metadata = notification.metadata;
    final date =
        notification.createdAt != null
            ? DateFormat(
              "EEEE, dd MMMM yyyy 'at' hh:mm a",
            ).format(notification.createdAt!)
            : "";

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: metadata?.image != null ? 280 : 120,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            leading: IconButton(
              icon: _circleIcon(const Icon(Icons.arrow_back, size: 20)),
              onPressed: () => Navigator.pop(context),
            ),
            /*  actions: [
              IconButton(
                icon: _circleIcon(const Icon(Icons.more_vert, size: 20)),
                onPressed: () => _showMoreOptions(context),
              ),
              const SizedBox(width: 8),
            ],*/
            flexibleSpace: FlexibleSpaceBar(
              background:
                  metadata?.image != null
                      ? _buildHeaderImage(metadata!.image!)
                      : _buildHeaderGradient(),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Main Card
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          notification.title ?? "Notification",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: AppFontWeights.bold,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Date
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${date.split(", ").first},',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    date.split(", ").last,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Divider(color: Colors.grey[200]),
                        const SizedBox(height: 12),

                        // Message
                        Text(
                          notification.message ??
                              "No message content available.",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorRes.leadGreyColor.shade800,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (metadata != null) _buildMetadataSection(metadata),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                _buildActionButtons(
                  notificationController,
                  notification.id ?? '',
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Helpers ----------

  Widget _circleIcon(Icon icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: icon,
    );
  }

  Widget _buildHeaderImage(String imageUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildHeaderGradient(),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorRes.primary, Colors.purple[500]!],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.notifications_rounded,
          size: 64,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildMetadataSection(dynamic metadata) {
    final items = <MapEntry<String, dynamic>>[];

    try {
      final json = metadata.toJson();
      json.forEach((k, v) {
        if (v != null && k != 'image' && v.toString().isNotEmpty) {
          items.add(MapEntry(k, v));
        }
      });
    } catch (_) {}

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey[200]),
        const SizedBox(height: 16),
        Text(
          "Additional Details",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((e) => _metaRow(e.key, e.value)),
      ],
    );
  }

  Widget _metaRow(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: ColorRes.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatKey(key),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(NotificationController controller, String id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await controller.markedReadNotification(id);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Mark as Read",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: Get.back,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorRes.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Dismiss",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map(
          (w) =>
              w.isEmpty
                  ? ''
                  : w[0].toUpperCase() + w.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sheetItem(
                    Icons.check_circle_outline,
                    "Mark as Read",
                    context,
                  ),
                  _sheetItem(
                    Icons.delete_outline,
                    "Delete Notification",
                    context,
                    destructive: true,
                  ),
                  _sheetItem(Icons.share_outlined, "Share", context),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }

  Widget _sheetItem(
    IconData icon,
    String title,
    BuildContext context, {
    bool destructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: destructive ? ColorRes.error : ColorRes.leadGreyColor.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: destructive ? ColorRes.error : ColorRes.leadGreyColor.shade700,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
