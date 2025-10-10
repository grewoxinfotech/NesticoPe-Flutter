class Referrel_Model {
  bool? success;
  String? message;
  List<Data>? data;

  Referrel_Model({this.success, this.message, this.data});

  Referrel_Model.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? referrerId;
  List<dynamic>? referredUsers;
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
  Null? approvalComment;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
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
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    referrerId = json['referrer_id'];
    referredUsers = json['referred_users'];
    referralCode = json['referral_code'];
    referralLink = json['referral_link'];
    status = json['status'];
    referralType = json['referralType'];
    referrerReward = json['referrerReward'];
    expiryDate = json['expiry_date'];
    totalReferrals = json['totalReferrals'];
    totalRewards = json['totalRewards'];
    isExpired = json['isExpired'];
    approvalStatus = json['approvalStatus'];
    approvalComment = json['approvalComment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['referrer_id'] = this.referrerId;
    data['referred_users'] = this.referredUsers;
    data['referral_code'] = this.referralCode;
    data['referral_link'] = this.referralLink;
    data['status'] = this.status;
    data['referralType'] = this.referralType;
    data['referrerReward'] = this.referrerReward;
    data['expiry_date'] = this.expiryDate;
    data['totalReferrals'] = this.totalReferrals;
    data['totalRewards'] = this.totalRewards;
    data['isExpired'] = this.isExpired;
    data['approvalStatus'] = this.approvalStatus;
    data['approvalComment'] = this.approvalComment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
