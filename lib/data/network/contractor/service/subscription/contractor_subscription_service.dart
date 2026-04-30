import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/network/contractor/model/subscription/contractor_active_subscription_model.dart';
import 'package:nesticope_app/data/network/contractor/service/subscription/subscription_limit_guard.dart';

class ContractorSubscriptionService {
  ContractorSubscriptionService._();

  static final ContractorSubscriptionService instance =
      ContractorSubscriptionService._();

  Future<ContractorActiveSubscriptionData?> fetchActivePlan(String userId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.subscriptionActive(userId)),
      headers: await ApiConstants.getHeaders(),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final parsed = ContractorActiveSubscriptionResponse.fromJson(json);
      return parsed.data;
    }

    await SubscriptionLimitGuard.handlePlanLimitResponse(response);
    return null;
  }
}
