// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import '../../../data/network/property/models/property_model.dart';
//
// class PropertyPriceManager {
//   final String listingType; // "rent" or "sale"
//   final FinancialInfo? financialInfo;
//
//   PropertyPriceManager({
//     required this.listingType,
//     required this.financialInfo,
//   });
//
//   /// Returns formatted main price display (₹12,000/month or ₹85L)
//   String get displayPrice {
//     if (financialInfo == null) return "Price not available";
//
//     if (listingType.toLowerCase() == "rent") {
//       final rent = financialInfo!.propertyRentPerMonth ?? 0;
//       final formatted = Formatter.formatPrice(rent);
//       return "$formatted /month";
//     } else {
//       final price = financialInfo!.price ?? 0;
//       final formatted = Formatter.formatPrice(price);
//       return financialInfo!.negotiable ? "$formatted (Negotiable)" : formatted;
//     }
//   }
//
//   /// Returns price per sqft if available
//   String? get pricePerSqft {
//     final ppsf = financialInfo?.pricePerSqft ?? 0;
//     return ppsf > 0 ? "₹${ppsf.toStringAsFixed(0)}/sqft" : null;
//   }
//
//   /// Returns maintenance info
//   String? get maintenance {
//     final m = financialInfo?.maintenance ?? 0;
//     return m > 0 ? "Maintenance: ₹${m.toStringAsFixed(0)}" : null;
//   }
//
//   /// Returns security deposit info (for rentals)
//   String? get securityDeposit {
//     if (listingType.toLowerCase() == "rent") {
//       final deposit = financialInfo?.propertySecurityDeposit ?? 0;
//       return deposit > 0 ? "Deposit: ₹${deposit.toStringAsFixed(0)}" : null;
//     }
//     return null;
//   }
//
//   /// Returns broker commission info
//   String? get brokerCommission {
//     final commission = financialInfo?.brokerCommission ?? 0;
//     return commission > 0
//         ? "Brokerage: ₹${commission.toStringAsFixed(0)}"
//         : null;
//   }
//
//   /// 🔹 Combine all info for UI display
//   Map<String, String?> get priceSummary => {
//     "Main Price": displayPrice,
//     "Price per Sqft": pricePerSqft,
//     "Maintenance": maintenance,
//     "Deposit": securityDeposit,
//     "Broker Commission": brokerCommission,
//   };
//
//   // ---------------------------------------------------
//   // 🔹 NEW: Compute total of all available charges
//   // ---------------------------------------------------
//   double get totalAmount {
//     if (financialInfo == null) return 0.0;
//
//     final fi = financialInfo!;
//     double total = 0.0;
//
//     // Base price or rent
//     if (listingType.toLowerCase() == "rent") {
//       total += fi.propertyRentPerMonth ?? 0;
//       total += fi.propertySecurityDeposit ?? 0;
//     } else {
//       total += fi.price ?? 0;
//     }
//
//     // Add other charges
//     total += fi.maintenance ?? 0;
//     total += fi.brokerCommission ?? 0;
//
//     return total;
//   }
//
//   /// 🔹 Formatted total display string
//   String get totalPriceDisplay {
//     if (totalAmount <= 0) return "Total not available";
//     return "${Formatter.formatPrice(totalAmount)}";
//   }
// }

import 'package:housing_flutter_app/modules/seller/view/widget/seller_list.dart';

import '../../../data/network/property/models/property_model.dart';
import '../../utils/formater/formater.dart';

