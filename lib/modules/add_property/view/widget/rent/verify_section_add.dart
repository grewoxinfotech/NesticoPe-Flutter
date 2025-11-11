import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../create_property.dart';

// class VerifySection extends StatelessWidget {
//   final CreatePropertyController controller;
//   const VerifySection({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.lookingTo.value == "Rent" ||
//           controller.lookingTo.value == "Sell") {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 24),
//
//             // Enhanced Steps Section
//             _buildVerificationSteps(),
//
//             const SizedBox(height: 24),
//
//             // Enhanced Plan Visit Section
//             _buildPlanVisitSection(context),
//
//             const SizedBox(height: 24),
//
//             // Enhanced Set Reminder Button
//             _buildSetReminderButton(),
//
//             const SizedBox(height: 24),
//
//             // Enhanced Alternative Section
//             _buildAlternativeSection(),
//           ],
//         );
//       }
//       return const SizedBox.shrink();
//     });
//   }
//
//   Widget _buildVerificationSteps() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.verified_outlined,
//                   color: ColorRes.primary,
//                   size: 16,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Verification Steps',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.bodyMedium,
//                   // fontSize: 15,
//                   fontWeight: AppFontWeights.bold,
//                   // fontWeight: AppFontWeights.bold,
//                   color: ColorRes.blackShade87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildEnhancedStep(
//                 Icons.location_on_outlined,
//                 "Visit Property",
//                 "Go to the location",
//                 0,
//               ),
//
//               _buildEnhancedStep(
//                 Icons.link_outlined,
//                 "Open Link",
//                 "Access verification",
//                 1,
//               ),
//
//               _buildEnhancedStep(
//                 Icons.camera_alt_outlined,
//                 "Take Photos",
//                 "Capture evidence",
//                 2,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlanVisitSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: ColorRes.blueColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.schedule_outlined,
//                   color: ColorRes.blueColor,
//                   size: 16,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Plan Your Visit',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.bodyMedium,
//                   // fontSize: 15,
//                   fontWeight: AppFontWeights.bold,
//                   // fontWeight: AppFontWeights.bold,
//                   color: ColorRes.blackShade87,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Schedule a convenient time for property verification",
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               // fontSize: 12,
//               color: ColorRes.leadGreyColor.shade600,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           // Enhanced Date/Time Selection
//           Row(
//             children: [
//               // Quick Today Option
//               Expanded(
//                 flex: 2,
//                 child: _buildQuickDateOption(
//                   "Today",
//                   DateFormat("d MMM").format(DateTime.now()),
//                   Icons.today_outlined,
//                   false,
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // Custom Date Selection
//               Expanded(
//                 flex: 3,
//                 child: Obx(() {
//                   final selected = controller.selectedDate.value;
//                   final selectedTime = controller.selectedTime.value;
//
//                   return _buildCustomDateTimeOption(
//                     context,
//                     selected,
//                     selectedTime,
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuickDateOption(
//     String title,
//     String date,
//     IconData icon,
//     bool isSelected,
//   ) {
//     return Container(
//       height: 120,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
//           width: isSelected ? 2 : 1,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         color:
//             isSelected
//                 ? ColorRes.primary.withOpacity(0.05)
//                 : ColorRes.leadGreyColor.shade50,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade600,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               // fontSize: 12,
//               fontWeight: AppFontWeights.semiBold,
//               color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade700,
//             ),
//           ),
//           Text(
//             date,
//             style: TextStyle(
//               fontSize: AppFontSizes.extraSmall,
//               // fontSize: 10,
//               color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCustomDateTimeOption(
//     BuildContext context,
//     DateTime? selectedDate,
//     TimeOfDay? selectedTime,
//   ) {
//     bool hasSelection = selectedDate != null || selectedTime != null;
//
//     return GestureDetector(
//       onTap: () => _openEnhancedDateTimePicker(context),
//       child: Container(
//         height: 120,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: hasSelection ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
//             width: hasSelection ? 2 : 1,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           color:
//               hasSelection
//                   ? ColorRes.primary.withOpacity(0.05)
//                   : ColorRes.leadGreyColor.shade50,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.event_outlined,
//               size: 20,
//               color: hasSelection ? ColorRes.primary : ColorRes.leadGreyColor.shade600,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               hasSelection ? "Custom" : "Select Date",
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: hasSelection ? ColorRes.primary : ColorRes.leadGreyColor.shade700,
//               ),
//             ),
//             if (hasSelection) ...[
//               Text(
//                 selectedDate != null
//                     ? DateFormat("d MMM").format(selectedDate)
//                     : "Date",
//                 style: TextStyle(fontSize: AppFontSizes.extraSmall, color: ColorRes.primary),
//               ),
//               if (selectedTime != null)
//                 Text(
//                   selectedTime.format(context),
//                   style: TextStyle(fontSize: AppFontSizes.extraSmall, color: ColorRes.primary),
//                 ),
//             ] else
//               Text(
//                 "Tap to choose",
//                 style: TextStyle(fontSize: AppFontSizes.extraSmall, color: ColorRes.leadGreyColor.shade500),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSetReminderButton() {
//     return Obx(() {
//       bool isEnabled = controller.selectedDate.value != null;
//
//       return Container(
//         // duration: const Duration(milliseconds: 300),
//         height: 50,
//         width: double.infinity,
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             elevation: isEnabled ? 4 : 0,
//             backgroundColor: isEnabled ? ColorRes.white : ColorRes.leadGreyColor.shade300,
//             foregroundColor: isEnabled ? ColorRes.white : ColorRes.leadGreyColor.shade500,
//             shape: RoundedRectangleBorder(
//               side: BorderSide(color: ColorRes.primary),
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//           onPressed:
//               isEnabled
//                   ? () {
//                     Get.snackbar(
//                       "🎉 Reminder Set!",
//                       "Visit planned for ${controller.formattedDate} at ${controller.formattedTime}",
//                       snackPosition: SnackPosition.TOP,
//                       backgroundColor: ColorRes.primary,
//                       colorText: ColorRes.white,
//                       borderRadius: 12,
//                       margin: const EdgeInsets.all(16),
//                       icon: const Icon(Icons.check_circle, color: ColorRes.white),
//                       duration: const Duration(seconds: 3),
//                     );
//                   }
//                   : null,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 isEnabled
//                     ? Icons.notifications_active
//                     : Icons.notifications_off,
//                 size: 20,
//                 color: ColorRes.primary,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 isEnabled ? "Set Reminder" : "Select Date First",
//                 style: TextStyle(
//                   fontSize: AppFontSizes.body,
//                   fontWeight: AppFontWeights.semiBold,
//                   color: ColorRes.primary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildAlternativeSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: Divider(color: ColorRes.leadGreyColor.shade300)),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   "Or",
//                   style: TextStyle(
//                     color: ColorRes.leadGreyColor.shade600,
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//               ),
//               Expanded(child: Divider(color: ColorRes.leadGreyColor.shade300)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ShareReminderButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEnhancedStep(
//     IconData icon,
//     String title,
//     String subtitle,
//     int index,
//   ) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.8)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Icon(icon, color: ColorRes.white, size: 22),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize:AppFontSizes.small,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.blackShade87,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize:AppFontSizes.extraSmall, color: ColorRes.leadGreyColor.shade600),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEnhancedConnector() {
//     return Container(
//       width: 30,
//       height: 2,
//       margin: const EdgeInsets.only(bottom: 35),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             ColorRes.primary.withOpacity(0.3),
//             ColorRes.primary.withOpacity(0.1),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(1),
//       ),
//     );
//   }
//
//   // Enhanced BottomSheet Picker
//   void _openEnhancedDateTimePicker(BuildContext context) {
//     final controller = Get.find<CreatePropertyController>();
//     DateTime tempDate = controller.selectedDate.value ?? DateTime.now();
//     TimeOfDay tempTime = controller.selectedTime.value ?? TimeOfDay.now();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: ColorRes.transparentColor,
//       builder: (ctx) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: ColorRes.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(ctx).viewInsets.bottom,
//               left: 20,
//               right: 20,
//               top: 20,
//             ),
//             child: StatefulBuilder(
//               builder: (ctx, setState) {
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Handle bar
//                     Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: ColorRes.leadGreyColor.shade300,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Header
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: ColorRes.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             Icons.event_outlined,
//                             color: ColorRes.primary,
//                             size: 18,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           "Pick Date & Time",
//                           style: TextStyle(
//                             fontSize: AppFontSizes.body,
//                             // fontSize: 16,
//                             fontWeight: AppFontWeights.bold,
//                             // fontWeight: AppFontWeights.bold,
//                             color: ColorRes.blackShade87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Enhanced Calendar
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: ColorRes.leadGreyColor.shade200),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Theme(
//                         data: Theme.of(ctx).copyWith(
//                           datePickerTheme: DatePickerThemeData(
//                             dayStyle: TextStyle(
//                               fontSize: 14,
//                               fontWeight: AppFontWeights.semiBold,
//                             ),
//                             todayForegroundColor: WidgetStateProperty.all(
//                               ColorRes.primary,
//                             ),
//                             // --- Circle for Selected Day ---
//                             dayOverlayColor: WidgetStateProperty.all(
//                               ColorRes.primary.withOpacity(0.2),
//                             ),
//                             shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                 color: ColorRes.primary,
//                                 width: 1.5,
//                               ),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             // Circle background for selected date
//                             rangeSelectionBackgroundColor: ColorRes.primary
//                                 .withOpacity(0.2),
//                           ),
//                         ),
//                         child: CalendarDatePicker(
//                           initialDate: tempDate,
//                           firstDate: DateTime.now(),
//                           lastDate: DateTime.now().add(
//                             const Duration(days: 60),
//                           ),
//                           onDateChanged: (date) {
//                             setState(() => tempDate = date);
//                           },
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Enhanced Time Picker
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: ColorRes.leadGreyColor.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: ColorRes.leadGreyColor.shade200),
//                       ),
//                       child: InkWell(
//                         onTap: () async {
//                           final picked = await showTimePicker(
//                             context: ctx,
//                             initialTime: tempTime,
//                             builder: (context, child) {
//                               return Theme(
//                                 data: Theme.of(context).copyWith(
//                                   colorScheme: ColorScheme.light(
//                                     primary: ColorRes.primary,
//                                   ),
//                                 ),
//
//                                 child: child!,
//                               );
//                             },
//                           );
//                           if (picked != null) {
//                             setState(() => tempTime = picked);
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: ColorRes.blueColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Icon(
//                                 Icons.access_time,
//                                 color: ColorRes.blueColor,
//                                 size: 20,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Selected Time",
//                                   style: TextStyle(
//                                     // fontSize: 12,
//                                     fontSize: AppFontSizes.small,
//                                     color:ColorRes.leadGreyColor,
//                                     fontWeight: AppFontWeights.medium,
//                                     // fontWeight: AppFontWeights.medium,
//                                   ),
//                                 ),
//                                 Text(
//                                   tempTime.format(ctx),
//                                   style: TextStyle(
//                                     fontSize: AppFontSizes.body,
//                                     // fontSize: 16,
//                                     fontWeight: AppFontWeights.semiBold,
//                                     // fontWeight: AppFontWeights.semiBold,
//                                     color: ColorRes.blackShade87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             Icon(
//                               Icons.chevron_right,
//                               color: ColorRes.leadGreyColor.shade400,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // Enhanced Confirm Button
//                     SafeArea(
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorRes.primary,
//                             foregroundColor: ColorRes.white,
//                             elevation: 2,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             shadowColor: ColorRes.primary.withOpacity(0.3),
//                           ),
//                           onPressed: () {
//                             controller.setDateTime(tempDate, tempTime);
//                             Navigator.pop(ctx);
//                           },
//                           child: Text(
//                             "Confirm Selection",
//                             style: TextStyle(
//                               // fontSize: 16,
//                               // fontWeight: AppFontWeights.semiBold,
//                               fontSize: AppFontSizes.body,
//                               fontWeight: AppFontWeights.semiBold,
//                               // color: ColorRes.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class ShareReminderButton extends StatelessWidget {
//   const ShareReminderButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: TextButton(
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.all(12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           backgroundColor: ColorRes.primary.withOpacity(0.2),
//         ),
//         onPressed: () {
//           // Trigger share event
//           Share.share(
//             "Skip reminder and verify property directly when you visit",
//             subject: "Property Verification",
//           );
//         },
//
//         child: Text(
//           "Share link with others",
//           style: TextStyle(
//             color: ColorRes.blueColor.shade700,
//             // fontSize: 11,
//             // fontWeight: AppFontWeights.medium,
//             fontSize: AppFontSizes.caption,
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ReviewPropertyScreen extends StatelessWidget {
  final CreatePropertyController controller;

  ReviewPropertyScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Obx(
              () =>  Column(
                children: [
                  // Success Card
                  const SizedBox(height: 16),
                  _buildSuccessCard(),

                  // if (controller.isEdited.value) const SizedBox(height: 16),
                  const SizedBox(height: 16),

                  // Pending Actions Card
                  if ((controller.imageList.isEmpty ||
                          controller.videoList.isEmpty) ||
                      controller.documentList.isEmpty) ...[
                    _buildPendingActionsCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        border: Border.all(color: ColorRes.border.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPropertyCard(),
        ],
      ),
    );
  }

  Widget _buildPropertyCard() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Summary Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: ColorRes.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Formatter.formatPrice(
                        int.tryParse(
                              controller.sell_ExpectedPrice.text.toString(),
                            ) ??
                            0,
                      ),
                      style: const TextStyle(
                        color: ColorRes.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: ColorRes.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text:
                                controller.rent_propertyType.value.isNotEmpty
                                    ? controller.rent_propertyType.value
                                    : controller.propertyType.value,
                          ),
                          TextSpan(
                            text: ' for ${controller.lookingTo.value}',
                            style: const TextStyle(
                              color: ColorRes.textSecondary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${controller.carpetAreaController.text} sq. ft. • ${controller.bhkType.value}',
                      style: const TextStyle(
                        color: ColorRes.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Detailed Property Information Sections
          _buildPropertyDetailsSection(),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Details
          _buildSectionTitle('Location Details'),
          const SizedBox(height: 10),
          // _buildDetailRow('Address', controller.sell_rent_Address.text),
          _buildDetailRow('City', controller.cityController.text),
          _buildDetailRow('Locality', controller.localityController.text),

          const SizedBox(height: 16),

          // Property Specifications
          _buildSectionTitle('Property Specifications'),
          const SizedBox(height: 10),
          _buildDetailRow(
            'Property Type',
            controller.rent_propertyType.value.isNotEmpty
                ? controller.rent_propertyType.value
                : controller.propertyType.value,
          ),
          _buildDetailRow('BHK', controller.bhkType.value),
          _buildDetailRow(
            'Carpet Area',
            '${controller.carpetAreaController.text} sq. ft.',
          ),
          _buildDetailRow(
            'Built-up Area',
            '${controller.areaController.text} sq. ft.',
          ),
          _buildDetailRow(
            'Floor',
            '${controller.sell_rent_Floor_No.text} / ${controller.sell_rent_Total_Floor.text}',
          ),
          if (controller.rent_facing.value.isNotEmpty)
            _buildDetailRow('Facing', controller.rent_facing.value),
          _buildDetailRow('Furnishing', controller.furnishingType.value),
          if (controller.rent_Balcony.value > 0)
            _buildDetailRow(
              'Balcony',
              controller.rent_Balcony.value.toString(),
            ),

          const SizedBox(height: 16),

          // Pricing Details
          _buildSectionTitle('Pricing Details'),
          const SizedBox(height: 10),
          if (controller.lookingTo.value == 'Rent') ...[
            _buildDetailRow(
              'Monthly Rent',
              Formatter.formatPrice(
                int.tryParse(controller.rent_MonthilyRent.text) ?? 0,
              ),
            ),
            _buildDetailRow(
              'Security Deposit',
              Formatter.formatPrice(
                int.tryParse(controller.rent_SecurityDeposit.text) ?? 0,
              ),
            ),
            if (controller.sell_rent_Maintenance_Charges.text.isNotEmpty)
              _buildDetailRow(
                'Maintenance',
                Formatter.formatPrice(
                  int.tryParse(controller.sell_rent_Maintenance_Charges.text) ??
                      0,
                ),
              ),
          ] else ...[
            _buildDetailRow(
              'Expected Price',
              Formatter.formatPrice(
                int.tryParse(controller.sell_ExpectedPrice.text) ?? 0,
              ),
            ),
          ],
          _buildDetailRow(
            'Price Negotiable',
            controller.negotiablePriceOrNot.value.isEmpty
                ? 'No'
                : controller.negotiablePriceOrNot.value,
          ),

          const SizedBox(height: 16),

          // Amenities
          if (controller.selectedRoomAmenities.isNotEmpty) ...[
            _buildSectionTitle('Amenities'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  controller.selectedRoomAmenities.map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorRes.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        amenity,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorRes.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Additional Details
          _buildSectionTitle('Additional Details'),
          const SizedBox(height: 10),
          if (controller.rent_AvailableFrom.text.isNotEmpty)
            _buildDetailRow(
              'Available From',
              controller.rent_AvailableFrom.text,
            ),
          if (controller.ageOfPropertyController.text.isNotEmpty)
            _buildDetailRow(
              'Age of Property',
              '${controller.ageOfPropertyController.text} years',
            ),
          if (controller.rent_Bathroom.value > 0)
            _buildDetailRow(
              'Bathrooms',
              controller.rent_Bathroom.value.toString(),
            ),
          if (controller.rent_OpenParking.value != '0')
            _buildDetailRow('Open Parking', controller.rent_OpenParking.value),
          if (controller.rent_CoveredParking.value != '0')
            _buildDetailRow(
              'Covered Parking',
              controller.rent_CoveredParking.value,
            ),

          // Description
          if (controller
              .sell_rent_propertyDescriptionController
              .text
              .isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Description'),
            const SizedBox(height: 10),
            Text(
              controller.sell_rent_propertyDescriptionController.text,
              style: const TextStyle(
                fontSize: 13,
                color: ColorRes.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style:  TextStyle(
        fontSize: AppFontSizes.medium,
        fontWeight: AppFontWeights.semiBold,
        color: ColorRes.textPrimary,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.textSecondary,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.textPrimary,
                fontWeight: AppFontWeights.semiBold
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ColorRes.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: ColorRes.error,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Pending Actions',
                  style: TextStyle(
                    color: ColorRes.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 44),
            child: Text(
              'Complete now to get more visibility & responses',
              style: TextStyle(
                color: ColorRes.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Add Photos Action
          _buildActionItem(
            icon: Icons.add_photo_alternate_rounded,
            iconBgColor: const Color(0xFFDEE7FF),
            iconColor: ColorRes.primary,
            title: 'Add Photos',
            description:
                'Properties with photos get 5x more responses from interested buyers. Go back to the previous step to add photos.',
            buttonText: 'Back to Add Photos',
            onPressed: () {
              // Navigate back to photo upload step
              controller.stepperSelectedIndex.value =
                  controller.stepperSelectedIndex.value - 3;
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.background.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorRes.border.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ColorRes.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: ColorRes.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                foregroundColor: ColorRes.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
