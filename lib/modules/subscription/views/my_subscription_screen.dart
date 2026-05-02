import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/activate_subscription_dialog.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/cancel_subscription_dialog.dart';
import 'package:nesticope_app/modules/support_ticket/controllers/support_ticket_controller.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/utils/formater/formater.dart';
import '../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import '../../../utils/shimmer/common_screen/my_subscription/my_subscription_list_screen.dart';
import '../controller/user_subscription_controller.dart';

class MySubscriptionScreen extends StatelessWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrentUserPlanController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        title: Text(
          "My Subscriptions",
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      ),
      body: SafeArea(

        child: Obx(() {
          /// Initial loading
          if (controller.isLoading.value && controller.items.isEmpty) {
            return MySubscriptionListScreenShimmer();
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

                final bool canActivateImmediately =
                    (item.status ?? '').toLowerCase() == 'pending';

                return _SubscriptionCard(
                  planName: plan?.name ?? "Unknown Plan",
                  startDate: startDate,
                  endDate: endDate,
                  price: price,
                  status: item.status ?? '',
                  planId: item.id,
                  canActivateImmediately: canActivateImmediately,
                  onActivate: () => controller.activateSubscription(item.id),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

/// ================= CARD UI =================

class _SubscriptionCard extends StatelessWidget {
  final String planId;
  final String planName;
  final String startDate;
  final String endDate;
  final String price;
  final String status;
  final bool canActivateImmediately;
  final Future<bool> Function() onActivate;

  const _SubscriptionCard({
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
    required this.planId,
    required this.canActivateImmediately,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final ticketController = Get.put(SupportTicketController());
    final statusColor = getColor(status);

    // final statusText = status ? "Active" : "Expired";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Expanded(
                child: Text(
                  planName,
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorRes.textColor,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.capitalize.toString(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.dialog(
                    CancelSubscriptionDialog(
                      onSubmit: (reason) {
                        ticketController.submitTicket(
                          payload: TicketCreateRequest(
                            title: 'Subscription Cancellation Request: ${planName}',
                            description:
                                'Reason for cancellation: ${reason.trim()}\n\n Subscription Details: \n- Plan ID: ${planId} \n- Plan Name: ${planName} \n- Start Date: ${startDate} \n- End Date: ${endDate} \n- Price: ${price}',
                            category: 'subscription_cancellation',
                            ticketType: "cancellation",
                            relatedId: planId,
                            priority: "medium",
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
              ),
            ],
          ),

          /// Details
          _row("Start Date", startDate),
          _row("End Date", endDate),
          _row("Price", price),
          if (canActivateImmediately) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Get.dialog(
                    ActivateSubscriptionDialog(
                      planName: planName,
                      onConfirm: onActivate,
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Activate now'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: ColorRes.textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: ColorRes.textPrimary))),
        ],
      ),
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
