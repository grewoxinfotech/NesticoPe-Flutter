class TrendingCitiesResponse {
  final bool success;
  final String message;
  final List<TrendingCityData> data;

  TrendingCitiesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TrendingCitiesResponse.fromJson(Map<String, dynamic> json) {
    return TrendingCitiesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<TrendingCityData>.from(
                json['data'].map((x) => TrendingCityData.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class TrendingCityData {
  final String city;
  final String cityImage;
  final int propertyCount;
  final int totalViews;
  final int totalInquiries;

  TrendingCityData({
    required this.city,
    required this.cityImage,
    required this.propertyCount,
    required this.totalViews,
    required this.totalInquiries,
  });

  factory TrendingCityData.fromJson(Map<String, dynamic> json) {
    return TrendingCityData(
      city: json['city'] ?? '',
      cityImage: json['cityImage'] ?? '',
      propertyCount: json['propertyCount'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalInquiries: json['totalInquiries'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'cityImage': cityImage,
      'propertyCount': propertyCount,
      'totalViews': totalViews,
      'totalInquiries': totalInquiries,
    };
  }
}
