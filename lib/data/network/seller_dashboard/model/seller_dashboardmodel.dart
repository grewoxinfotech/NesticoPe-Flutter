// class SellerInsightsModel {
//   final bool success;
//   final String message;
//   final SellerInsightsData data;
//
//   SellerInsightsModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory SellerInsightsModel.fromJson(Map<String, dynamic> json) {
//     return SellerInsightsModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: SellerInsightsData.fromJson(json['data'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data.toMap(),
//     };
//
//   }
// }
//
// class SellerInsightsData {
//   final PropertyMetrics propertyMetrics;
//   final LeadAnalytics leadAnalytics;
//   final FinancialMetrics financialMetrics;
//   final EngagementMetrics engagementMetrics;
//   final String lastUpdated;
//
//   SellerInsightsData({
//     required this.propertyMetrics,
//     required this.leadAnalytics,
//     required this.financialMetrics,
//     required this.engagementMetrics,
//     required this.lastUpdated,
//   });
//
//   factory SellerInsightsData.fromJson(Map<String, dynamic> json) {
//     return SellerInsightsData(
//       propertyMetrics: PropertyMetrics.fromJson(json['propertyMetrics'] ?? {}),
//       leadAnalytics: LeadAnalytics.fromJson(json['leadAnalytics'] ?? {}),
//       financialMetrics: FinancialMetrics.fromJson(
//         json['financialMetrics'] ?? {},
//       ),
//       engagementMetrics: EngagementMetrics.fromJson(
//         json['engagementMetrics'] ?? {},
//       ),
//       lastUpdated: json['lastUpdated'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'propertyMetrics': propertyMetrics.toMap(),
//       'leadAnalytics': leadAnalytics.toMap(),
//       'financialMetrics': financialMetrics.toMap(),
//       'engagementMetrics': engagementMetrics.toMap(),
//       'lastUpdated': lastUpdated,
//     };
//   }
// }
//
// class PropertyMetrics {
//   final int totalProperties;
//   final int activeListings;
//   final int pendingListings;
//   final int rejectedListings;
//
//   final List<ViewHistory> viewsHistory;
//   final Map<String, dynamic> statusDistribution;
//
//   PropertyMetrics( {
//     required this.pendingListings, required this.rejectedListings,
//     required this.totalProperties,
//     required this.activeListings,
//     required this.viewsHistory,
//     required this.statusDistribution,
//   });
//
//   factory PropertyMetrics.fromJson(Map<String, dynamic> json) {
//     return PropertyMetrics(
//       totalProperties: json['totalProperties'] ?? 0,
//       activeListings: json['activeListings'] ?? 0,
//       rejectedListings: json['rejectedListings'] ?? 0,
//       pendingListings: json['pendingListings'] ?? 0,
//       viewsHistory:
//           (json['viewsHistory'] as List?)
//               ?.map((e) => ViewHistory.fromJson(e))
//               .toList() ??
//           [],
//       statusDistribution: json['statusDistribution'] ?? {},
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalProperties': totalProperties,
//       'activeListings': activeListings,
//       'rejectedListings': rejectedListings,
//       'pendingListings': pendingListings,
//       'viewsHistory': viewsHistory.map((e) => e.toMap()).toList(),
//       'statusDistribution': statusDistribution,
//     };
//   }
// }
//
// class ViewHistory {
//   final String month;
//   final int views;
//
//   ViewHistory({required this.month, required this.views});
//
//   factory ViewHistory.fromJson(Map<String, dynamic> json) {
//     return ViewHistory(month: json['month'] ?? '', views: json['views'] ?? 0);
//   }
//
//   Map<String, dynamic> toMap() {
//     return {'month': month, 'views': views};
//   }
// }
//
// class LeadAnalytics {
//   final int totalLeads;
//   final Map<String, dynamic> sourceDistribution;
//   final double conversionRate;
//   final List<LeadsTimeline> leadsTimeline;
//
//   LeadAnalytics({
//     required this.totalLeads,
//     required this.sourceDistribution,
//     required this.conversionRate,
//     required this.leadsTimeline,
//   });
//
//   factory LeadAnalytics.fromJson(Map<String, dynamic> json) {
//     return LeadAnalytics(
//       totalLeads: json['totalLeads'] ?? 0,
//       sourceDistribution: json['sourceDistribution'] ?? {},
//       conversionRate: (json['conversionRate'] ?? 0).toDouble(),
//       leadsTimeline:
//           (json['leadsTimeline'] as List?)
//               ?.map((e) => LeadsTimeline.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalLeads': totalLeads,
//       'sourceDistribution': sourceDistribution,
//       'conversionRate': conversionRate,
//       'leadsTimeline': leadsTimeline.map((e) => e.toMap()).toList(),
//     };
//   }
// }
//
// class LeadsTimeline {
//   final String month;
//   final int count;
//
//   LeadsTimeline({required this.month, required this.count});
//
//   factory LeadsTimeline.fromJson(Map<String, dynamic> json) {
//     return LeadsTimeline(month: json['month'] ?? '', count: json['count'] ?? 0);
//   }
//
//   Map<String, dynamic> toMap() {
//     return {'month': month, 'count': count};
//   }
// }
//
// class FinancialMetrics {
//   final double totalRevenue;
//   final double averagePropertyValue;
//   final List<dynamic> revenueHistory;
//
//   FinancialMetrics({
//     required this.totalRevenue,
//     required this.averagePropertyValue,
//     required this.revenueHistory,
//   });
//
//   factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
//     return FinancialMetrics(
//       totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
//       averagePropertyValue: (json['averagePropertyValue'] ?? 0).toDouble(),
//       revenueHistory: json['revenueHistory'] ?? [],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalRevenue': totalRevenue,
//       'averagePropertyValue': averagePropertyValue,
//       'revenueHistory': revenueHistory,
//     };
//   }
// }
//
// class EngagementMetrics {
//   final double inquiryResponseRate;
//   final double averageResponseTime;
//   final double visitConversionRate;
//   final int totalVisits;
//   final int convertedVisits;
//
//   EngagementMetrics({
//     required this.inquiryResponseRate,
//     required this.averageResponseTime,
//     required this.visitConversionRate,
//     required this.totalVisits,
//     required this.convertedVisits,
//   });
//
//   factory EngagementMetrics.fromJson(Map<String, dynamic> json) {
//     return EngagementMetrics(
//       inquiryResponseRate: (json['inquiryResponseRate'] ?? 0).toDouble(),
//       averageResponseTime: (json['averageResponseTime'] ?? 0).toDouble(),
//       visitConversionRate: (json['visitConversionRate'] ?? 0).toDouble(),
//       totalVisits: json['totalVisits'] ?? 0,
//       convertedVisits: json['convertedVisits'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'inquiryResponseRate': inquiryResponseRate,
//       'averageResponseTime': averageResponseTime,
//       'visitConversionRate': visitConversionRate,
//       'totalVisits': totalVisits,
//       'convertedVisits': convertedVisits,
//     };
//   }
// }

