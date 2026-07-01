import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
// import 'package:nesticope_app/widgets/input/nesticope_text_field.dart';
import 'package:nesticope_app/app/widgets/shimmer/shimmer_widget.dart';
import '../services/offer_inquiry_service.dart';

class OffersDiscountsScreen extends StatefulWidget {
  final String? userType;
  const OffersDiscountsScreen({super.key, this.userType});

  static const List<Map<String, dynamic>> allOffers = [
    {
      'id': 1,
      'title': 'Early Bird Buyer Discount',
      'description':
          'Get an exclusive 5% discount on your first property purchase. This limited-time offer is valid for new registered buyers who complete their profile within 48 hours.',
      'discount': '5% OFF',
      'userType': 'buyer',
      'image':
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'features': ['First Purchase', 'Verified Profiles', 'Limited Time'],
    },
    {
      'id': 2,
      'title': 'Seller Premium Listing Offer',
      'description':
          'Upgrade to a premium listing at 50% off. Perfect for individual owners looking to sell their properties faster with enhanced visibility and direct lead access.',
      'discount': '50% OFF',
      'userType': 'seller-owner',
      'image':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'features': ['Premium Badge', 'Top Placement', 'Advanced Analytics'],
    },
    {
      'id': 3,
      'title': 'Bulk Project Promotion for Builders',
      'description':
          'Special advertising packages for real estate builders. List multiple projects with a dedicated project manager and social media promotion campaign included.',
      'discount': 'UP TO 30% OFF',
      'userType': 'seller-builder',
      'image':
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'features': ['Project Branding', 'Lead Generation', 'Social Media Ads'],
    },
    {
      'id': 4,
      'title': 'Contractor Service Launch Offer',
      'description':
          'Are you a verified contractor? Register your services today and get your first month of service listing free of cost. Showcase your portfolio to thousands of users.',
      'discount': '1 MONTH FREE',
      'userType': 'contractor',
      'image':
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'features': ['Service Listing', 'Verified Badge', 'Portfolio Support'],
    },
    {
      'id': 5,
      'title': 'Partner Referral Program',
      'description':
          'Join our partner network and earn higher commissions. New partners get an additional 2% bonus on all successful referrals for the first 90 days.',
      'discount': '+2% BONUS',
      'userType': 'partner',
      'image':
          'https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'features': ['Bonus Earnings', 'Partner Dashboard', 'Direct Support'],
    },
  ];

  @override
  State<OffersDiscountsScreen> createState() => _OffersDiscountsScreenState();
}

class _OffersDiscountsScreenState extends State<OffersDiscountsScreen> {
  final RxList<int> submittedOfferIds = <int>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();

