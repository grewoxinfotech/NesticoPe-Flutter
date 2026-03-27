import '../../../../data/database/secure_storage_service.dart';

enum UserType { reseller, seller, buyer, contractor }

enum SellerType { owner, builder }

class UserHelper {
  static UserType? _cachedUserType;
  static SellerType? _cachedSellerType;

  /// Aadhar verification cache
  static bool _cachedIsAadharVerified = false;

  /// Initialize once at app start (guest by default)
  static Future<void> initUserType() async {
    try {
      final user = await SecureStorage.getUserData();
      final roleString = user?.user?.userType;
      final sellerTypeString = user?.user?.sellerType; // new backend field

      _cachedUserType = _mapRoleStringToEnum(roleString);
      _cachedSellerType = _mapSellerStringToEnum(sellerTypeString);

      _cachedIsAadharVerified = user?.user?.isAadharVerified ?? false;

      print(
        'User type initialized: ${userTypeString} (${sellerTypeStringValue})',
      );
    } catch (e) {
      print('Error initializing user type: $e');
      _cachedUserType = null;
      _cachedSellerType = null;
      _cachedIsAadharVerified = false;
    }
  }

  /// Change user type at runtime (e.g., after login or conversion)
  static Future<void> setUserType(
    String? roleString, {
    String? sellerType,
    bool? isAadharVerified,
  }) async {
    _cachedUserType = _mapRoleStringToEnum(roleString);
    _cachedSellerType = _mapSellerStringToEnum(sellerType);

    if (isAadharVerified != null) {
      _cachedIsAadharVerified = isAadharVerified;
    }

    print('User type set: ${userTypeString} (${sellerTypeStringValue})');
  }

  /// Internal helpers
  static UserType? _mapRoleStringToEnum(String? roleString) {
    if (roleString == null || roleString.isEmpty) return null;

    switch (roleString.toLowerCase()) {
      case 'reseller':
        return UserType.reseller;
      case 'seller':
        return UserType.seller;
      case 'buyer':
        return UserType.buyer;
      case 'contractor':
        return UserType.contractor;
      default:
        return null;
    }
  }

  static SellerType? _mapSellerStringToEnum(String? sellerType) {
    if (sellerType == null || sellerType.isEmpty) return null;

    switch (sellerType.toLowerCase()) {
      case 'owner':
        return SellerType.owner;
      case 'builder':
        return SellerType.builder;
      default:
        return null;
    }
  }
  static String? getOfferUserType() {
  switch (_cachedUserType) {
    case UserType.reseller:
      return "reseller";

    case UserType.buyer:
      return "buyer";

    case UserType.contractor:
      return "contractor";

    case UserType.seller:
      if (_cachedSellerType == SellerType.owner) {
        return "seller-owner";
      } else if (_cachedSellerType == SellerType.builder) {
        return "seller-builder";
      }
      return "seller";

    default:
      return null;
  }
}

  /// Clear on logout
  static void clearUserType() {
    _cachedUserType = null;
    _cachedSellerType = null;
    _cachedIsAadharVerified = false;
  }

  static Future<void> setAadharVerified(bool isVerified) async {
    _cachedIsAadharVerified = isVerified;
    await SecureStorage.updateAadharVerified(value: isVerified);
  }

  // ─────────────────────────────────────────────
  // 💡 Public Getters
  // ─────────────────────────────────────────────

  /// Return string values instead of enum names
  static String? get userTypeString {
    switch (_cachedUserType) {
      case UserType.reseller:
        return "reseller";
      case UserType.seller:
        return "seller";
      case UserType.buyer:
        return "buyer";
      case UserType.contractor:
        return "contractor";
      default:
        return null;
    }
  }

  static String? get sellerTypeStringValue {
    switch (_cachedSellerType) {
      case SellerType.owner:
        return "owner";
      case SellerType.builder:
        return "builder";
      default:
        return null;
    }
  }

  static bool get isAadharVerified => _cachedIsAadharVerified;

  /// Retain enum getters too (for logic use)
  static UserType? get userType => _cachedUserType;

  static SellerType? get sellerType => _cachedSellerType;

  /// Quick role checks
  static bool get isSeller => _cachedUserType == UserType.seller;

  static bool get isReseller => _cachedUserType == UserType.reseller;

  static bool get isBuyer => _cachedUserType == UserType.buyer;

  static bool get isGuest => _cachedUserType == null;

  static bool get isContractor => _cachedUserType == UserType.contractor;

  static bool get isSellerOwner =>
      _cachedUserType == UserType.seller &&
      _cachedSellerType == SellerType.owner;

  static bool get isSellerBuilder =>
      _cachedUserType == UserType.seller &&
      _cachedSellerType == SellerType.builder;
}
