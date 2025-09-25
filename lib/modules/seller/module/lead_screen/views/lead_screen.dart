// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
//
// final List<Map<String, dynamic>> dummyLeads = [
//   {
//     "name": "Ethan Valdez",
//     "email": "ethan.valdez@example.com",
//     "phone": "+91 98765 12345",
//     "property": "2BHK Apartment in Viman Nagar",
//     "reseller": "RS1",
//     "source": "App",
//     "stage": "Interested",
//     "date": "23 Sep 2025",
//   },
//   {
//     "name": "Sophia Martinez",
//     "email": "sophia.m@example.com",
//     "phone": "+91 91234 56789",
//     "property": "Luxury Villa in Goa",
//     "reseller": "RS2",
//     "source": "Website",
//     "stage": "New Lead",
//     "date": "20 Sep 2025",
//   },
//   {
//     "name": "Arjun Sharma",
//     "email": "arjun.sharma@example.com",
//     "phone": "+91 99887 66554",
//     "property": "3BHK Flat in Bandra, Mumbai",
//     "reseller": "RS3",
//     "source": "Referral",
//     "stage": "Contacted",
//     "date": "18 Sep 2025",
//   },
//   {
//     "name": "Liam Johnson",
//     "email": "liam.j@example.com",
//     "phone": "+91 98770 11223",
//     "property": "Office Space in Connaught Place",
//     "reseller": "RS4",
//     "source": "Other",
//     "stage": "Negotiation",
//     "date": "15 Sep 2025",
//   },
//   {
//     "name": "Aarohi Mehta",
//     "email": "aarohi.mehta@example.com",
//     "phone": "+91 98989 77777",
//     "property": "Penthouse in Pune",
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
//         ),
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
//               return LeadCard(
//                 name: lead['name'],
//                 email: lead['email'],
//                 phone: lead['phone'],
//                 property: lead['property'],
//                 reseller: lead['reseller'],
//                 source: lead['source'],
//                 stage: lead['stage'],
//                 date: lead['date'],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// class LeadCard extends StatelessWidget {
//   final String name;
//   final String email;
//   final String phone;
//   final String property;
//   final String reseller;
//   final String source;
//   final String stage;
//   final String date;
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
//     required this.date,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[300]!),
//         color: Colors.transparent,
//       ),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: InkWell(
//         onTap: () {}, // Handle card tap for viewing details
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: AssetImage(IMGRes.user_2),
//                     radius: 25,
//                   ),
//                   SizedBox(width: 16),
//                   Flexible(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: Theme.of(
//                             context,
//                           ).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.email_outlined,
//                               color: ColorRes.primary,
//                               size: 14,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               email,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[800],
//                                 // height: 1.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.phone_outlined,
//                               color: ColorRes.primary,
//                               size: 14,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               phone,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[800],
//                                 // height: 1.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   _buildChip(source, Colors.blue[50]!, Colors.blue[700]!),
//                   const SizedBox(width: 8),
//                   _buildChip(stage, Colors.green[50]!, Colors.green[700]!),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               _buildInfoRow(Icons.home_work_outlined, property),
//               const SizedBox(height: 10),
//               _buildInfoRow(
//                 Icons.store_mall_directory_outlined,
//                 "Reseller: $reseller",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChip(String text, Color bgColor, Color textColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: textColor.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 16, color: ColorRes.primary.withOpacity(0.6)),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey[800],
//               // height: 1.3,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
