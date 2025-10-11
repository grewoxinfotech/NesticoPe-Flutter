// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// import 'package:intl/intl.dart';
//
// import '../controllers/lead_controller.dart';
//
// final List<Map<String, dynamic>> dummyLeads = [
//   {
//     "name": "Ethan Valdez",
//     "email": "ethan.valdez@example.com",
//     "phone": "+91 98765 12345",
//     "property": {
//       "name": "2BHK Apartment in Viman Nagar",
//       "type": "Apartment",
//       "price": "65 Lakhs",
//       "area": "1200 sq ft",
//       "image": IMGRes.home1,
//       "propertyId": "PROP001",
//     },
//     "reseller": "RS1",
//     "source": "App",
//     "stage": "Interested",
//     "date": "23 Sep 2025",
//   },
//   {
//     "name": "Sophia Martinez",
//     "email": "sophia.m@example.com",
//     "phone": "+91 91234 56789",
//     "property": {
//       "name": "Luxury Villa in Goa",
//       "type": "Villa",
//       "price": "2.5 Cr",
//       "area": "3500 sq ft",
//       "image": IMGRes.home2,
//       "propertyId": "PROP002",
//     },
//     "reseller": "RS2",
//     "source": "Website",
//     "stage": "New Lead",
//     "date": "20 Sep 2025",
//   },
//   {
//     "name": "Arjun Sharma",
//     "email": "arjun.sharma@example.com",
//     "phone": "+91 99887 66554",
//     "property": {
//       "name": "3BHK Flat in Bandra, Mumbai",
//       "type": "Apartment",
//       "price": "1.8 Cr",
//       "area": "1800 sq ft",
//       "image": IMGRes.home3,
//       "propertyId": "PROP003",
//     },
//     "reseller": "RS3",
//     "source": "Referral",
//     "stage": "Contacted",
//     "date": "18 Sep 2025",
//   },
//   {
//     "name": "Liam Johnson",
//     "email": "liam.j@example.com",
//     "phone": "+91 98770 11223",
//     "property": {
//       "name": "Office Space in Connaught Place",
//       "type": "Commercial",
//       "price": "95 Lakhs",
//       "area": "2200 sq ft",
//       "image": IMGRes.home4,
//       "propertyId": "PROP004",
//     },
//     "reseller": "RS4",
//     "source": "Other",
//     "stage": "Negotiation",
//     "date": "15 Sep 2025",
//   },
//   {
//     "name": "Aarohi Mehta",
//     "email": "aarohi.mehta@example.com",
//     "phone": "+91 98989 77777",
//     "property": {
//       "name": "Penthouse in Pune",
//       "type": "Penthouse",
//       "price": "3.2 Cr",
//       "area": "4000 sq ft",
//       "image": IMGRes.project_1,
//       "propertyId": "PROP005",
//     },
//     "reseller": "RS5",
//     "source": "App",
//     "stage": "Site Visit",
//     "date": "10 Sep 2025",
//   },
// ];
//
// class LeadScreen extends StatelessWidget {
//   const LeadScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LeadController());
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Leads",
//             style: TextStyle(fontWeight: AppFontWeights.semiBold),
//           ),
//           elevation: 0,
//           backgroundColor: ColorRes.white,
//           foregroundColor: ColorRes.black,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(48.0),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SizedBox(
//                     width: 150,
//                     child: Obx(() => NesticoPeDropdownField(
//                       value: controller.selectedFilterStatus.value,
//                       items: controller.statusList
//                           .map((e) => DropdownMenuItem(
//                         value: e,
//                         child: Text(
//                           e,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: ColorRes.leadGreyColor[800],
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                       ))
//                           .toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           controller.selectedFilterStatus.value = value;
//                         }
//                       },
//                     )),
//                   ),
//                 ),
//
//                 SizedBox(
//                   width: 150,
//                   child: Obx(() => NesticoPeDropdownField(
//                     value: controller.selectedLeadType.value,
//                     items: controller.leadTypeList
//                         .map((e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(
//                         e,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: ColorRes.leadGreyColor[800],
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ))
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         controller.selectedLeadType.value = value;
//                       }
//                     },
//                   )),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [ColorRes.leadGreyColor[50]!, ColorRes.white],
//             ),
//           ),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: dummyLeads.length,
//             itemBuilder: (context, index) {
//               final lead = dummyLeads[index];
//               final controller = Get.put(LeadController(),tag: index.toString());
//               return LeadCard(
//                 name: lead['name'],
//                 email: lead['email'],
//                 phone: lead['phone'],
//                 property: lead['property'],
//                 reseller: lead['reseller'],
//                 source: lead['source'],
//                 stage: lead['stage'],
//                 date: lead['date'],
//                 controller: controller,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LeadCard extends StatelessWidget {
//   final String name;
//   final String email;
//   final String phone;
//   final Map<String, dynamic> property;
//   final String reseller;
//   final String source;
//   final String stage;
//   final String date;
//   final LeadController controller;
//
//   const LeadCard({
//     super.key,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.property,
//     required this.reseller,
//     required this.source,
//     required this.stage,
//     required this.date, required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor[300]!),
//         color: ColorRes.white,
//       ),
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: EdgeInsets.all(12),
//       child: GestureDetector(
//         onTap: () {
//           Get.bottomSheet(
//             DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.6,
//               // start height
//               minChildSize: 0.4,
//               // collapsed
//               maxChildSize: 0.62,
//               // expanded
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     color: ColorRes.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     controller: scrollController, // 🔑 connect controller
//                     child:  LeadDetailBottomSheet(controller:controller ,),
//                   ),
//                 );
//               },
//             ),
//             isScrollControlled: true, // allows full height
//             backgroundColor: Colors.transparent,
//           );
//         }, // Handle card tap for viewing details
//         // borderRadius: BorderRadius.circular(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "$name >",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: ColorRes.black54,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Obx(()=> _buildChip(controller.selectedFilterStatus.value)),
//                         const SizedBox(width: 4),
//                         Container(
//                           height: 16, // controls the divider height
//                           child: const VerticalDivider(
//                             thickness: 1,
//                             color: ColorRes.black54,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           date,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: ColorRes.leadGreyColor[600],
//                             fontWeight: AppFontWeights.medium,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Row(
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: ColorRes.primary.withOpacity(0.1),
//                       ),
//                       child: Icon(
//                         Icons.phone_outlined,
//                         color: ColorRes.primary,
//                       ),
//                     ),
//                     SizedBox(width: 6),
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: ColorRes.primary.withOpacity(0.1),
//                       ),
//                       child: Icon(
//                         Icons.email_outlined,
//                         color: ColorRes.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               property['name'],
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.leadGreyColor[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPropertyInfo(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: ColorRes.primary),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 13,
//             color: ColorRes.leadGreyColor[700],
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: ColorRes.leadGreyColor.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: ColorRes.black54,
//           fontSize: 12,
//           fontWeight: AppFontWeights.semiBold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color: ColorRes.leadGreyColor[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 size: 16,
//                 color: ColorRes.primary.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(text, style: TextStyle(fontSize: 13, color: ColorRes.leadGreyColor[800])),
//           ],
//         ),
//         Text(
//           date,
//           style: TextStyle(
//             fontSize: 12,
//             color: ColorRes.leadGreyColor[600],
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class LeadDetailBottomSheet extends StatelessWidget {
//   final LeadController controller;
//   const LeadDetailBottomSheet({super.key, required this.controller});
//
//   void pickDateTime(BuildContext context, LeadController controller) async {
//     // First pick the date
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       // Then pick the time
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         // Merge Date + Time into one DateTime
//         final DateTime fullDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         // Update your GetX state
//         controller.selectedDate.value = fullDateTime;
//         controller.dateController.text =
//             DateFormat('dd MMM yyyy, hh:mm a').format(fullDateTime);
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.find<LeadController>();
//     return Container(
//       // height: MediaQuery.of(context).size.height*0.75,
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       padding: EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Gunjan",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: ColorRes.black54,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Obx(
//                       ()=> Text(
//                         "${DateFormat('dd MMM yyyy, hh:mm a').format(controller.selectedDate.value!) ?? "N/A"}",
//                         style: TextStyle(fontSize: 12, color: ColorRes.black54),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Obx(
//                   ()=> SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.33,
//                     child: NesticoPeDropdownField(
//                       value: controller.selectedFilterStatus.value,
//                       items: controller.statusList.map((e) {
//                         return DropdownMenuItem(
//                           value: e,
//                           child: Text(
//                             e,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: ColorRes.leadGreyColor[800],
//                               fontWeight: AppFontWeights.semiBold,
//                             ),
//                           ),
//                         );
//                       }).toList(), // 🔑 convert to list
//                       onChanged: (value) {
//                         if (value != null) {
//                           controller.selectedFilterStatus.value = value;
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//             SizedBox(height: 16),
//             _buildTextWithIconAndButton(
//               Icons.calendar_month,
//               "Follow up",
//               "Set Date And Time",
//               () {
//                 pickDateTime(context, controller);
//               },
//             ),
//             SizedBox(height: 12),
//             _buildTextWithIconAndButton(Icons.note_add, "Notes", "Edit", () {}),
//             SizedBox(height: 12),
//             Divider(color: ColorRes.black12),
//             SizedBox(height: 12),
//             _buildInfoRow("Property", "2BHK Apartment in Viman Nagar"),
//             SizedBox(height: 8),
//             _buildInfoRow("Type", "Apartment"),
//             SizedBox(height: 8),
//             _buildInfoRow("Price", "65 Lakhs"),
//             SizedBox(height: 8),
//             _buildInfoRow("Area", "1200 sq ft"),
//             SizedBox(height: 12),
//             Divider(color: ColorRes.black12),
//             SizedBox(height: 12),
//             Text(
//               "Intrested In: ",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: ColorRes.black54,
//                 fontWeight: AppFontWeights.semiBold,
//               ),
//             ),
//             SizedBox(height: 12),
//             _buildPropertyCard({
//               "name": "2BHK Apartment in Viman Nagar",
//               "type": "Apartment",
//               "price": "65 Lakhs",
//               "area": "1200 sq ft",
//               "image": IMGRes.home1,
//               "propertyId": "PROP001",
//               "address": "123, Viman Nagar, Pune, Maharashtra",
//             }),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     child: Center(child: Icon(Icons.phone_outlined)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorRes.primary.withOpacity(0.1),
//                       foregroundColor: ColorRes.primary,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: ColorRes.primary),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   flex: 3,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//
//                       children: [
//                         Icon(Icons.message_outlined),
//                         SizedBox(width: 6),
//                         Text(
//                           "Message",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorRes.primary.withOpacity(0.1),
//                       foregroundColor: ColorRes.primary,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: ColorRes.primary),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.phone_outlined),
//                         SizedBox(width: 6),
//                         Text(
//                           "Call",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorRes.primary,
//                       foregroundColor: ColorRes.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: ColorRes.primary),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextWithIconAndButton(
//     IconData icon,
//     String text,
//     String buttonText,
//     VoidCallback onPressed,
//   ) {
//     return Row(
//       children: [
//         Icon(icon, color: ColorRes.primary, size: 15),
//         SizedBox(width: 6),
//         Text(text, style: TextStyle(fontSize: 12, color: ColorRes.black54)),
//         SizedBox(width: 6),
//         GestureDetector(
//           onTap: onPressed,
//           child: Text(
//             buttonText,
//             style: TextStyle(
//               fontSize: 10,
//               decoration: TextDecoration.underline,
//               color: ColorRes.primary,
//               decorationColor: ColorRes.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Row(
//       children: [
//         Text(
//           "$title: ",
//           style: TextStyle(
//             fontSize: 12,
//             color: ColorRes.leadGreyColor[600],
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//         SizedBox(width: 6),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             color: ColorRes.leadGreyColor[800],
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPropertyCard(Map<String, dynamic> property) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor[300]!),
//         color: ColorRes.white,
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//               image: DecorationImage(
//                 image: AssetImage(property['image']),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // SizedBox(width: 12,),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   property['name'],
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.leadGreyColor[800],
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   "${property['address']}",
//                   style: TextStyle(fontSize: 10, color: ColorRes.leadGreyColor[600]),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 8),
//                 SingleChildScrollView(
//                   child: Row(
//                     children: [
//                       _buildChip(property['price']),
//                       SizedBox(width: 4),
//                       _buildChip(property['area']),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: ColorRes.leadGreyColor.shade50,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: ColorRes.black54,
//           fontSize: 9,
//           fontWeight: AppFontWeights.semiBold,
//         ),
//       ),
//     );
//   }
// }
//
// // class LeadCard extends StatelessWidget {
// //   final String name;
// //   final String email;
// //   final String phone;
// //   final Map<String, dynamic> property;
// //   final String reseller;
// //   final String source;
// //   final String stage;
// //   final String date;
// //
// //   const LeadCard({
// //     super.key,
// //     required this.name,
// //     required this.email,
// //     required this.phone,
// //     required this.property,
// //     required this.reseller,
// //     required this.source,
// //     required this.stage,
// //     required this.date,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: ColorRes.leadGreyColor[300]!),
// //         color: ColorRes.white,
// //       ),
// //       margin: const EdgeInsets.only(bottom: 16),
// //       child: InkWell(
// //         onTap: () {}, // Handle card tap for viewing details
// //         borderRadius: BorderRadius.circular(16),
// //         child: Column(
// //           children: [
// //             // Property Image Section
// //             Container(
// //               height: 140,
// //               decoration: BoxDecoration(
// //                 borderRadius: const BorderRadius.vertical(
// //                   top: Radius.circular(15),
// //                 ),
// //                 image: DecorationImage(
// //                   image: AssetImage(property['image']),
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               child: Stack(
// //                 children: [
// //                   Positioned(
// //                     top: 12,
// //                     right: 12,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 12,
// //                         vertical: 6,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: ColorRes.black.withOpacity(0.7),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(
// //                         property['propertyId'],
// //                         style: const TextStyle(
// //                           color: ColorRes.white,
// //                           fontSize: 12,
// //                           fontWeight: AppFontWeights.semiBold,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             // Lead Details Section
// //             Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       _buildChip(source, ColorRes.blueColor[50]!, ColorRes.blueColor[700]!),
// //                       const SizedBox(width: 8),
// //                       _buildChip(stage, Colors.green[50]!, Colors.green[700]!),
// //
// //                       // const Spacer(),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),
// //                   // Property Details Section
// //                   Container(
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: ColorRes.leadGreyColor[50],
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: ColorRes.leadGreyColor[200]!),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           property['name'],
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                             fontWeight: AppFontWeights.semiBold,
// //                             color: ColorRes.leadGreyColor[900],
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Row(
// //                           children: [
// //                             _buildPropertyInfo(
// //                               Icons.home_work,
// //                               property['type'],
// //                             ),
// //                             const SizedBox(width: 16),
// //                             _buildPropertyInfo(
// //                               Icons.square_foot,
// //                               property['area'],
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 4),
// //                         _buildPropertyInfo(
// //                           Icons.currency_rupee,
// //                           property['price'],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: ColorRes.leadGreyColor[200]!),
// //                     ),
// //                     padding: EdgeInsets.all(12),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.start,
// //                       children: [
// //                         CircleAvatar(
// //                           backgroundImage: AssetImage(IMGRes.user_2),
// //                           radius: 25,
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Flexible(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 name,
// //                                 style: Theme.of(
// //                                   context,
// //                                 ).textTheme.titleMedium?.copyWith(
// //                                   fontWeight: AppFontWeights.semiBold,
// //                                   fontSize: 16,
// //                                 ),
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                               Row(
// //                                 children: [
// //                                   Icon(
// //                                     Icons.email_outlined,
// //                                     color: ColorRes.primary,
// //                                     size: 14,
// //                                   ),
// //                                   const SizedBox(width: 8),
// //                                   Flexible(
// //                                     child: Text(
// //                                       email,
// //                                       style: TextStyle(
// //                                         fontSize: 13,
// //                                         color: ColorRes.leadGreyColor[800],
// //                                       ),
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                               Row(
// //                                 children: [
// //                                   Icon(
// //                                     Icons.phone_outlined,
// //                                     color: ColorRes.primary,
// //                                     size: 14,
// //                                   ),
// //                                   const SizedBox(width: 8),
// //                                   Text(
// //                                     phone,
// //                                     style: TextStyle(
// //                                       fontSize: 13,
// //                                       color: ColorRes.leadGreyColor[800],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   _buildInfoRow(
// //                     Icons.store_mall_directory_outlined,
// //                     "Reseller: $reseller",
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPropertyInfo(IconData icon, String text) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon, size: 16, color: ColorRes.primary),
// //         const SizedBox(width: 4),
// //         Text(
// //           text,
// //           style: TextStyle(
// //             fontSize: 13,
// //             color: ColorRes.leadGreyColor[700],
// //             fontWeight: AppFontWeights.medium,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildChip(String text, Color bgColor, Color textColor) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(
// //         color: bgColor,
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: textColor.withOpacity(0.3)),
// //       ),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           color: textColor,
// //           fontSize: 12,
// //           fontWeight: AppFontWeights.semiBold,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoRow(IconData icon, String text) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(6),
// //               decoration: BoxDecoration(
// //                 color: ColorRes.leadGreyColor[100],
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Icon(
// //                 icon,
// //                 size: 16,
// //                 color: ColorRes.primary.withOpacity(0.6),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Text(text, style: TextStyle(fontSize: 13, color: ColorRes.leadGreyColor[800])),
// //           ],
// //         ),
// //         Text(
// //           date,
// //           style: TextStyle(
// //             fontSize: 12,
// //             color: ColorRes.leadGreyColor[600],
// //             fontWeight: AppFontWeights.medium,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/utils/helper_function/contact_helper.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:intl/intl.dart';

import 'package:housing_flutter_app/widgets/expand_list/expanded_list.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../controllers/lead_controller.dart';
import '../model/lead_model.dart';

final List<Map<String, dynamic>> dummyLeads = [
  {
    "name": "Ethan Valdez",
    "email": "ethan.valdez@example.com",
    "phone": "+91 98765 12345",
    "property": {
      "name": "2BHK Apartment in Viman Nagar",
      "type": "Apartment",
      "price": "65 Lakhs",
      "area": "1200 sq ft",
      "image": IMGRes.home1,
      "propertyId": "PROP001",
      "address": "123, Viman Nagar, Pune, Maharashtra",
    },
    "reseller": "RS1",
    "source": "App",
    "stage": "Interested",
    "date": "23 Sep 2025",
  },
  {
    "name": "Sophia Martinez",
    "email": "sophia.m@example.com",
    "phone": "+91 91234 56789",
    "property": {
      "name": "Luxury Villa in Goa",
      "type": "Villa",
      "price": "2.5 Cr",
      "area": "3500 sq ft",
      "image": IMGRes.home2,
      "propertyId": "PROP002",
      "address": "456, Candolim, Goa",
    },
    "reseller": "RS2",
    "source": "Website",
    "stage": "New Lead",
    "date": "20 Sep 2025",
  },
  {
    "name": "Arjun Sharma",
    "email": "arjun.sharma@example.com",
    "phone": "+91 99887 66554",
    "property": {
      "name": "3BHK Flat in Bandra, Mumbai",
      "type": "Apartment",
      "price": "1.8 Cr",
      "area": "1800 sq ft",
      "image": IMGRes.home3,
      "propertyId": "PROP003",
      "address": "789, Bandra West, Mumbai, Maharashtra",
    },
    "reseller": "RS3",
    "source": "Referral",
    "stage": "Contacted",
    "date": "18 Sep 2025",
  },
  {
    "name": "Liam Johnson",
    "email": "liam.j@example.com",
    "phone": "+91 98770 11223",
    "property": {
      "name": "Office Space in Connaught Place",
      "type": "Commercial",
      "price": "95 Lakhs",
      "area": "2200 sq ft",
      "image": IMGRes.home4,
      "propertyId": "PROP004",
      "address": "101, Connaught Place, New Delhi",
    },
    "reseller": "RS4",
    "source": "Other",
    "stage": "Negotiation",
    "date": "15 Sep 2025",
  },
  {
    "name": "Aarohi Mehta",
    "email": "aarohi.mehta@example.com",
    "phone": "+91 98989 77777",
    "property": {
      "name": "Penthouse in Pune",
      "type": "Penthouse",
      "price": "3.2 Cr",
      "area": "4000 sq ft",
      "image": IMGRes.project_1,
      "propertyId": "PROP005",
      "address": "202, Koregaon Park, Pune, Maharashtra",
    },
    "reseller": "RS5",
    "source": "App",
    "stage": "Site Visit",
    "date": "10 Sep 2025",
  },
];

// class LeadScreen extends StatelessWidget {
//   const LeadScreen({super.key});
//
//   List<Map<String, dynamic>> getFilteredLeads(LeadController controller) {
//     List<Map<String, dynamic>> filteredLeads = List.from(dummyLeads);
//
//     // Filter by status
//     if (controller.selectedFilterStatus.value.isNotEmpty &&
//         controller.selectedFilterStatus.value != 'All Status') {
//       filteredLeads =
//           filteredLeads
//               .where(
//                 (lead) =>
//                     lead['stage'] == controller.selectedFilterStatus.value,
//               )
//               .toList();
//     }
//
//     // Filter by lead type (property type)
//     if (controller.selectedLeadType.value.isNotEmpty &&
//         controller.selectedLeadType.value != 'All Leads') {
//       if (controller.selectedLeadType.value == 'Residential') {
//         filteredLeads =
//             filteredLeads
//                 .where(
//                   (lead) => [
//                     'Apartment',
//                     'Villa',
//                     'Penthouse',
//                   ].contains(lead['property']['type']),
//                 )
//                 .toList();
//       } else if (controller.selectedLeadType.value == 'Commercial') {
//         filteredLeads =
//             filteredLeads
//                 .where((lead) => lead['property']['type'] == 'Commercial')
//                 .toList();
//       }
//     }
//
//     return filteredLeads;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mainController = Get.put(LeadController(), tag: 'main');
//
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Obx(() {
//             final filteredCount = getFilteredLeads(mainController).length;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Leads",
//                   style: TextStyle(fontWeight: AppFontWeights.semiBold, fontSize: 18),
//                 ),
//                 Text(
//                   "$filteredCount of ${dummyLeads.length} leads",
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             );
//           }),
//           elevation: 0,
//           backgroundColor: ColorRes.white,
//           foregroundColor: ColorRes.black,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(48.0),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Obx(
//                       () => NesticoPeDropdownField(
//                         value:
//                             mainController.selectedFilterStatus.value.isEmpty
//                                 ? null
//                                 : mainController.selectedFilterStatus.value,
//                         items:
//                             ['All Status', ...mainController.statusList]
//                                 .map(
//                                   (e) => DropdownMenuItem(
//                                     value: e,
//                                     child: Text(
//                                       e,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: ColorRes.leadGreyColor[800],
//                                         fontWeight: AppFontWeights.semiBold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             mainController.selectedFilterStatus.value = value;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Obx(
//                       () => NesticoPeDropdownField(
//                         value:
//                             mainController.selectedLeadType.value.isEmpty
//                                 ? null
//                                 : mainController.selectedLeadType.value,
//                         items:
//                             mainController.leadTypeList
//                                 .map(
//                                   (e) => DropdownMenuItem(
//                                     value: e,
//                                     child: Text(
//                                       e,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: ColorRes.leadGreyColor[800],
//                                         fontWeight: AppFontWeights.semiBold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             mainController.selectedLeadType.value = value;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [ColorRes.leadGreyColor[50]!, ColorRes.white],
//             ),
//           ),
//           child: Obx(() {
//             final filteredLeads = getFilteredLeads(mainController);
//
//             if (filteredLeads.isEmpty) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.search_off, size: 64, color: ColorRes.leadGreyColor),
//                     SizedBox(height: 16),
//                     Text(
//                       'No leads found',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: ColorRes.leadGreyColor,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                     Text(
//                       'Try adjusting your filters',
//                       style: TextStyle(fontSize: 14, color: ColorRes.leadGreyColor),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: filteredLeads.length,
//               itemBuilder: (context, index) {
//                 final lead = filteredLeads[index];
//                 final originalIndex = dummyLeads.indexOf(lead);
//
//                 return LeadCard(
//                   index: originalIndex,
//                   name: lead['name'],
//                   email: lead['email'],
//                   phone: lead['phone'],
//                   property: lead['property'],
//                   reseller: lead['reseller'],
//                   source: lead['source'],
//                   stage: lead['stage'],
//                   date: lead['date'],
//                 );
//               },
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

/// --------------------------------------------------- New -----------------------------------------------///

// class LeadScreen extends StatelessWidget {
//   const LeadScreen({super.key});
//
//   List<LeadItem> getFilteredLeads(LeadController controller) {
//     List<LeadItem> filteredLeads = List.from(controller.items);
//
//     // Filter by status
//     if (controller.selectedFilterStatus.value.isNotEmpty &&
//         controller.selectedFilterStatus.value != 'All Status') {
//       filteredLeads =
//           filteredLeads
//               .where(
//                 (lead) => lead.stage == controller.selectedFilterStatus.value,
//               )
//               .toList();
//     }
//
//     // Filter by lead type (property type)
//     if (controller.selectedLeadType.value.isNotEmpty &&
//         controller.selectedLeadType.value != 'All Leads') {
//       if (controller.selectedLeadType.value == 'Residential') {
//         filteredLeads =
//             filteredLeads
//                 .where((lead) => lead.customFields?.type! == 'residential')
//                 .toList();
//       } else if (controller.selectedLeadType.value == 'Commercial') {
//         filteredLeads =
//             filteredLeads
//                 .where((lead) => lead.customFields?.type! == 'commercial')
//                 .toList();
//       }
//     }
//
//     return filteredLeads;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LeadController());
//
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Obx(() {
//             final filteredCount = getFilteredLeads(controller).length;
//             final totalCount = controller.items.length;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Leads",
//                   style: TextStyle(fontWeight: AppFontWeights.semiBold, fontSize: 18),
//                 ),
//                 Text(
//                   "$filteredCount of $totalCount leads",
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             );
//           }),
//           elevation: 0,
//           backgroundColor: ColorRes.white,
//           foregroundColor: ColorRes.black,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(48.0),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Obx(
//                       () => NesticoPeDropdownField(
//                         value:
//                             controller.selectedFilterStatus.value.isEmpty
//                                 ? null
//                                 : controller.selectedFilterStatus.value,
//                         items:
//                             ['All Status', ...controller.statusList]
//                                 .map(
//                                   (e) => DropdownMenuItem(
//                                     value: e,
//                                     child: Text(
//                                       e,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: ColorRes.leadGreyColor[800],
//                                         fontWeight: AppFontWeights.semiBold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             controller.selectedFilterStatus.value = value;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Obx(
//                       () => NesticoPeDropdownField(
//                         value:
//                             controller.selectedLeadType.value.isEmpty
//                                 ? null
//                                 : controller.selectedLeadType.value,
//                         items:
//                             controller.leadTypeList
//                                 .map(
//                                   (e) => DropdownMenuItem(
//                                     value: e,
//                                     child: Text(
//                                       e,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: ColorRes.leadGreyColor[800],
//                                         fontWeight: AppFontWeights.semiBold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             controller.selectedLeadType.value = value;
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final filteredLeads = getFilteredLeads(controller);
//
//           if (filteredLeads.isEmpty) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 64, color: ColorRes.leadGreyColor),
//                   SizedBox(height: 16),
//                   Text(
//                     'No leads found',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: ColorRes.leadGreyColor,
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                   Text(
//                     'Try adjusting your filters',
//                     style: TextStyle(fontSize: 14, color: ColorRes.leadGreyColor),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return NotificationListener<ScrollNotification>(
//             onNotification: (scrollInfo) {
//               if (!controller.isPaging.value &&
//                   scrollInfo.metrics.pixels ==
//                       scrollInfo.metrics.maxScrollExtent &&
//                   controller.hasMore.value) {
//                 controller.loadMore();
//               }
//               return false;
//             },
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: filteredLeads.length,
//               itemBuilder: (context, index) {
//                 final lead = filteredLeads[index];
//
//                 return LeadCard(lead: lead);
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// class LeadCard extends StatelessWidget {
//   final LeadItem lead;
//
//   const LeadCard({super.key, required this.lead});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get or create controller for this specific lead
//     final controller = Get.find<LeadController>();
//
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor[300]!),
//         color: ColorRes.white,
//       ),
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       child: GestureDetector(
//         onTap: () {
//           Get.bottomSheet(
//             DraggableScrollableSheet(
//               expand: false,
//               initialChildSize: 0.6,
//               minChildSize: 0.4,
//               maxChildSize: 0.68,
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: const BoxDecoration(
//                     color: ColorRes.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     child: LeadDetailBottomSheet(
//                       controller: controller,
//                       leadData: lead,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             isScrollControlled: true,
//             backgroundColor: Colors.transparent,
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${lead.name} >",
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: ColorRes.black54,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           _buildChip(lead.status),
//
//                           const SizedBox(width: 4),
//                           SizedBox(
//                             height: 16,
//                             child: const VerticalDivider(
//                               thickness: 1,
//                               color: ColorRes.black54,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             DateFormat('yyyy-MM-dd').format(lead.createdAt),
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: ColorRes.leadGreyColor[600],
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     _buildActionButton(
//                       Icons.phone_outlined,
//                       () => ContactHelper.openDialer(lead.phone),
//                     ),
//                     const SizedBox(width: 6),
//                     _buildActionButton(
//                       Icons.email_outlined,
//                       () => ContactHelper.sendEmail(lead.email),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               lead.customFields?.title ?? "N/A",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.leadGreyColor[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 40,
//         width: 40,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: ColorRes.primary.withOpacity(0.1),
//         ),
//         child: Icon(icon, color: ColorRes.primary),
//       ),
//     );
//   }
//
//   Widget _buildChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: ColorRes.leadGreyColor.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: ColorRes.black54,
//           fontSize: 12,
//           fontWeight: AppFontWeights.semiBold,
//         ),
//       ),
//     );
//   }
// }
//
// class LeadDetailBottomSheet extends StatelessWidget {
//   final LeadController controller;
//   final LeadItem leadData;
//
//   const LeadDetailBottomSheet({
//     super.key,
//     required this.controller,
//     required this.leadData,
//   });
//
//   void pickDateTime(BuildContext context, LeadController controller) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: controller.selectedDate.value ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         final DateTime fullDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         controller.selectedDate.value = fullDateTime;
//         controller.dateController.text = DateFormat(
//           'dd MMM yyyy, hh:mm a',
//         ).format(fullDateTime);
//
//         Get.snackbar(
//           'Follow-up Scheduled',
//           'Follow-up set for ${DateFormat('dd MMM yyyy, hh:mm a').format(fullDateTime)}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: ColorRes.white,
//         );
//       }
//     }
//   }
//
//   void _showNotesDialog(BuildContext context) {
//     final TextEditingController notesController = TextEditingController();
//     notesController.text = controller.notes.value;
//
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: ColorRes.white,
//         title: const Text('Edit Notes'),
//         content: TextField(
//           controller: notesController,
//           maxLines: 5,
//           decoration: const InputDecoration(
//             hintText: 'Enter your notes here...',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               controller.notes.value = notesController.text;
//               Get.back();
//               Get.snackbar(
//                 'Notes Updated',
//                 'Lead notes have been updated',
//                 snackPosition: SnackPosition.BOTTOM,
//                 backgroundColor: Colors.green,
//                 colorText: ColorRes.white,
//               );
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle bar
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 color: ColorRes.leadGreyColor[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     leadData.name,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: ColorRes.black54,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Obx(
//                     () => Text(
//                       controller.selectedDate.value != null
//                           ? DateFormat(
//                             'dd MMM yyyy, hh:mm a',
//                           ).format(controller.selectedDate.value!)
//                           : "No follow-up set",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color:
//                             controller.selectedDate.value != null
//                                 ? ColorRes.black54
//                                 : ColorRes.leadGreyColor[400],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Obx(
//                 () => SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.33,
//                   child: NesticoPeDropdownField(
//                     value: controller.selectedStatus.value,
//                     items:
//                         controller.statusList.map((e) {
//                           return DropdownMenuItem(
//                             value: e,
//                             child: Text(
//                               e,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: ColorRes.leadGreyColor[800],
//                                 fontWeight: AppFontWeights.semiBold,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         controller.selectedStatus.value = value;
//                         // Get.snackbar(
//                         //   'Status Updated',
//                         //   'Lead status changed to $value',
//                         //   snackPosition: SnackPosition.BOTTOM,
//                         //   backgroundColor: ColorRes.blueColor,
//                         //   colorText: ColorRes.white,
//                         // );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           _buildTextWithIconAndButton(
//             Icons.calendar_month,
//             "Follow up",
//             controller.selectedDate.value != null
//                 ? "Update Date"
//                 : "Set Date And Time",
//             () => pickDateTime(context, controller),
//           ),
//
//           const SizedBox(height: 12),
//
//           _buildTextWithIconAndButton(
//             Icons.note_add,
//             "Notes",
//             "Edit",
//             () => _showNotesDialog(context),
//           ),
//
//           // Show notes if any
//           Obx(() {
//             if (controller.notes.value.isNotEmpty) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 8, left: 21),
//                 child: Text(
//                   controller.notes.value,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: ColorRes.leadGreyColor[600],
//                     fontStyle: FontStyle.italic,
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             }
//             return const SizedBox.shrink();
//           }),
//
//           const SizedBox(height: 12),
//           const Divider(color: ColorRes.black12),
//           const SizedBox(height: 12),
//
//           if (leadData.customFields?.title != null &&
//               leadData.customFields!.title!.isNotEmpty) ...[
//             _buildInfoRow("Property", leadData.customFields?.title ?? "N/A"),
//             const SizedBox(height: 8),
//           ],
//
//           if (leadData.customFields?.type != null &&
//               leadData.customFields!.type!.isNotEmpty) ...[
//             _buildInfoRow("Type", leadData.customFields?.type ?? "N/A"),
//             const SizedBox(height: 8),
//           ],
//
//           if (leadData.customFields?.propertyDetails?.financialInfo?.price !=
//                   null &&
//               leadData.customFields!.propertyDetails!.financialInfo!.price
//                   .toString()
//                   .isNotEmpty) ...[
//             _buildInfoRow(
//               "Price",
//               Formatter.formatPrice(
//                     leadData
//                         .customFields!
//                         .propertyDetails!
//                         .financialInfo!
//                         .price,
//                   ) ??
//                   "0",
//             ),
//             const SizedBox(height: 8),
//           ],
//
//           if (leadData.customFields?.propertyDetails?.propertyBuiltUpArea !=
//                   null &&
//               leadData.customFields!.propertyDetails!.propertyBuiltUpArea!
//                   .toString()
//                   .isNotEmpty) ...[
//             _buildInfoRow(
//               "Area",
//               "${leadData.customFields?.propertyDetails?.propertyBuiltUpArea.toString()} / sq.ft",
//             ),
//             const SizedBox(height: 12),
//           ],
//           const Divider(color: ColorRes.black12),
//           const SizedBox(height: 12),
//
//           const Text(
//             "Interested In: ",
//             style: TextStyle(
//               fontSize: 14,
//               color: ColorRes.black54,
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           if (leadData.customFields != null) ...[
//             _buildPropertyCard(leadData.customFields!),
//           ],
//
//           const SizedBox(height: 16),
//
//           Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: ElevatedButton(
//                   onPressed: () => ContactHelper.openWhatsApp(leadData.phone),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorRes.primary.withOpacity(0.1),
//                     foregroundColor: ColorRes.primary,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(color: ColorRes.primary),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Center(child: Image.asset(IMGRes.whatsapp)),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 3,
//                 child: ElevatedButton(
//                   onPressed: () => ContactHelper.sendEmail(leadData.email),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorRes.primary.withOpacity(0.1),
//                     foregroundColor: ColorRes.primary,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(color: ColorRes.primary),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.mail_outline),
//                       SizedBox(width: 6),
//                       Text(
//                         "Email",
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 2,
//                 child: ElevatedButton(
//                   onPressed: () => ContactHelper.openDialer(leadData.phone),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorRes.primary,
//                     foregroundColor: ColorRes.white,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(color: ColorRes.primary),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.phone_outlined),
//                       SizedBox(width: 6),
//                       Text(
//                         "Call",
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Add some bottom padding for better UX
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextWithIconAndButton(
//     IconData icon,
//     String text,
//     String buttonText,
//     VoidCallback onPressed,
//   ) {
//     return Row(
//       children: [
//         Icon(icon, color: ColorRes.primary, size: 15),
//         const SizedBox(width: 6),
//         Text(text, style: const TextStyle(fontSize: 12, color: ColorRes.black54)),
//         const SizedBox(width: 6),
//         GestureDetector(
//           onTap: onPressed,
//           child: Text(
//             buttonText,
//             style: TextStyle(
//               fontSize: 10,
//               decoration: TextDecoration.underline,
//               color: ColorRes.primary,
//               decorationColor: ColorRes.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Row(
//       children: [
//         Text(
//           "$title: ",
//           style: TextStyle(
//             fontSize: 12,
//             color: ColorRes.leadGreyColor[600],
//             fontWeight: AppFontWeights.medium,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               color: ColorRes.leadGreyColor[800],
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPropertyCard(Items property) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor[300]!),
//         color: ColorRes.white,
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//               image: DecorationImage(
//                 image:
//                     property.propertyImages != null
//                         ? NetworkImage(property.propertyImages!.first)
//                         : AssetImage(IMGRes.home3),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   if (property.title != null) ...[
//                     Text(
//                       property.title!,
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.leadGreyColor[800],
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                   ],
//                   Text(
//                     property.address ?? '',
//                     style: TextStyle(fontSize: 10, color: ColorRes.leadGreyColor[600]),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       if (property.propertyDetails?.financialInfo?.price
//                               .toString() !=
//                           null) ...[
//                         _buildChip(
//                           Formatter.formatPrice(
//                             property.propertyDetails!.financialInfo!.price,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                       ],
//                       if (property.propertyDetails?.propertyBuiltUpArea !=
//                           null) ...[
//                         _buildChip(
//                           "${property.propertyDetails?.propertyBuiltUpArea.toString()} / sq.ft",
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChip(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: ColorRes.leadGreyColor.shade50,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: ColorRes.black54,
//           fontSize: 9,
//           fontWeight: AppFontWeights.semiBold,
//         ),
//       ),
//     );
//   }
// }

// class LeadScreen extends StatelessWidget {
//   const LeadScreen({super.key});
//
//   List<LeadItem> getFilteredLeads(LeadController controller, String status) {
//     List<LeadItem> filteredLeads = List.from(controller.items);
//
//     // Always filter by the section's status
//     filteredLeads =
//         filteredLeads.where((lead) => lead.stage == status).toList();
//
//     // Apply global status filter (dropdown) if selected
//     if (controller.selectedFilterStatus.value.isNotEmpty &&
//         controller.selectedFilterStatus.value != 'All Status') {
//       filteredLeads =
//           filteredLeads
//               .where(
//                 (lead) =>
//                     lead.stage == controller.selectedFilterStatus.value &&
//                     lead.stage == status,
//               ) // ensure it belongs to this section
//               .toList();
//     }
//
//     // Apply global lead type filter
//     if (controller.selectedLeadType.value.isNotEmpty &&
//         controller.selectedLeadType.value != 'All Leads') {
//       if (controller.selectedLeadType.value == 'Residential') {
//         filteredLeads =
//             filteredLeads
//                 .where((lead) => lead.customFields?.type == 'residential')
//                 .toList();
//       } else if (controller.selectedLeadType.value == 'Commercial') {
//         filteredLeads =
//             filteredLeads
//                 .where((lead) => lead.customFields?.type == 'commercial')
//                 .toList();
//       }
//     }
//
//     return filteredLeads;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LeadController());
//
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Leads"),
//           elevation: 0,
//           backgroundColor: ColorRes.white,
//           foregroundColor: ColorRes.black,
//         ),
//
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               ...controller.statusList.map((status) {
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
//                   child: ExpandableTileConfig.card(
//                     title: status.capitalize.toString(),
//                     backgroundColor: Colors.transparent,
//                     children: [
//                       Obx(() {
//                         if (controller.isLoading.value) {
//                           return const Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: Center(child: CircularProgressIndicator()),
//                           );
//                         }
//
//                         final filteredLeads = getFilteredLeads(
//                           controller,
//                           status,
//                         );
//
//                         if (filteredLeads.isEmpty) {
//                           return const Padding(
//                             padding: EdgeInsets.all(24.0),
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.search_off,
//                                     size: 64,
//                                     color: ColorRes.leadGreyColor,
//                                   ),
//                                   SizedBox(height: 16),
//                                   Text(
//                                     'No leads found',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: ColorRes.leadGreyColor,
//                                       fontWeight: AppFontWeights.medium,
//                                     ),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     'Try adjusting your filters',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: ColorRes.leadGreyColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }
//
//                         return NotificationListener<ScrollNotification>(
//                           onNotification: (scrollInfo) {
//                             if (!controller.isPaging.value &&
//                                 scrollInfo.metrics.pixels ==
//                                     scrollInfo.metrics.maxScrollExtent &&
//                                 controller.hasMore.value) {
//                               controller
//                                   .loadMore(); // load more for this status
//                             }
//                             return false;
//                           },
//                           child: ListView.builder(
//                             shrinkWrap:
//                                 true, // 🔑 makes it fit inside expandable
//                             physics:
//                                 const NeverScrollableScrollPhysics(), // avoid nested scroll
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                             itemCount: filteredLeads.length,
//                             itemBuilder: (context, index) {
//                               final lead = filteredLeads[index];
//                               return LeadCard(lead: lead);
//                             },
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



///upafet
///upafet
class LeadScreen extends StatelessWidget {
  const LeadScreen({super.key});

  List<LeadItem> getFilteredLeads(LeadController controller, String status) {
    if (controller.selectedFilterType.value == "source") {
      return controller.items.where((lead) => lead.source == status).toList();
    } else if (controller.selectedFilterType.value == "status") {
      return controller.items.where((lead) => lead.status == status).toList();
    } else if (controller.selectedFilterType.value == "stage") {
      return controller.items.where((lead) => lead.stage == status).toList();
    } else {
      return [];
    }
  }

  List<String> getFilterList(LeadController controller) {
    if (controller.selectedFilterType.value == "source") {
      return controller.sourceList;
    } else if (controller.selectedFilterType.value == "status") {
      return controller.statusList;
    } else if (controller.selectedFilterType.value == "stage") {
      return controller.stageList;
    } else {
      return ["none"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeadController());

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorRes.white,
        appBar: AppBar(
          title: const Text(
            "Leads",
            style: TextStyle(fontWeight: AppFontWeights.bold),
          ),
          elevation: 0,
          foregroundColor: ColorRes.blackShade87,
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0), // Increased height for better spacing
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorRes.grey.withOpacity(0.1), // Softer border
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Better vertical spacing
                child: Obx(
                      () => Container(
                    padding: const EdgeInsets.all(4), // Reduced padding for sleeker look
                    decoration: BoxDecoration(
                      color: ColorRes.leadGreyColor.shade100,
                      borderRadius: BorderRadius.circular(12), // Modern rounded corners
                      border: Border.all(
                        color: ColorRes.leadGreyColor.shade200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorRes.black.withOpacity(0.03), // Subtle depth
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: controller.filterType.asMap().entries.map((entry) {
                        final filter = entry.value;
                        final isSelected = controller.selectedFilterType.value == filter;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact(); // Haptic feedback for better UX
                              controller.selectedFilterType.value = filter;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(vertical: 12), // Better touch target
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorRes.primary
                                    : ColorRes.transparentColor,
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: Center(
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.medium,
                                    fontWeight: isSelected ? AppFontWeights.bold : AppFontWeights.semiBold,
                                    color: isSelected ? ColorRes.white : ColorRes.leadGreyColor[700],
                                    letterSpacing: 0.2, // Improved readability
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => await controller.refreshList(),
          color: ColorRes.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorRes.primary),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: getFilterList(controller).map((status) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1,color: ColorRes.grey.withOpacity(0.3))
                        ),
                        child: NesticoPeExpandableTile(
                          title: status.capitalize.toString(),
                          expandedBackgroundColor: ColorRes.white,
                          borderRadius: BorderRadius.circular(16),
                          trailingIcon: Icons.keyboard_arrow_down_rounded,
                          onTap: () {
                            controller.filters.value = {
                              controller.selectedFilterType.value: status,
                            };
                            controller.loadMore();
                          },
                          onExpansionChanged: (value) {
                            if (value) {
                              controller.filters.value = {
                                controller.selectedFilterType.value: status,
                              };
                            }
                          },
                          initiallyExpanded: false,
                          backgroundColor: ColorRes.white,
                          children: [
                            Obx(() {
                              final filteredLeads = getFilteredLeads(controller, status);

                              if (filteredLeads.isEmpty && !controller.isLoading.value) {
                                return Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: ColorRes.leadGreyColor[100],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.search_off_rounded,
                                            size: 48,
                                            color: ColorRes.leadGreyColor[400],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No leads found',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.body,
                                            color: ColorRes.leadGreyColor[700],
                                            fontWeight: AppFontWeights.semiBold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Try adjusting your filters',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: ColorRes.leadGreyColor[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return SizedBox(
                                height: 320,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (scrollInfo) {
                                    if (scrollInfo is ScrollUpdateNotification) {
                                      final threshold = 100.0;
                                      if (!controller.isPaging.value &&
                                          controller.hasMore.value &&
                                          scrollInfo.metrics.pixels >
                                              scrollInfo.metrics.maxScrollExtent - threshold) {
                                        controller.loadMore();
                                      }
                                    }
                                    return false;
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    itemCount: filteredLeads.length + (controller.isPaging.value ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == filteredLeads.length) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(ColorRes.primary),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final lead = filteredLeads[index];
                                      return LeadCard(lead: lead);
                                    },
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final LeadItem lead;

  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeadController>();

    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: ColorRes.transparentColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Get.bottomSheet(
              DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.65,
                minChildSize: 0.4,
                maxChildSize: 0.75,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: ColorRes.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: LeadDetailBottomSheet(
                        controller: controller,
                        leadData: lead,
                      ),
                    ),
                  );
                },
              ),
              isScrollControlled: true,
              backgroundColor: ColorRes.transparentColor,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: ColorRes.primary.withOpacity(0.12),
                        child: Text(
                          getInitials(lead.name),
                          style: TextStyle(
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.bold,
                            fontSize: AppFontSizes.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead.name,
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.bold,
                              color: ColorRes.leadGreyColor[900],
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lead.customFields?.ownerName ?? 'N/A',
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.leadGreyColor[600],
                              fontWeight: AppFontWeights.regular,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lead.customFields?.ownerEmail ?? 'N/A',
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.leadGreyColor[600],
                              fontWeight: AppFontWeights.regular,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.leadGreyColor[800],
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Formatter.formatPrice(
                            lead.customFields?.propertyDetails?.financialInfo?.price ?? 0.0,
                          ),
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          _formatTime(lead.createdAt),
                          style: TextStyle(
                            fontSize: AppFontSizes.mini,
                            color: ColorRes.leadGreyColor[600],
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: ColorRes.leadGreyColor[200], thickness: 1, height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildChip(lead.status),
                    const Spacer(),
                    Row(
                      children: [
                        _buildActionButton(
                          Icons.phone_rounded,
                              () => ContactHelper.openDialer(lead.phone),
                          ColorRes.blueColor,
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          Icons.email_rounded,
                              () => ContactHelper.sendEmail(lead.email),
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, Color color) {
    return Material(
      color: ColorRes.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6.2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getStageColor(text).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStageColor(text).withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _getStageColor(text),
          fontSize: AppFontSizes.extraSmall,
          fontWeight: AppFontWeights.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class LeadDetailBottomSheet extends StatelessWidget {
  final LeadController controller;
  final LeadItem leadData;

  const LeadDetailBottomSheet({
    super.key,
    required this.controller,
    required this.leadData,
  });

  void pickDateTime(BuildContext context, LeadController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ColorRes.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: ColorRes.primary),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.selectedDate.value = fullDateTime;
        controller.dateController.text = DateFormat('dd MMM yyyy, hh:mm a').format(fullDateTime);

        Get.snackbar(
          'Follow-up Scheduled',
          'Follow-up set for ${DateFormat('dd MMM yyyy, hh:mm a').format(fullDateTime)}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: ColorRes.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.check_circle, color: ColorRes.white),
        );
      }
    }
  }

  void _showNotesDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController();
    notesController.text = controller.notes.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Notes', style: TextStyle(fontWeight: AppFontWeights.bold)),
        content: TextField(
          controller: notesController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter your notes here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorRes.leadGreyColor[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorRes.leadGreyColor[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorRes.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: ColorRes.leadGreyColor[600])),
          ),
          ElevatedButton(
            onPressed: () {
              controller.notes.value = notesController.text;
              Get.back();
              Get.snackbar(
                'Notes Updated',
                'Lead notes have been updated',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: ColorRes.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
                icon: const Icon(Icons.check_circle, color: ColorRes.white),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: ColorRes.leadGreyColor[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leadData.name,
                      style:  TextStyle(
                        fontSize: AppFontSizes.large,
                        color: ColorRes.blackShade87,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: controller.selectedDate.value != null
                              ? ColorRes.primary.withOpacity(0.08)
                              : ColorRes.leadGreyColor[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: controller.selectedDate.value != null
                                  ? ColorRes.primary
                                  : ColorRes.leadGreyColor[500],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              controller.selectedDate.value != null
                                  ? DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(controller.selectedDate.value!)
                                  : "No follow-up set",
                              style: TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: controller.selectedDate.value != null
                                    ? ColorRes.primary
                                    : ColorRes.leadGreyColor[500],
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
              const SizedBox(width: 12),
              Obx(
                    () => Container(
                  width: 130,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorRes.leadGreyColor[300]!),
                  ),
                  child: NesticoPeDropdownField(
                    value: controller.selectedStatus.value,
                    items: controller.statusList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.leadGreyColor[800],
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedStatus.value = value;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActionRow(
            Icons.calendar_month_rounded,
            "Follow up",
            controller.selectedDate.value != null ? "Update Date" : "Set Date & Time",
                () => pickDateTime(context, controller),
          ),
          const SizedBox(height: 12),
          _buildActionRow(
            Icons.note_add_rounded,
            "Notes",
            "Edit",
                () => _showNotesDialog(context),
          ),
          Obx(() {
            if (controller.notes.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 12, left: 32),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.leadGreyColor[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorRes.leadGreyColor[200]!),
                ),
                child: Text(
                  controller.notes.value,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.leadGreyColor[700],
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 20),
          Divider(color: ColorRes.leadGreyColor[200], thickness: 1),
          const SizedBox(height: 16),
          if (leadData.customFields?.title != null && leadData.customFields!.title!.isNotEmpty) ...[
            _buildInfoRow("Property", leadData.customFields?.title ?? "N/A"),
            const SizedBox(height: 10),
          ],
          if (leadData.customFields?.type != null && leadData.customFields!.type!.isNotEmpty) ...[
            _buildInfoRow("Type", leadData.customFields?.type ?? "N/A"),
            const SizedBox(height: 10),
          ],
          if (leadData.customFields?.propertyDetails?.financialInfo?.price != null &&
              leadData.customFields!.propertyDetails!.financialInfo!.price.toString().isNotEmpty) ...[
            _buildInfoRow(
              "Price",
              Formatter.formatPrice(
                leadData.customFields!.propertyDetails!.financialInfo!.price,
              ) ?? "0",
            ),
            const SizedBox(height: 10),
          ],
          if (leadData.customFields?.propertyDetails?.propertyBuiltUpArea != null &&
              leadData.customFields!.propertyDetails!.propertyBuiltUpArea!.toString().isNotEmpty) ...[
            _buildInfoRow(
              "Area",
              "${leadData.customFields?.propertyDetails?.propertyBuiltUpArea.toString()} sq.ft",
            ),
            const SizedBox(height: 16),
          ],
          Divider(color: ColorRes.leadGreyColor[200], thickness: 1),
          const SizedBox(height: 16),
          const Text(
            "Interested In:",
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              color: ColorRes.blackShade87,
              fontWeight: AppFontWeights.bold,
            ),
          ),
          const SizedBox(height: 14),
          if (leadData.customFields != null) ...[
            _buildPropertyCard(leadData.customFields!),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ContactHelper.openWhatsApp(leadData.phone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366).withOpacity(0.02),
                    foregroundColor: const Color(0xFF25D366),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFF25D366), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Image.asset(IMGRes.whatsapp, height: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => ContactHelper.sendEmail(leadData.email),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.02),
                    foregroundColor: Colors.orange,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.email_rounded, size: 20),
                  label: const Text(
                    "Email",
                    style: TextStyle(fontSize: AppFontSizes.bodySmall, fontWeight: AppFontWeights.semiBold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => ContactHelper.openDialer(leadData.phone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    foregroundColor: ColorRes.white,
                    elevation: 2,
                    shadowColor: ColorRes.primary.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.phone_rounded, size: 20),
                  label: const Text(
                    "Call",
                    style: TextStyle(fontSize: AppFontSizes.bodySmall, fontWeight: AppFontWeights.semiBold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String text, String buttonText, VoidCallback onPressed) {
    return Material(
      color: ColorRes.transparentColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: ColorRes.leadGreyColor[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorRes.leadGreyColor[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: ColorRes.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style:  TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  color: ColorRes.blackShade87,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  buttonText,
                  style:  TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.white,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "$title:",
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.leadGreyColor[900],
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(Items property) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor[300]!, width: 1),
        color: ColorRes.white,
      ),
      child: Row(
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              image: DecorationImage(
                image: property.propertyImages != null
                    ? NetworkImage(property.propertyImages!.first)
                    : AssetImage(IMGRes.home3) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (property.title != null) ...[
                    Text(
                      property.title!,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.bold,
                        color: ColorRes.leadGreyColor[900],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.address ?? 'N/A',
                          style: TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (property.propertyDetails?.financialInfo?.price.toString() != null) ...[
                        _buildPropertyChip(
                          Formatter.formatPrice(property.propertyDetails!.financialInfo!.price),
                          Icons.currency_rupee_rounded,
                        ),
                      ],
                      if (property.propertyDetails?.propertyBuiltUpArea != null) ...[
                        _buildPropertyChip(
                          "${property.propertyDetails?.propertyBuiltUpArea.toString()} sq.ft",
                          Icons.square_foot_rounded,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorRes.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ColorRes.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: ColorRes.primary,
              fontSize: AppFontSizes.extraSmall,
              fontWeight: AppFontWeights.bold,
            ),
          ),
        ],
      ),
    );
  }
}

String getInitials(String name) {
  if (name.trim().isEmpty) return '';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  } else {
    final firstInitial = parts[0].isNotEmpty ? parts[0][0] : '';
    final secondInitial = parts[1].isNotEmpty ? parts[1][0] : '';
    return (firstInitial + secondInitial).toUpperCase();
  }
}

String _formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inMinutes}m ago';
  }
}

Color _getStageColor(String stage) {
  switch (stage.toLowerCase()) {
    case 'new':
      return ColorRes.blueColor;
    case 'contacted':
      return ColorRes.orangeColor;
    case 'qualified':
      return ColorRes.purpleColor;
    case 'negotiation':
      return ColorRes.leadIndigoColor;
    case 'lost':
      return ColorRes.error;
    case 'converted':
      return ColorRes.success;
    default:
      return ColorRes.leadGreyColor;
  }
}
