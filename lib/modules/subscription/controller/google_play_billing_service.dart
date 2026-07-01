// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:nesticope_app/app/constants/api_constants.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';

// class GooglePlayBillingService {
//   GooglePlayBillingService({
//     required this.onPurchaseVerified,
//     required this.onPurchaseFailed,
//     required this.onPurchasePending,
//   });

//   final Future<void> Function() onPurchaseVerified;
//   final void Function(String message) onPurchaseFailed;
//   final void Function(String message) onPurchasePending;

//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
//   final List<ProductDetails> _products = [];
//   bool _isBillingAvailable = false;

//   Future<void> initialize() async {
//     try {
//       _purchaseSubscription ??= _inAppPurchase.purchaseStream.listen(
//         _handlePurchaseUpdates,
//         onDone: () {
//           _purchaseSubscription?.cancel();
//           _purchaseSubscription = null;
//         },
//         onError: (Object error) {
//           debugPrint('Google Play purchase stream error: $error');
//         },
//       );

//       _isBillingAvailable = await _inAppPurchase.isAvailable();
//       if (!_isBillingAvailable) {
//         return;
//       }

//       final response = await _inAppPurchase.queryProductDetails(<String>{
//         'monthly_premium_999',
//         'premium_monthly',
//         'subscription_monthly',
//       });

//       if (response.error != null) {
//         debugPrint(
//           'Google Play product query failed: ${response.error!.message}',
//         );
//         return;
//       }

//       _products
//         ..clear()
//         ..addAll(response.productDetails);
//     } catch (e) {
//       debugPrint('Exception initializing Google Play billing: $e');
//     }
//   }

//   Future<void> startPurchase(String planId) async {
//     try {
//       await initialize();

//       if (!_isBillingAvailable) {
//         onPurchaseFailed(
//           'Google Play billing is not available on this device.',
//         );
//         return;
//       }

//       ProductDetails? selectedProduct;
//       for (final product in _products) {
//         if (product.id == planId ||
//             product.id == 'monthly_premium_999' ||
//             product.id == 'premium_monthly' ||
//             product.id == 'subscription_monthly') {
//           selectedProduct = product;
//           break;
//         }
//       }

//       if (selectedProduct == null) {
//         onPurchaseFailed(
//           'This subscription plan is not available in Google Play yet.',
//         );
//         return;
//       }

//       final purchaseParam = PurchaseParam(productDetails: selectedProduct);
//       await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     } catch (e) {
//       debugPrint('Exception starting Google Play purchase: $e');
//       onPurchaseFailed('Unable to start the purchase flow.');
//     }
//   }

//   Future<void> _handlePurchaseUpdates(
//     List<PurchaseDetails> purchaseDetailsList,
//   ) async {
//     for (final purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         onPurchasePending('Purchase is pending. Please wait...');
//       } else if (purchaseDetails.status == PurchaseStatus.error) {
//         onPurchaseFailed(
//           purchaseDetails.error?.message ?? 'An error occurred during payment.',
//         );
//       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//           purchaseDetails.status == PurchaseStatus.restored) {
//         final verified = await _verifyPurchaseOnBackend(purchaseDetails);

//         if (verified) {
//           if (purchaseDetails.pendingCompletePurchase) {
//             await _inAppPurchase.completePurchase(purchaseDetails);
//           }
//           await onPurchaseVerified();
//         } else {
//           onPurchaseFailed(
//             'Unable to verify this purchase with the NesticoPe backend.',
//           );
//         }
//       }
//     }
//   }

//   Future<bool> _verifyPurchaseOnBackend(PurchaseDetails purchaseDetails) async {
//     try {
//       final token = await SecureStorage.getToken();
//       final user = await SecureStorage.getUserData();
//       final userId = user?.user?.id ?? '';

//       if ((token ?? '').isEmpty || userId.isEmpty) {
//         debugPrint('Missing auth data for Google Play verification');
//         return false;
//       }

//       final response = await http.post(
//         Uri.parse('${ApiConstants.subscription}/verify-google-play'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'googleProductId': purchaseDetails.productID,
//           'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
//           'packageName': 'com.nesticope.app',
//           'userId': userId,
//         }),
//       );

//       final decoded = jsonDecode(response.body);
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         return decoded['success'] == true || decoded['status'] == 'success';
//       }

//       debugPrint('Google Play verification failed: ${response.body}');
//       return false;
//     } catch (e) {
//       debugPrint('Exception verifying Google Play purchase: $e');
//       return false;
//     }
//   }

//   void dispose() {
//     _purchaseSubscription?.cancel();
//     _purchaseSubscription = null;
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> purchaseSubscription({required String planId}) async {
  try {
    final token = await SecureStorage.getToken();
    final user = await SecureStorage.getUserData();

    final packageInfo = await PackageInfo.fromPlatform();

    final response = await http.post(
      Uri.parse('${ApiConstants.subscription}/verify-google-play'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "planId": planId,
        'packageName':packageInfo.packageName, // Update with actual package name
        'userId': user?.user?.id, // Current user's database ID
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(data);
      final result = jsonDecode(response.body);

      // Success
      // onPurchaseVerified();
    } else {
      // onPurchaseFailed(data["message"] ?? "Purchase failed");
    }
  } catch (e) {
    print('Backend verification error: $e');
    // onPurchaseFailed(e.toString());
  }
}
