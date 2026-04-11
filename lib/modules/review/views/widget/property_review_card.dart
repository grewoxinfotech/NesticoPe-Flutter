// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/data/network/review/model/review_model.dart';
// import 'package:nesticope_app/modules/contractor/controller/contractor_lead_controller.dart';
// import 'package:nesticope_app/modules/review/controllers/review_controller.dart';
// import 'package:nesticope_app/modules/user/controllers/user_controller.dart';

// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../app/constants/img_res.dart';
// import '../../../../app/constants/size_manager.dart';
// import '../../../../app/widgets/image/custom_image.dart' hide ColorRes;
// import '../../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';

// // class PropertyReviewCard extends StatefulWidget {
// //   final ReviewItem reviewItem;
// //   const PropertyReviewCard({super.key, required this.reviewItem});
// //
// //   @override
// //   State<PropertyReviewCard> createState() => _PropertyReviewCardState();
// // }
// //
// // class _PropertyReviewCardState extends State<PropertyReviewCard> {
// //   late final UserController userController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
// //
// //     Get.put(UserController(), tag: tag);
// //     userController = Get.find<UserController>(tag: tag);
// //
// //     userController.fetchUserById(widget.reviewItem.createdBy ?? "");
// //   }
// //
// //   @override
// //   void dispose() {
// //     // Clean up: Delete the controller when this card is disposed
// //     final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
// //     Get.delete<UserController>(tag: tag);
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: 300,
// //       margin: const EdgeInsets.symmetric(vertical: 10),
// //       decoration: BoxDecoration(
// //         color: ColorRes.white,
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
// //         boxShadow: [
// //           BoxShadow(
// //             color: ColorRes.leadGreyColor.shade200.withOpacity(0.2),
// //             blurRadius: 6,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             /// HEADER — Avatar + Reviewer Info
// //             Row(
// //               children: [
// //                 _buildAvatar(),
// //                 const SizedBox(width: 12),
// //                 Expanded(child: _buildReviewerInfo()),
// //               ],
// //             ),
// //
// //             const SizedBox(height: 16),
// //
// //             /// RATING
// //             _buildRatingRow(),
// //
// //             const SizedBox(height: 16),
// //
// //             /// REVIEW CONTENT
// //             Text(
// //               '"${widget.reviewItem.content}"',
// //               style: TextStyle(
// //                 fontSize: AppFontSizes.medium,
// //                 color: ColorRes.leadGreyColor.shade700,
// //                 height: 1.5,
// //                 fontStyle: FontStyle.italic,
// //               ),
// //               maxLines: 4,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //
// //             const SizedBox(height: 16),
// //             const Spacer(),
// //
// //             /// FOOTER — Property Type & Date
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 if (widget.reviewItem.entityType!.isNotEmpty)
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 8,
// //                       vertical: 4,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: ColorRes.homeGreenFade.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Text(
// //                       widget.reviewItem.entityType!,
// //                       style: TextStyle(
// //                         fontSize: AppFontSizes.caption,
// //                         fontWeight: AppFontWeights.semiBold,
// //                         color: ColorRes.homeGreenFade,
// //                       ),
// //                     ),
// //                   ),
// //                 Text(
// //                   _formatDate(widget.reviewItem.createdAt!),
// //                   style: TextStyle(
// //                     fontSize: AppFontSizes.caption,
// //                     color: Colors.grey.shade600,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Avatar widget
// //   Widget _buildAvatar() {
// //     return Container(
// //       width: 50,
// //       height: 50,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(25),
// //         border: Border.all(
// //           color: const Color(0xFF2E7D63).withOpacity(0.2),
// //           width: 2,
// //         ),
// //         gradient: LinearGradient(
// //           colors: [
// //             ColorRes.homeGreenFade.withOpacity(0.1),
// //             ColorRes.homeGreenDarkFade.withOpacity(0.1),
// //           ],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(23),
// //         child: Image.asset(
// //           IMGRes.user_2,
// //           fit: BoxFit.cover,
// //           errorBuilder:
// //               (context, error, stackTrace) => Icon(
// //                 Icons.person,
// //                 color: ColorRes.leadGreyColor.shade300,
// //                 size: 28,
// //               ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Reviewer info (name + verification)
// //   Widget _buildReviewerInfo() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Expanded(
// //               child: Obx(() {
// //                 if (userController.isLoading.value &&
// //                     userController.user.value == null) {
// //                   return const Text('-');
// //                 }
// //                 return Text(
// //                   userController.user.value?.username ?? "Anonymous",
// //                   style: TextStyle(
// //                     fontSize: AppFontSizes.body,
// //                     fontWeight: AppFontWeights.extraBold,
// //                     color: ColorRes.homeBlackFade,
// //                   ),
// //                   overflow: TextOverflow.ellipsis,
// //                 );
// //               }),
// //             ),
// //             if (widget.reviewItem.isVerified ?? false)
// //               Container(
// //                 padding: const EdgeInsets.all(2),
// //                 decoration: BoxDecoration(
// //                   color: ColorRes.homeGreenDarkFade,
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: const Icon(Icons.check, color: ColorRes.white, size: 12),
// //               ),
// //           ],
// //         ),
// //         const SizedBox(height: 4),
// //         Text(
// //           widget.reviewItem.verificationType ?? "Verified User",
// //           style: TextStyle(
// //             fontSize: AppFontSizes.small,
// //             color: ColorRes.leadGreyColor.shade600,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Rating row
// //   Widget _buildRatingRow() {
// //     return Row(
// //       children: [
// //         ...List.generate(5, (index) {
// //           if (index < widget.reviewItem.rating!.floor()) {
// //             return const Icon(Icons.star, color: ColorRes.homeYellow, size: 16);
// //           } else if (index < widget.reviewItem.rating!) {
// //             return const Icon(
// //               Icons.star_half,
// //               color: ColorRes.homeYellow,
// //               size: 16,
// //             );
// //           } else {
// //             return Icon(
// //               Icons.star_outline,
// //               color: ColorRes.leadGreyColor.shade300,
// //               size: 16,
// //             );
// //           }
// //         }),
// //         const SizedBox(width: 8),
// //         Text(
// //           widget.reviewItem.rating!.toStringAsFixed(1),
// //           style: TextStyle(
// //             fontSize: AppFontSizes.medium,
// //             fontWeight: AppFontWeights.semiBold,
// //             color: ColorRes.homeBlackFade,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Format date for readability
// //   String _formatDate(DateTime date) {
// //     return "${date.day.toString().padLeft(2, '0')}-"
// //         "${date.month.toString().padLeft(2, '0')}-"
// //         "${date.year}";
// //   }
// // }