// class PropertyPriceManager {
//   final String listingType; // "rent" or "sale"
//   final FinancialInfo? financialInfo;
//
//   PropertyPriceManager({
//     required this.listingType,
//     required this.financialInfo,
//   });
//
//   bool get isRent => listingType.toLowerCase() == "rent";
//
//   double get monthRent {
//     final rentPerMonth = financialInfo?.propertyRentPerMonth ?? 0;
//     final monthlyRent = financialInfo?.monthlyRent ?? 0;
//
//     if (rentPerMonth > 0) return rentPerMonth;
//     if (monthlyRent > 0) return monthlyRent;
//
//     return 0;
//   }
//
//   /// 🔹 Main display
//   String get displayPrice {
//     print(monthRent);
//     print("isRent: $isRent");
//     if (financialInfo == null) return "Price not available";
//
//     if (isRent) {
//       final rent = monthRent;
//       if (rent <= 0) return "Price not available";
//       return "${Formatter.formatPrice(rent)} /month";
//     } else {
//       final price = financialInfo!.price ?? 0;
//       if (price <= 0) return "Price not available";
//       final formatted = Formatter.formatPrice(price);
//       return (financialInfo!.negotiable ?? false)
//           ? "$formatted (Negotiable)"
//           : formatted;
//     }
//   }
//
//   String? get pricePerSqft {
//     final ppsf = financialInfo?.pricePerSqft ?? 0;
//     return ppsf > 0 ? "₹${ppsf.toStringAsFixed(0)}/sqft" : null;
//   }
//
//   String? get maintenance {
//     final m = financialInfo?.maintenance ?? 0;
//     return m > 0 ? "₹${m.toStringAsFixed(0)}" : null;
//   }
//
//   String? get securityDeposit {
//     if (isRent) {
//       final deposit = financialInfo?.propertySecurityDeposit ?? 0;
//       return deposit > 0 ? "₹${deposit.toStringAsFixed(0)}" : null;
//     }
//     return null;
//   }
//
//   String? get brokerCommission {
//     final commission = financialInfo?.brokerCommission ?? 0;
//     return commission > 0 ? "₹${commission.toStringAsFixed(0)}" : null;
//   }
//
//   /// 🔹 Unified summary (only add existing values)
//   Map<String, String?> get priceSummary {
//     final summary = <String, String?>{};
//
//     if (isRent) {
//       summary["Rent / Month"] = displayPrice;
//       if (securityDeposit != null) summary["Deposit"] = securityDeposit;
//     } else {
//       summary["Main Price"] = displayPrice;
//       if (pricePerSqft != null) summary["Price per Sqft"] = pricePerSqft;
//     }
//
//     if (maintenance != null) summary["Maintenance"] = maintenance;
//     if (brokerCommission != null)
//       summary["Broker Commission"] = brokerCommission;
//
//     return summary;
//   }
//
//   double get totalAmount {
//     if (financialInfo == null) return 0.0;
//     final fi = financialInfo!;
//     double total = 0;
//
//     if (isRent) {
//       total += fi.propertyRentPerMonth ?? 0;
//       total += fi.propertySecurityDeposit ?? 0;
//     } else {
//       total += fi.price ?? 0;
//     }
//
//     total += fi.maintenance ?? 0;
//     total += fi.brokerCommission ?? 0;
//
//     return total;
//   }
//
//   String get totalPriceDisplay {
//     if (totalAmount <= 0) return "Total not available";
//     return Formatter.formatPrice(totalAmount);
//   }
// }

class PropertyPriceManager {
  final String listingType; // "rent" or "sale" or "PG"
  final FinancialInfo? financialInfo;
  final PgInfo? pgInfo; // Added for PG properties

  PropertyPriceManager({
    required this.listingType,
    required this.financialInfo,
    this.pgInfo,
  });

  /// 🔹 Check if property is PG
  bool get isPG => listingType.toUpperCase() == "PG";

  /// 🔹 Detect rent type dynamically if listingType is missing or inconsistent
  bool get isRent {
    final lowerType = listingType.toLowerCase();
    if (lowerType == "rent" || lowerType == "pg") return true;

    // Auto-detect rent if price == 0 but rent > 0
    final fi = financialInfo;
    if (fi != null) {
      final hasRent =
          (fi.propertyRentPerMonth > 0) || ((fi.monthlyRent ?? 0) > 0);
      final noSalePrice = (fi.price <= 0);
      if (hasRent && noSalePrice) return true;
    }

    return false;
  }

