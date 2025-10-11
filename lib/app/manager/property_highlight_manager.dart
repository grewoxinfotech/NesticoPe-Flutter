// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
//
// import '../../data/network/property/models/property_model.dart';
//
// class PropertyHighlightManager {
//   final Items property;
//
//   PropertyHighlightManager(this.property);
//
//   /// Returns a simplified list of highlights for UI (key-value)
//   List<Map<String, String>> getHighlights() {
//     final highlights = <Map<String, String>>[];
//
//     if (property.propertyDetails == null) return highlights;
//
//     final pd = property.propertyDetails!;
//
//     // ----- RESIDENTIAL -----
//     if (property.type == 'residential') {
//       if (pd.bhk != null) highlights.add({"BHK": "${pd.bhk} BHK"});
//       if (pd.furnishInfo?.furnishType != null) {
//         highlights.add({"Furnishing": pd.furnishInfo!.furnishType!});
//       }
//       if (pd.propertyBuiltUpArea != null) {
//         highlights.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
//       }
//       if (pd.pgInfo?.pgRoomInfo != null && pd.pgInfo!.pgRoomInfo!.isNotEmpty) {
//         highlights.add({
//           "Room Type": "${pd.pgInfo?.pgRoomInfo?.first.roomType} Room",
//         });
//       }
//
//       // Listing type specific
//       switch (property.listingType?.toLowerCase()) {
//         case 'rent':
//           if (pd.financialInfo?.price != null) {
//             highlights.add({
//               "Rent": "${pd.financialInfo!.propertyRentPerMonth} INR / month",
//             });
//           }
//           break;
//         case 'sell':
//           if (pd.financialInfo?.price != null) {
//             highlights.add({"Price": "${pd.financialInfo!.price} INR"});
//           }
//           break;
//         case 'pg':
//           highlights.add({
//             "Price":
//                 "${Formatter.formatPrice(pd.financialInfo!.propertyRentPerMonth)} INR / month",
//           });
//
//           break;
//       }
//
//       // Property type specific
//       switch (property.propertyType?.toLowerCase()) {
//         case 'apartment':
//           // Apartment-specific highlights
//           break;
//         case 'villa':
//           // Villa-specific highlights
//           break;
//         case 'house':
//           // House-specific highlights
//           break;
//       }
//     }
//
//     // ----- COMMERCIAL -----
//     if (property.type == 'commercial') {
//       if (pd.propertyBuiltUpArea != null) {
//         highlights.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
//       }
//       if (pd.floorInfo != null) {
//         highlights.add({
//           "Floor":
//               "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
//         });
//       }
//
//       // Listing type specific
//       switch (property.listingType?.toLowerCase()) {
//         case 'rent':
//           if (pd.financialInfo?.price != null) {
//             highlights.add({"Rent": "${pd.financialInfo!.price} INR / month"});
//           }
//           break;
//         case 'sell':
//           if (pd.financialInfo?.price != null) {
//             highlights.add({"Price": "${pd.financialInfo!.price} INR"});
//           }
//           break;
//       }
//
//       // Commercial type-specific highlights
//       switch (property.propertyType?.toLowerCase()) {
//         case 'office':
//         case 'shop':
//         case 'showroom':
//         case 'warehouse':
//           // Add type-specific highlights if needed
//           break;
//       }
//     }
//
//     // ----- COMMON HIGHLIGHTS -----
//     if (pd.possessionInfo?.possessionStatus != null) {
//       highlights.add({"Possession": pd.possessionInfo!.possessionStatus!});
//     }
//     if (pd.possessionInfo?.propertyAgeInYear != null) {
//       highlights.add({
//         "Age of Property": "${pd.possessionInfo!.propertyAgeInYear} years",
//       });
//     }
//
//     return highlights;
//   }
//
//   String get highlightsString {
//     final list = getHighlights();
//     // Join all values into a single string
//     return list.map((e) => e.values.first).join(', ');
//   }
// }
//
// // extension StringCasingExtension on String {
// //   String capitalize() =>
// //       "${this[0].toUpperCase()}${substring(1).replaceAll('_', ' ')}";
// // }

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import '../../data/network/property/models/property_model.dart';

/// Handles property highlights and icons centrally.
class PropertyHighlightManager {
  final Items property;

  PropertyHighlightManager(this.property);

  /// Maps highlight titles to their respective icons.
  static const Map<String, IconData> _iconMap = {
    "BHK": Icons.bed,
    "Furnishing": Icons.chair_alt,
    "Built-up Area": Icons.zoom_out_map_outlined,
    "Carpet Area": Icons.square_foot,
    "Floor": Icons.layers_outlined,
    "Age of Property": Icons.date_range,
    "Rent": Icons.attach_money,
    "Price": Icons.price_change,
    "Possession": Icons.home_work,
    "Amenities": Icons.checklist_rtl,
    "Parking": Icons.local_parking,
    "Facing": Icons.explore,
    "Condition": Icons.handyman,
    "Room Type": Icons.meeting_room,
  };

