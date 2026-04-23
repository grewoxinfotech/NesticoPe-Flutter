import 'dart:convert';

class ReviewResponse {
  final bool? success;
  final String? message;
  final ReviewData? data;

  ReviewResponse({this.success, this.message, this.data});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };

  static ReviewResponse fromRawJson(String str) =>
      ReviewResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class ReviewData {
  final List<ReviewItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  ReviewData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      items:
          (json['items'] as List?)?.map((e) => ReviewItem.fromJson(e)).toList(),
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((e) => e.toJson()).toList(),
    'total': total,
    'currentPage': currentPage,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}

class ReviewItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? entityType;
  final String? entityId;
  final String? reviewerId;
  final double? rating;
  final String? title;
  final String? content;
  final DetailedRatings? detailedRatings;
  final List<String>? photos;
  final List<String>? videos;
  final ReviewProsCons? pros;
  final ReviewProsCons? cons;
  final bool? isVerified;
  final String? verificationType;
  final String? status;
  final String? moderatedBy;
  final String? moderationNotes;
  final String? rejectionReason;
  final String? response;
  final String? responseBy;
  final String? responseDate;
  final int? helpfulCount;
  final int? reportCount;
    final DateTime? createdAt;
  final DateTime? updatedAt;
  final Reviewer? reviewer;
  final Reviewer? adminReviewer;
  final EntityUser? entityUser;
  ReviewItem({
    this.entityUser,
    this.reviewer,

    this.id,
    this.createdBy,
    this.updatedBy,
    this.entityType,
    this.entityId,
    this.reviewerId,
    this.rating,
    this.adminReviewer,
    this.title,
    this.content,
    this.detailedRatings,
    this.photos,
    this.videos,
    this.pros,
    this.cons,
    this.isVerified,
    this.verificationType,
    this.status,
    this.moderatedBy,
    this.moderationNotes,
    this.rejectionReason,
    this.response,
    this.responseBy,
    this.responseDate,
    this.helpfulCount,
    this.reportCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      entityType: json['entity_type'],
      entityId: json['entity_id'],
      reviewerId: json['reviewer_id'],
      rating: (json['rating'] as num?)?.toDouble(),
      title: json['title'],
      content: json['content'],
      adminReviewer:
          json['adminReviewer'] != null
              ? Reviewer.fromJson(json['adminReviewer'])
              : null,
      reviewer:
          json['reviewer'] != null ? Reviewer.fromJson(json['reviewer']) : null,

      entityUser:
          json['entityUser'] != null
              ? EntityUser.fromJson(json['entityUser'])
              : null,
      detailedRatings:
          json['detailed_ratings'] != null
              ? DetailedRatings.fromJson(json['detailed_ratings'])
              : null,
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
      videos: (json['videos'] as List?)?.map((e) => e.toString()).toList(),
      pros:
          json['pros'] != null && json['pros'] is Map<String, dynamic>
              ? ReviewProsCons.fromJson(json['pros'])
              : null,
      cons:
          json['cons'] != null && json['cons'] is Map<String, dynamic>
              ? ReviewProsCons.fromJson(json['cons'])
              : null,
      isVerified: json['is_verified'],
      verificationType: json['verification_type'],
      status: json['status'],
      moderatedBy: json['moderated_by'],
      moderationNotes: json['moderation_notes'],
      rejectionReason: json['rejection_reason'],
      response: json['response'],
      responseBy: json['response_by'],
      responseDate: json['response_date'],
      helpfulCount: json['helpful_count'],
      reportCount: json['report_count'],
            createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'entity_type': entityType,
    'entity_id': entityId,
    'reviewer_id': reviewerId,
    'reviewer': reviewer?.toJson(),
    'adminReviewer': adminReviewer?.toJson(),
    'entityUser': entityUser?.toJson(),
    'rating': rating,
    'title': title,
    'content': content,
    'detailed_ratings': detailedRatings?.toJson(),
    'photos': photos,
    'videos': videos,
    'pros': pros?.toJson(),
    'cons': cons?.toJson(),

    'is_verified': isVerified,
    'verification_type': verificationType,
    'status': status,
    'moderated_by': moderatedBy,
    'moderation_notes': moderationNotes,
    'rejection_reason': rejectionReason,
    'response': response,
    'response_by': responseBy,
    'response_date': responseDate,
    'helpful_count': helpfulCount,
    'report_count': reportCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class EntityUser {
  final String? username;
  final String? userType;

  EntityUser({this.username, this.userType});

  factory EntityUser.fromJson(Map<String, dynamic> json) {
    return EntityUser(username: json['username'], userType: json['userType']);
  }

  Map<String, dynamic> toJson() => {'username': username, 'userType': userType};
}

class DetailedRatings {
  final double? location;
  final double? cleanliness;
  final double? accuracy;
  final double? value;
  final double? amenities;

  DetailedRatings({
    this.location,
    this.cleanliness,
    this.accuracy,
    this.value,
    this.amenities,
  });

  factory DetailedRatings.fromJson(Map<String, dynamic> json) {
    return DetailedRatings(
      location: (json['location'] as num?)?.toDouble(),
      cleanliness: (json['cleanliness'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
      amenities: (json['amenities'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'location': location,
    'cleanliness': cleanliness,
    'accuracy': accuracy,
    'value': value,
    'amenities': amenities,
  };
}

class Reviewer {
  final String? id;
  final String? username;
  final String? userType;
  final String? profilePic;

  Reviewer({this.id, this.username, this.userType,this.profilePic});

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'],
      username: json['username'],
      userType: json['userType'],
      profilePic: json['profilePic'],

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'userType': userType,
    'profilePic':profilePic
  };
}

class UsersResponse {
  final bool success;
  final String message;
  final UsersData? data;

  UsersResponse({required this.success, required this.message, this.data});

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UsersData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'message': message,
    'data': data?.toMap(),
  };
}

class UsersData {
  final List<UserItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  UsersData({
    this.items = const [],
    this.total = 0,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
    this.fetchedAll = false,
  });

  factory UsersData.fromJson(Map<String, dynamic> json) {
    return UsersData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => UserItem.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'items': items.map((e) => e.toMap()).toList(),
    'total': total,
    'currentPage': currentPage,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}

class UserItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? username;
  final String? password;
  final String? email;
  final String? userType;
  final String? roleId;
  final String? profilePic;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? otp;
  final String? otpExpiry;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final bool? isVerified;
  final bool? isOnline;
  final String? lastSeen;
  final String? createdAt;
  final String? updatedAt;

  UserItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.username,
    this.password,
    this.email,
    this.userType,
    this.roleId,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.phone,
    this.otp,
    this.otpExpiry,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.isVerified,
    this.isOnline,
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
    id: json['id'],
    createdBy: json['created_by'],
    updatedBy: json['updated_by'],
    username: json['username'],
    password: json['password'],
    email: json['email'],
    userType: json['userType'],
    roleId: json['role_id'],
    profilePic: json['profilePic'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    phone: json['phone'],
    otp: json['otp'],
    otpExpiry: json['otpExpiry'],
    address: json['address'],
    city: json['city'],
    state: json['state'],
    zipCode: json['zipCode'],
    isVerified: json['isVerified'],
    isOnline: json['isOnline'],
    lastSeen: json['lastSeen'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'username': username,
    'password': password,
    'email': email,
    'userType': userType,
    'role_id': roleId,
    'profilePic': profilePic,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'otp': otp,
    'otpExpiry': otpExpiry,
    'address': address,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'isVerified': isVerified,
    'isOnline': isOnline,
    'lastSeen': lastSeen,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class ReviewProsCons {
  final String? text;
  final List<String>? tags;

  ReviewProsCons({this.text, this.tags});

  factory ReviewProsCons.fromJson(Map<String, dynamic> json) {
    return ReviewProsCons(
      text: json['text'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (text != null) map['text'] = text;
    if (tags != null && tags!.isNotEmpty) map['tags'] = tags;
    return map;
  }
}
