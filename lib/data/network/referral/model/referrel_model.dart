import 'dart:convert';

class ReferralModel {
  bool? success;
  String? message;
  DataWrapper? data;

  ReferralModel({this.success, this.message, this.data});

  factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
    success: json['success'],
    message: json['message'],
    data: json['data'] != null ? DataWrapper.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class DataWrapper {
  List<Data>? referrals;
  Points? points;
  Settings? settings;

  DataWrapper({this.referrals, this.points, this.settings});

  factory DataWrapper.fromJson(Map<String, dynamic> json) => DataWrapper(
    referrals: json['referrals'] != null
        ? (json['referrals'] as List)
        .map((v) => Data.fromJson(v))
        .toList()
        : [],
    points: json['points'] != null ? Points.fromJson(json['points']) : null,
    settings:
    json['settings'] != null ? Settings.fromJson(json['settings']) : null,
  );

  Map<String, dynamic> toJson() => {
    'referrals': referrals?.map((v) => v.toJson()).toList(),
    'points': points?.toJson(),
    'settings': settings?.toJson(),
  };
}

class Data {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? referrerId;
  String? referrerType;
  List<ReferredUser>? referredUsers;
  String? referralCode;
  String? referralLink;
  String? status;
  String? referralType;
  int? referrerReward;
  String? expiryDate;
  int? totalReferrals;
  String? totalRewards;
  bool? isExpired;
  String? approvalStatus;
  String? approvalComment;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.referrerId,
    this.referrerType,
    this.referredUsers,
    this.referralCode,
    this.referralLink,
    this.status,
    this.referralType,
    this.referrerReward,
    this.expiryDate,
    this.totalReferrals,
    this.totalRewards,
    this.isExpired,
    this.approvalStatus,
    this.approvalComment,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // Handle referred_users being a JSON string or List
    List<ReferredUser> referredUsersList = [];
    var referred = json['referred_users'];
    if (referred is String) {
      try {
        final decoded = referred.isNotEmpty ? jsonDecode(referred) : [];
        if (decoded is List) {
          referredUsersList =
              decoded.map((v) => ReferredUser.fromJson(v)).toList();
        }
      } catch (_) {}
    } else if (referred is List) {
      referredUsersList = referred.map((v) => ReferredUser.fromJson(v)).toList();
    }

    return Data(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      referrerId: json['referrer_id'],
      referrerType: json['referrer_type'],
      referredUsers: referredUsersList,
      referralCode: json['referral_code'],
      referralLink: json['referral_link'],
      status: json['status'],
      referralType: json['referralType'],
      referrerReward: json['referrerReward'],
      expiryDate: json['expiry_date'],
      totalReferrals: json['totalReferrals'],
      totalRewards: json['totalRewards']?.toString(),
      isExpired: json['isExpired'],
      approvalStatus: json['approvalStatus'],
      approvalComment: json['approvalComment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'referrer_id': referrerId,
    'referrer_type': referrerType,
    'referred_users': referredUsers?.map((v) => v.toJson()).toList(),
    'referral_code': referralCode,
    'referral_link': referralLink,
    'status': status,
    'referralType': referralType,
    'referrerReward': referrerReward,
    'expiry_date': expiryDate,
    'totalReferrals': totalReferrals,
    'totalRewards': totalRewards,
    'isExpired': isExpired,
    'approvalStatus': approvalStatus,
    'approvalComment': approvalComment,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class ReferredUser {
  String? userId;
  String? username;
  String? email;
  String? registeredAt;
  String? status;

  ReferredUser({this.userId, this.username, this.email, this.registeredAt, this.status});

  factory ReferredUser.fromJson(Map<String, dynamic> json) => ReferredUser(
    userId: json['userId'],
    username: json['username'],
    email: json['email'],
    registeredAt: json['registeredAt'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'email': email,
    'registeredAt': registeredAt,
    'status': status,
  };
}

class Points {
  String? id;
  String? userId;
  int? totalPoints;
  int? pointsEarned;
  int? pointsRedeemed;
  String? lastEarnedAt;
  String? lastRedeemedAt;
  String? createdAt;
  String? updatedAt;

  Points({
    this.id,
    this.userId,
    this.totalPoints,
    this.pointsEarned,
    this.pointsRedeemed,
    this.lastEarnedAt,
    this.lastRedeemedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    id: json['id'],
    userId: json['userId'],
    totalPoints: json['total_points'],
    pointsEarned: json['points_earned'],
    pointsRedeemed: json['points_redeemed'],
    lastEarnedAt: json['last_earned_at'],
    lastRedeemedAt: json['last_redeemed_at'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'total_points': totalPoints,
    'points_earned': pointsEarned,
    'points_redeemed': pointsRedeemed,
    'last_earned_at': lastEarnedAt,
    'last_redeemed_at': lastRedeemedAt,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class Settings {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? userType;
  String? referralType;
  int? referrerReward;
  int? validityDays;
  int? pointsForDiscount;
  int? discountPercentage;
  String? createdAt;
  String? updatedAt;

  Settings({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.userType,
    this.referralType,
    this.referrerReward,
    this.validityDays,
    this.pointsForDiscount,
    this.discountPercentage,
    this.createdAt,
    this.updatedAt,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    id: json['id'],
    createdBy: json['created_by'],
    updatedBy: json['updated_by'],
    userType: json['userType'],
    referralType: json['referralType'],
    referrerReward: json['referrerReward'],
    validityDays: json['validity_days'],
    pointsForDiscount: json['pointsForDiscount'],
    discountPercentage: json['discountPercentage'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'userType': userType,
    'referralType': referralType,
    'referrerReward': referrerReward,
    'validity_days': validityDays,
    'pointsForDiscount': pointsForDiscount,
    'discountPercentage': discountPercentage,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
