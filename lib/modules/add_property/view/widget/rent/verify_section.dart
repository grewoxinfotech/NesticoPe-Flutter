// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
// import 'package:intl/intl.dart';
//
// import '../../create_property.dart';
//
// class VerifySection extends StatelessWidget {
//   final CreatePropertyController controller;
//   const VerifySection({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.lookingTo.value == "Rent") {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             buildSectionTitle('Steps to Verify'),
//             const SizedBox(height: 12),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStep(Icons.location_on, "Go to Property"),
//                 _buildConnector(),
//                 _buildStep(Icons.link, "Open Link"),
//                 _buildConnector(),
//                 _buildStep(Icons.camera_alt, "Take Photos"),
//               ],
//             ),
//
//             const SizedBox(height: 24),
//
//             // --- Reminder Section ---
//             buildSectionTitle("Plan your Visit"),
//             const SizedBox(height: 8),
//             const Text("Pick a date & time for your reminder"),
//             const SizedBox(height: 16),
//
//             // --- Open BottomSheet Button ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // --- Today (Static) ---
//                 Expanded(
//                   child: Container(
//                     height: 45,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade400),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       "Today",
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//
//                 // --- Current Date (Static) ---
//                 Expanded(
//                   child: Container(
//                     height: 45,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade400),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       DateFormat("d MMM").format(DateTime.now()), // example: 23 Sep
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//
//                 // --- Selected Date (Reactive) ---
//                 Expanded(
//                   child: Obx(() {
//                     final selected = controller.selectedDate.value;
//                     final selectedTime = controller.selectedTime.value;
//
//                     String label = "Custom";
//                     if (selected != null) {
//                       label = DateFormat("d MMM").format(selected);
//                       if (selectedTime != null) {
//                         label;
//                       }
//                     }
//
//                     return Container(
//                       height: 45,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: selected != null ? ColorRes.primary : Colors.grey.shade400,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                         color: selected != null
//                             ? ColorRes.primary.withOpacity(0.08)
//                             : Colors.transparent,
//                       ),
//                       child: Text(
//                         label,
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: selected != null ? ColorRes.primary : Colors.black87,
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(width: 8),
//
//                 Expanded(
//                   child: Obx(() {
//                     // final selected = controller.selectedDate.value;
//                     final selectedTime = controller.selectedTime.value;
//                     return Container(
//                       height: 45,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: selectedTime != null ? ColorRes.primary : Colors.grey.shade400,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                         color: selectedTime != null
//                             ? ColorRes.primary.withOpacity(0.08)
//                             : Colors.transparent,
//                       ),
//                       child: Text(
//                         '${selectedTime?.format(Get.context!)}',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                           color: selectedTime != null ? ColorRes.primary : Colors.black87,
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(width: 8),
//
//                 // --- Select Button ---
//
//               ],
//             ),
//             const SizedBox(height: 12),
//
//             SizedBox(
//               height: 45,
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   side: const BorderSide(color: ColorRes.primary),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: () => _openDateTimePicker(context),
//                 child: const Text(
//                   "Select",
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//               ),
//             ),
//
//
//
//             const SizedBox(height: 24),
//
//             // --- Set Reminder Button ---
//             Obx(() => SizedBox(
//               height: 50,
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   backgroundColor: ColorRes.primary,
//                 ),
//                 onPressed: controller.selectedDate.value != null
//                     ? () {
//                   Get.snackbar(
//                     "Reminder Set",
//                     "Visit planned for ${controller.formattedDate} at ${controller.formattedTime}",
//                     snackPosition: SnackPosition.BOTTOM,
//                   );
//                 }
//                     : null,
//                 child: const Text(
//                   "Set Reminder",
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: ColorRes.white),
//                 ),
//               ),
//             )),
//
//             const SizedBox(height: 12),
//             const Align(alignment: Alignment.center, child: Text("Or")),
//           ],
//         );
//       }
//       return const SizedBox.shrink();
//     });
//   }
//
//
//
//
//   // ---------------- BottomSheet Picker ----------------
//   void _openDateTimePicker(BuildContext context) {
//     final controller = Get.find<CreatePropertyController>();
//     DateTime tempDate = controller.selectedDate.value ?? DateTime.now();
//     TimeOfDay tempTime = controller.selectedTime.value ?? TimeOfDay.now();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) {
//         return Padding(
//           padding:
//           EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
//           child: StatefulBuilder(
//             builder: (ctx, setState) {
//               return Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Wrap(
//                   runSpacing: 16,
//                   children: [
//                     const Text(
//                       "Pick Date & Time",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 12),
//
//                     // Calendar
//                     CalendarDatePicker(
//                       initialDate: tempDate,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 60)),
//                       onDateChanged: (date) {
//                         setState(() => tempDate = date);
//                       },
//                     ),
//
//                     // Time Picker
//                     ListTile(
//                       leading: const Icon(Icons.access_time),
//                       title: Text("Time: ${tempTime.format(ctx)}"),
//                       onTap: () async {
//                         final picked = await showTimePicker(
//                           context: ctx,
//                           initialTime: tempTime,
//                         );
//                         if (picked != null) {
//                           setState(() => tempTime = picked);
//                         }
//                       },
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // Confirm Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorRes.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text("Confirm"),
//                         onPressed: () {
//                           controller.setDateTime(tempDate, tempTime);
//                           Navigator.pop(ctx);
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStep(IconData icon, String label) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 22,
//           backgroundColor: ColorRes.primary.withOpacity(0.1),
//           child: Icon(icon, color: ColorRes.primary),
//         ),
//         const SizedBox(height: 6),
//         SizedBox(
//           width: 70,
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 10),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildConnector() {
//     return Expanded(
//       child: Container(
//         height: 2,
//         color: Colors.grey.shade300,
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../create_property.dart';

class VerifySection extends StatelessWidget {
  final CreatePropertyController controller;
  const VerifySection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.lookingTo.value == "Rent" ||
          controller.lookingTo.value == "Sell") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Enhanced Steps Section
            _buildVerificationSteps(),

            const SizedBox(height: 24),

            // Enhanced Plan Visit Section
            _buildPlanVisitSection(context),

            const SizedBox(height: 24),

            // Enhanced Set Reminder Button
            _buildSetReminderButton(),

            const SizedBox(height: 24),

            // Enhanced Alternative Section
            _buildAlternativeSection(),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildVerificationSteps() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.verified_outlined,
                  color: ColorRes.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Verification Steps',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEnhancedStep(
                Icons.location_on_outlined,
                "Visit Property",
                "Go to the location",
                0,
              ),

              _buildEnhancedStep(
                Icons.link_outlined,
                "Open Link",
                "Access verification",
                1,
              ),

              _buildEnhancedStep(
                Icons.camera_alt_outlined,
                "Take Photos",
                "Capture evidence",
                2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanVisitSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule_outlined,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Plan Your Visit',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Schedule a convenient time for property verification",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Enhanced Date/Time Selection
          Row(
            children: [
              // Quick Today Option
              Expanded(
                flex: 2,
                child: _buildQuickDateOption(
                  "Today",
                  DateFormat("d MMM").format(DateTime.now()),
                  Icons.today_outlined,
                  false,
                ),
              ),
              const SizedBox(width: 12),

              // Custom Date Selection
              Expanded(
                flex: 3,
                child: Obx(() {
                  final selected = controller.selectedDate.value;
                  final selectedTime = controller.selectedTime.value;

                  return _buildCustomDateTimeOption(
                    context,
                    selected,
                    selectedTime,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateOption(
    String title,
    String date,
    IconData icon,
    bool isSelected,
  ) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? ColorRes.primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color:
            isSelected
                ? ColorRes.primary.withOpacity(0.05)
                : Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? ColorRes.primary : Colors.grey.shade600,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? ColorRes.primary : Colors.grey.shade700,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? ColorRes.primary : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDateTimeOption(
    BuildContext context,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
  ) {
    bool hasSelection = selectedDate != null || selectedTime != null;

    return GestureDetector(
      onTap: () => _openEnhancedDateTimePicker(context),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasSelection ? ColorRes.primary : Colors.grey.shade300,
            width: hasSelection ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color:
              hasSelection
                  ? ColorRes.primary.withOpacity(0.05)
                  : Colors.grey.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_outlined,
              size: 20,
              color: hasSelection ? ColorRes.primary : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              hasSelection ? "Custom" : "Select Date",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hasSelection ? ColorRes.primary : Colors.grey.shade700,
              ),
            ),
            if (hasSelection) ...[
              Text(
                selectedDate != null
                    ? DateFormat("d MMM").format(selectedDate)
                    : "Date",
                style: TextStyle(fontSize: 10, color: ColorRes.primary),
              ),
              if (selectedTime != null)
                Text(
                  selectedTime.format(context),
                  style: TextStyle(fontSize: 10, color: ColorRes.primary),
                ),
            ] else
              Text(
                "Tap to choose",
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetReminderButton() {
    return Obx(() {
      bool isEnabled = controller.selectedDate.value != null;

      return Container(
        // duration: const Duration(milliseconds: 300),
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: isEnabled ? 4 : 0,
            backgroundColor: isEnabled ? ColorRes.white : Colors.grey.shade300,
            foregroundColor: isEnabled ? Colors.white : Colors.grey.shade500,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ColorRes.primary),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed:
              isEnabled
                  ? () {
                    Get.snackbar(
                      "🎉 Reminder Set!",
                      "Visit planned for ${controller.formattedDate} at ${controller.formattedTime}",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: ColorRes.primary,
                      colorText: Colors.white,
                      borderRadius: 12,
                      margin: const EdgeInsets.all(16),
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      duration: const Duration(seconds: 3),
                    );
                  }
                  : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                size: 20,
                color: ColorRes.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isEnabled ? "Set Reminder" : "Select Date First",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorRes.primary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAlternativeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Or",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 16),
          ShareReminderButton(),
        ],
      ),
    );
  }

  Widget _buildEnhancedStep(
    IconData icon,
    String title,
    String subtitle,
    int index,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedConnector() {
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 35),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorRes.primary.withOpacity(0.3),
            ColorRes.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  // Enhanced BottomSheet Picker
  void _openEnhancedDateTimePicker(BuildContext context) {
    final controller = Get.find<CreatePropertyController>();
    DateTime tempDate = controller.selectedDate.value ?? DateTime.now();
    TimeOfDay tempTime = controller.selectedTime.value ?? TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: StatefulBuilder(
              builder: (ctx, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.event_outlined,
                            color: ColorRes.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Pick Date & Time",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Enhanced Calendar
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(ctx).copyWith(
                          datePickerTheme: DatePickerThemeData(
                            dayStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            todayForegroundColor: WidgetStateProperty.all(
                              ColorRes.primary,
                            ),
                            // --- Circle for Selected Day ---
                            dayOverlayColor: WidgetStateProperty.all(
                              ColorRes.primary.withOpacity(0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: ColorRes.primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            // Circle background for selected date
                            rangeSelectionBackgroundColor: ColorRes.primary
                                .withOpacity(0.2),
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 60),
                          ),
                          onDateChanged: (date) {
                            setState(() => tempDate = date);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Enhanced Time Picker
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: tempTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: ColorRes.primary,
                                  ),
                                ),

                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => tempTime = picked);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Selected Time",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  tempTime.format(ctx),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Enhanced Confirm Button
                    SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: ColorRes.primary.withOpacity(0.3),
                          ),
                          onPressed: () {
                            controller.setDateTime(tempDate, tempTime);
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            "Confirm Selection",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ShareReminderButton extends StatelessWidget {
  const ShareReminderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: ColorRes.primary.withOpacity(0.2),
        ),
        onPressed: () {
          // Trigger share event
          Share.share(
            "Skip reminder and verify property directly when you visit",
            subject: "Property Verification",
          );
        },

        child: Text(
          "Share link with others",
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
