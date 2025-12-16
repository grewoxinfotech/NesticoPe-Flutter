// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:intl/intl.dart';

import '../../modules/add_property/view/create_property.dart';
import 'formater/formater.dart';

class ContactOwnerBottom extends StatefulWidget {
  // final Items property;

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
    bool isBookSiteVisit,
    String planningToBuy,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  )?
  onContactPressed;
  final ValueChanged<bool?>? onAllowSellerContactChanged;
  final ValueChanged<bool?>? onHomeLoanInterestChanged;
  final ValueChanged<bool?>? onBookVisitChanged;

  // Icons
  final IconData nameIcon;
  final IconData phoneIcon;
  final IconData emailIcon;
  final Icon chatButtonIcon;

  const ContactOwnerBottom({
    super.key,
    // required this.property,
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
    this.onContactPressed,
    this.onAllowSellerContactChanged,
    this.onHomeLoanInterestChanged,
    this.onBookVisitChanged,
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

  String dropdownValue = 'Option 1';

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
          _allowSellerContact,
          dropdownValue,
          _selectedDate,
          _selectedTime,
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
                fontSize: 15,
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
            const SizedBox(height: 14),

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
              SizedBox(height: 16),
              Text(
                "When are you planning to buy",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textSecondary,
                ),
              ),
              SizedBox(height: 12),
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
                  prefixIcon: Icon(Icons.currency_rupee_outlined, size: 18),
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required";
                  }

                  final enteredPrice = double.tryParse(value);
                  if (enteredPrice == null) {
                    return "Enter a valid amount";
                  }

                  final originalPrice = widget.price!;

                  // Calculate 2% lower limit
                  final minAllowedPrice = originalPrice * 0.98;

                  if (enteredPrice < minAllowedPrice ||
                      enteredPrice >= originalPrice) {
                    return "Price must be between "
                        "${Formatter.formatPrice(minAllowedPrice)} "
                        "and ${Formatter.formatPrice(originalPrice)}";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
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
  final List<String> timeList = ['10:00 AM', '04:00 PM'];

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
        DropdownButtonFormField<String>(
          value: selectedDate,
          decoration: InputDecoration(
            hintText: 'Select date',
            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items:
              dateList
                  .map(
                    (date) => DropdownMenuItem(value: date, child: Text(date)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() => selectedDate = value);
            _notifyParent();
          },
          validator:
              (value) => value == null || value.isEmpty ? "Required" : null,
        ),

        const SizedBox(height: 8),

        /// TIME DROPDOWN
        DropdownButtonFormField<String>(
          value: selectedTime,
          decoration: InputDecoration(
            hintText: 'Select time',
            prefixIcon: const Icon(Icons.access_time_outlined, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items:
              timeList
                  .map(
                    (time) => DropdownMenuItem(value: time, child: Text(time)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() => selectedTime = value);
            _notifyParent();
          },
          validator:
              (value) => value == null || value.isEmpty ? "Required" : null,
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
