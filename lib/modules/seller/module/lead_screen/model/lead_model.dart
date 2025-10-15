import 'dart:convert';

import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

class LeadItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? name;
  final String? email;
  final String? phone;
  final String? propertyId;
  final String? resellerId;
  final String? source;
  final String? status;
  final String? stage;
  final String? notes;
  final String? lastContactedAt;
  final bool? isFake;
  final String? fakeReason;
  final String? markedFakeBy;
  final String? markedFakeAt;
  final Items? customFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LeadItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.name,
    this.email,
    this.phone,
    this.propertyId,
    this.resellerId,
    this.source,
    this.status,
    this.stage,
    this.notes,
    this.lastContactedAt,
    this.isFake,
    this.fakeReason,
    this.markedFakeBy,
    this.markedFakeAt,
    this.customFields,
    this.createdAt,
    this.updatedAt,
  });

  factory LeadItem.fromJson(Map<String, dynamic> json) => LeadItem(
    id: json["id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    propertyId: json["property_id"],
    resellerId: json["reseller_id"],
    source: json["source"],
    status: json["status"],
    stage: json["stage"],
    notes: json["notes"],
    lastContactedAt: json["lastContactedAt"],
    isFake: json["isFake"],
    fakeReason: json["fakeReason"],
    markedFakeBy: json["markedFakeBy"],
    markedFakeAt: json["markedFakeAt"],
    customFields:
        json["customFields"] != null && json["customFields"].isNotEmpty
            ? Items.fromJson(json["customFields"])
            : null,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    if (createdBy != null) "created_by": createdBy,
    if (updatedBy != null) "updated_by": updatedBy,
    if (name != null) "name": name,
    if (email != null) "email": email,
    if (phone != null) "phone": phone,
    if (propertyId != null) "property_id": propertyId,
    if (resellerId != null) "reseller_id": resellerId,
    if (source != null) "source": source,
    if (status != null) "status": status,
    if (stage != null) "stage": stage,
    if (notes != null) "notes": notes,
    if (lastContactedAt != null) "lastContactedAt": lastContactedAt,
    if (isFake != null) "isFake": isFake,
    if (fakeReason != null) "fakeReason": fakeReason,
    if (markedFakeBy != null) "markedFakeBy": markedFakeBy,
    if (markedFakeAt != null) "markedFakeAt": markedFakeAt,
    if (customFields != null) "customFields": customFields?.toJson(),
    if (createdAt != null) "createdAt": createdAt?.toIso8601String(),
    if (updatedAt != null) "updatedAt": updatedAt?.toIso8601String(),
  };
}

extension LeadItemCopy on LeadItem {
  LeadItem copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? name,
    String? email,
    String? phone,
    String? propertyId,
    String? resellerId,
    String? source,
    String? status,
    String? stage,
    String? notes,
    String? lastContactedAt,
    bool? isFake,
    String? fakeReason,
    String? markedFakeBy,
    String? markedFakeAt,
    Items? customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeadItem(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      propertyId: propertyId ?? this.propertyId,
      resellerId: resellerId ?? this.resellerId,
      source: source ?? this.source,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      notes: notes ?? this.notes,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      isFake: isFake ?? this.isFake,
      fakeReason: fakeReason ?? this.fakeReason,
      markedFakeBy: markedFakeBy ?? this.markedFakeBy,
      markedFakeAt: markedFakeAt ?? this.markedFakeAt,
      customFields: customFields ?? this.customFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
