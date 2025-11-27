class FavoriteResponseModel {
  final bool success;
  final String message;
  final FavoriteData? data;

  FavoriteResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteResponseModel(
      success: json['story'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? FavoriteData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'story': success, 'message': message, 'data': data?.toJson()};
  }
}

class FavoriteData {
  final List<FavoriteItem> favorite;

  FavoriteData({required this.favorite});

  factory FavoriteData.fromJson(Map<String, dynamic> json) {
    return FavoriteData(
      favorite:
          (json['favorite'] as List<dynamic>?)
              ?.map((e) => FavoriteItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'favorite': favorite.map((e) => e.toJson()).toList()};
  }
}

class FavoriteItem {
  final int id;
  final String propertyId;
  final String userId;
  final String favoritedAt;
  final String createdAt;
  final String updatedAt;
  final String entityType;
  final FavoriteDetails details;

  FavoriteItem({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.favoritedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.entityType,
    required this.details,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? 0,
      propertyId: json['propertyId'] ?? '',
      userId: json['userId'] ?? '',
      favoritedAt: json['favoritedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      entityType: json['entityType'] ?? '',
      details: FavoriteDetails.fromJson(json['details'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'userId': userId,
      'favoritedAt': favoritedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'entityType': entityType,
      'details': details.toJson(),
    };
  }

  String get displayPrice {
    if (entityType == 'property') {
      return details.price?.toString() ?? '-';
    }
    final range = details.priceRange;
    if (range == null) return '-';
    return (range.minPrice == range.maxPrice)
        ? range.maxPrice.toString()
        : "${range.minPrice} - ${range.maxPrice}";
  }
}

class FavoriteDetails {
  final String id;
  final String? projectName;
  final String? propertyType;
  final String? propertyTypes; // for project entity
  final String? listingType;
  final String? images;
  final String? location;
  final String? city;
  final String? status;
  final int? price;
  final String? priceType;
  final PriceRange? priceRange;

  FavoriteDetails({
    required this.id,
    this.projectName,
    this.propertyType,
    this.propertyTypes,
    this.listingType,
    this.images,
    this.location,
    this.city,
    this.status,
    this.price,
    this.priceType,
    this.priceRange,
  });

  factory FavoriteDetails.fromJson(Map<String, dynamic> json) {
    return FavoriteDetails(
      id: json['id'] ?? '',
      projectName: json['projectName'],
      propertyType: json['propertyType'],
      propertyTypes: json['propertyTypes'],
      listingType: json['listingType'],
      images: json['images'],
      location: json['location'],
      city: json['city'],
      status: json['status'],
      price: json['price'],
      priceType: json['priceType'],
      priceRange:
          json['priceRange'] != null
              ? PriceRange.fromJson(json['priceRange'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectName': projectName,
      'propertyType': propertyType,
      'propertyTypes': propertyTypes,
      'listingType': listingType,
      'images': images,
      'location': location,
      'city': city,
      'status': status,
      'price': price,
      'priceType': priceType,
      'priceRange': priceRange?.toJson(),
    };
  }
}

class PriceRange {
  final int minPrice;
  final int maxPrice;

  PriceRange({required this.minPrice, required this.maxPrice});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      minPrice: json['minPrice'] ?? 0,
      maxPrice: json['maxPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'minPrice': minPrice, 'maxPrice': maxPrice};
  }
}
