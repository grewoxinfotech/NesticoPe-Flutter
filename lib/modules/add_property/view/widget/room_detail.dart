import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/model/room_detail_model.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart' hide Obx;
import '../../controller/create_property_controller.dart';

class RoomDetail extends StatelessWidget {
  final CreatePropertyController controller;
  const RoomDetail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.lookingTo.value == "PG/Co-Living") {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              buildSectionTitle('Room Details'),
              const SizedBox(height: 10),

              // Show list ONLY when rooms exist
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
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.deleteRoom(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

              // Input fields for add/update
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
                                  'Private Room',
                              onTap:
                                  () =>
                                      controller.tempRoomType.value =
                                          'Private Room',
                            ),
                            buildChoice(
                              width: 140,
                              title: 'Double Sharing',
                              selected:
                                  controller.tempRoomType.value ==
                                  'Double Sharing',
                              onTap:
                                  () =>
                                      controller.tempRoomType.value =
                                          'Double Sharing',
                            ),
                            buildChoice(
                              title: 'Triple Sharing',
                              width: 140,
                              selected:
                                  controller.tempRoomType.value ==
                                  'Triple Sharing',
                              onTap:
                                  () =>
                                      controller.tempRoomType.value =
                                          'Triple Sharing',
                            ),
                            buildChoice(
                              title: '3 + Sharing',
                              width: 140,
                              selected:
                                  controller.tempRoomType.value ==
                                  '3 + Sharing',
                              onTap:
                                  () =>
                                      controller.tempRoomType.value =
                                          '3 + Sharing',
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
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        'Deposit',
                        Icons.currency_rupee_sharp,
                        controller.tempDeposit,
                        isPhoneKey: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Save button (Add / Update)
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: controller.saveRoom,
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
                          ? "${controller.rooms.value.isEmpty ? "Add Room Detail" : "Add Another Room"}"
                          : "Update Room",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorRes.primary,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Post Property button
              // SizedBox(
              //   width: double.infinity,
              //   height: 45,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       print(
              //         "${controller.bestSuitedList} ${controller.selectedItems}",
              //       );
              //       if (controller.stepIndex.value <
              //           controller.stepsList.value.length) {
              //         controller.nextStep(); // move to next step
              //       } else {
              //         controller.submitForm(); // final submit
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: ColorRes.primary,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(14),
              //       ),
              //       elevation: 2,
              //     ),
              //     child: const Text(
              //       "Post Property",
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: Colors.white,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
