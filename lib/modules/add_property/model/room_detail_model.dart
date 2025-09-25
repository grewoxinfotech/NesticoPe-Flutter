class RoomModel {
  String roomType;
  String monthlyRent;
  String deposit;

  RoomModel({
    required this.roomType,
    required this.monthlyRent,
    required this.deposit,
  });

  // Convert model to Map (for API/DB storage)
  Map<String, dynamic> toMap() {
    return {
      'roomType': roomType,
      'monthlyRent': monthlyRent,
      'deposit': deposit,
    };
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomType: json['roomType'] ?? '',
      monthlyRent: json['monthlyRent'] ?? '',
      deposit: json['deposit'] ?? '',
    );
  }
}
