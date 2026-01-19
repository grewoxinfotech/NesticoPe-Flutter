class ProfileSellerModel {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String userId;
  final String sellerType;
  final String contactName;
  final String contactPhone;
  final String companyName;
  final String reraNumber;
  final String gstNumber;
  final String? idProof;
  final String? propertyAddress;
  final int numberOfProperties;
  final String? whyChooseUs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileSellerModel({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.userId,
    required this.sellerType,
    required this.contactName,
    required this.contactPhone,
    required this.companyName,
    required this.reraNumber,
    required this.gstNumber,
    this.idProof,
    this.propertyAddress,
    required this.numberOfProperties,
    this.whyChooseUs,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileSellerModel.fromJson(Map<String, dynamic> map) {
    return ProfileSellerModel(
      id: map['id'] ?? '',
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      userId: map['userId'] ?? '',
      sellerType: map['sellerType'] ?? '',
      contactName: map['contactName'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      companyName: map['companyName'] ?? '',
      reraNumber: map['reraNumber'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
      idProof: map['idProof'],
      propertyAddress: map['propertyAddress'],
      numberOfProperties: map['numberOfProperties'] ?? 0,
      whyChooseUs: map['whychooseus'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'userId': userId,
      'sellerType': sellerType,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'companyName': companyName,
      'reraNumber': reraNumber,
      'gstNumber': gstNumber,
      'idProof': idProof,
      'propertyAddress': propertyAddress,
      'numberOfProperties': numberOfProperties,
      'whychooseus': whyChooseUs,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class UserUpdateProfile {
  final String firstName;
  final String lastName;
  final String phone;
   String? image;
  final String address;
  final String email;
  final String city;
  final String totalExperience;
  final String state;
  final SellerProfileData profileData;

  UserUpdateProfile({
    required this.firstName,
    required this.totalExperience,
    required this.lastName,
    required this.phone,
    required this.address,
     this.image,
    required this.email,
    required this.city,
    required this.state,
    required this.profileData,
  });

  factory UserUpdateProfile.fromMap(Map<String, dynamic> map) {
    return UserUpdateProfile(
      firstName: map['firstName'] ?? '',
      totalExperience: map['totalExperience'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      address: map['address']??'',
      profileData: SellerProfileData.fromMap(map['profiledata'] ?? {}), image: map['profilePic']??'',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'city': city,
      'totalExperience': totalExperience,
      'state': state,
      'address':address,
      'profilePic':image??"",
      'profiledata': profileData.toMap(),
    };
  }
}

class SellerProfileData {
  final String contactName;
  final String contactPhone;
  final String companyName;
  final String gstNumber;
  final String reraNumber;

  SellerProfileData({
    required this.contactName,
    required this.contactPhone,
    required this.companyName,
    required this.gstNumber,
    required this.reraNumber,
  });

  factory SellerProfileData.fromMap(Map<String, dynamic> map) {
    return SellerProfileData(
      contactName: map['contactName'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      companyName: map['companyName'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
      reraNumber: map['reraNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactName': contactName,
      'contactPhone': contactPhone,
      'companyName': companyName,
      'gstNumber': gstNumber,
      'reraNumber': reraNumber,
    };
  }
}

