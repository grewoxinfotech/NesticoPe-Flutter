import '../../data/network/property/models/property_model.dart';

class PropertyDetailManager {
  final Items property;

  PropertyDetailManager(this.property);

  /// Returns key-value pairs of details to show based on type, listingType, propertyType
  List<Map<String, String>> getDetails() {
    final details = <Map<String, String>>[];

    if (property.propertyDetails == null) return details;

    final pd = property.propertyDetails!;

    // ----- RESIDENTIAL -----
    if (property.type == 'residential') {
      // Common Residential details
      if (pd.bhk != null) details.add({"BHK": "${pd.bhk} BHK"});
      if (pd.bathroom != null) details.add({"Bathrooms": "${pd.bathroom}"});
      if (pd.balcony != null) details.add({"Balcony": "${pd.balcony}"});
      if (pd.floorInfo != null) {
        details.add({
          "Floor":
              "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
        });
      }
      if (pd.furnishInfo?.furnishType != null) {
        details.add({"Furnishing": pd.furnishInfo!.furnishType!});
      }
      if (pd.propertyBuiltUpArea != null) {
        details.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
      }
      if (pd.propertyCarpetArea != null) {
        details.add({"Carpet Area": "${pd.propertyCarpetArea} sq.ft."});
      }

      // Listing type specific (Rent/Sell/PG)
      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            details.add({"Rent": "${pd.financialInfo!.price} INR / month"});
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            details.add({"Price": "${pd.financialInfo!.price} INR"});
          }
          break;
        case 'pg':
          // Add PG specific fields if pg_info exists
          // details.add({"PG Name": property.propertyDetails?.pgInfo?.pgName ?? ""});
          break;
      }

      // Property type specific (Apartment/House/Villa)
      switch (property.propertyType?.toLowerCase()) {
        case 'apartment':
          // extra apartment specific details
          break;
        case 'villa':
          // extra villa specific details
          break;
        case 'house':
          // extra house specific details
          break;
      }
    }

    // ----- COMMERCIAL -----
    if (property.type == 'commercial') {
      // Common Commercial details
      if (pd.floorInfo != null) {
        details.add({
          "Floor":
              "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
        });
      }
      if (pd.propertyBuiltUpArea != null) {
        details.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
      }

      // Listing type specific (Rent/Sell)
      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            details.add({"Rent": "${pd.financialInfo!.price} INR / month"});
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            details.add({"Price": "${pd.financialInfo!.price} INR"});
          }
          break;
      }

      // Property type specific (Office/Shop/Showroom)
      switch (property.propertyType?.toLowerCase()) {
        case 'office':
        case 'shop':
        case 'showroom':
        case 'warehouse':
          // Add commercial type specific details
          break;
      }
    }

    // ----- COMMON DETAILS -----
    if (pd.amenities != null && pd.amenities!.isNotEmpty) {
      details.add({
        "Amenities": pd.amenities!
            .map((e) => e.replaceAll('_', ' ').capitalize())
            .join(", "),
      });
    }

    if (pd.parkingInfo != null) {
      final parking = pd.parkingInfo!;
      if ((parking.covered ?? 0) > 0 || (parking.open ?? 0) > 0) {
        details.add({
          "Parking":
              "${parking.covered ?? 0} Covered, ${parking.open ?? 0} Open",
        });
      }
    }

    if (pd.propertyFacing != null) details.add({"Facing": pd.propertyFacing!});
    if (pd.propertyCondition != null) {
      details.add({"Condition": pd.propertyCondition!});
    }

    // Possession info
    if (pd.possessionInfo?.possessionStatus != null) {
      details.add({"Possession": pd.possessionInfo!.possessionStatus!});
    }
    if (pd.possessionInfo?.propertyAgeInYear != null) {
      details.add({
        "Age of Property": "${pd.possessionInfo!.propertyAgeInYear} years",
      });
    }

    // Address
    // final addressParts =
    //     [
    //       property.address,
    //       property.city,
    //       property.state,
    //       property.zipCode,
    //     ].where((e) => e != null && e.isNotEmpty).toList();
    // if (addressParts.isNotEmpty) {
    //   details.add({"Address": addressParts.join(", ")});
    // }

    return details;
  }
}

extension StringCasingExtension on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).replaceAll('_', ' ')}";
}
