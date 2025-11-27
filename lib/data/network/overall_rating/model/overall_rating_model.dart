class PropertyReviewResponse {
  final bool success;
  final String message;
  final ReviewData? data;

  PropertyReviewResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PropertyReviewResponse.fromJson(Map<String, dynamic> json) {
    return PropertyReviewResponse(
      success: json['story'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'story': success, 'message': message, 'data': data?.toJson()};
  }
}

class ReviewData {
  final int totalReviews;
  final double overallRating;
  final DetailedRatings detailedRatings;

  ReviewData({
    required this.totalReviews,
    required this.overallRating,
    required this.detailedRatings,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      totalReviews: json['totalReviews'] ?? 0,
      overallRating: (json['overallRating'] ?? 0).toDouble(),
      detailedRatings: DetailedRatings.fromJson(json['detailedRatings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'overallRating': overallRating,
      'detailedRatings': detailedRatings.toJson(),
    };
  }
}

class DetailedRatings {
  final double location;
  final double cleanliness;
  final double accuracy;
  final double value;
  final double amenities;

  DetailedRatings({
    required this.location,
    required this.cleanliness,
    required this.accuracy,
    required this.value,
    required this.amenities,
  });

  factory DetailedRatings.fromJson(Map<String, dynamic> json) {
    return DetailedRatings(
      location: (json['location'] ?? 0).toDouble(),
      cleanliness: (json['cleanliness'] ?? 0).toDouble(),
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      value: (json['value'] ?? 0).toDouble(),
      amenities: (json['amenities'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'cleanliness': cleanliness,
      'accuracy': accuracy,
      'value': value,
      'amenities': amenities,
    };
  }

  factory DetailedRatings.empty() => DetailedRatings(
    location: 0,
    cleanliness: 0,
    accuracy: 0,
    value: 0,
    amenities: 0,
  );
}
