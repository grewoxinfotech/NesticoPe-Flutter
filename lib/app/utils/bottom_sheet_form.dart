// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:intl/intl.dart';

import '../../data/network/builder/model/builder_model.dart';
import '../../modules/add_property/view/create_property.dart';
import '../../modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import '../../widgets/New folder/inputs/dropdown_field.dart';
import 'formater/formater.dart';

class ContactOwnerBottom extends StatefulWidget {
  // final Items property;

  // Titles & Labels
  final String titleText;
  final String isProject;
  final String chatButtonText;
  final String formTitle;
  final bool isForSell;

  final double forRentPrice;
  final double forSellPrice;
  final String listingType;
  final String nameLabel;
  final String phoneLabel;
  final String propertyStatus;
  final String emailLabel;
  final String contactButtonText;
  final String termsText;

  final String termsClickableText;
  final bool inQuireSubmitted;
  final double? price;

  // Button Colors
  final Color chatButtonColor;
  final Color contactButtonColor;

  // Checkbox states
  final bool allowSellerContact;
  final bool negotiable;
  final bool bookSiteVisit;

  // Callbacks
  final VoidCallback? onChatPressed;
  final Function(
    String? name,
    String? phone,
    String? email,
    String? price,
    bool isNegotiable,
    bool isAllowAllCondition,
    String? inquiryType,
    bool isBookSiteVisit,

    String planningToBuy,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    Map<String, dynamic>? roomInfo,
    Map<String, dynamic>? selectedVarient,
  )?
  onContactPressed;
  final ValueChanged<bool?>? onAllowSellerContactChanged;
  final ValueChanged<bool?>? onHomeLoanInterestChanged;
  final ValueChanged<bool?>? onBookVisitChanged;

  // Icons
  final IconData nameIcon;
  List<PgRoomInfo>? pgRoomData;
  List<ProjectConfiguration>? projectConfiguration;

  final IconData phoneIcon;
  final IconData emailIcon;
  final Icon chatButtonIcon;

  ContactOwnerBottom({
    super.key,
    // required this.property,
    this.pgRoomData,
    this.projectConfiguration,
    this.price,
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
    this.allowSellerContact = false,
    this.negotiable = false,
    this.bookSiteVisit = false,
    this.onChatPressed,
    this.inQuireSubmitted = false,
    required this.propertyStatus,
    this.onContactPressed,
    this.onAllowSellerContactChanged,
    this.onHomeLoanInterestChanged,
    this.onBookVisitChanged,
    this.nameIcon = Icons.person_outline,
    this.phoneIcon = Icons.call,
    this.emailIcon = Icons.email_outlined,
    this.chatButtonIcon = const Icon(Icons.call, color: ColorRes.white),
    this.forRentPrice = 0.0,
    this.forSellPrice = 0,
    this.isForSell = false,
    required this.listingType,
    required this.isProject,
  });

  @override
  State<ContactOwnerBottom> createState() => _ContactOwnerBottomState();
}

