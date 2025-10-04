import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../data/network/property/models/property_model.dart';
import '../../utils/formater/formater.dart';

class PropertyPriceManager {
  final String listingType; // "rent" or "sale"
  final FinancialInfo financialInfo;

  PropertyPriceManager({
    required this.listingType,
    required this.financialInfo,
  });

  /// Returns the main price string (e.g., "₹12,000 /month" or "₹85,00,000")
  String get displayPrice {
    if (listingType.toLowerCase() == "rent") {
      return "${Formatter.formatPrice(financialInfo.propertyRentPerMonth)} /month";
    } else {
      String base = Formatter.formatPrice(financialInfo.price);
      return financialInfo.negotiable ? "$base (Negotiable)" : base;
    }
  }

  /// Returns price per sqft if available
  String? get pricePerSqft {
    if (financialInfo.pricePerSqft > 0) {
      return "₹${financialInfo.pricePerSqft.toStringAsFixed(0)}/sqft";
    }
    return null;
  }

  /// Returns maintenance charges
  String? get maintenance {
    if (financialInfo.maintenance != null && financialInfo.maintenance! > 0) {
      return "Maintenance: ₹${financialInfo.maintenance!.toStringAsFixed(0)}";
    }
    return null;
  }

  /// Returns deposit info (for rent cases)
  String? get securityDeposit {
    if (listingType.toLowerCase() == "rent" &&
        financialInfo.propertySecurityDeposit > 0) {
      return "Deposit: ₹${financialInfo.propertySecurityDeposit.toStringAsFixed(0)}";
    }
    return null;
  }

  /// Returns broker commission info
  String? get brokerCommission {
    if (financialInfo.brokerCommission > 0) {
      return "Brokerage: ₹${financialInfo.brokerCommission.toStringAsFixed(0)}";
    }
    return null;
  }
}
