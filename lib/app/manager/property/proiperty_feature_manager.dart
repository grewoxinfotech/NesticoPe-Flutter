import '../../../data/network/property/models/property_model.dart';

class PropertyFeatureManager {
  /// Returns a list of features for the given property based on its listing type
  static List<String> getFeatures(Items property) {
    if (property.listingType == null || property.propertyDetails == null) {
      return ["No features available"];
    }

    final details = property.propertyDetails!;
    final financial = details.financialInfo;
    final possession = details.possessionInfo;
    final parking = details.parkingInfo;
    final furnish = details.furnishInfo;

    switch (property.listingType!.toLowerCase()) {
      case 'sell':
        return [
          // "Price: ₹${financial?.price?.toStringAsFixed(0) ?? 'N/A'}",
          "Negotiable: ${financial?.negotiable == true ? 'Yes' : 'No'}",
          "BHK: ${details.bhk ?? 'N/A'}",
          "Bathrooms: ${details.bathroom ?? 'N/A'}",
          "Carpet Area: ${details.propertyCarpetArea?.toStringAsFixed(0) ?? 'N/A'} sq.ft.",
          "Facing: ${details.propertyFacing ?? 'N/A'}",
          "Condition: ${details.propertyCondition ?? 'N/A'}",
          "Age: ${possession?.propertyAgeInYear ?? 'N/A'} years",
          // if (details.amenities != null && details.amenities!.isNotEmpty)
          //   "Amenities: ${details.amenities!.join(', ')}",
        ];

      case 'rent':
        return [
          // "Rent Price: ₹${financial?.propertyRentPerMonth?.toStringAsFixed(0) ?? 'N/A'} / month",
          "Deposit: ₹${financial?.propertySecurityDeposit?.toStringAsFixed(0) ?? 'N/A'}",
          "BHK: ${details.bhk ?? 'N/A'}",
          "Bathrooms: ${details.bathroom ?? 'N/A'}",
          "Furnish Type: ${furnish?.furnishType ?? 'N/A'}",
          "Parking: ${_getParkingInfo(parking)}",
          "Available From: ${possession?.possessionStatus ?? 'N/A'}",
          // if (details.amenities != null && details.amenities!.isNotEmpty)
          //   "Amenities: ${details.amenities!.join(', ')}",
        ];

      case 'pg':
        return [
          // "Rent per bed: ₹${financial?.propertyRentPerMonth?.toStringAsFixed(0) ?? 'N/A'}",
          "Sharing Type: ${property.propertyType ?? 'N/A'}",
          "Furnishing: ${furnish?.furnishType ?? 'N/A'}",
          "Security Deposit: ₹${financial?.propertySecurityDeposit?.toStringAsFixed(0) ?? 'N/A'}",
          // if (details.amenities != null && details.amenities!.isNotEmpty)
          //   "Facilities: ${details.amenities!.join(', ')}",
        ];

      default:
        return ["No specific features available"];
    }
  }

  /// Helper to format parking info
  // static String _getParkingInfo(ParkingInfo? parking) {
  //   if (parking == null) return "N/A";
  //   List<String> list = [];
  //   if ((parking.covered ?? 0) > 0) list.add("${parking.covered} Covered");
  //   if ((parking.open ?? 0) > 0) list.add("${parking.open} Open");
  //   return list.isNotEmpty ? list.join(", ") : "N/A";
  // }
  static String _getParkingInfo(ParkingInfo? parking) {
    if (parking == null) return "N/A";

    final List<String> list = [];

    // Only add if the number of parking slots is greater than 0
    if (parking.covered != null && parking.covered == true) {
      list.add("${parking.covered} Covered");
    }

    if (parking.open != null && parking.open == true ) {
      list.add("${parking.open} Open");
    }

    // Join the list with comma or return "N/A" if empty
    return list.isNotEmpty ? list.join(", ") : "N/A";
  }

}
