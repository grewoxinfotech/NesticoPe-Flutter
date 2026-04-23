class ViewResponseModel {
  final bool success;
  final String message;
  final ViewData? data;

  ViewResponseModel({required this.success, required this.message, this.data});

  factory ViewResponseModel.fromJson(Map<String, dynamic> json) {
    return ViewResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ViewData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class ViewData {
  final List<PropertyView> property;

  ViewData({required this.property});

  factory ViewData.fromJson(Map<String, dynamic> json) {
    return ViewData(
      property:
          (json['property'] as List<dynamic>?)
              ?.map((e) => PropertyView.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'property': property.map((e) => e.toJson()).toList(),
  };
}

class PropertyView {
  final int id;
  final String propertyId;
  final String userId;
  final DateTime? viewedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String entityType;
  final PropertyDetails? details;

  PropertyView({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.viewedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.entityType,
    this.details,
  });

  factory PropertyView.fromJson(Map<String, dynamic> json) {
    return PropertyView(
      id: json['id'] ?? 0,
      propertyId: json['propertyId'] ?? '',
      userId: json['userId'] ?? '',
      viewedAt:
          json['viewedAt'] != null ? DateTime.parse(json['viewedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      entityType: json['entityType'] ?? '',
      details:
          json['details'] != null
              ? PropertyDetails.fromJson(json['details'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'userId': userId,
    'viewedAt': viewedAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'entityType': entityType,
    'details': details?.toJson(),
  };

  /// ✅ SAFE display price
  String get displayPrice {
    if (details == null) return '-';

    if (entityType == 'property') {
      return details!.price?.toString() ?? '-';
    }

    final range = details!.priceRange;
    if (range == null) return '-';

    return (range.minPrice == range.maxPrice)
        ? range.maxPrice.toString()
        : "${range.minPrice} - ${range.maxPrice}";
  }
}

class PropertyDetails {
  final String id;
  final String? projectName;
  final String? propertyTypes;
  final String? propertyType;
  final String? listingType;
  final String? images;
  final String? location;
  final String? city;
  final String? status;

  final PriceRange? priceRange;

  final num? price;
  final String? priceType;

  PropertyDetails({
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

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    final dynamic priceData = json['price'];
    PriceRange? parsedRange;
    num? parsedPrice;

    if (priceData is Map<String, dynamic>) {
      parsedRange = PriceRange.fromJson(priceData);
    } else if (priceData is num) {
      parsedPrice = priceData;
    }

    parsedRange ??=
        json['priceRange'] != null
            ? PriceRange.fromJson(json['priceRange'])
            : null;

    return PropertyDetails(
      id: json['id'] ?? '',
      projectName: json['projectName'],
      propertyTypes: json['propertyTypes'],
      propertyType: json['propertyType'],
      listingType: json['listingType'],
      images: json['images'],
      location: json['location'],
      city: json['city'],
      status: json['status'],
      priceRange: parsedRange,
      price: parsedPrice,
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
    'priceRange': priceRange?.toJson(),
    'price': price,
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