class SellerInsightsModel {
  final bool success;
  final String message;
  final SellerInsightsData data;

  SellerInsightsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SellerInsightsModel.fromJson(Map<String, dynamic> json) {
    return SellerInsightsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SellerInsightsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data.toMap(),
    };
  }
}

class SellerInsightsData {
  final PropertyMetrics propertyMetrics;
  final LeadAnalytics leadAnalytics;
  final FinancialMetrics financialMetrics;
  final EngagementMetrics engagementMetrics;
  final SubscriptionInfo subscriptionInfo;
  final String lastUpdated;

  SellerInsightsData({
    required this.propertyMetrics,
    required this.leadAnalytics,
    required this.financialMetrics,
    required this.engagementMetrics,
    required this.subscriptionInfo,
    required this.lastUpdated,
  });

  factory SellerInsightsData.fromJson(Map<String, dynamic> json) {
    return SellerInsightsData(
      propertyMetrics: PropertyMetrics.fromJson(json['propertyMetrics'] ?? {}),
      leadAnalytics: LeadAnalytics.fromJson(json['leadAnalytics'] ?? {}),
      financialMetrics: FinancialMetrics.fromJson(json['financialMetrics'] ?? {}),
      engagementMetrics: EngagementMetrics.fromJson(json['engagementMetrics'] ?? {}),
      subscriptionInfo: SubscriptionInfo.fromJson(json['subscriptionInfo'] ?? {}),
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyMetrics': propertyMetrics.toMap(),
      'leadAnalytics': leadAnalytics.toMap(),
      'financialMetrics': financialMetrics.toMap(),
      'engagementMetrics': engagementMetrics.toMap(),
      'subscriptionInfo': subscriptionInfo.toMap(),
      'lastUpdated': lastUpdated,
    };
  }
}