class _ContactOwnerBottomState extends State<ContactOwnerBottom> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = 'Option 1';
  Map<String, dynamic> roomDetail = {};
  Map<String, dynamic> configuration = {};
  String selectedType = '';
  double miniPrice = 0.0;
  double currentPrice = 0.0;

  // TextControllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  TextEditingController _negotiablePriceController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Checkbox states
  late bool _allowSellerContact;
  late bool _negotiable;
  late bool _bookSiteVisit;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.isProject.toLowerCase() != "project") {
        if (widget.isForSell) {
          if (widget.listingType == "sell") {
            _negotiablePriceController.text = widget.forSellPrice.toString();
            miniPrice = widget.forSellPrice * 0.98;
            currentPrice = widget.forSellPrice;
            log("Current price ${currentPrice} ${miniPrice}");
          } else if (widget.listingType == "rent") {
            _negotiablePriceController.text = widget.forRentPrice.toString();
            miniPrice = widget.forRentPrice * 0.98;
            currentPrice = widget.forRentPrice;
          }
        } else {
          if (widget.listingType == "sell") {
            _negotiablePriceController.text = widget.forSellPrice.toString();
            miniPrice = widget.forSellPrice * 0.98;
            currentPrice = widget.forSellPrice;
          } else if (widget.listingType == "rent") {
            _negotiablePriceController.text = widget.forRentPrice.toString();
            miniPrice = widget.forRentPrice * 0.98;
            currentPrice = widget.forRentPrice;
          }
        }
      }
    });
    selectedType = widget.listingType;
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    _allowSellerContact = widget.allowSellerContact;

    _negotiable = widget.negotiable;
    _bookSiteVisit = widget.bookSiteVisit;

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
          _negotiablePriceController.text.trim(),
          _negotiable,
          _bookSiteVisit,

          selectedType,
          _allowSellerContact,

          dropdownValue,

          _selectedDate,
          _selectedTime,
          roomDetail,
          configuration,
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
    if (widget.inQuireSubmitted) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close button (top-right)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: ColorRes.primary,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Success Icon with animation potential
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorRes.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorRes.success.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: ColorRes.success,
                    size: 40,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              "Inquiry Already Submitted!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: AppFontWeights.bold,
                color: ColorRes.blueGrey,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle / message
            Text(
              "You've already submitted an inquiry for this property. The owner will contact you soon.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor,
                height: 1.6,
              ),
            ),

            // const SizedBox(height: 32),
            //
            // // Action button (always visible for better UX)
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: ColorRes.primary,
            //       foregroundColor: Colors.white,
            //       elevation: 0,
            //       shadowColor: Colors.transparent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //     ),
            //     onPressed: () => Get.back(),
            //     child: Text(
            //       "Got It",
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: AppFontWeights.semiBold,
            //         color: Colors.white,
            //         letterSpacing: 0.2,
            //       ),
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 8),
            //
            // // Optional: View My Inquiries link
            // TextButton(
            //   onPressed: () {
            //     Get.back();
            //     // Navigate to inquiries page
            //     // Get.toNamed(Routes.MY_INQUIRIES);
            //   },
            //   style: TextButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //   ),
            //   child: Text(
            //     "View My Inquiries",
            //     style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: AppFontWeights.medium,
            //       color: ColorRes.primary,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    } else if (widget.propertyStatus.toLowerCase() == "sold" &&
        widget.propertyStatus.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close button (top-right)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: ColorRes.primary,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Success Icon with animation potential
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorRes.homeYellow.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorRes.homeYellow.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber,
                    color: ColorRes.homeYellow,
                    size: 40,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              "Property Sold!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: AppFontWeights.bold,
                color: ColorRes.blueGrey,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle / message
            Text(
              "This property has been sold.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor,
                height: 1.6,
              ),),
              Text(
              "Please look for other properties.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.bodyMedium,
                color: ColorRes.textSecondary,
                height: 1.6,
              ),
            ),

            // const SizedBox(height: 32),
            //
            // // Action button (always visible for better UX)
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: ColorRes.primary,
            //       foregroundColor: Colors.white,
            //       elevation: 0,
            //       shadowColor: Colors.transparent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //     ),
            //     onPressed: () => Get.back(),
            //     child: Text(
            //       "Got It",
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: AppFontWeights.semiBold,
            //         color: Colors.white,
            //         letterSpacing: 0.2,
            //       ),
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 8),
            //
            // // Optional: View My Inquiries link
            // TextButton(
            //   onPressed: () {
            //     Get.back();
            //     // Navigate to inquiries page
            //     // Get.toNamed(Routes.MY_INQUIRIES);
            //   },
            //   style: TextButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //   ),
            //   child: Text(
            //     "View My Inquiries",
            //     style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: AppFontWeights.medium,
            //       color: ColorRes.primary,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    } else {
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
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.blueGrey,
              ),
            ),
            // const SizedBox(height: 12),
            //
            // // Owner info
            // Row(
            //   children: [
            //     CircleAvatar(
            //       radius: 20,
            //       backgroundColor: ColorRes.blueColor.shade100,
            //       backgroundImage: AssetImage(IMGRes.home2),
            //     ),
            //     const SizedBox(width: 12),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "${widget.property.ownerName}",
            //           style: TextStyle(
            //             fontWeight: AppFontWeights.semiBold,
            //             fontSize: 12,
            //           ),
            //         ),
            //         Text(
            //           "+91 ${widget.property.ownerPhone}",
            //           style: TextStyle(
            //             color: ColorRes.leadGreyColor,
            //             fontSize: 11,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            //
            // // WhatsApp button
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: widget.chatButtonColor,
            //     minimumSize: const Size(double.infinity, 48),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   icon: widget.chatButtonIcon,
            //   label: Text(
            //     widget.chatButtonText,
            //     style: const TextStyle(fontSize: 14, color: ColorRes.white),
            //   ),
            //   onPressed: widget.onChatPressed,
            // ),
            // const SizedBox(height: 14),
            //
            // // OR divider
            // Row(
            //   children: [
            //     Expanded(
            //       child: Divider(
            //         thickness: 0.5,
            //         color: ColorRes.grey.withOpacity(0.4),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: Text(
            //         "OR",
            //         style: TextStyle(fontSize: 10, color: ColorRes.grey),
            //       ),
            //     ),
            //     Expanded(
            //       child: Divider(
            //         thickness: 0.5,
            //         color: ColorRes.grey.withOpacity(0.4),
            //       ),
            //     ),
            //   ],
            // ),

            // const SizedBox(height: 12),
            // Text(
            //   widget.formTitle,
            //   style: TextStyle(
            //     fontSize: 13,
            //     fontWeight: AppFontWeights.semiBold,
            //   ),
            // ),
            const SizedBox(height: 20),

            // Name field
            TextFormField(
              controller: _nameController,
              style: TextStyle(fontSize: AppFontSizes.bodySmall),
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
              style: TextStyle(fontSize: AppFontSizes.bodySmall),
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
              style: TextStyle(fontSize: AppFontSizes.bodySmall),
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
            if (widget.isForSell) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedType == 'sell'
                                ? ColorRes.primary
                                : Colors.grey.shade300,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedType = 'sell';
                          _negotiablePriceController.text =
                              widget.forSellPrice.toString();
                          miniPrice = widget.forSellPrice * 0.98;
                          currentPrice = widget.forSellPrice;
                        });
                      },
                      child: Text(
                        'Interested for Sell',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: AppFontWeights.semiBold,
                          color:
                              selectedType == 'sell'
                                  ? Colors.white
                                  : ColorRes.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedType == 'rent'
                                ? ColorRes.success
                                : Colors.grey.shade300,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedType = 'rent';

                          _negotiablePriceController.text =
                              widget.forRentPrice.toString();
                          miniPrice = widget.forRentPrice * 0.98;
                          currentPrice = widget.forRentPrice;
                        });
                      },
                      child: Text(
                        'Interested for Rent',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: AppFontWeights.semiBold,
                          color:
                              selectedType == 'rent'
                                  ? Colors.white
                                  : ColorRes.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            if (widget.listingType.toLowerCase() == "pg") ...[
              NesticoPeDropdownField<String>(
                value: roomDetail?['roomType'],
                // store only the roomType
                hintText: "Select date",
                prefixIcon: Icons.calendar_today_outlined,
                items:
                    widget.pgRoomData?.map((date) {
                      return DropdownMenuItem<String>(
                        value: date.roomType,
                        child: Text(
                          '${capitalizeEachWord(date.roomType)} ${Formatter.formatPrice(num.tryParse(date.rent.toString()) ?? 0)}',
                          style: const TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      );
                    }).toList() ??
                    [],
                onChanged: (val) {
                  setState(() {
                    final selected = widget.pgRoomData!.firstWhere(
                      (d) => d.roomType == val,
                    );
                    currentPrice =
                        double.tryParse(selected.rent.toString()) ?? 0.0;
                    roomDetail = {
                      'roomType': selected.roomType,
                      'price': selected.rent,
                    };
                    _negotiablePriceController.text = selected.rent.toString();
                  });
                },
                darkText: true,
                validator: (value) => value == null ? "Required" : null,
              ),

              const SizedBox(height: 20),
            ],
            if (widget.isProject == 'project') ...[
              NesticoPeDropdownField<String>(
                value: configuration?['variantId'],
                hintText: "Choose a variant",
                prefixIcon: Icons.home_outlined,
                items:
                    widget.projectConfiguration
                        ?.expand(
                          (config) => config.variants.map((variant) {
                            return DropdownMenuItem<String>(
                              value: variant.variantId ?? variant.name,
                              child: Text(
                                '${variant.name.isNotEmpty ? variant.name : '${config.bhk} BHK'} - ${Formatter.formatPrice(variant.price)}',
                                style: const TextStyle(
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            );
                          }),
                        )
                        .toList() ??
                    [],
                onChanged: (val) {
                  setState(() {
                    // Find the selected variant from nested configs
                    final selectedConfig = widget.projectConfiguration!
                        .firstWhere(
                          (c) => c.variants.any(
                            (v) => v.variantId == val || v.name == val,
                          ),
                        );
                    final selectedVariant = selectedConfig.variants.firstWhere(
                      (v) => v.variantId == val || v.name == val,
                    );

                    currentPrice = selectedVariant.price;
                    miniPrice = selectedVariant.price * 0.98;
                    configuration = {
                      'bhk': selectedConfig.bhk,
                      'name': selectedVariant.name,
                      'price': selectedVariant.price,
                      'id': selectedVariant.variantId,
                    };
                    _negotiablePriceController.text =
                        selectedVariant.price.toString();
                  });
                },
                darkText: true,
                validator: (value) => value == null ? "Required" : null,
              ),

              const SizedBox(height: 20),
            ],

            Row(
              children: [
                Checkbox(
                  value: _negotiable,
                  side: BorderSide(color: ColorRes.grey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _negotiable = value ?? false;
                    });
                    if (widget.onHomeLoanInterestChanged != null) {
                      widget.onHomeLoanInterestChanged!(value);
                    }
                  },
                  activeColor: ColorRes.primary,
                ),
                Expanded(
                  child: Text("Negotiable", style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            if (_negotiable) ...[
              const SizedBox(height: 16),
              Text(
                "When are you planning to buy",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    [
                      'less than 1 month',
                      'less than 3 month',
                      'less than 6 month',
                      'less than 12 month',
                    ].map((option) {
                      return buildChoice(
                        title: option,
                        selected: dropdownValue == option,
                        onTap: () {
                          setState(() {
                            dropdownValue = option;
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              buildSectionTitle("Negotiable Price"),
              const SizedBox(height: 12),
              // TextFormField(
              //   controller: _negotiablePriceController,
              //   style: TextStyle(fontSize: AppFontSizes.bodySmall),
              //   decoration: InputDecoration(
              //     hintText: 'Enter your negotiable price',
              //     hintStyle: TextStyle(fontSize: AppFontSizes.small),
              //     labelStyle: TextStyle(
              //       fontSize: AppFontSizes.small,
              //       fontWeight: AppFontWeights.medium,
              //     ),
              //     prefixIcon: const Icon(Icons.currency_rupee_outlined, size: 18),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: const BorderSide(color: ColorRes.overlay),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: const BorderSide(color: ColorRes.overlay),
              //     ),
              //   ),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //
              //     if (value == null || value.trim().isEmpty) {
              //       return "Required";
              //     }
              //
              //     final enteredPrice = double.tryParse(value);
              //     if (enteredPrice == null) {
              //       return "Enter a valid amount";
              //     }
              //
              //     final originalPrice = int.tryParse(_negotiablePriceController.text)??0;
              //     final minAllowedPrice = originalPrice * 0.98;
              //     print("Price $originalPrice  $minAllowedPrice");
              //
              //     if (enteredPrice < minAllowedPrice || enteredPrice >= originalPrice) {
              //       return "Price must be between "
              //           "${Formatter.formatPrice(minAllowedPrice)} "
              //           "and ${Formatter.formatPrice(originalPrice)}";
              //     }
              //
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setState) {
                  log("Lst Current price ${currentPrice} ${miniPrice}");

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _negotiablePriceController,
                        style: TextStyle(fontSize: AppFontSizes.bodySmall),
                        decoration: InputDecoration(
                          hintText: 'Enter your negotiable price',
                          hintStyle: TextStyle(fontSize: AppFontSizes.small),
                          labelStyle: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.medium,
                          ),
                          prefixIcon: const Icon(
                            Icons.currency_rupee_outlined,
                            size: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: ColorRes.overlay,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: ColorRes.overlay,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }

                          final enteredPrice = num.tryParse(value);
                          if (enteredPrice == null) {
                            return "Enter a valid amount";
                          }

                          if (enteredPrice < miniPrice ||
                              enteredPrice > currentPrice) {
                            return "Price must be between "
                                "${Formatter.formatFullPrice(miniPrice)} "
                                "and ${Formatter.formatPrice(currentPrice)}";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      if (widget.listingType.toLowerCase() == "pg") ...[
                        Text(
                          "Base room price: ${Formatter.formatPrice(currentPrice)}",
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Negotiate on the selected room's price",
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.primary,
                          ),
                        ),
                      ] else ...[
                        Text(
                          "Original property price: ${Formatter.formatPrice(currentPrice)}",
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Minimum acceptable price (2% discount): ${Formatter.formatFullPrice(miniPrice)}",
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.primary,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],

            Row(
              children: [
                Checkbox(
                  value: _bookSiteVisit,
                  side: BorderSide(color: ColorRes.grey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _bookSiteVisit = value ?? false;
                    });
                    if (widget.onBookVisitChanged != null) {
                      widget.onBookVisitChanged!(value);
                    }
                  },
                  activeColor: ColorRes.primary,
                ),
                Expanded(
                  child: Text(
                    "Book Site Visit",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            if (_bookSiteVisit) ...[
              DateTimeDropdownExample(
                onChanged: (value) {
                  _selectedDate = DateFormat('dd MMM yyyy').parse(value.date);
                  final timeParts = value.time.split(' ');
                  final hourMinute = timeParts[0].split(':');
                  int hour = int.parse(hourMinute[0]);
                  final minute = int.parse(hourMinute[1]);
                  if (timeParts[1] == 'PM' && hour != 12) {
                    hour += 12;
                  } else if (timeParts[1] == 'AM' && hour == 12) {
                    hour = 0;
                  }
                  _selectedTime = TimeOfDay(hour: hour, minute: minute);
                },
              ),
              SizedBox(height: 8),
            ],
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
                    "I agree to be contacted by NesticoPe and agents via WhatsApp, SMS, phone, email etc",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Contact Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _allowSellerContact == true
                        ? widget.contactButtonColor
                        : Colors.grey.shade400,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _allowSellerContact == true ? _submitForm : null,
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorRes.leadGreyColor,
                  ),
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
            SizedBox(height: 50),
          ],

          // const SizedBox(height: 10),
        ),
      );
    }
  }
}

class DateTimeDropdownExample extends StatefulWidget {
  final void Function(SelectedDateTime value)? onChanged;

  const DateTimeDropdownExample({super.key, this.onChanged});

  @override
  State<DateTimeDropdownExample> createState() =>
      _DateTimeDropdownExampleState();
}

class _DateTimeDropdownExampleState extends State<DateTimeDropdownExample> {
  String? selectedDate;
  String? selectedTime;

  late List<String> dateList;
  final List<String> timeList = ['11:00 AM', '05:00 PM'];

  @override
  void initState() {
    super.initState();
    _generateDates();
  }

  void _generateDates() {
    final now = DateTime.now();

    dateList = List.generate(2, (index) {
      final date = now.add(Duration(days: 2 + index));
      return DateFormat('dd MMM yyyy').format(date);
    });
  }

  void _notifyParent() {
    if (selectedDate != null && selectedTime != null) {
      widget.onChanged?.call(
        SelectedDateTime(date: selectedDate!, time: selectedTime!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// DATE DROPDOWN
        // DropdownButtonFormField<String>(
        //   value: selectedDate,
        //   decoration: InputDecoration(
        //     hintText: 'Select date',
        //     hintStyle: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.medium),
        //     prefixIcon: const Icon(Icons.calendar_today_outlined, size: 14),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 0.5)),
        //   ),
        //   items:
        //       dateList
        //           .map(
        //             (date) => DropdownMenuItem(value: date, child: Text(date,style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.medium),)),
        //
        //           )
        //           .toList(),
        //   onChanged: (value) {
        //     setState(() => selectedDate = value);
        //     _notifyParent();
        //   },
        //   validator:
        //       (value) => value == null || value.isEmpty ? "Required" : null,
        // ),
        NesticoPeDropdownField<String>(
          value: selectedDate,
          hintText: "Select date",
          prefixIcon: Icons.calendar_today_outlined,
          items:
              dateList
                  .map(
                    (date) => DropdownMenuItem(
                      value: date,
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) {
            setState(() => selectedDate = val);
            _notifyParent();
          },
          darkText: true,
          validator:
              (value) => value == null || value.isEmpty ? "Required" : null,
        ),

        const SizedBox(height: 8),

        /// TIME DROPDOWN
        // DropdownButtonFormField<String>(
        //   value: selectedTime,
        //   decoration: InputDecoration(
        //     hintText: 'Select time',
        //     hintStyle: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.medium),
        //     prefixIcon: const Icon(Icons.access_time_outlined, size: 14),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: ColorRes.leadGreyColor.shade300,width: 0.5)),
        //   ),
        //   items:
        //       timeList
        //           .map(
        //             (time) => DropdownMenuItem(value: time, child: Text(time,style: TextStyle(fontSize: AppFontSizes.small,fontWeight: AppFontWeights.medium),)),
        //           )
        //           .toList(),
        //   onChanged: (value) {
        //     setState(() => selectedTime = value);
        //     _notifyParent();
        //   },
        //   validator:
        //       (value) => value == null || value.isEmpty ? "Required" : null,
        // ),
        NesticoPeDropdownField<String>(
          value: selectedTime,
          hintText: "Select time",
          prefixIcon: Icons.access_time_outlined,
          items:
              timeList
                  .map(
                    (time) => DropdownMenuItem(
                      value: time,
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) {
            setState(() => selectedTime = val);
            _notifyParent();
          },
          validator:
              (value) => value == null || value.isEmpty ? "Required" : null,
          darkText: true,
        ),
      ],
    );
  }
}

class SelectedDateTime {
  final String date;
  final String time;

  SelectedDateTime({required this.date, required this.time});
}
