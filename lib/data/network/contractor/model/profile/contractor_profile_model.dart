// contractor_profile_model.dart

class ContractorProfileModel {
  final bool success;
  final String message;
  final ContractorProfileData data;

  ContractorProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorProfileModel.fromJson(Map<String, dynamic> json) {
    return ContractorProfileModel(
      success: json['success'],
      message: json['message'],
      data: ContractorProfileData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ContractorProfileData {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String userId;
  final int totalReviews;
  final String overallRating;
  final int warningCount;
  final int totalServices;
  final bool isBlocked;
  final String? blockReason;
  final String? contractorType;
  final String? blockedAt;
  final int activeServices;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ContractorProjectData projectData;

  ContractorProfileData({
    required this.id,
    this.createdBy,
    this.updatedBy,
    this.contractorType,
    required this.userId,
    required this.totalReviews,
    required this.overallRating,
    required this.warningCount,
    required this.totalServices,
    required this.isBlocked,
    this.blockReason,
    this.blockedAt,
    required this.activeServices,
     this.createdAt,
     this.updatedAt,
    required this.projectData,
  });

  factory ContractorProfileData.fromJson(Map<String, dynamic> json) {
    return ContractorProfileData(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      userId: json['userId'],
      totalReviews: json['totalReviews'],
      overallRating: json['overallRating'],
      warningCount: json['warningCount'],
      totalServices: json['totalServices'],
      isBlocked: json['isBlocked'],
      blockReason: json['blockReason'],
      blockedAt: json['blockedAt'],
      activeServices: json['activeServices'],
      contractorType: json['contractorType'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      projectData: ContractorProjectData.fromJson(json['projectData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'userId': userId,
      'totalReviews': totalReviews,
      'overallRating': overallRating,
      'warningCount': warningCount,
      'totalServices': totalServices,
      'isBlocked': isBlocked,
      'blockReason': blockReason,
      'contractorType':contractorType,
      'blockedAt': blockedAt,
      'activeServices': activeServices,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'projectData': projectData.toJson(),
    };
  }
}

class ContractorProjectData {
  final int totalProjects;
  final int pendingProjects;
  final int runningProjects;
  final int completedProjects;
  final int cancelledProjects;

  ContractorProjectData({
    required this.totalProjects,
    required this.pendingProjects,
    required this.runningProjects,
    required this.completedProjects,
    required this.cancelledProjects,
  });

  factory ContractorProjectData.fromJson(Map<String, dynamic> json) {
    return ContractorProjectData(
      totalProjects: json['totalProjects'],
      pendingProjects: json['pendingProjects'],
      runningProjects: json['runningProjects'],
      completedProjects: json['completedProjects'],
      cancelledProjects: json['cancelledProjects'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalProjects': totalProjects,
      'pendingProjects': pendingProjects,
      'runningProjects': runningProjects,
      'completedProjects': completedProjects,
      'cancelledProjects': cancelledProjects,
    };
  }
}



class ContractorUserUpdateProfile {
  final String firstName;
  final String lastName;
  final String phone;
  String? image;

  final String email;
  final String city;
  final int experinec;
  final String state;


  ContractorUserUpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.experinec,

    this.image,
    required this.email,
    required this.city,
    required this.state,

  });

  factory ContractorUserUpdateProfile.fromMap(Map<String, dynamic> map) {
    return ContractorUserUpdateProfile(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      experinec: map['totalExperience']??0,
      email: map['email'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',


    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'city': city,
      'totalExperience':experinec,
      'state': state,

      'profilePic':image??"",

    };
  }
}