// class PropertyReviewCard extends StatefulWidget {
//   final ReviewItem reviewItem;

//   const PropertyReviewCard({super.key, required this.reviewItem});

//   @override
//   State<PropertyReviewCard> createState() => _PropertyReviewCardState();
// }

// class _PropertyReviewCardState extends State<PropertyReviewCard> {
//   late final UserController userController;
//   final reviewController = Get.put(ReviewController());

//   @override
//   void initState() {
//     super.initState();
//     final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
//     Get.put(UserController(), tag: tag);
//     userController = Get.find<UserController>(tag: tag);
//     userController.fetchUserById(widget.reviewItem.createdBy ?? "");
//   }

//   @override
//   void dispose() {
//     final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
//     Get.delete<UserController>(tag: tag);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(20),
//         // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 0.8),
//         boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 2,

//               offset: const Offset(0, 3),
//             ),
//           ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 🧑‍💼 Header — Avatar + Reviewer Info
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Obx(
//                 () => _buildAvatar(
//                   username: userController.user.value?.username ?? "Anonymous",
//                   imageUrl: userController.user.value?.profilePic,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(child: _buildReviewerInfo()),
//               Text(
//                 _formatDate(widget.reviewItem.createdAt ?? DateTime.now()),
//                 style: TextStyle(
//                   fontSize: AppFontSizes.small,
//                   color: ColorRes.leadGreyColor.shade600,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           // ⭐ Rating Row
//           _buildRatingRow(),

//           const SizedBox(height: 12),

//           // 💬 Review Content
//           Text(
//             '${widget.reviewItem.content}' ?? '',

//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.leadGreyColor.shade800,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),

//           const SizedBox(height: 16),
//           if (widget.reviewItem.pros != null &&
//               ((widget.reviewItem.pros?.text?.isNotEmpty ?? false) ||
//                   (widget.reviewItem.pros?.tags?.isNotEmpty ?? false)))
//             ProsConsSection(review: widget.reviewItem, isPros: true),
//           const SizedBox(height: 10),
//           // ❌ Cons Section
//           if (widget.reviewItem.cons != null &&
//               ((widget.reviewItem.cons?.text?.isNotEmpty ?? false) ||
//                   (widget.reviewItem.cons?.tags?.isNotEmpty ?? false)))
//             ProsConsSection(review: widget.reviewItem, isPros: false),
//           const SizedBox(height: 12),
//           // 👍 Helpful & Report Row
//           // Row(
//           //   children: [
//           //     Icon(Icons.thumb_up_alt_outlined,
//           //         size: 18, color: ColorRes.textSecondary),
//           //     const SizedBox(width: 4),
//           //     GestureDetector(
//           //       onTap: () {
//           //         // reviewController.markHelpful(widget.reviewItem.id??'');
//           //         // reviewController.refreshList();
//           //       },
//           //       child: Text(
//           //         "Helpful (${widget.reviewItem.helpfulCount ?? 0})",
//           //         style: TextStyle(
//           //             fontSize: AppFontSizes.small,
//           //             color: ColorRes.textSecondary),
//           //       ),
//           //     ),
//           //     Spacer(),
//           //     Icon(Icons.flag_outlined,
//           //         size: 18, color: ColorRes.textSecondary),
//           //     const SizedBox(width: 4),
//           //     Text(
//           //       "Report",
//           //       style: TextStyle(
//           //           fontSize: AppFontSizes.small,
//           //           color: ColorRes.textSecondary),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }

//   /// 🧍 Avatar (Rounded Image)
//   Widget _buildAvatar({String? imageUrl, required String username}) {
//     final String initial =
//         username.isNotEmpty ? username.trim()[0].toUpperCase() : "U";

//     return ClipOval(
//       child: Container(
//         width: 50,
//         height: 50,
//         color: ColorRes.leadGreyColor.shade100,
//         child:
//             (imageUrl != null && imageUrl.isNotEmpty)
//                 ? CustomImage(
//                   src: imageUrl,
//                   type: CustomImageType.network,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => _buildInitialAvatar(initial),
//                 )
//                 : _buildInitialAvatar(initial),
//       ),
//     );
//   }

//   Widget _buildInitialAvatar(String initial) {
//     return Center(
//       child: Text(
//         initial,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey.shade700,
//         ),
//       ),
//     );
//   }

//   /// 📝 Reviewer Info (Name + Verification)
//   Widget _buildReviewerInfo() {
//     return Obx(() {
//       final isLoading = userController.isLoading.value;
//       final user = userController.user.value;

//       final username =
//           isLoading ? 'Loading...' : (user?.username ?? 'Anonymous');

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Flexible(
//                 child: Text(
//                   username,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.homeBlackFade,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (widget.reviewItem.isVerified ?? false) ...[
//                 const SizedBox(width: 6),
//                 const Icon(Icons.verified, color: ColorRes.primary, size: 16),
//               ],
//             ],
//           ),
//           const SizedBox(height: 2),
//           Text(
//             widget.reviewItem.verificationType ?? "Verified User",
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.leadGreyColor.shade600,
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   /// ⭐ Star Rating Row
//   Widget _buildRatingRow() {
//     final rating = widget.reviewItem.rating ?? 0.0;
//     return Row(
//       children: [
//         ...List.generate(5, (index) {
//           if (index < rating.floor()) {
//             return const Icon(Icons.star, color: ColorRes.homeYellow, size: 18);
//           } else if (index < rating) {
//             return const Icon(
//               Icons.star_half,
//               color: ColorRes.homeYellow,
//               size: 18,
//             );
//           } else {
//             return Icon(
//               Icons.star_border,
//               color: ColorRes.leadGreyColor.shade300,
//               size: 18,
//             );
//           }
//         }),
//         const SizedBox(width: 6),
//         Text(
//           rating.toStringAsFixed(1),
//           style: TextStyle(
//             fontSize: AppFontSizes.body,
//             fontWeight: FontWeight.w600,
//             color: ColorRes.homeBlackFade,
//           ),
//         ),
//       ],
//     );
//   }

//   /// 📅 Format date
//   String _formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')}-"
//         "${date.month.toString().padLeft(2, '0')}-"
//         "${date.year}";
//   }
// }

// class ProsConsSection extends StatefulWidget {
//   final ReviewItem review;
//   final bool isPros;

//   const ProsConsSection({
//     super.key,
//     required this.review,
//     required this.isPros,
//   });

//   @override
//   State<ProsConsSection> createState() => _ProsConsSectionState();
// }

// class _ProsConsSectionState extends State<ProsConsSection> {
//   bool showMore = false;

//   @override
//   Widget build(BuildContext context) {
//     final ReviewProsCons? section =
//         widget.isPros ? widget.review.pros : widget.review.cons;

//     final tags = section?.tags ?? [];
//     final text = section?.text ?? "";
//     final color = widget.isPros ? Colors.green : Colors.red;
//     final title = widget.isPros ? "Like" : "Dislike";
//     final icon = widget.isPros ? Icons.add_circle : Icons.remove_circle;

//     if ((tags.isEmpty) && text.isEmpty) return const SizedBox.shrink();

//     // Determine visible tags based on showMore
//     final visibleTags = showMore ? tags : tags.take(3).toList();
//     final hasMore = tags.length > 3 || text.length > 100;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title
//         Row(
//           children: [
//             Icon(icon, color: color, size: 18),
//             const SizedBox(width: 6),
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: AppFontWeights.regular,
//                 fontSize: AppFontSizes.bodySmall,
//                 color: ColorRes.leadGreyColor.shade600,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         if (text.isNotEmpty) ...[
//           Text(
//             showMore
//                 ? text
//                 : text.length > 100
//                 ? "${text.substring(0, 100)}..."
//                 : text,
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               fontWeight: AppFontWeights.medium,
//               color: color.shade500,
//               height: 1.3,
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],

//         // Tags
//         if (visibleTags.isNotEmpty)
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children:
//                 visibleTags
//                     .map(
//                       (t) => Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColorRes.primary.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           capitalizeEachWord(t),
//                           style: TextStyle(
//                             fontSize: AppFontSizes.extraSmall,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                       ),
//                     )
//                     .toList(),
//           ),

//         // Text content

//         // Show more / less button
//         if (hasMore)
//           Align(
//             alignment: Alignment.centerLeft,
//             child: TextButton(
//               onPressed: () => setState(() => showMore = !showMore),
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.zero,
//                 minimumSize: const Size(40, 24),
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//               child: Text(
//                 showMore ? "Show Less" : "Show More",
//                 style: TextStyle(
//                   fontSize: AppFontSizes.small,
//                   color: color,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:nesticope_app/modules/review/controllers/review_controller.dart';
import 'package:nesticope_app/modules/user/controllers/user_controller.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/img_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/widgets/image/custom_image.dart' hide ColorRes;
import '../../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';

// class PropertyReviewCard extends StatefulWidget {
//   final ReviewItem reviewItem;
//   const PropertyReviewCard({super.key, required this.reviewItem});
//
//   @override
//   State<PropertyReviewCard> createState() => _PropertyReviewCardState();
// }
//
// class _PropertyReviewCardState extends State<PropertyReviewCard> {
//   late final UserController userController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
//
//     Get.put(UserController(), tag: tag);
//     userController = Get.find<UserController>(tag: tag);
//
//     userController.fetchUserById(widget.reviewItem.createdBy ?? "");
//   }
//
//   @override
//   void dispose() {
//     // Clean up: Delete the controller when this card is disposed
//     final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
//     Get.delete<UserController>(tag: tag);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 300,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: ColorRes.leadGreyColor.shade200.withOpacity(0.2),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// HEADER — Avatar + Reviewer Info
//             Row(
//               children: [
//                 _buildAvatar(),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildReviewerInfo()),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//
//             /// RATING
//             _buildRatingRow(),
//
//             const SizedBox(height: 16),
//
//             /// REVIEW CONTENT
//             Text(
//               '"${widget.reviewItem.content}"',
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 color: ColorRes.leadGreyColor.shade700,
//                 height: 1.5,
//                 fontStyle: FontStyle.italic,
//               ),
//               maxLines: 4,
//               overflow: TextOverflow.ellipsis,
//             ),
//
//             const SizedBox(height: 16),
//             const Spacer(),
//
//             /// FOOTER — Property Type & Date
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 if (widget.reviewItem.entityType!.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: ColorRes.homeGreenFade.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       widget.reviewItem.entityType!,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.caption,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.homeGreenFade,
//                       ),
//                     ),
//                   ),
//                 Text(
//                   _formatDate(widget.reviewItem.createdAt!),
//                   style: TextStyle(
//                     fontSize: AppFontSizes.caption,
//                     color: Colors.grey.shade600,
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
//   /// Avatar widget
//   Widget _buildAvatar() {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(
//           color: const Color(0xFF2E7D63).withOpacity(0.2),
//           width: 2,
//         ),
//         gradient: LinearGradient(
//           colors: [
//             ColorRes.homeGreenFade.withOpacity(0.1),
//             ColorRes.homeGreenDarkFade.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(23),
//         child: Image.asset(
//           IMGRes.user_2,
//           fit: BoxFit.cover,
//           errorBuilder:
//               (context, error, stackTrace) => Icon(
//                 Icons.person,
//                 color: ColorRes.leadGreyColor.shade300,
//                 size: 28,
//               ),
//         ),
//       ),
//     );
//   }
//
//   /// Reviewer info (name + verification)
//   Widget _buildReviewerInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Obx(() {
//                 if (userController.isLoading.value &&
//                     userController.user.value == null) {
//                   return const Text('-');
//                 }
//                 return Text(
//                   userController.user.value?.username ?? "Anonymous",
//                   style: TextStyle(
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.extraBold,
//                     color: ColorRes.homeBlackFade,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 );
//               }),
//             ),
//             if (widget.reviewItem.isVerified ?? false)
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: ColorRes.homeGreenDarkFade,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.check, color: ColorRes.white, size: 12),
//               ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         Text(
//           widget.reviewItem.verificationType ?? "Verified User",
//           style: TextStyle(
//             fontSize: AppFontSizes.small,
//             color: ColorRes.leadGreyColor.shade600,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Rating row
//   Widget _buildRatingRow() {
//     return Row(
//       children: [
//         ...List.generate(5, (index) {
//           if (index < widget.reviewItem.rating!.floor()) {
//             return const Icon(Icons.star, color: ColorRes.homeYellow, size: 16);
//           } else if (index < widget.reviewItem.rating!) {
//             return const Icon(
//               Icons.star_half,
//               color: ColorRes.homeYellow,
//               size: 16,
//             );
//           } else {
//             return Icon(
//               Icons.star_outline,
//               color: ColorRes.leadGreyColor.shade300,
//               size: 16,
//             );
//           }
//         }),
//         const SizedBox(width: 8),
//         Text(
//           widget.reviewItem.rating!.toStringAsFixed(1),
//           style: TextStyle(
//             fontSize: AppFontSizes.medium,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.homeBlackFade,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Format date for readability
//   String _formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')}-"
//         "${date.month.toString().padLeft(2, '0')}-"
//         "${date.year}";
//   }
// }

class PropertyReviewCard extends StatefulWidget {
  final ReviewItem reviewItem;
  /// When true show the complete review (pros/cons, footer etc.).
  /// When false show a compact summary (header, rating, truncated content).
  final bool showFullDetails;

  const PropertyReviewCard({
    super.key,
    required this.reviewItem,
    this.showFullDetails = true,
  });

  @override
  State<PropertyReviewCard> createState() => _PropertyReviewCardState();
}

class _PropertyReviewCardState extends State<PropertyReviewCard> {
  late final UserController userController;
  final reviewController = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();
    final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
    Get.put(UserController(), tag: tag);
    userController = Get.find<UserController>(tag: tag);
    userController.fetchUserById(widget.reviewItem.createdBy ?? "");
  }

  @override
  void dispose() {
    final tag = 'user_${widget.reviewItem.createdBy}_${widget.reviewItem.id}';
    Get.delete<UserController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🧑‍💼 Header — Avatar + Reviewer Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => _buildAvatar(
                  username: userController.user.value?.username ?? "Anonymous",
                  imageUrl: userController.user.value?.profilePic,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildReviewerInfo()),
              const SizedBox(width: 12),
              Text(
                _formatDate(widget.reviewItem.createdAt ?? DateTime.now()),
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: ColorRes.leadGreyColor.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ⭐ Rating Row
          _buildRatingRow(),

          const SizedBox(height: 12),

          // 💬 Review Content
          Text(
            '${widget.reviewItem.content}' ?? '',

            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor.shade800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),
          if (widget.showFullDetails) ...[
            if (widget.reviewItem.pros != null &&
                ((widget.reviewItem.pros?.text?.isNotEmpty ?? false) ||
                    (widget.reviewItem.pros?.tags?.isNotEmpty ?? false)))
              ProsConsSection(review: widget.reviewItem, isPros: true),
            const SizedBox(height: 10),
            // ❌ Cons Section
            if (widget.reviewItem.cons != null &&
                ((widget.reviewItem.cons?.text?.isNotEmpty ?? false) ||
                    (widget.reviewItem.cons?.tags?.isNotEmpty ?? false)))
              ProsConsSection(review: widget.reviewItem, isPros: false),
            const SizedBox(height: 12),
          ],
          // 👍 Helpful & Report Row
          // Row(
          //   children: [
          //     Icon(Icons.thumb_up_alt_outlined,
          //         size: 18, color: ColorRes.textSecondary),
          //     const SizedBox(width: 4),
          //     GestureDetector(
          //       onTap: () {
          //         // reviewController.markHelpful(widget.reviewItem.id??'');
          //         // reviewController.refreshList();
          //       },
          //       child: Text(
          //         "Helpful (${widget.reviewItem.helpfulCount ?? 0})",
          //         style: TextStyle(
          //             fontSize: AppFontSizes.small,
          //             color: ColorRes.textSecondary),
          //       ),
          //     ),
          //     Spacer(),
          //     Icon(Icons.flag_outlined,
          //         size: 18, color: ColorRes.textSecondary),
          //     const SizedBox(width: 4),
          //     Text(
          //       "Report",
          //       style: TextStyle(
          //           fontSize: AppFontSizes.small,
          //           color: ColorRes.textSecondary),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  /// 🧍 Avatar (Rounded Image)
  Widget _buildAvatar({String? imageUrl, required String username}) {
    final String initial =
        username.isNotEmpty ? username.trim()[0].toUpperCase() : "U";

    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: ColorRes.leadGreyColor.shade100,
        child:
            (imageUrl != null && imageUrl.isNotEmpty)
                ? CustomImage(
                  src: imageUrl,
                  type: CustomImageType.network,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildInitialAvatar(initial),
                )
                : _buildInitialAvatar(initial),
      ),
    );
  }

  Widget _buildInitialAvatar(String initial) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  /// 📝 Reviewer Info (Name + Verification)
  Widget _buildReviewerInfo() {
    return Obx(() {
      final isLoading = userController.isLoading.value;
      final user = userController.user.value;

      final username =
          isLoading ? 'Loading...' : (user?.username ?? 'Anonymous');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  username.replaceAll("_", " ").capitalize??'',
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.homeBlackFade,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.reviewItem.isVerified ?? false) ...[
                const SizedBox(width: 6),
                const Icon(Icons.verified, color: ColorRes.primary, size: 16),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            widget.reviewItem.verificationType ?? "Verified User",
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor.shade600,
            ),
          ),
        ],
      );
    });
  }

  /// ⭐ Star Rating Row
  Widget _buildRatingRow() {
    final rating = widget.reviewItem.rating ?? 0.0;
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, color: ColorRes.homeYellow, size: 18);
          } else if (index < rating) {
            return const Icon(
              Icons.star_half,
              color: ColorRes.homeYellow,
              size: 18,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: ColorRes.leadGreyColor.shade300,
              size: 18,
            );
          }
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: FontWeight.w600,
            color: ColorRes.homeBlackFade,
          ),
        ),
      ],
    );
  }

  /// 📅 Format date
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}

