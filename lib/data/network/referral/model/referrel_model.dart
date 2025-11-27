// class Referrel_Model {
//   bool? success;
//   String? message;
//   List<Data>? data;
//
//   Referrel_Model({this.success, this.message, this.data});
//
//   Referrel_Model.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();

//     data['success'] = this.story;

//     data['success'] = this.success;
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     return data;
//   }
// }
//
// class Data {
//   String? id;
//   String? createdBy;
//   String? updatedBy;
//   String? referrerId;
//    String? referredUsers;
//   String? referralCode;
//   String? referralLink;
//   String? status;
//   String? referralType;
//   int? referrerReward;
//   String? expiryDate;
//   int? totalReferrals;
//   String? totalRewards;
//   bool? isExpired;
//   String? approvalStatus;
//   Null? approvalComment;
//   String? createdAt;
//   String? updatedAt;
//
//   Data(
//       {this.id,
//         this.createdBy,
//         this.updatedBy,
//         this.referrerId,
//         this.referredUsers,
//         this.referralCode,
//         this.referralLink,
//         this.status,
//         this.referralType,
//         this.referrerReward,
//         this.expiryDate,
//         this.totalReferrals,
//         this.totalRewards,
//         this.isExpired,
//         this.approvalStatus,
//         this.approvalComment,
//         this.createdAt,
//         this.updatedAt});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdBy = json['created_by'];
//     updatedBy = json['updated_by'];
//     referrerId = json['referrer_id'];
//     referredUsers = json['referred_users'];
//     referralCode = json['referral_code'];
//     referralLink = json['referral_link'];
//     status = json['status'];
//     referralType = json['referralType'];
//     referrerReward = json['referrerReward'];
//     expiryDate = json['expiry_date'];
//     totalReferrals = json['totalReferrals'];
//     totalRewards = json['totalRewards'];
//     isExpired = json['isExpired'];
//     approvalStatus = json['approvalStatus'];
//     approvalComment = json['approvalComment'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['created_by'] = this.createdBy;
//     data['updated_by'] = this.updatedBy;
//     data['referrer_id'] = this.referrerId;
//     data['referred_users'] = this.referredUsers;
//     data['referral_code'] = this.referralCode;
//     data['referral_link'] = this.referralLink;
//     data['status'] = this.status;
//     data['referralType'] = this.referralType;
//     data['referrerReward'] = this.referrerReward;
//     data['expiry_date'] = this.expiryDate;
//     data['totalReferrals'] = this.totalReferrals;
//     data['totalRewards'] = this.totalRewards;
//     data['isExpired'] = this.isExpired;
//     data['approvalStatus'] = this.approvalStatus;
//     data['approvalComment'] = this.approvalComment;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }

import 'dart:convert';

class ReferralModel {
  bool? success;
  String? message;
  List<Data>? data;

  ReferralModel({this.success, this.message, this.data});

  ReferralModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Data {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? referrerId;
  List<ReferredUser>? referredUsers; // ✅ Now dynamic list
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    referrerId = json['referrer_id'];

    /// ✅ Handle `referred_users` being a String or List
    var referred = json['referred_users'];
    if (referred is String) {
      // If it's a JSON string, try parsing
      try {
        final decoded = referred.isNotEmpty ? jsonDecode(referred) : [];
        if (decoded is List) {
          referredUsers = decoded.map((v) => ReferredUser.fromJson(v)).toList();
        } else {
          referredUsers = [];
        }
      } catch (e) {
        referredUsers = [];
      }
    } else if (referred is List) {
      referredUsers = referred.map((v) => ReferredUser.fromJson(v)).toList();
    } else {
      referredUsers = [];
    }

    referralCode = json['referral_code'];
    referralLink = json['referral_link'];
    status = json['status'];
    referralType = json['referralType'];
    referrerReward = json['referrerReward'];
    expiryDate = json['expiry_date'];
    totalReferrals = json['totalReferrals'];
    totalRewards = json['totalRewards']?.toString();
    isExpired = json['isExpired'];
    approvalStatus = json['approvalStatus'];
    approvalComment = json['approvalComment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['created_by'] = createdBy;
    result['updated_by'] = updatedBy;
    result['referrer_id'] = referrerId;
    result['referred_users'] =
        referredUsers?.map((v) => v.toJson()).toList() ?? [];
    result['referral_code'] = referralCode;
    result['referral_link'] = referralLink;
    result['status'] = status;
    result['referralType'] = referralType;
    result['referrerReward'] = referrerReward;
    result['expiry_date'] = expiryDate;
    result['totalReferrals'] = totalReferrals;
    result['totalRewards'] = totalRewards;
    result['isExpired'] = isExpired;
    result['approvalStatus'] = approvalStatus;
    result['approvalComment'] = approvalComment;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    return result;
  }
}

class ReferredUser {
  String? userId;
  String? username;
  String? email;
  String? registeredAt;
  String? status;

  ReferredUser({
    this.userId,
    this.username,
    this.email,
    this.registeredAt,
    this.status,
  });

  ReferredUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    email = json['email'];
    registeredAt = json['registeredAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['userId'] = userId;
    result['username'] = username;
    result['email'] = email;
    result['registeredAt'] = registeredAt;
    result['status'] = status;
    return result;
  }
}
