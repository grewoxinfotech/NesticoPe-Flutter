class PropertyReportModel {
  final String propertyId;
  final String reason;
  final String description;

  PropertyReportModel({
    required this.propertyId,
    required this.reason,
    required this.description,
  });

  /// Convert JSON to Model
  factory PropertyReportModel.fromJson(Map<String, dynamic> json) {
    return PropertyReportModel(
      propertyId: json['propertyId'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'reason': reason,
      'description': description,
    };
  }
}
