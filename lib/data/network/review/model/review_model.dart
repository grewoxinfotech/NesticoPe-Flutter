import '../../overall_rating/model/overall_rating_model.dart';

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
    this.id,
    this.createdBy,
    this.updatedBy,
    this.entityType,
    this.entityId,
    this.reviewerId,
    this.rating,
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
    this.reviewer,
    this.adminReviewer,
    this.entityUser,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      entityType: json['entity_type'] ?? '',
      entityId: json['entity_id'] ?? '',
      reviewerId: json['reviewer_id'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      detailedRatings:
          json['detailed_ratings'] != null
              ? DetailedRatings.fromJson(json['detailed_ratings'])
              : null,
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
      videos: (json['videos'] as List?)?.map((e) => e.toString()).toList(),
      pros: json['pros'] != null && json['pros'] is Map<String, dynamic>
          ? ReviewProsCons.fromJson(json['pros'])
          : null,
      cons: json['cons'] != null && json['cons'] is Map<String, dynamic>
          ? ReviewProsCons.fromJson(json['cons'])
          : null,

      isVerified: json['is_verified'] ?? false,
      verificationType: json['verification_type'],
      status: json['status'] ?? '',
      moderatedBy: json['moderated_by'],
      moderationNotes: json['moderation_notes'],
      rejectionReason: json['rejection_reason'],
      response: json['response'],
      responseBy: json['response_by'],
      responseDate: json['response_date'],
      helpfulCount: json['helpful_count'] ?? 0,
      reportCount: json['report_count'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      adminReviewer: json['adminReviewer'] != null ? Reviewer.fromJson(json['adminReviewer']) : null,
      reviewer: json['reviewer'] != null ? Reviewer.fromJson(json['reviewer']) : null,
      entityUser: json['entityUser'] != null ? EntityUser.fromJson(json['entityUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
    if (createdBy != null) map['created_by'] = createdBy;
    if (updatedBy != null) map['updated_by'] = updatedBy;
    if (entityType != null) map['entity_type'] = entityType;
    if (entityId != null) map['entity_id'] = entityId;
    if (reviewerId != null) map['reviewer_id'] = reviewerId;
    if (rating != null) map['rating'] = rating;
    if (title != null) map['title'] = title;
    if (content != null) map['content'] = content;
    if (detailedRatings != null)
      map['detailed_ratings'] = detailedRatings!.toJson();
    if (photos != null && photos!.isNotEmpty) map['photos'] = photos;
    if (videos != null && videos!.isNotEmpty) map['videos'] = videos;
    if (pros != null) map['pros'] = pros!.toJson();
    if (cons != null) map['cons'] = cons!.toJson();
    if (adminReviewer != null) map['adminReviewer'] = adminReviewer!.toJson();
    if (isVerified != null) map['is_verified'] = isVerified;
    if (verificationType != null) map['verification_type'] = verificationType;
    if (status != null) map['status'] = status;
    if (moderatedBy != null) map['moderated_by'] = moderatedBy;
    if (moderationNotes != null) map['moderation_notes'] = moderationNotes;
    if (rejectionReason != null) map['rejection_reason'] = rejectionReason;
    if (response != null) map['response'] = response;
    if (responseBy != null) map['response_by'] = responseBy;
    if (responseDate != null) map['response_date'] = responseDate;
    if (helpfulCount != null) map['helpful_count'] = helpfulCount;
    if (reportCount != null) map['report_count'] = reportCount;
    if (createdAt != null) map['createdAt'] = createdAt?.toIso8601String();
    if (updatedAt != null) map['updatedAt'] = updatedAt?.toIso8601String();
    if (reviewer != null) map['reviewer'] = reviewer?.toJson();
    if (entityUser != null) map['entityUser'] = entityUser?.toJson();

    return map;
  }
}

extension ReviewItemCopy on ReviewItem {
  ReviewItem copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? entityType,
    String? entityId,
    String? reviewerId,
    double? rating,
    String? title,
    String? content,
    DetailedRatings? detailedRatings,
    List<String>? photos,
    List<String>? videos,
    ReviewProsCons? pros,
    ReviewProsCons? cons,
    bool? isVerified,
    String? verificationType,
    String? status,
    String? moderatedBy,
    String? moderationNotes,
    String? rejectionReason,
    String? response,
    String? responseBy,
    String? responseDate,
    int? helpfulCount,
    int? reportCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewItem(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      reviewerId: reviewerId ?? this.reviewerId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      detailedRatings: detailedRatings ?? this.detailedRatings,
      photos: photos ?? this.photos,
      videos: videos ?? this.videos,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      isVerified: isVerified ?? this.isVerified,
      verificationType: verificationType ?? this.verificationType,
      status: status ?? this.status,
      moderatedBy: moderatedBy ?? this.moderatedBy,
      moderationNotes: moderationNotes ?? this.moderationNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      response: response ?? this.response,
      responseBy: responseBy ?? this.responseBy,
      responseDate: responseDate ?? this.responseDate,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      reportCount: reportCount ?? this.reportCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

extension ReviewItemPayload on ReviewItem {
  Map<String, dynamic> toCreatePayload() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (createdBy != null) map['created_by'] = createdBy;
    if (updatedBy != null) map['updated_by'] = updatedBy;
    if (entityType != null) map['entity_type'] = entityType;
    if (entityId != null) map['entity_id'] = entityId;
    if (reviewerId != null) map['reviewer_id'] = reviewerId;
    if (rating != null) map['rating'] = rating;
    if (title != null) map['title'] = title;
    if (content != null) map['content'] = content;

    if (detailedRatings != null) {
      final dr = detailedRatings!;
      final drMap = <String, dynamic>{};
      if (dr.location > 0) drMap['location'] = dr.location;
      if (dr.cleanliness > 0) drMap['cleanliness'] = dr.cleanliness;
      if (dr.nightlifeRating > 0) drMap['nightlife'] = dr.nightlifeRating;
      if (dr.value > 0) drMap['value'] = dr.value;
      if (dr.amenities > 0) drMap['amenities'] = dr.amenities;
      if (drMap.isNotEmpty) {
        map['detailed_ratings'] = drMap;
      }
    }

    if (photos != null && photos!.isNotEmpty) map['photos'] = photos;
    if (videos != null && videos!.isNotEmpty) map['videos'] = videos;
    if (pros != null) map['pros'] = pros!.toJson();
    if (cons != null) map['cons'] = cons!.toJson();

    if (isVerified != null) map['is_verified'] = isVerified;
    if (verificationType != null) map['verification_type'] = verificationType;
    if (status != null) map['status'] = status;
    if (moderatedBy != null) map['moderated_by'] = moderatedBy;
    if (moderationNotes != null) map['moderation_notes'] = moderationNotes;
    if (rejectionReason != null) map['rejection_reason'] = rejectionReason;
    if (response != null) map['response'] = response;
    if (responseBy != null) map['response_by'] = responseBy;
    if (responseDate != null) map['response_date'] = responseDate;
    if (helpfulCount != null) map['helpful_count'] = helpfulCount;
    if (reportCount != null) map['report_count'] = reportCount;
    if (createdAt != null) map['createdAt'] = createdAt?.toIso8601String();
    if (updatedAt != null) map['updatedAt'] = updatedAt?.toIso8601String();
    if (reviewer != null) map['reviewer'] = reviewer?.toJson();
    if (entityUser != null) map['entityUser'] = entityUser?.toJson();
    return map;
  }
}

class Reviewer {
  final String? id;
  final String? username;
  final String? userType;
  Reviewer({this.id, this.username, this.userType});
  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'],
      username: json['username'],
      userType: json['userType'],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (username != null) map['username'] = username;
    if (userType != null) map['userType'] = userType;
    return map;
  }
}

class EntityUser {
  final String? username;
  final String? userType;
  EntityUser({this.username, this.userType});
  factory EntityUser.fromJson(Map<String, dynamic> json) {
    return EntityUser(
      username: json['username'],
      userType: json['userType'],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (username != null) map['username'] = username;
    if (userType != null) map['userType'] = userType;
    return map;
  }
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


// class DetailedRatings {
//   final double? location;
//   final double? cleanliness;
//   final double? accuracy;
//   final double? value;
//   final double? amenities;
//
//   DetailedRatings({
//     this.location,
//     this.cleanliness,
//     this.accuracy,
//     this.value,
//     this.amenities,
//   });
//
//   /// Create from Map (e.g., from JSON)
//   factory DetailedRatings.fromMap(Map<String, dynamic> map) {
//     return DetailedRatings(
//       location: (map['location'] ?? 0).toDouble(),
//       cleanliness: (map['cleanliness'] ?? 0).toDouble(),
//       accuracy: (map['accuracy'] ?? 0).toDouble(),
//       value: (map['value'] ?? 0).toDouble(),
//       amenities: (map['amenities'] ?? 0).toDouble(),
//     );
//   }
//
//   /// Convert to Map
//   Map<String, dynamic> toMap() {
//
//     final map = <String, dynamic>{};
//     if(location != 0.0)map['location']=location;
//     if(cleanliness != 0.0)map['cleanliness']= cleanliness;
//     if(accuracy != 0.0)map['accuracy']= accuracy;
//     if(value != 0.0)map['value']= value;
//     if(amenities != 0.0)map['amenities']= amenities;
//
//     return map;
//
//   }
//
//   /// Optional: copyWith for updates
//   DetailedRatings copyWith({
//     double? location,
//     double? cleanliness,
//     double? accuracy,
//     double? value,
//     double? amenities,
//   }) {
//     return DetailedRatings(
//       location: location ?? this.location,
//       cleanliness: cleanliness ?? this.cleanliness,
//       accuracy: accuracy ?? this.accuracy,
//       value: value ?? this.value,
//       amenities: amenities ?? this.amenities,
//     );
//   }
// }
