import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:nesticope_app/data/network/auth/model/user_model.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Keys
  static const String _keyToken = 'authToken';
  static const String _keyUsername = 'username';
  static const String _keyLoggedIn = 'isLogin';
  static const String _keyUserData = 'user';
  static const String _keyClientId = 'clientId';
  static const _selectedCityKey = 'selected_city';
  static const String _keyUpdatePhoneToken = 'updatePhoneToken';
  static const String _termsAndConditionApply = "termAndConditionApply";
  static const String _keyAadharVerified = 'isAadharVerified';
  static const String _keyHasLaunched = 'hasLaunchedApp';
  static const String _keyNotificationToken = 'notificationToken';
  static const String _keyFcmToken = 'fcmToken';
  static const String _commissionAcceptedKey = 'reseller_commission_accepted';
  static const String _keyIsGuestUserPropertyInquiry =
      'isGuestUserPropertyInquiry';
  static const String _keySubscriptionInquiry = 'subscriptionInquiry';
  static const String _keyOfferInquiry = 'offerInquiry';
  static const String _keyLoginSkipped = 'loginSkipped';
  static const String _keyLoginWithOtpToken = 'loginWithOtpToken';
  static const String _keySupportTicketId = 'supportTicketId';
  static const String _keyHomeCategory = 'homeCategory';

  /// User finished login/skip on onboarding but has not chosen a city yet.
  static const String _keyPendingOnboardingCity = 'pendingOnboardingCity';
  static const String _keyPlatformServiceInquiry = 'platformServiceInquiry';
  static const String _keyGeneralInquiry = 'generalInquirySubmissions';


  //===================================================================================
  static const String _keySellerLeadCount = 'sellerLeadCount';
static const String _keyResellerLeadCount = 'resellerLeadCount';
static const String _keyContractorLeadCount = 'contractorLeadCount';
static const String _keyBuilderLeadCount = 'builderLeadCount';


static Future<void> saveSellerLeadCount(int count) async {
  await _storage.write(
    key: _keySellerLeadCount,
    value: count.toString(),
  );
}

static Future<void> saveResellerLeadCount(int count) async {
  await _storage.write(
    key: _keyResellerLeadCount,
    value: count.toString(),
  );
}

static Future<void> saveContractorLeadCount(int count) async {
  print("Check the lead number store or not${count}");
  await _storage.write(
    key: _keyContractorLeadCount,
    value: count.toString(),
  );
}

static Future<void> saveBuilderLeadCount(int count) async {
  await _storage.write(
    key: _keyBuilderLeadCount,
    value: count.toString(),
  );
}


static Future<int> getSellerLeadCount() async {
  final value = await _storage.read(key: _keySellerLeadCount);
  return int.tryParse(value ?? '0') ?? 0;
}

static Future<int> getResellerLeadCount() async {
  final value = await _storage.read(key: _keyResellerLeadCount);
  return int.tryParse(value ?? '0') ?? 0;
}

static Future<int> getContractorLeadCount() async {
  final value = await _storage.read(key: _keyContractorLeadCount);
  return int.tryParse(value ?? '0') ?? 0;
}

static Future<int> getBuilderLeadCount() async {
  final value = await _storage.read(key: _keyBuilderLeadCount);
  return int.tryParse(value ?? '0') ?? 0;
}


static Future<bool> hasNewSellerLead(int currentLeadCount) async {
  final storedCount = await getSellerLeadCount();
  return currentLeadCount > storedCount;
}

static Future<bool> hasNewResellerLead(int currentLeadCount) async {
  final storedCount = await getResellerLeadCount();
  return currentLeadCount > storedCount;
}

static Future<bool> hasNewContractorLead(int currentLeadCount) async {
  final storedCount = await getContractorLeadCount();
      print("Check the lead number store or not${currentLeadCount}");
    print("Check the lead number store or not${storedCount}");
      print("Check the lead number store or not${currentLeadCount > storedCount}");
  return currentLeadCount > storedCount;
}