  /// 🔹 Returns whichever rent value is > 0 (includes PG room rent)
  double get monthRent {
    // For PG properties, get minimum room rent
    if (isPG && pgInfo?.pgRoomInfo != null && pgInfo!.pgRoomInfo!.isNotEmpty) {
      final rooms = pgInfo!.pgRoomInfo!;
      final rents = rooms.map((r) => r.rent ?? 0).where((r) => r > 0).toList();
      if (rents.isNotEmpty) {
        rents.sort();
        return rents.first.toDouble(); // Return minimum rent
      }
    }

    // For regular rent properties
    final fi = financialInfo;
    if (fi == null) return 0;
    final rentPerMonth = fi.propertyRentPerMonth;
    final monthlyRent = fi.monthlyRent ?? 0;

    if (rentPerMonth > 0) return rentPerMonth;
    if (monthlyRent > 0) return monthlyRent;
    return 0;
  }

  /// 🔹 Main display logic (handles PG pricing with type-specific formatting)
  String get displayPrice {
    // For PG properties, show price range with room details
    if (isPG) {
      if (pgInfo?.pgRoomInfo != null && pgInfo!.pgRoomInfo!.isNotEmpty) {
        final rooms = pgInfo!.pgRoomInfo!;
        final rents =
            rooms.map((r) => r.rent ?? 0).where((r) => r > 0).toList();

        if (rents.isEmpty) return "Price not available";

        rents.sort();
        final minRent = rents.first.toDouble();
        final maxRent = rents.last.toDouble();
        final minFormatted = Formatter.formatPrice(minRent);
        final maxFormatted = Formatter.formatNumber(maxRent);

        if (minRent == maxRent) {
          // All rooms have same price - simple display
          return "$minFormatted /month";
        } else {
          // Show range with formatted values
          return "$minFormatted - $maxFormatted /month";
        }
      }
      return "Price not available"; // PG but no room info
    }

    // For regular properties
    final fi = financialInfo;
    if (fi == null) return "Price not available";

    if (isRent) {
      final rent = monthRent;
      if (rent <= 0) return "Rent not available";
      final formatted = Formatter.formatPrice(rent);
      return "₹$formatted /month";
    } else {
      final price = fi.price;
      if (price <= 0) return "Price not available";
      final formatted = Formatter.formatPrice(price);
      return (fi.negotiable) ? "₹$formatted (Negotiable)" : "₹$formatted";
    }
  }

  String? get pricePerSqft {
    // PG properties don't have price per sqft
    if (isPG) return null;

    final ppsf = financialInfo?.pricePerSqft ?? 0;
    return ppsf > 0 ? "₹${ppsf.toStringAsFixed(0)}/sqft" : null;
  }

  String? get maintenance {
    // PG properties don't have separate maintenance (included in charges)
    if (isPG) return null;

    final m = financialInfo?.maintenance ?? 0;
    return m > 0 ? "₹${m.toStringAsFixed(0)}" : null;
  }

  String? get securityDeposit {
    // For PG properties, show deposit range from rooms
    if (isPG && pgInfo?.pgRoomInfo != null && pgInfo!.pgRoomInfo!.isNotEmpty) {
      final rooms = pgInfo!.pgRoomInfo!;
      final deposits =
          rooms.map((r) => r.securityDeposit ?? 0).where((d) => d > 0).toList();

      if (deposits.isEmpty) return null;

      deposits.sort();
      final minDeposit = deposits.first;
      final maxDeposit = deposits.last;

      if (minDeposit == maxDeposit) {
        return "₹${minDeposit.toStringAsFixed(0)}";
      } else {
        return "₹${minDeposit.toStringAsFixed(0)} - ₹${maxDeposit.toStringAsFixed(0)}";
      }
    }

    // For regular rent properties
    if (isRent) {
      final deposit = financialInfo?.propertySecurityDeposit ?? 0;
      return deposit > 0 ? "₹${deposit.toStringAsFixed(0)}" : null;
    }
    return null;
  }

