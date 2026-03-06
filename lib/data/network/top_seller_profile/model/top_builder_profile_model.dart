class BuilderTopResponseModel {
  final bool? success;
  final String? message;
  final BuilderTopData? data;

  BuilderTopResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory BuilderTopResponseModel.fromMap(Map<String, dynamic> map) {
    return BuilderTopResponseModel(
      success: map['success'],
      message: map['message'],
      data: map['data'] != null
          ? BuilderTopData.fromMap(map['data'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "success": success,
      "message": message,
      "data": data?.toMap(),
    };
  }
}
class BuilderTopData {
  final List<BuilderItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  BuilderTopData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory BuilderTopData.fromMap(Map<String, dynamic> map) {
    return BuilderTopData(
      items: map['items'] != null
          ? List<BuilderItem>.from(
              map['items'].map((x) => BuilderItem.fromMap(x)))
          : [],
      total: map['total'],
      currentPage: map['currentPage'],
      totalPages: map['totalPages'],
      hasMore: map['hasMore'],
      fetchedAll: map['fetchedAll'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "items": items?.map((e) => e.toMap()).toList(),
      "total": total,
      "currentPage": currentPage,
      "totalPages": totalPages,
      "hasMore": hasMore,
      "fetchedAll": fetchedAll,
    };
  }
}
class BuilderItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? username;
  final String? email;
  final String? userType;
  final String? roleId;
  final String? profilePic;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? city;
  final String? state;

  final bool? isVerified;
  final bool? isAadhaarVerified;
  final bool? isOnline;

  final int? totalExperience;
  final int? projectCount;
  final int? upcomingCount;
  final int? ongoingCount;
  final int? completedCount;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final BuilderSellerProfile? sellerProfile;
  final BuilderProjectStats? projectStats;

  final int? planPrice;
  final bool? hasActivePremiumSubscription;

  BuilderItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.username,
    this.email,
    this.userType,
    this.roleId,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.phone,
    this.city,
    this.state,
    this.isVerified,
    this.isAadhaarVerified,
    this.isOnline,
    this.totalExperience,
    this.projectCount,
    this.upcomingCount,
    this.ongoingCount,
    this.completedCount,
    this.createdAt,
    this.updatedAt,
    this.sellerProfile,
    this.projectStats,
    this.planPrice,
    this.hasActivePremiumSubscription,
  });

  factory BuilderItem.fromMap(Map<String, dynamic> map) {
    return BuilderItem(
      id: map['id'],
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      username: map['username'],
      email: map['email'],
      userType: map['userType'],
      roleId: map['role_id'],
      profilePic: map['profilePic'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      city: map['city'],
      state: map['state'],
      isVerified: map['isVerified'],
      isAadhaarVerified: map['isAadhaarVerified'],
      isOnline: map['isOnline'],
      totalExperience: map['totalExperience'],
      projectCount: map['projectCount'],
      upcomingCount: map['upcomingCount'],
      ongoingCount: map['ongoingCount'],
      completedCount: map['completedCount'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      sellerProfile: map['sellerProfile'] != null
          ? BuilderSellerProfile.fromMap(map['sellerProfile'])
          : null,
      projectStats: map['projectStats'] != null
          ? BuilderProjectStats.fromMap(map['projectStats'])
          : null,
      planPrice: map['planPrice'],
      hasActivePremiumSubscription:
          map['hasActivePremiumSubscription'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "created_by": createdBy,
      "updated_by": updatedBy,
      "username": username,
      "email": email,
      "userType": userType,
      "role_id": roleId,
      "profilePic": profilePic,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "city": city,
      "state": state,
      "isVerified": isVerified,
      "isAadhaarVerified": isAadhaarVerified,
      "isOnline": isOnline,
      "totalExperience": totalExperience,
      "projectCount": projectCount,
      "upcomingCount": upcomingCount,
      "ongoingCount": ongoingCount,
      "completedCount": completedCount,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "sellerProfile": sellerProfile?.toMap(),
      "projectStats": projectStats?.toMap(),
      "planPrice": planPrice,
      "hasActivePremiumSubscription":
          hasActivePremiumSubscription,
    };
  }
}
class BuilderSellerProfile {
  final String? companyName;
  final String? sellerType;
  final int? numberOfProperties;
  final String? contactName;
  final String? contactPhone;
  final String? reraNumber;

  BuilderSellerProfile({
    this.companyName,
    this.sellerType,
    this.numberOfProperties,
    this.contactName,
    this.contactPhone,
    this.reraNumber,
  });

  factory BuilderSellerProfile.fromMap(Map<String, dynamic> map) {
    return BuilderSellerProfile(
      companyName: map['companyName'],
      sellerType: map['sellerType'],
      numberOfProperties: map['numberOfProperties'],
      contactName: map['contactName'],
      contactPhone: map['contactPhone'],
      reraNumber: map['reraNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "companyName": companyName,
      "sellerType": sellerType,
      "numberOfProperties": numberOfProperties,
      "contactName": contactName,
      "contactPhone": contactPhone,
      "reraNumber": reraNumber,
    };
  }
}
class BuilderProjectStats {
  final int? total;
  final int? upcoming;
  final int? ongoing;
  final int? completed;

  BuilderProjectStats({
    this.total,
    this.upcoming,
    this.ongoing,
    this.completed,
  });

  factory BuilderProjectStats.fromMap(Map<String, dynamic> map) {
    return BuilderProjectStats(
      total: map['total'],
      upcoming: map['upcoming'],
      ongoing: map['ongoing'],
      completed: map['completed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total": total,
      "upcoming": upcoming,
      "ongoing": ongoing,
      "completed": completed,
    };
  }
}