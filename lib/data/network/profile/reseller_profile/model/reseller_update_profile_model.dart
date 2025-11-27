class ResellerUpdateProfile {
  final bool? success;
  final String? message;
  final ResellerData? data;

  ResellerUpdateProfile({this.success, this.message, this.data});

  factory ResellerUpdateProfile.fromMap(Map<String, dynamic> map) {
    return ResellerUpdateProfile(
      success: map['success'] as bool?,
      message: map['message'] as String?,
      data: map['data'] != null ? ResellerData.fromMap(map['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {'story': success, 'message': message, 'data': data?.toMap()};
  }
}

class ResellerData {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? username;
  final String? password;
  final String? email;
  final String? userType;
  final String? roleId;
  final String? profilePic;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? otp;
  final String? otpExpiry;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final bool? isVerified;
  final bool? isOnline;
  final String? lastSeen;
  final String? createdAt;
  final String? updatedAt;

  ResellerData({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.username,
    this.password,
    this.email,
    this.userType,
    this.roleId,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.phone,
    this.otp,
    this.otpExpiry,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.isVerified,
    this.isOnline,
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
  });

  factory ResellerData.fromMap(Map<String, dynamic> map) {
    return ResellerData(
      id: map['id'] as String?,
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      username: map['username'] as String?,
      password: map['password'] as String?,
      email: map['email'] as String?,
      userType: map['userType'] as String?,
      roleId: map['role_id'] as String?,
      profilePic: map['profilePic'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      phone: map['phone'] as String?,
      otp: map['otp'] as String?,
      otpExpiry: map['otpExpiry'] as String?,
      address: map['address'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      zipCode: map['zipCode'] as String?,
      isVerified: map['isVerified'] as bool?,
      isOnline: map['isOnline'] as bool?,
      lastSeen: map['lastSeen'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'username': username,
      'password': password,
      'email': email,
      'userType': userType,
      'role_id': roleId,
      'profilePic': profilePic,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'otp': otp,
      'otpExpiry': otpExpiry,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
