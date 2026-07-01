import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/network/property/models/property_model.dart';

/// Centralized utility to manage how a property's display name/title appears in the UI.
class PropertyNameManager {
  final Items property;

  PropertyNameManager(this.property);

  /// Returns the proper display name as a formatted string
  String get displayName {
    final type = property.type?.toLowerCase() ?? '';
    final propertyType = property.propertyType?.capitalize ?? '';

    print("Property Type: $propertyType, Property BHK: ${property.title}");

    if (type == "residential") {
      final bhk = property.propertyDetails?.bhk ?? 0;

      if(property.listingType?.toLowerCase() == "pg") {
        return property.propertyDetails?.pgInfo?.pgName??'PG';
      }
      // If bhk = 0, show only property type
      return bhk > 0
          ? "$bhk BHK ${propertyType.replaceAll("_", " ").capitalize.toString()}"
          : propertyType.replaceAll("_", " ").capitalize.toString();
    }

    if (type == "commercial") {
      return propertyType;
    }

    // Default fallback
    return property.title ?? "Property";
  }

  /// Returns a ready-to-use Text widget with consistent style
  Widget get displayNameWidget {
    return Text(
      displayName,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black87,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Optional subtitle — like project name or builder
  String? get subtitle {
    if (property.projectName != null && property.projectName!.isNotEmpty) {
      return property.projectName!;
    }
    if (property.builderName != null && property.builderName!.isNotEmpty) {
      return property.builderName!;
    }
    return null;
  }
}
