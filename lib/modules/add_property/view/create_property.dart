import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/model/add_property_model.dart';
import 'package:housing_flutter_app/modules/add_property/payloads/edit_property/load_edit_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/basic_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/photo_upload.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/post_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/advance_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/amenities.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/price_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/verify_section_add.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/review_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/room_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/step_row.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/stepper_property.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../search_property/controller/search_controller.dart';

class CreatePropertyScreen extends StatelessWidget {
  // final SellerType sellerType;
  final bool isEdit;
  final AddPropertyModel? property;
  final bool isLogin;

  const CreatePropertyScreen({
    super.key,
    // required this.sellerType,
    this.isLogin = false,
    this.isEdit = false,
    this.property,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePropertyController());
    final GoogleMapSearchController controllerCity = Get.put(
      GoogleMapSearchController(),
      tag: 'city',
    );

    if (isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final editController = Get.put(LoadEditPropertyPayload());
        if (property != null) {
          controller.isEdited.value = isEdit;
          log('Editing value : ${controller.isEdited.value}');
          editController.onLoad(controller, property ?? AddPropertyModel());
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLogin) {
        controller.isLogin.value = isLogin;
      }
    });

    return Obx(() {
      // Generate form keys based on current property type and looking to values
      final List<GlobalKey<FormState>?> formKeys = List.generate(
        controller.stepsList.length,
        (index) {
          final propertyType = controller.propertyType.value;
          final lookingTo = controller.lookingTo.value;

          // Residential + Rent: Steps 0-4 need validation
          if (propertyType == 'Residential' && lookingTo == 'Rent') {
            return [0, 1, 2, 3, 4].contains(index)
                ? GlobalKey<FormState>()
                : null;
          }

          // Residential + Sell: Steps 0-4 need validation
          if (propertyType == 'Residential' && lookingTo == 'Sell') {
            return [0, 1, 2, 3, 4].contains(index)
                ? GlobalKey<FormState>()
                : null;
          }

          // Residential + PG/Co-Living: Steps 0-3 need validation
          if (propertyType == 'Residential' && lookingTo == 'PG/Co-Living') {
            return [0, 1, 2, 3].contains(index) ? GlobalKey<FormState>() : null;
          }

          // Commercial + Rent: Steps 0-2, 4 need validation
          if (propertyType == 'Commercial' && lookingTo == 'Rent') {
            return [0, 1, 2, 4].contains(index) ? GlobalKey<FormState>() : null;
          }

          // Commercial + Sell: Steps 0-2, 4 need validation
          if (propertyType == 'Commercial' && lookingTo == 'Sell') {
            return [0, 1, 2, 4].contains(index) ? GlobalKey<FormState>() : null;
          }

          // Default: validate first 5 steps
          return index < 5 ? GlobalKey<FormState>() : null;
        },
      );

      print("Form keys length: ${formKeys.length}");

      if (controller.isLogin.value) {
        return Scaffold(
          backgroundColor: ColorRes.addPropertyBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder:
                  (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: ColorRes.addPropertyBackgroundColor,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorRes.leadGreyColor.shade300,
                                    ),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        if (controller
                                                .stepperSelectedIndex
                                                .value ==
                                            0) {
                                          // If on the first step, pop the screen
                                          Navigator.pop(context);
                                        } else {
                                          // Otherwise, go to previous step
                                          controller.previousStep();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: ColorRes.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Create Listing",
                                    style: TextStyle(
                                      color: ColorRes.white,
                                      fontSize: AppFontSizes.large,
                                      fontWeight: AppFontWeights.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: const BoxDecoration(
                                color: ColorRes.addPropertyBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    "Sell or rent your property faster",
                                    style: TextStyle(
                                      color: ColorRes.white,
                                      fontSize: AppFontSizes.body,
                                      fontWeight: AppFontWeights.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: ColorRes.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: StepChipsRow(
                                          selectedIndex:
                                              controller
                                                  .stepperSelectedIndex
                                                  .value,
                                          steps: controller.stepsList,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Obx(() {
                                        final step =
                                            controller
                                                .stepperSelectedIndex
                                                .value;
                                        // Get current form key (or create dummy if none exists)
                                        final currentFormKey =
                                            (step < formKeys.length &&
                                                    formKeys[step] != null)
                                                ? formKeys[step]!
                                                : GlobalKey<FormState>();

                                        if (step == 0) {
                                          return BasicDetail(
                                            controller: controller,
                                            formKey: currentFormKey,
                                          );
                                        }
                                        log('jhvfdhvfys $step');

                                        if (controller.lookingTo.value ==
                                            'PG/Co-Living') {
                                          switch (step) {
                                            case 1:
                                              return PostProperty(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 2:
                                              return RoomDetail(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 3:
                                              return RentAmenities(
                                                controller: controller,
                                              );
                                            case 4:
                                              return PhotoUpload(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 5:
                                              return ListingReviewCard(
                                                controller: controller,
                                              );
                                            default:
                                              return Container();
                                          }
                                        } else if ((controller
                                                        .lookingTo
                                                        .value ==
                                                    'Rent' ||
                                                controller.lookingTo.value ==
                                                    'Sell') &&
                                            controller.propertyType.value ==
                                                "Residential") {
                                          switch (step) {
                                            case 1:
                                              return PostProperty(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 2:
                                              return RentPriceDetail(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 3:
                                              return PhotoUpload(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 4:
                                              return RentAdvanceDetail(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 5:
                                              return RentAmenities(
                                                controller: controller,
                                              );
                                            case 6:
                                              return ReviewPropertyScreen(
                                                controller: controller,
                                              );
                                          }
                                        } else if ((controller
                                                        .lookingTo
                                                        .value ==
                                                    "Rent" ||
                                                controller.lookingTo.value ==
                                                    "Sell") &&
                                            controller.propertyType.value ==
                                                "Commercial") {
                                          print(
                                            'current step ${controller.stepsList[step]}',
                                          );
                                          switch (step) {
                                            case 1:
                                              return PostProperty(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 2:
                                              return RentPriceDetail(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 3:
                                              return RentAmenities(
                                                controller: controller,
                                              );
                                            case 4:
                                              return PhotoUpload(
                                                controller: controller,
                                                formKey: currentFormKey,
                                              );
                                            case 5:
                                              return ListingReviewCard(
                                                controller: controller,
                                              );
                                            default:
                                              return Container();
                                          }
                                        }
                                        return Container();
                                      }),
                                    ),
                                  ],
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

          // --- Full screen loader overlay ---
          bottomNavigationBar: Container(
            color: ColorRes.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () async {
                            final step = controller.stepperSelectedIndex.value;
                            log(
                              'hgd $step ${controller.propertyType.value} ${controller.lookingTo.value} ${controller.rent_propertyType.value}    ${(controller.lookingTo.value == 'Rent' || controller.lookingTo.value == 'Sell') && controller.propertyType.value == 'Residential' && step == 1 && controller.rent_propertyType.value.isEmpty}',
                            );

                            // Property type validation
                            if (step == 0 &&
                                controller.propertyType.value.isEmpty) {
                              controller.showBasicPropertyType.value = true;
                              return;
                            } else {
                              controller.showBasicPropertyType.value = false;
                            }
                            log(
                              'hgdvcgytdvcfhgdvcgytdvcf vbv$step ${controller.propertyType.value}',
                            );
                            if (step == 0 &&
                                controller.lookingTo.value.isEmpty) {
                              controller.showBasicLookingTo.value = true;
                              return;
                            } else {
                              controller.showBasicLookingTo.value = false;
                            }
                            log(
                              'hgdvcgytdvcfhgdvcgytdvcf $step ${controller.propertyType.value}',
                            );
                            if (step == 0 &&
                                controller.selectedIndex.value.isEmpty &&
                                controller.propertyType.value == 'Commercial') {
                              controller.hasShownCommercialCategory.value =
                                  true;
                              return;
                            } else {
                              controller.hasShownCommercialCategory.value =
                                  false;
                            }
                            log(
                              'hgdvcgytdvcfhgdvcgytdvcf $step ${controller.propertyType.value}',
                            );
                            // Rent property type validation
                            if ((controller.lookingTo.value == 'Rent' ||
                                    controller.lookingTo.value == 'Sell') &&
                                controller.propertyType.value ==
                                    'Residential' &&
                                step == 1 &&
                                controller.rent_propertyType.value.isEmpty) {
                              controller.showPropertyTypeError.value = true;
                              return;
                            } else {
                              controller.showPropertyTypeError.value = false;
                            }
                            log(
                              'hgdvcgytdvcfhgdvcgytdvcf $step ${controller.propertyType.value}',
                            );
                            log(
                              'hgdvcgytdvcfhgdvcgytdvcf $step ${controller.propertyType.value}',
                            );
                            if (controller.lookingTo.value == 'Sell' &&
                                controller.propertyType.value ==
                                    'Residential' &&
                                step == 2 &&
                                controller
                                    .sell_constructionStatus
                                    .value
                                    .isEmpty) {
                              controller.selectedSellFromPriceDetail.value =
                                  true;
                              log(
                                'hgdvcgytdvcfhgdvcgytdvcf $step ${controller.propertyType.value}',
                              );
                              return;
                            } else {
                              controller.selectedSellFromPriceDetail.value =
                                  false;
                            }

                            // Commercial property validation
                            if ((controller.lookingTo.value == 'Sell' ||
                                    controller.lookingTo.value == 'Rent') &&
                                controller.propertyType.value == 'Commercial' &&
                                step == 1 &&
                                controller.commercial_ZoneType.value.isEmpty) {
                              controller.selectedZoneTypeInCommercial.value =
                                  true;
                            } else {
                              controller.selectedZoneTypeInCommercial.value =
                                  false;
                            }

                            if ((controller.lookingTo.value == 'Sell' ||
                                    controller.lookingTo.value == 'Rent') &&
                                controller.propertyType.value == 'Commercial' &&
                                step == 1 &&
                                controller
                                    .commercial_ownerShipList
                                    .value
                                    .isEmpty) {
                              controller.seletedOwnerShipInCommercial.value =
                                  true;
                            } else {
                              controller.seletedOwnerShipInCommercial.value =
                                  false;
                            }

                            if ((controller.lookingTo.value == 'Sell' ||
                                    controller.lookingTo.value == 'Rent') &&
                                controller.propertyType.value == 'Commercial' &&
                                step == 1 &&
                                controller
                                    .commercial_rent_posessionStatus
                                    .value
                                    .isEmpty) {
                              controller.selectedPossessionStatus.value = true;
                            } else {
                              controller.selectedPossessionStatus.value = false;
                            }

                            if ((controller.lookingTo.value == 'Sell') &&
                                controller.propertyType.value == 'Commercial' &&
                                step == 1 &&
                                controller
                                    .commercial_construction_status_value
                                    .value
                                    .isEmpty) {
                              controller
                                  .selectedConstructionStatusRent_Commercial
                                  .value = true;
                            } else {
                              controller
                                  .selectedConstructionStatusRent_Commercial
                                  .value = false;
                            }

                            if ((controller.lookingTo.value == 'Sell') &&
                                controller.propertyType.value == 'Commercial' &&
                                step == 2 &&
                                controller
                                    .commercial_isPreLeased
                                    .value
                                    .isEmpty) {
                              controller
                                  .selectedChoiceAnyoneInPriceSection
                                  .value = true;
                            } else {
                              controller
                                  .selectedChoiceAnyoneInPriceSection
                                  .value = false;
                            }

                            if (step ==
                                controller.stepsList.indexOf("Photos")) {
                              // Check for minimum 1 image
                              if (controller.imageList.value.isEmpty) {
                                NesticoPeSnackBar.showAwesomeSnackbar(
                                  title: 'Required',
                                  message:
                                      'Please upload at least 1 property image',
                                  contentType: ContentType.failure,
                                );
                                return;
                              }

                              // Check for minimum 1 document
                              if (controller.documentList.value.isEmpty) {
                                NesticoPeSnackBar.showAwesomeSnackbar(
                                  title: 'Required',
                                  message:
                                      'Please upload at least 1 property document',
                                  contentType: ContentType.failure,
                                );
                                return;
                              }
                            }

                            // BHK validation
                            // if ((controller.lookingTo.value == 'Rent' ||
                            //         controller.lookingTo.value == 'Sell') &&
                            //     controller.propertyType.value ==
                            //         'Residential' &&
                            //     step == 1 &&
                            //     controller.bhkType.value.isEmpty) {
                            //   controller.showBHKChooseToError.value = true;
                            //   return;
                            // } else {
                            //   controller.showBHKChooseToError.value = false;
                            // }

                            // Validate current step's form before proceeding (only if form key exists)
                            final hasFormKey =
                                step < formKeys.length &&
                                formKeys[step] != null;
                            final isValid =
                                !hasFormKey ||
                                (formKeys[step]!.currentState?.validate() ??
                                    true);

                            if (isValid) {
                              if (controller.stepperSelectedIndex.value <
                                  controller.stepsList.length - 1) {
                                controller.nextStep();
                              } else {
                                isEdit
                                    ? await controller.updateProperty(
                                      property?.id ?? '',
                                    )
                                    : await controller.addProperty();
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.isLoading.value
                            ? ColorRes.primary.withOpacity(0.5)
                            : ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isEdit
                        ? controller.isLoading.value
                            ? "Updating... Wait"
                            : "Next"
                        : controller.isLoading.value
                        ? "Adding Property... Wait"
                        : "Next",
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      color: ColorRes.white,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        // Login section
        final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
        return Scaffold(
          backgroundColor: ColorRes.addPropertyBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder:
                  (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                color: ColorRes.addPropertyBackgroundColor,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorRes.leadGreyColor.shade300,
                                    ),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        print(
                                          "gcdsyuhfekewkwdlkjwlk;welkqwel;kmqwedifsgopfiugoiegureoipgokeroijsfd",
                                        );
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: ColorRes.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "NesticoPe",
                                    style: TextStyle(
                                      color: ColorRes.white,
                                      fontSize: AppFontSizes.large,
                                      fontWeight: AppFontWeights.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: const BoxDecoration(
                                color: ColorRes.addPropertyBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    "Sell or rent your property faster",
                                    style: TextStyle(
                                      color: ColorRes.white,
                                      fontSize: AppFontSizes.body,
                                      fontWeight: AppFontWeights.semiBold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  buildInfoPoint("Post property for free"),
                                  buildInfoPoint("Get verified buyers"),
                                  buildInfoPoint(
                                    "Personalised selling assistance",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: ColorRes.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                                child: Obx(
                                  () => Form(
                                    key: loginFormKey,
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                ColorRes.leadGreyColor.shade200,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap:
                                                      () => controller
                                                          .toggleOwner(true),
                                                  child: buildTab(
                                                    "Owner",
                                                    controller.isOwner.value,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap:
                                                      () => controller
                                                          .toggleOwner(false),
                                                  child: buildTab(
                                                    "Broker/Builder",
                                                    !controller.isOwner.value,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        if (controller.isOwner.value) ...[
                                          buildSectionTitle("Property Type"),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              buildChoice(
                                                title: 'Residential',
                                                selected:
                                                    controller
                                                        .propertyType
                                                        .value ==
                                                    'Residential',
                                                onTap:
                                                    () => controller.setValue(
                                                      controller.propertyType,
                                                      'Residential',
                                                    ),
                                              ),
                                              const SizedBox(width: 12),
                                              buildChoice(
                                                title: 'Commercial',
                                                selected:
                                                    controller
                                                        .propertyType
                                                        .value ==
                                                    'Commercial',
                                                onTap:
                                                    () => controller.setValue(
                                                      controller.propertyType,
                                                      'Commercial',
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          buildSectionTitle(
                                            "You're looking to...",
                                          ),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 12,
                                            children: [
                                              if (controller
                                                      .propertyType
                                                      .value ==
                                                  'Residential') ...[
                                                buildChoice(
                                                  title: 'Rent',
                                                  selected:
                                                      controller
                                                          .lookingTo
                                                          .value ==
                                                      'Rent',
                                                  onTap:
                                                      () => controller.setValue(
                                                        controller.lookingTo,
                                                        'Rent',
                                                      ),
                                                ),
                                                buildChoice(
                                                  title: 'Sell',
                                                  selected:
                                                      controller
                                                          .lookingTo
                                                          .value ==
                                                      'Sell',
                                                  onTap:
                                                      () => controller.setValue(
                                                        controller.lookingTo,
                                                        'Sell',
                                                      ),
                                                ),
                                                buildChoice(
                                                  title: 'PG/Co-Living',
                                                  selected:
                                                      controller
                                                          .lookingTo
                                                          .value ==
                                                      'PG/Co-Living',
                                                  onTap:
                                                      () => controller.setValue(
                                                        controller.lookingTo,
                                                        'PG/Co-Living',
                                                      ),
                                                ),
                                              ] else ...[
                                                buildChoice(
                                                  title: 'Rent',
                                                  selected:
                                                      controller
                                                          .lookingTo
                                                          .value ==
                                                      'Rent',
                                                  onTap:
                                                      () => controller.setValue(
                                                        controller.lookingTo,
                                                        'Rent',
                                                      ),
                                                ),
                                                buildChoice(
                                                  title: 'Sell',
                                                  selected:
                                                      controller
                                                          .lookingTo
                                                          .value ==
                                                      'Sell',
                                                  onTap:
                                                      () => controller.setValue(
                                                        controller.lookingTo,
                                                        'Sell',
                                                      ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          if (controller.propertyType.value ==
                                              "Commercial") ...[
                                            const SizedBox(height: 24),
                                            subPropertyType(controller),
                                          ],
                                          const SizedBox(height: 24),
                                          buildTextField(
                                            "Phone Number",
                                            Icons.phone,
                                            controller.phoneController,
                                            isPhone: true,
                                            isPhoneKey: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Phone required';
                                              }
                                              final selectedCode =
                                                  controller.countryCode.value;
                                              final expectedLength =
                                                  controller
                                                      .countryRules[selectedCode] ??
                                                  10;
                                              final onlyDigits = RegExp(
                                                r'^\d+$',
                                              );
                                              if (!onlyDigits.hasMatch(value)) {
                                                return 'Enter digits only';
                                              }
                                              if (value.length !=
                                                  expectedLength) {
                                                return 'Enter $expectedLength digit number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          buildTextField(
                                            "Your Name",
                                            Icons.person,
                                            controller.nameController,
                                          ),
                                          const SizedBox(height: 16),
                                          buildTextField(
                                            "Search City",
                                            Icons.location_on,
                                            controller.cityController,
                                            onTap: () async {
                                              Prediction
                                              selectedCity = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => CommonSearchField(
                                                        onCitySelected: (city) {
                                                          Navigator.pop(
                                                            context,
                                                            city,
                                                          );
                                                        },
                                                        isFromAddProperty: true,
                                                        initialSearchText:
                                                            controller
                                                                .cityController
                                                                .text,
                                                      ),
                                                ),
                                              );
                                              controller.cityController.text =
                                                  selectedCity.description
                                                      ?.split(',')[0] ??
                                                  '';

                                              print(
                                                "city ${controller.cityController.text}",
                                              );
                                              FocusScope.of(context).unfocus();
                                            },
                                            isEnable: false,
                                          ),
                                          const SizedBox(height: 28),
                                        ] else ...[
                                          const SizedBox(height: 20),
                                          buildTextField(
                                            "Phone Number",
                                            Icons.phone,
                                            controller.phoneController,
                                            isPhone: true,
                                            isPhoneKey: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Phone required';
                                              }
                                              final selectedCode =
                                                  controller.countryCode.value;
                                              final expectedLength =
                                                  controller
                                                      .countryRules[selectedCode] ??
                                                  10;
                                              final onlyDigits = RegExp(
                                                r'^\d+$',
                                              );
                                              if (!onlyDigits.hasMatch(value)) {
                                                return 'Enter digits only';
                                              }
                                              if (value.length !=
                                                  expectedLength) {
                                                return 'Enter $expectedLength digit number';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 40),
                                          Container(
                                            width: double.infinity,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: ColorRes.grey.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Continue',
                                              style: TextStyle(
                                                fontSize:
                                                    AppFontSizes.bodyMedium,
                                                fontWeight:
                                                    AppFontWeights.semiBold,
                                                color: ColorRes.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'By clicking above you agree to ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: ColorRes.leadGreyColor,
                                                  fontSize:
                                                      AppFontSizes.extraSmall,
                                                  fontWeight:
                                                      AppFontWeights.semiBold,
                                                ),
                                              ),
                                              Text(
                                                'Terms & Conditions',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: ColorRes.primary,
                                                  fontSize:
                                                      AppFontSizes.caption,
                                                  fontWeight:
                                                      AppFontWeights.semiBold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  color: ColorRes.leadGreyColor
                                                      .withOpacity(0.5),
                                                  thickness: 0.8,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                child: Text(
                                                  'OR',
                                                  style: TextStyle(
                                                    color:
                                                        ColorRes.leadGreyColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Divider(
                                                  color: ColorRes.leadGreyColor
                                                      .withOpacity(0.5),
                                                  thickness: 0.8,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 40),
                                          Center(
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              onTap: controller.submitForm,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 12,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Existing User?",
                                                      style: TextStyle(
                                                        fontSize:
                                                            AppFontSizes.small,
                                                        color:
                                                            ColorRes
                                                                .textSecondary,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .medium,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      "Login Here",
                                                      style: TextStyle(
                                                        fontSize:
                                                            AppFontSizes
                                                                .bodySmall,
                                                        color: ColorRes.primary,
                                                        fontWeight:
                                                            AppFontWeights
                                                                .semiBold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
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
          bottomNavigationBar: Container(
            color: ColorRes.white,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isLogin.value) {
                      if (controller.stepperSelectedIndex.value <
                          controller.stepsList.length - 1) {
                        controller.nextStep();
                      }
                    } else {
                      if (loginFormKey.currentState?.validate() ?? true) {
                        controller.submitForm();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Next, add address & price",
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      color: ColorRes.white,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}

// ----- WIDGET HELPERS -----

Widget buildInfoPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.yellow, size: 15),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: ColorRes.white,
            fontSize: AppFontSizes.bodySmall,
          ),
        ),
      ],
    ),
  );
}

Widget buildTab(String title, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color:
          isSelected
              ? ColorRes.primary.withOpacity(0.15)
              : ColorRes.transparentColor,
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: Text(
      title,
      style: TextStyle(
        fontWeight: AppFontWeights.semiBold,
        fontSize: AppFontSizes.bodySmall,
        color: isSelected ? ColorRes.primary : ColorRes.textPrimary,
      ),
    ),
  );
}

Widget buildChoice({
  required String title,
  required bool selected,
  required VoidCallback onTap,
  double? width = 155,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? ColorRes.primary.withOpacity(0.1) : ColorRes.white,
        border: Border.all(
          color: selected ? ColorRes.transparentColor : Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: selected ? ColorRes.primary : ColorRes.textPrimary,
          fontWeight: AppFontWeights.medium,
          fontSize: AppFontSizes.small,
        ),
      ),
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textSecondary,
    ),
  );
}

Widget buildSizedSectionTitle(String title, {double width = 70}) {
  return Text(
    title,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: AppFontSizes.caption,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textSecondary,
    ),
  );
}

Widget buildTextField(
  String label,
  IconData icon,
  TextEditingController controller, {
  bool isPhone = false,
  bool isPhoneKey = false,
  bool isEnable = true,
  int maxLines = 1,
  int minLines = 1,
  TextInputType inputType = TextInputType.text,
  List<TextInputFormatter>? formatter,
  VoidCallback? onTap,
  String? Function(String?)? validator,
  Function(String)? onChanged,
}) {
  return GestureDetector(
    onTap: onTap,
    child: NesticoPeTextField(
      controller: controller,
      hintText: label,
      enabled: isEnable,
      maxLines: maxLines,
      keyboardType: isPhoneKey ? TextInputType.phone : inputType,
      formatter: formatter,
      validator: validator,
      onChanged: onChanged,
      // onTap: onTap,
      prefixIcon: isPhone ? null : icon,
      suffixIcon:
          isPhone
              ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: buildPhonePrefix(),
              )
              : null,
    ),
  );
}

Widget buildPhonePrefix() {
  final countryCodes = [
    {'code': '+91', 'flag': '🇮🇳'},
    {'code': '+1', 'flag': '🇺🇸'},
    {'code': '+44', 'flag': '🇬🇧'},
    {'code': '+61', 'flag': '🇦🇺'},
    {'code': '+1-CA', 'flag': '🇨🇦'},
    {'code': '+49', 'flag': '🇩🇪'},
    {'code': '+33', 'flag': '🇫🇷'},
    {'code': '+65', 'flag': '🇸🇬'},
    {'code': '+971', 'flag': '🇦🇪'},
    {'code': '+81', 'flag': '🇯🇵'},
  ];

  final controller = Get.find<CreatePropertyController>();

  return Obx(
    () => Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.countryCode.value,
            isDense: true,
            icon: const SizedBox(),
            style: const TextStyle(fontSize: 14, color: ColorRes.textSecondary),
            items:
                countryCodes.map((entry) {
                  return DropdownMenuItem(
                    value: entry['code'],
                    child: Row(
                      children: [
                        Text(
                          entry['flag']!,
                          style: const TextStyle(fontSize: AppFontSizes.body),
                        ),
                        const SizedBox(width: 3),
                        Text(entry['code']!),
                      ],
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (context) {
              return countryCodes.map((entry) {
                return Row(
                  children: [
                    Text(
                      entry['flag']!,
                      style: const TextStyle(fontSize: AppFontSizes.body),
                    ),
                    const SizedBox(width: 3),
                    Text(entry['code']!),
                  ],
                );
              }).toList();
            },
            onChanged: (val) {
              if (val != null) controller.setValue(controller.countryCode, val);
            },
          ),
        ),
      ],
    ),
  );
}

Widget subPropertyType(CreatePropertyController controller) {
  final items = IconManager.items;

  return Obx(
    () => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = controller.selectedIndex.value == item.title;

          return GestureDetector(
            onTap: () => controller.select(item.title),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? ColorRes.primary.withOpacity(0.1)
                        : ColorRes.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      isSelected
                          ? ColorRes.transparentColor
                          : ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSvgIcon(
                    assetName: item.key,
                    size: 24,
                    color:
                        isSelected
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                      color: isSelected ? ColorRes.primary : ColorRes.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}
