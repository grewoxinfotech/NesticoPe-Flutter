class ProfileSellerModel {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String userId;
  final String sellerType;
  final String? contactName;
  final String? contactPhone;
  final String? companyName;
  final String? reraNumber;
  final String? gstNumber;
  final String? idProof;
  final String? propertyAddress;
  final int numberOfProperties;
  final String? whyChooseUs;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileSellerModel({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.userId,
    required this.sellerType,
    this.contactName,
    this.contactPhone,
    this.companyName,
    this.reraNumber,
    this.gstNumber,
    this.idProof,
    this.propertyAddress,
    required this.numberOfProperties,
    this.whyChooseUs,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert JSON to Model
  factory ProfileSellerModel.fromJson(Map<String, dynamic> json) {
    return ProfileSellerModel(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      userId: json['userId'] ?? '',
      sellerType: json['sellerType'] ?? '',
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      companyName: json['companyName'],
      reraNumber: json['reraNumber'],
      gstNumber: json['gstNumber'],
      idProof: json['idProof'],
      propertyAddress: json['propertyAddress'],
      numberOfProperties: json['numberOfProperties'] ?? 0,
      whyChooseUs: json['whychooseus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Convert Model to Map (for API or DB)
  Map<String, dynamic> toMap() {
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
