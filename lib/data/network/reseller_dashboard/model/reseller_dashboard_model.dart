// class ResellerInsightsModel {
//   final bool success;
//   final String message;
//   final ResellerData data;
//
//   ResellerInsightsModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory ResellerInsightsModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       return ResellerInsightsModel(
//         success: false,
//         message: '',
//         data: ResellerData.empty(),
//       );
//     }
//
//     return ResellerInsightsModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] == null
//           ? ResellerData.empty()
//           : ResellerData.fromJson(json['data']),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "data": data.toJson(),
//   };
// }
//
// class ResellerData {
//   final int totalAssignedProperties;
//   final Earnings earnings;
//   final Performance performance;
//   final Leaderboard leaderboard;
//   final DailyGoals dailyGoals;
//   final Level level;
//   final List<SuccessStory> successStories;
//   final List<LeadsTrend> leadsTrend;
//   final List<CommissionTrend> commissionTrend;
//   final String lastUpdated;
//
//   ResellerData({
//     required this.totalAssignedProperties,
//     required this.earnings,
//     required this.performance,
//     required this.leaderboard,
//     required this.commissionTrend,
//     required this.dailyGoals,
//     required this.level,
//     required this.successStories,
//     required this.leadsTrend,
//     required this.lastUpdated,
//   });
//
//   factory ResellerData.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return ResellerData.empty();
//
//     return ResellerData(
//       totalAssignedProperties: json['totalAssignedProperties'] ?? 0,
//       earnings: Earnings.fromJson(json['earnings'] ?? {}),
//       performance: Performance.fromJson(json['performance'] ?? {}),
//       leaderboard: Leaderboard.fromJson(json['leaderboard'] ?? {}),
//       dailyGoals: DailyGoals.fromJson(json['dailyGoals'] ?? {}),
//       level: Level.fromJson(json['level'] ?? {}),
//       successStories: (json['successStories'] as List? ?? [])
//           .map((e) => SuccessStory.fromJson(e))
//           .toList(),
//       leadsTrend: (json['leadsTrend'] as List? ?? [])
//           .map((e) => LeadsTrend.fromJson(e))
//           .toList(),
//       commissionTrend: (json['commissionTrend'] as List? ?? [])
//           .map((e) => CommissionTrend.fromJson(e))
//           .toList(),
//       lastUpdated: json['lastUpdated'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "totalAssignedProperties": totalAssignedProperties,
//     "earnings": earnings.toJson(),
//     "performance": performance.toJson(),
//     "leaderboard": leaderboard.toJson(),
//     "dailyGoals": dailyGoals.toJson(),
//     "commissionTrend": commissionTrend.map((e) => e.toJson()).toList(),
//     "level": level.toJson(),
//     "successStories": successStories.map((e) => e.toJson()).toList(),
//     "leadsTrend": leadsTrend.map((e) => e.toJson()).toList(),
//     "lastUpdated": lastUpdated,
//   };
//
//   factory ResellerData.empty() => ResellerData(
//     totalAssignedProperties: 0,
//     earnings: Earnings.empty(),
//     commissionTrend: [],
//     performance: Performance.empty(),
//     leaderboard: Leaderboard.empty(),
//     dailyGoals: DailyGoals.empty(),
//     level: Level.empty(),
//     successStories: [],
//     leadsTrend: [],
//     lastUpdated: '',
//   );
// }
//
// class Earnings {
//   final int totalCommission;
//   final String paidCommission;
//   final String unpaidCommission;
//   final double monthlyBonus;
//   final double currentMonthCommission;
//   final double previousMonthCommission;
//
//   Earnings({
//     required this.totalCommission,
//     required this.paidCommission,
//     required this.unpaidCommission,
//     required this.monthlyBonus,
//     required this.currentMonthCommission,
//     required this.previousMonthCommission,
//   });
//
//   factory Earnings.fromJson(Map<String, dynamic>? json) => Earnings(
//     totalCommission: (json?['totalCommission'] ?? 0).toDouble(),
//     paidCommission: (json?['paidCommission'] ?? '0'),
//     unpaidCommission: (json?['unpaidCommission'] ?? '0').toString(),
//     monthlyBonus: (json?['monthlyBonus'] ?? 0).toDouble(),
//     currentMonthCommission: (json?['currentMonthCommission'] ?? 0).toDouble(),
//     previousMonthCommission: (json?['previousMonthCommission'] ?? 0).toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "totalCommission": totalCommission,
//     "paidCommission": paidCommission,
//     "unpaidCommission": unpaidCommission,
//     "monthlyBonus": monthlyBonus,
//     "currentMonthCommission": currentMonthCommission,
//     "previousMonthCommission": previousMonthCommission,
//   };
//
//   factory Earnings.empty() => Earnings(
//     totalCommission: 0,
//     paidCommission: '0',
//     unpaidCommission: '0',
//     monthlyBonus: 0,
//     currentMonthCommission: 0,
//     previousMonthCommission: 0,
//   );
// }
//
// class Performance {
//   final int totalLeads;
//   final int closedDeals;
//   final double totalDealsAmount;
//   final int currentMonthLeads;
//   final int previousMonthLeads;
//
//   Performance({
//     required this.totalLeads,
//     required this.closedDeals,
//     required this.totalDealsAmount,
//     required this.currentMonthLeads,
//     required this.previousMonthLeads,
//   });
//
//   factory Performance.fromJson(Map<String, dynamic>? json) => Performance(
//     totalLeads: json?['totalLeads'] ?? 0,
//     closedDeals: json?['closedDeals'] ?? 0,
//     totalDealsAmount: (json?['totalDealsAmount'] ?? 0).toDouble(),
//     currentMonthLeads: json?['currentMonthLeads'] ?? 0,
//     previousMonthLeads: json?['previousMonthLeads'] ?? 0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "totalLeads": totalLeads,
//     "closedDeals": closedDeals,
//     "totalDealsAmount": totalDealsAmount,
//     "currentMonthLeads": currentMonthLeads,
//     "previousMonthLeads": previousMonthLeads,
//   };
//
//   factory Performance.empty() => Performance(
//     totalLeads: 0,
//     closedDeals: 0,
//     totalDealsAmount: 0,
//     currentMonthLeads: 0,
//     previousMonthLeads: 0,
//   );
// }
//
// class Leaderboard {
//   final List<TopReseller> topResellers;
//   final int currentRank;
//   final List<TopProperty> topProperties;
//
//   Leaderboard({
//     required this.topResellers,
//     required this.currentRank,
//     required this.topProperties,
//   });
//
//   factory Leaderboard.fromJson(Map<String, dynamic>? json) => Leaderboard(
//     topResellers: (json?['topResellers'] as List? ?? [])
//         .map((e) => TopReseller.fromJson(e))
//         .toList(),
//     currentRank: json?['currentRank'] ?? 0,
//     topProperties: (json?['topProperties'] as List? ?? [])
//         .map((e) => TopProperty.fromJson(e))
//         .toList(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "topResellers": topResellers.map((e) => e.toJson()).toList(),
//     "currentRank": currentRank,
//     "topProperties": topProperties.map((e) => e.toJson()).toList(),
//   };
//
//   factory Leaderboard.empty() =>
//       Leaderboard(topResellers: [], currentRank: 0, topProperties: []);
// }
//
// class TopReseller {
//   final String id;
//   final String name;
//   final double commission;
//
//   TopReseller({
//     required this.id,
//     required this.name,
//     required this.commission,
//   });
//
//   factory TopReseller.fromJson(Map<String, dynamic>? json) => TopReseller(
//     id: json?['id'] ?? '',
//     name: json?['name'] ?? '',
//     commission: (json?['commission'] ?? 0).toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "commission": commission,
//   };
// }
//
// class TopProperty {
//   final String id;
//   final double price;
//   final double commission;
//
//   TopProperty({
//     required this.id,
//     required this.price,
//     required this.commission,
//   });
//
//   factory TopProperty.fromJson(Map<String, dynamic>? json) => TopProperty(
//     id: json?['id'] ?? '',
//     price: (json?['price'] ?? 0).toDouble(),
//     commission: (json?['commission'] ?? 0).toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "price": price,
//     "commission": commission,
//   };
// }
//
// class DailyGoals {
//   final int dailyLeadGoal;
//   final int todaysLeads;
//   final int achievementStreak;
//   final int minimumLeadsForStreak;
//
//   DailyGoals({
//     required this.dailyLeadGoal,
//     required this.todaysLeads,
//     required this.achievementStreak,
//     required this.minimumLeadsForStreak,
//   });
//
//   factory DailyGoals.fromJson(Map<String, dynamic>? json) => DailyGoals(
//     dailyLeadGoal: json?['dailyLeadGoal'] ?? 0,
//     todaysLeads: json?['todaysLeads'] ?? 0,
//     achievementStreak: json?['achievementStreak'] ?? 0,
//     minimumLeadsForStreak: json?['minimumLeadsForStreak'] ?? 0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "dailyLeadGoal": dailyLeadGoal,
//     "todaysLeads": todaysLeads,
//     "achievementStreak": achievementStreak,
//     "minimumLeadsForStreak": minimumLeadsForStreak,
//   };
//
//   factory DailyGoals.empty() => DailyGoals(
//     dailyLeadGoal: 0,
//     todaysLeads: 0,
//     achievementStreak: 0,
//     minimumLeadsForStreak: 0,
//   );
// }
//
// class Level {
//   final String currentLevel;
//   final String currentLevelIcon;
//   final double commissionRate;
//   final List<String> benefits;
//   final double totalCommissionEarned;
//   final int totalClosedDeals;
//   final String nextLevelName;
//   final double nextLevelThreshold;
//   final double nextLevelCommissionRate;
//   final double amountToNextLevel;
//   final double progressToNextLevel;
//   final double totalSalesVolume;
//
//   Level({
//     required this.currentLevel,
//     required this.currentLevelIcon,
//     required this.commissionRate,
//     required this.benefits,
//     required this.totalCommissionEarned,
//     required this.totalClosedDeals,
//     required this.nextLevelName,
//     required this.nextLevelThreshold,
//     required this.nextLevelCommissionRate,
//     required this.amountToNextLevel,
//     required this.progressToNextLevel,
//     required this.totalSalesVolume,
//   });
//
//   factory Level.fromJson(Map<String, dynamic>? json) => Level(
//     currentLevel: json?['currentLevel'] ?? '',
//     currentLevelIcon: json?['currentLevelIcon'] ?? '',
//     commissionRate: (json?['commissionRate'] ?? 0).toDouble(),
//     benefits: List<String>.from(json?['benefits'] ?? []),
//     totalCommissionEarned: (json?['totalCommissionEarned'] ?? 0).toDouble(),
//     totalClosedDeals: json?['totalClosedDeals'] ?? 0,
//     nextLevelName: json?['nextLevelName'] ?? '',
//     nextLevelThreshold: (json?['nextLevelThreshold'] ?? 0).toDouble(),
//     nextLevelCommissionRate:
//     (json?['nextLevelCommissionRate'] ?? 0).toDouble(),
//     amountToNextLevel: (json?['amountToNextLevel'] ?? 0).toDouble(),
//     progressToNextLevel: (json?['progressToNextLevel'] ?? 0).toDouble(),
//     totalSalesVolume: (json?['totalSalesVolume'] ?? 0).toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "currentLevel": currentLevel,
//     "currentLevelIcon": currentLevelIcon,
//     "commissionRate": commissionRate,
//     "benefits": benefits,
//     "totalCommissionEarned": totalCommissionEarned,
//     "totalClosedDeals": totalClosedDeals,
//     "nextLevelName": nextLevelName,
//     "nextLevelThreshold": nextLevelThreshold,
//     "nextLevelCommissionRate": nextLevelCommissionRate,
//     "amountToNextLevel": amountToNextLevel,
//     "progressToNextLevel": progressToNextLevel,
//     "totalSalesVolume": totalSalesVolume,
//   };
//
//   factory Level.empty() => Level(
//     currentLevel: '',
//     currentLevelIcon: '',
//     commissionRate: 0,
//     benefits: [],
//     totalCommissionEarned: 0,
//     totalClosedDeals: 0,
//     nextLevelName: '',
//     nextLevelThreshold: 0,
//     nextLevelCommissionRate: 0,
//     amountToNextLevel: 0,
//     progressToNextLevel: 0,
//     totalSalesVolume: 0,
//   );
// }
//
// class SuccessStory {
//   final String id;
//   final String createdBy;
//   final String updatedBy;
//   final String resellerId;
//   final String title;
//   final String description;
//   final String achievement;
//   final String monthYear;
//   final int totalDeals;
//   final String totalValue;
//   final double rating;
//   final String image;
//   final String status;
//   final String createdAt;
//   final String updatedAt;
//
//   SuccessStory({
//     required this.id,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.resellerId,
//     required this.title,
//     required this.description,
//     required this.achievement,
//     required this.monthYear,
//     required this.totalDeals,
//     required this.totalValue,
//     required this.rating,
//     required this.image,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory SuccessStory.fromJson(Map<String, dynamic>? json) => SuccessStory(
//     id: json?['id'] ?? '',
//     createdBy: json?['created_by'] ?? '',
//     updatedBy: json?['updated_by'] ?? '',
//     resellerId: json?['resellerId'] ?? '',
//     title: json?['title'] ?? '',
//     description: json?['description'] ?? '',
//     achievement: json?['achievement'] ?? '',
//     monthYear: json?['monthYear'] ?? '',
//     totalDeals: json?['totalDeals'] ?? 0,
//     totalValue: json?['totalValue']?.toString() ?? '0',
//     rating: (json?['rating'] ?? 0).toDouble(),
//     image: json?['image'] ?? '',
//     status: json?['status'] ?? '',
//     createdAt: json?['createdAt'] ?? '',
//     updatedAt: json?['updatedAt'] ?? '',
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "created_by": createdBy,
//     "updated_by": updatedBy,
//     "resellerId": resellerId,
//     "title": title,
//     "description": description,
//     "achievement": achievement,
//     "monthYear": monthYear,
//     "totalDeals": totalDeals,
//     "totalValue": totalValue,
//     "rating": rating,
//     "image": image,
//     "status": status,
//     "createdAt": createdAt,
//     "updatedAt": updatedAt,
//   };
// }
//
// class LeadsTrend {
//   final String name;
//   final int leads;
//
//   LeadsTrend({
//     required this.name,
//     required this.leads,
//   });
//
//   factory LeadsTrend.fromJson(Map<String, dynamic>? json) => LeadsTrend(
//     name: json?['name'] ?? '',
//     leads: json?['leads'] ?? 0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "leads": leads,
//   };
// }
//
// // =======================================================================
// // CommissionTrend ✅ NEW MODEL
// // =======================================================================
//
// class CommissionTrend {
//   final String name;
//   final double commission;
//
//   CommissionTrend({
//     required this.name,
//     required this.commission,
//   });
//
//   factory CommissionTrend.fromJson(Map<String, dynamic>? json) =>
//       CommissionTrend(
//         name: json?['name'] ?? '',
//         commission: (json?['commission'] ?? 0),
//       );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "commission": commission,
//   };
// }
//



