class SellerOverviewModel {
  final bool success;
  final String message;
  final OverviewData? data;

  SellerOverviewModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SellerOverviewModel.fromJson(Map<String, dynamic> json) {
    return SellerOverviewModel(
      success: json['story'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OverviewData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'story': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class OverviewData {
  final PropertyMetrics? propertyMetrics;
  final LeadAnalytics? leadAnalytics;
  final FinancialMetrics? financialMetrics;
  final EngagementMetrics? engagementMetrics;
  final String? lastUpdated;

  OverviewData({
    this.propertyMetrics,
    this.leadAnalytics,
    this.financialMetrics,
    this.engagementMetrics,
    this.lastUpdated,
  });

  factory OverviewData.fromJson(Map<String, dynamic> json) {
    return OverviewData(
      propertyMetrics:
          json['propertyMetrics'] != null
              ? PropertyMetrics.fromJson(json['propertyMetrics'])
              : null,
      leadAnalytics:
          json['leadAnalytics'] != null
              ? LeadAnalytics.fromJson(json['leadAnalytics'])
              : null,
      financialMetrics:
          json['financialMetrics'] != null
              ? FinancialMetrics.fromJson(json['financialMetrics'])
              : null,
      engagementMetrics:
          json['engagementMetrics'] != null
              ? EngagementMetrics.fromJson(json['engagementMetrics'])
              : null,
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() => {
    'propertyMetrics': propertyMetrics?.toJson(),
    'leadAnalytics': leadAnalytics?.toJson(),
    'financialMetrics': financialMetrics?.toJson(),
    'engagementMetrics': engagementMetrics?.toJson(),
    'lastUpdated': lastUpdated,
  };
}

class PropertyMetrics {
  final int activeListings;
  final List<ViewsHistory> viewsHistory;
  final Map<String, int> statusDistribution;

  PropertyMetrics({
    required this.activeListings,
    required this.viewsHistory,
    required this.statusDistribution,
  });

  factory PropertyMetrics.fromJson(Map<String, dynamic> json) {
    return PropertyMetrics(
      activeListings: json['activeListings'] ?? 0,
      viewsHistory:
          (json['viewsHistory'] as List<dynamic>?)
              ?.map((e) => ViewsHistory.fromJson(e))
              .toList() ??
          [],
      statusDistribution: Map<String, int>.from(
        json['statusDistribution'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'activeListings': activeListings,
    'viewsHistory': viewsHistory.map((e) => e.toJson()).toList(),
    'statusDistribution': statusDistribution,
  };
}

class ViewsHistory {
  final String date;
  final int views;

  ViewsHistory({required this.date, required this.views});

  factory ViewsHistory.fromJson(Map<String, dynamic> json) =>
      ViewsHistory(date: json['date'] ?? '', views: json['views'] ?? 0);

  Map<String, dynamic> toJson() => {'date': date, 'views': views};
}

class LeadAnalytics {
  final int totalLeads;
  final Map<String, int> sourceDistribution;
  final num conversionRate;
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
      sourceDistribution: Map<String, int>.from(
        json['sourceDistribution'] ?? {},
      ),
      conversionRate: json['conversionRate'] ?? 0,
      leadsTimeline:
          (json['leadsTimeline'] as List<dynamic>?)
              ?.map((e) => LeadsTimeline.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalLeads': totalLeads,
    'sourceDistribution': sourceDistribution,
    'conversionRate': conversionRate,
    'leadsTimeline': leadsTimeline.map((e) => e.toJson()).toList(),
  };
}

class LeadsTimeline {
  final String date;
  final int count;

  LeadsTimeline({required this.date, required this.count});

  factory LeadsTimeline.fromJson(Map<String, dynamic> json) =>
      LeadsTimeline(date: json['date'] ?? '', count: json['count'] ?? 0);

  Map<String, dynamic> toJson() => {'date': date, 'count': count};
}

class FinancialMetrics {
  final num totalRevenue;
  final num averagePropertyValue;
  final List<RevenueHistory> revenueHistory;

  FinancialMetrics({
    required this.totalRevenue,
    required this.averagePropertyValue,
    required this.revenueHistory,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalRevenue: json['totalRevenue'] ?? 0,
      averagePropertyValue: json['averagePropertyValue'] ?? 0,
      revenueHistory:
          (json['revenueHistory'] as List<dynamic>?)
              ?.map((e) => RevenueHistory.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalRevenue': totalRevenue,
    'averagePropertyValue': averagePropertyValue,
    'revenueHistory': revenueHistory.map((e) => e.toJson()).toList(),
  };
}

class RevenueHistory {
  final String month;
  final num revenue;

  RevenueHistory({required this.month, required this.revenue});

  factory RevenueHistory.fromJson(Map<String, dynamic> json) =>
      RevenueHistory(month: json['month'] ?? '', revenue: json['revenue'] ?? 0);

  Map<String, dynamic> toJson() => {'month': month, 'revenue': revenue};
}

class EngagementMetrics {
  final num inquiryResponseRate;
  final num averageResponseTime;
  final num visitConversionRate;
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
      inquiryResponseRate: json['inquiryResponseRate'] ?? 0,
      averageResponseTime: json['averageResponseTime'] ?? 0,
      visitConversionRate: json['visitConversionRate'] ?? 0,
      totalVisits: json['totalVisits'] ?? 0,
      convertedVisits: json['convertedVisits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'inquiryResponseRate': inquiryResponseRate,
    'averageResponseTime': averageResponseTime,
    'visitConversionRate': visitConversionRate,
    'totalVisits': totalVisits,
    'convertedVisits': convertedVisits,
  };
}
