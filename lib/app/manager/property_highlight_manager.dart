import '../../data/network/property/models/property_model.dart';

class PropertyHighlightManager {
  final Items property;

  PropertyHighlightManager(this.property);

  /// Returns a simplified list of highlights for UI (key-value)
  List<Map<String, String>> getHighlights() {
    final highlights = <Map<String, String>>[];

    if (property.propertyDetails == null) return highlights;

    final pd = property.propertyDetails!;

    // ----- RESIDENTIAL -----
    if (property.type == 'residential') {
      if (pd.bhk != null) highlights.add({"BHK": "${pd.bhk} BHK"});
      if (pd.furnishInfo?.furnishType != null) {
        highlights.add({"Furnishing": pd.furnishInfo!.furnishType!});
      }
      if (pd.propertyBuiltUpArea != null) {
        highlights.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
      }
      if (pd.floorInfo != null) {
        highlights.add({
          "Floor":
              "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
        });
      }

      // Listing type specific
      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            highlights.add({"Rent": "${pd.financialInfo!.price} INR / month"});
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            highlights.add({"Price": "${pd.financialInfo!.price} INR"});
          }
          break;
        case 'pg':
          // PG-specific highlights (if available)
          break;
      }

      // Property type specific
      switch (property.propertyType?.toLowerCase()) {
        case 'apartment':
          // Apartment-specific highlights
          break;
        case 'villa':
          // Villa-specific highlights
          break;
        case 'house':
          // House-specific highlights
          break;
      }
    }

    // ----- COMMERCIAL -----
    if (property.type == 'commercial') {
      if (pd.propertyBuiltUpArea != null) {
        highlights.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
      }
      if (pd.floorInfo != null) {
        highlights.add({
          "Floor":
              "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
        });
      }

      // Listing type specific
      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            highlights.add({"Rent": "${pd.financialInfo!.price} INR / month"});
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            highlights.add({"Price": "${pd.financialInfo!.price} INR"});
          }
          break;
      }

      // Commercial type-specific highlights
      switch (property.propertyType?.toLowerCase()) {
        case 'office':
        case 'shop':
        case 'showroom':
        case 'warehouse':
          // Add type-specific highlights if needed
          break;
      }
    }

    // ----- COMMON HIGHLIGHTS -----
    if (pd.possessionInfo?.possessionStatus != null) {
      highlights.add({"Possession": pd.possessionInfo!.possessionStatus!});
    }
    if (pd.possessionInfo?.propertyAgeInYear != null) {
      highlights.add({
        "Age of Property": "${pd.possessionInfo!.propertyAgeInYear} years",
      });
    }

    return highlights;
  }
}

// extension StringCasingExtension on String {
//   String capitalize() =>
//       "${this[0].toUpperCase()}${substring(1).replaceAll('_', ' ')}";
// }
