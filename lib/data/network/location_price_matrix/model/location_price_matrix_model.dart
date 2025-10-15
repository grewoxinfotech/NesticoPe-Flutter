class LocationPriceMatrixModel {
  final bool? success;
  final LocationPriceMatrixData? data;

  LocationPriceMatrixModel({this.success, this.data});

  factory LocationPriceMatrixModel.fromJson(Map<String, dynamic> json) {
    return LocationPriceMatrixModel(
      success: json['success'],
      data: json['data'] != null ? LocationPriceMatrixData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.toJson(),
  };
}

class  LocationPriceMatrixData{
  final Map<String, dynamic>? buy;
  final Map<String, dynamic>? rent;

  LocationPriceMatrixData({this.buy, this.rent});

  factory LocationPriceMatrixData.fromJson(Map<String, dynamic> json) {
    return LocationPriceMatrixData(
      buy: json['buy'] != null ? Map<String, dynamic>.from(json['buy']) : null,
      rent: json['rent'] != null ? Map<String, dynamic>.from(json['rent']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'buy': buy,
    'rent': rent,
  };
}

/// Generic model for Buy/Rent listings (used within nested maps)
class LocationPriceMatrixListings {
  final String? location;
  final int? totalListings;
  final num? avgPrice;
  final PricePerSqFt? pricePerSqFt;
  final Map<String, dynamic>? bhkDistribution;
  final num? demandIndex;

  // Rent-specific fields (optional)
  final num? minPrice;
  final num? maxPrice;

  LocationPriceMatrixListings({
    this.location,
    this.totalListings,
    this.avgPrice,
    this.pricePerSqFt,
    this.bhkDistribution,
    this.demandIndex,
    this.minPrice,
    this.maxPrice,
  });

  factory LocationPriceMatrixListings.fromJson(Map<String, dynamic> json) {
    return LocationPriceMatrixListings(
      location: json['location'],
      totalListings: json['totalListings'],
      avgPrice: json['avgPrice'],
      pricePerSqFt: json['pricePerSqFt'] != null
          ? PricePerSqFt.fromJson(json['pricePerSqFt'])
          : null,
      bhkDistribution: json['bhkDistribution'] != null
          ? Map<String, dynamic>.from(json['bhkDistribution'])
          : {},
      demandIndex: json['demandIndex'],
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
    );
  }

  Map<String, dynamic> toJson() => {
    'location': location,
    'totalListings': totalListings,
    'avgPrice': avgPrice,
    'pricePerSqFt': pricePerSqFt?.toJson(),
    'bhkDistribution': bhkDistribution,
    'demandIndex': demandIndex,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
  };
}

class PricePerSqFt {
  final num? min;
  final num? max;
  final num? avg;

  PricePerSqFt({this.min, this.max, this.avg});

  factory PricePerSqFt.fromJson(Map<String, dynamic> json) {
    return PricePerSqFt(
      min: json['min'],
      max: json['max'],
      avg: json['avg'],
    );
  }

  Map<String, dynamic> toJson() => {
    'min': min,
    'max': max,
    'avg': avg,
  };
}
