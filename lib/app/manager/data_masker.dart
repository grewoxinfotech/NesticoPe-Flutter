/// Centralized class for masking sensitive user data
class DataMasker {
  // 🔹 Mask phone number (keep last 2 or 3 visible)
  static String maskPhone(String? phone, {int visibleDigits = 2}) {
    if (phone == null || phone.isEmpty) return "";
    if (phone.length <= visibleDigits) return phone;
    final masked = "*" * (phone.length - visibleDigits);
    return "$masked${phone.substring(phone.length - visibleDigits)}";
  }

  // 🔹 Mask email (keep first letter and domain visible)
  static String maskEmail(String? email) {
    if (email == null || !email.contains('@')) return "";
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return "${name[0]}***@$domain";
    return "${name[0]}${"*" * (name.length - 2)}${name[name.length - 1]}@$domain";
  }

  // 🔹 Mask Aadhaar or other ID numbers
  static String maskId(String? id, {int visibleDigits = 4}) {
    if (id == null || id.isEmpty) return "";
    if (id.length <= visibleDigits) return id;
    final masked = "*" * (id.length - visibleDigits);
    return "$masked${id.substring(id.length - visibleDigits)}";
  }

  // 🔹 Mask PAN (format: AAAAA9999A)
  static String maskPAN(String? pan) {
    if (pan == null || pan.isEmpty) return "";
    if (pan.length < 10) return maskId(pan);
    return "*****${pan.substring(5)}";
  }

  // 🔹 Mask Bank Account (keep last 3 or 4 visible)
  static String maskBankAccount(String? account, {int visibleDigits = 4}) {
    if (account == null || account.isEmpty) return "";
    if (account.length <= visibleDigits) return account;
    final masked = "*" * (account.length - visibleDigits);
    return "$masked${account.substring(account.length - visibleDigits)}";
  }

  // 🔹 Mask Card Number (e.g., 4111 2233 3344 5566 → **** **** **** 5566)
  static String maskCardNumber(String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) return "";
    final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.length <= 4) return clean;
    final masked = "**** " * ((clean.length - 4) ~/ 4);
    return "$masked${clean.substring(clean.length - 4)}";
  }

  // 🔹 Generic custom masker
  static String maskCustom(String? text, {int start = 0, int end = 0}) {
    if (text == null || text.isEmpty) return "";
    if (start + end >= text.length) return text;
    final masked = "*" * (text.length - (start + end));
    return "${text.substring(0, start)}$masked${text.substring(text.length - end)}";
  }


  static String maskName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return "Owner";
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final maskedParts =
        parts.map((name) {
          if (name.length <= 2) return "${name[0]}*";
          return "${name[0]}${"*" * (name.length - 2)}${name[name.length - 1]}";
        }).toList();
    return maskedParts.join(" ");
  }
}
