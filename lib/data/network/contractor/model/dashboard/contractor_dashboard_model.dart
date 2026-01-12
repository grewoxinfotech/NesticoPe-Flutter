// class ContractorInsightsModel {
//   final bool success;
//   final String message;
//   final ContractorData? data;
//
//   ContractorInsightsModel({
//     required this.success,
//     required this.message,
//     this.data,
//   });
//
//   factory ContractorInsightsModel.fromJson(Map<String, dynamic> json) {
//     return ContractorInsightsModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null ? ContractorData.fromJson(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toMap(),
//     };
//   }
// }
//
// class ContractorData {
//   final String contractorId;
//   final ContractorPerformance performance;
//   final ContractorServices services;
//   final ContractorReviews reviews;
//   final List<ContractorInquiriesTrend> inquiriesTrend;
//   final List<ContractorLeadsTrend> leadsTrend;
//   final String lastUpdated;
//
//   ContractorData({
//     required this.contractorId,
//     required this.performance,
//     required this.services,
//     required this.reviews,
//     required this.inquiriesTrend,
//     required this.leadsTrend,
//     required this.lastUpdated,
//   });
//
//   factory ContractorData.fromJson(Map<String, dynamic> json) {
//     return ContractorData(
//       contractorId: json['contractorId'] ?? '',
//       performance: ContractorPerformance.fromJson(json['performance'] ?? {}),
//       services: ContractorServices.fromJson(json['services'] ?? {}),
//       reviews: ContractorReviews.fromJson(json['reviews'] ?? {}),
//       inquiriesTrend: (json['inquiriesTrend'] as List<dynamic>? ?? [])
//           .map((e) => ContractorInquiriesTrend.fromJson(e))
//           .toList(),
//       leadsTrend: (json['leadsTrend'] as List<dynamic>? ?? [])
//           .map((e) => ContractorLeadsTrend.fromJson(e))
//           .toList(),
//       lastUpdated: json['lastUpdated'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'contractorId': contractorId,
//       'performance': performance.toMap(),
//       'services': services.toMap(),
//       'reviews': reviews.toMap(),
//       'inquiriesTrend': inquiriesTrend.map((e) => e.toMap()).toList(),
//       'leadsTrend': leadsTrend.map((e) => e.toMap()).toList(),
//       'lastUpdated': lastUpdated,
//     };
//   }
// }
//
// class ContractorPerformance {
//   final int totalServices;
//   final int activeServices;
//   final int inactiveServices;
//   final int totalInquiries;
//   final int totalLeads;
//   final double conversionRate;
//   final double overallRating;
//   final int totalReviews;
//   final int warningCount;
//   final bool isBlocked;
//   final int currentMonthInquiries;
//   final int previousMonthInquiries;
//   final int currentMonthLeads;
//   final int previousMonthLeads;
//
//   ContractorPerformance({
//     required this.totalServices,
//     required this.activeServices,
//     required this.inactiveServices,
//     required this.totalInquiries,
//     required this.totalLeads,
//     required this.conversionRate,
//     required this.overallRating,
//     required this.totalReviews,
//     required this.warningCount,
//     required this.isBlocked,
//     required this.currentMonthInquiries,
//     required this.previousMonthInquiries,
//     required this.currentMonthLeads,
//     required this.previousMonthLeads,
//   });
//
//   factory ContractorPerformance.fromJson(Map<String, dynamic> json) {
//     return ContractorPerformance(
//       totalServices: json['totalServices'] ?? 0,
//       activeServices: json['activeServices'] ?? 0,
//       inactiveServices: json['inactiveServices'] ?? 0,
//       totalInquiries: json['totalInquiries'] ?? 0,
//       totalLeads: json['totalLeads'] ?? 0,
//       conversionRate: (json['conversionRate'] ?? 0).toDouble(),
//       overallRating: (json['overallRating'] ?? 0).toDouble(),
//       totalReviews: json['totalReviews'] ?? 0,
//       warningCount: json['warningCount'] ?? 0,
//       isBlocked: json['isBlocked'] ?? false,
//       currentMonthInquiries: json['currentMonthInquiries'] ?? 0,
//       previousMonthInquiries: json['previousMonthInquiries'] ?? 0,
//       currentMonthLeads: json['currentMonthLeads'] ?? 0,
//       previousMonthLeads: json['previousMonthLeads'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalServices': totalServices,
//       'activeServices': activeServices,
//       'inactiveServices': inactiveServices,
//       'totalInquiries': totalInquiries,
//       'totalLeads': totalLeads,
//       'conversionRate': conversionRate,
//       'overallRating': overallRating,
//       'totalReviews': totalReviews,
//       'warningCount': warningCount,
//       'isBlocked': isBlocked,
//       'currentMonthInquiries': currentMonthInquiries,
//       'previousMonthInquiries': previousMonthInquiries,
//       'currentMonthLeads': currentMonthLeads,
//       'previousMonthLeads': previousMonthLeads,
//     };
//   }
// }
//
// class ContractorServices {
//   final List<ContractorTopService> topRatedServices;
//   final Map<String, int> ratingsDistribution;
//
//   ContractorServices({
//     required this.topRatedServices,
//     required this.ratingsDistribution,
//   });
//
//   factory ContractorServices.fromJson(Map<String, dynamic> json) {
//     return ContractorServices(
//       topRatedServices: (json['topRatedServices'] as List<dynamic>? ?? [])
//           .map((e) => ContractorTopService.fromJson(e))
//           .toList(),
//       ratingsDistribution:
//       Map<String, int>.from(json['ratingsDistribution'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'topRatedServices': topRatedServices.map((e) => e.toMap()).toList(),
//       'ratingsDistribution': ratingsDistribution,
//     };
//   }
// }
//
// class ContractorTopService {
//   final String id;
//   final String serviceName;
//   final String category;
//   final String description;
//   final int totalReviews;
//   final double averageRating;
//   final int warningCount;
//   final bool isActive;
//   final bool isBlocked;
//   final String createdAt;
//
//   ContractorTopService({
//     required this.id,
//     required this.serviceName,
//     required this.category,
//     required this.description,
//     required this.totalReviews,
//     required this.averageRating,
//     required this.warningCount,
//     required this.isActive,
//     required this.isBlocked,
//     required this.createdAt,
//   });
//
//   factory ContractorTopService.fromJson(Map<String, dynamic> json) {
//     return ContractorTopService(
//       id: json['id'] ?? '',
//       serviceName: json['serviceName'] ?? '',
//       category: json['category'] ?? '',
//       description: json['description'] ?? '',
//       totalReviews: json['totalReviews'] ?? 0,
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//       warningCount: json['warningCount'] ?? 0,
//       isActive: json['isActive'] ?? false,
//       isBlocked: json['isBlocked'] ?? false,
//       createdAt: json['createdAt'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'serviceName': serviceName,
//       'category': category,
//       'description': description,
//       'totalReviews': totalReviews,
//       'averageRating': averageRating,
//       'warningCount': warningCount,
//       'isActive': isActive,
//       'isBlocked': isBlocked,
//       'createdAt': createdAt,
//     };
//   }
// }
//
// class ContractorReviews {
//   final int totalReviews;
//   final List<ContractorReview> recentReviews;
//   final Map<String, int> ratingBreakdown;
//   final double averageRating;
//
//   ContractorReviews({
//     required this.totalReviews,
//     required this.recentReviews,
//     required this.ratingBreakdown,
//     required this.averageRating,
//   });
//
//   factory ContractorReviews.fromJson(Map<String, dynamic> json) {
//     return ContractorReviews(
//       totalReviews: json['totalReviews'] ?? 0,
//       recentReviews: (json['recentReviews'] as List<dynamic>? ?? [])
//           .map((e) => ContractorReview.fromJson(e))
//           .toList(),
//       ratingBreakdown: Map<String, int>.from(json['ratingBreakdown'] ?? {}),
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalReviews': totalReviews,
//       'recentReviews': recentReviews.map((e) => e.toMap()).toList(),
//       'ratingBreakdown': ratingBreakdown,
//       'averageRating': averageRating,
//     };
//   }
// }
//
// class ContractorReview {
//   final String id;
//   final double rating;
//   final String? title;
//   final String content;
//   final String reviewerName;
//   final String? reviewerProfilePic;
//   final String createdAt;
//
//   ContractorReview({
//     required this.id,
//     required this.rating,
//     this.title,
//     required this.content,
//     required this.reviewerName,
//     this.reviewerProfilePic,
//     required this.createdAt,
//   });
//
//   factory ContractorReview.fromJson(Map<String, dynamic> json) {
//     return ContractorReview(
//       id: json['id'] ?? '',
//       rating: (json['rating'] ?? 0).toDouble(),
//       title: json['title'],
//       content: json['content'] ?? '',
//       reviewerName: json['reviewerName'] ?? '',
//       reviewerProfilePic: json['reviewerProfilePic'],
//       createdAt: json['createdAt'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'rating': rating,
//       'title': title,
//       'content': content,
//       'reviewerName': reviewerName,
//       'reviewerProfilePic': reviewerProfilePic,
//       'createdAt': createdAt,
//     };
//   }
// }
//
// class ContractorInquiriesTrend {
//   final String month;
//   final int inquiries;
//
//   ContractorInquiriesTrend({
//     required this.month,
//     required this.inquiries,
//   });
//
//   factory ContractorInquiriesTrend.fromJson(Map<String, dynamic> json) {
//     return ContractorInquiriesTrend(
//       month: json['month'] ?? '',
//       inquiries: json['inquiries'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'month': month,
//       'inquiries': inquiries,
//     };
//   }
// }
//
// class ContractorLeadsTrend {
//   final String month;
//   final int leads;
//
//   ContractorLeadsTrend({
//     required this.month,
//     required this.leads,
//   });
//
//   factory ContractorLeadsTrend.fromJson(Map<String, dynamic> json) {
//     return ContractorLeadsTrend(
//       month: json['month'] ?? '',
//       leads: json['leads'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'month': month,
//       'leads': leads,
//     };
//   }
// }
// class ContractorInsightsModel {
//   final bool success;
//   final String message;
//   final ContractorData? data;
//
//   ContractorInsightsModel({
//     required this.success,
//     required this.message,
//     this.data,
//   });
//
//   factory ContractorInsightsModel.fromJson(Map<String, dynamic> json) {
//     return ContractorInsightsModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null ? ContractorData.fromJson(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toMap(),
//     };
//   }
// }
//
// class ContractorData {
//   final String contractorId;
//   final ContractorPerformance? performance;
//   final ContractorServices? services;
//   final ContractorReviews? reviews;
//   final List<ContractorInquiriesTrend> inquiriesTrend;
//   final List<ContractorLeadsTrend> leadsTrend;
//   final List<ContractorProjectsTrend> projectsTrend;
//   final String? lastUpdated;
//
//   ContractorData({
//     required this.contractorId,
//     this.performance,
//     this.services,
//     this.reviews,
//     required this.inquiriesTrend,
//     required this.leadsTrend,
//     required this.projectsTrend,
//     this.lastUpdated,
//   });
//
//   factory ContractorData.fromJson(Map<String, dynamic> json) {
//     return ContractorData(
//       contractorId: json['contractorId'] ?? '',
//       performance: json['performance'] != null
//           ? ContractorPerformance.fromJson(json['performance'])
//           : null,
//       services: json['services'] != null
//           ? ContractorServices.fromJson(json['services'])
//           : null,
//       reviews: json['reviews'] != null
//           ? ContractorReviews.fromJson(json['reviews'])
//           : null,
//       inquiriesTrend: (json['inquiriesTrend'] as List<dynamic>? ?? [])
//           .map((e) => ContractorInquiriesTrend.fromJson(e))
//           .toList(),
//       leadsTrend: (json['leadsTrend'] as List<dynamic>? ?? [])
//           .map((e) => ContractorLeadsTrend.fromJson(e))
//           .toList(),
//       projectsTrend: (json['projectsTrend'] as List<dynamic>? ?? [])
//           .map((e) => ContractorProjectsTrend.fromJson(e))
//           .toList(),
//       lastUpdated: json['lastUpdated'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'contractorId': contractorId,
//       'performance': performance?.toMap(),
//       'services': services?.toMap(),
//       'reviews': reviews?.toMap(),
//       'inquiriesTrend': inquiriesTrend.map((e) => e.toMap()).toList(),
//       'leadsTrend': leadsTrend.map((e) => e.toMap()).toList(),
//       'projectsTrend': projectsTrend.map((e) => e.toMap()).toList(),
//       'lastUpdated': lastUpdated,
//     };
//   }
// }
//
// class ContractorPerformance {
//   final int totalServices;
//   final int activeServices;
//   final int inactiveServices;
//   final int totalInquiries;
//   final int totalLeads;
//   final int totalProjects;
//   final int activeProjects;
//   final int completedProjects;
//   final double conversionRate;
//   final double overallRating;
//   final int totalReviews;
//   final int warningCount;
//   final bool isBlocked;
//   final int currentMonthInquiries;
//   final int previousMonthInquiries;
//   final int currentMonthLeads;
//   final Map<String, dynamic> stageBreakdown;
//   final int previousMonthLeads;
//
//   ContractorPerformance({
//     required this.totalServices,
//     required this.activeServices,
//     required this.inactiveServices,
//     required this.totalInquiries,
//     required this.totalLeads,
//     required this.totalProjects,
//     required this.activeProjects,
//     required this.stageBreakdown,
//     required this.completedProjects,
//     required this.conversionRate,
//     required this.overallRating,
//     required this.totalReviews,
//     required this.warningCount,
//     required this.isBlocked,
//     required this.currentMonthInquiries,
//     required this.previousMonthInquiries,
//     required this.currentMonthLeads,
//     required this.previousMonthLeads,
//   });
//
//   factory ContractorPerformance.fromJson(Map<String, dynamic> json) {
//     return ContractorPerformance(
//       totalServices: json['totalServices'] ?? 0,
//       activeServices: json['activeServices'] ?? 0,
//       inactiveServices: json['inactiveServices'] ?? 0,
//       totalInquiries: json['totalInquiries'] ?? 0,
//       totalLeads: json['totalLeads'] ?? 0,
//       totalProjects: json['totalProjects'] ?? 0,
//       stageBreakdown: json['leadStageBreakdown'] ?? {},
//       activeProjects: json['activeProjects'] ?? 0,
//       completedProjects: json['completedProjects'] ?? 0,
//       conversionRate: (json['conversionRate'] ?? 0).toDouble(),
//       overallRating: (json['overallRating'] ?? 0).toDouble(),
//       totalReviews: json['totalReviews'] ?? 0,
//       warningCount: json['warningCount'] ?? 0,
//       isBlocked: json['isBlocked'] ?? false,
//       currentMonthInquiries: json['currentMonthInquiries'] ?? 0,
//       previousMonthInquiries: json['previousMonthInquiries'] ?? 0,
//       currentMonthLeads: json['currentMonthLeads'] ?? 0,
//       previousMonthLeads: json['previousMonthLeads'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalServices': totalServices,
//       'activeServices': activeServices,
//       'inactiveServices': inactiveServices,
//       'totalInquiries': totalInquiries,
//       'totalLeads': totalLeads,
//       'totalProjects': totalProjects,
//       'activeProjects': activeProjects,
//       'leadStageBreakdown': stageBreakdown,
//       'completedProjects': completedProjects,
//       'conversionRate': conversionRate,
//       'overallRating': overallRating,
//       'totalReviews': totalReviews,
//       'warningCount': warningCount,
//       'isBlocked': isBlocked,
//       'currentMonthInquiries': currentMonthInquiries,
//       'previousMonthInquiries': previousMonthInquiries,
//       'currentMonthLeads': currentMonthLeads,
//       'previousMonthLeads': previousMonthLeads,
//     };
//   }
// }
//
// class ContractorServices {
//   final List<ContractorTopService> topRatedServices;
//   final Map<String, int> ratingsDistribution;
//
//   ContractorServices({
//     required this.topRatedServices,
//     required this.ratingsDistribution,
//   });
//
//   factory ContractorServices.fromJson(Map<String, dynamic> json) {
//     return ContractorServices(
//       topRatedServices: (json['topRatedServices'] as List<dynamic>? ?? [])
//           .map((e) => ContractorTopService.fromJson(e))
//           .toList(),
//       ratingsDistribution:
//       Map<String, int>.from(json['ratingsDistribution'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'topRatedServices': topRatedServices.map((e) => e.toMap()).toList(),
//       'ratingsDistribution': ratingsDistribution,
//     };
//   }
// }
//
// class ContractorTopService {
//   final String id;
//   final String serviceName;
//   final String category;
//   final String description;
//   final int totalReviews;
//   final double averageRating;
//   final int warningCount;
//   final bool isActive;
//   final bool isBlocked;
//   final String? createdAt;
//
//   ContractorTopService({
//     required this.id,
//     required this.serviceName,
//     required this.category,
//     required this.description,
//     required this.totalReviews,
//     required this.averageRating,
//     required this.warningCount,
//     required this.isActive,
//     required this.isBlocked,
//     this.createdAt,
//   });
//
//   factory ContractorTopService.fromJson(Map<String, dynamic> json) {
//     return ContractorTopService(
//       id: json['id'] ?? '',
//       serviceName: json['serviceName'] ?? '',
//       category: json['category'] ?? '',
//       description: json['description'] ?? '',
//       totalReviews: json['totalReviews'] ?? 0,
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//       warningCount: json['warningCount'] ?? 0,
//       isActive: json['isActive'] ?? false,
//       isBlocked: json['isBlocked'] ?? false,
//       createdAt: json['createdAt'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'serviceName': serviceName,
//       'category': category,
//       'description': description,
//       'totalReviews': totalReviews,
//       'averageRating': averageRating,
//       'warningCount': warningCount,
//       'isActive': isActive,
//       'isBlocked': isBlocked,
//       'createdAt': createdAt,
//     };
//   }
// }
//
// class ContractorReviews {
//   final int totalReviews;
//   final List<ContractorReview> recentReviews;
//   final Map<String, int> ratingBreakdown;
//   final double averageRating;
//
//   ContractorReviews({
//     required this.totalReviews,
//     required this.recentReviews,
//     required this.ratingBreakdown,
//     required this.averageRating,
//   });
//
//   factory ContractorReviews.fromJson(Map<String, dynamic> json) {
//     return ContractorReviews(
//       totalReviews: json['totalReviews'] ?? 0,
//       recentReviews: (json['recentReviews'] as List<dynamic>? ?? [])
//           .map((e) => ContractorReview.fromJson(e))
//           .toList(),
//       ratingBreakdown: Map<String, int>.from(json['ratingBreakdown'] ?? {}),
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'totalReviews': totalReviews,
//       'recentReviews': recentReviews.map((e) => e.toMap()).toList(),
//       'ratingBreakdown': ratingBreakdown,
//       'averageRating': averageRating,
//     };
//   }
// }
//
// class ContractorReview {
//   final String id;
//   final double rating;
//   final String? title;
//   final String content;
//   final String reviewerName;
//   final String? reviewerProfilePic;
//   final String? createdAt;
//
//   ContractorReview({
//     required this.id,
//     required this.rating,
//     this.title,
//     required this.content,
//     required this.reviewerName,
//     this.reviewerProfilePic,
//     this.createdAt,
//   });
//
//   factory ContractorReview.fromJson(Map<String, dynamic> json) {
//     return ContractorReview(
//       id: json['id'] ?? '',
//       rating: (json['rating'] ?? 0).toDouble(),
//       title: json['title'],
//       content: json['content'] ?? '',
//       reviewerName: json['reviewerName'] ?? '',
//       reviewerProfilePic: json['reviewerProfilePic'],
//       createdAt: json['createdAt'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'rating': rating,
//       'title': title,
//       'content': content,
//       'reviewerName': reviewerName,
//       'reviewerProfilePic': reviewerProfilePic,
//       'createdAt': createdAt,
//     };
//   }
// }
//
// class ContractorInquiriesTrend {
//   final String month;
//   final int inquiries;
//
//   ContractorInquiriesTrend({
//     required this.month,
//     required this.inquiries,
//   });
//
//   factory ContractorInquiriesTrend.fromJson(Map<String, dynamic> json) {
//     return ContractorInquiriesTrend(
//       month: json['month'] ?? '',
//       inquiries: json['inquiries'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'month': month,
//       'inquiries': inquiries,
//     };
//   }
// }
//
// class ContractorLeadsTrend {
//   final String month;
//   final int leads;
//
//   ContractorLeadsTrend({
//     required this.month,
//     required this.leads,
//   });
//
//   factory ContractorLeadsTrend.fromJson(Map<String, dynamic> json) {
//     return ContractorLeadsTrend(
//       month: json['month'] ?? '',
//       leads: json['leads'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'month': month,
//       'leads': leads,
//     };
//   }
// }
//
// class ContractorProjectsTrend {
//   final String month;
//   final int projects;
//
//   ContractorProjectsTrend({
//     required this.month,
//     required this.projects,
//   });
//
//   factory ContractorProjectsTrend.fromJson(Map<String, dynamic> json) {
//     return ContractorProjectsTrend(
//       month: json['month'] ?? '',
//       projects: json['projects'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'month': month,
//       'projects': projects,
//     };
//   }
// }
/*class ContractorInsightsModel {
  final bool success;
  final String message;
  final ContractorData? data;

  ContractorInsightsModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ContractorInsightsModel.fromJson(Map<String, dynamic> json) {
    return ContractorInsightsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ContractorData.fromJson(json['data']) : null,
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

class ContractorData {
  final String contractorId;
  final ContractorPerformance? performance;
  final ContractorServices? services;
  final ContractorReviews? reviews;
  final List<ContractorInquiriesTrend> inquiriesTrend;
  final List<ContractorLeadsTrend> leadsTrend;
  final List<ContractorProjectsTrend> projectsTrend;
  final String? lastUpdated;

  ContractorData({
    required this.contractorId,
    this.performance,
    this.services,
    this.reviews,
    required this.inquiriesTrend,
    required this.leadsTrend,
    required this.projectsTrend,
    this.lastUpdated,
  });

  factory ContractorData.fromJson(Map<String, dynamic> json) {
    return ContractorData(
      contractorId: json['contractorId'] ?? '',
      performance: json['performance'] != null
          ? ContractorPerformance.fromJson(json['performance'])
          : null,
      services: json['services'] != null
          ? ContractorServices.fromJson(json['services'])
          : null,
      reviews: json['reviews'] != null
          ? ContractorReviews.fromJson(json['reviews'])
          : null,
      inquiriesTrend: (json['inquiriesTrend'] as List<dynamic>? ?? [])
          .map((e) => ContractorInquiriesTrend.fromJson(e))
          .toList(),
      leadsTrend: (json['leadsTrend'] as List<dynamic>? ?? [])
          .map((e) => ContractorLeadsTrend.fromJson(e))
          .toList(),
      projectsTrend: (json['projectsTrend'] as List<dynamic>? ?? [])
          .map((e) => ContractorProjectsTrend.fromJson(e))
          .toList(),
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contractorId': contractorId,
      'performance': performance?.toMap(),
      'services': services?.toMap(),
      'reviews': reviews?.toMap(),
      'inquiriesTrend': inquiriesTrend.map((e) => e.toMap()).toList(),
      'leadsTrend': leadsTrend.map((e) => e.toMap()).toList(),
      'projectsTrend': projectsTrend.map((e) => e.toMap()).toList(),
      'lastUpdated': lastUpdated,
    };
  }
}

class ContractorPerformance {
  final int totalServices;
  final int activeServices;
  final int inactiveServices;
  final int totalInquiries;
  final int totalLeads;
  final int totalProjects;
  final int activeProjects;
  final int completedProjects;
  final double conversionRate;
  final double overallRating;
  final int totalReviews;
  final int warningCount;
  final bool isBlocked;
  final int currentMonthInquiries;
  final int previousMonthInquiries;
  final int currentMonthLeads;
  final int previousMonthLeads;
  final Map<String, dynamic> inquiryStatusBreakdown;
  final ContractorLeadAnalytics? leadAnalytics;

  ContractorPerformance({
    required this.totalServices,
    required this.activeServices,
    required this.inactiveServices,
    required this.totalInquiries,
    required this.totalLeads,
    required this.totalProjects,
    required this.activeProjects,
    required this.completedProjects,
    required this.conversionRate,
    required this.overallRating,
    required this.totalReviews,
    required this.warningCount,
    required this.isBlocked,
    required this.currentMonthInquiries,
    required this.previousMonthInquiries,
    required this.currentMonthLeads,
    required this.previousMonthLeads,
    required this.inquiryStatusBreakdown,
    this.leadAnalytics,
  });

  factory ContractorPerformance.fromJson(Map<String, dynamic> json) {
    return ContractorPerformance(
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      inactiveServices: json['inactiveServices'] ?? 0,
      totalInquiries: json['totalInquiries'] ?? 0,
      totalLeads: json['totalLeads'] ?? 0,
      totalProjects: json['totalProjects'] ?? 0,
      activeProjects: json['activeProjects'] ?? 0,
      completedProjects: json['completedProjects'] ?? 0,
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      overallRating: (json['overallRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      warningCount: json['warningCount'] ?? 0,
      isBlocked: json['isBlocked'] ?? false,
      currentMonthInquiries: json['currentMonthInquiries'] ?? 0,
      previousMonthInquiries: json['previousMonthInquiries'] ?? 0,
      currentMonthLeads: json['currentMonthLeads'] ?? 0,
      previousMonthLeads: json['previousMonthLeads'] ?? 0,
      inquiryStatusBreakdown:
      Map<String, dynamic>.from(json['inquiryStatusBreakdown'] ?? {}),
      leadAnalytics: json['leadAnalytics'] != null
          ? ContractorLeadAnalytics.fromJson(json['leadAnalytics'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalServices': totalServices,
      'activeServices': activeServices,
      'inactiveServices': inactiveServices,
      'totalInquiries': totalInquiries,
      'totalLeads': totalLeads,
      'totalProjects': totalProjects,
      'activeProjects': activeProjects,
      'completedProjects': completedProjects,
      'conversionRate': conversionRate,
      'overallRating': overallRating,
      'totalReviews': totalReviews,
      'warningCount': warningCount,
      'isBlocked': isBlocked,
      'currentMonthInquiries': currentMonthInquiries,
      'previousMonthInquiries': previousMonthInquiries,
      'currentMonthLeads': currentMonthLeads,
      'previousMonthLeads': previousMonthLeads,
      'inquiryStatusBreakdown': inquiryStatusBreakdown,
      'leadAnalytics': leadAnalytics?.toMap(),
    };
  }
}

class ContractorLeadAnalytics {
  final Map<String, dynamic> leadStatusBreakdown;
  final Map<String, dynamic> leadSourceBreakdown;
  final Map<String, dynamic> leadStageBreakdown;

  ContractorLeadAnalytics({
    required this.leadStatusBreakdown,
    required this.leadSourceBreakdown,
    required this.leadStageBreakdown,
  });

  factory ContractorLeadAnalytics.fromJson(Map<String, dynamic> json) {
    return ContractorLeadAnalytics(
      leadStatusBreakdown:
      Map<String, dynamic>.from(json['leadStatusBreakdown'] ?? {}),
      leadSourceBreakdown:
      Map<String, dynamic>.from(json['leadSourceBreakdown'] ?? {}),
      leadStageBreakdown:
      Map<String, dynamic>.from(json['leadStageBreakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leadStatusBreakdown': leadStatusBreakdown,
      'leadSourceBreakdown': leadSourceBreakdown,
      'leadStageBreakdown': leadStageBreakdown,
    };
  }
}

class ContractorServices {
  final List<ContractorTopService> topRatedServices;
  final Map<String, int> ratingsDistribution;

  ContractorServices({
    required this.topRatedServices,
    required this.ratingsDistribution,
  });

  factory ContractorServices.fromJson(Map<String, dynamic> json) {
    return ContractorServices(
      topRatedServices: (json['topRatedServices'] as List<dynamic>? ?? [])
          .map((e) => ContractorTopService.fromJson(e))
          .toList(),
      ratingsDistribution:
      Map<String, int>.from(json['ratingsDistribution'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topRatedServices': topRatedServices.map((e) => e.toMap()).toList(),
      'ratingsDistribution': ratingsDistribution,
    };
  }
}

class ContractorTopService {
  final String id;
  final String serviceName;
  final String category;
  final String description;
  final int totalReviews;
  final double averageRating;
  final int warningCount;
  final bool isActive;
  final bool isBlocked;
  final String? createdAt;

  ContractorTopService({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.description,
    required this.totalReviews,
    required this.averageRating,
    required this.warningCount,
    required this.isActive,
    required this.isBlocked,
    this.createdAt,
  });

  factory ContractorTopService.fromJson(Map<String, dynamic> json) {
    return ContractorTopService(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      warningCount: json['warningCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'category': category,
      'description': description,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'warningCount': warningCount,
      'isActive': isActive,
      'isBlocked': isBlocked,
      'createdAt': createdAt,
    };
  }
}

class ContractorReviews {
  final int totalReviews;
  final List<ContractorReview> recentReviews;
  final Map<String, int> ratingBreakdown;
  final double averageRating;

  ContractorReviews({
    required this.totalReviews,
    required this.recentReviews,
    required this.ratingBreakdown,
    required this.averageRating,
  });

  factory ContractorReviews.fromJson(Map<String, dynamic> json) {
    return ContractorReviews(
      totalReviews: json['totalReviews'] ?? 0,
      recentReviews: (json['recentReviews'] as List<dynamic>? ?? [])
          .map((e) => ContractorReview.fromJson(e))
          .toList(),
      ratingBreakdown: Map<String, int>.from(json['ratingBreakdown'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalReviews': totalReviews,
      'recentReviews': recentReviews.map((e) => e.toMap()).toList(),
      'ratingBreakdown': ratingBreakdown,
      'averageRating': averageRating,
    };
  }
}

class ContractorReview {
  final String id;
  final double rating;
  final String? title;
  final String content;
  final String reviewerName;
  final String? reviewerProfilePic;
  final String? createdAt;

  ContractorReview({
    required this.id,
    required this.rating,
    this.title,
    required this.content,
    required this.reviewerName,
    this.reviewerProfilePic,
    this.createdAt,
  });

  factory ContractorReview.fromJson(Map<String, dynamic> json) {
    return ContractorReview(
      id: json['id'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      title: json['title'],
      content: json['content'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerProfilePic: json['reviewerProfilePic'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'title': title,
      'content': content,
      'reviewerName': reviewerName,
      'reviewerProfilePic': reviewerProfilePic,
      'createdAt': createdAt,
    };
  }
}

class ContractorInquiriesTrend {
  final String month;
  final int inquiries;

  ContractorInquiriesTrend({
    required this.month,
    required this.inquiries,
  });

  factory ContractorInquiriesTrend.fromJson(Map<String, dynamic> json) {
    return ContractorInquiriesTrend(
      month: json['month'] ?? '',
      inquiries: json['inquiries'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'inquiries': inquiries,
    };
  }
}

class ContractorLeadsTrend {
  final String month;
  final int leads;

  ContractorLeadsTrend({
    required this.month,
    required this.leads,
  });

  factory ContractorLeadsTrend.fromJson(Map<String, dynamic> json) {
    return ContractorLeadsTrend(
      month: json['month'] ?? '',
      leads: json['leads'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'leads': leads,
    };
  }
}

class ContractorProjectsTrend {
  final String month;
  final int projects;

  ContractorProjectsTrend({
    required this.month,
    required this.projects,
  });

  factory ContractorProjectsTrend.fromJson(Map<String, dynamic> json) {
    return ContractorProjectsTrend(
      month: json['month'] ?? '',
      projects: json['projects'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'projects': projects,
    };
  }
}*/