static Future<bool> hasNewBuilderLead(int currentLeadCount) async {
  final storedCount = await getBuilderLeadCount();
  return currentLeadCount > storedCount;
}
//=======================================================================================

  static Future<void> savePlatformServiceInquiryData(String value) async {
    await _storage.write(key: _keyPlatformServiceInquiry, value: value);
  }

  static Future<String?> getPlatformServiceInquiryData() async {
    return _storage.read(key: _keyPlatformServiceInquiry);
  }

  static Future<void> savePlatformResellerFees(String value) async {
    await _storage.write(key: _commissionAcceptedKey, value: value);
  }

  static Future<String?> getPlatformResellerFees() async {
    return _storage.read(key: _commissionAcceptedKey);
  }

  static Future<bool> hasPlatformServiceInquiry(String serviceId) async {
    try {
      final data = await getPlatformServiceInquiryData();
      if (data == null || data.isEmpty) return false;
      final decoded = jsonDecode(data);
      if (decoded is List) {
        return decoded.any((item) => item['serviceId'] == serviceId);
      } else if (decoded is Map) {
        return decoded['serviceId'] == serviceId;
      }
      return false;
    } catch (e) {
      print('❌ Error reading platform service inquiry data: $e');
      return false;
    }
  }

  static Future<void> addPlatformServiceInquiry(
    Map<String, dynamic> newInquiry,
  ) async {
    try {
      final data = await getPlatformServiceInquiryData();
      List<dynamic> inquiryList = [];
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          inquiryList = decoded;
        } else if (decoded is Map) {
          inquiryList = [decoded];
        }
      }
      final exists = inquiryList.any(
        (item) => item['serviceId'] == newInquiry['serviceId'],
      );
      if (!exists) {
        inquiryList.add(newInquiry);
        await savePlatformServiceInquiryData(jsonEncode(inquiryList));
        print('✅ New platform service inquiry saved');
      }
    } catch (e) {
      print('❌ Error saving platform service inquiry: $e');
    }
  }

  static Future<void> savePropertyInquiryData(String value) async {
    await _storage.write(key: _keyIsGuestUserPropertyInquiry, value: value);
  }

  static Future<void> saveOfferInquiryData(String value) async {
    await _storage.write(key: _keyOfferInquiry, value: value);
  }

  static Future<String?> getOfferInquiryData() async {
    return _storage.read(key: _keyOfferInquiry);
  }

  static Future<bool> hasOfferInquiry(
    int offerId, {
    String? email,
    String? phone,
  }) async {
    try {
      final data = await getOfferInquiryData();
      if (data == null || data.isEmpty) return false;
      final decoded = jsonDecode(data);
      List<dynamic> inquiryList = [];
      if (decoded is List) {
        inquiryList = decoded;
      } else if (decoded is Map) {
        inquiryList = [decoded];
      }

      return inquiryList.any(
        (item) =>
            item['offerId'] == offerId &&
            (email == null || item['email'] == email) &&
            (phone == null || item['phone'] == phone),
      );
    } catch (e) {
      print('❌ Error reading offer inquiry data: $e');
      return false;
    }
  }

  static Future<void> addOfferInquiry(Map<String, dynamic> newInquiry) async {
    try {
      final data = await getOfferInquiryData();
      List<dynamic> inquiryList = [];
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          inquiryList = decoded;
        } else if (decoded is Map) {
          inquiryList = [decoded];
        }
      }
      final exists = inquiryList.any(
        (item) =>
            item['offerId'] == newInquiry['offerId'] &&
            (item['email'] == newInquiry['email'] ||
                item['phone'] == newInquiry['phone']),
      );
      if (!exists) {
        inquiryList.add(newInquiry);
        await saveOfferInquiryData(jsonEncode(inquiryList));
        print('✅ New offer inquiry saved');
      }
    } catch (e) {
      print('❌ Error saving offer inquiry: $e');
    }
  }

  static Future<String?> getPropertyInquiryData() async {
    return _storage.read(key: _keyIsGuestUserPropertyInquiry);
  }

  static Future<bool> hasPropertyInquiry(String propertyId) async {
    try {
      final data = await getPropertyInquiryData();
      if (data == null || data.isEmpty) return false;

      log('Property Inquiry Data: $data');

      // Decode stored JSON (can be a single map or a list of inquiries)
      final decoded = jsonDecode(data);

      if (decoded is List) {
        // 🧩 If multiple inquiries stored as a list
        return decoded.any((item) => item['property'] == propertyId);
      } else if (decoded is Map) {
        // 🧩 If only one inquiry is stored as a map
        return decoded['property'] == propertyId;
      } else {
        return false;
      }
    } catch (e) {
      print('❌ Error reading property inquiry data: $e');
      return false;
    }
  }

  /// ✅ Add a new inquiry (only if not duplicate)
  static Future<void> addPropertyInquiry(
    Map<String, dynamic> newInquiry,
  ) async {
    try {
      final data = await getPropertyInquiryData();
      List<dynamic> inquiryList = [];

      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          inquiryList = decoded;
        } else if (decoded is Map) {
          inquiryList = [decoded];
        }
      }

      final exists = inquiryList.any(
        (item) => item['property'] == newInquiry['property'],
      );

      if (!exists) {
        inquiryList.add(newInquiry);
        await savePropertyInquiryData(jsonEncode(inquiryList));
        print('✅ New property inquiry saved');
      } else {
        print('⚠️ Property already in inquiry list, skipping duplicate');
      }
    } catch (e) {
      print('❌ Error saving property inquiry: $e');
    }
  }

  static Future<void> saveSubscriptionInquiryData(String value) async {
    await _storage.write(key: _keySubscriptionInquiry, value: value);
  }

  static Future<String?> getSubscriptionInquiryData() async {
    return _storage.read(key: _keySubscriptionInquiry);
  }

  static Future<void> addSubscriptionInquiry(
    Map<String, dynamic> newInquiry,
  ) async {
    try {
      final data = await getSubscriptionInquiryData();
      List<dynamic> inquiryList = [];
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          inquiryList = decoded;
        } else if (decoded is Map) {
          inquiryList = [decoded];
        }
      }
      final String role = (newInquiry['role'] ?? '').toString();
      // Device-level de-dup by role so any user on this device sees "submitted"
      final exists = inquiryList.any(
        (item) => (item['role'] ?? '').toString() == role,
      );
      if (!exists) {
        inquiryList.add(newInquiry);
      }
      await saveSubscriptionInquiryData(jsonEncode(inquiryList));
    } catch (e) {
      print('❌ Error saving subscription inquiry: $e');
    }
  }

  /// ================= General Inquiry (by type) =================
  static Future<void> saveGeneralInquiryData(String value) async {
    await _storage.write(key: _keyGeneralInquiry, value: value);
  }

  static Future<String?> getGeneralInquiryData() async {
    return _storage.read(key: _keyGeneralInquiry);
  }

  static Future<bool> hasGeneralInquirySubmission({
    required String type,
    String? userId,
    String? email,
    String? phone,
  }) async {
    try {
      final data = await getGeneralInquiryData();
      if (data == null || data.isEmpty) return false;
      final decoded = jsonDecode(data);
      List<dynamic> list = [];
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map) {
        list = [decoded];
      }
      return list.any((item) {
        final t = (item['type'] ?? '').toString();
        final u = (item['userId'] ?? '').toString();
        final e = (item['email'] ?? '').toString();
        final p = (item['phone'] ?? '').toString();
        final typeMatch = t == type;
        final idMatch = userId == null || userId.isEmpty ? true : u == userId;
        final contactMatch =
            ((email == null || email.isEmpty) ? true : e == email) &&
            ((phone == null || phone.isEmpty) ? true : p == phone);
        return typeMatch && idMatch && contactMatch;
      });
    } catch (e) {
      print('❌ Error reading general inquiry data: $e');
      return false;
    }
  }

  static Future<void> addGeneralInquirySubmission(
    Map<String, dynamic> newInquiry,
  ) async {
    try {
      final data = await getGeneralInquiryData();
      List<dynamic> list = [];
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map) {
          list = [decoded];
        }
      }
      final exists = list.any((item) {
        return (item['type'] ?? '') == (newInquiry['type'] ?? '') &&
            ((item['userId'] ?? '') == (newInquiry['userId'] ?? '') ||
                (item['email'] ?? '') == (newInquiry['email'] ?? '') ||
                (item['phone'] ?? '') == (newInquiry['phone'] ?? ''));
      });
      if (!exists) {
        list.add(newInquiry);
        await saveGeneralInquiryData(jsonEncode(list));
      }
    } catch (e) {
      print('❌ Error saving general inquiry: $e');
    }
  }

  static Future<bool> hasSubscriptionInquiryForUser(
    String name, {
    required String userId,
    required String role,
  }) async {
    try {
      print("check any thing missing api calling ${role}");

      final data = await getSubscriptionInquiryData();
      log('Subscription Inquiry Data: $data');
      if (data == null || data.isEmpty) return false;
      final decoded = jsonDecode(data);
      if (decoded is List) {
        if (userId.isNotEmpty) {
          return decoded.any((item) {
            final r = (item['role'] ?? '').toString();
            // final u = (item['userId'] ?? '').toString();
            // Match either same user or same role (device-level)
            return r == role;
          });
        } else {
          return decoded.any((item) {
            final r = (item['role'] ?? '').toString();
            return r == role; // device-level role flag
          });
        }
      } else if (decoded is Map) {
        if (userId.isNotEmpty) {
          final r = (decoded['role'] ?? '').toString();
          // final u = (decoded['userId'] ?? '').toString();
          // return u == userId && r == role;
          return r == role;
        } else {
          final r = (decoded['role'] ?? '').toString();
          return r == role;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('❌ Error reading subscription inquiry data: $e');
      return false;
    }
  }

  // Notification Token
  static Future<void> saveNotificationToken(String token) async {
    await _storage.write(key: _keyNotificationToken, value: token);
  }

  static Future<String?> getNotificationToken() async {
    return _storage.read(key: _keyNotificationToken);
  }

  // FCM Token
  static Future<void> saveFcmToken(String token) async {
    await _storage.write(key: _keyFcmToken, value: token);
  }

  static Future<String?> getFcmToken() async {
    return _storage.read(key: _keyFcmToken);
  }

  static Future<void> deleteFcmToken() async {
    await _storage.delete(key: _keyFcmToken);
  }

  /// Mark that the app has been opened once
  static Future<void> setAppLaunched() async {
    await _storage.write(key: _keyHasLaunched, value: 'true');
  }

  /// TRUE → First time user
  /// FALSE → App opened before
  static Future<bool> isFirstTimeUser() async {
    final value = await _storage.read(key: _keyHasLaunched);
    return value == null;
  }

  // Token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token.toString());
  }

  static Future<void> saveTermAndConditionValue(String? condition) async {
    log("Terms and condition apply $condition");

    await _storage.write(key: _termsAndConditionApply, value: condition);
  }

  static Future<String?> getTermAndConditionValue() async {
    final value = await _storage.read(key: _termsAndConditionApply);
    log("Terms and condition get apply $value");
    return value; // ✅ just return the stored value, don’t overwrite it
  }

  static Future<void> deletedTermsAndConditionApply() async {
    await _storage.delete(key: _termsAndConditionApply);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _keyToken);
  }

  /*
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
*/

  // User data
  static Future<void> saveUserData(UserModel data) async {
    await _storage.write(key: _keyUserData, value: jsonEncode(data.toJson()));
  }

  static Future<UserModel?> getUserData() async {
    final jsonString = await _storage.read(key: _keyUserData);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  static Future<void> deleteUserData() async {
    await _storage.delete(key: _keyUserData);
    await _storage.delete(key: _keyClientId);
  }

  static Future<String?> getClientId() async {
    final clientId = await _storage.read(key: _keyClientId);
    if (clientId != null) return clientId;
    final userData = await getUserData();
    return userData?.user?.id;
  }

  // Username
  static Future<void> saveUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  static Future<String?> getUsername() async {
    return _storage.read(key: _keyUsername);
  }

  static Future<void> deleteUsername() async {
    await _storage.delete(key: _keyUsername);
  }

  // isLoggedIn
  static Future<void> saveLoggedIn(bool value) async {
    print("Check user login or not ${value}");
    await _storage.write(key: _keyLoggedIn, value: value.toString());
  }

  static Future<bool> getLoggedIn() async {
    final value = await _storage.read(key: _keyLoggedIn);
      print("Check user login or not fddf${value}");
    return value?.toLowerCase() == "true";
  }

  static Future<void> deleteLoggedIn() async {
    await _storage.delete(key: _keyLoggedIn);
  }

  static Future<void> deleteLoginSkipped() async {
    await _storage.delete(key: _keyLoginSkipped);
  }

  static Future<void> saveLoginSkipped(bool value) async {
    await _storage.write(key: _keyLoginSkipped, value: value.toString());
  }

  static Future<bool> getLoginSkipped() async {
    final value = await _storage.read(key: _keyLoginSkipped);
    return value?.toLowerCase() == "true";
  }

  static Future<void> saveSelectedCity(String city) async {
    final storage = FlutterSecureStorage();
    log('Save city work or not $city');
    await storage.write(key: _selectedCityKey, value: city);
  }

  // Support Ticket Id (persist across logout)
  static Future<void> saveSupportTicketId(String id) async {
    await _storage.write(key: _keySupportTicketId, value: id);
  }

  static Future<String?> getSupportTicketId() async {
    return _storage.read(key: _keySupportTicketId);
  }

  static Future<void> deleteSupportTicketId() async {
    await _storage.delete(key: _keySupportTicketId);
  }

  // Get selected city
  static Future<String?> getSelectedCity() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: _selectedCityKey);
  }

  // Clear selected city (optional)
  static Future<void> clearSelectedCity() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: _selectedCityKey);
  }

  // Update Phone Token (for OTP verification)
  static Future<void> saveUpdatePhoneToken(String token) async {
    log("Check any field mission of updated token $token");
    await _storage.write(key: _keyUpdatePhoneToken, value: token);
  }

  static Future<String?> getUpdatePhoneToken() async {
    return _storage.read(key: _keyUpdatePhoneToken);
  }

  static Future<void> deleteUpdatePhoneToken() async {
    await _storage.delete(key: _keyUpdatePhoneToken);
  }

  static Future<void> saveLoginWithOtpToken(String token) async {
    await _storage.write(key: _keyLoginWithOtpToken, value: token);
  }

  static Future<String?> getLoginWithOtpToken() async {
    return _storage.read(key: _keyLoginWithOtpToken);
  }

  static Future<void> deleteLoginWithOtpToken() async {
    await _storage.delete(key: _keyLoginWithOtpToken);
  }

  // Home category (Buy/Rent/Lease/Commercial/PG/Plots)
  static Future<void> saveHomeCategory(String value) async {
    await _storage.write(key: _keyHomeCategory, value: value);
  }

  static Future<String?> getHomeCategory() async {
    return _storage.read(key: _keyHomeCategory);
  }

  static Future<void> setPendingOnboardingCitySelection(bool value) async {
    await _storage.write(
      key: _keyPendingOnboardingCity,
      value: value.toString(),
    );
  }

  static Future<bool> getPendingOnboardingCitySelection() async {
    final v = await _storage.read(key: _keyPendingOnboardingCity);
    return v?.toLowerCase() == 'true';
  }

  // Clear everything
  static Future<void> clearAll() async {
    // Preserve a few values before clearing so we can re-save device-level flags
    final city = await SecureStorage.getSelectedCity();
    final offerInquiry = await getOfferInquiryData();
    final subscriptionInquiry = await getSubscriptionInquiryData();
    final loginSkipped = await getLoginSkipped();
    final storedTicketId = await getSupportTicketId();
    final isFirstTismeUser = await isFirstTimeUser();
    final platfromResellerfees = await getPlatformResellerFees();


    final sellerLeadCount = await getSellerLeadCount();
  final resellerLeadCount = await getResellerLeadCount();
  final contractorLeadCount = await getContractorLeadCount();
  final builderLeadCount = await getBuilderLeadCount();
    
    // Debug: show current auth/storage state before wiping
    final tokenBefore = await getToken();
    final userBefore = await getUserData();
    final isLoginBefore = await getLoggedIn();
    log('SecureStorage.clearAll - BEFORE deleteAll -> token:${tokenBefore ?? "<null>"}, isLogin:$isLoginBefore, user:${userBefore != null ? jsonEncode(userBefore.toJson()) : "<null>"}');

    await _storage.deleteAll();

    // Debug: verify cleared
    final tokenAfter = await getToken();
    final userAfter = await getUserData();
    final isLoginAfter = await getLoggedIn();
    log('SecureStorage.clearAll - AFTER deleteAll -> token:${tokenAfter ?? "<null>"}, isLogin:$isLoginAfter, user:${userAfter != null ? jsonEncode(userAfter.toJson()) : "<null>"}');

    // Re-save preserved values that should survive a clearAll
    if (city != null && city.isNotEmpty) {
      await SecureStorage.saveSelectedCity(city);
    }
    if (isFirstTismeUser) {
      await setAppLaunched();
    }
    if (platfromResellerfees == 'true') {
      await savePlatformResellerFees(platfromResellerfees ?? '');
    }
    if (offerInquiry != null && offerInquiry.isNotEmpty) {
      await saveOfferInquiryData(offerInquiry);
    }
    if (subscriptionInquiry != null && subscriptionInquiry.isNotEmpty) {
      await saveSubscriptionInquiryData(subscriptionInquiry);
    }
    if (storedTicketId != null && storedTicketId.isNotEmpty) {
      await saveSupportTicketId(storedTicketId);
    }

  await saveSellerLeadCount(sellerLeadCount);
  await saveResellerLeadCount(resellerLeadCount);
  await saveContractorLeadCount(contractorLeadCount);
  await saveBuilderLeadCount(builderLeadCount);

    await _storage.write(key: _keyHasLaunched, value: 'true');
    if (loginSkipped) {
      await saveLoginSkipped(true);
    }

    // Debug: final state after re-saving preserved values
    final tokenFinal = await getToken();
    final userFinal = await getUserData();
    final isLoginFinal = await getLoggedIn();
    log('SecureStorage.clearAll - FINAL state -> token:${tokenFinal ?? "<null>"}, isLogin:$isLoginFinal, user:${userFinal != null ? jsonEncode(userFinal.toJson()) : "<null>"}');
  }

  static Future<void> updateAadharVerified({required bool value}) async {
    log('Updating Aadhaar verified status: $value');

    // Update standalone flag (safe fallback)
    await _storage.write(key: _keyAadharVerified, value: value.toString());

    // Also update inside user model if exists
    final userData = await getUserData();
    if (userData == null || userData.user == null) return;
    userData.user!.isAadharVerified = value;
    final updatedUser = userData;

    await saveUserData(updatedUser);
  }
}
