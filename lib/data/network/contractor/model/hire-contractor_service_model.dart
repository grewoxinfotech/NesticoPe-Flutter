class HireContractorServiceResponse {
  final bool success;
  final String message;
  final HireContractorServiceData data;

  HireContractorServiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HireContractorServiceResponse.fromMap(Map<String, dynamic> map) {
    return HireContractorServiceResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: HireContractorServiceData.fromMap(map['data'] ?? {}),
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
class HireContractorServiceData {
  final List<HireContractorServiceContractor> contractors;
  final int total;
  final String categoryId;

  HireContractorServiceData({
    required this.contractors,
    required this.total,
    required this.categoryId,
  });

  factory HireContractorServiceData.fromMap(Map<String, dynamic> map) {
    return HireContractorServiceData(
      contractors: (map['contractors'] as List<dynamic>?)
          ?.map((e) => HireContractorServiceContractor.fromMap(e))
          .toList() ??
          [],
      total: map['total'] ?? 0,
      categoryId: map['categoryId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contractors': contractors.map((e) => e.toMap()).toList(),
      'total': total,
      'categoryId': categoryId,
    };
  }
}
class HireContractorServiceContractor {
  final String contractorId;
  final String username;
  final String? profilePic;
  final String email;
  final HireContractorProfile contractorProfile;
  final List<HireContractorCategoryService> servicesInCategory;
  final int totalServicesInCategory;
  final String avgRatingInCategory;

  HireContractorServiceContractor({
    required this.contractorId,
    required this.username,
    this.profilePic,
    required this.email,
    required this.contractorProfile,
    required this.servicesInCategory,
    required this.totalServicesInCategory,
    required this.avgRatingInCategory,
  });

  factory HireContractorServiceContractor.fromMap(Map<String, dynamic> map) {
    return HireContractorServiceContractor(
      contractorId: map['contractor_id'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'],
      email: map['email'] ?? '',
      contractorProfile:
      HireContractorProfile.fromMap(map['contractorProfile'] ?? {}),
      servicesInCategory: (map['servicesInCategory'] as List<dynamic>?)
          ?.map((e) => HireContractorCategoryService.fromMap(e))
          .toList() ??
          [],
      totalServicesInCategory: map['totalServicesInCategory'] ?? 0,
      avgRatingInCategory: map['avgRatingInCategory'] ?? '0.00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contractor_id': contractorId,
      'username': username,
      'profilePic': profilePic,
      'email': email,
      'contractorProfile': contractorProfile.toMap(),
      'servicesInCategory': servicesInCategory.map((e) => e.toMap()).toList(),
      'totalServicesInCategory': totalServicesInCategory,
      'avgRatingInCategory': avgRatingInCategory,
    };
  }
}
class HireContractorProfile {
  final int totalServices;
  final int activeServices;
  final String overallRating;
  final int totalReviews;
  final bool isBlocked;

  HireContractorProfile({
    required this.totalServices,
    required this.activeServices,
    required this.overallRating,
    required this.totalReviews,
    required this.isBlocked,
  });

  factory HireContractorProfile.fromMap(Map<String, dynamic> map) {
    return HireContractorProfile(
      totalServices: map['totalServices'] ?? 0,
      activeServices: map['activeServices'] ?? 0,
      overallRating: map['overallRating'] ?? '0.00',
      totalReviews: map['totalReviews'] ?? 0,
      isBlocked: map['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalServices': totalServices,
      'activeServices': activeServices,
      'overallRating': overallRating,
      'totalReviews': totalReviews,
      'isBlocked': isBlocked,
    };
  }
}
class HireContractorCategoryService {
  final String id;
  final String serviceName;
  final double rating;

  HireContractorCategoryService({
    required this.id,
    required this.serviceName,
    required this.rating,
  });

  factory HireContractorCategoryService.fromMap(Map<String, dynamic> map) {
    return HireContractorCategoryService(
      id: map['id'] ?? '',
      serviceName: map['serviceName'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'rating': rating,
    };
  }
}