import 'dart:convert';

class ResellerInsightsModel {
  final bool success;
  final String message;
  final ResellerData data;

  ResellerInsightsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResellerInsightsModel.fromJson(Map<String, dynamic> json) {
    return ResellerInsightsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ResellerData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }

  static ResellerInsightsModel fromRawJson(String str) =>
      ResellerInsightsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class ResellerData {
  final int totalAssignedProperties;
  final Earnings earnings;
  final Performance performance;
  final Leaderboard leaderboard;
  final DailyGoals dailyGoals;
  final Level level;
  final List<SuccessStory> successStories;
  final List<LeadsTrend> leadsTrend;
  final List<CommissionTrend> commissionTrend;
  final String lastUpdated;

  ResellerData({
    required this.totalAssignedProperties,
    required this.earnings,
    required this.performance,
    required this.leaderboard,
    required this.dailyGoals,
    required this.level,
    required this.successStories,
    required this.leadsTrend,
    required this.commissionTrend,
    required this.lastUpdated,
  });

  factory ResellerData.fromJson(Map<String, dynamic> json) {
    return ResellerData(
      totalAssignedProperties: json['totalAssignedProperties'] ?? 0,
      earnings: Earnings.fromJson(json['earnings'] ?? {}),
      performance: Performance.fromJson(json['performance'] ?? {}),
      leaderboard: Leaderboard.fromJson(json['leaderboard'] ?? {}),
      dailyGoals: DailyGoals.fromJson(json['dailyGoals'] ?? {}),
      level: Level.fromJson(json['level'] ?? {}),
      successStories: (json['successStories'] as List<dynamic>? ?? [])
          .map((e) => SuccessStory.fromJson(e))
          .toList(),
      leadsTrend: (json['leadsTrend'] as List<dynamic>? ?? [])
          .map((e) => LeadsTrend.fromJson(e))
          .toList(),
      commissionTrend: (json['commissionTrend'] as List<dynamic>? ?? [])
          .map((e) => CommissionTrend.fromJson(e))
          .toList(),
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAssignedProperties': totalAssignedProperties,
      'earnings': earnings.toJson(),
      'performance': performance.toJson(),
      'leaderboard': leaderboard.toJson(),
      'dailyGoals': dailyGoals.toJson(),
      'level': level.toJson(),
      'successStories': successStories.map((e) => e.toJson()).toList(),
      'leadsTrend': leadsTrend.map((e) => e.toJson()).toList(),
      'commissionTrend': commissionTrend.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated,
    };
  }
}

class Earnings {
  final num totalCommission;
  final String paidCommission;
  final String unpaidCommission;
  final num monthlyBonus;
  final num currentMonthCommission;
  final num previousMonthCommission;

