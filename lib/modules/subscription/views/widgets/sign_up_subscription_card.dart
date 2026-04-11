import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/home/controllers/contact_controller.dart';
import 'package:nesticope_app/app/utils/helper_function/contact_helper.dart';

class SignUpSubscriptionScreen extends StatefulWidget {
  final String title;
  final bool
  compact; // when true, render inline CTA card; otherwise show modal form
  final void Function(String name, String email, String phone) onSubmit;
  final bool showThankYou;
  final String? headingText;
  final String? subtitleText;
  final String? ctaText;
  

  const SignUpSubscriptionScreen({
    super.key,
    required this.title,
    required this.onSubmit,
    this.compact = false,
    this.showThankYou = false,
    this.headingText,
    this.subtitleText,
    this.ctaText,
  });

  @override
  State<SignUpSubscriptionScreen> createState() =>
      _SignUpSubscriptionScreenState();
}

class _SignUpSubscriptionScreenState extends State<SignUpSubscriptionScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _hasUserData = false;
  late final ContactController _contactController;

  @override
  void initState() {
    super.initState();
    _prefillFromSecureStorage();
    _contactController = Get.isRegistered<ContactController>()
        ? Get.find<ContactController>()
        : Get.put(ContactController());
    if (_contactController.primaryPhone.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _contactController.loadContacts(reset: true);
      });
    }
  }

  Future<void> _prefillFromSecureStorage() async {
    try {
      final UserModel? model = await SecureStorage.getUserData();
      final user = model?.user;
      if (user != null) {
        final parts =
            [
              user.firstName?.trim() ?? '',
              user.lastName?.trim() ?? '',
            ].where((e) => e.isNotEmpty).toList();
        final fullName = parts.join(' ').trim();
        if (fullName.isNotEmpty) {
          nameController.text = fullName;
        } else if ((user.username ?? '').trim().isNotEmpty) {
          nameController.text = (user.username ?? '').trim();
        }
        if ((user.email ?? '').trim().isNotEmpty) {
          emailController.text = (user.email ?? '').trim();
        }
        if ((user.phone ?? '').trim().isNotEmpty) {
          phoneController.text = (user.phone ?? '').trim();
        }
        _hasUserData = [
          user.firstName,
          user.lastName,
          user.username,
          user.email,
          user.phone,
        ].any((v) => (v ?? '').trim().isNotEmpty);
        if (mounted) setState(() {});
      }
    } catch (e) {
      log('Prefill error: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String heading =
        widget.headingText ?? 'Unlock ${widget.title} Plans';
    final String subtitle =
        widget.subtitleText ?? 'Fill your details to view pricing and features';
    final String cta = widget.ctaText ?? 'Unlock Plans';
    if (widget.compact) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront,
                color: ColorRes.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: ColorRes.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Start listing properties and earn more visibility',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => widget.onSubmit('', '', ''),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                elevation: 0,
              ),
              child: const Text('Get Started', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      );
    }

    if (widget.showThankYou) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
                    const SizedBox(height: 10),
                    const Text(
                      'Thank You!',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Thank you for your interest. Our support team will contact you shortly to help you start your journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(height: 1, width: double.infinity, color: ColorRes.leadGreyColor.shade200),
                    const SizedBox(height: 14),
                    Obx(() {
                      final phone = _contactController.primaryPhone.value;
                      return Column(
                        children: [
                          if (phone.isNotEmpty) ...[
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  await ContactHelper.openDialer(phone);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.phone, color: ColorRes.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      phone,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await ContactHelper.openWhatsApp(phone);
                                },
                                icon: const Icon(Icons.chat_bubble_outline_rounded),
                                label: const Text(
                                  'Chat with Us',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorRes.primary.withOpacity(0.08),
                                  foregroundColor: ColorRes.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Fetching contact details...',
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                          ]
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ColorRes.leadGreyColor.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        heading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorRes.leadGreyColor.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!_hasUserData) ...[
                      _field(
                        controller: nameController,
                        hint: 'Full Name',
                        keyboard: TextInputType.name,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Enter your name'
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: emailController,
                        hint: 'Email Address',
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter your email';
                          final ok = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(v);
                          return ok ? null : 'Enter a valid email';
                        },
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: phoneController,
                        hint: 'Phone Number',
                        keyboard: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter your phone';
                          return v.trim().length < 7
                              ? 'Enter a valid phone'
                              : null;
                        },
                      ),
                      const SizedBox(height: 14),
                    ] else ...[
                      const SizedBox(height: 18),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_hasUserData) {
                            if (formKey.currentState?.validate() ?? false) {
                              widget.onSubmit(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                phoneController.text.trim(),
                              );
                            }
                          } else {
                            widget.onSubmit(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              phoneController.text.trim(),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      child: Text(
                        cta,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    log('hint Text For TextFormField: $hint');

    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(
        color: ColorRes.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        hintStyle: TextStyle(
          color: ColorRes.leadGreyColor.shade500,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorRes.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// // import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';

// class SignUpSubscriptionScreen extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;

//   const SignUpSubscriptionScreen({
//     super.key,
//     required this.onTap,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Icon
//           Container(
//             height: 44,
//             width: 44,
//             decoration: BoxDecoration(
//               color: ColorRes.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(Icons.storefront, color: ColorRes.primary, size: 24),
//           ),

//           const SizedBox(width: 12),

//           // Title + Subtitle
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'Start listing properties and earn more visibility',
//                   style: TextStyle(color: Colors.black54, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 12),

//           // CTA Button
//           ElevatedButton(
//             onPressed: onTap,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ColorRes.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               elevation: 0,
//             ),
//             child: Row(
//               children: const [
//                 Text('Get Started', style: TextStyle(fontSize: 13)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
