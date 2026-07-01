// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/img_res.dart';
// import 'package:nesticope_app/app/widgets/image/custom_image.dart';
//
// import '../../../../app/constants/size_manager.dart';
//
// class CompareScreen extends StatelessWidget {
//   const CompareScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Compare Property')),
//       body: Padding(
//         padding: const EdgeInsets.all(AppPadding.medium),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Text("Compare Property"),
//               // SizedBox(height: AppSpacing.medium),
//               PropertyCardForCompare(
//                 label: "Property A",
//                 title: "3 BHK Apartment",
//                 image: IMGRes.home2,
//               ),
//               SizedBox(height: AppSpacing.small),
//               PropertyCardForCompare(
//                 label: "Property B",
//                 title: "2 BHK Apartment",
//                 image: IMGRes.home4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/modules/property/views/property_detail_screen.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/read_more_or_less.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/widgets/image/custom_image.dart' hide ColorRes;
import '../../../../app/manager/compare_manager.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/auth/model/user_model.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../data/network/property/services/property_contacted_service.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../auth/views/login_screen.dart';
import '../../../propert_detail/view/property_details.dart';
import '../../../property/controllers/property_controller.dart';

// class PropertyCardForCompare extends StatelessWidget {
//   final String image;
//   final String title;
//   final String label;
//   final String address;
//   final String price;
//
//   const PropertyCardForCompare({
//     super.key,
//     required this.title,
//     required this.label,
//     required this.image,
//     required this.address,
//     required this.price,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         border: Border.all(color: ColorRes.grey.withOpacity(0.2)),
//         borderRadius: BorderRadius.circular(AppRadius.medium),
//       ),
//       padding: EdgeInsets.all(AppPadding.small),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Property Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(AppRadius.small),
//             child: CustomImage(
//               type: CustomImageType.asset,
//               src: image,
//               height: 70,
//               width: 70,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           SizedBox(width: AppPadding.small),
//
//           // Property Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 SizedBox(
//                   width: 190 ,
//                   child: Text(
//                     address,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       fontWeight: AppFontWeights.regular,
//                       color: ColorRes.textSecondary,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.caption,
//                     fontWeight: AppFontWeights.medium,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 1,
//             height: 60,
//             color: ColorRes.leadGreyColor.withOpacity(0.2),
//           ),
//           SizedBox(width: 8),
//           // Price
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               price, // now dynamic instead of hardcoded
//               style: TextStyle(
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.bold,
//                 color: ColorRes.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class PropertyCardForCompare extends StatefulWidget {
  final Items item;
  final VoidCallback? onRemove;
  final bool isSubmitted;
  final bool isActive;

  const PropertyCardForCompare({
    super.key,
    required this.item,
    this.onRemove,
    required this.isSubmitted,
    this.isActive = false,
  });

  @override
  State<PropertyCardForCompare> createState() => _PropertyCardForCompareState();
}

class _PropertyCardForCompareState extends State<PropertyCardForCompare> {
  final PropertyController controller = Get.find<PropertyController>();
  final PropertyContactedService _contactedService = PropertyContactedService();

  String _firstImage(Items i) {
    final imgs = i.propertyMedia?.images;
    if (imgs != null && imgs.isNotEmpty) return imgs.first;
    return '';
  }

  String _title(Items i) {
    if ((i.type ?? '').toLowerCase() == 'residential') {
      final bhk = i.propertyDetails?.bhk ?? 0;

      if (bhk > 0) {
        return '${bhk} BHK ${i.propertyType?.capitalizeFirst ?? ''}';
      } else {
        return i.propertyType?.capitalizeFirst ?? '';
      }
    }

    return i.propertyType?.capitalizeFirst ?? (i.title ?? '');
  }