  Earnings({
    required this.totalCommission,
    required this.paidCommission,
    required this.unpaidCommission,
    required this.monthlyBonus,
    required this.currentMonthCommission,
    required this.previousMonthCommission,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      totalCommission: json['totalCommission'] ?? 0,
      paidCommission: json['paidCommission'] ?? '0',
      unpaidCommission: json['unpaidCommission'] ?? '0',
      monthlyBonus: json['monthlyBonus'] ?? 0,
      currentMonthCommission: json['currentMonthCommission'] ?? 0,
      previousMonthCommission: json['previousMonthCommission'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCommission': totalCommission,
      'paidCommission': paidCommission,
      'unpaidCommission': unpaidCommission,
      'monthlyBonus': monthlyBonus,
      'currentMonthCommission': currentMonthCommission,
      'previousMonthCommission': previousMonthCommission,
    };
  }
}

class Performance {
  final int totalLeads;
  final int closedDeals;
  final num totalDealsAmount;
  final int currentMonthLeads;
  final int previousMonthLeads;

  Performance({
    required this.totalLeads,
    required this.closedDeals,
    required this.totalDealsAmount,
    required this.currentMonthLeads,
    required this.previousMonthLeads,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      totalLeads: json['totalLeads'] ?? 0,
      closedDeals: json['closedDeals'] ?? 0,
      totalDealsAmount: json['totalDealsAmount'] ?? 0,
      currentMonthLeads: json['currentMonthLeads'] ?? 0,
      previousMonthLeads: json['previousMonthLeads'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalLeads': totalLeads,
      'closedDeals': closedDeals,
      'totalDealsAmount': totalDealsAmount,
      'currentMonthLeads': currentMonthLeads,
      'previousMonthLeads': previousMonthLeads,
    };
  }
}

class Leaderboard {
  final List<TopReseller> topResellers;
  final int currentRank;
  final List<TopProperty> topProperties;

