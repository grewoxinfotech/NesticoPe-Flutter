// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../data/network/platform_service/platform_service_model.dart';
//
// class PlatformServiceHorizontalList extends StatelessWidget {
//   final List<PlatformServiceItem> services;
//   final double cardWidth;
//   final double cardHeight;
//   final void Function(PlatformServiceItem)? onTap;
//
//   const PlatformServiceHorizontalList({
//     super.key,
//     required this.services,
//     this.cardWidth = 250,
//     this.cardHeight = 200,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (services.isEmpty) {
//       return const SizedBox(
//         height: 180,
//         child: Center(child: Text("No services available")),
//       );
//     }
//
//     return SizedBox(
//       height: cardHeight,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: services.length,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemBuilder: (context, index) {
//           final service = services[index];
//           return GestureDetector(
//             onTap: () => onTap?.call(service),
//             child: Container(
//               width: cardWidth,
//               margin: const EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 color: ColorRes.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: ColorRes.leadGreyColor.shade200),
//               ),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Icon or placeholder
//                   Row(
//                     children: [
//                       Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           color: ColorRes.blueColor.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child:
//                             service.icon != null
//                                 ? Image.network(
//                                   service.icon!,
//                                   fit: BoxFit.contain,
//                                 )
//                                 : Icon(
//                                   Icons.home_work,
//                                   color: ColorRes.blueColor,
//                                 ),
//                       ),
//                       const SizedBox(width: 12),
//                       // Title
//                       Expanded(
//                         child: Text(
//                           service.title ?? '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontWeight: AppFontWeights.bold,
//                             fontSize: AppFontSizes.medium,
//                             color: ColorRes.textPrimary
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: ColorRes.primary.withOpacity(0.08),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           '#${index + 1}',
//                           style: TextStyle(
//                             fontWeight: AppFontWeights.semiBold,
//                             fontSize: AppFontSizes.small,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//                   // Description
//                   Text(
//                     service.description ?? '',
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: AppFontSizes.caption,
//                       color: ColorRes.blackShade54,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   if (service.features != null && service.features!.isNotEmpty)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children:
//                             service.features!
//                                 .take(2)
//                                 .map(
//                                   (f) => Container(
//                                     margin: const EdgeInsets.only(right: 6),
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 10,
//                                       vertical: 5,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: ColorRes.blueColor.shade50,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       f,
//                                       style: TextStyle(
//                                         fontSize: AppFontSizes.extraSmall,
//                                         color: ColorRes.blueColor,
//                                         fontWeight: AppFontWeights.medium,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                       ),
//                     ),
//                   Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(right: 6),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: service.isActive ?? false
//                               ? ColorRes.green
//                               : ColorRes.leadGreyColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         alignment: Alignment.center,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Circular dot
//                             Container(
//                               width: 8,
//                               height: 8,
//                               margin: const EdgeInsets.only(right: 6),
//                               decoration: BoxDecoration(
//                                 color: Colors.white, // dot color
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             // Status text
//                             Text(
//                               service.isActive ?? false ? "ACTIVE" : "INACTIVE",
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.extraSmall,
//                                 color: ColorRes.white,
//                                 fontWeight: AppFontWeights.semiBold ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         'Updated: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(service.updatedAt ?? ''),)}',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.extraSmall,
//                           color: ColorRes.leadGreyColor,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       )
//
//                     ],
//                   ),
//
//
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/builder/controller/project_controller.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/platform_service/platform_service_model.dart';
import 'package:nesticope_app/app/utils/helper_function/contact_helper.dart';
import 'package:nesticope_app/modules/home/controllers/contact_controller.dart';

class PlatformServiceHorizontalList extends StatefulWidget {
  final List<PlatformServiceItem> services;
  final double cardWidth;
  final double cardHeight;
  final void Function(PlatformServiceItem)? onTap;

  const PlatformServiceHorizontalList({
    super.key,
    required this.services,
    this.cardWidth = 270,
    this.cardHeight = 325,
    this.onTap,
  });
  @override
  State<PlatformServiceHorizontalList> createState() =>
      _PlatformServiceHorizontalListState();
}