  String _price(Items i) {
    final pm = PropertyPriceManager(
      listingType: i.listingType ?? '',
      financialInfo: i.propertyDetails?.financialInfo,
      pgInfo: i.propertyDetails?.pgInfo, // Added for PG support
    );

    return pm.displayPrice;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => PropertyDetailScreen(propertyId: widget.item.id ?? ''));
        },
        child: Material(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),

          elevation: 1,
          shadowColor: ColorRes.black.withOpacity(0.06),
          child: Container(
            height: 115,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.isActive ? 14 : 12),
              boxShadow:
                  widget.isActive
                      ? [
                        BoxShadow(
                          color: ColorRes.primary.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 2,

                          offset: const Offset(0, 3),
                        ),
                      ],
              border:
                  widget.isActive
                      ? Border.all(color: ColorRes.primary, width: 2)
                      : null,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Image Section
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(11),
                      ),
                      child:
                          (_firstImage(widget.item).isNotEmpty)
                              ? CustomImage(
                                type: CustomImageType.network,
                                src: _firstImage(widget.item),
                                width: 120,
                                height: 121,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 120,
                                height: 121,
                                color: ColorRes.leadGreyColor.shade200,
                                child: const Icon(
                                  Icons.image,
                                  color: ColorRes.grey,
                                ),
                              ),
                    ),

                    // Content Section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title
                            Text(
                              _title(widget.item),
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textColor,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Address
                            Text(
                              widget.item.address ?? '-',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.leadGreyColor[600],
                                height: 1.3,
                                // fontSize: AppFontSizes.caption,
                                fontWeight: AppFontWeights.medium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Property Typ
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if ((widget.item.propertyDetails?.bhk ?? 0) > 0)
                                  Icon(
                                    Icons.bed_outlined,
                                    size: 12,
                                    color: const Color(0xFF2563EB),
                                  ),
                                const SizedBox(width: 4),
                                Text(
                                  (widget.item.propertyDetails?.bhk ?? 0) > 0
                                      ? '${widget.item.propertyDetails!.bhk} BHK'
                                      : '',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.extraSmall,
                                    fontWeight: AppFontWeights.medium,
                                    color: ColorRes.blackShade54,
                                  ),
                                ),
                              ],
                            ),

                            // Price Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    _price(widget.item),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.bold,
                                      color: ColorRes.textColor,
                                      height: 1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10),
                                if (widget.item.propertyStatus?.toLowerCase() ==
                                    "sold") ...[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorRes.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Property Sold',
                                        style: TextStyle(
                                          fontWeight: AppFontWeights.semiBold,
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  if (widget.isSubmitted) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorRes.success.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: ColorRes.success,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: ColorRes.success,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Submitted',
                                            style: TextStyle(
                                              color: ColorRes.success,
                                              fontSize: AppFontSizes.small,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    GestureDetector(
                                      onTap:
                                          (UserHelper.isGuest)
                                              ? ()  {
                                                // try {
                                                //   if (Get.context == null) {
                                                //     NesticoPeSnackBar.showAwesomeSnackbar(
                                                //       title: 'Error',
                                                //       message:
                                                //           'UI not ready to show dialog.',
                                                //       contentType:
                                                //           ContentType.failure,
                                                //     );
                                                //     return;
                                                //   }

                                                //   addInquiryFromApp(
                                                //     '',
                                                //     '',
                                                //     '',
                                                //     widget.item.id ?? '',
                                                //     widget.item.listingType ??
                                                //         '',
                                                //     'property' ?? '',

                                                //     controller,
                                                //   );
                                                // } catch (e, s) {
                                                //   debugPrint(
                                                //     '❌ Error in Get Offer button: $e',
                                                //   );
                                                //   debugPrint('$s');

                                                //   NesticoPeSnackBar.showAwesomeSnackbar(
                                                //     title: 'Error',
                                                //     message:
                                                //         'Something went wrong. Please try again.',
                                                //     contentType:
                                                //         ContentType.failure,
                                                //   );
                                                // }
                                                Get.to(() => LoginScreen());
                                              }
                                              : () async {
                                                try {
                                                  final user =
                                                      await SecureStorage.getUserData();

                                                  if (user == null) {
                                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                                      title: 'Error',
                                                      message:
                                                          'No user data found. Please log in.',
                                                      contentType:
                                                          ContentType.failure,
                                                    );
                                                    return;
                                                  }

                                                  final fullName =
                                                      user.user?.fullName ?? '';
                                                  final firstName =
                                                      user.user?.firstName ??
                                                      '';
                                                  final username =
                                                      user.user?.username ?? '';
                                                  final email =
                                                      user.user?.email ?? '';
                                                  final phone =
                                                      user.user?.phone ?? '';

                                                  final displayName =
                                                      (firstName.isEmpty
                                                              ? username
                                                              : fullName)
                                                          .trim();

                                                  if (Get.context == null) {
                                                    NesticoPeSnackBar.showAwesomeSnackbar(
                                                      title: 'Error',
                                                      message:
                                                          'UI not ready to show dialog.',
                                                      contentType:
                                                          ContentType.failure,
                                                    );
                                                    return;
                                                  }

                                                  addInquiryFromApp(
                                                    displayName,
                                                    email,
                                                    phone,
                                                    widget.item.id ?? '',
                                                    widget.item.listingType ??
                                                        '',
                                                    'property' ?? '',

                                                    controller,
                                                  );
                                                } catch (e, s) {
                                                  debugPrint(
                                                    '❌ Error in Get Offer button: $e',
                                                  );
                                                  debugPrint('$s');

                                                  NesticoPeSnackBar.showAwesomeSnackbar(
                                                    title: 'Error',
                                                    message:
                                                        'Something went wrong. Please try again.',
                                                    contentType:
                                                        ContentType.failure,
                                                  );
                                                }
                                              },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorRes.primary,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '${controller.hasSubmittedInquiry.value ? 'Submitted' : 'Contact Now'}',
                                          style: TextStyle(
                                            fontWeight: AppFontWeights.semiBold,
                                            fontSize: AppFontSizes.small,
                                            color: ColorRes.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Remove button
                if (widget.onRemove != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: widget.onRemove,
                      child: const Icon(
                        Icons.cancel,
                        color: ColorRes.error,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void addInquiryFromApp(
  String name,
  String email,
  String phone,
  String propertyID,
  String propertyType,
  String type,

  PropertyController controller,
) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        "Contact Seller",
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
                              "agreeToContact": true,
                              "meta": {
                                "inquiryType":
                                    "${propertyType.toLowerCase().replaceAll(" ", "_")}",

                                "type": "$type",
                              },
                            };

                            print('Submitting inquiry: ${inquiry}');

                            final success = await controller.addInquiry(
                              inquiry,
                              propertyID ?? '',
                            );

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
                              /* CustomSnackBar.show(
                                Get.overlayContext!,
                                message: "Inquiry Added Successfully",
                                type: SnackBarType.success,
                              );*/
                              Get.back();
                              await controller.getAllInQuireData(
                                propertyID ?? '',
                              );
                              await controller.getHasInQuireData(
                                propertyID ?? '',
                              );
                            } else {
                              Get.back();
                              /*CustomSnackBar.show(
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
                              'Send Enquiry',

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

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final PropertyController controller = Get.find<PropertyController>();
  final PropertyContactedService _contactedService = PropertyContactedService();
  final PageController _propertyCardsController = PageController(
    viewportFraction: 0.94,
  );
  final PageController _comparisonCardsController = PageController();
  int _currentPropertyCard = 0;
  String? _activePropertyId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final selected = CompareManager.to.selectedList;

      loadData(selected[0].id ?? '');
      loadDataSecond(selected[1].id ?? '');
    });
  }

  Future<void> loadData(String propertyId) async {
    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';
      controller.isComparePropertyFirst.value = await _contactedService
          .fetchHasInquiries(userId, itemId: propertyId);
    } catch (e, s) {
      log(
        '[PropertyDetail] ERROR in _loadData',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }
  }

  Future<void> loadDataSecond(String propertyId) async {
    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';

      final inquiries = await _contactedService.fetchContactedInquiries(userId);
      controller.inquiryResponse.assignAll(inquiries);

      final result = controller.inquiryResponse.any(
        (e) => e.propertyId == propertyId,
      );

      controller.isComparePropertySecond.value = result;
      // await controller.getAllInQuireData(propertyId);
      // await controller.getHasInQuireData(propertyId);
    } catch (e, s) {
      log(
        '[PropertyDetail] ERROR in _loadData',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }
  }

  void _syncTopWithBottom(int index) {
    if (!_propertyCardsController.hasClients) return;
    final current = _propertyCardsController.page?.round() ?? 0;
    if (current == index) return;
    _propertyCardsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _syncBottomWithTop(int index) {
    if (!_comparisonCardsController.hasClients) return;
    final current = _comparisonCardsController.page?.round() ?? 0;
    if (current == index) return;
    _comparisonCardsController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _propertyCardsController.dispose();
    _comparisonCardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Property Comparison',
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        actions: [
          if (CompareManager.to.selectedList.length < 5)
            TextButton(
              onPressed: () {
                Get.to(PropertyDetail());
              },
              child: Text(
                '+ Add',
                style: TextStyle(
                  // fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final selected = CompareManager.to.selectedList;

          // If no properties selected
          if (selected.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.compare_arrows,
                      size: 64,
                      color: ColorRes.leadGreyColor[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No properties selected',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.leadGreyColor[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select properties from home to compare',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.leadGreyColor[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // If only 1 property selected

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),

                SizedBox(
                  height: 132,
                  child: PageView.builder(
                    controller: _propertyCardsController,
                    itemCount: selected.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPropertyCard = index;
                      });
                      _syncBottomWithTop(index);
                    },
                    itemBuilder: (context, index) {
                      final item = selected[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PropertyCardForCompare(
                          item: item,
                          isActive: item.id == _activePropertyId,
                          isSubmitted: controller.isComparePropertyFirst.value,
                          onRemove: () {
                            CompareManager.to.remove(item.id ?? '');
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (selected.length > 1) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      selected.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _propertyCardsController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                          _syncBottomWithTop(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPropertyCard == index ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentPropertyCard == index
                                    ? ColorRes.primary
                                    : ColorRes.leadGreyColor.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
                  child: Text(
                    'Detailed Comparison',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ComparisonTable(
                  items: selected,
                  pageController: _comparisonCardsController,
                  currentPage: _currentPropertyCard,
                  onPageChanged: (index) {
                    _syncTopWithBottom(index);
                    setState(() {
                      _currentPropertyCard = index;
                    });
                  },
                  onActiveChange: (id) {
                    setState(() {
                      _activePropertyId = id;
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// class _PropertyCard extends StatelessWidget {
//   final String imagePath;
//   final String propertyName;
//   final String propertyType;
//   final String location;
//   final String price;
//   final String description;
//   final String sellerName;
//   final double sellerRating;
//   final int sellerReviews;
//   final String sellerAvatar;
//   final Color? priceColor;
//
//   const _PropertyCard({
//     required this.imagePath,
//     required this.propertyName,
//     required this.propertyType,
//     required this.location,
//     required this.price,
//     required this.description,
//     required this.sellerName,
//     required this.sellerRating,
//     required this.sellerReviews,
//     required this.sellerAvatar,
//     this.priceColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Property Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Container(
//               height: 120,
//               width: double.infinity,
//               color: Colors.grey[300],
//               child: const Icon(Icons.image, size: 50, color: Colors.grey),
//               // Use Image.asset(imagePath) for actual images
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   propertyName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$propertyType -',
//                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 ),
//                 Text(
//                   location,
//                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   price,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: priceColor ?? Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Seller Info
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: Colors.grey[300],
//                       child: const Icon(
//                         Icons.person,
//                         size: 20,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             sellerName,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.star,
//                                 size: 14,
//                                 color: Colors.amber,
//                               ),
//                               const SizedBox(width: 2),
//                               Text(
//                                 '$sellerRating ($sellerReviews',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               const SizedBox(width: 2),
//                               Text(
//                                 'reviews)',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Contact Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Contact Seller',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ComparisonTable extends StatelessWidget {
//   final Items a;
//   final Items b;
//
//   const _ComparisonTable({super.key, required this.a, required this.b});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.05),
//         //     blurRadius: 10,
//         //     offset: const Offset(0, 2),
//         //   ),
//         // ],
//       ),
//       child: Column(
//         children: [
//           // Header Row
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: ColorRes.leadGreyColor[200]!),
//               ),
//             ),
//
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Features',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.small,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     _title(a),
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     _title(b),
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: AppFontSizes.small,
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Comparison Rows
//           _ComparisonRow(
//             icon: Icons.home_outlined,
//             label: 'Property\nType',
//             valueA: a.propertyType ?? '-',
//             valueB: b.propertyType ?? '-',
//           ),
//           _ComparisonRow(
//             icon: Icons.location_on_outlined,
//             label: 'Location',
//             valueA: a.address ?? '-',
//             valueB: b.address ?? '-',
//           ),
//           _ComparisonRow(
//             icon: Icons.square_foot,
//             label: 'Built-up Area',
//             valueA: _area(a),
//             valueB: _area(b),
//             highlightB: _highlightB(
//               a,
//               b,
//               (x) => x.propertyDetails?.propertyBuiltUpArea ?? 0,
//             ),
//           ),
//           _ComparisonRow(
//             icon: Icons.bed_outlined,
//             label: 'Bedrooms',
//             valueA: (a.propertyDetails?.bhk ?? 0).toString(),
//             valueB: (b.propertyDetails?.bhk ?? 0).toString(),
//           ),
//           _ComparisonRow(
//             icon: Icons.bathtub_outlined,
//             label: 'Bathrooms',
//             valueA: (a.propertyDetails?.bathroom ?? 0).toString(),
//             valueB: (b.propertyDetails?.bathroom ?? 0).toString(),
//           ),
//           _ComparisonRow(
//             icon: Icons.layers_outlined,
//             label: 'Floor',
//             valueA: _floor(a),
//             valueB: _floor(b),
//           ),
//           _ComparisonRow(
//             icon: Icons.monetization_on_outlined,
//             label: 'Price/sq\nft',
//             valueA: _ppsf(a) ?? '-',
//             valueB: _ppsf(b) ?? '-',
//             highlightB: _highlightB(
//               a,
//               b,
//               (x) => x.propertyDetails?.financialInfo?.pricePerSqft ?? 0,
//             ),
//           ),
//           _ComparisonRow(
//             icon: Icons.checklist_rtl,
//             label: 'Amenities',
//             valueA: _amenities(a),
//             valueB: _amenities(b),
//             highlightB:
//                 (b.propertyDetails?.amenities?.length ?? 0) >
//                 (a.propertyDetails?.amenities?.length ?? 0),
//           ),
//           _ComparisonRow(
//             icon: Icons.price_change,
//             label: 'Price',
//             valueA:
//                 PropertyPriceManager(
//                   listingType: a.listingType ?? '',
//                   financialInfo: a.propertyDetails?.financialInfo,
//                 ).displayPrice,
//             valueB:
//                 PropertyPriceManager(
//                   listingType: b.listingType ?? '',
//                   financialInfo: b.propertyDetails?.financialInfo,
//                 ).displayPrice,
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// String _title(Items i) {
//   if ((i.type ?? '').toLowerCase() == 'residential') {
//     final bhk = i.propertyDetails?.bhk ?? 0;
//     return '${bhk} BHK ${i.propertyType?.capitalizeFirst ?? ''}';
//   }
//   return i.propertyType?.capitalizeFirst ?? (i.title ?? '');
// }
//
// String _area(Items i) {
//   final v = i.propertyDetails?.propertyBuiltUpArea;
//   if (v == null || v == 0) return '-';
//   final unit = i.propertyDetails?.propertyBuiltUpAreaUnit ?? 'sq.ft';
//   return '${v.toStringAsFixed(0)} $unit';
// }
//
// String? _ppsf(Items i) {
//   final v = i.propertyDetails?.financialInfo?.pricePerSqft ?? 0;
//   return v > 0 ? '₹${v.toStringAsFixed(0)}' : null;
// }
//
// String _floor(Items i) {
//   final f = i.propertyDetails?.floorInfo?.floorNumber;
//   final t = i.propertyDetails?.floorInfo?.totalFloors;
//   if (f == null && t == null) return '-';
//   if (f == null) return 'of ${t}';
//   if (t == null) return '${f}';
//   return '${f} of ${t}';
// }
//
// String _amenities(Items i) {
//   final a = i.propertyDetails?.amenities ?? [];
//   if (a.isEmpty) return '-';
//   return a.take(4).join(', ');
// }
//
// bool _highlightB(Items a, Items b, num Function(Items) pick) {
//   return pick(b) > pick(a);
// }
//
class _ComparisonRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valueA;
  final String valueB;
  final bool isAddress;
  final bool highlightB;
  final bool isLast;

  const _ComparisonRow({
    required this.icon,
    required this.label,
    required this.valueA,
    required this.valueB,
    this.isAddress = false,
    this.highlightB = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ),

          Expanded(
            child:
                (isAddress)
                    ? ReadMoreClass(
                      description: valueA,
                      trimLines: 3,
                      size: AppFontSizes.small,
                      colorClickableText: ColorRes.primary,
                    )
                    : Text(
                      valueA,

                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.textColor,
                      ),
                    ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding:
                  highlightB ? const EdgeInsets.symmetric(vertical: 6) : null,
              child:
                  (isAddress)
                      ? ReadMoreClass(
                        description: valueB,
                        trimLines: 3,
                        size: AppFontSizes.small,
                        colorClickableText: ColorRes.primary,
                      )
                      : Text(
                        valueB,

                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: ColorRes.textColor,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final List<Items> items;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<String>? onActiveChange;
  const _ComparisonTable({
    super.key,
    required this.items,
    required this.pageController,
    required this.currentPage,
    this.onPageChanged,
    this.onActiveChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 680,
          child: PageView.builder(
            controller: pageController,
            itemCount: items.length,

            onPageChanged: (i) {
              onPageChanged?.call(i);
              final item = items[i];
              if ((item.id ?? '').isNotEmpty) {
                onActiveChange?.call(item.id!);
              }
            },

            itemBuilder: (context, index) {
              final item = items[index];
              return _PropertyDetailsCard(item: item);
            },
          ),
        ),
        const SizedBox(height: 12),
        if (items.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  onPageChanged?.call(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        currentPage == index
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PropertyDetailsCard extends StatelessWidget {
  final Items item;
  const _PropertyDetailsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              color: ColorRes.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _title(item),
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: 5,
            children: [
              _basicRow('Property Type', item.propertyType ?? '-'),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow('Location', item.address ?? '-'),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow('Built-up Area', _area(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow(
                'Bedrooms',
                (item.propertyDetails?.bhk ?? 0).toString(),
              ),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow(
                'Bathrooms',
                (item.propertyDetails?.bathroom ?? 0).toString(),
              ),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow('Floor', _floor(item)),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow('Price/sq ft', _ppsf(item) ?? '-'),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow(
                'Price',
                PropertyPriceManager(
                  listingType: item.listingType ?? '',
                  financialInfo: item.propertyDetails?.financialInfo,
                  pgInfo: item.propertyDetails?.pgInfo, // Added for PG support
                ).displayPrice,
              ),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow(
                'Security Deposit',
                Formatter.formatPrice(
                  item
                          .propertyDetails
                          ?.financialInfo
                          ?.propertySecurityDeposit ??
                      0,
                ),
              ),
              Divider(color: ColorRes.leadGreyColor.shade300),
              _basicRow('Amenities', _amenities(item)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _basicRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,

              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// ---------------- Helper Functions ----------------
// --------------------------------------------------

bool _shouldHide(String? a, String? b) {
  bool empty(String? v) =>
      v == null || v.trim().isEmpty || v == '-' || v == '0';
  return empty(a) && empty(b);
}

String _title(Items i) {
  if ((i.type ?? '').toLowerCase() == 'residential') {
    final bhk = i.propertyDetails?.bhk ?? 0;

    if (bhk > 0) {
      return '${bhk} BHK ${i.propertyType?.capitalizeFirst ?? ''}';
    } else {
      return i.propertyType?.capitalizeFirst ?? '';
    }
  }

  return i.propertyType?.capitalizeFirst ?? (i.title ?? '');
}

String _area(Items i) {
  final v = i.propertyDetails?.propertyBuiltUpArea;
  if (v == null || v == 0) return '-';
  final unit = i.propertyDetails?.propertyBuiltUpAreaUnit ?? 'sq.ft';
  return '${v.toStringAsFixed(0)} $unit';
}

String? _ppsf(Items i) {
  final v = i.propertyDetails?.financialInfo?.pricePerSqft ?? 0;
  return v > 0 ? '₹${v.toStringAsFixed(0)}' : null;
}

String _floor(Items i) {
  final f = i.propertyDetails?.floorInfo?.floorNumber;
  final t = i.propertyDetails?.floorInfo?.totalFloors;
  if (f == null && t == null) return '-';
  if (f == null) return 'of $t';
  if (t == null) return '$f';
  return '$f of $t';
}

String _amenities(Items i) {
  final a = i.propertyDetails?.amenities ?? [];
  if (a.isEmpty) return '-';
  return a.take(4).join(', ');
}

bool _highlightB(Items a, Items b, num Function(Items) pick) {
  return pick(b) > pick(a);
}

Widget buildWishlistCard() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      borderRadius: BorderRadius.circular(12),
      color: ColorRes.white,
    ),
    child: Column(children: []),
  );
}
