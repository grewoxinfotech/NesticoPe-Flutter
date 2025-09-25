import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/basic_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/photo_upload.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/post_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/advance_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/amenities.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/price_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/rent/verify_section.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/review_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/room_detail.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/step_row.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/stepper_property.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

  import '../../../data/network/auth/model/user_model.dart';

  @override
  Widget build(BuildContext context) {
    final List<String> pgFor = ['Girl', 'Boy'];
    final controller = Get.put(CreatePropertyController());

    return Obx(() {
      if (controller.isLogin.value) {
        return Scaffold(
          backgroundColor: const Color(0xff091F48),
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
                                color: Color(0xff091F48),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        if (controller
                                                .stepperSelectedIndex
                                                .value >
                                            0) {
                                          controller.previousStep();
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Create Listing",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSizes.large,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                // vertical: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xff091F48),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Sell or rent your property faster",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSizes.body,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // const SizedBox(height: 15),
                                  // buildInfoPoint("Post property for free"),
                                  // buildInfoPoint("Get verified buyers"),
                                  // buildInfoPoint(
                                  //   "Personalised selling assistance",
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Form Card Section
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                                child: Obx(
                                  () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      // Tabs
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
                                          print('list of ${controller.stepsList}');
                                          final step =
                                              controller
                                                  .stepperSelectedIndex
                                                  .value;
                                          if (step == 0) {
                                            return BasicDetail(
                                              controller: controller,
                                            );
                                          }
                                          if (controller.lookingTo.value ==
                                              'PG/Co-Living') {
                                            switch (step) {
                                              case 1:
                                                return PostProperty(
                                                  controller: controller,
                                                );
                                              case 2:
                                                return RoomDetail(
                                                  controller: controller,
                                                );
                                              case 3:
                                                return PhotoUpload(
                                                  controller: controller,
                                                );
                                              case 4:
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
                                                  'Sell')&& controller.propertyType.value=="Residential") {
                                            switch (step) {
                                              case 1:
                                                return PostProperty(
                                                  controller: controller,
                                                );
                                              case 2:
                                                return RentPriceDetail(
                                                  controller: controller,
                                                );
                                              case 3:
                                                return PhotoUpload(
                                                  controller: controller,
                                                );
                                              case 4:
                                                return RentAdvanceDetail(
                                                  controller: controller,
                                                );
                                              case 5:
                                                return RentAmenities(
                                                  controller: controller,
                                                );

                                              case 6:
                                                return VerifySection(
                                                  controller: controller,
                                                );
                                                
                                            }
                                          }
                                          else if((controller.lookingTo.value=="Rent" || controller.lookingTo.value=="Sell") && controller.propertyType.value=="Commercial")
                                            {print('current step ${controller.stepsList[step]}');
                                              switch (step) {
                                                case 1:
                                                  return PostProperty(
                                                    controller: controller,
                                                  );
                                                case 2:
                                                  return RentPriceDetail(
                                                    controller: controller,
                                                  );
                                                case 3:
                                                  return RentAmenities(controller: controller);
                                                case 4:
                                                  return PhotoUpload(
                                                    controller: controller,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white, // 👈 white background behind button
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isLogin.value) {
                      // Use stepperSelectedIndex for navigation
                      if (controller.stepperSelectedIndex.value <
                          controller.stepsList.length - 1) {
                        controller.nextStep();
                      }
                      // else do nothing or show a message, as you are already at the last step (review)
                    } else {
                      controller.submitForm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Next, add address & price",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: const Color(0xff091F48),
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
                                color: Color(0xff091F48),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Housing.com",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSizes.large,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                // vertical: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xff091F48),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Sell or rent your property faster",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSizes.body,
                                      fontWeight: FontWeight.w600,
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
                            // Form Card Section
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                                child: Obx(
                                  () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      // Tabs
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
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
                                            if (controller.propertyType.value ==
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
                                                    () =>
                                                        controller..setValue(
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
                                        ),

                                        const SizedBox(height: 28),
                                        // SizedBox(
                                        //   width: double.infinity,
                                        //   height: 45,
                                        //   child: ElevatedButton(
                                        //     onPressed: controller.submitForm,
                                        //     style: ElevatedButton.styleFrom(
                                        //       backgroundColor: ColorRes.primary,
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(14),
                                        //       ),
                                        //       elevation: 2,
                                        //     ),
                                        //     child: const Text(
                                        //       "Next, add address & price",
                                        //       style: TextStyle(
                                        //         fontSize: 14,
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.w500,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ] else ...[
                                        const SizedBox(height: 20),

                                        buildTextField(
                                          "Phone Number",
                                          Icons.phone,
                                          controller.phoneController,
                                          isPhone: true,
                                          isPhoneKey: true,
                                        ),

                                        const SizedBox(height: 40),

                                        // Con const SizedBox(height: 20),tinue button
                                        Container(
                                          width: double.infinity,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: ColorRes.grey.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'By clicking above you agree to ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Terms & Conditions',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: ColorRes.primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.withOpacity(
                                                  0.5,
                                                ), // choose color
                                                thickness: 0.8, // optional
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
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ), // adjust color if needed
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.withOpacity(
                                                  0.5,
                                                ),
                                                thickness: 0.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(height: 20),

                                        // SizedBox(
                                        //   width: double.infinity,
                                        //   height: 45,
                                        //   child: ElevatedButton(
                                        //     onPressed: controller.submitForm,
                                        //     style: ElevatedButton.styleFrom(
                                        //       backgroundColor: ColorRes.primary,
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(14),
                                        //       ),
                                        //       elevation: 2,
                                        //     ),
                                        //     child: const Text(
                                        //       "On Tap Login with Truecaller",
                                        //       style: TextStyle(
                                        //         fontSize: 14,
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.w500,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(height: 40),

                                        Center(
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            onTap: controller.submitForm,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 12,
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize
                                                        .min, // keep row compact
                                                children: [
                                                  Text(
                                                    "Existing User?",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          ColorRes
                                                              .textSecondary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Login Here",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: ColorRes.primary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration:
                                                          TextDecoration
                                                              .underline, // 👈 adds a hint it's clickable
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // const SizedBox(height: 25),
                                      ],
                                    ],
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
            color: Colors.white, // 👈 white background behind button
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isLogin.value) {
                      // Use stepperSelectedIndex for navigation
                      if (controller.stepperSelectedIndex.value <
                          controller.stepsList.length - 1) {
                        controller.nextStep();
                      }
                      // else do nothing or show a message, as you are already at the last step (review)
                    } else {
                      controller.submitForm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Next, add address & price",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    ),
  );
}

Widget buildTab(String title, bool isSelected) {
  return Container(
    // duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color:
          isSelected ? ColorRes.primary.withOpacity(0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
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
        color: selected ? ColorRes.primary.withOpacity(0.1) : Colors.white,
        border: Border.all(
          color: selected ? Colors.transparent : Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: selected ? ColorRes.primary : ColorRes.textPrimary,
          fontWeight: FontWeight.w500,
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
    style: const TextStyle(
      fontSize: AppFontSizes.small,

      fontWeight: FontWeight.w600,
      color: ColorRes.textSecondary,
    ),
  );
}

Widget buildSizedSectionTitle(String title, {double width = 70}) {
  return Text(
    title,
    textAlign: TextAlign.left,
    style: const TextStyle(
      fontSize: AppFontSizes.caption,

      fontWeight: FontWeight.w600,
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
}) {
  return TextField(
    controller: controller,
    enabled: isEnable,
    maxLines: maxLines,
    minLines: minLines,
    keyboardType: isPhoneKey ? TextInputType.phone : TextInputType.text,
    style: const TextStyle(fontSize: 14, color: ColorRes.textPrimary),
    decoration: InputDecoration(
      prefixIcon:
          isPhone
              ? Padding(
                padding: const EdgeInsets.only(left: 8),
                child: buildPhonePrefix(),
              )
              : Icon(icon, color: ColorRes.primary, size: 20),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, maxHeight: 20),
      hintText: label,
      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 0.8,
          color: ColorRes.grey.withOpacity(0.3),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 0.8,
          color: ColorRes.grey.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1.2, color: ColorRes.primary),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
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
            // 🔑 reduces built-in padding
            style: const TextStyle(fontSize: 14, color: ColorRes.textSecondary),
            items:
                countryCodes.map((entry) {
                  return DropdownMenuItem(
                    value: entry['code'],
                    child: Row(
                      children: [
                        Text(
                          entry['flag']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 3), // reduced from 6 → 3
                        Text(entry['code']!),
                      ],
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (context) {
              return countryCodes.map((entry) {
                return Row(
                  children: [
                    Text(entry['flag']!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 3), // reduced from 6 → 3
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
              // duration: const Duration(milliseconds: 200),
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? ColorRes.primary.withOpacity(0.1)
                        : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSvgIcon(
                    assetName: item.key,
                    size: 24,
                    color: isSelected ? ColorRes.primary : Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? ColorRes.primary : Colors.black,
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

Widget _buildChoiceChip(String label, bool selected, VoidCallback onSelected) {
  return ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
    selectedColor: Colors.deepPurpleAccent,
    labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
