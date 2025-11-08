class RoomModel {
  String roomType;
  String monthlyRent;
  String deposit;
  List<String> amenities;
  String other;// ✅ Added list of strings

  RoomModel({
    required this.roomType,
    required this.monthlyRent,
    required this.deposit,
    required this.other,
    required this.amenities, // ✅ Added to constructor
  });

  // Convert model to Map (for API/DB storage)
  Map<String, dynamic> toMap() {
    return {
      'roomType': roomType,
      'monthlyRent': monthlyRent,
      'deposit': deposit,
      'other':other,
      'amenities': amenities, // ✅ Added to map
    };
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomType: json['roomType'] ?? '',
      monthlyRent: json['monthlyRent'] ?? '',
      deposit: json['deposit'] ?? '',
      other: json['other']??'',
      amenities: List<String>.from(json['amenities'] ?? []), // ✅ Safe parsing
    );
  }
}