class PropertyMetrics {
  final int totalProperties;
  final int activeListings;
  final int pendingListings;
  final int rejectedListings;
  final int selectedYear;
  final List<ViewHistory> viewsHistory;
  final Map<String, dynamic> statusDistribution;


  PropertyMetrics({
    required this.totalProperties,
    required this.activeListings,
    required this.pendingListings,
    required this.rejectedListings,
    required this.selectedYear,
    required this.viewsHistory,
    required this.statusDistribution,

  });

  factory PropertyMetrics.fromJson(Map<String, dynamic> json) {
    return PropertyMetrics(
      totalProperties: json['totalProperties'] ?? 0,
      activeListings: json['activeListings'] ?? 0,
      pendingListings: json['pendingListings'] ?? 0,
      rejectedListings: json['rejectedListings'] ?? 0,
      selectedYear: json['selectedYear'] ?? 0,
      viewsHistory: (json['viewsHistory'] as List?)
          ?.map((e) => ViewHistory.fromJson(e))
          .toList() ??
          [],
      statusDistribution: json['statusDistribution'] ?? {},

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalProperties': totalProperties,
      'activeListings': activeListings,
      'pendingListings': pendingListings,
      'rejectedListings': rejectedListings,
      'selectedYear': selectedYear,
      'viewsHistory': viewsHistory.map((e) => e.toMap()).toList(),
      'statusDistribution': statusDistribution,

    };
  }
}

class ViewHistory {
  final String month;
  final int views;

  ViewHistory({required this.month, required this.views});

  factory ViewHistory.fromJson(Map<String, dynamic> json) {
    return ViewHistory(
      month: json['month'] ?? '',
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'month': month, 'views': views};
  }
}

class LeadAnalytics {
  final int totalLeads;
  final Map<String, dynamic> sourceDistribution;
  final double conversionRate;
  final List<LeadsTimeline> leadsTimeline;
  final Map<String, dynamic> stageBreakdown;

  LeadAnalytics({
    required this.totalLeads,
    required this.sourceDistribution,
    required this.conversionRate,
    required this.leadsTimeline,
    required this.stageBreakdown,
  });

  factory LeadAnalytics.fromJson(Map<String, dynamic> json) {
    return LeadAnalytics(
      totalLeads: json['totalLeads'] ?? 0,
      sourceDistribution: json['sourceDistribution'] ?? {},
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      stageBreakdown: json['stageBreakdown'] ?? {},
      leadsTimeline: (json['leadsTimeline'] as List?)
          ?.map((e) => LeadsTimeline.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalLeads': totalLeads,
      'sourceDistribution': sourceDistribution,
      'conversionRate': conversionRate,
      'leadsTimeline': leadsTimeline.map((e) => e.toMap()).toList(),
      'stageBreakdown': stageBreakdown,
    };
  }
}

class LeadsTimeline {
  final String month;
  final int count;

  LeadsTimeline({required this.month, required this.count});

