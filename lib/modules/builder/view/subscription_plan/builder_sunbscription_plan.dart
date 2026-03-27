import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/enum.dart';

import '../../../subscription/views/suscription_plan_screen.dart';

class BuilderSubscriptionPlanScreen extends StatelessWidget {
  const BuilderSubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionPlansScreen(
      role: Roles.sellerBuilder.name,
      isShowCurrentPlan: true,
      isNotFromBuyerSide: true,
      showArrow: false,
    );
  }
}