    _loadSubmittedInquiries();
  }

  Future<void> _loadSubmittedInquiries() async {
    try {
      isLoading.value = true;
      final userData = await SecureStorage.getUserData();
      final email = userData?.user?.email;
      final phone = userData?.user?.phone;

      for (var offer in OffersDiscountsScreen.allOffers) {
        final exists = await SecureStorage.hasOfferInquiry(
          offer['id'],
          email: email,
          phone: phone,
        );
        if (exists) {
          submittedOfferIds.add(offer['id']);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showInquiryDialog(Map<String, dynamic> offer) async {
    final userData = await SecureStorage.getUserData();
    String name =
        "${userData?.user?.firstName ?? ''} ${userData?.user?.lastName ?? ''}"
            .trim();
    if (name.isEmpty) {
      name = userData?.user?.username ?? "";
    }
    final email = userData?.user?.email ?? "";
    final phone = userData?.user?.phone ?? "";

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final RxBool isSubmitting = false.obs;

    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Get Offer Details",
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(50),
                        child: const Icon(
                          Icons.close_rounded,
                          color: ColorRes.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NesticoPeTextField(
                          controller: nameController,
                          title: "Name",
                          hintText: 'Enter your name',
                          prefixIcon: Icons.person_outline,
                          isRequired: true,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Name is required'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        NesticoPeTextField(
                          controller: emailController,
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          title: "Email",
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'Email is required';
                            if (!GetUtils.isEmail(value.trim()))
                              return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        NesticoPeTextField(
                          controller: phoneController,
                          hintText: 'Enter your phone number',
                          title: "Phone",
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isRequired: true,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return 'Phone is required';
                            if (!GetUtils.isPhoneNumber(value.trim()))
                              return 'Enter a valid phone number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border(
                      top: BorderSide(
                        color: ColorRes.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: ColorRes.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed:
                                isSubmitting.value
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        isSubmitting.value = true;

                                        final meta = {
                                          "offerTitle": offer['title'],
                                          "offerDiscount": offer['discount'],
                                          "userType": offer['userType'],
                                          "notes":
                                              "General Inquiry: Offer - ${offer['title']} (${offer['discount']}) for User Type: ${offer['userType']}.",
                                        };

                                        final response =
                                            await OfferInquiryService.submitOfferInquiry(
                                              name: nameController.text.trim(),
                                              email:
                                                  emailController.text.trim(),
                                              phone:
                                                  phoneController.text.trim(),
                                              meta: meta,
                                            );

                                        if (response['success'] == true) {
                                          final inquiryData = {
                                            'offerId': offer['id'],
                                            'email':
                                                emailController.text.trim(),
                                            'phone':
                                                phoneController.text.trim(),
                                            'date':
                                                DateTime.now()
                                                    .toIso8601String(),
                                          };
                                          await SecureStorage.addOfferInquiry(
                                            inquiryData,
                                          );
                                          submittedOfferIds.add(offer['id']);

                                          Get.back();
                                          Get.snackbar(
                                            'Success',
                                            response['message'] ??
                                                ((UserHelper.isBuyer ||
                                                        UserHelper.isGuest)
                                                    ? 'enquiry submitted successfully!'
                                                    : 'Inquiry submitted successfully!'),
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        } else {
                                          isSubmitting.value = false;
                                          Get.snackbar(
                                            'Error',
                                            response['message'] ??
                                                'Failed to submit inquiry',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                isSubmitting.value
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.send, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Submit Inquiry',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.medium,
                                            fontWeight: AppFontWeights.semiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    log('userType Frm Which Panel: ${widget.userType}');

    final filteredOffers =
        widget.userType == null
            ? OffersDiscountsScreen.allOffers
            : OffersDiscountsScreen.allOffers.where((offer) {
              final type = offer['userType'].toString().toLowerCase();
              final searchType = widget.userType!.toLowerCase();

              if (searchType == 'reseller') return type == 'partner';
              if (searchType == 'seller-owner') return type == 'seller-owner';
              if (searchType == 'seller-builder')
                return type == 'seller-builder';
              if (searchType == 'buyer') return type == 'buyer';
              if (searchType == 'contractor') return type == 'contractor';

              return false;
            }).toList();

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Offers & Discounts',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) => _buildShimmerCard(),
          );
        }

        if (filteredOffers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 64,
                  color: ColorRes.leadGreyColor[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No offers available for your profile',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: ColorRes.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredOffers.length,
          itemBuilder: (context, index) {
            return _buildOfferCard(filteredOffers[index]);
          },
        );
      }),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            height: 200,
            width: double.infinity,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  height: 20,
                  width: 200,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                ShimmerWidget(
                  height: 15,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  height: 15,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 20),
                Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ShimmerWidget(
                        height: 30,
                        width: 80,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ShimmerWidget(
                  height: 50,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  offer['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Discount Badge
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    offer['discount'],
                    style: const TextStyle(
                      color: ColorRes.error,
                      fontWeight: AppFontWeights.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              // UserType Badge
              Positioned(
                bottom: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        offer['userType'].toString().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  offer['title'],
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  offer['description'],
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Features
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      (offer['features'] as List<String>).map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.leadGreyColor[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorRes.leadGreyColor[200]!,
                            ),
                          ),
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorRes.leadGreyColor[700],
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),

                // Inquire Now Button
                Obx(() {
                  final isSubmitted = submittedOfferIds.contains(offer['id']);
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          isSubmitted ? null : () => _showInquiryDialog(offer),
                      icon: Icon(
                        isSubmitted ? Icons.check_circle : Icons.mail_outline,
                        size: 20,
                      ),
                      label: Text(
                       (UserHelper.isBuyer|| UserHelper.isGuest)?isSubmitted ? 'Enquiry Submitted' : 'Enquire Now' :isSubmitted ? 'Inquiry Submitted' : 'Inquire Now',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSubmitted
                                ? Colors.green
                                : const Color(0xFF4873D3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