  factory LeadsTimeline.fromJson(Map<String, dynamic> json) {
    return LeadsTimeline(
      month: json['month'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'month': month, 'count': count};
  }
}

class FinancialMetrics {
  final double totalRevenue;
  final double averagePropertyValue;
  final int propertiesSold;
  final List<dynamic> revenueHistory;

  FinancialMetrics({
    required this.totalRevenue,
    required this.averagePropertyValue,
    required this.propertiesSold,
    required this.revenueHistory,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      averagePropertyValue: (json['averagePropertyValue'] ?? 0).toDouble(),
      propertiesSold: json['propertiesSold'] ?? 0,
      revenueHistory: json['revenueHistory'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRevenue': totalRevenue,
      'averagePropertyValue': averagePropertyValue,
      'propertiesSold': propertiesSold,
      'revenueHistory': revenueHistory,
    };
  }
}

class EngagementMetrics {
  final double inquiryResponseRate;
  final double averageResponseTime;
  final double visitConversionRate;
  final int totalVisits;
  final int totalInquiries;
  final int convertedVisits;

  EngagementMetrics({
    required this.inquiryResponseRate,
    required this.averageResponseTime,
    required this.visitConversionRate,
    required this.totalVisits,
    required this.totalInquiries,
    required this.convertedVisits,
  });

  factory EngagementMetrics.fromJson(Map<String, dynamic> json) {
    return EngagementMetrics(
      inquiryResponseRate: (json['inquiryResponseRate'] ?? 0).toDouble(),
      averageResponseTime: (json['averageResponseTime'] ?? 0).toDouble(),
      visitConversionRate: (json['visitConversionRate'] ?? 0).toDouble(),
      totalVisits: json['totalVisits'] ?? 0,
      totalInquiries: json['totalInquiries'] ?? 0,
      convertedVisits: json['convertedVisits'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inquiryResponseRate': inquiryResponseRate,
      'averageResponseTime': averageResponseTime,
      'visitConversionRate': visitConversionRate,
      'totalVisits': totalVisits,
      'totalInquiries': totalInquiries,
      'convertedVisits': convertedVisits,
    };
  }
}
class SubscriptionInfo {
  final bool hasSubscription;
  final String? plan;
  final String? status;
  final String? startDate;
  final String? endDate;
  final bool isPremium;

  SubscriptionInfo({
    required this.hasSubscription,
    required this.plan,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.isPremium,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    dynamic planValue = json['plan'];
    dynamic statusValue = json['status'];
    dynamic startDateValue = json['startDate'];
    dynamic endDateValue = json['endDate'];

    return SubscriptionInfo(
      hasSubscription: json['hasSubscription'] ?? false,
      plan: planValue is Map ? planValue['name']?.toString() : planValue?.toString(),
      status: statusValue is Map ? statusValue['code']?.toString() : statusValue?.toString(),
      startDate: startDateValue?.toString(),
      endDate: endDateValue?.toString(),
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hasSubscription': hasSubscription,
      'plan': plan,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'isPremium': isPremium,
    };
  }
}

// class SubscriptionInfo {
//   final bool hasSubscription;
//   final String? plan;
//   final String? status;
//   final String? startDate;
//   final String? endDate;
//   final bool isPremium;
//
//   SubscriptionInfo({
//     required this.hasSubscription,
//     required this.plan,
//     required this.status,
//     required this.startDate,
//     required this.endDate,
//     required this.isPremium,
//   });
//
//   factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
//     return SubscriptionInfo(
//       hasSubscription: json['hasSubscription'] ?? false,
//       plan: json['plan'],
//       status: json['status'],
//       startDate: json['startDate'],
//       endDate: json['endDate'],
//       isPremium: json['isPremium'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'hasSubscription': hasSubscription,
//       'plan': plan,
//       'status': status,
//       'startDate': startDate,
//       'endDate': endDate,
//       'isPremium': isPremium,
//     };
//   }
// }
