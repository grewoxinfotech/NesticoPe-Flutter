// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

class ContactOwnerBottom extends StatefulWidget {
  final Items property;

  // Titles & Labels
  final String titleText;
  final String chatButtonText;
  final String formTitle;
  final String nameLabel;
  final String phoneLabel;
  final String emailLabel;
  final String contactButtonText;
  final String termsText;
  final String termsClickableText;

  // Button Colors
  final Color chatButtonColor;
  final Color contactButtonColor;

  // Checkbox states
  final bool allowSellerContact;
  final bool homeLoanInterest;

  // Callbacks
  final VoidCallback? onChatPressed;
  final Function(String? name, String? phone, String? email)? onContactPressed;
  final ValueChanged<bool?>? onAllowSellerContactChanged;
  final ValueChanged<bool?>? onHomeLoanInterestChanged;

  // Icons
  final IconData nameIcon;
  final IconData phoneIcon;
  final IconData emailIcon;
  final Icon chatButtonIcon;

  const ContactOwnerBottom({
    super.key,
    required this.property,
    this.titleText = "Contact Property Owner",
    this.chatButtonText = "Chat on WhatsApp",
    this.formTitle = "One Time Contact Form",
    this.nameLabel = "Your Name",
    this.phoneLabel = "Phone Number",
    this.emailLabel = "Email",
    this.contactButtonText = "Contact Owner",
    this.termsText = "By clicking above you agree to ",
    this.termsClickableText = "Terms & Conditions",
    this.chatButtonColor = ColorRes.success,
    this.contactButtonColor = ColorRes.primary,
    this.allowSellerContact = true,
    this.homeLoanInterest = false,
    this.onChatPressed,
    this.onContactPressed,
    this.onAllowSellerContactChanged,
    this.onHomeLoanInterestChanged,
    this.nameIcon = Icons.person_outline,
    this.phoneIcon = Icons.call,
    this.emailIcon = Icons.email_outlined,
    this.chatButtonIcon = const Icon(Icons.call, color: ColorRes.white),
  });

  @override
  State<ContactOwnerBottom> createState() => _ContactOwnerBottomState();
}

class _ContactOwnerBottomState extends State<ContactOwnerBottom> {
  final _formKey = GlobalKey<FormState>();

  // TextControllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  // Checkbox states
  late bool _allowSellerContact;
  late bool _homeLoanInterest;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    _allowSellerContact = widget.allowSellerContact;
    _homeLoanInterest = widget.homeLoanInterest;

    loadData(); // load actual user data asynchronously
  }

  Future<void> loadData() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      _nameController.text = user.user?.username ?? '';
      _phoneController.text = user.user?.phone ?? '';
      _emailController.text = user.user?.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // All fields valid
      if (widget.onContactPressed != null) {
        widget.onContactPressed!(
          _nameController.text.trim(),
          _phoneController.text.trim(),
          _emailController.text.trim(),
        );
      }
    } else {
      // Show error if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            widget.titleText,
            style: TextStyle(
              fontSize: 15,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.blueGrey,

            ),
          ),
          const SizedBox(height: 12),

          // Owner info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorRes.blueColor.shade100,
                backgroundImage: AssetImage(IMGRes.home2),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.property.ownerName}",
                    style: TextStyle(fontWeight: AppFontWeights.semiBold, fontSize: 12),
                  ),
                  Text(
                    "+91 ${widget.property.ownerPhone}",
                    style: TextStyle(color: ColorRes.leadGreyColor, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // WhatsApp button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.chatButtonColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: widget.chatButtonIcon,
            label: Text(
              widget.chatButtonText,
              style: const TextStyle(fontSize: 14, color: ColorRes.white),
            ),
            onPressed: widget.onChatPressed,
          ),
          const SizedBox(height: 14),

          // OR divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: ColorRes.grey.withOpacity(0.4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "OR",
                  style: TextStyle(fontSize: 10, color: ColorRes.grey),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: ColorRes.grey.withOpacity(0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.formTitle,
            style: TextStyle(fontSize: 13, fontWeight: AppFontWeights.semiBold),
          ),
          const SizedBox(height: 14),

          // Name field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: widget.nameLabel,
              labelStyle: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
              prefixIcon: Icon(widget.nameIcon, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorRes.overlay),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorRes.overlay),
              ),
            ),
            validator:
                (value) => value == null || value.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),

          // Phone field
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: widget.phoneLabel,
              labelStyle: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
              prefixIcon: Icon(widget.phoneIcon, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorRes.overlay),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorRes.overlay),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator:
                (value) => value == null || value.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: widget.emailLabel,
              labelStyle: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
              prefixIcon: Icon(widget.emailIcon, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorRes.overlay),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ColorRes.overlay),
              ),
            ),
            validator:
                (value) => value == null || value.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 20),

          // Checkboxes
          Row(
            children: [
              Checkbox(
                value: _allowSellerContact,
                side: BorderSide(color: ColorRes.grey, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) {
                  setState(() {
                    _allowSellerContact = value ?? false;
                  });
                  if (widget.onAllowSellerContactChanged != null) {
                    widget.onAllowSellerContactChanged!(value);
                  }
                },
                activeColor: ColorRes.primary,
              ),
              Expanded(
                child: Text(
                  "Allow sellers to get in touch",
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _homeLoanInterest,
                side: BorderSide(color: ColorRes.grey, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) {
                  setState(() {
                    _homeLoanInterest = value ?? false;
                  });
                  if (widget.onHomeLoanInterestChanged != null) {
                    widget.onHomeLoanInterestChanged!(value);
                  }
                },
                activeColor: ColorRes.primary,
              ),
              Expanded(
                child: Text(
                  "I am interested in Home loans",
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.contactButtonColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _submitForm,
            child: Text(
              widget.contactButtonText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.white,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Terms & Conditions Text
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: widget.termsText,
                style: const TextStyle(fontSize: 12, color: ColorRes.leadGreyColor),
                children: [
                  TextSpan(
                    text: widget.termsClickableText,
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
