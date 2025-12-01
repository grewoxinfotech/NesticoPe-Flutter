import 'package:flutter/material.dart';

import '../controller/subscription_controller.dart';
import 'widgets/subscription_plan_widget.dart';
import 'package:get/get.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  final String role;

  const SubscriptionPlansScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionPlanController(userRole: role));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Plans"),
        automaticallyImplyLeading: false,
      ),
      body: SubscriptionPlansWidget(controller: controller),
    );
  }
}
