import 'package:flutter/material.dart';

import '../../../../app/constants/enum.dart';
import '../../../subscription/views/suscription_plan_screen.dart';
class ContractorPlanScreen extends StatelessWidget {
  const ContractorPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionPlansScreen(role: Roles.contractor.name);
  }
}
