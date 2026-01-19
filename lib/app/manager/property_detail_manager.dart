// import '../../data/network/property/models/property_model.dart';
//
// class PropertyDetailManager {
//   final Items property;
//
//   PropertyDetailManager(this.property);
//
//   /// Returns key-value pairs of details to show based on type, listingType, propertyType
//   List<Map<String, String>> getDetails() {
//     final details = <Map<String, String>>[];
//
//     if (property.propertyDetails == null) return details;
//
//     final pd = property.propertyDetails!;
//
//     // ----- RESIDENTIAL -----
//     if (property.type == 'residential') {
//       // Common Residential details
//       if (pd.bhk != null) details.add({"BHK": "${pd.bhk} BHK"});
//       if (pd.bathroom != null) details.add({"Bathrooms": "${pd.bathroom}"});
//       if (pd.balcony != null) details.add({"Balcony": "${pd.balcony}"});
//       if (pd.floorInfo != null) {
//         details.add({
//           "Floor":
//               "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
//         });
//       }
//       if (pd.furnishInfo?.furnishType != null) {
//         details.add({"Furnishing": pd.furnishInfo!.furnishType!});
//       }
//       if (pd.propertyBuiltUpArea != null) {
//         details.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
//       }
//       if (pd.propertyCarpetArea != null) {
//         details.add({"Carpet Area": "${pd.propertyCarpetArea} sq.ft."});
//       }
//
//       // Listing type specific (Rent/Sell/PG)
//       switch (property.listingType?.toLowerCase()) {
//         case 'rent':
//           if (pd.financialInfo?.price != null) {
//             details.add({"Rent": "${pd.financialInfo!.price} INR / month"});
//           }
//           break;
//         case 'sell':
//           if (pd.financialInfo?.price != null) {
//             details.add({"Price": "${pd.financialInfo!.price} INR"});
//           }
//           break;
//         case 'pg':
//           // Add PG specific fields if pg_info exists
//           if (pd.pgInfo?.pgRoomInfo != null &&
//               pd.pgInfo!.pgRoomInfo!.isNotEmpty) {
//             final rents =
//                 pd.pgInfo!.pgRoomInfo!.map((r) => r.rent ?? 0).toList();
//
//             final minRent = rents.reduce((a, b) => a < b ? a : b);
//             final maxRent = rents.reduce((a, b) => a > b ? a : b);
//
//             // If both rents are equal, show a single value
//             final rentText =
//                 (minRent == maxRent)
//                     ? "$minRent INR / month"
//                     : "$minRent - $maxRent INR / month";
//
//             details.add({"PG": rentText});
//           }
//
//           break;
//       }
//
//       // Property type specific (Apartment/House/Villa)
//       switch (property.propertyType?.toLowerCase()) {
//         case 'apartment':
//           // extra apartment specific details
//           break;
//         case 'villa':
//           // extra villa specific details
//           break;
//         case 'house':
//           // extra house specific details
//           break;
//       }
//     }
//
//     // ----- COMMERCIAL -----
//     if (property.type == 'commercial') {
//       // Common Commercial details
//       if (pd.floorInfo != null) {
//         details.add({
//           "Floor":
//               "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
//         });
//       }
//       if (pd.propertyBuiltUpArea != null) {
//         details.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
//       }
//
//       // Listing type specific (Rent/Sell)
//       switch (property.listingType?.toLowerCase()) {
//         case 'rent':
//           if (pd.financialInfo?.price != null) {
//             details.add({"Rent": "${pd.financialInfo!.price} INR / month"});
//           }
//           break;
//         case 'sell':
//           if (pd.financialInfo?.price != null) {
//             details.add({"Price": "${pd.financialInfo!.price} INR"});
//           }
//           break;
//       }
//
//       // Property type specific (Office/Shop/Showroom)
//       switch (property.propertyType?.toLowerCase()) {
//         case 'office':
//         case 'shop':
//         case 'showroom':
//         case 'warehouse':
//           // Add commercial type specific details
//           break;
//       }
//     }
//
//     // ----- COMMON DETAILS -----
//     // if (pd.amenities != null && pd.amenities!.isNotEmpty) {
//     //   details.add({
//     //     "Amenities": pd.amenities!
//     //         .map((e) => e.replaceAll('_', ' ').capitalize)
//     //         .join(", "),
//     //   });
//     // }
//
//     if (pd.parkingInfo != null) {
//       final parking = pd.parkingInfo!;
//       if ((parking.covered ?? false) || (parking.open ?? false)) {
//         details.add({
//           "Parking":
//               "${(parking.covered ?? false) ? "1 Covered" : "0 Covered"}, ${(parking.open ?? false) ? "1 Open" : "0 Open"}",
//         });
//       }
//     }
//
//     if (pd.propertyFacing != null) details.add({"Facing": pd.propertyFacing!});
//     if (pd.propertyCondition != null) {
//       details.add({"Condition": pd.propertyCondition!});
//     }
//
//     // Possession info
//     if (pd.possessionInfo?.possessionStatus != null) {
//       details.add({"Possession": pd.possessionInfo!.possessionStatus!});
//     }
//     if (pd.possessionInfo?.propertyAgeInYear != null) {
//       details.add({
//         "Age of Property": "${pd.possessionInfo!.propertyAgeInYear} years",
//       });
//     }
//
//     // Address
//     // final addressParts =
//     //     [
//     //       property.address,
//     //       property.city,
//     //       property.state,
//     //       property.zipCode,
//     //     ].where((e) => e != null && e.isNotEmpty).toList();
//     // if (addressParts.isNotEmpty) {
//     //   details.add({"Address": addressParts.join(", ")});
//     // }
//
//     return details;
//   }
// }

