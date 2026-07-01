bool _asBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

class SubscriptionPlansResponse {
  final bool success;
  final String message;
  final SubscriptionData data;

  SubscriptionPlansResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: SubscriptionData.fromJson(json['data'] ?? {}),
    );
  }
}

class SubscriptionData {
  final List<SubscriptionPlan> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  SubscriptionData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => SubscriptionPlan.fromJson(e))
              .toList(),
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }
}

class SubscriptionPlan {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String name;
  final String type;
  final String plansFor;
  final String amount;
  final String originalPrice;
  final int durationMonths;
  final bool isPremium;
  final bool isActive;
  final PlanFeatures features;
  final String gstRate;
  final bool isRecommended;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.createdBy,
    required this.updatedBy,
    required this.name,
    required this.type,
    required this.plansFor,
    required this.amount,
    required this.originalPrice,
    required this.durationMonths,
    required this.isPremium,
    required this.isActive,
    required this.features,
    required this.gstRate,
    required this.isRecommended,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? "",
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      name: json['name'] ?? "",
      type: json['type'] ?? "",
      plansFor: json['plansFor'] ?? "",
      amount: json['amount'] ?? "",
      originalPrice: json['originalPrice'] ?? "",
      durationMonths: json['durationMonths'] ?? 0,
      isPremium: _asBool(json['isPremium']),
      isActive: _asBool(json['isActive']),
      features: PlanFeatures.fromJson(json['features'] ?? {}),
      gstRate: json['gstRate'] ?? "",
      isRecommended: _asBool(json['isRecommended']),
      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? "") ?? DateTime.now(),
    );
  }
}

class PlanFeatures {
  final dynamic maxProperties; // can be "unlimited" or int
  final dynamic maxService; // can be "unlimited" or int
  final dynamic maxLeads; // can be "unlimited" or int
  final dynamic maxUsers; // can be "unlimited" or int
  final dynamic maxProjects; // can be "unlimited" or int
  final String? commission;
  final dynamic analytics; // can be bool or String (depending on API)
  final dynamic support; // can be bool or String
  final bool? bulkListing;
  final String? clientManagement;
  final bool? verifiedBadge;
  final String? marketingTools;
  final bool? dedicatedSupport;
  final String? leadGeneration;
  final String? projectShowcase;

  final bool? exportData;
  final bool? advancedReports;
  final bool? customBranding;
  final bool? apiAccess;
  final bool? prioritySupport;
  final bool? dedicatedManager;

  PlanFeatures({
    this.maxProperties,
    this.maxService,
    this.maxLeads,
    this.maxUsers,
    this.maxProjects,
    this.commission,
    this.analytics,
    this.support,
    this.bulkListing,
    this.clientManagement,
    this.verifiedBadge,
    this.marketingTools,
    this.dedicatedSupport,
    this.leadGeneration,
    this.projectShowcase,
    this.exportData,
    this.advancedReports,
    this.customBranding,
    this.apiAccess,
    this.prioritySupport,
    this.dedicatedManager,
  });

