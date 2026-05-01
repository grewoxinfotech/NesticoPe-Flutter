// import 'package:nesticope_app/app/utils/formater/formater.dart';
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
import 'package:nesticope_app/app/utils/formater/formater.dart';
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
    "Rent": Icons.currency_rupee,
    "Price": Icons.currency_rupee,
    "Possession": Icons.home_work,
    "Amenities": Icons.checklist_rtl,
    "Parking": Icons.local_parking,
    "Facing": Icons.explore,
    "Condition": Icons.handyman,
    "Room Type": Icons.meeting_room,
  };
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
      // switch (property.listingType?.toLowerCase()) {
      //   case 'rent':
      //     if (pd.financialInfo?.propertyRentPerMonth != null &&
      //         pd.financialInfo!.propertyRentPerMonth! > 0) {
      //       highlights.add(
      //         PropertyHighlightItem(
      //           title: "Rent",
      //           value:
      //               "${Formatter.formatPrice(pd.financialInfo!.propertyRentPerMonth)} / month",
      //           icon: _iconMap["Rent"],
      //         ),
      //       );
      //     }
      //     break;
      //   case 'sell':
      //     if (pd.financialInfo?.price != null) {
      //       highlights.add(
      //         PropertyHighlightItem(
      //           title: "Price",
      //           value: "${Formatter.formatPrice(pd.financialInfo!.price)}",
      //           icon: _iconMap["Price"],
      //         ),
      //       );
      //     }
      //     break;
      //   case 'pg':
      //     if (pd.financialInfo?.propertyRentPerMonth != null) {
      //       highlights.add(
      //         PropertyHighlightItem(
      //           title: "Price",
      //           value:
      //               "${Formatter.formatPrice(pd.financialInfo!.propertyRentPerMonth)} / month",
      //           icon: _iconMap["Price"],
      //         ),
      //       );
      //     }
      //     break;
      // }
      switch (property.listingType?.toLowerCase()) {
  case 'rent':
    final fi = pd.financialInfo;

    num? rentValue;

    if (fi?.propertyRentPerMonth != null && fi!.propertyRentPerMonth! > 0) {
      rentValue = fi.propertyRentPerMonth;
    } else if (fi?.monthlyRent != null) {
      rentValue = num.tryParse(fi!.monthlyRent.toString());
    } else if (fi?.price != null) {
      rentValue = num.tryParse(fi!.price.toString());
    }

    if (rentValue != null && rentValue > 0) {
      highlights.add(
        PropertyHighlightItem(
          title: "Rent",
          value: "${Formatter.formatPrice(rentValue)} / month",
          icon: _iconMap["Rent"],
        ),
      );
    }
    break;

  case 'sell':
    final price = pd.financialInfo?.price;

    if (price != null && price > 0) {
      highlights.add(
        PropertyHighlightItem(
          title: "Price",
          value: Formatter.formatPrice(price),
          icon: _iconMap["Price"],
        ),
      );
    }
    break;

  case 'pg':
    final pg = pd.pgInfo;

    if (pg != null && pg.pgRoomInfo != null && pg.pgRoomInfo!.isNotEmpty) {
      final rents = pg.pgRoomInfo!.map((r) => r.rent ?? 0).toList();

      final minRent = rents.reduce((a, b) => a < b ? a : b);
      final maxRent = rents.reduce((a, b) => a > b ? a : b);

      final rentText = (minRent == maxRent)
          ? "${Formatter.formatPrice(minRent)} / month"
          : "${Formatter.formatPrice(minRent)} - ${Formatter.formatPrice(maxRent)} / month";

      highlights.add(
        PropertyHighlightItem(
          title: "Rent",
          value: rentText,
          icon: _iconMap["Rent"],
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

  /// Returns property furnishing information as a list of items with counts/availability
  List<FurnishingItem> getFurnishingInfo() {
    final furnishingItems = <FurnishingItem>[];

    if (property.propertyDetails?.furnishInfo?.furnishDetails == null) {
      return furnishingItems;
    }

    final details = property.propertyDetails!.furnishInfo!.furnishDetails!;

    // Add count-based items (integer values)
    if (details.ac != null && details.ac! > 0) {
      furnishingItems.add(
        FurnishingItem(name: "AC", count: details.ac, icon: Icons.ac_unit),
      );
    }

    if (details.bed != null && details.bed! > 0) {
      furnishingItems.add(
        FurnishingItem(name: "Bed", count: details.bed, icon: Icons.bed),
      );
    }

    if (details.geyser != null && details.geyser! > 0) {
      furnishingItems.add(
        FurnishingItem(
          name: "Geyser",
          count: details.geyser,
          icon: Icons.water_drop,
        ),
      );
    }

    // Add boolean-based items (available/not available)
    if (details.washingMachine == true) {
      furnishingItems.add(
        FurnishingItem(
          name: "Washing Machine",
          isAvailable: true,
          icon: Icons.local_laundry_service,
        ),
      );
    }

    if (details.cupboard == true) {
      furnishingItems.add(
        FurnishingItem(
          name: "Cupboard",
          isAvailable: true,
          icon: Icons.door_sliding,
        ),
      );
    }

    if (details.stove == true) {
      furnishingItems.add(
        FurnishingItem(name: "Stove", isAvailable: true, icon: Icons.whatshot),
      );
    }

    if (details.fridge == true) {
      furnishingItems.add(
        FurnishingItem(name: "Fridge", isAvailable: true, icon: Icons.kitchen),
      );
    }

    if (details.waterPurifier == true) {
      furnishingItems.add(
        FurnishingItem(
          name: "Water Purifier",
          isAvailable: true,
          icon: Icons.water,
        ),
      );
    }

    if (details.modularKitchen == true) {
      furnishingItems.add(
        FurnishingItem(
          name: "Modular Kitchen",
          isAvailable: true,
          icon: Icons.countertops,
        ),
      );
    }

    return furnishingItems;
  }

  /// Returns the furnishing type (e.g., "fully-furnished", "semi-furnished", "unfurnished")
  String? get furnishingType =>
      property.propertyDetails?.furnishInfo?.furnishType;
}

/// Model to hold highlight data
class PropertyHighlightItem {
  final String title;
  final String value;
  final IconData? icon;

  PropertyHighlightItem({required this.title, required this.value, this.icon});
}

/// Model to hold furnishing item data
class FurnishingItem {
  final String name;
  final int? count; // For countable items like AC, Bed, Geyser
  final bool? isAvailable; // For boolean items like Washing Machine, Fridge
  final IconData? icon;

  FurnishingItem({required this.name, this.count, this.isAvailable, this.icon});

  /// Returns display text for the furnishing item
  String get displayText {
    if (count != null) {
      return "$name ($count)";
    }
    return name;
  }
}
