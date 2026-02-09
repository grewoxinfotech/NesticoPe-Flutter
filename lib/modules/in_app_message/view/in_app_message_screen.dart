import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:intl/intl.dart';

import '../../../data/network/in_app_messaging/model/in_app_messaging_model.dart';
import '../../../utils/shimmer/common_screen/in_app_message/in_app_message_list_screen_shimmer.dart';
import '../controller/in_app_message_controller.dart';
import 'in_app_message_detail screen.dart';

class InAppMessageScreen extends StatelessWidget {
  const InAppMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
        Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),

        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        actions: [
          Obx(
            () =>
                controller.items.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.done_all_rounded),
                      tooltip: "Mark all as read",
                      onPressed: () async {
                        await controller.markAllRead();
                      },
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshNotifications,
        color: Theme.of(context).primaryColor,
        child: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return InAppMessageListScreenShimmer();
          }

          if (controller.items.isEmpty) {
            return RefreshIndicator(onRefresh: controller.refreshNotifications,child: _EmptyState());

          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount:
                controller.items.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.items.length) {
                controller.loadMore();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }

              final notification = controller.items[index];

              return _NotificationCard(
                notification: notification,
                index: index,
              );
            },
          );
        }),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: ColorRes.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No notifications yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You're all caught up!",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  final NotificationItem notification;
  final int index;

  const _NotificationCard({required this.notification, required this.index});

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final NotificationController controller = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Stagger animations
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.notification.metadata;
    final date =
        widget.notification.createdAt != null
            ? _formatDate(widget.notification.createdAt!)
            : "";

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => NotificationDetailScreen(
                          notification: widget.notification,
                        ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(metadata),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.notification.title ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              // Unread indicator (optional)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: ColorRes.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.notification.message ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  await controller.markedReadNotification(
                                    widget.notification.id ?? '',
                                  );
                                },
                                child: Text(
                                  "Mark As Read",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorRes.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildNotificationIcon(metadata) {
    if (metadata?.image != null) {
      return Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            metadata!.image!,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _defaultIcon(),
          ),
        ),
      );
    }
    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: ColorRes.primary,

        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.notifications_rounded,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }
}