  String? get brokerCommission {
    // PG properties typically don't have broker commission
    if (isPG) return null;

    final commission = financialInfo?.brokerCommission ?? 0;
    return commission > 0 ? "₹${commission.toStringAsFixed(0)}" : null;
  }

  /// 🔹 Get PG type display name with icon/badge info
  String get pgTypeDisplay {
    if (!isPG || pgInfo == null) return "";

    final pgFor = pgInfo!.pgFor?.toLowerCase() ?? "";
    final suitedFor = pgInfo!.pgSuitedFor?.toLowerCase() ?? "";

    if (pgFor.contains("boys")) return "Boys PG";
    if (pgFor.contains("girls")) return "Girls PG";
    if (pgFor.contains("unisex")) return "Unisex PG";

    if (suitedFor.contains("professional")) return "Professional PG";
    if (suitedFor.contains("student")) return "Student PG";
    if (suitedFor.contains("working")) return "Working PG";

    return "PG";
  }

  /// 🔹 Unified summary (adds only valid values, includes PG charges)
  Map<String, String?> get priceSummary {
    final summary = <String, String?>{};

    // For PG properties
    if (isPG) {
      summary["Room Rent"] = displayPrice;
      if (securityDeposit != null)
        summary["Security Deposit"] = securityDeposit;

      // Add PG-specific charges
      if (pgInfo != null) {
        final mealCharges = pgInfo!.mealChargesPerMonth ?? 0;
        final elecCharges = pgInfo!.electricityChargesPerMonth ?? 0;

        if (mealCharges > 0) {
          summary["Meal Charges"] =
              "₹${Formatter.formatPrice(mealCharges.toDouble())} /month";
        }
        if (elecCharges > 0) {
          summary["Electricity Charges"] =
              "₹${Formatter.formatPrice(elecCharges.toDouble())} /month";
        }
      }

      // Add notice & lock-in period
      if (noticePeriod != null) summary["Notice Period"] = noticePeriod;
      if (lockInPeriod != null) summary["Lock-in Period"] = lockInPeriod;

      return summary;
    }

    // For regular properties
    if (isRent) {
      summary["Rent / Month"] = displayPrice;
      if (securityDeposit != null) summary["Deposit"] = securityDeposit;
    } else {
      summary["Main Price"] = displayPrice;
      if (pricePerSqft != null) summary["Price per Sqft"] = pricePerSqft;
    }

    if (maintenance != null) summary["Maintenance"] = maintenance;
    if (brokerCommission != null) {
      summary["Broker Commission"] = brokerCommission;
    }

    return summary;
  }

  /// 🔹 Total combined amount (includes PG additional charges)
  double get totalAmount {
    double total = 0;

    // For PG properties - calculate from pg_info
    if (isPG) {
      // Use minimum room rent
      total += monthRent;

      // Add PG-specific monthly charges (meal + electricity)
      // if (pgInfo != null) {
      //   total += (pgInfo!.mealChargesPerMonth ?? 0).toDouble();
      //   total += (pgInfo!.electricityChargesPerMonth ?? 0).toDouble();
      // }

      // Note: Security deposit NOT included in monthly total
      // (it's one-time, shown separately)

      return total;
    }

    // For regular properties
    if (financialInfo == null) return 0.0;
    final fi = financialInfo!;

    if (isRent) {
      total += monthRent;
      total += fi.propertySecurityDeposit;
    } else {
      total += fi.price;
    }

    total += fi.maintenance ?? 0;
    total += fi.brokerCommission ?? 0;

    return total;
  }

  String get totalPriceDisplay {
    if (totalAmount <= 0) return "Total not available";
    return "${Formatter.formatPrice(totalAmount)}";
  }