class ContractorInsightsModel {
  final bool success;
  final String message;
  final ContractorData? data;

  ContractorInsightsModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ContractorInsightsModel.fromJson(Map<String, dynamic> json) {
    return ContractorInsightsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ContractorData.fromJson(json['data']) : null,
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

class ContractorData {
  final String contractorId;
  final ContractorPerformance? performance;
  final ContractorLeadAnalytics? leadAnalytics;
  final ContractorServices? services;
  final ContractorReviews? reviews;
  final List<ContractorInquiriesTrend> inquiriesTrend;
  final List<ContractorLeadsTrend> leadsTrend;
  final List<ContractorProjectsTrend> projectsTrend;
  final String? lastUpdated;

  ContractorData({
    required this.contractorId,
    this.performance,
    this.leadAnalytics,
    this.services,
    this.reviews,
    required this.inquiriesTrend,
    required this.leadsTrend,
    required this.projectsTrend,
    this.lastUpdated,
  });

  factory ContractorData.fromJson(Map<String, dynamic> json) {
    return ContractorData(
      contractorId: json['contractorId'] ?? '',
      performance: json['performance'] != null
          ? ContractorPerformance.fromJson(json['performance'])
          : null,
      leadAnalytics: json['leadAnalytics'] != null
          ? ContractorLeadAnalytics.fromJson(json['leadAnalytics'])
          : null,
      services: json['services'] != null
          ? ContractorServices.fromJson(json['services'])
          : null,
      reviews: json['reviews'] != null
          ? ContractorReviews.fromJson(json['reviews'])
          : null,
      inquiriesTrend: (json['inquiriesTrend'] as List<dynamic>? ?? [])
          .map((e) => ContractorInquiriesTrend.fromJson(e))
          .toList(),
      leadsTrend: (json['leadsTrend'] as List<dynamic>? ?? [])
          .map((e) => ContractorLeadsTrend.fromJson(e))
          .toList(),
      projectsTrend: (json['projectsTrend'] as List<dynamic>? ?? [])
          .map((e) => ContractorProjectsTrend.fromJson(e))
          .toList(),
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contractorId': contractorId,
      'performance': performance?.toMap(),
      'leadAnalytics': leadAnalytics?.toMap(),
      'services': services?.toMap(),
      'reviews': reviews?.toMap(),
      'inquiriesTrend': inquiriesTrend.map((e) => e.toMap()).toList(),
      'leadsTrend': leadsTrend.map((e) => e.toMap()).toList(),
      'projectsTrend': projectsTrend.map((e) => e.toMap()).toList(),
      'lastUpdated': lastUpdated,
    };
  }
}

class ContractorPerformance {
  final int totalServices;
  final int activeServices;
  final int inactiveServices;
  final int totalInquiries;
  final int totalLeads;
  final int totalProjects;
  final int activeProjects;
  final int completedProjects;
  final double conversionRate;
  final double overallRating;
  final int totalReviews;
  final int warningCount;
  final bool isBlocked;
  final int currentMonthInquiries;
  final int previousMonthInquiries;
  final int currentMonthLeads;
  final int previousMonthLeads;
  final Map<String, dynamic> inquiryStatusBreakdown;

  ContractorPerformance({
    required this.totalServices,
    required this.activeServices,
    required this.inactiveServices,
    required this.totalInquiries,
    required this.totalLeads,
    required this.totalProjects,
    required this.activeProjects,
    required this.completedProjects,
    required this.conversionRate,
    required this.overallRating,
    required this.totalReviews,
    required this.warningCount,
    required this.isBlocked,
    required this.currentMonthInquiries,
    required this.previousMonthInquiries,
    required this.currentMonthLeads,
    required this.previousMonthLeads,
    required this.inquiryStatusBreakdown,
  });

  factory ContractorPerformance.fromJson(Map<String, dynamic> json) {
    return ContractorPerformance(
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      inactiveServices: json['inactiveServices'] ?? 0,
      totalInquiries: json['totalInquiries'] ?? 0,
      totalLeads: json['totalLeads'] ?? 0,
      totalProjects: json['totalProjects'] ?? 0,
      activeProjects: json['activeProjects'] ?? 0,
      completedProjects: json['completedProjects'] ?? 0,
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      overallRating: (json['overallRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      warningCount: json['warningCount'] ?? 0,
      isBlocked: json['isBlocked'] ?? false,
      currentMonthInquiries: json['currentMonthInquiries'] ?? 0,
      previousMonthInquiries: json['previousMonthInquiries'] ?? 0,
      currentMonthLeads: json['currentMonthLeads'] ?? 0,
      previousMonthLeads: json['previousMonthLeads'] ?? 0,
      inquiryStatusBreakdown:
      Map<String, dynamic>.from(json['inquiryStatusBreakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalServices': totalServices,
      'activeServices': activeServices,
      'inactiveServices': inactiveServices,
      'totalInquiries': totalInquiries,
      'totalLeads': totalLeads,
      'totalProjects': totalProjects,
      'activeProjects': activeProjects,
      'completedProjects': completedProjects,
      'conversionRate': conversionRate,
      'overallRating': overallRating,
      'totalReviews': totalReviews,
      'warningCount': warningCount,
      'isBlocked': isBlocked,
      'currentMonthInquiries': currentMonthInquiries,
      'previousMonthInquiries': previousMonthInquiries,
      'currentMonthLeads': currentMonthLeads,
      'previousMonthLeads': previousMonthLeads,
      'inquiryStatusBreakdown': inquiryStatusBreakdown,
    };
  }
}

class ContractorLeadAnalytics {
  final Map<String, dynamic> leadStatusBreakdown;
  final Map<String, dynamic> leadStageBreakdown;
  final Map<String, dynamic> leadSourceBreakdown;

  ContractorLeadAnalytics({
    required this.leadStatusBreakdown,
    required this.leadStageBreakdown,
    required this.leadSourceBreakdown,
  });

  factory ContractorLeadAnalytics.fromJson(Map<String, dynamic> json) {
    return ContractorLeadAnalytics(
      leadStatusBreakdown:
      Map<String, dynamic>.from(json['leadStatusBreakdown'] ?? {}),
      leadStageBreakdown:
      Map<String, dynamic>.from(json['leadStageBreakdown'] ?? {}),
      leadSourceBreakdown:
      Map<String, dynamic>.from(json['leadSourceBreakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leadStatusBreakdown': leadStatusBreakdown,
      'leadStageBreakdown': leadStageBreakdown,
      'leadSourceBreakdown': leadSourceBreakdown,
    };
  }
}

class ContractorServices {
  final List<ContractorTopService> topRatedServices;
  final Map<String, int> ratingsDistribution;

  ContractorServices({
    required this.topRatedServices,
    required this.ratingsDistribution,
  });

  factory ContractorServices.fromJson(Map<String, dynamic> json) {
    return ContractorServices(
      topRatedServices: (json['topRatedServices'] as List<dynamic>? ?? [])
          .map((e) => ContractorTopService.fromJson(e))
          .toList(),
      ratingsDistribution:
      Map<String, int>.from(json['ratingsDistribution'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topRatedServices': topRatedServices.map((e) => e.toMap()).toList(),
      'ratingsDistribution': ratingsDistribution,
    };
  }
}

class ContractorTopService {
  final String id;
  final String serviceName;
  final String category;
  final String description;
  final int totalReviews;
  final double averageRating;
  final int warningCount;
  final bool isActive;
  final bool isBlocked;
  final String? createdAt;

  ContractorTopService({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.description,
    required this.totalReviews,
    required this.averageRating,
    required this.warningCount,
    required this.isActive,
    required this.isBlocked,
    this.createdAt,
  });

  factory ContractorTopService.fromJson(Map<String, dynamic> json) {
    return ContractorTopService(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      warningCount: json['warningCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'category': category,
      'description': description,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'warningCount': warningCount,
      'isActive': isActive,
      'isBlocked': isBlocked,
      'createdAt': createdAt,
    };
  }
}

class ContractorReviews {
  final int totalReviews;
  final List<ContractorReview> recentReviews;
  final Map<String, int> ratingBreakdown;
  final double averageRating;

  ContractorReviews({
    required this.totalReviews,
    required this.recentReviews,
    required this.ratingBreakdown,
    required this.averageRating,
  });

  factory ContractorReviews.fromJson(Map<String, dynamic> json) {
    return ContractorReviews(
      totalReviews: json['totalReviews'] ?? 0,
      recentReviews: (json['recentReviews'] as List<dynamic>? ?? [])
          .map((e) => ContractorReview.fromJson(e))
          .toList(),
      ratingBreakdown: Map<String, int>.from(json['ratingBreakdown'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalReviews': totalReviews,
      'recentReviews': recentReviews.map((e) => e.toMap()).toList(),
      'ratingBreakdown': ratingBreakdown,
      'averageRating': averageRating,
    };
  }
}

class ContractorReview {
  final String id;
  final double rating;
  final String? title;
  final String content;
  final String reviewerName;
  final String? reviewerProfilePic;
  final String? createdAt;

  ContractorReview({
    required this.id,
    required this.rating,
    this.title,
    required this.content,
    required this.reviewerName,
    this.reviewerProfilePic,
    this.createdAt,
  });

  factory ContractorReview.fromJson(Map<String, dynamic> json) {
    return ContractorReview(
      id: json['id'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      title: json['title'],
      content: json['content'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
      reviewerProfilePic: json['reviewerProfilePic'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'title': title,
      'content': content,
      'reviewerName': reviewerName,
      'reviewerProfilePic': reviewerProfilePic,
      'createdAt': createdAt,
    };
  }
}

class ContractorInquiriesTrend {
  final String month;
  final int inquiries;

  ContractorInquiriesTrend({
    required this.month,
    required this.inquiries,
  });

  factory ContractorInquiriesTrend.fromJson(Map<String, dynamic> json) {
    return ContractorInquiriesTrend(
      month: json['month'] ?? '',
      inquiries: json['inquiries'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'inquiries': inquiries,
    };
  }
}

class ContractorLeadsTrend {
  final String month;
  final int leads;

  ContractorLeadsTrend({
    required this.month,
    required this.leads,
  });

  factory ContractorLeadsTrend.fromJson(Map<String, dynamic> json) {
    return ContractorLeadsTrend(
      month: json['month'] ?? '',
      leads: json['leads'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'leads': leads,
    };
  }
}

class ContractorProjectsTrend {
  final String month;
  final int projects;

  ContractorProjectsTrend({
    required this.month,
    required this.projects,
  });

  factory ContractorProjectsTrend.fromJson(Map<String, dynamic> json) {
    return ContractorProjectsTrend(
      month: json['month'] ?? '',
      projects: json['projects'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'projects': projects,
    };
  }
}


