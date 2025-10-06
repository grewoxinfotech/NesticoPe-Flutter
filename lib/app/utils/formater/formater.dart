import 'package:intl/intl.dart';

class Formatter {
  Formatter._();

  static String formatPriceIndian(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN', // Indian locale
      symbol: '₹', // Rupee symbol
      decimalDigits: 0, // No decimal for round prices
    );
    return formatter.format(value);
  }

  static String formatPriceCompact(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(0)} Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(0)} L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(0)} K';
    }
    return '₹$value';
  }


  static String formatPrice(num price) {
    String suffix = '';
    num value = price;
    String prefix = '₹';

    if (price >= 10000000 || price <= -10000000) {
      // 1 Crore = 1 Cr = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price >= 100000 || price <= -100000) {
      // 1 Lakh = 1 Lac = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price >= 1000 || price <= -1000) {
      // 1 Thousand
      value = price / 1000;
      suffix = 'K';
    } else {
      // Less than 1k, return with 2 decimal places
      return '$prefix ${price.toStringAsFixed(2)}';
    }

    // Remove trailing .0 for larger amounts
    String formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2);
    }

    return '$prefix $formatted$suffix';
  }

  static String formatPriceInternational(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