  /// Returns a simplified list of highlights for UI (with icon and text)
  List<PropertyHighlightItem> getHighlights() {
    final highlights = <PropertyHighlightItem>[];

    if (property.propertyDetails == null) return highlights;
    final pd = property.propertyDetails!;

    // ----- RESIDENTIAL -----
    if (property.type == 'residential') {
      if (pd.bhk != null) {
        highlights.add(
          PropertyHighlightItem(
            title: "BHK",
            value: "${pd.bhk} BHK",
            icon: _iconMap["BHK"],
          ),
        );
      }
      if (pd.furnishInfo?.furnishType != null) {
        highlights.add(
          PropertyHighlightItem(
            title: "Furnishing",
            value: pd.furnishInfo!.furnishType!,
            icon: _iconMap["Furnishing"],
          ),
        );
      }
      if (pd.propertyBuiltUpArea != null) {
        highlights.add(
          PropertyHighlightItem(
            title: "Built-up Area",
            value: "${pd.propertyBuiltUpArea} sq.ft.",
            icon: _iconMap["Built-up Area"],
          ),
        );
      }
      if (pd.pgInfo?.pgRoomInfo != null && pd.pgInfo!.pgRoomInfo!.isNotEmpty) {
        highlights.add(
          PropertyHighlightItem(
            title: "Room Type",
            value: "${pd.pgInfo?.pgRoomInfo?.first.roomType} Room",
            icon: _iconMap["Room Type"],
          ),
        );
      }

      // Listing type specific
      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.propertyRentPerMonth != null) {
            highlights.add(
              PropertyHighlightItem(
                title: "Rent",
                value:
                    "${Formatter.formatPrice(pd.financialInfo!.propertyRentPerMonth)} / month",
                icon: _iconMap["Rent"],
              ),
            );
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            highlights.add(
              PropertyHighlightItem(
                title: "Price",
                value: "${Formatter.formatPrice(pd.financialInfo!.price)}",
                icon: _iconMap["Price"],
              ),
            );
          }
          break;
        case 'pg':
          if (pd.financialInfo?.propertyRentPerMonth != null) {
            highlights.add(
              PropertyHighlightItem(
                title: "Price",
                value:
                    "${Formatter.formatPrice(pd.financialInfo!.propertyRentPerMonth)} / month",
                icon: _iconMap["Price"],
              ),
            );
          }
          break;
      }
    }

    // ----- COMMERCIAL -----
    if (property.type == 'commercial') {
      if (pd.propertyBuiltUpArea != null) {
        highlights.add(
          PropertyHighlightItem(
            title: "Built-up Area",
            value: "${pd.propertyBuiltUpArea} sq.ft.",
            icon: _iconMap["Built-up Area"],
          ),
        );
      }
      if (pd.floorInfo != null) {
        highlights.add(
          PropertyHighlightItem(
            title: "Floor",
            value:
                "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors ?? '-'}",
            icon: _iconMap["Floor"],
          ),
        );
      }

      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            highlights.add(
              PropertyHighlightItem(
                title: "Rent",
                value:
                    "${Formatter.formatPrice(pd.financialInfo!.price)} / month",
                icon: _iconMap["Rent"],
              ),
            );
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            highlights.add(
              PropertyHighlightItem(
                title: "Price",
                value: Formatter.formatPrice(pd.financialInfo!.price),
                icon: _iconMap["Price"],
              ),
            );
          }
          break;
      }
    }

    // ----- COMMON HIGHLIGHTS -----
    if (pd.possessionInfo?.possessionStatus != null) {
      highlights.add(
        PropertyHighlightItem(
          title: "Possession",
          value: pd.possessionInfo!.possessionStatus!,
          icon: _iconMap["Possession"],
        ),
      );
    }
    if (pd.possessionInfo?.propertyAgeInYear != null) {
      highlights.add(
        PropertyHighlightItem(
          title: "Age of Property",
          value: "${pd.possessionInfo!.propertyAgeInYear} years",
          icon: _iconMap["Age of Property"],
        ),
      );
    }

    return highlights;
  }

  /// Returns comma-separated highlight values only (no icons)
  String get highlightsString => getHighlights().map((e) => e.value).join(', ');
}

/// Model to hold highlight data
class PropertyHighlightItem {
  final String title;
  final String value;
  final IconData? icon;

  PropertyHighlightItem({required this.title, required this.value, this.icon});
}
