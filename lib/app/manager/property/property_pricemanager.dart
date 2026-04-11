import '../../../data/network/property/models/property_model.dart';
import '../../constants/enum.dart';
import '../../utils/formater/formater.dart';

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

  /// 🔹 Returns maximum room rent for PG
  double get maxPgRent {
    if (isPG && pgInfo?.pgRoomInfo != null && pgInfo!.pgRoomInfo!.isNotEmpty) {
      final rents =
          pgInfo!.pgRoomInfo!.map((r) => r.rent ?? 0).where((r) => r > 0).toList();
      if (rents.isNotEmpty) {
        rents.sort();
        return rents.last.toDouble();
      }
    }
    return 0;
  }

  /// 🔹 Display only maximum price for PG (single value)
  String get maxPgPriceDisplay {
    if (!isPG) return displayPrice;
    final maxR = maxPgRent;
    if (maxR <= 0) return "Price not available";
    final maxFormatted = Formatter.formatPrice(maxR);
    
    return "$maxFormatted /month";
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
        final maxFormatted = Formatter.formatPrice(maxRent);

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
      return "$formatted /month";
    } else {
      final price = fi.price;
      if (price <= 0) return "Price not available";
      final formatted = Formatter.formatPrice(price);
      return (fi.negotiable) ? "$formatted" : "$formatted";
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

  Map<String, String> get propertyPriceSummary {
    final result = <String, String>{};

    // PG Properties
    if (isPG) {
      result[PricingKey.roomRent.label] = displayPrice;

      if (securityDeposit != null)
        result[PricingKey.securityDeposit.label] = securityDeposit!;

      if (pgInfo != null) {
        if ((pgInfo!.mealChargesPerMonth ?? 0) > 0) {
          result[PricingKey.mealCharges.label] =
              "₹${Formatter.formatPrice(pgInfo!.mealChargesPerMonth!.toDouble())} /month";
        }
        if ((pgInfo!.electricityChargesPerMonth ?? 0) > 0) {
          result[PricingKey.electricityCharges.label] =
              "₹${Formatter.formatPrice(pgInfo!.electricityChargesPerMonth!.toDouble())} /month";
        }
      }

      if (noticePeriod != null) {
        result[PricingKey.noticePeriod.label] = noticePeriod!;
      }
      if (lockInPeriod != null) {
        result[PricingKey.lockInPeriod.label] = lockInPeriod!;
      }

      return result;
    }

    // Regular Rent / Sale
    if (isRent) {
      result[PricingKey.rentPerMonth.label] = displayPrice;
      if (securityDeposit != null) {
        result[PricingKey.securityDeposit.label] = securityDeposit!;
      }
    } else {
      result[PricingKey.mainPrice.label] = displayPrice;
      if (pricePerSqft != null) {
        result[PricingKey.pricePerSqft.label] = pricePerSqft!;
      }
    }

    if (maintenance != null) {
      result[PricingKey.maintenance.label] = maintenance!;
    }
    if (brokerCommission != null) {
      result[PricingKey.brokerCommission.label] = brokerCommission!;
    }

    return result;
  }

  double get actualPrice {
    if (isRent) {
      return monthRent;
    } else {
      return financialInfo?.price ?? 0;
    }
  }
}
