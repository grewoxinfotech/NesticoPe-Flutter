import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/subscription/views/widgets/cancel_subscription_dialog.dart';

import '../../../app/utils/formater/formater.dart';
import '../controller/user_subscription_controller.dart';

class MySubscriptionScreen extends StatelessWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrentUserPlanController());

    return Scaffold(
      appBar: AppBar(title: const Text("My Subscriptions")),
      body: Obx(() {
        /// Initial loading
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Empty state
        if (controller.items.isEmpty) {
          return const Center(child: Text("No subscriptions found"));
        }

        return NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge && metrics.pixels != 0) {
              controller.loadMore();
            }
            return false;
          },

          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              /// Pagination loader at bottom
              if (index == controller.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = controller.items[index];
              final plan = item.plan;

              final String startDate = Formatter.formatDate(
                item.startDate.toString(),
              );

              final String endDate = Formatter.formatDate(
                item.endDate.toString(),
              );

              final String price = Formatter.formatPrice(
                double.tryParse(plan?.amount ?? "0") ?? 0,
              );

              final bool isActive = DateTime.now().isBefore(item.endDate!);

              return _SubscriptionCard(
                planName: plan?.name ?? "Unknown Plan",
                startDate: startDate,
                endDate: endDate,
                price: price,
                status: item.status ?? '',
              );
            },
          ),
        );
      }),
    );
  }
}

/// ================= CARD UI =================

class _SubscriptionCard extends StatelessWidget {
  final String planName;
  final String startDate;
  final String endDate;
  final String price;
  final String status;

  const _SubscriptionCard({
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            /// Header with accent color bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                border: Border(
                  left: BorderSide(color: statusColor, width: 4),
                ),
              ),
              child: Row(
                children: [
                  /// Plan icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.card_membership,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Plan name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status.capitalize.toString(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Cancel button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.dialog(CancelSubscriptionDialog());
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                      iconSize: 20,
                      tooltip: 'Cancel Subscription',
                    ),
                  ),
                ],
              ),
            ),

            /// Details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _detailRow(
                    icon: Icons.calendar_today_outlined,
                    label: "Start Date",
                    value: startDate,
                    iconColor: Colors.blue,
                  ),
                  const Divider(height: 20),
                  _detailRow(
                    icon: Icons.event_outlined,
                    label: "End Date",
                    value: endDate,
                    iconColor: Colors.orange,
                  ),
                  const Divider(height: 20),
                  _detailRow(
                    icon: Icons.payments_outlined,
                    label: "Price",
                    value: price,
                    iconColor: Colors.green,
                    isPrice: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isPrice = false,
  }) {
    return Row(
      children: [
        /// Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),

        /// Label
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        /// Value
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: isPrice ? 16 : 14,
              fontWeight: isPrice ? FontWeight.bold : FontWeight.w600,
              color: isPrice ? Colors.green.shade700 : Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