class _PlatformServiceHorizontalListState
    extends State<PlatformServiceHorizontalList> {
  // Track expanded state for each service card
  final Map<int, bool> _expandedStates = {};
  // Track pressed state for contact button per card
  final Map<int, bool> _contactPressed = {};

  @override
  Widget build(BuildContext context) {
    if (widget.services.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No services available")),
      );
    }

    return SizedBox(
      height: widget.cardHeight + 15, // Increased height to accommodate shadow
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.services.length,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ), // Added vertical padding
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final service = widget.services[index];

          // final isExpanded = _expandedStates[index] ?? false;
          // final hasMoreFeatures = (service.features?.length ?? 0) > 2;
          return GestureDetector(
            onTap: () => widget.onTap?.call(service),
            child: Container(
              width: widget.cardWidth,
              // margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
                border: Border(
                  top: BorderSide(color: Color(0xffD3B674), width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon or placeholder
                  Row(
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          service.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: AppFontSizes.bodyMedium,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // Container(
                      //   padding: EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: ColorRes.primary.withOpacity(0.08),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: Text(
                      //     '#${index + 1}',
                      //     style: TextStyle(
                      //       fontWeight: AppFontWeights.semiBold,
                      //       fontSize: AppFontSizes.small,
                      //       color: ColorRes.primary,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Description
                  Text(
                    service.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.leadGreyColor.shade700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (service.features != null && service.features!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          service.features!.map((f) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,

                                  // shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 15,
                                      color: Color(0xffB38728),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          color: ColorRes.leadGreyColor[700],
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  Spacer(),

                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTapDown:
                        (_) => setState(() => _contactPressed[index] = true),
                    onTapCancel:
                        () => setState(() => _contactPressed[index] = false),
                    onTapUp:
                        (_) => setState(() => _contactPressed[index] = false),
                    onTap: () async {
                      try {
                        final id = service.id ?? '';
                        if (id.isNotEmpty) {
                          final already =
                              await SecureStorage.hasPlatformServiceInquiry(id);
                          if (already) {
                            final cc =
                                Get.isRegistered<ContactController>()
                                    ? Get.find<ContactController>()
                                    : Get.put(ContactController());
                            if (cc.primaryPhone.value.isEmpty) {
                              await cc.loadContacts(reset: true);
                            }
                            final number = cc.primaryPhone.value;
                            Get.dialog(
                              Dialog(
                                backgroundColor: ColorRes.white,
                                shape: RoundedRectangleBorder(
                          
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.check_circle,
                                              color: ColorRes.primary),
                                          SizedBox(width: 8),
                                          Text(
                                            'Thank You!',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.large,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                              color: ColorRes.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                       Text(
                                        'Your inquiry has been submitted successfully. Our support team will contact you shortly to discuss your needs.',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.leadGreyColor[700],
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (number.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(Icons.call,
                                                size: 18,
                                                color: ColorRes.primary),
                                            const SizedBox(width: 8),
                                            Text(number,
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.small,
                                                  color: ColorRes.leadGreyColor[700],
                                                  fontWeight: AppFontWeights.medium,
                                                )),
                                          ],
                                        ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: number.isNotEmpty
                                                  ? () async {
                                                      await ContactHelper
                                                          .openDialer(number);
                                                    }
                                                  : null,
                                              icon: const Icon(Icons.call),
                                              label: Text(
                                                'Call',
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.small,
                                                  color: Colors.white,
                                                  fontWeight: AppFontWeights.medium,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ColorRes.primary,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: number.isNotEmpty
                                                  ? () async {
                                                      await ContactHelper
                                                          .openWhatsApp(
                                                        number,
                                                        message:
                                                            'Hi, I already submitted an inquiry. I want to chat about ${service.title ?? 'service'}.',
                                                      );
                                                    }
                                                  : null,
                                              icon: Image.asset(
                                                'assets/images/whatsapp.png',
                                                width: 18,
                                                height: 18,
                                              ),
                                              label: Text(
                                                'Chat with Us',
                                                style: TextStyle(
                                                  fontSize: AppFontSizes.small,
                                                  color: ColorRes.primary,
                                                  fontWeight: AppFontWeights.medium,
                                                ),
                                              ),
                                              style:
                                                  OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: ColorRes.primary,
                                                ),
                                                foregroundColor:
                                                    ColorRes.primary,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('Close'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              barrierDismissible: true,
                            );
                            return;
                          }
                        }

                        final user = await SecureStorage.getUserData();

                        // if (user == null) {
                        //   NesticoPeSnackBar.showAwesomeSnackbar(
                        //     title: 'Error',
                        //     message: 'No user data found. Please log in.',
                        //     contentType: ContentType.failure,
                        //   );
                        //   return;
                        // }


                        final fullName = user?.user?.fullName ?? '';
                        final firstName = user?.user?.firstName ?? '';
                        final username = user?.user?.username ?? '';
                        final email = user?.user?.email ?? '';
                        final phone = user?.user?.phone ?? '';

                        final displayName =
                            (firstName.isEmpty ? username : fullName).trim();

                        if (Get.context == null) {
                          NesticoPeSnackBar.showAwesomeSnackbar(
                            title: 'Error',
                            message: 'UI not ready to show dialog.',
                            contentType: ContentType.failure,
                          );
                          return;
                        }

                        addInquiryFromProject(
                          displayName,
                          email,
                          phone,
                          service?.id ?? '',
                          'sell',
                          "home",
                        );

                        try {
                          final id2 = service.id ?? '';
                          if (id2.isNotEmpty) {
                            await SecureStorage.addPlatformServiceInquiry({
                              'serviceId': id2,
                              'email': email,
                              'phone': phone,
                              'success': true,
                            });
                          }
                        } catch (_) {}
                      } catch (e, s) {
                        debugPrint('❌ Error in Get Offer button: $e');
                        debugPrint('$s');

                        NesticoPeSnackBar.showAwesomeSnackbar(
                          title: 'Error',
                          message: 'Something went wrong. Please try again.',
                          contentType: ContentType.failure,
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            (_contactPressed[index] ?? false)
                                ? const Color(0xffBF953F)
                                : ColorRes.white,
                        border: Border.all(
                          color: const Color(0xffBF953F),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 18,
                            color:
                                (_contactPressed[index] ?? false)
                                    ? ColorRes.white
                                    : const Color(0xffBF953F),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'CONTACT NOW',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color:
                                  (_contactPressed[index] ?? false)
                                      ? ColorRes.white
                                      : const Color(0xffBF953F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void addInquiryFromProject(
  String name,
  String email,
  String phone,
  String propertyID,
  String propertyType,
  String type,
) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProjectController controller =
      Get.isRegistered<ProjectController>()
          ? Get.find<ProjectController>()
          : Get.put(ProjectController());

  final nameController = TextEditingController(text: name);
  final emailController = TextEditingController(text: email);
  final phoneController = TextEditingController(text: phone);

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
                        "Inquiry for Project Promotion & Marketing",
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
                flex: 1,
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Enter a valid email';
                          }
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone is required';
                          }
                          if (!GetUtils.isPhoneNumber(value.trim())) {
                            return 'Enter a valid phone number';
                          }
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
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // perform your submission logic here
                            final inquiry = {
                              "name": nameController.text ?? "",
                              "phone": phoneController.text ?? "",
                              "email": emailController.text ?? "",

                              "meta": {
                                "inquiryType": "$propertyType",
                                "type": "$type",
                                "propertyID": propertyID ?? '',
                              },
                            };

                            print('Submitting inquiry: ${inquiry}');

                            final success = await controller
                                .addForNesticoPeInquiry(inquiry);

                            if (success) {
                              if (UserHelper.isGuest) {
                                controller.hasSubmittedInquiry.value = true;
                                var inquiryData = {
                                  'property': propertyID,
                                  "email": emailController.text ?? "",
                                  "success": success,
                                };
                                final exists =
                                    await SecureStorage.hasPropertyInquiry(
                                      propertyID,
                                    );

                                if (!exists) {
                                  await SecureStorage.addPropertyInquiry(
                                    inquiryData,
                                  );
                                }
                              }
                              controller.hasSubmittedInquiry.value = true;
                              /*      CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Inquiry Added Successfully",
                                  type: SnackBarType.success,
                                );*/
                              Get.back();
                              // await controller.getAllInQuireData(
                              //   widget.projectItem?.id ?? '',
                              // );
                              // await controller.getHasInQuireData(
                              //   widget?.projectItem?.id ?? '',
                              // );
                            } else {
                              Get.back();
                              /* CustomSnackBar.show(
                                  Get.overlayContext!,
                                  message: "Failed to Submit Inquiry",
                                  type: SnackBarType.error,
                                );*/
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
