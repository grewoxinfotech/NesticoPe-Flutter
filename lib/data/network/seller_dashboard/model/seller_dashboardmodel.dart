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

/*
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

*/
class SellerInsightsModel {
  final bool success;
  final String message;
  final SellerInsightsData? data;

  SellerInsightsModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SellerInsightsModel.fromJson(Map<String, dynamic> json) {
    return SellerInsightsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SellerInsightsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }
}

class SellerInsightsData {
  final PropertyMetrics? propertyMetrics;
  final LeadAnalytics? leadAnalytics;
  final FinancialMetrics? financialMetrics;
  final EngagementMetrics? engagementMetrics;
  final SubscriptionInfo? subscriptionInfo;
  final String? sellerType;
  final String? lastUpdated;

  SellerInsightsData({
    this.propertyMetrics,
    this.leadAnalytics,
    this.financialMetrics,
    this.engagementMetrics,
    this.subscriptionInfo,
    this.sellerType,
    this.lastUpdated,
  });

  factory SellerInsightsData.fromJson(Map<String, dynamic> json) {
    return SellerInsightsData(
      propertyMetrics: json['propertyMetrics'] != null
          ? PropertyMetrics.fromJson(json['propertyMetrics'])
          : null,
      leadAnalytics: json['leadAnalytics'] != null
          ? LeadAnalytics.fromJson(json['leadAnalytics'])
          : null,
      financialMetrics: json['financialMetrics'] != null
          ? FinancialMetrics.fromJson(json['financialMetrics'])
          : null,
      engagementMetrics: json['engagementMetrics'] != null
          ? EngagementMetrics.fromJson(json['engagementMetrics'])
          : null,
      subscriptionInfo: json['subscriptionInfo'] != null
          ? SubscriptionInfo.fromJson(json['subscriptionInfo'])
          : null,
      sellerType: json['sellerType'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyMetrics': propertyMetrics?.toMap(),
      'leadAnalytics': leadAnalytics?.toMap(),
      'financialMetrics': financialMetrics?.toMap(),
      'engagementMetrics': engagementMetrics?.toMap(),
      'subscriptionInfo': subscriptionInfo?.toMap(),
      'sellerType': sellerType,
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
  final List<PropertyTimeline> propertyTimeline;
  final Map<String, dynamic> statusDistribution;

  PropertyMetrics({
    required this.totalProperties,
    required this.activeListings,
    required this.pendingListings,
    required this.propertyTimeline,
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
      propertyTimeline: (json['propertyTimeline'] as List?)
          ?.map((e) => PropertyTimeline.fromJson(e))
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
      'propertyTimeline': propertyTimeline.map((e) => e.toMap()).toList(),
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

  Map<String, dynamic> toMap() => {'month': month, 'views': views};
}
class PropertyTimeline {
  final String month;
  final int count;

  PropertyTimeline({required this.month, required this.count});

  factory PropertyTimeline.fromJson(Map<String, dynamic> json) {
    return PropertyTimeline(
      month: json['month'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {'month': month, 'count': count};
}

class LeadAnalytics {
  final int totalLeads;
  final int currentMonthLeads;
  final int previousMonthLeads;
  final LeadStatusBreakdown statusBreakdown;
  final LeadSourceDistribution sourceDistribution;
  final LeadStageBreakdown stageBreakdown;
  final double conversionRate;
  final List<LeadsTimeline> leadsTimeline;

  LeadAnalytics({
    required this.totalLeads,
    required this.currentMonthLeads,
    required this.previousMonthLeads,
    required this.statusBreakdown,
    required this.sourceDistribution,
    required this.stageBreakdown,
    required this.conversionRate,
    required this.leadsTimeline,
  });

  factory LeadAnalytics.fromJson(Map<String, dynamic> json) {
    return LeadAnalytics(
      totalLeads: json['totalLeads'] ?? 0,
      currentMonthLeads: json['currentMonthLeads'] ?? 0,
      previousMonthLeads: json['previousMonthLeads'] ?? 0,
      statusBreakdown:
      LeadStatusBreakdown.fromJson(json['statusBreakdown'] ?? {}),
      sourceDistribution:
      LeadSourceDistribution.fromJson(json['sourceDistribution'] ?? {}),
      stageBreakdown:
      LeadStageBreakdown.fromJson(json['stageBreakdown'] ?? {}),
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      leadsTimeline: (json['leadsTimeline'] as List?)
          ?.map((e) => LeadsTimeline.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalLeads': totalLeads,
      'currentMonthLeads': currentMonthLeads,
      'previousMonthLeads': previousMonthLeads,
      'statusBreakdown': statusBreakdown.toMap(),
      'sourceDistribution': sourceDistribution.toMap(),
      'stageBreakdown': stageBreakdown.toMap(),
      'conversionRate': conversionRate,
      'leadsTimeline': leadsTimeline.map((e) => e.toMap()).toList(),
    };
  }
}

/// ----- Breakdown Models -----

class LeadStatusBreakdown {
  final int newLeads;
  final int contacted;
  final int qualified;
  final int negotiation;
  final int lost;
  final int converted;

  LeadStatusBreakdown({
    required this.newLeads,
    required this.contacted,
    required this.qualified,
    required this.negotiation,
    required this.lost,
    required this.converted,
  });

  factory LeadStatusBreakdown.fromJson(Map<String, dynamic> json) {
    return LeadStatusBreakdown(
      newLeads: json['new'] ?? 0,
      contacted: json['contacted'] ?? 0,
      qualified: json['qualified'] ?? 0,
      negotiation: json['negotiation'] ?? 0,
      lost: json['lost'] ?? 0,
      converted: json['converted'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'new': newLeads,
    'contacted': contacted,
    'qualified': qualified,
    'negotiation': negotiation,
    'lost': lost,
    'converted': converted,
  };
}

class LeadSourceDistribution {
  final int app;
  final int website;
  final int referral;
  final int socialMedia;
  final int direct;
  final int other;

  LeadSourceDistribution({
    required this.app,
    required this.website,
    required this.referral,
    required this.socialMedia,
    required this.direct,
    required this.other,
  });

  factory LeadSourceDistribution.fromJson(Map<String, dynamic> json) {
    return LeadSourceDistribution(
      app: json['app'] ?? 0,
      website: json['website'] ?? 0,
      referral: json['referral'] ?? 0,
      socialMedia: json['social_media'] ?? 0,
      direct: json['direct'] ?? 0,
      other: json['other'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'app': app,
    'website': website,
    'referral': referral,
    'social_media': socialMedia,
    'direct': direct,
    'other': other,
  };
}

class LeadStageBreakdown {
  final int newLead;
  final int contacted;
  final int interested;
  final int siteVisit;
  final int sell;

  LeadStageBreakdown({
    required this.newLead,
    required this.contacted,
    required this.interested,
    required this.siteVisit,
    required this.sell,
  });

  factory LeadStageBreakdown.fromJson(Map<String, dynamic> json) {
    return LeadStageBreakdown(
      newLead: json['new_lead'] ?? 0,
      contacted: json['contacted'] ?? 0,
      interested: json['interested'] ?? 0,
      siteVisit: json['site_visit'] ?? 0,
      sell: json['sell'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'new_lead': newLead,
    'contacted': contacted,
    'interested': interested,
    'site_visit': siteVisit,
    'sell': sell,
  };
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

  Map<String, dynamic> toMap() => {'month': month, 'count': count};
}

class FinancialMetrics {
  final double totalRevenue;
  final double currentMonthRevenue;
  final double previousMonthRevenue;
  final double averagePropertyValue;
  final int propertiesSold;
  final List<dynamic> revenueHistory;

  FinancialMetrics({
    required this.totalRevenue,
    required this.currentMonthRevenue,
    required this.previousMonthRevenue,
    required this.averagePropertyValue,
    required this.propertiesSold,
    required this.revenueHistory,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      currentMonthRevenue: (json['currentMonthRevenue'] ?? 0).toDouble(),
      previousMonthRevenue: (json['previousMonthRevenue'] ?? 0).toDouble(),
      averagePropertyValue: (json['averagePropertyValue'] ?? 0).toDouble(),
      propertiesSold: json['propertiesSold'] ?? 0,
      revenueHistory: json['revenueHistory'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRevenue': totalRevenue,
      'currentMonthRevenue': currentMonthRevenue,
      'previousMonthRevenue': previousMonthRevenue,
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
    this.plan,
    this.status,
    this.startDate,
    this.endDate,
    required this.isPremium,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      hasSubscription: json['hasSubscription'] ?? false,
      plan: json['plan']?.toString(),
      status: json['status']?.toString(),
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
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
