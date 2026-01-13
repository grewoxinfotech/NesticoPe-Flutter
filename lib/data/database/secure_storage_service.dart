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
    await _storage.deleteAll();
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