  factory PlanFeatures.fromJson(Map<String, dynamic> json) {
    return PlanFeatures(
      maxProperties: json['maxProperties'],
      maxService: json['maxServices'],
      maxLeads: json['maxLeads'],
      maxUsers: json['maxUsers'],
      maxProjects: json['maxProjects'],
      commission: json['commission'],
      analytics: json['analytics'],
      support: json['support'],
      bulkListing: json['bulkListing'],
      clientManagement: json['clientManagement'],
      verifiedBadge: json['verifiedBadge'],
      marketingTools: json['marketingTools'],
      dedicatedSupport: json['dedicatedSupport'],
      leadGeneration: json['leadGeneration'],
      projectShowcase: json['projectShowcase'],
      exportData: json['exportData'],
      advancedReports: json['advancedReports'],
      customBranding: json['customBranding'],
      apiAccess: json['apiAccess'],
      prioritySupport: json['prioritySupport'],
      dedicatedManager: json['dedicatedManager'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxProperties': maxProperties,
      'maxServices': maxService,
      'maxLeads': maxLeads,
      'maxUsers': maxUsers,
      'maxProjects': maxProjects,
      'commission': commission,
      'analytics': analytics,
      'support': support,
      'bulkListing': bulkListing,
      'clientManagement': clientManagement,
      'verifiedBadge': verifiedBadge,
      'marketingTools': marketingTools,
      'dedicatedSupport': dedicatedSupport,
      'leadGeneration': leadGeneration,
      'projectShowcase': projectShowcase,
      'exportData': exportData,
      'advancedReports': advancedReports,
      'customBranding': customBranding,
      'apiAccess': apiAccess,
      'prioritySupport': prioritySupport,
      'dedicatedManager': dedicatedManager,
    };
  }
}

//
// class PlanFeatures {
//   final dynamic maxProperties; // can be "unlimited" or int
//   final String? commission;
//   final String? analytics;
//   final String? support;
//   final bool? bulkListing;
//   final String? clientManagement;
//   final bool? verifiedBadge;
//   final String? marketingTools;
//   final bool? dedicatedSupport;
//
//   PlanFeatures({
//     this.maxProperties,
//     this.commission,
//     this.analytics,
//     this.support,
//     this.bulkListing,
//     this.clientManagement,
//     this.verifiedBadge,
//     this.marketingTools,
//     this.dedicatedSupport,
//   });
//
//   factory PlanFeatures.fromJson(Map<String, dynamic> json) {
//     return PlanFeatures(
//       maxProperties: json['maxProperties'], // could be int or string
//       commission: json['commission'],
//       analytics: json['analytics'],
//       support: json['support'],
//       bulkListing: json['bulkListing'],
//       clientManagement: json['clientManagement'],
//       verifiedBadge: json['verifiedBadge'],
//       marketingTools: json['marketingTools'],
//       dedicatedSupport: json['dedicatedSupport'],
//     );
//   }
// }

class FeatureItem {
  final String name;
  final bool isIncluded;

  FeatureItem({required this.name, required this.isIncluded});
}

const Map<String, String> featureLabels = {
  'maxProperties': 'Max Properties',
  'maxServices': 'Max Services',
  'maxLeads': 'Max Leads',
  'maxUsers': 'Max Users',
  'maxProjects': 'Max Projects',
  'commission': 'Commission',
  'analytics': 'Analytics',
  'support': 'Support',
  'bulkListing': 'Bulk Listing',
  'clientManagement': 'Client Management',
  'verifiedBadge': 'Verified Badge',
  'marketingTools': 'Marketing Tools',
  'dedicatedSupport': 'Dedicated Support',
  'exportData': 'Export Data',
  'advancedReports': 'Advanced Reports',
  'customBranding': 'Custom Branding',
  'apiAccess': 'API Access',
  'prioritySupport': 'Priority Support',
  'dedicatedManager': 'Dedicated Manager',
  'profileListing': 'Profile Listing',
  'projectGallery': 'Project Gallery',
  'projectShowcase': 'Project Showcase',
  'leadGeneration': 'Lead Generation',
  // 'leadGeneration': 'Lead Generation',
};

extension PlanFeaturesMap on PlanFeatures {
  Map<String, dynamic> asMap() {
    return {
      'maxProperties': maxProperties,
      'maxServices': maxService,
      'maxLeads': maxLeads,
      'maxUsers': maxUsers,
      'maxProjects': maxProjects,
      'commission': commission,
      'analytics': analytics,
      'support': support,
      'bulkListing': bulkListing,
      'clientManagement': clientManagement,
      'verifiedBadge': verifiedBadge,
      'marketingTools': marketingTools,
      'dedicatedSupport': dedicatedSupport,
      'leadGeneration': leadGeneration,
      'projectShowcase': projectShowcase,
      'exportData': exportData,
      'advancedReports': advancedReports,
      'customBranding': customBranding,
      'apiAccess': apiAccess,
      'prioritySupport': prioritySupport,
      'dedicatedManager': dedicatedManager,
    }..removeWhere((_, value) => value == null);
  }
}

extension PlanFeaturesMapper on PlanFeatures {
  List<FeatureItem> toFeatureList() {
    final features = asMap();

    return features.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;

      final label = featureLabels[key] ?? key;

      // Boolean features
      if (value is bool) {
        return FeatureItem(name: label, isIncluded: value);
      }

      // Numeric / String / unlimited features
      return FeatureItem(name: "$label: ${value==0?"Unlimited":'$value'}", isIncluded: true);
    }).toList();
  }
}
