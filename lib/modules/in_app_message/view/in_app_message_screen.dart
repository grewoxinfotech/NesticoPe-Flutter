import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/network/in_app_messaging/model/in_app_messaging_model.dart';
import '../controller/in_app_message_controller.dart';

class InAppMessageScreen extends StatelessWidget {
  const InAppMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: controller.refreshNotifications,
        child: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.items.isEmpty) {
            return const Center(child: Text("No notifications found"));
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount:
                controller.items.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.items.length) {
                controller.loadMore();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final notification = controller.items[index];

              return _NotificationCard(notification: notification);
            },
          );
        }),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final metadata = notification.metadata;
    final date =
        notification.createdAt != null
            ? DateFormat("dd MMM yyyy, hh:mm a").format(notification.createdAt!)
            : "";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (metadata?.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  metadata!.image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.notifications, size: 40),
                ),
              )
            else
              const Icon(Icons.notifications, size: 40),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? "",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