  Leaderboard({
    required this.topResellers,
    required this.currentRank,
    required this.topProperties,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      topResellers: (json['topResellers'] as List<dynamic>? ?? [])
          .map((e) => TopReseller.fromJson(e))
          .toList(),
      currentRank: json['currentRank'] ?? 0,
      topProperties: (json['topProperties'] as List<dynamic>? ?? [])
          .map((e) => TopProperty.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topResellers': topResellers.map((e) => e.toJson()).toList(),
      'currentRank': currentRank,
      'topProperties': topProperties.map((e) => e.toJson()).toList(),
    };
  }
}

class TopReseller {
  final int rank;
  final String resellerId;
  final String name;
  final String email;
  final String city;
  final String state;
  final num totalCommission;
  final String level;
  final bool isCurrentUser;

  TopReseller({
    required this.rank,
    required this.resellerId,
    required this.name,
    required this.email,
    required this.city,
    required this.state,
    required this.totalCommission,
    required this.level,
    required this.isCurrentUser,
  });

  factory TopReseller.fromJson(Map<String, dynamic> json) {
    return TopReseller(
      rank: json['rank'] ?? 0,
      resellerId: json['resellerId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      totalCommission: json['totalCommission'] ?? 0,
      level: json['level'] ?? '',
      isCurrentUser: json['isCurrentUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'resellerId': resellerId,
      'name': name,
      'email': email,
      'city': city,
      'state': state,
      'totalCommission': totalCommission,
      'level': level,
      'isCurrentUser': isCurrentUser,
    };
  }
}

class TopProperty {
  final String id;
  final String propertyType;
  final String city;
  final String? state;
  final String image;
  final num price;
  final num commission;

  TopProperty({
    required this.id,
    required this.propertyType,
    required this.city,
    this.state,
    required this.image,
    required this.price,
    required this.commission,
  });

  factory TopProperty.fromJson(Map<String, dynamic> json) {
    return TopProperty(
      id: json['id'] ?? '',
      propertyType: json['propertyType'] ?? '',
      city: json['city'] ?? '',
      state: json['state'],
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      commission: json['commission'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyType': propertyType,
      'city': city,
      'state': state,
      'image': image,
      'price': price,
      'commission': commission,
    };
  }
}

class DailyGoals {
  final int dailyLeadGoal;
  final int todaysLeads;
  final int achievementStreak;
  final int minimumLeadsForStreak;

  DailyGoals({
    required this.dailyLeadGoal,
    required this.todaysLeads,
    required this.achievementStreak,
    required this.minimumLeadsForStreak,
  });

  factory DailyGoals.fromJson(Map<String, dynamic> json) {
    return DailyGoals(
      dailyLeadGoal: json['dailyLeadGoal'] ?? 0,
      todaysLeads: json['todaysLeads'] ?? 0,
      achievementStreak: json['achievementStreak'] ?? 0,
      minimumLeadsForStreak: json['minimumLeadsForStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyLeadGoal': dailyLeadGoal,
      'todaysLeads': todaysLeads,
      'achievementStreak': achievementStreak,
      'minimumLeadsForStreak': minimumLeadsForStreak,
    };
  }
}

class Level {
  final String currentLevel;
  final String currentLevelIcon;
  final num commissionRate;
  final List<String> benefits;
  final num totalCommissionEarned;
  final num totalClosedDeals;
  final String nextLevelName;
  final num nextLevelThreshold;
  final num nextLevelCommissionRate;
  final num amountToNextLevel;
  final num progressToNextLevel;
  final num totalSalesVolume;

  Level({
    required this.currentLevel,
    required this.currentLevelIcon,
    required this.commissionRate,
    required this.benefits,
    required this.totalCommissionEarned,
    required this.totalClosedDeals,
    required this.nextLevelName,
    required this.nextLevelThreshold,
    required this.nextLevelCommissionRate,
    required this.amountToNextLevel,
    required this.progressToNextLevel,
    required this.totalSalesVolume,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      currentLevel: json['currentLevel'] ?? '',
      currentLevelIcon: json['currentLevelIcon'] ?? '',
      commissionRate: json['commissionRate'] ?? 0,
      benefits:
      (json['benefits'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      totalCommissionEarned: json['totalCommissionEarned'] ?? 0,
      totalClosedDeals: json['totalClosedDeals'] ?? 0,
      nextLevelName: json['nextLevelName'] ?? '',
      nextLevelThreshold: json['nextLevelThreshold'] ?? 0,
      nextLevelCommissionRate: json['nextLevelCommissionRate'] ?? 0,
      amountToNextLevel: json['amountToNextLevel'] ?? 0,
      progressToNextLevel: json['progressToNextLevel'] ?? 0,
      totalSalesVolume: json['totalSalesVolume'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'currentLevelIcon': currentLevelIcon,
      'commissionRate': commissionRate,
      'benefits': benefits,
      'totalCommissionEarned': totalCommissionEarned,
      'totalClosedDeals': totalClosedDeals,
      'nextLevelName': nextLevelName,
      'nextLevelThreshold': nextLevelThreshold,
      'nextLevelCommissionRate': nextLevelCommissionRate,
      'amountToNextLevel': amountToNextLevel,
      'progressToNextLevel': progressToNextLevel,
      'totalSalesVolume': totalSalesVolume,
    };
  }
}

class SuccessStory {
  final String id;
  final String createdBy;
  final String? updatedBy;
  final String resellerId;
  final String title;
  final String description;
  final String achievement;
  final String monthYear;
  final int totalDeals;
  final String totalValue;
  final int rating;
  final String? image;
  final String status;
  final String createdAt;
  final String updatedAt;

  SuccessStory({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.resellerId,
    required this.title,
    required this.description,
    required this.achievement,
    required this.monthYear,
    required this.totalDeals,
    required this.totalValue,
    required this.rating,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SuccessStory.fromJson(Map<String, dynamic> json) {
    return SuccessStory(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      resellerId: json['resellerId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      achievement: json['achievement'] ?? '',
      monthYear: json['monthYear'] ?? '',
      totalDeals: json['totalDeals'] ?? 0,
      totalValue: json['totalValue'] ?? '0',
      rating: json['rating'] ?? 0,
      image: json['image'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'resellerId': resellerId,
      'title': title,
      'description': description,
      'achievement': achievement,
      'monthYear': monthYear,
      'totalDeals': totalDeals,
      'totalValue': totalValue,
      'rating': rating,
      'image': image,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class LeadsTrend {
  final String name;
  final int leads;

  LeadsTrend({
    required this.name,
    required this.leads,
  });

  factory LeadsTrend.fromJson(Map<String, dynamic> json) {
    return LeadsTrend(
      name: json['name'] ?? '',
      leads: json['leads'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'leads': leads,
    };
  }
}

class CommissionTrend {
  final String name;
  final num commission;

  CommissionTrend({
    required this.name,
    required this.commission,
  });

  factory CommissionTrend.fromJson(Map<String, dynamic> json) {
    return CommissionTrend(
      name: json['name'] ?? '',
      commission: json['commission'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'commission': commission,
    };
  }
}
