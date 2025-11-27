import 'dart:convert';

class TrendingAreasResponse {
  final bool success;
  final String message;
  final List<TrendingArea> data;

  TrendingAreasResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TrendingAreasResponse.fromJson(Map<String, dynamic> json) {
    return TrendingAreasResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => TrendingArea.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class TrendingArea {
  final String area;
  final String city;
  final int propertyCount;
  final int totalViews;
  final int totalInquiries;

  TrendingArea({
    required this.area,
    required this.city,
    required this.propertyCount,
    required this.totalViews,
    required this.totalInquiries,
  });

  factory TrendingArea.fromJson(Map<String, dynamic> json) {
    return TrendingArea(
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      propertyCount: json['propertyCount'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalInquiries: json['totalInquiries'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'area': area,
    'city': city,
    'propertyCount': propertyCount,
    'totalViews': totalViews,
    'totalInquiries': totalInquiries,
  };
}
