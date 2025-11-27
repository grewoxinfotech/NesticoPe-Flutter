class CityResponse {
  final bool success;
  final String message;
  final List<CityData> data;

  CityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      success: json['story'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<CityData>.from(
                json['data'].map((x) => CityData.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class CityData {
  final int id;
  final String city;
  final String state;
  final List<String> listingTypes;

  CityData({
    required this.id,
    required this.city,
    required this.state,
    required this.listingTypes,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      id: json['id'] ?? 0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      listingTypes:
          json['listingTypes'] != null
              ? List<String>.from(json['listingTypes'])
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'state': state,
      'listingTypes': listingTypes,
    };
  }
}
