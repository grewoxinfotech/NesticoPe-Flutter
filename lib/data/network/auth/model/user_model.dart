enum UserRole { buyer, seller, reseller, contractor }

class UserModel {
  String? token;
  User? user;

  UserModel({this.token, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? username;
  String? password;
  String? email;
  String? userType;
  String? sellerType;
  String? roleId;
  String? profilePic;
  String? firstName;
  String? lastName;
  String? phone;
  String? otp;
  String? otpExpiry;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.createdBy,
      this.updatedBy,
      this.username,
      this.password,
      this.email,
      this.userType,
      this.sellerType,
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
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    userType = json['userType'];
    sellerType = json['sellerType'];
    roleId = json['role_id'];
    profilePic = json['profilePic'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    otp = json['otp'];
    otpExpiry = json['otpExpiry'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['userType'] = userType;
    data['sellerType'] = sellerType;
    data['role_id'] = roleId;
    data['profilePic'] = profilePic;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['otp'] = otp;
    data['otpExpiry'] = otpExpiry;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipCode;
    data['isVerified'] = isVerified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}