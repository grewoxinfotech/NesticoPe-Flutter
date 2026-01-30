import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/enum.dart';

import '../../../subscription/views/suscription_plan_screen.dart';

class ResellerSubscriptionPlanScreen extends StatelessWidget {
  const ResellerSubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionPlansScreen(
      role: Roles.reseller.name,
      isShowCurrentPlan: true,
    );
  }
}
