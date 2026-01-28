class ReferralResponseModel {
  final bool success;
  final String message;
  final ReferralData data;

  ReferralResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReferralResponseModel.fromJson(Map<String, dynamic> json) {
    return ReferralResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ReferralData.fromJson(json['data'] ?? {}),
    );
  }
}

class ReferralData {
  final ReferralUser user;
  final List<ReferralItem> referrals;
  final int totalReferralPointsEarned;
  final int totalReferralsMade;
  final int pointsBalance;
  final int pointsEarned;
  final int pointsRedeemed;
  final int pointsUsed;
  final ModuleSettings moduleSettings;
  final String moduleName;

  ReferralData({
    required this.user,
    required this.referrals,
    required this.totalReferralPointsEarned,
    required this.totalReferralsMade,
    required this.pointsBalance,
    required this.pointsEarned,
    required this.pointsRedeemed,
    required this.pointsUsed,
    required this.moduleSettings,
    required this.moduleName,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    return ReferralData(
      user: ReferralUser.fromJson(json['user'] ?? {}),
      referrals:
          (json['referrals'] as List<dynamic>? ?? [])
              .map((e) => ReferralItem.fromJson(e))
              .toList(),
      totalReferralPointsEarned: json['totalReferralPointsEarned'] ?? 0,
      totalReferralsMade: json['totalReferralsMade'] ?? 0,
      pointsBalance: json['pointsBalance'] ?? 0,
      pointsEarned: json['pointsEarned'] ?? 0,
      pointsRedeemed: json['pointsRedeemed'] ?? 0,
      pointsUsed: json['pointsUsed'] ?? 0,
      moduleSettings: ModuleSettings.fromJson(json['moduleSettings'] ?? {}),
      moduleName: json['moduleName'] ?? '',
    );
  }
}

class ReferralUser {
  final String id;
  final String username;
  final String email;
  final String userType;

  ReferralUser({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
  });

  factory ReferralUser.fromJson(Map<String, dynamic> json) {
    return ReferralUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
    );
  }
}

class ReferralItem {
  final String referrerId;
  final String referralLink;
  final String totalRewards;

  ReferralItem({
    required this.referrerId,
    required this.referralLink,
    required this.totalRewards,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) {
    return ReferralItem(
      referrerId: json['referrer_id'] ?? '',
      referralLink: json['referral_link'] ?? '',
      totalRewards: json['totalRewards'] ?? '0.00',
    );
  }
}

class ModuleSettings {
  final String userType;
  final String referralType;
  final int referrerReward;
  final int validityDays;
  final int pointsForDiscount;
  final int discountPercentage;

  ModuleSettings({
    required this.userType,
    required this.referralType,
    required this.referrerReward,
    required this.validityDays,
    required this.pointsForDiscount,
    required this.discountPercentage,
  });

  factory ModuleSettings.fromJson(Map<String, dynamic> json) {
    return ModuleSettings(
      userType: json['userType'] ?? '',
      referralType: json['referralType'] ?? '',
      referrerReward: json['referrerReward'] ?? 0,
      validityDays: json['validity_days'] ?? 0,
      pointsForDiscount: json['pointsForDiscount'] ?? 0,
      discountPercentage: json['discountPercentage'] ?? 0,
    );
  }
}
