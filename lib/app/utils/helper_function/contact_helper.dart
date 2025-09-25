import 'package:url_launcher/url_launcher.dart';

class ContactHelper {
  /// Open phone dialer
  static Future<void> openDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open dialer for $phoneNumber';
    }
  }

  /// Open email app
  static Future<void> sendEmail(String email, {String subject = "", String body = ""}) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      }.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&'),
    );

      await launchUrl(uri);

  }

  /// Open WhatsApp chat
  static Future<void> openWhatsApp(String phoneNumber, {String message = ""}) async {
    final Uri uri = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

      await launchUrl(uri, mode: LaunchMode.externalApplication);

  }
}
