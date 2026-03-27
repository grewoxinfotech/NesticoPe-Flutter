import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/calender/model/calender_model.dart';
import 'package:nesticope_app/modules/calender/views/widgets/add_event_widget.dart';
import 'package:nesticope_app/modules/calender/views/widgets/calender_event_card.dart';
import 'package:nesticope_app/utils/shimmer/common_screen/calender_screen/calender_screen_shimmer.dart';
import 'package:nesticope_app/widgets/dialog/delete_confirmation_dialog.dart';

import 'package:intl/intl.dart';

import '../controllers/calender_controller.dart';
import '../controllers/calender_event_category_controller.dart';
import '../controllers/calender_event_controller.dart';
//
// class CalendarScreen extends StatelessWidget {
//   final CalendarController controller = Get.put(CalendarController());
//   final CalenderEventController _eventController = Get.put(
//     CalenderEventController(),
//   );
//   final CalenderCategoryController _categoryController = Get.put(
//     CalenderCategoryController(),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text('Add Event',style: TextStyle(fontWeight: AppFontWeights.semiBold),),
//         centerTitle: true,
//         actions: [
//           IconButton(onPressed: () => showEventDialog(), icon: Icon(Icons.add)),
//         ],
//       ),
//       body: Column(
//         children: [
//           // ---- Month Navigation Row ----
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//             children: [
//               IconButton(
//                 onPressed: controller.previousMonth,
//                 icon: Icon(Icons.keyboard_arrow_left_rounded),
//               ),
//               Obx(
//                 () => Text(
//                   "${DateFormat.MMMM().format(controller.currentDate.value)} "
//                   "${controller.currentDate.value.year}",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: ColorRes.leadGreyColor.shade600),
//                 ),
//               ),
//               IconButton(
//                 onPressed: controller.nextMonth,
//                 icon: Icon(Icons.keyboard_arrow_right_rounded),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//           SizedBox(
//             // flex: 1,
//             height: 350,
//             child: Card(
//
//               child: Column(
//                 children: [
//                   buildWeekDays(),
//                   Expanded(
//                     child: Card(
//                       child: PageView.builder(
//                         controller: controller.pageController,
//                         onPageChanged: controller.onPageChanged,
//                         itemBuilder: (context, index) {
//                           final date = DateTime(
//                             DateTime.now().year,
//                             DateTime.now().month + (index - 5000),
//                             1,
//                           );
//                           return buildMonthGrid(date);
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // ---- Events Section ----
//           Expanded(
//             flex: 1,
//             child: Card(
//               margin: const EdgeInsets.all(12),
//               child: Obx(() {
//                 final grouped = _eventController.eventsGroupedByDate;
//
//
//                 if (grouped.isEmpty) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Text("No events found"),
//                     ),
//                   );
//                 }
//
//                 final today = DateTime.now();
//                 final todayNormalized = DateTime(
//                   today.year,
//                   today.month,
//                   today.day,
//                 );
//
//                 // Filter only today or future dates
//                 final upcomingDates =
//                     grouped.keys
//                         .where((date) => !date.isBefore(todayNormalized))
//                         .toList()
//                       ..sort((a, b) => a.compareTo(b));
//
//                 if (upcomingDates.isEmpty) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Text("No upcoming events"),
//                     ),
//                   );
//                 }
//
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     children: [
//                       for (final date in upcomingDates)
//                         EventDateSection(
//                           date: _formatDate(date),
//                           events: [
//                             for (final event in grouped[date]!)
//                               EventCard(
//                                 title: event.title ?? "",
//                                 description: "All day — ${event.details ?? ""}",
//                                 tag: event.categoryName ?? "",
//                                 tagColor: Colors.blue,
//                                 onEdit: () {
//                                   showEventDialog(event: event, isEdit: true);
//                                 },
//                                 onDelete: () {
//                                   showDeleteConfirmationDialog(
//                                     onConfirm: () {
//                                       _eventController.deleteEvent(event.id);
//                                     },
//                                   );
//                                 },
//                               ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Weekdays header
//   Widget buildWeekDays() {
//     final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children:
//           days
//               .map(
//                 (e) => Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     alignment: Alignment.center,
//                     child: Text(
//                       e[0],
//                       style: TextStyle(fontWeight: AppFontWeights.semiBold),
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//     );
//   }
//
//   // Month grid
//   Widget buildMonthGrid(DateTime date) {
//     final controller = Get.find<CalendarController>();
//     final today = DateTime.now();
//     final todayNormalized = DateTime(today.year, today.month, today.day);
//
//     final firstDayOfMonth = DateTime(date.year, date.month, 1);
//     final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
//     final daysInMonth = lastDayOfMonth.day;
//     final firstWeekday = firstDayOfMonth.weekday % 7;
//
//     List<Widget> dayWidgets = [];
//
//     // Empty cells before first day of month
//     for (int i = 0; i < firstWeekday; i++) {
//       dayWidgets.add(Container());
//     }
//
//     for (int day = 1; day <= daysInMonth; day++) {
//       final dayDate = DateTime(date.year, date.month, day);
//
//       dayWidgets.add(
//         GestureDetector(
//           onTap:
//               dayDate.isBefore(todayNormalized)
//                   ? null
//                   : () => showEventDialog(
//                     event: CalenderEventModel(date: dayDate.toString()),
//                   ),
//           child: Obx(() {
//             final isSelected =
//                 controller.selectedDate.value != null &&
//                 DateFormat(
//                       'yyyy-MM-dd',
//                     ).format(controller.selectedDate.value!) ==
//                     DateFormat('yyyy-MM-dd').format(dayDate);
//
//             final hasEvent =
//                 _eventController.getEventsForDate(dayDate).isNotEmpty;
//
//             // Determine text & background color
//             Color bgColor = Colors.transparent;
//             Color textColor = Colors.black;
//
//             if (isSelected) {
//               bgColor = Colors.blue;
//               textColor = Colors.white;
//             } else if (dayDate.isBefore(todayNormalized)) {
//               textColor = ColorRes.leadGreyColor.shade600; // past dates gray
//             } else if (dayDate == todayNormalized) {
//               bgColor = Colors.orangeAccent.withOpacity(
//                 0.3,
//               ); // today highlighted
//               textColor = Colors.black;
//             }
//
//             return Container(
//               margin: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 // borderRadius: BorderRadius.circular(8),
//                 shape: BoxShape.circle
//               ),
//               alignment: Alignment.center,
//               child: Stack(
//                 children: [
//                   Center(
//                     child: Text(
//                       "$day",
//                       style: TextStyle(
//                         color: textColor,
//                         fontWeight:
//                             dayDate == todayNormalized ? AppFontWeights.semiBold : null,
//                       ),
//                     ),
//                   ),
//                   if (hasEvent)
//                     Positioned(
//                       bottom: 4,
//                       right: 16,
//                       child: Container(
//                         width: 6,
//                         height: 6,
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       );
//     }
//
//     return GridView.count(
//       crossAxisCount: 7,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       children: dayWidgets,
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return "${_monthName(date.month)} ${date.day}, ${date.year}";
//   }
//
//   String _monthName(int m) {
//     const months = [
//       "January",
//       "February",
//       "March",
//       "April",
//       "May",
//       "June",
//       "July",
//       "August",
//       "September",
//       "October",
//       "November",
//       "December",
//     ];
//     return months[m - 1];
//   }
// }
//
// //   void showAddEventDialog({DateTime? date}) {
// //     final eventController = Get.find<CalenderEventController>();
// //
// //     // Text controllers
// //     final titleCtrl = TextEditingController();
// //     final detailsCtrl = TextEditingController();
// //     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //     final dropdownKey = GlobalKey<_CustomDropdownWithAddState>();
// //     // Selected values
// //     Rx<DateTime> selectedDate = (date ?? DateTime.now()).obs;
// //
// //     Get.dialog(
// //       Dialog(
// //         backgroundColor: ColorRes.white,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         child: Container(
// //           constraints: BoxConstraints(
// //             maxHeight: Get.height * 0.8, // Maximum 80% of screen
// //             maxWidth: Get.width * 0.9,
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Dialog Title
// //               Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Text(
// //                   "Add Event",
// //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //
// //               // Scrollable Content
// //               Flexible(
// //                 child: SingleChildScrollView(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // ------------------ TITLE -------------------
// //                         NesticoPeTextField(
// //                           title: "Title",
// //                           hintText: "Enter title...",
// //                           autovalidateMode: AutovalidateMode.onUserInteraction,
// //                           validator: (value) => requiredField(value, 'Title'),
// //                           controller: titleCtrl,
// //                         ),
// //                         const SizedBox(height: 12),
// //
// //                         // ------------------ DATE PICKER -------------------
// //                         DatePickerTextField(
// //                           title: "Date",
// //                           hintText: "Select date",
// //                           selectedDate: selectedDate,
// //                           onDatePicked: (d) {},
// //                         ),
// //
// //                         const SizedBox(height: 12),
// //
// //                         // ------------------ CATEGORY DROPDOWN -------------------
// //                         Obx(() {
// //                           return CustomDropdownWithAdd<CalenderCategoryModel>(
// //                             key: dropdownKey,
// //                             title: "Category",
// //                             hintText: "Select category",
// //                             value: eventController.selectedCategory.value,
// //                             items: eventController.categories,
// //                             itemBuilder:
// //                                 (c) => Row(
// //                                   children: [
// //                                     Expanded(
// //                                       child: Text(
// //                                         c.name ?? "-",
// //                                         overflow: TextOverflow.ellipsis,
// //                                       ),
// //                                     ),
// //                                     if (c.createdBy.toLowerCase() != 'system')
// //                                       Row(
// //                                         children: [
// //                                           GestureDetector(
// //                                             onTap: () async {
// //                                               dropdownKey.currentState
// //                                                   ?.closeDropdown();
// //                                               final category =
// //                                                   await openAddCategoryDialog(
// //                                                     initialText: c.name,
// //                                                     isEdit: true,
// //                                                   );
// //                                               if (category != null) {
// //                                                 c.name = category;
// //                                                 await _categoryController
// //                                                     .updateCategory(c);
// //                                                 await eventController
// //                                                     .loadCategories();
// //                                                 eventController
// //                                                     .selectedCategory
// //                                                     .value = eventController
// //                                                     .categories
// //                                                     .firstWhereOrNull(
// //                                                       (element) =>
// //                                                           element.name ==
// //                                                           category,
// //                                                     );
// //                                               }
// //                                             },
// //                                             child: Icon(
// //                                               Icons.edit_outlined,
// //                                               color: ColorRes.primary,
// //                                             ),
// //                                           ),
// //                                           SizedBox(width: 10),
// //                                           GestureDetector(
// //                                             onTap: () {
// //                                               dropdownKey.currentState
// //                                                   ?.closeDropdown();
// //
// //                                               showDeleteConfirmationDialog(
// //                                                 onConfirm: () async {
// //                                                   // 1️⃣ If deleting selected category → switch to another one first
// //                                                   if (eventController
// //                                                           .selectedCategory
// //                                                           .value ==
// //                                                       c) {
// //                                                     if (eventController
// //                                                             .categories
// //                                                             .length >
// //                                                         1) {
// //                                                       eventController
// //                                                               .selectedCategory
// //                                                               .value =
// //                                                           eventController
// //                                                               .categories
// //                                                               .firstWhere(
// //                                                                 (item) =>
// //                                                                     item.id !=
// //                                                                     c.id,
// //                                                               );
// //                                                     } else {
// //                                                       // only one category exists
// //                                                       eventController
// //                                                           .selectedCategory
// //                                                           .value = null;
// //                                                     }
// //                                                   }
// //
// //                                                   // 2️⃣ Call API and delete category
// //                                                   await _categoryController
// //                                                       .deleteCategory(c.id);
// //
// //                                                   // 3️⃣ Remove from list
// //                                                   eventController.categories
// //                                                       .removeWhere(
// //                                                         (x) => x.id == c.id,
// //                                                       );
// //                                                 },
// //                                                 title: 'Delete',
// //                                                 message:
// //                                                     "Are you sure to delete \"${c.name}\" category?",
// //                                                 confirmText: 'Delete',
// //                                                 cancelText: 'Cancel',
// //                                                 confirmColor: ColorRes.error,
// //                                               );
// //                                             },
// //                                             child: Icon(
// //                                               Icons.delete_outline,
// //                                               color: ColorRes.error,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                   ],
// //                                 ),
// //                             onChanged: (value) {
// //                               eventController.selectedCategory.value = value;
// //                             },
// //                             onAddPressed: () async {
// //                               final category = await openAddCategoryDialog();
// //                               if (category != null) {
// //                                 final categoryController =
// //                                     Get.find<CalenderCategoryController>();
// //                                 await categoryController.addCategory(category);
// //                                 await eventController.loadCategories();
// //                                 eventController.selectedCategory.value =
// //                                     eventController.categories.firstWhereOrNull(
// //                                       (element) => element.name == category,
// //                                     );
// //                               }
// //                             },
// //                           );
// //                         }),
// //
// //                         const SizedBox(height: 12),
// //
// //                         // ------------------ DETAILS FIELD -------------------
// //                         NesticoPeTextField(
// //                           title: "Details",
// //                           hintText: "Enter details...",
// //                           autovalidateMode: AutovalidateMode.onUserInteraction,
// //                           validator: (value) => requiredField(value, 'Title'),
// //                           maxLines: 3,
// //                           controller: detailsCtrl,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Action Buttons
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: TextButton(
// //                         onPressed: () {
// //                           Get.back();
// //                         },
// //                         child: Text('Cancel'),
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: NesticoPeButton(
// //                         title: 'Add',
// //                         onTap: () async {
// //                           if (!_formKey.currentState!.validate()) {
// //                             return;
// //                           }
// //
// //                           final newEvent = CalenderEventModel(
// //                             title: titleCtrl.text.trim(),
// //                             date: selectedDate.value.toString(),
// //                             category:
// //                                 eventController.selectedCategory.value!.id,
// //                             details: detailsCtrl.text.trim(),
// //                           );
// //
// //                           final result = await eventController.addEvent(
// //                             newEvent,
// //                           );
// //                           if (result) Get.back();
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       barrierDismissible: false,
// //     );
// //   }
// //
// //   Future<String?> openAddCategoryDialog({
// //     String? initialText,
// //     bool isEdit = false,
// //   }) async {
// //     final TextEditingController textCtrl = TextEditingController(
// //       text: initialText ?? "",
// //     );
// //
// //     return await Get.defaultDialog<String?>(
// //       title: isEdit ? "Edit Category" : "Add Category",
// //       barrierDismissible: false,
// //       content: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           TextField(
// //             controller: textCtrl,
// //             decoration: InputDecoration(
// //               hintText: "Enter category name",
// //               border: OutlineInputBorder(),
// //               contentPadding: const EdgeInsets.symmetric(
// //                 horizontal: 12,
// //                 vertical: 10,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       textConfirm: isEdit ? "Update" : "Add",
// //       textCancel: "Cancel",
// //       onConfirm: () {
// //         final text = textCtrl.text.trim();
// //         if (text.isEmpty) {
// //           Get.snackbar("Error", "Please enter category name");
// //           return;
// //         }
// //         Get.back(result: text); // return text
// //       },
// //       onCancel: () {
// //         Get.back(result: null); // return nothing
// //       },
// //     );
// //   }
// // }
// //
// // class DatePickerTextField extends StatelessWidget {
// //   final String title;
// //   final String hintText;
// //   final Rx<DateTime> selectedDate;
// //   final Function(DateTime) onDatePicked;
// //
// //   const DatePickerTextField({
// //     super.key,
// //     required this.title,
// //     required this.hintText,
// //     required this.selectedDate,
// //     required this.onDatePicked,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(() {
// //       return InkWell(
// //         onTap: () async {
// //           final picked = await showDatePicker(
// //             context: context,
// //             initialDate: selectedDate.value,
// //             firstDate: DateTime(2000),
// //             lastDate: DateTime(2050),
// //           );
// //           if (picked != null) {
// //             selectedDate.value = picked;
// //             onDatePicked(picked);
// //           }
// //         },
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (title.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(bottom: 6),
// //                 child: Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ),
// //
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.grey.shade400),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Row(
// //                 children: [
// //                   const Icon(
// //                     Icons.calendar_today,
// //                     size: 18,
// //                     color: Colors.grey,
// //                   ),
// //                   const SizedBox(width: 10),
// //                   Text(
// //                     DateFormat("dd-MM-yyyy").format(selectedDate.value),
// //                     style: const TextStyle(fontSize: 14),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }
// //
// // class CustomDropdownWithAdd<T> extends StatefulWidget {
// //   final String title;
// //   final String hintText;
// //   final T? value;
// //   final List<T> items;
// //   final Widget Function(T item) itemBuilder;
// //   final Function(T?) onChanged;
// //   final VoidCallback onAddPressed;
// //
// //   const CustomDropdownWithAdd({
// //     super.key,
// //     required this.title,
// //     required this.hintText,
// //     required this.value,
// //     required this.items,
// //     required this.itemBuilder,
// //     required this.onChanged,
// //     required this.onAddPressed,
// //   });
// //
// //   @override
// //   State<CustomDropdownWithAdd<T>> createState() =>
// //       _CustomDropdownWithAddState<T>();
// // }
// //
// // class _CustomDropdownWithAddState<T> extends State<CustomDropdownWithAdd<T>> {
// //   final LayerLink _layerLink = LayerLink();
// //   OverlayEntry? _overlayEntry;
// //   bool isOpen = false;
// //
// //   // Public method to close dropdown - can be called via GlobalKey
// //   void closeDropdown() {
// //     if (!isOpen) return;
// //     _overlayEntry?.remove();
// //     _overlayEntry = null;
// //     if (mounted) {
// //       setState(() => isOpen = false);
// //     }
// //   }
// //
// //   void toggleDropdown() {
// //     if (isOpen) {
// //       closeDropdown();
// //     } else {
// //       openDropdown();
// //     }
// //   }
// //
// //   void openDropdown() {
// //     _overlayEntry = _createOverlay();
// //     Overlay.of(context).insert(_overlayEntry!);
// //     setState(() => isOpen = true);
// //   }
// //
// //   OverlayEntry _createOverlay() {
// //     RenderBox box = context.findRenderObject() as RenderBox;
// //     final size = box.size;
// //     final offset = box.localToGlobal(Offset.zero);
// //     final screenHeight = MediaQuery.of(context).size.height;
// //
// //     // Calculate height for 4 items (each item ~48px + padding)
// //     const itemHeight = 48.0;
// //     const maxItems = 4;
// //     const addButtonHeight = 50.0;
// //     final dropdownHeight =
// //         (itemHeight * maxItems) + addButtonHeight + 16; // 16 for padding
// //
// //     // Calculate available space below and above
// //     final spaceBelow = screenHeight - offset.dy - size.height;
// //     final spaceAbove = offset.dy;
// //     final showAbove = spaceBelow < dropdownHeight && spaceAbove > spaceBelow;
// //
// //     return OverlayEntry(
// //       builder:
// //           (context) => GestureDetector(
// //             onTap: closeDropdown,
// //             behavior: HitTestBehavior.translucent,
// //             child: Stack(
// //               children: [
// //                 Positioned(
// //                   width: size.width,
// //                   child: CompositedTransformFollower(
// //                     link: _layerLink,
// //                     showWhenUnlinked: false,
// //                     offset:
// //                         showAbove
// //                             ? Offset(0, -250 - 6) // Show above
// //                             : Offset(0, size.height + 6), // Show below
// //                     child: Material(
// //                       elevation: 8,
// //                       borderRadius: BorderRadius.circular(12),
// //                       shadowColor: Colors.black26,
// //                       child: Container(
// //                         constraints: BoxConstraints(maxHeight: dropdownHeight),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(12),
// //                           border: Border.all(
// //                             color: Colors.grey.shade200,
// //                             width: 1,
// //                           ),
// //                         ),
// //                         child: ClipRRect(
// //                           borderRadius: BorderRadius.circular(12),
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               // Items List
// //                               if (widget.items.isNotEmpty)
// //                                 Flexible(
// //                                   child: ListView.separated(
// //                                     padding: const EdgeInsets.symmetric(
// //                                       vertical: 8,
// //                                     ),
// //                                     shrinkWrap: true,
// //                                     itemCount: widget.items.length,
// //                                     separatorBuilder:
// //                                         (_, __) => Divider(
// //                                           height: 1,
// //                                           indent: 12,
// //                                           endIndent: 12,
// //                                           color: Colors.grey.shade200,
// //                                         ),
// //                                     itemBuilder: (context, index) {
// //                                       final item = widget.items[index];
// //                                       final isSelected = widget.value == item;
// //
// //                                       return InkWell(
// //                                         onTap: () {
// //                                           widget.onChanged(item);
// //                                           closeDropdown();
// //                                         },
// //                                         child: Container(
// //                                           height: itemHeight,
// //                                           padding: const EdgeInsets.symmetric(
// //                                             horizontal: 16,
// //                                           ),
// //                                           alignment: Alignment.centerLeft,
// //                                           color:
// //                                               isSelected
// //                                                   ? Colors.blue.shade50
// //                                                   : Colors.transparent,
// //                                           child: widget.itemBuilder(item),
// //                                         ),
// //                                       );
// //                                     },
// //                                   ),
// //                                 ),
// //
// //                               // Empty State
// //                               if (widget.items.isEmpty)
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(16),
// //                                   child: Text(
// //                                     "No categories available",
// //                                     style: TextStyle(
// //                                       color: Colors.grey.shade600,
// //                                       fontSize: 14,
// //                                     ),
// //                                   ),
// //                                 ),
// //
// //                               // Divider before Add button
// //                               Divider(
// //                                 height: 1,
// //                                 thickness: 1,
// //                                 color: Colors.grey.shade300,
// //                               ),
// //
// //                               // Add New Button
// //                               InkWell(
// //                                 onTap: () {
// //                                   closeDropdown();
// //                                   widget.onAddPressed();
// //                                 },
// //                                 child: Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                     horizontal: 16,
// //                                     vertical: 14,
// //                                   ),
// //                                   child: Row(
// //                                     children: [
// //                                       Icon(
// //                                         Icons.add_circle_outline,
// //                                         color: Colors.blue.shade600,
// //                                         size: 20,
// //                                       ),
// //                                       const SizedBox(width: 12),
// //                                       Text(
// //                                         "Add New Category",
// //                                         style: TextStyle(
// //                                           color: Colors.blue.shade600,
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 15,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _overlayEntry?.remove();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return CompositedTransformTarget(
// //       link: _layerLink,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Title Label
// //           Text(
// //             widget.title,
// //             style: const TextStyle(
// //               fontWeight: FontWeight.w600,
// //               fontSize: 14,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //
// //           // Dropdown Field
// //           InkWell(
// //             onTap: toggleDropdown,
// //             borderRadius: BorderRadius.circular(10),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 border: Border.all(
// //                   color: isOpen ? Colors.blue.shade400 : Colors.grey.shade300,
// //                   width: isOpen ? 2 : 1,
// //                 ),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Text(
// //                       widget.value != null
// //                           ? (widget.value as dynamic).name ?? ""
// //                           : widget.hintText,
// //                       style: TextStyle(
// //                         color:
// //                             widget.value == null
// //                                 ? Colors.grey.shade500
// //                                 : Colors.black87,
// //                         fontSize: 15,
// //                         fontWeight:
// //                             widget.value == null
// //                                 ? FontWeight.normal
// //                                 : FontWeight.w500,
// //                       ),
// //                     ),
// //                   ),
// //                   Icon(
// //                     isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
// //                     color: isOpen ? Colors.blue.shade400 : Colors.grey.shade600,
// //                     size: 28,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController controller = Get.put(CalendarController());
  final CalenderEventController _eventController = Get.put(
    CalenderEventController(),
  );
  final CalenderCategoryController _categoryController = Get.put(
    CalenderCategoryController(),
  );

  bool _hasLoadedOnce = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showEventDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // ---- Month Navigation Row ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: controller.previousMonth,
                icon: const Icon(Icons.keyboard_arrow_left_rounded),
              ),
              Obx(
                () => Text(
                  "${DateFormat.MMMM().format(controller.currentDate.value)} "
                  "${controller.currentDate.value.year}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorRes.leadGreyColor.shade600,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.nextMonth,
                icon: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ---- Calendar ----
          SizedBox(
            height: 350,
            child: Card(
              child: Column(
                children: [
                  buildWeekDays(),
                  Expanded(
                    child: Card(
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        itemBuilder: (context, index) {
                          final date = DateTime(
                            DateTime.now().year,
                            DateTime.now().month + (index - 5000),
                            1,
                          );
                          return buildMonthGrid(date);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- Events Section ----
          Expanded(
            flex: 1,
            child: Card(
              margin: const EdgeInsets.all(12),
              child: Obx(() {
                final grouped = _eventController.eventsGroupedByDate;

                // ✅ UI-only loading
                if (_eventController.isLoading.value && grouped.isEmpty) {
                  return CalenderScreenShimmer();
                }

                if (!_eventController.isLoading.value && grouped.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No events found"),
                    ),
                  );
                }

                final today = DateTime.now();
                final todayNormalized = DateTime(
                  today.year,
                  today.month,
                  today.day,
                );

                final upcomingDates =
                    grouped.keys
                        .where((date) => !date.isBefore(todayNormalized))
                        .toList()
                      ..sort((a, b) => a.compareTo(b));

                if (upcomingDates.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No upcoming events"),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final date in upcomingDates)
                        EventDateSection(
                          date: _formatDate(date),
                          events: [
                            for (final event in grouped[date]!)
                              EventCard(
                                title: event.title ?? "",
                                description: "All day — ${event.details ?? ""}",
                                tag: event.categoryName ?? "",
                                tagColor: Colors.blue,
                                onEdit: () {
                                  showEventDialog(event: event, isEdit: true);
                                },
                                onDelete: () {
                                  showDeleteConfirmationDialog(
                                    onConfirm: () {
                                      _eventController.deleteEvent(event.id);
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Weekdays header ----
  Widget buildWeekDays() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          days
              .map(
                (e) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      e[0],
                      style: TextStyle(fontWeight: AppFontWeights.semiBold),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  // ---- Month grid ----
  Widget buildMonthGrid(DateTime date) {
    final calendarController = Get.find<CalendarController>();
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final dayDate = DateTime(date.year, date.month, day);

      dayWidgets.add(
        GestureDetector(
          onTap:
              dayDate.isBefore(todayNormalized)
                  ? null
                  : () => showEventDialog(
                    event: CalenderEventModel(date: dayDate.toString()),
                  ),
          child: Obx(() {
            final isSelected =
                calendarController.selectedDate.value != null &&
                DateFormat(
                      'yyyy-MM-dd',
                    ).format(calendarController.selectedDate.value!) ==
                    DateFormat('yyyy-MM-dd').format(dayDate);

            final hasEvent =
                _eventController.getEventsForDate(dayDate).isNotEmpty;

            Color bgColor = Colors.transparent;
            Color textColor = Colors.black;

            if (isSelected) {
              bgColor = Colors.blue;
              textColor = Colors.white;
            } else if (dayDate.isBefore(todayNormalized)) {
              textColor = ColorRes.leadGreyColor.shade600;
            } else if (dayDate == todayNormalized) {
              bgColor = Colors.orangeAccent.withOpacity(0.3);
            }

            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: textColor,
                        fontWeight:
                            dayDate == todayNormalized
                                ? AppFontWeights.semiBold
                                : null,
                      ),
                    ),
                  ),
                  if (hasEvent)
                    Positioned(
                      bottom: 4,
                      right: 16,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m - 1];
  }
}
