// class MarketInsightResponse {
//   final bool success;
//   final MarketData data;
//
//   MarketInsightResponse({required this.success, required this.data});
//
//   factory MarketInsightResponse.fromJson(Map<String, dynamic> json) {
//     return MarketInsightResponse(
//       success: json['success'] ?? false,
//       data: MarketData.fromJson(json['data'] ?? {}),
//     );
//   }
// }
//
// class MarketData {
//   final Map<String, Map<String, List<LocationInsight>>> buy;
//   final Map<String, dynamic> rent;
//
//   MarketData({required this.buy, required this.rent});
//
//   factory MarketData.fromJson(Map<String, dynamic> json) {
//     Map<String, Map<String, List<LocationInsight>>> parseBuy(
//       Map<String, dynamic> input,
//     ) {
//       final result = <String, Map<String, List<LocationInsight>>>{};
//
//       input.forEach((state, cities) {
//         final cityMap = <String, List<LocationInsight>>{};
//         (cities as Map<String, dynamic>).forEach((city, locations) {
//           cityMap[city] =
//               (locations as List)
//                   .map((e) => LocationInsight.fromJson(e))
//                   .toList();
//         });
//         result[state] = cityMap;
//       });
//
//       return result;
//     }
//
//     return MarketData(
//       buy: parseBuy(json['buy'] ?? {}),
//       rent: json['rent'] ?? {},
//     );
//   }
// }
//
// class LocationInsight {
//   final String location;
//   final int totalListings;
//   final double demandIndex;
//   final double oneYearGrowth;
//   final double threeYearGrowth;
//   final double fiveYearGrowth;
//   final List<PriceTrend> priceTrend;
//   final Map<String, PropertyTypeData> propertyTypes;
//
//   LocationInsight({
//     required this.location,
//     required this.totalListings,
//     required this.demandIndex,
//     required this.priceTrend,
//     required this.propertyTypes,
//     this.oneYearGrowth = 0.0,
//     this.threeYearGrowth = 0.0,
//     this.fiveYearGrowth = 0.0,
//   });
//
//   factory LocationInsight.fromJson(Map<String, dynamic> json) {
//     return LocationInsight(
//       location: json['location'] ?? '',
//       totalListings: json['totalListings'] ?? 0,
//       demandIndex: (json['demandIndex'] ?? 0).toDouble(),
//       priceTrend:
//           (json['priceTrend'] as List? ?? [])
//               .map((e) => PriceTrend.fromJson(e))
//               .toList(),
//       propertyTypes: (json['propertyTypes'] as Map<String, dynamic>? ?? {}).map(
//         (key, value) => MapEntry(key, PropertyTypeData.fromJson(value)),
//       ),
//       oneYearGrowth: (json['oneYearGrowth'] ?? 0).toDouble(),
//       threeYearGrowth: (json['threeYearGrowth'] ?? 0).toDouble(),
//       fiveYearGrowth: (json['fiveYearGrowth'] ?? 0).toDouble(),
//     );
//   }
// }
//
// class PropertyTypeData {
//   final int totalListings;
//   final int avgPrice;
//   final PricePerSqFt pricePerSqFt;
//   final Map<String, int> bhkDistribution;
//   final List<PriceTrend> priceTrend;
//
//   PropertyTypeData({
//     required this.totalListings,
//     required this.avgPrice,
//     required this.pricePerSqFt,
//     required this.bhkDistribution,
//     required this.priceTrend,
//   });
//
//   factory PropertyTypeData.fromJson(Map<String, dynamic> json) {
//     return PropertyTypeData(
//       totalListings: json['totalListings'] ?? 0,
//       avgPrice: json['avgPrice'] ?? 0,
//       pricePerSqFt: PricePerSqFt.fromJson(json['pricePerSqFt'] ?? {}),
//       bhkDistribution: (json['bhkDistribution'] as Map<String, dynamic>? ?? {})
//           .map((k, v) => MapEntry(k, v as int)),
//       priceTrend:
//           (json['priceTrend'] as List? ?? [])
//               .map((e) => PriceTrend.fromJson(e))
//               .toList(),
//     );
//   }
// }
//
// class PricePerSqFt {
//   final int min;
//   final int max;
//   final int avg;
//
//   PricePerSqFt({required this.min, required this.max, required this.avg});
//
//   factory PricePerSqFt.fromJson(Map<String, dynamic> json) {
//     return PricePerSqFt(
//       min: json['min'] ?? 0,
//       max: json['max'] ?? 0,
//       avg: json['avg'] ?? 0,
//     );
//   }
// }
//
// class PriceTrend {
//   final int year;
//   final int avgPricePerSqFt;
//
//   PriceTrend({required this.year, required this.avgPricePerSqFt});
//
//   factory PriceTrend.fromJson(Map<String, dynamic> json) {
//     return PriceTrend(
//       year: json['year'] ?? 0,
//       avgPricePerSqFt: json['avgPricePerSqFt'] ?? 0,
//     );
//   }
// }

