import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/model/room_detail_model.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart' hide Obx;
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
                            "${room.roomType} ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppFontSizes.bodySmall,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "Deposit: ₹${room.deposit} - ₹${room.monthlyRent} / month",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
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
                                  controller.tempMonthlyRent.text = room.monthlyRent;
                                  controller.tempDeposit.text = room.deposit;
                                  controller.editingIndex.value = index;
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  controller.deleteRoom(index);
                                  if (controller.rooms.isNotEmpty)
                                  {controller.clearRoomDetail();}
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
                      controller.rooms.isEmpty ? "Add Room Detail" : "Add Another Room",
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontWeight: FontWeight.w500,
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                      'single',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'single',
                                ),
                                buildChoice(
                                  width: 140,
                                  title: 'Double Sharing',
                                  selected:
                                      controller.tempRoomType.value ==
                                      'double',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'double',
                                ),
                                buildChoice(
                                  title: 'Triple Sharing',
                                  width: 140,
                                  selected:
                                      controller.tempRoomType.value ==
                                      'triple',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'triple',
                                ),
                                buildChoice(
                                  title: '3 + Sharing',
                                  width: 140,
                                  selected:
                                      controller.tempRoomType.value ==
                                      'other',
                                  onTap:
                                      () =>
                                          controller.tempRoomType.value =
                                              'other',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          buildTextField(
                            'Monthly Rent',
                            Icons.calendar_month_outlined,
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
                          buildTextField(
                            'Deposit',
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

                          // Save/Update button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey?.currentState?.validate() ?? false) {
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
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorRes.primary,
                                  fontWeight: FontWeight.w500,
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
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
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
