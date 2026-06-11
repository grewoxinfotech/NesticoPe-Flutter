import 'dart:convert';
import 'dart:developer' as dev;

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
    debugPrint('[SubscriptionLimitGuard] Parsed response body: ${response.body}');
    final errorCode = _extractErrorCode(parsed);
    final statusCode = response.statusCode;

    final isPlanLimit = _isPlanLimitError(statusCode, errorCode);

    dev.log('[SubscriptionLimitGuard] statusCode=$statusCode, errorCode=$errorCode, isPlanLimit=$isPlanLimit', name: 'SubscriptionLimitGuard');

    if (!isPlanLimit) return false;

    _handledPlanLimitError = true;

    if (_dialogVisible) return true;
    _dialogVisible = true;

    final title = statusCode == 403 ? 'Active plan required' : 'Limit Reached';
    final description =
        statusCode == 403
            ? 'Active plan required to continue this action.'
            : 'Limit Reached, please upgrade your plan.';

    dev.log('[SubscriptionLimitGuard] Showing plan limit dialog', name: 'SubscriptionLimitGuard');
    await Get.dialog<void>(
      AlertDialog(
        backgroundColor: Colors.white,
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
    dev.log('[SubscriptionLimitGuard] Dialog closed', name: 'SubscriptionLimitGuard');
    return true;
  }

  static bool _isPlanLimitError(int statusCode, String errorCode) {
    dev.log('[SubscriptionLimitGuard] Checking plan limit for status=$statusCode code=$errorCode', name: 'SubscriptionLimitGuard');
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
    dev.log('[SubscriptionLimitGuard] extractErrorCode input', name: 'SubscriptionLimitGuard', error: body);
    if (fromError is Map<String, dynamic>) {
      final code = fromError['code']?.toString();
      if (code != null && code.isNotEmpty) {
        dev.log('[SubscriptionLimitGuard] extracted code from error.map: $code', name: 'SubscriptionLimitGuard');
        return code;
      }
    }
    final fallback = body['errorCode']?.toString() ?? '';
    dev.log('[SubscriptionLimitGuard] extracted fallback errorCode: $fallback', name: 'SubscriptionLimitGuard');
    return fallback;
  }

  static Map<String, dynamic> _parseBody(String body) {
    try {
      final decoded = jsonDecode(body);
      dev.log('[SubscriptionLimitGuard] _parseBody decoded', name: 'SubscriptionLimitGuard', error: decoded);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (e, st) {
      dev.log('[SubscriptionLimitGuard] _parseBody error: $e', name: 'SubscriptionLimitGuard', error: st);
    }
    return {};
  }
}
