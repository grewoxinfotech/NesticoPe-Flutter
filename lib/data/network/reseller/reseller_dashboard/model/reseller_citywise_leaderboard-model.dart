import 'dart:convert';

/// 📊 Reseller Leaderboard Citywise Response Model
class ResellerLeaderboardCitywise {
  final bool success;
  final String message;
  final List<ResellerLeaderboardCitywiseData> data;

  ResellerLeaderboardCitywise({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResellerLeaderboardCitywise.fromJson(Map<String, dynamic> json) {
    return ResellerLeaderboardCitywise(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ResellerLeaderboardCitywiseData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };

  Map<String, dynamic> toMap() => toJson();

  static ResellerLeaderboardCitywise fromJsonString(String str) =>
      ResellerLeaderboardCitywise.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

/// 🏆 Individual Reseller Citywise Leaderboard Entry
class ResellerLeaderboardCitywiseData {
  final int rank;
  final String resellerId;
  final String name;
  final String email;
  final String? city;
  final String? state;
  final String? profilePic;
  final num totalCommission;
  final int totalTransactions;
  final int totalLeads;
  final int totalDeals;
  final num performanceScore;
  final String? level;

  ResellerLeaderboardCitywiseData({
    required this.rank,
    required this.resellerId,
    required this.name,
    required this.email,
    this.city,
    this.state,
    this.profilePic,
    required this.totalCommission,
    required this.totalTransactions,
    required this.totalLeads,
    required this.totalDeals,
    required this.performanceScore,
    this.level,
  });

  factory ResellerLeaderboardCitywiseData.fromJson(Map<String, dynamic> json) {
    return ResellerLeaderboardCitywiseData(
      rank: json['rank'] ?? 0,
      resellerId: json['resellerId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      city: json['city'],
      state: json['state'],
      profilePic: json['profilePic'],
      totalCommission: json['totalCommission'] ?? 0,
      totalTransactions: json['totalTransactions'] ?? 0,
      totalLeads: json['totalLeads'] ?? 0,
      totalDeals: json['totalDeals'] ?? 0,
      performanceScore: json['performanceScore'] ?? 0,
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'resellerId': resellerId,
    'name': name,
    'email': email,
    'city': city,
    'state': state,
    'profilePic': profilePic,
    'totalCommission': totalCommission,
    'totalTransactions': totalTransactions,
    'totalLeads': totalLeads,
    'totalDeals': totalDeals,
    'performanceScore': performanceScore,
    'level': level,
  };

  Map<String, dynamic> toMap() => toJson();
}


/// 📊 Reseller City Leaderboard - All Cities Model
class ResellerCityLeaderBoardAllCities {
  final bool success;
  final String message;
  final List<ResellerCityLeaderBoardAllCitiesData> data;

  ResellerCityLeaderBoardAllCities({
    required this.success,
    required this.message,
    required this.data,
  });

  /// ✅ Factory for parsing from JSON
  factory ResellerCityLeaderBoardAllCities.fromJson(Map<String, dynamic> json) {
    return ResellerCityLeaderBoardAllCities(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
          ResellerCityLeaderBoardAllCitiesData.fromJson(e))
          .toList() ??
          [],
    );
  }

  /// ✅ Convert object to JSON map
  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };

  /// ✅ For Map conversion compatibility
  Map<String, dynamic> toMap() => toJson();

  /// ✅ Helpers for JSON string handling
  static ResellerCityLeaderBoardAllCities fromJsonString(String str) =>
      ResellerCityLeaderBoardAllCities.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

/// 🏙️ Individual City Entry
class ResellerCityLeaderBoardAllCitiesData {
  final String city;
  final int count;

  ResellerCityLeaderBoardAllCitiesData({
    required this.city,
    required this.count,
  });

  factory ResellerCityLeaderBoardAllCitiesData.fromJson(
      Map<String, dynamic> json) {
    return ResellerCityLeaderBoardAllCitiesData(
      city: json['city'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'count': count,
  };

  Map<String, dynamic> toMap() => toJson();
}
