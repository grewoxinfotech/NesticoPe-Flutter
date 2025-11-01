class InterestFormModel {
  final String propertyId;
  final String resellerId;
  final List<CustomFormField> formFields;

  InterestFormModel({
    required this.propertyId,
    required this.resellerId,
    required this.formFields,
  });

  factory InterestFormModel.fromJson(Map<String, dynamic> json) {
    return InterestFormModel(
      propertyId: json['propertyId'] ?? '',
      resellerId: json['resellerId'] ?? '',
      formFields:
          (json['formFields'] as List<dynamic>?)
              ?.map((e) => CustomFormField.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (propertyId != null) {
      map['propertyId'] = propertyId;
    }
    if (resellerId != null) {
      map['resellerId'] = resellerId;
    }
    if (formFields != null && formFields.isNotEmpty) {
      map['formFields'] = formFields.map((e) => e.toJson()).toList();
    }

    return map;
  }
}

class CustomFormField {
  final String id;
  final String label;
  final String name;
  final String type;
  final bool required;
  final String placeHolder;

  CustomFormField({
    required this.id,
    required this.label,
    required this.name,
    required this.type,
    required this.required,
    required this.placeHolder,
  });

  factory CustomFormField.fromJson(Map<String, dynamic> json) {
    return CustomFormField(
      id: json[['id']] ?? "",
      label: json['label'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      required: json['required'] ?? false,
      placeHolder: json['placeHolder'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'name': name,
      'type': type,
      'required': required,
      'placeHolder': placeHolder,
    };
  }
}
