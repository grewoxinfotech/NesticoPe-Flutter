import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import '../../../data/network/property/models/property_model.dart';

class PropertyPriceManager {
  final String listingType; // "rent" or "sale"
  final FinancialInfo? financialInfo;

  PropertyPriceManager({
    required this.listingType,
    required this.financialInfo,
  });

  /// Returns formatted main price display (₹12,000/month or ₹85L)
  String get displayPrice {
    if (financialInfo == null) return "Price not available";

    if (listingType.toLowerCase() == "rent") {
      final rent = financialInfo!.propertyRentPerMonth ?? 0;
      final formatted = Formatter.formatPrice(rent);
      return "$formatted /month";
    } else {
      final price = financialInfo!.price ?? 0;
      final formatted = Formatter.formatPrice(price);
      return financialInfo!.negotiable ? "$formatted (Negotiable)" : formatted;
    }
  }

  /// Returns price per sqft if available
  String? get pricePerSqft {
    final ppsf = financialInfo?.pricePerSqft ?? 0;
    return ppsf > 0 ? "₹${ppsf.toStringAsFixed(0)}/sqft" : null;
  }

  /// Returns maintenance info
  String? get maintenance {
    final m = financialInfo?.maintenance ?? 0;
    return m > 0 ? "Maintenance: ₹${m.toStringAsFixed(0)}" : null;
  }

  /// Returns security deposit info (for rentals)
  String? get securityDeposit {
    if (listingType.toLowerCase() == "rent") {
      final deposit = financialInfo?.propertySecurityDeposit ?? 0;
      return deposit > 0 ? "Deposit: ₹${deposit.toStringAsFixed(0)}" : null;
    }
    return null;
  }

  /// Returns broker commission info
  String? get brokerCommission {
    final commission = financialInfo?.brokerCommission ?? 0;
    return commission > 0
        ? "Brokerage: ₹${commission.toStringAsFixed(0)}"
        : null;
  }

  /// 🔹 Combine all info for UI display
  Map<String, String?> get priceSummary => {
    "Main Price": displayPrice,
    "Price per Sqft": pricePerSqft,
    "Maintenance": maintenance,
    "Deposit": securityDeposit,
    "Broker Commission": brokerCommission,
  };

  // ---------------------------------------------------
  // 🔹 NEW: Compute total of all available charges
  // ---------------------------------------------------
  double get totalAmount {
    if (financialInfo == null) return 0.0;

    final fi = financialInfo!;
    double total = 0.0;

    // Base price or rent
    if (listingType.toLowerCase() == "rent") {
      total += fi.propertyRentPerMonth ?? 0;
      total += fi.propertySecurityDeposit ?? 0;
    } else {
      total += fi.price ?? 0;
    }

    // Add other charges
    total += fi.maintenance ?? 0;
    total += fi.brokerCommission ?? 0;

    return total;
  }

  /// 🔹 Formatted total display string
  String get totalPriceDisplay {
    if (totalAmount <= 0) return "Total not available";
    return "${Formatter.formatPrice(totalAmount)}";
  }
}
