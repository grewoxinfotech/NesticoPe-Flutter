import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
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
  static Future<void> sendEmail(
    String email, {
    String subject = "",
    String body = "",
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: {
            if (subject.isNotEmpty) 'subject': subject,
            if (body.isNotEmpty) 'body': body,
          }.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&'),
    );

    await launchUrl(uri);
  }

  static Future<void> sendEmailWithOutReceiver({
    String? subject,
    String? body,
  }) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        queryParameters: {
          if (subject != null && subject.isNotEmpty) 'subject': subject,
          if (body != null && body.isNotEmpty) 'body': body,
        },
      );

      bool launched = false;
      try {
        launched = await launchUrl(emailUri, mode: LaunchMode.platformDefault);
      } catch (_) {
        launched = false;
      }

      if (!launched) {
        debugPrint("⚠️ Email app not available, opening Gmail web");
        await launchUrl(
          Uri.parse('https://mail.google.com/'),
          mode: LaunchMode.platformDefault,
        );
      }

      debugPrint("📧 Email composer opened");
    } catch (e, st) {
      debugPrint("❌ Failed to open email composer: $e");
      debugPrint("Stack: $st");
    }
  }

  /// Open WhatsApp chat
  static Future<void> openWhatsApp(
    String phoneNumber, {
    String message = "",
  }) async {
    final Uri uri = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  static void shareFeature(String url, String title) async {
    ShareResult shareResult = await SharePlus.instance.share(
      ShareParams(uri: Uri.parse(url), title: title),
    );
  }

  static Future<void> openPublicWhatsApp({
    String? phoneNumber,
    String message = "",
    bool shareToStatus = false,
  }) async {
    try {
      if (shareToStatus) {
        // Share to WhatsApp Status / Story
        final Uri statusUri = Uri.parse(
          "whatsapp://send?text=${Uri.encodeComponent(message)}",
        );

        await launchUrl(statusUri, mode: LaunchMode.platformDefault);
      } else if (phoneNumber != null && phoneNumber.isNotEmpty) {
        // Chat with specific number
        final Uri uri = Uri.parse(
          "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
        );

        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        // Share message directly in WhatsApp (no number)
        final Uri uri = Uri.parse(
          "whatsapp://send?text=${Uri.encodeComponent(message)}",
        );

        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint("WhatsApp share failed: $e");
    }
  }

  // static Future<void> openInstagram({
  //   String? storyImagePath,
  //   String? caption,
  // }) async {
  //   try {
  //     // --- 1️⃣ If image provided, share it via system sheet ---
  //     if (storyImagePath != null && File(storyImagePath).existsSync()) {
  //       await SharePlus.instance.share(
  //         ShareParams(files: [XFile(storyImagePath)], text: caption),
  //       );
  //       debugPrint("📸 Shared image to Instagram or other apps");
  //       return;
  //     }
  //
  //     // --- 2️⃣ Open Instagram app directly ---
  //     final Uri appUri = Uri.parse("instagram://app");
  //     final Uri webUri = Uri.parse("https://www.instagram.com/");
  //
  //     bool launched = false;
  //     try {
  //       launched = await launchUrl(appUri, mode: LaunchMode.platformDefault);
  //     } catch (_) {
  //       launched = false;
  //     }
  //
  //     // --- 3️⃣ If Instagram app not available, open web ---
  //     if (!launched) {
  //       await launchUrl(webUri, mode: LaunchMode.platformDefault);
  //     }
  //
  //     debugPrint("📱 Opened Instagram successfully");
  //   } catch (e, st) {
  //     debugPrint("❌ Failed to open Instagram: $e");
  //     debugPrint("Stack: $st");
  //   }
  // }

  static Future<void> shareToInstagramStory(String? link) async {
    try {
      final Uri storyUri = Uri.parse('instagram-stories://share');

      bool launched = false;
      try {
        launched = await launchUrl(storyUri, mode: LaunchMode.platformDefault);
      } catch (_) {
        launched = false;
      }

      if (!launched) {
        // Fallback to Instagram web with link
        await launchUrl(
          Uri.parse(link ?? 'https://www.instagram.com/'),
          mode: LaunchMode.platformDefault,
        );
      }

      debugPrint("📸 Opened Instagram story composer");
    } catch (e) {
      debugPrint("❌ Failed to open Instagram story: $e");
    }
  }

  /// Share image or content to Instagram feed (system share)
  static Future<void> shareToInstagramFeed(String? storyImagePath) async {
    try {
      if (storyImagePath != null && File(storyImagePath).existsSync()) {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(storyImagePath)], text: 'Check this out!'),
        );
        debugPrint("✅ Shared image to Instagram (system share sheet)");
      } else {
        // Just open Instagram app
        final Uri appUri = Uri.parse('instagram://app');
        final Uri webUri = Uri.parse('https://www.instagram.com/');

        bool launched = false;
        try {
          launched = await launchUrl(appUri, mode: LaunchMode.platformDefault);
        } catch (_) {
          launched = false;
        }

        if (!launched) {
          await launchUrl(webUri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (e) {
      debugPrint("❌ Failed to share to Instagram feed: $e");
    }
  }

  static Future<void> shareToFacebookStory(String? link) async {
    try {
      final Uri storyUri = Uri.parse('fb-stories://share');
      bool launched = false;

      try {
        launched = await launchUrl(
          storyUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {
        launched = false;
      }

      if (!launched) {
        // fallback to Facebook web or provided link
        await launchUrl(
          Uri.parse(link ?? 'https://www.facebook.com/'),
          mode: LaunchMode.externalApplication,
        );
      }

      debugPrint("📘 Opened Facebook Story composer");
    } catch (e) {
      debugPrint("❌ Failed to open Facebook story: $e");
    }
  }

  /// 🔹 Share image or text to Facebook Feed
  static Future<void> shareToFacebookFeed(
    String? imagePath, {
    String? caption,
  }) async {
    try {
      if (imagePath != null && File(imagePath).existsSync()) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(imagePath)],
            text: caption ?? 'Check this out!',
          ),
        );
        debugPrint("✅ Shared image via system share sheet (Facebook feed)");
      } else {
        // just open Facebook app
        final Uri appUri = Uri.parse('fb://feed');
        final Uri webUri = Uri.parse('https://www.facebook.com/');

        bool launched = false;
        try {
          launched = await launchUrl(
            appUri,
            mode: LaunchMode.externalApplication,
          );
        } catch (_) {
          launched = false;
        }

        if (!launched) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint("❌ Failed to share to Facebook feed: $e");
    }
  }

  static Future<void> shareContent({
    String? text, // Caption or message
    String? link, // Optional URL
    String? imagePath, // Optional image path
  }) async {
    try {
      // Combine text and link
      final shareText = [
        if (text != null) text,
        if (link != null) link,
      ].join('\n');

      if (imagePath != null && File(imagePath).existsSync()) {
        // 🖼️ Share with image
        await SharePlus.instance.share(
          ShareParams(text: shareText, files: [XFile(imagePath)]),
        );
      } else {
        // 📄 Share text only
        await SharePlus.instance.share(ShareParams(text: shareText));
      }

      debugPrint("✅ Shared content successfully");
    } catch (e, st) {
      debugPrint("❌ Failed to share content: $e");
      debugPrint("Stack: $st");

      // Fallback — open link directly if share fails
      if (link != null) {
        await launchUrl(Uri.parse(link), mode: LaunchMode.platformDefault);
      }
    }
  }
}