class MarketInsightResponse {
  final bool success;
  final MarketData data;

  MarketInsightResponse({required this.success, required this.data});

  factory MarketInsightResponse.fromJson(Map<String, dynamic> json) {
    return MarketInsightResponse(
      success: json['success'] ?? false,
      data: MarketData.fromJson(json['data'] ?? {}),
    );
  }
}

class MarketData {
  final Map<String, Map<String, List<LocationInsight>>> buy;
  final Map<String, dynamic> rent;

  MarketData({required this.buy, required this.rent});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, List<LocationInsight>>> parseBuy(
      Map<String, dynamic> input,
    ) {
      final result = <String, Map<String, List<LocationInsight>>>{};

      input.forEach((state, cities) {
        final cityMap = <String, List<LocationInsight>>{};
        (cities as Map<String, dynamic>).forEach((city, locations) {
          cityMap[city] =
              (locations as List)
                  .map((e) => LocationInsight.fromJson(e))
                  .toList();
        });
        result[state] = cityMap;
      });

      return result;
    }

    return MarketData(
      buy: parseBuy(json['buy'] ?? {}),
      rent: json['rent'] ?? {},
    );
  }
}

class LocationInsight {
  final String location;
  final int totalListings;
  final double demandIndex;
  final double oneYearGrowth;
  final double threeYearGrowth;
  final double fiveYearGrowth;
  final List<PriceTrend> priceTrend;
  final Map<String, PropertyTypeData> propertyTypes;

  LocationInsight({
    required this.location,
    required this.totalListings,
    required this.demandIndex,
    required this.oneYearGrowth,
    required this.threeYearGrowth,
    required this.fiveYearGrowth,
    required this.priceTrend,
    required this.propertyTypes,
  });

  factory LocationInsight.fromJson(Map<String, dynamic> json) {
    return LocationInsight(
      location: json['location'] ?? '',
      totalListings: json['totalListings'] ?? 0,
      demandIndex: (json['demandIndex'] ?? 0).toDouble(),
      oneYearGrowth: (json['oneYearGrowth'] ?? 0).toDouble(),
      threeYearGrowth: (json['threeYearGrowth'] ?? 0).toDouble(),
      fiveYearGrowth: (json['fiveYearGrowth'] ?? 0).toDouble(),
      priceTrend:
          (json['priceTrend'] as List? ?? [])
              .map((e) => PriceTrend.fromJson(e))
              .toList(),
      propertyTypes: (json['propertyTypes'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, PropertyTypeData.fromJson(value)),
      ),
    );
  }
}

class PropertyTypeData {
  final int totalListings;
  final int avgPrice;
  final double oneYearGrowth;
  final double threeYearGrowth;
  final double fiveYearGrowth;
  final PricePerSqFt pricePerSqFt;
  final Map<String, int> bhkDistribution;
  final List<PriceTrend> priceTrend;

  PropertyTypeData({
    required this.totalListings,
    required this.avgPrice,
    required this.oneYearGrowth,
    required this.threeYearGrowth,
    required this.fiveYearGrowth,
    required this.pricePerSqFt,
    required this.bhkDistribution,
    required this.priceTrend,
  });

  factory PropertyTypeData.fromJson(Map<String, dynamic> json) {
    return PropertyTypeData(
      totalListings: json['totalListings'] ?? 0,
      avgPrice: json['avgPrice'] ?? 0,
      oneYearGrowth: (json['oneYearGrowth'] ?? 0).toDouble(),
      threeYearGrowth: (json['threeYearGrowth'] ?? 0).toDouble(),
      fiveYearGrowth: (json['fiveYearGrowth'] ?? 0).toDouble(),
      pricePerSqFt: PricePerSqFt.fromJson(json['pricePerSqFt'] ?? {}),
      bhkDistribution: (json['bhkDistribution'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, v as int)),
      priceTrend:
          (json['priceTrend'] as List? ?? [])
              .map((e) => PriceTrend.fromJson(e))
              .toList(),
    );
  }
}

class PricePerSqFt {
  final int min;
  final int max;
  final int avg;

  PricePerSqFt({required this.min, required this.max, required this.avg});

  factory PricePerSqFt.fromJson(Map<String, dynamic> json) {
    return PricePerSqFt(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      avg: json['avg'] ?? 0,
    );
  }
}

class PriceTrend {
  final int year;
  final int avgPrice;
  final int avgPricePerSqFt;
  final double yoyGrowth;

  PriceTrend({
    required this.year,
    required this.avgPrice,
    required this.avgPricePerSqFt,
    required this.yoyGrowth,
  });

  factory PriceTrend.fromJson(Map<String, dynamic> json) {
    return PriceTrend(
      year: json['year'] ?? 0,
      avgPrice: json['avgPrice'] ?? 0,
      avgPricePerSqFt: json['avgPricePerSqFt'] ?? 0,
      yoyGrowth: (json['yoyGrowth'] ?? 0).toDouble(),
    );
  }
}
