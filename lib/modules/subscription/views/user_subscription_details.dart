import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import '../../reseller/view/property_reseller.dart';
import '../controller/user_subscription_controller.dart';

class UserSubscriptionDetails extends StatelessWidget {
  const UserSubscriptionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrentUserPlanController());

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorRes.white,
        title: const Text(
          "My Subscription Details",
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final item =
            controller.items.isNotEmpty ? controller.items.first : null;
        if (item == null) {
          return const Center(child: Text("No subscription found"));
        }

        final plan = item.plan;
        final int used =
            item.usedProperties > 0 ? item.usedProperties : item.usedServices;

        final int max =
            (item.metadata?['maxProperties'] ??
                        item.metadata?['maxServices'] ??
                        0)
                    is String
                ? int.tryParse(
                      item.metadata?['maxProperties'] ??
                          item.metadata?['maxServices'] ??
                          '0',
                    ) ??
                    0
                : (item.metadata?['maxProperties'] ??
                    item.metadata?['maxServices'] ??
                    0);

        final double percent = max <= 0 ? 0.0 : used / max;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorRes.leadGreyColor.shade300,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.deepPurple,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "My Plan Details",
                      style: TextStyle(
                        color: Colors.deepPurple.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "ACTIVE",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: "Currently on "),
                      TextSpan(
                        text: plan?.name ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const TextSpan(
                        text: " - View your plan details and usage statistics",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 100, // Fixed height for each card
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    // Map index to your cards
                    final cards = [
                      (
                        'Start Date',
                        Formatter.formatDate(item.startDate.toString()),
                        Icons.timer_outlined,
                        ColorRes.deepPurpleColor,
                      ),
                      (
                        'Expiry Date',
                        Formatter.formatDate(item.endDate.toString()),
                        Icons.calendar_month_outlined,
                        ColorRes.green,
                      ),
                      (
                        'Plan Amount',
                        Formatter.formatPrice(
                          double.tryParse(plan?.amount ?? "0") ?? 0,
                        ),
                        Icons.currency_rupee_outlined,
                        ColorRes.orangeColor,
                      ),
                      (
                        'Subscription Tier',
                        plan?.isPremium == true ? "Premium" : "Basic",
                        Icons.star_rounded,
                        ColorRes.purpleColor,
                      ),
                    ];
                    return buildMetricCard(
                      cards[index].$1,
                      cards[index].$2,
                      cards[index].$3,
                      cards[index].$4,
                    );
                  },
                ),
                const Text(
                  "Plan Usage",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "$used / $max",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Total Used",
                      style: TextStyle(color: Colors.black54, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: percent,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.deepPurple.shade400,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 6),
                Text(
                  "${max - used} remaining in your current cycle",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _planCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