class ProsConsSection extends StatefulWidget {
  final ReviewItem review;
  final bool isPros;

  const ProsConsSection({
    super.key,
    required this.review,
    required this.isPros,
  });

  @override
  State<ProsConsSection> createState() => _ProsConsSectionState();
}

class _ProsConsSectionState extends State<ProsConsSection> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    final ReviewProsCons? section =
        widget.isPros ? widget.review.pros : widget.review.cons;

    final tags = section?.tags ?? [];
    final text = section?.text ?? "";
    final color = widget.isPros ? Colors.green : Colors.red;
    final title = widget.isPros ? "Like" : "Dislike";
    final icon = widget.isPros ? Icons.add_circle : Icons.remove_circle;

    if ((tags.isEmpty) && text.isEmpty) return const SizedBox.shrink();

    // Determine visible tags based on showMore
    final visibleTags = showMore ? tags : tags.take(3).toList();
    final hasMore = tags.length > 3 || text.length > 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: AppFontWeights.regular,
                fontSize: AppFontSizes.bodySmall,
                color: ColorRes.leadGreyColor.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (text.isNotEmpty) ...[
          Text(
            showMore
                ? text
                : text.length > 100
                ? "${text.substring(0, 100)}..."
                : text,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: color.shade500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Tags
        if (visibleTags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                visibleTags
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          capitalizeEachWord(t),
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),

        // Text content

        // Show more / less button
        if (hasMore)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => showMore = !showMore),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                showMore ? "Show Less" : "Show More",
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: color,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
