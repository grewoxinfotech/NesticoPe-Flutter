class SharePropertyResponse {
  final bool success;
  final String message;
  final ShareData? data;

  SharePropertyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SharePropertyResponse.fromJson(Map<String, dynamic> json) {
    return SharePropertyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ShareData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ShareData {
  final String shareId;
  final String shareUrl;
  final String propertyId;

  ShareData({
    required this.shareId,
    required this.shareUrl,
    required this.propertyId,
  });

  factory ShareData.fromJson(Map<String, dynamic> json) {
    return ShareData(
      shareId: json['shareId'] ?? '',
      shareUrl: json['shareUrl'] ?? '',
      propertyId: json['propertyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shareId': shareId,
      'shareUrl': shareUrl,
      'propertyId': propertyId,
    };
  }
}