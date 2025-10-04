// import '../../model/reseller_lead_model/reseller_lead_overview.dart';
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
//
// // Import your model here
// // import 'your_model_path.dart';
//
// class LeadDetailScreen extends StatelessWidget {
//   final ResellerLeadOverview lead;
//
//   const LeadDetailScreen({Key? key, required this.lead}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isCompact = MediaQuery.of(context).size.width < 600;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'Lead Details',
//           style: TextStyle(
//             fontWeight: AppFontWeights.bold,
//             fontSize: AppFontSizes.large,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to edit screen
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               _showMoreOptions(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Property Image Gallery
//             _buildPropertyImageGallery(context),
//
//             // Contact Information Card
//             _buildContactCard(context, isCompact),
//
//             // Property Overview Card
//             _buildPropertyOverviewCard(context, isCompact),
//
//             // Property Details Card
//             _buildPropertyDetailsCard(context, isCompact),
//
//             // Amenities Card
//             _buildAmenitiesCard(context, isCompact),
//
//             // Financial Information Card
//             _buildFinancialCard(context, isCompact),
//
//             // Lead Status & Timeline Card
//             _buildStatusTimelineCard(context, isCompact),
//
//             // Notes Section
//             if (lead.notes != null) _buildNotesCard(context, isCompact),
//
//             // Action Buttons
//             _buildActionButtons(context, isCompact),
//
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPropertyImageGallery(BuildContext context) {
//     // Dummy images - replace with actual images if available
//     final dummyImages = [
//       'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
//       'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
//       'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
//     ];
//
//     return Container(
//       height: 280,
//       color: Colors.white,
//       child: Stack(
//         children: [
//           PageView.builder(
//             itemCount: dummyImages.length,
//             itemBuilder: (context, index) {
//               return Image.network(
//                 dummyImages[index],
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.home, size: 80, color: Colors.grey[400]),
//                         SizedBox(height: 8),
//                         Text(
//                           lead.customFields.title,
//                           style: TextStyle(
//                             fontSize: AppFontSizes.large,
//                             fontWeight: AppFontWeights.bold,
//                             color: Colors.grey[600],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//           // Image counter
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 '1/${dummyImages.length}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//             ),
//           ),
//           // Status Badge
//           Positioned(
//             top: 16,
//             left: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: _getStatusColor(lead.status),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 _getStatusText(lead.status),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactCard(BuildContext context, bool isCompact) {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(isCompact ? 16 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: isCompact ? 28 : 32,
//                 backgroundColor: ColorRes.primary.withOpacity(0.2),
//                 child: Text(
//                   lead.name.split(' ').map((e) => e[0]).join().toUpperCase(),
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontWeight: AppFontWeights.bold,
//                     fontSize: isCompact ? AppFontSizes.large : AppFontSizes.large,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       lead.name,
//                       style: TextStyle(
//                         fontSize: isCompact ? AppFontSizes.large : AppFontSizes.large,
//                         fontWeight: AppFontWeights.bold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Lead Source: ${lead.source.toUpperCase()}',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Divider(),
//           SizedBox(height: 16),
//           _buildContactRow(
//             Icons.email_outlined,
//             'Email',
//             lead.email,
//             Colors.blue,
//                 () => _launchEmail(lead.email),
//           ),
//           SizedBox(height: 12),
//           _buildContactRow(
//             Icons.phone_outlined,
//             'Phone',
//             lead.phone,
//             Colors.green,
//                 () => _launchPhone(lead.phone),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactRow(
//       IconData icon,
//       String label,
//       String value,
//       Color color,
//       VoidCallback onTap,
//       ) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, size: 20, color: color),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.medium,
//                       color: ColorRes.textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPropertyOverviewCard(BuildContext context, bool isCompact) {
//     final customFields = lead.customFields;
//     final propertyDetails = customFields.propertyDetails;
//
//     return _buildCard(
//       context,
//       isCompact,
//       title: 'Property Overview',
//       icon: Icons.home_outlined,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             customFields.title,
//             style: TextStyle(
//               fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
//               fontWeight: AppFontWeights.bold,
//               color: ColorRes.textColor,
//             ),
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
//               SizedBox(width: 4),
//               Expanded(
//                 child: Text(
//                   '${customFields.address}, ${customFields.city}, ${customFields.state} - ${customFields.zipCode}',
//                   style: TextStyle(
//                     fontSize: AppFontSizes.small,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               _buildOverviewChip(
//                 '${propertyDetails.bhk} BHK',
//                 Icons.bed_outlined,
//                 Colors.blue,
//               ),
//               SizedBox(width: 8),
//               _buildOverviewChip(
//                 customFields.propertyType.toUpperCase(),
//                 Icons.apartment_outlined,
//                 Colors.purple,
//               ),
//               SizedBox(width: 8),
//               _buildOverviewChip(
//                 customFields.listingType,
//                 Icons.sell_outlined,
//                 Colors.orange,
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Divider(),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(
//                 '${propertyDetails.propertyCarpetArea}',
//                 'Carpet Area\n(sq.ft)',
//                 Icons.straighten,
//               ),
//               _buildStatItem(
//                 '${propertyDetails.bathroom}',
//                 'Bathrooms',
//                 Icons.bathtub_outlined,
//               ),
//               _buildStatItem(
//                 '${propertyDetails.balcony}',
//                 'Balconies',
//                 Icons.balcony_outlined,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOverviewChip(String text, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: AppFontSizes.extraSmall,
//               color: color,
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatItem(String value, String label, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, size: 24, color: ColorRes.primary),
//         SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: AppFontSizes.large,
//             fontWeight: AppFontWeights.bold,
//             color: ColorRes.textColor,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: AppFontSizes.extraSmall,
//             color: Colors.grey[600],
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPropertyDetailsCard(BuildContext context, bool isCompact) {
//     final propertyDetails = lead.customFields.propertyDetails;
//     final furnishInfo = propertyDetails.furnishInfo;
//
//     return _buildCard(
//       context,
//       isCompact,
//       title: 'Property Details',
//       icon: Icons.info_outline,
//       child: Column(
//         children: [
//           _buildDetailRow('Builder', lead.customFields.builderName),
//           _buildDetailRow('Project', lead.customFields.projectName),
//           _buildDetailRow('Property Type', lead.customFields.propertyType.toUpperCase()),
//           _buildDetailRow('Zone Type', propertyDetails.zoneType),
//           _buildDetailRow('Facing', propertyDetails.propertyFacing),
//           _buildDetailRow('Floor', '${propertyDetails.floorInfo.floorNumber} of ${propertyDetails.floorInfo.totalFloors}'),
//           _buildDetailRow('Built-up Area', '${propertyDetails.propertyBuiltUpArea} sq.ft'),
//           _buildDetailRow('Carpet Area', '${propertyDetails.propertyCarpetArea} sq.ft'),
//           _buildDetailRow('Furnishing', furnishInfo.furnishType.toUpperCase()),
//           if (furnishInfo.furnishType == 'fully-furnished')
//             _buildDetailRow('Furnish Details', furnishInfo.furnishDetails?.other ?? 'N/A'),
//           _buildDetailRow('Parking', '${propertyDetails.parkingInfo.openParking ? "Open" : ""}${propertyDetails.parkingInfo.openParking && propertyDetails.parkingInfo.coveredParking ? " & " : ""}${propertyDetails.parkingInfo.coveredParking ? "Covered" : ""}'),
//           _buildDetailRow('Possession', propertyDetails.possessionInfo.possessionStatus),
//           _buildDetailRow('Property Age', '${propertyDetails.possessionInfo.propertyAgeInYears} years'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.textColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAmenitiesCard(BuildContext context, bool isCompact) {
//     final amenities = lead.customFields.propertyDetails.amenities;
//
//     return _buildCard(
//       context,
//       isCompact,
//       title: 'Amenities',
//       icon: Icons.star_outline,
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: amenities.map((amenity) {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.green.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.green.withOpacity(0.3)),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.check_circle, size: 14, color: Colors.green),
//                 SizedBox(width: 6),
//                 Text(
//                   amenity,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.small,
//                     color: Colors.green[700],
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildFinancialCard(BuildContext context, bool isCompact) {
//     final financialInfo = lead.customFields.propertyDetails.financialInfo;
//
//     return _buildCard(
//       context,
//       isCompact,
//       title: 'Financial Information',
//       icon: Icons.currency_rupee_outlined,
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.green.withOpacity(0.3)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Property Price',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       Formatter.formatPrice(financialInfo.propertyPrice),
//                       style: TextStyle(
//                         fontSize: isCompact ? AppFontSizes.large : AppFontSizes.large,
//                         fontWeight: AppFontWeights.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (financialInfo.negotiable)
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'Negotiable',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.extraSmall,
//                         color: Colors.orange[700],
//                         fontWeight: AppFontWeights.bold,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           _buildDetailRow('Broker Commission', Formatter.formatPrice(financialInfo.brokerCommission)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusTimelineCard(BuildContext context, bool isCompact) {
//     return _buildCard(
//       context,
//       isCompact,
//       title: 'Lead Timeline',
//       icon: Icons.timeline_outlined,
//       child: Column(
//         children: [
//           _buildTimelineItem(
//             'Lead Created',
//             _formatDateTime(lead.createdAt),
//             Icons.add_circle_outline,
//             Colors.blue,
//             true,
//           ),
//           if (lead.lastContactedAt != null)
//             _buildTimelineItem(
//               'Last Contacted',
//               _formatDateTime(lead.lastContactedAt!),
//               Icons.phone_outlined,
//               Colors.orange,
//               false,
//             ),
//           _buildTimelineItem(
//             'Current Status',
//             _getStatusText(lead.status),
//             Icons.flag_outlined,
//             _getStatusColor(lead.status),
//             false,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem(
//       String title,
//       String subtitle,
//       IconData icon,
//       Color color,
//       bool isFirst,
//       ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 20, color: color),
//             ),
//             if (!isFirst)
//               Container(
//                 width: 2,
//                 height: 40,
//                 color: color.withOpacity(0.3),
//                 margin: EdgeInsets.symmetric(vertical: 4),
//               ),
//           ],
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(bottom: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textColor,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.small,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotesCard(BuildContext context, bool isCompact) {
//     return _buildCard(
//       context,
//       isCompact,
//       title: 'Notes',
//       icon: Icons.note_outlined,
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.amber.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.amber.withOpacity(0.3)),
//         ),
//         child: Text(
//           lead.notes!,
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             color: Colors.grey[800],
//             height: 1.5,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () => _launchPhone(lead.phone),
//               icon: Icon(Icons.phone),
//               label: Text(
//                 'Call',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () => _launchEmail(lead.email),
//               icon: Icon(Icons.email),
//               label: Text(
//                 'Email',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorRes.primary,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(
//       BuildContext context,
//       bool isCompact, {
//         required String title,
//         required IconData icon,
//         required Widget child,
//       }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: EdgeInsets.all(isCompact ? 16 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, size: 20, color: ColorRes.primary),
//               ),
//               SizedBox(width: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
//                   fontWeight: AppFontWeights.bold,
//                   color: ColorRes.textColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           child,
//         ],
//       ),
//     );
//   }
//
//   void _showMoreOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.share, color: Colors.blue),
//                 title: Text('Share Lead'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement share functionality
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.flag, color: Colors.orange),
//                 title: Text('Mark as Fake'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement mark as fake
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.delete, color: Colors.red),
//                 title: Text('Delete Lead'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement delete functionality
//                 },
//               ),
//               SizedBox(height: 8),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'new':
//         return Colors.blue;
//       case 'contacted':
//         return Colors.orange;
//       case 'qualified':
//         return Colors.purple;
//       case 'negotiating':
//         return Colors.indigo;
//       case 'sold':
//         return Colors.green;
//       case 'lost':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _getStatusText(String status) {
//     return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }
//
//   void _launchPhone(String phone) {
//     // Implement phone call functionality
//     // url_launcher package: launch('tel:$phone');
//   }
//
//   void _launchEmail(String email) {
//     // Implement email functionality
//     // url_launcher package: launch('mailto:$email');
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
//
// import '../../model/reseller_lead_model/reseller_lead_overview.dart';
//
// // Import your model here
// // import 'your_model_path.dart';
//
// class LeadDetailScreen extends StatelessWidget {
//   final ResellerLeadOverview lead;
//
//   const LeadDetailScreen({Key? key, required this.lead}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isCompact = MediaQuery.of(context).size.width < 600;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(onPressed: () {
//           Get.back();
//         }, icon: Icon(Icons.arrow_back)),
//         title: Text(
//           'Lead Details',
//           style: TextStyle(
//             fontWeight: AppFontWeights.bold,
//             fontSize: AppFontSizes.large,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               _showMoreOptions(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Property Image Gallery
//             _buildPropertyImageGallery(context),
//
//             SizedBox(height: 16),
//
//             // Contact Information
//             _buildContactSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // Property Overview
//             _buildPropertyOverviewSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // Property Details
//             _buildPropertyDetailsSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // Amenities
//             _buildAmenitiesSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // Financial Information
//             _buildFinancialSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // Lead Status & Timeline
//             _buildStatusTimelineSection(context, isCompact),
//
//             // Notes Section
//             if (lead.notes != null) ...[
//               Divider(thickness: 8, color: Colors.grey[100]),
//               _buildNotesSection(context, isCompact),
//             ],
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // Action Buttons
//             _buildActionButtons(context, isCompact),
//
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPropertyImageGallery(BuildContext context) {
//     // Dummy images - replace with actual images if available
//     final dummyImages = [
//       'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
//       'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
//       'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
//     ];
//
//     return Container(
//       height: 280,
//       color: Colors.white,
//       child: Stack(
//         children: [
//           PageView.builder(
//             itemCount: dummyImages.length,
//             onPageChanged: (value) {
//             },
//             itemBuilder: (context, index) {
//               return Image.network(
//                 dummyImages[index],
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.home, size: 80, color: Colors.grey[400]),
//                         SizedBox(height: 8),
//                         Text(
//                           lead.customFields.title,
//                           style: TextStyle(
//                             fontSize: AppFontSizes.large,
//                             fontWeight: AppFontWeights.bold,
//                             color: Colors.grey[600],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//           // Image counter
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 '1/${dummyImages.length}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//             ),
//           ),
//           // Status Badge
//           Positioned(
//             top: 16,
//             left: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: _getStatusColor(lead.status),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 _getStatusText(lead.status),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: AppFontSizes.extraSmall,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: isCompact ? 24 : 28,
//                 backgroundColor: ColorRes.primary.withOpacity(0.2),
//                 child: Text(
//                   lead.name.split(' ').map((e) => e[0]).join().toUpperCase(),
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontWeight: AppFontWeights.semiBold,
//                     fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       lead.name,
//                       style: TextStyle(
//                         fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200], // light background
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Lead Source: ${lead.source.toUpperCase()}',
//                               style: TextStyle(
//                                 color: Colors.grey[700],
//                                 fontSize: AppFontSizes.extraSmall,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Container(
//
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Property Type: ${lead.customFields.propertyType.toUpperCase()}',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.extraSmall,
//                                 color: Colors.grey[700],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // SizedBox(height: 10),
//           // Divider(thickness: 1, color: Colors.grey[300]),
//           SizedBox(height: 16),
//           _buildContactRow(
//             Icons.email_outlined,
//             'Email',
//             lead.email,
//             Colors.blue,
//                 () => _launchEmail(lead.email),
//           ),
//           SizedBox(height: 12),
//           _buildContactRow(
//             Icons.phone_outlined,
//             'Phone',
//             lead.phone,
//             Colors.green,
//                 () => _launchPhone(lead.phone),
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactRow(
//       IconData icon,
//       String label,
//       String value,
//       Color color,
//       VoidCallback onTap,
//       ) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, size: 18, color: color),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: AppFontSizes.extraSmall,
//                       color: Colors.grey[700],
//                     ),
//
//                   ),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       fontWeight: FontWeight.w500,
//                       color: ColorRes.textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
//   //   final customFields = lead.customFields;
//   //   final propertyDetails = customFields.propertyDetails;
//   //
//   //   return Padding(
//   //     padding: EdgeInsets.all(16),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         _buildSectionHeader('Property Overview', Icons.home_outlined),
//   //         SizedBox(height: 16),
//   //         Text(
//   //           customFields.title,
//   //           style: TextStyle(
//   //             fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
//   //             fontWeight: AppFontWeights.bold,
//   //             color: ColorRes.textColor,
//   //           ),
//   //         ),
//   //         SizedBox(height: 8),
//   //         Row(
//   //           children: [
//   //             Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
//   //             SizedBox(width: 4),
//   //             Expanded(
//   //               child: Text(
//   //                 '${customFields.address}, ${customFields.city}, ${customFields.state} - ${customFields.zipCode}',
//   //                 style: TextStyle(
//   //                   fontSize: AppFontSizes.small,
//   //                   color: Colors.grey[600],
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         SizedBox(height: 16),
//   //         Wrap(
//   //           spacing: 8,
//   //           runSpacing: 8,
//   //           children: [
//   //             _buildOverviewChip(
//   //               '${propertyDetails.bhk} BHK',
//   //               Icons.bed_outlined,
//   //               Colors.blue,
//   //             ),
//   //             _buildOverviewChip(
//   //               customFields.propertyType.toUpperCase(),
//   //               Icons.apartment_outlined,
//   //               Colors.purple,
//   //             ),
//   //             _buildOverviewChip(
//   //               customFields.listingType,
//   //               Icons.sell_outlined,
//   //               Colors.orange,
//   //             ),
//   //           ],
//   //         ),
//   //         SizedBox(height: 20),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //           children: [
//   //             _buildStatItem(
//   //               '${propertyDetails.propertyCarpetArea}',
//   //               'Carpet Area\n(sq.ft)',
//   //               Icons.straighten,
//   //             ),
//   //             Container(width: 1, height: 50, color: Colors.grey[300]),
//   //             _buildStatItem(
//   //               '${propertyDetails.bathroom}',
//   //               'Bathrooms',
//   //               Icons.bathtub_outlined,
//   //             ),
//   //             Container(width: 1, height: 50, color: Colors.grey[300]),
//   //             _buildStatItem(
//   //               '${propertyDetails.balcony}',
//   //               'Balconies',
//   //               Icons.balcony_outlined,
//   //             ),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _buildSectionHeader(String title, IconData icon) {
//   //   return Row(
//   //     children: [
//   //       Icon(icon, size: 22, color: ColorRes.primary),
//   //       SizedBox(width: 8),
//   //       Text(
//   //         title,
//   //         style: TextStyle(
//   //           fontSize: AppFontSizes.large,
//   //           fontWeight: AppFontWeights.bold,
//   //           color: ColorRes.textColor,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//   //
//   // Widget _buildOverviewChip(String text, IconData icon, Color color) {
//   //   return Container(
//   //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//   //     decoration: BoxDecoration(
//   //       color: color.withOpacity(0.1),
//   //       borderRadius: BorderRadius.circular(20),
//   //       border: Border.all(color: color.withOpacity(0.3)),
//   //     ),
//   //     child: Row(
//   //       mainAxisSize: MainAxisSize.min,
//   //       children: [
//   //         Icon(icon, size: 14, color: color),
//   //         SizedBox(width: 4),
//   //         Text(
//   //           text,
//   //           style: TextStyle(
//   //             fontSize: AppFontSizes.extraSmall,
//   //             color: color,
//   //             fontWeight: AppFontWeights.semiBold,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }.
//
//
//   Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
//     final customFields = lead.customFields;
//     final propertyDetails = customFields.propertyDetails;
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Property Overview', Icons.home_outlined, isCompact),
//           const SizedBox(height: 16),
//
//           // Title
//           Text(
//             customFields.title,
//             style: TextStyle(
//               fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.textColor,
//             ),
//           ),
//           const SizedBox(height: 6),
//
//           // Address
//           SizedBox(
//             width: 300,
//             child: Text(
//
//               '${customFields.address}, ${customFields.city}, ${customFields.state} - ${customFields.zipCode}',
//               style: TextStyle(
//                 fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
//                 color: Colors.grey[700],
//                 // height: 1.3,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Chips
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _buildOverviewChip(
//                 '${propertyDetails.bhk} BHK',
//                 Icons.bed_outlined,
//                 ColorRes.primary ,
//                 isCompact,
//               ),
//               _buildOverviewChip(
//                 customFields.propertyType.toUpperCase(),
//                 Icons.apartment_outlined,
//                 Colors.purple,
//                 isCompact,
//               ),
//               _buildOverviewChip(
//                 customFields.listingType,
//                 Icons.sell_outlined,
//                 Colors.orange,
//                 isCompact,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // Stats
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(
//                 '${propertyDetails.propertyCarpetArea}',
//                 'Carpet Area\n(sq.ft)',
//                 Icons.straighten,
//                 isCompact,
//               ),
//               Container(width: 1, height: 50, color: Colors.grey[300]),
//               _buildStatItem(
//                 '${propertyDetails.bathroom}',
//                 'Bathrooms',
//                 Icons.bathtub_outlined,
//                 isCompact,
//               ),
//               Container(width: 1, height: 50, color: Colors.grey[300]),
//               _buildStatItem(
//                 '${propertyDetails.balcony}',
//                 'Balconies',
//                 Icons.balcony_outlined,
//                 isCompact,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon, bool isCompact) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: ColorRes.primary),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textColor,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildOverviewChip(
//       String text, IconData icon, Color color, bool isCompact) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
//               color: color,
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatItem(
//       String value, String label, IconData icon, bool isCompact) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon,
//             size: isCompact ? 18 : 22, color: ColorRes.primary.withOpacity(0.8)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: isCompact ? AppFontSizes.small : AppFontSizes.medium,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textColor,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
//             color: Colors.grey[700],
//             // height: 1.2,
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   // Widget _buildStatItem(String value, String label, IconData icon) {
//   //   return Column(
//   //     children: [
//   //       Icon(icon, size: 24, color: ColorRes.primary),
//   //       SizedBox(height: 8),
//   //       Text(
//   //         value,
//   //         style: TextStyle(
//   //           fontSize: AppFontSizes.large,
//   //           fontWeight: AppFontWeights.bold,
//   //           color: ColorRes.textColor,
//   //         ),
//   //       ),
//   //       SizedBox(height: 4),
//   //       Text(
//   //         label,
//   //         style: TextStyle(
//   //           fontSize: AppFontSizes.extraSmall,
//   //           color: Colors.grey[600],
//   //         ),
//   //         textAlign: TextAlign.center,
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
//     final propertyDetails = lead.customFields.propertyDetails;
//     final furnishInfo = propertyDetails.furnishInfo;
//
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Property Details', Icons.info_outline,true),
//           SizedBox(height: 16),
//           _buildDetailRow('Builder', lead.customFields.builderName),
//           _buildDetailRow('Project', lead.customFields.projectName),
//           _buildDetailRow('Property Type', lead.customFields.propertyType.toUpperCase()),
//           _buildDetailRow('Zone Type', propertyDetails.zoneType),
//           _buildDetailRow('Facing', propertyDetails.propertyFacing),
//           _buildDetailRow('Floor', '${propertyDetails.floorInfo.floorNumber} of ${propertyDetails.floorInfo.totalFloors}'),
//           _buildDetailRow('Built-up Area', '${propertyDetails.propertyBuiltUpArea} sq.ft'),
//           _buildDetailRow('Carpet Area', '${propertyDetails.propertyCarpetArea} sq.ft'),
//           _buildDetailRow('Furnishing', furnishInfo.furnishType.toUpperCase()),
//           if (furnishInfo.furnishType == 'fully-furnished')
//             _buildDetailRow('Furnish Details', furnishInfo.furnishDetails?.other ?? 'N/A'),
//           _buildDetailRow('Parking', '${propertyDetails.parkingInfo.openParking ? "Open" : ""}${propertyDetails.parkingInfo.openParking && propertyDetails.parkingInfo.coveredParking ? " & " : ""}${propertyDetails.parkingInfo.coveredParking ? "Covered" : ""}'),
//           _buildDetailRow('Possession', propertyDetails.possessionInfo.possessionStatus),
//           _buildDetailRow('Property Age', '${propertyDetails.possessionInfo.propertyAgeInYears} years'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: AppFontSizes.caption,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.textColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
//     final amenities = lead.customFields.propertyDetails.amenities;
//
//     return Padding(
//       padding: EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Amenities', Icons.star_outline,true),
//           SizedBox(height: 16),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: amenities.map((amenity) {
//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Icon(Icons.check_circle, size: 14, color: ColorRes.primary),
//                     // SizedBox(width: 6),
//                     Text(
//                       amenity,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: ColorRes.primary.withOpacity(0.7),
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFinancialSection(BuildContext context, bool isCompact) {
//     final financialInfo = lead.customFields.propertyDetails.financialInfo;
//
//     return Padding(
//       padding: EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Financial Information', Icons.currency_rupee_outlined,true),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Property Price',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     Formatter.formatPrice(financialInfo.propertyPrice),
//                     style: TextStyle(
//                       fontSize: isCompact ? AppFontSizes.large : AppFontSizes.large,
//                       fontWeight: AppFontWeights.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//               if (financialInfo.negotiable)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(lead.status).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: _getStatusColor(lead.status),width: 1)
//                   ),
//                   child: Text(
//                     'Negotiable',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       color:_getStatusColor(lead.status),
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Divider(thickness: 1, color: Colors.grey[300]),
//           SizedBox(height: 10),
//           _buildDetailRow('Broker Commission', Formatter.formatPrice(financialInfo.brokerCommission)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusTimelineSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Lead Timeline', Icons.timeline_outlined,true),
//           SizedBox(height: 16),
//           _buildTimelineItem(
//             'Lead Created',
//             _formatDateTime(lead.createdAt),
//             Icons.add_circle_outline,
//             Colors.blue,
//             true,
//           ),
//           if (lead.lastContactedAt != null)
//             _buildTimelineItem(
//               'Last Contacted',
//               _formatDateTime(lead.lastContactedAt!),
//               Icons.phone_outlined,
//               Colors.orange,
//               false,
//             ),
//           _buildTimelineItem(
//             'Current Status',
//             _getStatusText(lead.status),
//             Icons.flag_outlined,
//             _getStatusColor(lead.status),
//             false,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem(
//       String title,
//       String subtitle,
//       IconData icon,
//       Color color,
//       bool isFirst,
//       ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 20, color: color),
//             ),
//             if (!isFirst)
//               Container(
//                 width: 2,
//                 height: 40,
//                 color: color.withOpacity(0.3),
//                 margin: EdgeInsets.symmetric(vertical: 4),
//               ),
//           ],
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(bottom: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textColor,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.small,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotesSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Notes', Icons.note_outlined,true),
//           SizedBox(height: 16),
//           Text(
//             lead.notes!,
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               color: Colors.grey[800],
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () => _launchPhone(lead.phone),
//               icon: Icon(Icons.phone),
//               label: Text(
//                 'Call',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () => _launchEmail(lead.email),
//               icon: Icon(Icons.email),
//               label: Text(
//                 'Email',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorRes.primary,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showMoreOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.share, color: Colors.blue),
//                 title: Text('Share Lead'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement share functionality
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.flag, color: Colors.orange),
//                 title: Text('Mark as Fake'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement mark as fake
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.delete, color: Colors.red),
//                 title: Text('Delete Lead'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement delete functionality
//                 },
//               ),
//               SizedBox(height: 8),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'new':
//         return Colors.blue;
//       case 'contacted':
//         return Colors.orange;
//       case 'qualified':
//         return Colors.purple;
//       case 'negotiating':
//         return Colors.indigo;
//       case 'sold':
//         return Colors.green;
//       case 'lost':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _getStatusText(String status) {
//     return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }
//
//   void _launchPhone(String phone) {
//     // Implement phone call functionality
//     // url_launcher package: launch('tel:$phone');
//   }
//
//   void _launchEmail(String email) {
//     // Implement email functionality
//     // url_launcher package: launch('mailto:$email');
//   }
// }

///====================================================Odl
///
///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/svg_res.dart';
// import 'package:housing_flutter_app/app/manager/icon_manager.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
//
// import '../../../../app/utils/svg_widget.dart';
// import '../../model/reseller_lead_model/reseller_lead_overview.dart';
//
// class LeadDetailScreen extends StatelessWidget {
//   final ResellerLeadOverview lead;
//
//   const LeadDetailScreen({Key? key, required this.lead}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isCompact = MediaQuery.of(context).size.width < 600;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading:  IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//
//             FocusScope.of(context).unfocus();
//            Get.back();
//
//
//           },
//
//         ),
//         title: Text(
//           'Lead Details',
//           style: TextStyle(
//             fontWeight: AppFontWeights.bold,
//             fontSize: AppFontSizes.large,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () => _showMoreOptions(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. Contact Information (Top Priority)
//             _buildContactSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 2. Property Image Gallery
//             _buildPropertyImageGallery(context),
//
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 4. Property Overview
//             _buildPropertyOverviewSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 5. Property Details
//             _buildPropertyDetailsSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 6. Amenities
//             _buildAmenitiesSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 3. Financial Information (High Priority - Moved Up)
//             _buildFinancialSection(context, isCompact),
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 7. Lead Status & Timeline
//             _buildStatusTimelineSection(context, isCompact),
//
//             // 8. Notes Section
//             if (lead.notes != null) ...[
//               Divider(thickness: 8, color: Colors.grey[100]),
//               _buildNotesSection(context, isCompact),
//             ],
//
//             Divider(thickness: 8, color: Colors.grey[100]),
//
//             // 9. Action Buttons
//             _buildActionButtons(context, isCompact),
//
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContactSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 8),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: isCompact ? 24 : 28,
//                 backgroundColor: ColorRes.primary.withOpacity(0.2),
//                 child: Text(
//                   lead.name.split(' ').map((e) => e[0]).join().toUpperCase(),
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontWeight: AppFontWeights.semiBold,
//                     fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       lead.name,
//                       style: TextStyle(
//                         fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Lead Source: ${lead.source.toUpperCase()}',
//                               style: TextStyle(
//                                 color: Colors.grey[700],
//                                 fontSize: AppFontSizes.extraSmall,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Property Type: ${lead.customFields.propertyType.toUpperCase()}',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.extraSmall,
//                                 color: Colors.grey[700],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           _buildContactRow(
//             Icons.email_outlined,
//             'Email',
//             lead.email,
//             Colors.blue,
//                 () => _launchEmail(lead.email),
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildContactRow(
//                   Icons.phone_outlined,
//                   'Phone',
//                   lead.phone,
//                   Colors.green,
//                       () => _launchPhone(lead.phone),
//                 ),
//               ),
//
//
//             ],
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactRow(
//       IconData icon,
//       String label,
//       String value,
//       Color color,
//       VoidCallback onTap,
//       ) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, size: 18, color: color),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: AppFontSizes.extraSmall,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       fontWeight: FontWeight.w500,
//                       color: ColorRes.textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPropertyImageGallery(BuildContext context) {
//     final dummyImages = [
//       'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
//       'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
//       'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
//     ];
//
//     return Container(
//       height: 280,
//       color: Colors.white,
//       child: Stack(
//         children: [
//           PageView.builder(
//             itemCount: dummyImages.length,
//             onPageChanged: (value) {},
//             itemBuilder: (context, index) {
//               return Image.network(
//                 dummyImages[index],
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.home, size: 80, color: Colors.grey[400]),
//                         SizedBox(height: 8),
//                         Text(
//                           lead.customFields.title,
//                           style: TextStyle(
//                             fontSize: AppFontSizes.large,
//                             fontWeight: AppFontWeights.bold,
//                             color: Colors.grey[600],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//
//             },
//
//           ),
//           // Image counter
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 '1/${dummyImages.length}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//             ),
//           ),
//
//           Positioned(
//             top: 16,
//             left: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                   color: _getStatusColor(lead.status),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: _getStatusColor(lead.status).withOpacity(0.3),width: 1)
//               ),
//               child: Text(
//                 _getStatusText(lead.status),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: AppFontSizes.extraSmall,
//                   fontWeight: AppFontWeights.semiBold,
//                 ),
//               ),
//             ),
//           ),
//           // Status Badge
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFinancialSection(BuildContext context, bool isCompact) {
//     final financialInfo = lead.customFields.propertyDetails.financialInfo;
//
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Financial Information', Icons.currency_rupee_outlined, isCompact),
//           SizedBox(height: 16),
//
//           // Price Display
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.green.shade200, width: 1),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Property Price',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.extraSmall,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           Formatter.formatPrice(financialInfo.propertyPrice),
//                           style: TextStyle(
//                             fontSize: isCompact ? AppFontSizes.large : 28,
//                             fontWeight: AppFontWeights.semiBold,
//                             color: Colors.green.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (financialInfo.negotiable)
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(lead.status).withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: _getStatusColor(lead.status).withOpacity(0.3), width: 1),
//                         ),
//                         child: Text(
//                           'Negotiable',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.extraSmall,
//                             color: _getStatusColor(lead.status),
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Divider(thickness: 1, color: Colors.grey[300]),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Broker Commission',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.small,
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       Formatter.formatPrice(financialInfo.brokerCommission),
//                       style: TextStyle(
//                         fontSize: isCompact ? AppFontSizes.large : 28,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
//     final customFields = lead.customFields;
//     final propertyDetails = customFields.propertyDetails;
//
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Property Overview', Icons.home_outlined, isCompact),
//           const SizedBox(height: 16),
//
//           // Title
//           Text(
//             customFields.title,
//             style: TextStyle(
//               fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.textColor,
//             ),
//           ),
//           const SizedBox(height: 6),
//
//           // Address
//           SizedBox(
//             width: 300,
//             child: Text(
//
//               '${customFields.address}, ${customFields.city}, ${customFields.state} - ${customFields.zipCode}',
//               style: TextStyle(
//                 fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
//                 color: Colors.grey[700],
//                 // height: 1.3,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Chips
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _buildOverviewChip(
//                 '${propertyDetails.bhk} BHK',
//                 Icons.bed_outlined,
//                 ColorRes.primary ,
//                 isCompact,
//               ),
//               _buildOverviewChip(
//                 customFields.propertyType.toUpperCase(),
//                 Icons.apartment_outlined,
//                 Colors.purple,
//                 isCompact,
//               ),
//               _buildOverviewChip(
//                 customFields.listingType,
//                 Icons.sell_outlined,
//                 Colors.orange,
//                 isCompact,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // Stats
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(
//                 '${propertyDetails.propertyCarpetArea}',
//                 'Carpet Area\n(sq.ft)',
//                 Icons.straighten,
//                 isCompact,
//               ),
//               Container(width: 1, height: 50, color: Colors.grey[300]),
//               _buildStatItem(
//                 '${propertyDetails.bathroom}',
//                 'Bathrooms',
//                 Icons.bathtub_outlined,
//                 isCompact,
//               ),
//               Container(width: 1, height: 50, color: Colors.grey[300]),
//               _buildStatItem(
//                 '${propertyDetails.balcony}',
//                 'Balconies',
//                 Icons.balcony_outlined,
//                 isCompact,
//               ),
//
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon, bool isCompact) {
//     return Row(
//       children: [
//         // Icon(icon, size: 20, color: ColorRes.primary),
//         // const SizedBox(width: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textColor,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildOverviewChip(String text, IconData icon, Color color, bool isCompact) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
//               color: color,
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatItem(String value, String label, IconData icon, bool isCompact) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: isCompact ? 18 : 22, color: ColorRes.primary.withOpacity(0.8)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: isCompact ? AppFontSizes.small : AppFontSizes.medium,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textColor,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
//             color: Colors.grey[700],
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
//     final propertyDetails = lead.customFields.propertyDetails;
//     final furnishInfo = propertyDetails.furnishInfo;
//
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Property Details', Icons.info_outline, true),
//           SizedBox(height: 16),
//           _buildDetailRow('Builder', lead.customFields.builderName),
//           _buildDetailRow('Project', lead.customFields.projectName),
//           _buildDetailRow('Property Type', lead.customFields.propertyType.toUpperCase()),
//           _buildDetailRow('Zone Type', propertyDetails.zoneType),
//           _buildDetailRow('Facing', propertyDetails.propertyFacing),
//           _buildDetailRow('Floor', '${propertyDetails.floorInfo.floorNumber} of ${propertyDetails.floorInfo.totalFloors}'),
//           _buildDetailRow('Built-up Area', '${propertyDetails.propertyBuiltUpArea} sq.ft'),
//           _buildDetailRow('Carpet Area', '${propertyDetails.propertyCarpetArea} sq.ft'),
//           _buildDetailRow('Furnishing', furnishInfo.furnishType.toUpperCase()),
//           if (furnishInfo.furnishType == 'fully-furnished')
//             _buildDetailRow('Bed', furnishInfo.furnishDetails.bed.toString() ?? 'N/A'),
//           _buildDetailRow('Fan', furnishInfo.furnishDetails.fan.toString() ?? 'N/A'),
//             _buildDetailRow('Furnish Details', furnishInfo.furnishDetails?.other ?? 'N/A'),
//
//           _buildDetailRow('Parking', '${propertyDetails.parkingInfo.openParking ? "Open" : ""}${propertyDetails.parkingInfo.openParking && propertyDetails.parkingInfo.coveredParking ? " & " : ""}${propertyDetails.parkingInfo.coveredParking ? "Covered" : ""}'),
//           _buildDetailRow('Possession', propertyDetails.possessionInfo.possessionStatus),
//           _buildDetailRow('Property Age', '${propertyDetails.possessionInfo.propertyAgeInYears} years'),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: AppFontSizes.caption,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.textColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
//   //   final amenities = lead.customFields.propertyDetails.amenities;
//   //   final item =IconManager.allAmenities;
//   //
//   //   return Padding(
//   //     padding: EdgeInsets.all(12),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         _buildSectionHeader('Amenities', Icons.star_outline, true),
//   //         SizedBox(height: 16),
//   //         Wrap(
//   //           spacing: 8,
//   //           runSpacing: 8,
//   //           children: amenities.map((amenity) {
//   //             return Container(
//   //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   //               decoration: BoxDecoration(
//   //                 color: ColorRes.primary.withOpacity(0.1),
//   //                 borderRadius: BorderRadius.circular(8),
//   //                 border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
//   //               ),
//   //               child: Row(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 children: [
//   //                   Text(
//   //                     amenity,
//   //                     style: TextStyle(
//   //                       fontSize: AppFontSizes.small,
//   //                       color: ColorRes.primary.withOpacity(0.7),
//   //                       fontWeight: AppFontWeights.medium,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             );
//   //           }).toList(),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
//     final amenities = lead.customFields.propertyDetails.amenities;
//
//     return Padding(
//       padding: EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Amenities', Icons.star_outline, true),
//           SizedBox(height: 16),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: amenities.map((amenity) {
//               // Find matching icon item
//
//               final matchedItem = IconManager.allAmenities.firstWhere(
//                     (item) => item.title.toLowerCase() == amenity.toLowerCase(),
//                 orElse: () => IconItem(
//                   key: '',
//                   title: amenity,
//                   icon: Icons.help_outline,
//                 ),
//               );
//
//               final hasIcon = matchedItem.key.isNotEmpty;
//
//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (hasIcon) ...[
//                       AppSvgIcon(
//                         assetName: matchedItem.key,
//                         size: 16,
//                         color: ColorRes.primary,
//                         folder: 'amenities',
//                       ),
//                       SizedBox(width: 6),
//                     ],
//                     Text(
//                       amenity,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.extraSmall,
//                         color: ColorRes.primary,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusTimelineSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Lead Timeline', Icons.timeline_outlined, true),
//           SizedBox(height: 16),
//           _buildTimelineItem(
//             'Lead Created',
//             _formatDateTime(lead.createdAt),
//             Icons.add_circle_outline,
//             Colors.blue,
//             true,
//           ),
//           if (lead.lastContactedAt != null)
//             _buildTimelineItem(
//               'Last Contacted',
//               _formatDateTime(lead.lastContactedAt!),
//               Icons.phone_outlined,
//               Colors.orange,
//               false,
//             ),
//           _buildTimelineItem(
//             'Current Status',
//             _getStatusText(lead.status),
//             Icons.flag_outlined,
//             _getStatusColor(lead.status),
//             false,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem(
//       String title,
//       String subtitle,
//       IconData icon,
//       Color color,
//       bool isFirst,
//       ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 20, color: color),
//             ),
//             if (!isFirst)
//               Container(
//                 width: 2,
//                 height: 40,
//                 color: color.withOpacity(0.3),
//                 margin: EdgeInsets.symmetric(vertical: 4),
//               ),
//           ],
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(bottom: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textColor,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.small,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNotesSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('Notes', Icons.note_outlined, true),
//           SizedBox(height: 16),
//           Text(
//             lead.notes!,
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               color: Colors.grey[800],
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () => _launchPhone(lead.phone),
//               icon: Icon(Icons.phone),
//               label: Text(
//                 'Call',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () => _launchEmail(lead.email),
//               icon: Icon(Icons.email),
//               label: Text(
//                 'Email',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorRes.primary,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showMoreOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.share, color: Colors.blue),
//                 title: Text('Share Lead'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement share functionality
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.flag, color: Colors.orange),
//                 title: Text('Mark as Fake'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement mark as fake
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.delete, color: Colors.red),
//                 title: Text('Delete Lead'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement delete functionality
//                 },
//               ),
//               SizedBox(height: 8),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'new':
//         return Colors.blue;
//       case 'contacted':
//         return Colors.orange;
//       case 'qualified':
//         return Colors.purple;
//       case 'negotiating':
//         return Colors.indigo;
//       case 'sold':
//         return Colors.green;
//       case 'lost':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String _getStatusText(String status) {
//     return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }
//
//   void _launchPhone(String phone) {
//     // Implement phone call functionality
//     // url_launcher package: launch('tel:$phone');
//   }
//
//   void _launchEmail(String email) {
//     // Implement email functionality
//     // url_launcher package: launch('mailto:$email');
//   }
// }

///======================================
///
///
///
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/svg_res.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

import '../../../../app/utils/svg_widget.dart';
import '../../controller/dashborad_controller/dashboard_controller.dart';
import '../../model/reseller_lead_model/reseller_lead_overview.dart';
import '../report/report_screen.dart';

class LeadDetailScreen extends StatelessWidget {
  final ResellerLeadOverview lead;
  final bool isFromLead;

  LeadDetailScreen({Key? key, required this.lead, this.isFromLead = false})
    : super(key: key);

  // Initialize controller
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
        ),
        title: Text(
          '${(isFromLead)?'Lead Details':'Property Overview'}',
          style: TextStyle(
            fontWeight: AppFontWeights.bold,
            fontSize: AppFontSizes.large,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Contact Information (Always Visible)
            if (isFromLead) ...[
              _buildContactSection(context, isCompact),

              Divider(thickness: 8, color: Colors.grey[100]),
            ],

            // 2. Property Image Gallery (Always Visible)
            _buildPropertyImageGallery(context),

            Divider(thickness: 8, color: Colors.grey[100]),

            // 3. Property Overview (Always Visible)
            _buildPropertyOverviewSection(context, isCompact),

            // Expand/Collapse Button

            // Conditional Sections (Show when expanded)
            Obx(
              () =>
                  controller.isResellerDetailExpanded.value
                      ? Column(
                        children: [
                          Divider(thickness: 8, color: Colors.grey[100]),

                          // 4. Property Details
                          _buildPropertyDetailsSection(context, isCompact),

                          Divider(thickness: 8, color: Colors.grey[100]),

                          // 5. Amenities
                          _buildAmenitiesSection(context, isCompact),

                          Obx(() => _buildExpandButton(context)),
                        ],
                      )
                      : Obx(() => _buildExpandButton(context)),
            ),
            Divider(thickness: 8, color: Colors.grey[100]),

            // 6. Financial Information
            _buildFinancialSection(context, isCompact),

            if (isFromLead) ...[
              Divider(thickness: 8, color: Colors.grey[100]),

              // 7. Lead Status & Timeline
              _buildStatusTimelineSection(context, isCompact),
            ],

            Divider(thickness: 8, color: Colors.grey[100]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PropertyOverviewCard(lead: lead),
            ),

            Divider(thickness: 8, color: Colors.grey[100]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:
              16,vertical:8 ),
              child: _buildSectionHeader('Report', Icons.report_gmailerrorred_outlined, isCompact),
            ),
            const ReportPropertyCard(),


            // 8. Notes Section
            if (lead.notes != null) ...[
              Divider(thickness: 8, color: Colors.grey[100]),
              _buildNotesSection(context, isCompact),
            ],

            Divider(thickness: 8, color: Colors.grey[100]),

            // 9. Action Buttons
            _buildActionButtons(context, isCompact),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return InkWell(
      onTap: () => controller.toggleExpanded(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   controller.isResellerDetailExpanded.value
            //       ? Icons.expand_less
            //       : Icons.expand_more,
            //   color: ColorRes.primary,
            //   size: 24,
            // ),
            // SizedBox(width: 8),
            Text(
              controller.isResellerDetailExpanded.value
                  ? 'Hide Additional Details'
                  : 'Show Additional Details',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: isCompact ? 24 : 28,
                backgroundColor: ColorRes.primary.withOpacity(0.2),
                child: Text(
                  lead.name.split(' ').map((e) => e[0]).join().toUpperCase(),
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.semiBold,
                    fontSize:
                        isCompact ? AppFontSizes.medium : AppFontSizes.large,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name,
                      style: TextStyle(
                        fontSize:
                            isCompact ? AppFontSizes.body : AppFontSizes.large,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Lead Source: ${lead.source.toUpperCase()}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: AppFontSizes.extraSmall,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Property Type: ${lead.customFields.propertyType.toUpperCase()}',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildContactRow(
            Icons.email_outlined,
            'Email',
            lead.email,
            Colors.blue,
            () => _launchEmail(lead.email),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildContactRow(
                  Icons.phone_outlined,
                  'Phone',
                  lead.phone,
                  Colors.green,
                  () => _launchPhone(lead.phone),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppFontSizes.extraSmall,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImageGallery(BuildContext context) {
    final dummyImages = [
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
      'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
      'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
    ];

    return Container(
      height: 280,
      color: Colors.white,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: dummyImages.length,
            onPageChanged: (value) {},
            itemBuilder: (context, index) {
              return Image.network(
                dummyImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, size: 80, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          lead.customFields.title,
                          style: TextStyle(
                            fontSize: AppFontSizes.large,
                            fontWeight: AppFontWeights.bold,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '1/${dummyImages.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(lead.status),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(lead.status).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(lead.status),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.extraSmall,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyOverviewSection(BuildContext context, bool isCompact) {
    final customFields = lead.customFields;
    final propertyDetails = customFields.propertyDetails;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Property Overview',
            Icons.home_outlined,
            isCompact,
          ),
          const SizedBox(height: 16),
          Text(
            customFields.title,
            style: TextStyle(
              fontSize: isCompact ? AppFontSizes.medium : AppFontSizes.large,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 300,
            child: Text(
              '${customFields.address}, ${customFields.city}, ${customFields.state} - ${customFields.zipCode}',
              style: TextStyle(
                fontSize:
                    isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildOverviewChip(
                '${propertyDetails.bhk} BHK',
                Icons.bed_outlined,
                ColorRes.primary,
                isCompact,
              ),
              _buildOverviewChip(
                customFields.propertyType.toUpperCase(),
                Icons.apartment_outlined,
                Colors.purple,
                isCompact,
              ),
              _buildOverviewChip(
                customFields.listingType,
                Icons.sell_outlined,
                Colors.orange,
                isCompact,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '${propertyDetails.propertyCarpetArea}',
                'Carpet Area\n(sq.ft)',
                Icons.straighten,
                isCompact,
              ),
              Container(width: 1, height: 50, color: Colors.grey[300]),
              _buildStatItem(
                '${propertyDetails.bathroom}',
                'Bathrooms',
                Icons.bathtub_outlined,
                isCompact,
              ),
              Container(width: 1, height: 50, color: Colors.grey[300]),
              _buildStatItem(
                '${propertyDetails.balcony}',
                'Balconies',
                Icons.balcony_outlined,
                isCompact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isCompact) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.body : AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewChip(
    String text,
    IconData icon,
    Color color,
    bool isCompact,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize:
                  isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
              color: color,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    bool isCompact,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isCompact ? 18 : 22,
          color: ColorRes.primary.withOpacity(0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.small : AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //
  // Widget _buildFinancialSection(BuildContext context, bool isCompact) {
  //   final financialInfo = lead.customFields.propertyDetails.financialInfo;
  //
  //   return Padding(
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildSectionHeader('Financial Information', Icons.currency_rupee_outlined, isCompact),
  //         SizedBox(height: 16),
  //         Container(
  //           padding: EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: Colors.green.shade200, width: 1),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Property Price',
  //                         style: TextStyle(
  //                           fontSize: AppFontSizes.extraSmall,
  //                           fontWeight: FontWeight.w500,
  //                           color: Colors.grey[700],
  //                         ),
  //                       ),
  //                       SizedBox(height: 4),
  //                       Text(
  //                         Formatter.formatPrice(financialInfo.propertyPrice),
  //                         style: TextStyle(
  //                           fontSize: isCompact ? AppFontSizes.large : 28,
  //                           fontWeight: AppFontWeights.semiBold,
  //                           color: Colors.green.shade700,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   if (financialInfo.negotiable)
  //                     Container(
  //                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                       decoration: BoxDecoration(
  //                         color: _getStatusColor(lead.status).withOpacity(0.08),
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(color: _getStatusColor(lead.status).withOpacity(0.3), width: 1),
  //                       ),
  //                       child: Text(
  //                         'Negotiable',
  //                         style: TextStyle(
  //                           fontSize: AppFontSizes.extraSmall,
  //                           color: _getStatusColor(lead.status),
  //                           fontWeight: AppFontWeights.semiBold,
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //               SizedBox(height: 10),
  //               Divider(thickness: 1, color: Colors.grey[300]),
  //               SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     'Broker Commission',
  //                     style: TextStyle(
  //                       fontSize: AppFontSizes.small,
  //                       color: Colors.grey[700],
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   Text(
  //                     Formatter.formatPrice(financialInfo.brokerCommission),
  //                     style: TextStyle(
  //                       fontSize: isCompact ? AppFontSizes.large : 28,
  //                       fontWeight: AppFontWeights.semiBold,
  //                       color: ColorRes.primary,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPropertyDetailsSection(BuildContext context, bool isCompact) {
    final propertyDetails = lead.customFields.propertyDetails;
    final furnishInfo = propertyDetails.furnishInfo;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Property Details', Icons.info_outline, true),
          SizedBox(height: 16),
          _buildDetailRow('Builder', lead.customFields.builderName),
          _buildDetailRow('Project', lead.customFields.projectName),
          _buildDetailRow(
            'Property Type',
            lead.customFields.propertyType.toUpperCase(),
          ),
          _buildDetailRow('Zone Type', propertyDetails.zoneType),
          _buildDetailRow('Facing', propertyDetails.propertyFacing),
          _buildDetailRow(
            'Floor',
            '${propertyDetails.floorInfo.floorNumber} of ${propertyDetails.floorInfo.totalFloors}',
          ),
          _buildDetailRow(
            'Built-up Area',
            '${propertyDetails.propertyBuiltUpArea} sq.ft',
          ),
          _buildDetailRow(
            'Carpet Area',
            '${propertyDetails.propertyCarpetArea} sq.ft',
          ),
          _buildDetailRow('Furnishing', furnishInfo.furnishType.toUpperCase()),
          if (furnishInfo.furnishType == 'fully-furnished')
            _buildDetailRow('Bed', furnishInfo.furnishDetails.bed.toString()),
          _buildDetailRow('Fan', furnishInfo.furnishDetails.fan.toString()),
          _buildDetailRow(
            'Furnish Details',
            furnishInfo.furnishDetails?.other ?? 'N/A',
          ),
          _buildDetailRow(
            'Parking',
            '${propertyDetails.parkingInfo.openParking ? "Open" : ""}${propertyDetails.parkingInfo.openParking && propertyDetails.parkingInfo.coveredParking ? " & " : ""}${propertyDetails.parkingInfo.coveredParking ? "Covered" : ""}',
          ),
          _buildDetailRow(
            'Possession',
            propertyDetails.possessionInfo.possessionStatus,
          ),
          _buildDetailRow(
            'Property Age',
            '${propertyDetails.possessionInfo.propertyAgeInYears} years',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(BuildContext context, bool isCompact) {
    final amenities = lead.customFields.propertyDetails.amenities;

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Amenities', Icons.star_outline, true),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities.map((amenity) {
                  final matchedItem = IconManager.allAmenities.firstWhere(
                    (item) => item.title.toLowerCase() == amenity.toLowerCase(),
                    orElse:
                        () => IconItem(
                          key: '',
                          title: amenity,
                          icon: Icons.help_outline,
                        ),
                  );

                  final hasIcon = matchedItem.key.isNotEmpty;

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasIcon) ...[
                          AppSvgIcon(
                            assetName: matchedItem.key,
                            size: 16,
                            color: ColorRes.primary,
                            folder: 'amenities',
                          ),
                          SizedBox(width: 6),
                        ],
                        Text(
                          amenity,
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  //
  // Widget _buildStatusTimelineSection(BuildContext context, bool isCompact) {
  //   return Padding(
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildSectionHeader('Lead Timeline', Icons.timeline_outlined, true),
  //         SizedBox(height: 16),
  //         _buildTimelineItem(
  //           'Lead Created',
  //           _formatDateTime(lead.createdAt),
  //           Icons.add_circle_outline,
  //           Colors.blue,
  //           true,
  //         ),
  //         if (lead.lastContactedAt != null)
  //           _buildTimelineItem(
  //             'Last Contacted',
  //             _formatDateTime(lead.lastContactedAt!),
  //             Icons.phone_outlined,
  //             Colors.orange,
  //             false,
  //           ),
  //         _buildTimelineItem(
  //           'Current Status',
  //           _getStatusText(lead.status),
  //           Icons.flag_outlined,
  //           _getStatusColor(lead.status),
  //           false,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildTimelineItem(
  //     String title,
  //     String subtitle,
  //     IconData icon,
  //     Color color,
  //     bool isFirst,
  //     ) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Column(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(0.2),
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(icon, size: 20, color: color),
  //           ),
  //           if (!isFirst)
  //             Container(
  //               width: 2,
  //               height: 40,
  //               color: color.withOpacity(0.3),
  //               margin: EdgeInsets.symmetric(vertical: 4),
  //             ),
  //         ],
  //       ),
  //       SizedBox(width: 16),
  //       Expanded(
  //         child: Padding(
  //           padding: EdgeInsets.only(bottom: 16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   fontSize: AppFontSizes.medium,
  //                   fontWeight: AppFontWeights.semiBold,
  //                   color: ColorRes.textColor,
  //                 ),
  //               ),
  //               SizedBox(height: 4),
  //               Text(
  //                 subtitle,
  //                 style: TextStyle(
  //                   fontSize: AppFontSizes.small,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFinancialSection(BuildContext context, bool isCompact) {
    final financialInfo = lead.customFields.propertyDetails.financialInfo;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Financial Information',
            Icons.currency_rupee_outlined,
            isCompact,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Price Section (static - no Obx needed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Property Price',
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            Formatter.formatPrice(financialInfo.propertyPrice),
                            style: TextStyle(
                              fontSize: isCompact ? AppFontSizes.large : 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (financialInfo.negotiable)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(lead.status).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _getStatusColor(
                              lead.status,
                            ).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Negotiable',
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: _getStatusColor(lead.status),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16),
                Divider(thickness: 0.65, color: ColorRes.grey.withOpacity(0.4)),
                SizedBox(height: 16),

                // Broker Commission Section (static - no Obx needed)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorRes.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 20,
                              color: ColorRes.primary,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Broker Commission',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        Formatter.formatPrice(financialInfo.brokerCommission),
                        style: TextStyle(
                          fontSize:
                              isCompact
                                  ? AppFontSizes.medium
                                  : AppFontSizes.large,
                          fontWeight: FontWeight.w600,
                          color: ColorRes.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // WRAP REACTIVE SECTION WITH OBX
                Obx(() {
                  final hasOffer = controller.submittedOfferAmount.value != 0.0;

                  return Column(
                    children: [
                      // Submitted Offer Section
                      if (hasOffer) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            //   colors: [
                            //     Colors.orange.shade50,
                            //     Colors.orange.shade100.withOpacity(0.5),
                            //   ],
                            // ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.handshake_rounded,
                                          size: 20,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          'Negotiable Price',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.small,
                                            // color: ColorRes.textColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatter.formatPrice(
                                      controller.submittedOfferAmount.value,
                                    ),
                                    style: TextStyle(
                                      fontSize:
                                          isCompact
                                              ? AppFontSizes.medium
                                              : AppFontSizes.large,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pending_outlined,
                                      size: 14,
                                      color: Colors.orange.shade700,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Pending Review',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.extraSmall,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Negotiation Button
                      if (financialInfo.negotiable) ...[
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                !hasOffer
                                    ? () => _handleNegotiation(context)
                                    : null,
                            icon: Icon(
                              !hasOffer
                                  ? Icons.chat_bubble_outline
                                  : Icons.check_circle_outline,
                              size: 18,
                            ),
                            label: Text(
                              !hasOffer
                                  ? 'Start Negotiation'
                                  : 'Offer Submitted',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !hasOffer
                                      ? Colors.green.shade600
                                      : Colors.grey.shade400,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              shadowColor: Colors.green.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimelineSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Lead Timeline', Icons.timeline_outlined, true),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Column(
              children: [
                _buildTimelineItem(
                  'Lead Created',
                  _formatDateTime(lead.createdAt),
                  Icons.add_circle_outline,
                  Colors.blue,
                  true,
                  false,
                ),
                if (lead.lastContactedAt != null)
                  _buildTimelineItem(
                    'Last Contacted',
                    _formatDateTime(lead.lastContactedAt!),
                    Icons.phone_outlined,
                    Colors.orange,
                    false,
                    false,
                  ),
                _buildTimelineItem(
                  'Current Status',
                  _getStatusText(lead.status),
                  Icons.flag_outlined,
                  _getStatusColor(lead.status),
                  false,
                  true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isFirst,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2.5),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withOpacity(0.6), color.withOpacity(0.4)],
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: ColorRes.textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Negotiation handler method
  // void _handleNegotiation(BuildContext context) {
  //   final offerController = TextEditingController();
  //   final messageController = TextEditingController();
  //   final formKey = GlobalKey<FormState>();
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     enableDrag: true,
  //     builder:
  //         (context) => Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //           ),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Drag Handle
  //                 Container(
  //                   margin: EdgeInsets.only(top: 12, bottom: 8),
  //                   width: 40,
  //                   height: 4,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey.shade300,
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //
  //                 Flexible(
  //                   child: SingleChildScrollView(
  //                     padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
  //                     child: Form(
  //                       key: formKey,
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           // Header Section
  //                           Container(
  //                             padding: EdgeInsets.all(16),
  //                             decoration: BoxDecoration(
  //                               gradient: LinearGradient(
  //                                 colors: [
  //                                   Colors.green.shade50,
  //                                   Colors.green.shade100.withOpacity(0.5),
  //                                 ],
  //                               ),
  //                               borderRadius: BorderRadius.circular(16),
  //                             ),
  //                             child: Row(
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.all(14),
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     shape: BoxShape.circle,
  //                                     border: Border.all(
  //                                       color: ColorRes.green,
  //                                       width: 1,
  //                                     ),
  //                                   ),
  //                                   child: Icon(
  //                                     Icons.handshake_rounded,
  //                                     color: Colors.green.shade700,
  //                                     size: 25,
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 16),
  //                                 Expanded(
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         'Negotiate Price',
  //                                         style: TextStyle(
  //                                           fontSize: 18,
  //                                           fontWeight: FontWeight.bold,
  //                                           color: Colors.grey[900],
  //                                           // letterSpacing: 0.5,
  //                                         ),
  //                                       ),
  //                                       SizedBox(height: 4),
  //                                       Text(
  //                                         'Make your best offer',
  //                                         style: TextStyle(
  //                                           fontSize: AppFontSizes.caption,
  //                                           color: Colors.grey[600],
  //                                           fontWeight: FontWeight.w500,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //
  //                           SizedBox(height: 24),
  //
  //                           // Current Price Info
  //                           Container(
  //                             padding: EdgeInsets.all(14),
  //                             decoration: BoxDecoration(
  //                               color: Colors.blue.shade50,
  //                               borderRadius: BorderRadius.circular(12),
  //                               border: Border.all(color: Colors.blue.shade100),
  //                             ),
  //                             child: Row(
  //                               children: [
  //                                 Icon(
  //                                   Icons.info_outline,
  //                                   color: Colors.blue.shade700,
  //                                   size: 20,
  //                                 ),
  //                                 SizedBox(width: 12),
  //                                 Expanded(
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         'Current Asking Price',
  //                                         style: TextStyle(
  //                                           fontSize: AppFontSizes.extraSmall,
  //                                           color: Colors.blue.shade700,
  //                                           fontWeight: FontWeight.w600,
  //                                         ),
  //                                       ),
  //                                       SizedBox(height: 2),
  //                                       Text(
  //                                         Formatter.formatPrice(
  //                                           lead
  //                                               .customFields
  //                                               .propertyDetails
  //                                               .financialInfo
  //                                               .propertyPrice,
  //                                         ),
  //                                         style: TextStyle(
  //                                           fontSize: AppFontSizes.medium,
  //                                           fontWeight: FontWeight.bold,
  //                                           color: Colors.blue.shade900,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //
  //                           SizedBox(height: 24),
  //
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Your Offer Amount *',
  //                                 style: TextStyle(
  //                                   fontSize: AppFontSizes.small,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.grey[800],
  //                                 ),
  //                               ),
  //                               SizedBox(height: 8),
  //                               TextFormField(
  //                                 controller: offerController,
  //                                 keyboardType: TextInputType.number,
  //                                 validator: (value) {
  //                                   if (value == null || value.isEmpty) {
  //                                     return 'Please enter your offer amount';
  //                                   }
  //                                   if (double.tryParse(value) == null) {
  //                                     return 'Please enter a valid amount';
  //                                   }
  //                                   return null;
  //                                 },
  //                                 decoration: InputDecoration(
  //                                   hintText: 'Enter amount',
  //                                   hintStyle: TextStyle(
  //                                     fontSize: 14,
  //                                     color: Colors.grey[400],
  //                                   ),
  //                                   prefixIcon: Icon(
  //                                     Icons.currency_rupee,
  //                                     color: Colors.green.shade700,
  //                                     size: 22,
  //                                   ),
  //                                   border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: Colors.grey.shade300,
  //                                     ),
  //                                   ),
  //                                   enabledBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: Colors.grey.shade300,
  //                                     ),
  //                                   ),
  //                                   focusedBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: ColorRes.primary,
  //                                       width: 1,
  //                                     ),
  //                                   ),
  //                                   errorBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: Colors.red.shade300,
  //                                     ),
  //                                   ),
  //                                   filled: true,
  //                                   fillColor: Colors.white,
  //                                   contentPadding: EdgeInsets.symmetric(
  //                                     horizontal: 16,
  //                                     vertical: 16,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //
  //                           SizedBox(height: 20),
  //
  //                           // Message Field
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Message (Optional)',
  //                                 style: TextStyle(
  //                                   fontSize: AppFontSizes.small,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.grey[800],
  //                                 ),
  //                               ),
  //                               SizedBox(height: 8),
  //                               TextFormField(
  //                                 controller: messageController,
  //                                 minLines: 1,
  //                                 maxLines: 3,
  //                                 decoration: InputDecoration(
  //                                   hintText: 'Add a message...',
  //                                   hintStyle: TextStyle(
  //                                     fontSize: 14,
  //                                     color: Colors.grey[400],
  //                                   ),
  //                                   prefixIcon: Icon(
  //                                     Icons.message_outlined,
  //                                     color: Colors.orange.shade700,
  //                                     size: 22,
  //                                   ),
  //                                   border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: Colors.grey.shade300,
  //                                     ),
  //                                   ),
  //                                   enabledBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: Colors.grey.shade300,
  //                                     ),
  //                                   ),
  //                                   focusedBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     borderSide: BorderSide(
  //                                       color: ColorRes.primary,
  //                                       width: 2,
  //                                     ),
  //                                   ),
  //                                   filled: true,
  //                                   fillColor: Colors.white,
  //                                   contentPadding: EdgeInsets.symmetric(
  //                                     horizontal: 16,
  //                                     vertical: 16,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //
  //                           SizedBox(height: 28),
  //
  //                           // Action Buttons
  //                           SafeArea(
  //                             child: Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: OutlinedButton(
  //                                     onPressed: () {
  //                                       offerController.clear();
  //                                       messageController.clear();
  //                                       Navigator.pop(context);
  //                                     },
  //                                     child: Text(
  //                                       'Cancel',
  //                                       style: TextStyle(
  //                                         fontSize: AppFontSizes.medium,
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     style: OutlinedButton.styleFrom(
  //                                       foregroundColor: Colors.grey[700],
  //                                       side: BorderSide(
  //                                         color: Colors.grey.shade400,
  //                                         width: 1.5,
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(
  //                                         vertical: 14,
  //                                       ),
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(
  //                                           14,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 12),
  //                                 Expanded(
  //                                   child: ElevatedButton.icon(
  //                                     onPressed: () {
  //                                       if (formKey.currentState!.validate()) {
  //                                         // Handle negotiation submission
  //                                         final offerAmount =
  //                                             offerController.text;
  //                                         final message =
  //                                             messageController.text;
  //
  //                                         offerController.clear();
  //                                         messageController.clear();
  //                                         Navigator.pop(context);
  //
  //                                         ScaffoldMessenger.of(
  //                                           context,
  //                                         ).showSnackBar(
  //                                           SnackBar(
  //                                             content: Row(
  //                                               children: [
  //                                                 Icon(
  //                                                   Icons.check_circle,
  //                                                   color: Colors.white,
  //                                                 ),
  //                                                 SizedBox(width: 12),
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     'Offer submitted successfully!',
  //                                                     style: TextStyle(
  //                                                       fontWeight:
  //                                                           FontWeight.w600,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             backgroundColor: ColorRes.primary,
  //                                             behavior:
  //                                                 SnackBarBehavior.floating,
  //                                             shape: RoundedRectangleBorder(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(12),
  //                                             ),
  //                                             duration: Duration(seconds: 3),
  //                                           ),
  //                                         );
  //                                       }
  //                                     },
  //
  //                                     label: Text(
  //                                       'Submit Offer',
  //                                       style: TextStyle(
  //                                         fontSize: AppFontSizes.medium,
  //                                         fontWeight: FontWeight.bold,
  //                                         letterSpacing: 0.3,
  //                                       ),
  //                                     ),
  //                                     style: ElevatedButton.styleFrom(
  //                                       backgroundColor: ColorRes.primary,
  //                                       foregroundColor: Colors.white,
  //                                       padding: EdgeInsets.symmetric(
  //                                         vertical: 14,
  //                                       ),
  //                                       elevation: 0,
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(
  //                                           14,
  //                                         ),
  //                                       ),
  //                                       shadowColor: Colors.green.withOpacity(
  //                                         0.3,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //     // ).whenComplete(() {
  //     //   offerController.dispose();
  //     //   messageController.dispose();
  //     // });
  //   );
  // }
  void _handleNegotiation(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade50,
                                    Colors.green.shade100.withOpacity(0.5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ColorRes.green,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.handshake_rounded,
                                      color: Colors.green.shade700,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Negotiate Price',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Make your best offer',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.caption,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24),

                            // Current Price Info
                            Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue.shade700,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Asking Price',
                                          style: TextStyle(
                                            fontSize: AppFontSizes.extraSmall,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          Formatter.formatPrice(
                                            lead
                                                .customFields
                                                .propertyDetails
                                                .financialInfo
                                                .propertyPrice,
                                          ),
                                          style: TextStyle(
                                            fontSize: AppFontSizes.medium,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Offer Amount *',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.offerController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your offer amount';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid amount';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter amount',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                    prefixIcon: Icon(
                                      Icons.currency_rupee,
                                      color: Colors.green.shade700,
                                      size: 22,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: ColorRes.primary,
                                        width: 1,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.red.shade300,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Message Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Message (Optional)',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.messageController,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Add a message...',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                    prefixIcon: Icon(
                                      Icons.message_outlined,
                                      color: Colors.orange.shade700,
                                      size: 22,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: ColorRes.primary,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 28),

                            // Action Buttons
                            SafeArea(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        controller.offerController.clear();
                                        controller.messageController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.medium,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey[700],
                                        side: BorderSide(
                                          color: Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          // Store the offer amount
                                          final offerAmount = double.parse(
                                            controller.offerController.text,
                                          );
                                          final message =
                                              controller.messageController.text;

                                          // Update the state to display the offer

                                          controller
                                              .submittedOfferAmount
                                              .value = offerAmount;

                                          controller.offerController.clear();
                                          controller.messageController.clear();
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      'Offer submitted successfully!',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: ColorRes.primary,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      },
                                      label: Text(
                                        'Submit Offer',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.medium,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorRes.primary,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        shadowColor: Colors.green.withOpacity(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }

  Widget _buildNotesSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Notes', Icons.note_outlined, true),
          SizedBox(height: 16),
          Text(
            lead.notes!,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isCompact) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchPhone(lead.phone),
                icon: Icon(Icons.phone),
                label: Text(
                  'Call',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchEmail(lead.email),
                icon: Icon(Icons.email),
                label: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.blue),
                title: Text('Share Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.flag, color: Colors.orange),
                title: Text('Mark as Fake'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement mark as fake
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Lead'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement delete functionality
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'contacted':
        return Colors.orange;
      case 'qualified':
        return Colors.purple;
      case 'negotiating':
        return Colors.indigo;
      case 'sold':
        return Colors.green;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _launchPhone(String phone) {
    // Implement phone call functionality
    // url_launcher package: launch('tel:$phone');
  }

  void _launchEmail(String email) {
    // Implement email functionality
    // url_launcher package: launch('mailto:$email');
  }
}
