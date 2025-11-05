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

import '../../../data/network/property/models/property_model.dart';
import '../../../modules/builder/view/builder_leads.dart' as Formatter;

class PropertyPriceManager {
  final String listingType; // "rent" or "sale"
  final FinancialInfo? financialInfo;

  PropertyPriceManager({
    required this.listingType,
    required this.financialInfo,
  });

  bool get isRent => listingType.toLowerCase() == "rent";

  double get monthRent {
    final rentPerMonth = financialInfo?.propertyRentPerMonth ?? 0;
    final monthlyRent = financialInfo?.monthlyRent ?? 0;

    if (rentPerMonth > 0) return rentPerMonth;
    if (monthlyRent > 0) return monthlyRent;

    return 0;
  }

  /// 🔹 Main display
  String get displayPrice {
    if (financialInfo == null) return "Price not available";

    if (isRent) {
      final rent = monthRent;
      if (rent <= 0) return "Price not available";
      return "${Formatter.formatPrice(rent)} /month";
    } else {
      final price = financialInfo!.price ?? 0;
      if (price <= 0) return "Price not available";
      final formatted = Formatter.formatPrice(price);
      return (financialInfo!.negotiable ?? false)
          ? "$formatted (Negotiable)"
          : formatted;
    }
  }

  String? get pricePerSqft {
    final ppsf = financialInfo?.pricePerSqft ?? 0;
    return ppsf > 0 ? "₹${ppsf.toStringAsFixed(0)}/sqft" : null;
  }

  String? get maintenance {
    final m = financialInfo?.maintenance ?? 0;
    return m > 0 ? "₹${m.toStringAsFixed(0)}" : null;
  }

  String? get securityDeposit {
    if (isRent) {
      final deposit = financialInfo?.propertySecurityDeposit ?? 0;
      return deposit > 0 ? "₹${deposit.toStringAsFixed(0)}" : null;
    }
    return null;
  }

  String? get brokerCommission {
    final commission = financialInfo?.brokerCommission ?? 0;
    return commission > 0 ? "₹${commission.toStringAsFixed(0)}" : null;
  }

  /// 🔹 Unified summary (only add existing values)
  Map<String, String?> get priceSummary {
    final summary = <String, String?>{};

    if (isRent) {
      summary["Rent / Month"] = displayPrice;
      if (securityDeposit != null) summary["Deposit"] = securityDeposit;
    } else {
      summary["Main Price"] = displayPrice;
      if (pricePerSqft != null) summary["Price per Sqft"] = pricePerSqft;
    }

    if (maintenance != null) summary["Maintenance"] = maintenance;
    if (brokerCommission != null)
      summary["Broker Commission"] = brokerCommission;

    return summary;
  }

  double get totalAmount {
    if (financialInfo == null) return 0.0;
    final fi = financialInfo!;
    double total = 0;

    if (isRent) {
      total += fi.propertyRentPerMonth ?? 0;
      total += fi.propertySecurityDeposit ?? 0;
    } else {
      total += fi.price ?? 0;
    }

    total += fi.maintenance ?? 0;
    total += fi.brokerCommission ?? 0;

    return total;
  }

  String get totalPriceDisplay {
    if (totalAmount <= 0) return "Total not available";
    return Formatter.formatPrice(totalAmount);
  }
}
