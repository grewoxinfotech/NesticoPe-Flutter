import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/model/room_detail_model.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart'
    hide Obx;
import '../../../../app/manager/icon_manager.dart';
import '../../../../app/utils/svg_widget.dart';
import '../../controller/create_property_controller.dart';

class RoomDetail extends StatelessWidget {
  final CreatePropertyController controller;
  final GlobalKey<FormState>? formKey;
  const RoomDetail({super.key, required this.controller, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.lookingTo.value == "PG/Co-Living") {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                buildSectionTitle('Room Details'),
                const SizedBox(height: 10),

                // Show list of rooms
                if (controller.rooms.isNotEmpty)
                  Column(
                    children: List.generate(controller.rooms.length, (index) {
                      final room = controller.rooms[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: ColorRes.grey.withOpacity(0.3),
                            width: 0.8,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            "(Room ${index + 1}) - ${room.roomType} ",
                            style: TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.bodySmall,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "Deposit: ₹${room.deposit} - ₹${room.monthlyRent} / month",
                            style: TextStyle(
                              fontWeight: AppFontWeights.medium,
                              fontSize: AppFontSizes.small,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: ColorRes.primary,
                                ),
                                onPressed: () {
                                  controller.showAddRoomCard.value = true;
                                  // Pre-fill fields
                                  controller.tempRoomType.value = room.roomType;
                                  controller.tempMonthlyRent.text =
                                      room.monthlyRent;
                                  controller.tempDeposit.text = room.deposit;
                                  controller.editingIndex.value = index;
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: ColorRes.error,
                                ),
                                onPressed: () {
                                  controller.deleteRoom(index);
                                  if (controller.rooms.isNotEmpty) {
                                    controller.clearRoomDetail();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                // Show Add Room button when card is not visible
                if (!controller.showAddRoomCard.value)
                  TextButton(
                    onPressed: () {
                      controller.showAddRoomCard.value = true;
                      controller.editingIndex.value = -1;
                      controller.clearRoomDetail();
                    },
                    child: Text(
                      controller.rooms.isEmpty
                          ? "Add Room Detail"
                          : "Add Another Room",
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),

                // Input card for add/update
                if (controller.showAddRoomCard.value)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: ColorRes.grey.withOpacity(0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildSectionTitle('Room Type'),

                              GestureDetector(
                                onTap: () {
                                  controller.clearRoomDetail();
                                },
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.primary,
                                    fontWeight: AppFontWeights.medium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 16),

                          // PG Details
                          buildSectionTitle("Monthly Rent"),
                          const SizedBox(height: 8),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                buildChoice(
                                  width: 140,
                                  title: 'Private Room',
                                  selected:
                                      controller.tempRoomType.value ==
                                      'private',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'private',
                                ),
                                buildChoice(
                                  width: 140,
                                  title: 'Double Sharing',
                                  selected:
                                      controller.tempRoomType.value == 'double',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'double',
                                ),
                                buildChoice(
                                  title: 'Triple Sharing',
                                  width: 140,
                                  selected:
                                      controller.tempRoomType.value == 'triple',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'triple',
                                ),
                                buildChoice(
                                  title: '3 + Sharing',
                                  width: 140,
                                  selected:
                                      controller.tempRoomType.value == 'multi',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'multi',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          buildTextField(
                            'Enter monthly rent',
                            Icons.currency_rupee_outlined,
                            controller.tempMonthlyRent,
                            isPhoneKey: true,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter monthly rent';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          buildSectionTitle("Security Deposit"),
                          const SizedBox(height: 8),
                          buildTextField(
                            'Enter security deposit',
                            Icons.currency_rupee_sharp,
                            controller.tempDeposit,
                            isPhoneKey: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter deposit';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),
                          buildSectionTitle("Room Facility Available"),
                          const SizedBox(height: 8),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: buildChoice(
                                    title: 'Yes',

                                    selected:
                                        controller
                                            .roomFacilityAvailableOrNot
                                            .value ==
                                        'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.roomFacilityAvailableOrNot,
                                          'Yes',
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: buildChoice(
                                    title: 'No',

                                    selected:
                                        controller
                                            .roomFacilityAvailableOrNot
                                            .value ==
                                        'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.roomFacilityAvailableOrNot,
                                          'No',
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.roomFacilityAvailableOrNot ==
                              'Yes') ...[
                            const SizedBox(height: 16),
                            buildSectionTitle("Room Facility"),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    IconManager.roomAmenities.map((e) {
                                      final isSelected = controller
                                          .selectedRoomAmenitiesDataForPG
                                          .contains(e.key);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.addOrUpdateRoomAmenities(
                                              e.key,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.1)
                                                      : ColorRes.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? Theme.of(
                                                          context,
                                                        ).primaryColor
                                                        : ColorRes
                                                            .leadGreyColor
                                                            .shade300,
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  e.title,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                        isSelected
                                                            ? Theme.of(
                                                              context,
                                                            ).primaryColor
                                                            : ColorRes.black,
                                                    fontSize:
                                                        AppFontSizes.caption,
                                                    fontWeight:
                                                        AppFontWeights.regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildSectionTitle("Other Facility"),
                            const SizedBox(height: 12),
                            buildTextField(
                              "Enter other facility",
                              Icons.other_houses_outlined,
                              controller.otherFacility,
                            ),
                          ],
                          const SizedBox(height: 16),
                          // Save/Update button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey?.currentState?.validate() ??
                                    false) {
                                  controller.saveRoom();
                                  controller.showAddRoomCard.value = false;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorRes.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: const BorderSide(
                                    color: ColorRes.primary,
                                    width: 1,
                                  ),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                controller.editingIndex.value == -1
                                    ? "Add Room"
                                    : "Update Room",
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  color: ColorRes.primary,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Cancel button
                          if (controller.rooms.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  controller.showAddRoomCard.value = false;
                                  controller.clearRoomDetail();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: ColorRes.leadGreyColor,
                                    fontWeight: AppFontWeights.medium,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
