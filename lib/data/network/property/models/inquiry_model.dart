// class InquiryResponse {
//   final bool success;
//   final String message;
//   final InquiryData data;
//
//   InquiryResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory InquiryResponse.fromJson(Map<String, dynamic> json) {
//     return InquiryResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: InquiryData.fromJson(json['data'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'success': success,
//     'message': message,
//     'data': data.toJson(),
//   };
// }
//
// class InquiryData {
//   final List<Inquiry> inquiries;
//
//   InquiryData({required this.inquiries});
//
//   factory InquiryData.fromJson(Map<String, dynamic> json) {
//     return InquiryData(
//       inquiries:
//           (json['inquiries'] as List<dynamic>? ?? [])
//               .map((e) => Inquiry.fromJson(e))
//               .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'inquiries': inquiries.map((e) => e.toJson()).toList(),
//   };
// }
//
// class Inquiry {
//   final int id;
//   final String propertyId;
//   final String userId;
//   final String name;
//   final String email;
//   final String phone;
//   final DateTime inquiredAt;
//   final String? inquiryType;
//   final String? submittedAt;
//   final bool isConvertedToLead;
//   final String? convertedToLeadAt;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Inquiry({
//     required this.id,
//     required this.propertyId,
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.inquiredAt,
//     this.inquiryType,
//     this.submittedAt,
//     required this.isConvertedToLead,
//     this.convertedToLeadAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Inquiry.fromJson(Map<String, dynamic> json) {
//     return Inquiry(
//       id: json['id'] ?? 0,
//       propertyId: json['propertyId'] ?? '',
//       userId: json['userId'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       inquiredAt: DateTime.parse(json['inquiredAt']),
//       inquiryType: json['inquiryType'],
//       submittedAt: json['submittedAt'],
//       isConvertedToLead: json['isConvertedToLead'] ?? false,
//       convertedToLeadAt: json['convertedToLeadAt'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'propertyId': propertyId,
//     'userId': userId,
//     'name': name,
//     'email': email,
//     'phone': phone,
//     'inquiredAt': inquiredAt.toIso8601String(),
//     'inquiryType': inquiryType,
//     'submittedAt': submittedAt,
//     'isConvertedToLead': isConvertedToLead,
//     'convertedToLeadAt': convertedToLeadAt,
//     'createdAt': createdAt.toIso8601String(),
//     'updatedAt': updatedAt.toIso8601String(),
//   };
// }

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
  final List<Inquiry> items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  InquiryData({
    required this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory InquiryData.fromJson(Map<String, dynamic> json) {
    return InquiryData(
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => Inquiry.fromJson(e))
              .toList(),
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'total': total,
    'currentPage': currentPage,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}

class Inquiry {
  final String id;
  final String propertyId;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final DateTime inquiredAt;
  final String status;
  final String? submittedAt;
  final bool isConvertedToLead;
  final String? convertedToLeadAt;
  final Meta? meta;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String entityType;
  final InquiryDetails? details;

  Inquiry({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.inquiredAt,
    required this.status,
    this.submittedAt,
    required this.isConvertedToLead,
    this.convertedToLeadAt,
    this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.entityType,
    this.details,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] ?? "0",
      propertyId: json['propertyId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      inquiredAt: DateTime.tryParse(json['inquiredAt'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      submittedAt: json['submittedAt'],
      isConvertedToLead: json['isConvertedToLead'] ?? false,
      convertedToLeadAt: json['convertedToLeadAt'],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      entityType: json['entityType'] ?? '',
      details:
          json['details'] != null
              ? InquiryDetails.fromJson(json['details'])
              : null,
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
    'status': status,
    'submittedAt': submittedAt,
    'isConvertedToLead': isConvertedToLead,
    'convertedToLeadAt': convertedToLeadAt,
    'meta': meta?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'entityType': entityType,
    'details': details?.toJson(),
  };
}

class Meta {
  final String? negotiablePrice;
  final bool? isNegotiable;
  final String? timePeriod;
  final String? inquiryType;
  final String? visitDate;
  final String? visitTime;

  Meta({
    this.negotiablePrice,
    this.isNegotiable,
    this.timePeriod,
    this.inquiryType,
    this.visitDate,
    this.visitTime,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    final dynamic price = json['negotiablePrice'];

    return Meta(
      negotiablePrice: price == null
          ? null
          : price is int
          ? price.toString()
          : price.toString(),
      isNegotiable: json['isNegotiable'] ?? false,
      timePeriod: json['timePeriod'] ?? '',
      inquiryType: json['inquiryType'] ?? '',
      visitDate: json['visitDate'] ?? '',
      visitTime: json['visitTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'negotiablePrice': negotiablePrice,
    'isNegotiable': isNegotiable,
    'timePeriod': timePeriod,
    'inquiryType': inquiryType,
    'visitDate': visitDate,
    'visitTime': visitTime,
  };
}



class InquiryDetails {
  // Common
  final String id;
  final String? projectName;
  final String? propertyTypes;
  final String? propertyType;
  final String? listingType;
  final String? images;
  final String? location;
  final String? city;
  final String? status;

  // For project type
  final PriceRange? priceRange;

  // For property type
  final num? price;
  final String? priceType;

  InquiryDetails({
    required this.id,
    this.projectName,
    this.propertyTypes,
    this.propertyType,
    this.listingType,
    this.images,
    this.location,
    this.city,
    this.status,
    this.priceRange,
    this.price,
    this.priceType,
  });

  factory InquiryDetails.fromJson(Map<String, dynamic> json) {
    // Handle both numeric and range-style price fields safely
    final dynamic priceData = json['price'];

    PriceRange? priceRange;
    num? singlePrice;

    if (priceData is Map<String, dynamic>) {
      // it's an object like {"minPrice":6500,"maxPrice":8000}
      priceRange = PriceRange.fromJson(priceData);
    } else if (priceData is num) {
      // it's a single number like 1234567
      singlePrice = priceData;
    }

    return InquiryDetails(
      id: json['id'] ?? '',
      projectName: json['projectName'],
      propertyTypes: json['propertyTypes'],
      propertyType: json['propertyType'],
      listingType: json['listingType'],
      images: json['images'],
      location: json['location'],
      city: json['city'],
      status: json['status'],
      priceRange: priceRange,
      price: singlePrice,
      priceType: json['priceType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectName': projectName,
    'propertyTypes': propertyTypes,
    'propertyType': propertyType,
    'listingType': listingType,
    'images': images,
    'location': location,
    'city': city,
    'status': status,
    // Only include whichever price representation exists
    'price': price != null ? price : priceRange?.toJson(),
    'priceType': priceType,
  };
}

class PriceRange {
  final num minPrice;
  final num maxPrice;

  PriceRange({required this.minPrice, required this.maxPrice});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      minPrice: json['minPrice'] ?? 0,
      maxPrice: json['maxPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'minPrice': minPrice, 'maxPrice': maxPrice};
}
