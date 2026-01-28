import 'dart:convert';

class OverAllContractorResponse {
  final bool success;
  final String message;
  final OverAllContractorData? data;

  OverAllContractorResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OverAllContractorResponse.fromRawJson(String source) =>
      OverAllContractorResponse.fromJson(
        json.decode(source) as Map<String, dynamic>,
      );

  factory OverAllContractorResponse.fromJson(Map<String, dynamic> json) {
    return OverAllContractorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? OverAllContractorData.fromJson(
                Map<String, dynamic>.from(json['data']),
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'success': success,
    'message': message,
    'data': data?.toMap(),
  };

  String toJson() => json.encode(toMap());
}

class OverAllContractorData {
  final List<OverAllContractorItem> contractors;
  final int total;

  OverAllContractorData({required this.contractors, required this.total});

  factory OverAllContractorData.fromJson(Map<String, dynamic> json) {
    return OverAllContractorData(
      contractors:
          (json['contractors'] as List<dynamic>? ?? [])
              .map(
                (e) => OverAllContractorItem.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'contractors': contractors.map((e) => e.toMap()).toList(),
    'total': total,
  };
}

class OverAllContractorItem {
  final String id;
  final String userId;
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;
  final String phone;
  final String? profilePic;
  final String? city;
  final String? state;
  final int? totalExperience;
  final int? contractorVisitCharge;
  final int totalServices;
  final int activeServices;
  final String overallRating;
  final int totalReviews;
  final String? contractorType;
  final bool isBlocked;
  final int warningCount;
  final OverAllContractorSubscription? subscription;
  final List<OverAllServiceInCategory> servicesInCategory;
  final int totalServicesInCategory;
  final String avgRatingInCategory;

  OverAllContractorItem({
    required this.id,
    required this.userId,
    required this.username,
    this.firstName,
    this.lastName,
    required this.email,
    required this.phone,
    this.profilePic,
    this.city,
    this.state,
    this.totalExperience,
    required this.totalServices,
    required this.activeServices,
    required this.overallRating,
    required this.totalReviews,
    this.contractorType,
    required this.isBlocked,
    required this.warningCount,
    this.subscription,
    required this.servicesInCategory,
    required this.totalServicesInCategory,
    required this.avgRatingInCategory,
    this.contractorVisitCharge,
  });

  factory OverAllContractorItem.fromJson(Map<String, dynamic> json) {
    return OverAllContractorItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePic: json['profilePic'],
      city: json['city'],
      state: json['state'],
      totalExperience: json['totalExperience'],
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      overallRating: json['overallRating'] ?? '0.00',
      totalReviews: json['totalReviews'] ?? 0,
      contractorType: json['contractorType'],
      isBlocked: json['isBlocked'] ?? false,
      warningCount: json['warningCount'] ?? 0,
      subscription:
          json['subscription'] != null
              ? OverAllContractorSubscription.fromJson(
                Map<String, dynamic>.from(json['subscription']),
              )
              : null,
      servicesInCategory:
          (json['servicesInCategory'] as List<dynamic>? ?? [])
              .map(
                (e) => OverAllServiceInCategory.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),
      totalServicesInCategory: json['totalServicesInCategory'] ?? 0,
      avgRatingInCategory: json['avgRatingInCategory'] ?? '0.00',
      contractorVisitCharge: json['contractorVisitCharge'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'profilePic': profilePic,
    'city': city,
    'state': state,
    'totalExperience': totalExperience,
    'totalServices': totalServices,
    'activeServices': activeServices,
    'overallRating': overallRating,
    'totalReviews': totalReviews,
    'contractorType': contractorType,
    'isBlocked': isBlocked,
    'warningCount': warningCount,
    'subscription': subscription?.toMap(),
    'servicesInCategory': servicesInCategory.map((e) => e.toMap()).toList(),
    'totalServicesInCategory': totalServicesInCategory,
    'avgRatingInCategory': avgRatingInCategory,
    'contractorVisitCharge': contractorVisitCharge,
  };
}

class OverAllContractorSubscription {
  final bool hasPremiumPlan;
  final int planAmount;
  final String planName;

  OverAllContractorSubscription({
    required this.hasPremiumPlan,
    required this.planAmount,
    required this.planName,
  });

  factory OverAllContractorSubscription.fromJson(Map<String, dynamic> json) {
    return OverAllContractorSubscription(
      hasPremiumPlan: json['hasPremiumPlan'] ?? false,
      planAmount: json['planAmount'] ?? 0,
      planName: json['planName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'hasPremiumPlan': hasPremiumPlan,
    'planAmount': planAmount,
    'planName': planName,
  };
}

class OverAllServiceInCategory {
  final String id;
  final String serviceName;
  final dynamic rating;

  OverAllServiceInCategory({
    required this.id,
    required this.serviceName,
    this.rating,
  });

  factory OverAllServiceInCategory.fromJson(Map<String, dynamic> json) {
    return OverAllServiceInCategory(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'serviceName': serviceName,
    'rating': rating,
  };
}

class ContractorCityInsightsResponse {
  final bool success;
  final String message;
  final List<ContractorCityInsight> data;

  ContractorCityInsightsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorCityInsightsResponse.fromJson(Map<String, dynamic> json) {
    return ContractorCityInsightsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map(
                (e) => ContractorCityInsight.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class ContractorCityInsight {
  final String city;
  final int count;

  ContractorCityInsight({required this.city, required this.count});

  factory ContractorCityInsight.fromJson(Map<String, dynamic> json) {
    return ContractorCityInsight(
      city: json['city'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'city': city, 'count': count};
  }
}
