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
  final String lastUpdated;

  SellerInsightsData({
    required this.propertyMetrics,
    required this.leadAnalytics,
    required this.financialMetrics,
    required this.engagementMetrics,
    required this.lastUpdated,
  });

  factory SellerInsightsData.fromJson(Map<String, dynamic> json) {
    return SellerInsightsData(
      propertyMetrics: PropertyMetrics.fromJson(json['propertyMetrics'] ?? {}),
      leadAnalytics: LeadAnalytics.fromJson(json['leadAnalytics'] ?? {}),
      financialMetrics: FinancialMetrics.fromJson(json['financialMetrics'] ?? {}),
      engagementMetrics: EngagementMetrics.fromJson(json['engagementMetrics'] ?? {}),
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyMetrics': propertyMetrics.toMap(),
      'leadAnalytics': leadAnalytics.toMap(),
      'financialMetrics': financialMetrics.toMap(),
      'engagementMetrics': engagementMetrics.toMap(),
      'lastUpdated': lastUpdated,
    };
  }
}

class PropertyMetrics {
  final int totalProperties;
  final int activeListings;
  final List<ViewHistory> viewsHistory;
  final Map<String, dynamic> statusDistribution;

  PropertyMetrics({
    required this.totalProperties,
    required this.activeListings,
    required this.viewsHistory,
    required this.statusDistribution,
  });

  factory PropertyMetrics.fromJson(Map<String, dynamic> json) {
    return PropertyMetrics(
      totalProperties: json['totalProperties'] ?? 0,
      activeListings: json['activeListings'] ?? 0,
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
      'viewsHistory': viewsHistory.map((e) => e.toMap()).toList(),
      'statusDistribution': statusDistribution,
    };
  }
}

class ViewHistory {
  final String month;
  final int views;

  ViewHistory({
    required this.month,
    required this.views,
  });

  factory ViewHistory.fromJson(Map<String, dynamic> json) {
    return ViewHistory(
      month: json['month'] ?? '',
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'views': views,
    };
  }
}

class LeadAnalytics {
  final int totalLeads;
  final Map<String, dynamic> sourceDistribution;
  final double conversionRate;
  final List<LeadsTimeline> leadsTimeline;

  LeadAnalytics({
    required this.totalLeads,
    required this.sourceDistribution,
    required this.conversionRate,
    required this.leadsTimeline,
  });

  factory LeadAnalytics.fromJson(Map<String, dynamic> json) {
    return LeadAnalytics(
      totalLeads: json['totalLeads'] ?? 0,
      sourceDistribution: json['sourceDistribution'] ?? {},
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
      'sourceDistribution': sourceDistribution,
      'conversionRate': conversionRate,
      'leadsTimeline': leadsTimeline.map((e) => e.toMap()).toList(),
    };
  }
}

class LeadsTimeline {
  final String month;
  final int count;

  LeadsTimeline({
    required this.month,
    required this.count,
  });

  factory LeadsTimeline.fromJson(Map<String, dynamic> json) {
    return LeadsTimeline(
      month: json['month'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'count': count,
    };
  }
}

class FinancialMetrics {
  final double totalRevenue;
  final double averagePropertyValue;
  final List<dynamic> revenueHistory;

  FinancialMetrics({
    required this.totalRevenue,
    required this.averagePropertyValue,
    required this.revenueHistory,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      averagePropertyValue: (json['averagePropertyValue'] ?? 0).toDouble(),
      revenueHistory: json['revenueHistory'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRevenue': totalRevenue,
      'averagePropertyValue': averagePropertyValue,
      'revenueHistory': revenueHistory,
    };
  }
}

class EngagementMetrics {
  final double inquiryResponseRate;
  final double averageResponseTime;
  final double visitConversionRate;
  final int totalVisits;
  final int convertedVisits;

  EngagementMetrics({
    required this.inquiryResponseRate,
    required this.averageResponseTime,
    required this.visitConversionRate,
    required this.totalVisits,
    required this.convertedVisits,
  });

  factory EngagementMetrics.fromJson(Map<String, dynamic> json) {
    return EngagementMetrics(
      inquiryResponseRate: (json['inquiryResponseRate'] ?? 0).toDouble(),
      averageResponseTime: (json['averageResponseTime'] ?? 0).toDouble(),
      visitConversionRate: (json['visitConversionRate'] ?? 0).toDouble(),
      totalVisits: json['totalVisits'] ?? 0,
      convertedVisits: json['convertedVisits'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inquiryResponseRate': inquiryResponseRate,
      'averageResponseTime': averageResponseTime,
      'visitConversionRate': visitConversionRate,
      'totalVisits': totalVisits,
      'convertedVisits': convertedVisits,
    };
  }
}
