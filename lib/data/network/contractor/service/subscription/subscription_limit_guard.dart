import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/modules/subscription/views/suscription_plan_screen.dart';

class SubscriptionLimitGuard {
  SubscriptionLimitGuard._();

  static bool _handledPlanLimitError = false;
  static bool _dialogVisible = false;

  static bool consumeHandledState() {
    final handled = _handledPlanLimitError;
    _handledPlanLimitError = false;
    return handled;
  }

  static Future<bool> handlePlanLimitResponse(http.Response response) async {
    final parsed = _parseBody(response.body);
    final errorCode = _extractErrorCode(parsed);
    final statusCode = response.statusCode;
    final isPlanLimit = _isPlanLimitError(statusCode, errorCode);

    if (!isPlanLimit) return false;

    _handledPlanLimitError = true;

    if (_dialogVisible) return true;
    _dialogVisible = true;

    final title = statusCode == 403 ? 'Active plan required' : 'Limit Reached';
    final description =
        statusCode == 403
            ? 'Active plan required to continue this action.'
            : 'Limit Reached, please upgrade your plan.';

    await Get.dialog<void>(
      AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.to(
                () => SubscriptionPlansScreen(
                  role: 'contractor',
                  isShowCurrentPlan: true,
                ),
              );
            },
            child: const Text('Upgrade Plan'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    _dialogVisible = false;
    return true;
  }

  static bool _isPlanLimitError(int statusCode, String errorCode) {
    const maxLimitCodes = {
      'MAX_SERVICES_LIMIT_REACHED',
      'MAX_LEADS_LIMIT_REACHED',
      'MAX_USERS_LIMIT_REACHED',
    };
    const planRequiredCodes = {
      'PLAN_REQUIRED_SERVICES',
      'PLAN_REQUIRED_LEADS',
      'PLAN_REQUIRED_USERS',
    };

    if (statusCode == 429 && maxLimitCodes.contains(errorCode)) return true;
    if (statusCode == 403 && planRequiredCodes.contains(errorCode)) return true;
    return false;
  }

  static String _extractErrorCode(Map<String, dynamic> body) {
    final fromError = body['error'];
    if (fromError is Map<String, dynamic>) {
      final code = fromError['code']?.toString();
      if (code != null && code.isNotEmpty) return code;
    }
    return body['errorCode']?.toString() ?? '';
  }

  static Map<String, dynamic> _parseBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }
}