  /// 🔹 Get breakdown of room types with prices (PG only)
  Map<String, String> get pgRoomBreakdown {
    final breakdown = <String, String>{};

    if (!isPG || pgInfo?.pgRoomInfo == null || pgInfo!.pgRoomInfo!.isEmpty) {
      return breakdown;
    }

    for (final room in pgInfo!.pgRoomInfo!) {
      final roomType = room.roomType ?? "Room";
      final rent = room.rent ?? 0;

      if (rent > 0) {
        breakdown[roomType] =
            "₹${Formatter.formatPrice(rent.toDouble())} /month";
      }
    }

    return breakdown;
  }

  /// 🔹 Check if PG has multiple room types
  bool get hasMultipleRoomTypes {
    if (!isPG || pgInfo?.pgRoomInfo == null) return false;

    final types =
        pgInfo!.pgRoomInfo!
            .map((r) => r.roomType)
            .where((t) => t != null && t.isNotEmpty)
            .toSet();

    return types.length > 1;
  }

  /// 🔹 Get average room price for PG
  double get averageRoomPrice {
    if (!isPG || pgInfo?.pgRoomInfo == null || pgInfo!.pgRoomInfo!.isEmpty) {
      return 0;
    }

    final rents =
        pgInfo!.pgRoomInfo!
            .map((r) => (r.rent ?? 0).toDouble())
            .where((r) => r > 0)
            .toList();

    if (rents.isEmpty) return 0;

    final sum = rents.reduce((a, b) => a + b);
    return sum / rents.length;
  }

  /// 🔹 Display average price (for comparison/sorting)
  String get averagePriceDisplay {
    final avg = averageRoomPrice;
    if (avg <= 0) return "N/A";
    return "₹${Formatter.formatPrice(avg)}";
  }

  /// 🔹 Get notice period (PG specific from financial_info)
  String? get noticePeriod {
    if (!isPG || financialInfo == null) return null;

    final notice = financialInfo!.noticePeriod ?? 0;
    if (notice <= 0) return null;

    return "$notice ${notice == 1 ? 'month' : 'months'}";
  }

  /// 🔹 Get lock-in period (PG specific from financial_info)
  String? get lockInPeriod {
    if (!isPG || financialInfo == null) return null;

    final lockIn = financialInfo!.lockInPeriod ?? 0;
    if (lockIn <= 0) return null;

    return "$lockIn ${lockIn == 1 ? 'month' : 'months'}";
  }

  /// 🔹 Get meal charges formatted
  String? get mealCharges {
    if (!isPG || pgInfo == null) return null;

    final charges = pgInfo!.mealChargesPerMonth ?? 0;
    if (charges <= 0) return null;

    return "₹${Formatter.formatPrice(charges.toDouble())}";
  }

  /// 🔹 Get electricity charges formatted
  String? get electricityCharges {
    if (!isPG || pgInfo == null) return null;

    final charges = pgInfo!.electricityChargesPerMonth ?? 0;
    if (charges <= 0) return null;

    return "₹${Formatter.formatPrice(charges.toDouble())}";
  }

  /// 🔹 Get PG meals offered
  String? get mealsOffered {
    if (!isPG || pgInfo == null) return null;
    return pgInfo!.pgMealOffered;
  }

  /// 🔹 Get PG common areas
  String? get commonAreas {
    if (!isPG || pgInfo == null) return null;
    return pgInfo!.pgCommonArea;
  }

  /// 🔹 Get PG managed by
  String? get managedBy {
    if (!isPG || pgInfo == null) return null;

    final manager = pgInfo!.pgManageBy;
    if (manager == null) return null;

    // Capitalize first letter
    return manager[0].toUpperCase() + manager.substring(1);
  }

  /// 🔹 Check if owner stays at PG
  bool get ownerStaysAtPg {
    if (!isPG || pgInfo == null) return false;
    return pgInfo!.pgOwnerStaysAtPg ?? false;
  }
}
