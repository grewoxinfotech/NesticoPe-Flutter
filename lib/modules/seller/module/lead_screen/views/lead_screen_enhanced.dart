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
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
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
//                             color: Colors.grey[800],
//                             fontWeight: FontWeight.w600,
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
//                           color: Colors.grey[800],
//                           fontWeight: FontWeight.w600,
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
//               colors: [Colors.grey[50]!, Colors.white],
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
//         border: Border.all(color: Colors.grey[300]!),
//         color: Colors.white,
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
//                     color: Colors.white,
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
//                         color: Colors.black54,
//                         fontWeight: FontWeight.w600,
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
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           date,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
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
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
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
//             color: Colors.grey[700],
//             fontWeight: FontWeight.w500,
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
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.black54,
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
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
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 size: 16,
//                 color: ColorRes.primary.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
//           ],
//         ),
//         Text(
//           date,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
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
//         color: Colors.white,
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
//                         color: Colors.black54,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Obx(
//                       ()=> Text(
//                         "${DateFormat('dd MMM yyyy, hh:mm a').format(controller.selectedDate.value!) ?? "N/A"}",
//                         style: TextStyle(fontSize: 12, color: Colors.black54),
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
//                               color: Colors.grey[800],
//                               fontWeight: FontWeight.w600,
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
//             Divider(color: Colors.black12),
//             SizedBox(height: 12),
//             _buildInfoRow("Property", "2BHK Apartment in Viman Nagar"),
//             SizedBox(height: 8),
//             _buildInfoRow("Type", "Apartment"),
//             SizedBox(height: 8),
//             _buildInfoRow("Price", "65 Lakhs"),
//             SizedBox(height: 8),
//             _buildInfoRow("Area", "1200 sq ft"),
//             SizedBox(height: 12),
//             Divider(color: Colors.black12),
//             SizedBox(height: 12),
//             Text(
//               "Intrested In: ",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black54,
//                 fontWeight: FontWeight.w600,
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
//                             fontWeight: FontWeight.w600,
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
//                             fontWeight: FontWeight.w600,
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
//         Text(text, style: TextStyle(fontSize: 12, color: Colors.black54)),
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
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(width: 6),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[800],
//             fontWeight: FontWeight.w600,
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
//         border: Border.all(color: Colors.grey[300]!),
//         color: Colors.white,
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
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   "${property['address']}",
//                   style: TextStyle(fontSize: 10, color: Colors.grey[600]),
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
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.black54,
//           fontSize: 9,
//           fontWeight: FontWeight.w600,
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
// //         border: Border.all(color: Colors.grey[300]!),
// //         color: Colors.white,
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
// //                         color: Colors.black.withOpacity(0.7),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Text(
// //                         property['propertyId'],
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
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
// //                       _buildChip(source, Colors.blue[50]!, Colors.blue[700]!),
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
// //                       color: Colors.grey[50],
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: Colors.grey[200]!),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           property['name'],
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                             fontWeight: FontWeight.w600,
// //                             color: Colors.grey[900],
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
// //                       border: Border.all(color: Colors.grey[200]!),
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
// //                                   fontWeight: FontWeight.w600,
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
// //                                         color: Colors.grey[800],
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
// //                                       color: Colors.grey[800],
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
// //             color: Colors.grey[700],
// //             fontWeight: FontWeight.w500,
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
// //           fontWeight: FontWeight.w600,
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
// //                 color: Colors.grey[100],
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Icon(
// //                 icon,
// //                 size: 16,
// //                 color: ColorRes.primary.withOpacity(0.6),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
// //           ],
// //         ),
// //         Text(
// //           date,
// //           style: TextStyle(
// //             fontSize: 12,
// //             color: Colors.grey[600],
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:intl/intl.dart';

import '../controllers/lead_controller.dart';

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

class LeadScreen extends StatelessWidget {
  const LeadScreen({super.key});

  List<Map<String, dynamic>> getFilteredLeads(LeadController controller) {
    List<Map<String, dynamic>> filteredLeads = List.from(dummyLeads);

    // Filter by status
    if (controller.selectedFilterStatus.value.isNotEmpty &&
        controller.selectedFilterStatus.value != 'All Status') {
      filteredLeads =
          filteredLeads
              .where(
                (lead) =>
                    lead['stage'] == controller.selectedFilterStatus.value,
              )
              .toList();
    }

    // Filter by lead type (property type)
    if (controller.selectedLeadType.value.isNotEmpty &&
        controller.selectedLeadType.value != 'All Leads') {
      if (controller.selectedLeadType.value == 'Residential') {
        filteredLeads =
            filteredLeads
                .where(
                  (lead) => [
                    'Apartment',
                    'Villa',
                    'Penthouse',
                  ].contains(lead['property']['type']),
                )
                .toList();
      } else if (controller.selectedLeadType.value == 'Commercial') {
        filteredLeads =
            filteredLeads
                .where((lead) => lead['property']['type'] == 'Commercial')
                .toList();
      }
    }

    return filteredLeads;
  }

  @override
  Widget build(BuildContext context) {
    final mainController = Get.put(LeadController(), tag: 'main');

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            final filteredCount = getFilteredLeads(mainController).length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Leads",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Text(
                  "$filteredCount of ${dummyLeads.length} leads",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => NesticoPeDropdownField(
                        value:
                            mainController.selectedFilterStatus.value.isEmpty
                                ? null
                                : mainController.selectedFilterStatus.value,
                        items:
                            ['All Status', ...mainController.statusList]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            mainController.selectedFilterStatus.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                      () => NesticoPeDropdownField(
                        value:
                            mainController.selectedLeadType.value.isEmpty
                                ? null
                                : mainController.selectedLeadType.value,
                        items:
                            mainController.leadTypeList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            mainController.selectedLeadType.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[50]!, Colors.white],
            ),
          ),
          child: Obx(() {
            final filteredLeads = getFilteredLeads(mainController);

            if (filteredLeads.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No leads found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Try adjusting your filters',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                final lead = filteredLeads[index];
                final originalIndex = dummyLeads.indexOf(lead);

                return LeadCard(
                  index: originalIndex,
                  name: lead['name'],
                  email: lead['email'],
                  phone: lead['phone'],
                  property: lead['property'],
                  reseller: lead['reseller'],
                  source: lead['source'],
                  stage: lead['stage'],
                  date: lead['date'],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final int index;
  final String name;
  final String email;
  final String phone;
  final Map<String, dynamic> property;
  final String reseller;
  final String source;
  final String stage;
  final String date;

  const LeadCard({
    super.key,
    required this.index,
    required this.name,
    required this.email,
    required this.phone,
    required this.property,
    required this.reseller,
    required this.source,
    required this.stage,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // Get or create controller for this specific lead
    final controller = Get.put(LeadController(), tag: 'lead_$index');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: () {
          Get.bottomSheet(
            DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.68,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: LeadDetailBottomSheet(
                      controller: controller,
                      leadData: {
                        'name': name,
                        'email': email,
                        'phone': phone,
                        'property': property,
                        'reseller': reseller,
                        'source': source,
                        'stage': stage,
                        'date': date,
                      },
                    ),
                  ),
                );
              },
            ),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$name >",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Obx(
                            () => _buildChip(
                              controller.selectedFilterStatus.value.isEmpty
                                  ? stage
                                  : controller.selectedFilterStatus.value,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 16,
                            child: const VerticalDivider(
                              thickness: 1,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildActionButton(
                      Icons.phone_outlined,
                      () => _makePhoneCall(phone),
                    ),
                    const SizedBox(width: 6),
                    _buildActionButton(
                      Icons.email_outlined,
                      () => _sendEmail(email),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              property['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorRes.primary.withOpacity(0.1),
        ),
        child: Icon(icon, color: ColorRes.primary),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // Implement phone call functionality
    Get.snackbar(
      'Calling',
      'Calling $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _sendEmail(String email) {
    // Implement email functionality
    Get.snackbar(
      'Email',
      'Opening email for $email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class LeadDetailBottomSheet extends StatelessWidget {
  final LeadController controller;
  final Map<String, dynamic> leadData;

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
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
        controller.dateController.text = DateFormat(
          'dd MMM yyyy, hh:mm a',
        ).format(fullDateTime);

        Get.snackbar(
          'Follow-up Scheduled',
          'Follow-up set for ${DateFormat('dd MMM yyyy, hh:mm a').format(fullDateTime)}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showNotesDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController();
    notesController.text = controller.notes.value;

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Notes'),
        content: TextField(
          controller: notesController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter your notes here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.notes.value = notesController.text;
              Get.back();
              Get.snackbar(
                'Notes Updated',
                'Lead notes have been updated',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
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
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leadData['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      controller.selectedDate.value != null
                          ? DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(controller.selectedDate.value!)
                          : "No follow-up set",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            controller.selectedDate.value != null
                                ? Colors.black54
                                : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: NesticoPeDropdownField(
                    value: controller.selectedStatus.value,
                    items:
                        controller.statusList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedStatus.value = value;
                        // Get.snackbar(
                        //   'Status Updated',
                        //   'Lead status changed to $value',
                        //   snackPosition: SnackPosition.BOTTOM,
                        //   backgroundColor: Colors.blue,
                        //   colorText: Colors.white,
                        // );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildTextWithIconAndButton(
            Icons.calendar_month,
            "Follow up",
            controller.selectedDate.value != null
                ? "Update Date"
                : "Set Date And Time",
            () => pickDateTime(context, controller),
          ),

          const SizedBox(height: 12),

          _buildTextWithIconAndButton(
            Icons.note_add,
            "Notes",
            "Edit",
            () => _showNotesDialog(context),
          ),

          // Show notes if any
          Obx(() {
            if (controller.notes.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 21),
                child: Text(
                  controller.notes.value,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: 12),
          const Divider(color: Colors.black12),
          const SizedBox(height: 12),

          _buildInfoRow("Property", leadData['property']['name']),
          const SizedBox(height: 8),
          _buildInfoRow("Type", leadData['property']['type']),
          const SizedBox(height: 8),
          _buildInfoRow("Price", leadData['property']['price']),
          const SizedBox(height: 8),
          _buildInfoRow("Area", leadData['property']['area']),
          const SizedBox(height: 12),
          const Divider(color: Colors.black12),
          const SizedBox(height: 12),

          const Text(
            "Interested In: ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          _buildPropertyCard(leadData['property']),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => _makePhoneCall(leadData['phone']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary.withOpacity(0.1),
                    foregroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: ColorRes.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Center(child: Icon(Icons.phone_outlined)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () => _sendMessage(leadData['phone']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary.withOpacity(0.1),
                    foregroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: ColorRes.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.message_outlined),
                      SizedBox(width: 6),
                      Text(
                        "Message",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _makePhoneCall(leadData['phone']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    foregroundColor: ColorRes.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: ColorRes.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_outlined),
                      SizedBox(width: 6),
                      Text(
                        "Call",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Add some bottom padding for better UX
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    Get.snackbar(
      'Calling',
      'Calling $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _sendMessage(String phoneNumber) {
    Get.snackbar(
      'Message',
      'Opening message for $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Widget _buildTextWithIconAndButton(
    IconData icon,
    String text,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Row(
      children: [
        Icon(icon, color: ColorRes.primary, size: 15),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 10,
              decoration: TextDecoration.underline,
              color: ColorRes.primary,
              decorationColor: ColorRes.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(property['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    property['name'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property['address'] ?? '',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildChip(property['price']),
                      const SizedBox(width: 4),
                      _buildChip(property['area']),
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

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