import 'dart:developer';

import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';

import '../../data/network/property/models/property_model.dart';

class PropertyDetailManager {
  final Items property;

  PropertyDetailManager(this.property);

  List<Map<String, String>> getDetails() {
    final details = <Map<String, String>>[];

    // if (property.propertyDetails == null) return details;
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

      // ----- LISTING TYPE -----
      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            details.add({
              "Rent":
                  "${Formatter.formatPrice(pd.financialInfo!.price)}/ month",
            });
          }
          break;

        case 'sell':
          if (pd.financialInfo?.price != null) {
            details.add({
              "Price": "${Formatter.formatPrice(pd.financialInfo!.price)}",
            });
          }
          break;

        case 'pg':
          final pg = pd.pgInfo;
          if (pg != null) {
            // --- Rent Range ---
            if (pg.pgRoomInfo != null && pg.pgRoomInfo!.isNotEmpty) {
              final rents = pg.pgRoomInfo!.map((r) => r.rent ?? 0).toList();
              final minRent = rents.reduce((a, b) => a < b ? a : b);
              final maxRent = rents.reduce((a, b) => a > b ? a : b);

              final rentText =
                  (minRent == maxRent)
                      ? "$minRent INR / month"
                      : "$minRent - $maxRent INR / month";
              details.add({"Rent Range": rentText});
            }

            // --- PG Basic Info ---
            if (pg.pgFor != null) details.add({"PG For": pg.pgFor!});
            if (pg.pgSuitedFor != null) {
              details.add({"Suited For": pg.pgSuitedFor!});
            }
            // if (pg.pgMealOffered != null) {
            //   details.add({"Meals Offered": pg.pgMealOffered!});
            // }
            // if (pg.pgCommonArea != null) {
            //   details.add({"Common Areas": pg.pgCommonArea!});
            // }
            if (pg.pgManageBy != null) {
              String managedByText = pg.pgManageBy!;
              if (pg.pgOwnerStaysAtPg != null) {
                managedByText +=
                    " (${pg.pgOwnerStaysAtPg! ? "stays" : "not stay"})";
              }
              details.add({"Managed By": managedByText});
            }

            // if (pg.pgOwnerStaysAtPg != null) {
            //   details.add({
            //     "Owner Stays at PG": pg.pgOwnerStaysAtPg! ? "Yes" : "No",
            //   });
            // }

            // --- Charges ---
            // if (pg.mealChargesPerMonth != null) {
            //   details.add({
            //     "Meal Charges": "${pg.mealChargesPerMonth} INR / month",
            //   });
            // }
            // if (pg.electricityChargesPerMonth != null) {
            //   details.add({
            //     "Electricity Charges":
            //         "${pg.electricityChargesPerMonth} INR / month",
            //   });
            // }

            // --- Rules ---
            // if (pg.pgRules != null) {
            //   final rules = pg.pgRules!;
            //   final rulesList = [
            //     if (rules.nonVegAllowed == true) "Non-Veg Allowed",
            //     if (rules.petsAllowed == true) "Pets Allowed",
            //     if (rules.lateEntryAllowed == true) "Late Entry Allowed",
            //   ];
            //   if (rulesList.isNotEmpty) {
            //     details.add({"Rules": rulesList.join(", ")});
            //   }
            // }
          }
          break;
      }

      // Property type specific
      switch (property.propertyType?.toLowerCase()) {
        case 'apartment':
          break;
        case 'villa':
          break;
        case 'house':
          break;
        case 'agricultural_land':
          final plot = pd.plotInfo;
          if (plot != null) {
            if (plot.plotArea != null) {
              details.add({
                "Plot Area": "${plot.plotArea} ${plot.plotAreaUnit}",
              });
            }
            if (plot.plotLength != null) {
              details.add({"Plot Length": "${plot.plotLength}"});
            }
            if (plot.plotWidth != null) {
              details.add({"Plot Width": "${plot.plotWidth}"});
            }
            if (plot.ownership != null) {
              details.add({"Ownership": plot.ownership!});
            }
            if (plot.zoneType != null) {
              details.add({"Plot Type": plot.zoneType!});
            }
            if (plot.possessionStatus != null) {
              details.add({
                "Possession":
                    plot.possessionStatus!
                        .replaceAll("_", " ")
                        .capitalize
                        .toString(),
              });
            }
            if (property.propertyType != null) {
              details.add({
                "Property Type":
                    property.propertyType!
                        .replaceAll("_", " ")
                        .capitalize
                        .toString(),
              });
            }
          }
          break;
      }
    }

    // ----- COMMERCIAL -----
    if (property.type == 'commercial') {
      if (pd.floorInfo != null) {
        details.add({
          "Floor":
              "${pd.floorInfo!.floorNumber} of ${pd.floorInfo!.totalFloors}",
        });
      }
      if (pd.propertyBuiltUpArea != null) {
        details.add({"Built-up Area": "${pd.propertyBuiltUpArea} sq.ft."});
      }

      switch (property.listingType?.toLowerCase()) {
        case 'rent':
          if (pd.financialInfo?.price != null) {
            details.add({
              "Rent":
                  "${Formatter.formatPrice(pd.financialInfo!.price)} / month",
            });
          }
          break;
        case 'sell':
          if (pd.financialInfo?.price != null) {
            details.add({
              "Price": "${Formatter.formatPrice(pd.financialInfo!.price)}",
            });
          }
          break;
      }
    }

    // ----- COMMON DETAILS -----
    if (pd.parkingInfo != null) {
      final parking = pd.parkingInfo!;
      if ((parking.covered ?? false) || (parking.open ?? false)) {
        details.add({
          "Parking":
              "${(parking.covered ?? false) ? "1 Covered" : "0 Covered"}, ${(parking.open ?? false) ? "1 Open" : "0 Open"}",
        });
      }
    }

    if (pd.propertyFacing != null) details.add({"Facing": pd.propertyFacing!});
    if (pd.propertyCondition != null) {
      details.add({
        "Condition":
            pd.propertyCondition!.replaceAll('_', ' ').capitalize.toString(),
      });
    }
    if (pd.possessionInfo?.possessionStatus != null) {
      details.add({
        "Possession":
            pd.possessionInfo!.possessionStatus!
                .replaceAll("_", " ")
                .capitalize
                .toString(),
      });
    }
    final age = pd.possessionInfo?.propertyAgeInYear;

    if (age != null &&
        age.toString().trim().isNotEmpty &&
        age.toString().toLowerCase() != 'null' &&
        age != 0) {
      log("Adding property age: $age");
      details.add({"Age of Property": "$age years"});
    }

    return details;
  }
}
bool isValidField(dynamic value) {
  if (value == null) return false;
  final str = value.toString().trim().toLowerCase();
  return str.isNotEmpty && str != 'null' && str != '0';
}
