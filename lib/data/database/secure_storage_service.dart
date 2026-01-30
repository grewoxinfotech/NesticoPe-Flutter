import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';

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
  static const String _keyIsGuestUserPropertyInquiry = 'isGuestUserPropertyInquiry';


 static Future <void> savePropertyInquiryData(String value) async {
    await _storage.write(key: _keyIsGuestUserPropertyInquiry, value: value);
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
  static Future<void> addPropertyInquiry(Map<String, dynamic> newInquiry) async {
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

      final exists =
      inquiryList.any((item) => item['property'] == newInquiry['property']);

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


  // Notification Token
  static Future<void> saveNotificationToken(String token) async {
    await _storage.write(key: _keyNotificationToken, value: token);
  }

  static Future<String?> getNotificationToken() async {
    return _storage.read(key: _keyNotificationToken);
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

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

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
    await _storage.write(key: _keyLoggedIn, value: value.toString());
  }

  static Future<bool> getLoggedIn() async {
    final value = await _storage.read(key: _keyLoggedIn);
    return value?.toLowerCase() == "true";
  }

  static Future<void> deleteLoggedIn() async {
    await _storage.delete(key: _keyLoggedIn);
  }

  static Future<void> saveSelectedCity(String city) async {
    final storage = FlutterSecureStorage();
    log('Save city work or not $city');
    await storage.write(key: _selectedCityKey, value: city);
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
    await _storage.write(key: _keyUpdatePhoneToken, value: token);
  }

  static Future<String?> getUpdatePhoneToken() async {
    return _storage.read(key: _keyUpdatePhoneToken);
  }

  static Future<void> deleteUpdatePhoneToken() async {
    await _storage.delete(key: _keyUpdatePhoneToken);
  }

  // Clear everything
  static Future<void> clearAll() async {
    final city = await SecureStorage.getSelectedCity();

    await _storage.deleteAll();
    if (city != null && city.isNotEmpty) {
      await SecureStorage.saveSelectedCity(city);
    }
    await _storage.write(key: _keyHasLaunched, value: 'true');
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
