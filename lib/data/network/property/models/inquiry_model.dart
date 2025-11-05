class InquiryResponse {
  final bool success;
  final String message;
  final InquiryData data;

  InquiryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InquiryResponse.fromJson(Map<String, dynamic> json) {
    return InquiryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: InquiryData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class InquiryData {
  final List<Inquiry> inquiries;

  InquiryData({required this.inquiries});

  factory InquiryData.fromJson(Map<String, dynamic> json) {
    return InquiryData(
      inquiries:
          (json['inquiries'] as List<dynamic>? ?? [])
              .map((e) => Inquiry.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'inquiries': inquiries.map((e) => e.toJson()).toList(),
  };
}

class Inquiry {
  final int id;
  final String propertyId;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final DateTime inquiredAt;
  final String? inquiryType;
  final String? submittedAt;
  final bool isConvertedToLead;
  final String? convertedToLeadAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inquiry({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.inquiredAt,
    this.inquiryType,
    this.submittedAt,
    required this.isConvertedToLead,
    this.convertedToLeadAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] ?? 0,
      propertyId: json['propertyId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      inquiredAt: DateTime.parse(json['inquiredAt']),
      inquiryType: json['inquiryType'],
      submittedAt: json['submittedAt'],
      isConvertedToLead: json['isConvertedToLead'] ?? false,
      convertedToLeadAt: json['convertedToLeadAt'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'userId': userId,
    'name': name,
    'email': email,
    'phone': phone,
    'inquiredAt': inquiredAt.toIso8601String(),
    'inquiryType': inquiryType,
    'submittedAt': submittedAt,
    'isConvertedToLead': isConvertedToLead,
    'convertedToLeadAt': convertedToLeadAt,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
