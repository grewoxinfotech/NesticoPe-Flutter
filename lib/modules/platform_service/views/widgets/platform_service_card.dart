// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../data/network/platform_service/platform_service_model.dart';
//
// class PlatformServiceHorizontalList extends StatelessWidget {
//   final List<PlatformServiceItem> services;
//   final double cardWidth;
//   final double cardHeight;
//   final void Function(PlatformServiceItem)? onTap;
//
//   const PlatformServiceHorizontalList({
//     super.key,
//     required this.services,
//     this.cardWidth = 250,
//     this.cardHeight = 200,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (services.isEmpty) {
//       return const SizedBox(
//         height: 180,
//         child: Center(child: Text("No services available")),
//       );
//     }
//
//     return SizedBox(
//       height: cardHeight,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: services.length,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemBuilder: (context, index) {
//           final service = services[index];
//           return GestureDetector(
//             onTap: () => onTap?.call(service),
//             child: Container(
//               width: cardWidth,
//               margin: const EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 color: ColorRes.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: ColorRes.leadGreyColor.shade200),
//               ),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Icon or placeholder
//                   Row(
//                     children: [
//                       Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           color: ColorRes.blueColor.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child:
//                             service.icon != null
//                                 ? Image.network(
//                                   service.icon!,
//                                   fit: BoxFit.contain,
//                                 )
//                                 : Icon(
//                                   Icons.home_work,
//                                   color: ColorRes.blueColor,
//                                 ),
//                       ),
//                       const SizedBox(width: 12),
//                       // Title
//                       Expanded(
//                         child: Text(
//                           service.title ?? '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontWeight: AppFontWeights.bold,
//                             fontSize: AppFontSizes.medium,
//                             color: ColorRes.textPrimary
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: ColorRes.primary.withOpacity(0.08),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           '#${index + 1}',
//                           style: TextStyle(
//                             fontWeight: AppFontWeights.semiBold,
//                             fontSize: AppFontSizes.small,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//                   // Description
//                   Text(
//                     service.description ?? '',
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: AppFontSizes.caption,
//                       color: ColorRes.blackShade54,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   if (service.features != null && service.features!.isNotEmpty)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children:
//                             service.features!
//                                 .take(2)
//                                 .map(
//                                   (f) => Container(
//                                     margin: const EdgeInsets.only(right: 6),
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 10,
//                                       vertical: 5,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: ColorRes.blueColor.shade50,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       f,
//                                       style: TextStyle(
//                                         fontSize: AppFontSizes.extraSmall,
//                                         color: ColorRes.blueColor,
//                                         fontWeight: AppFontWeights.medium,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                       ),
//                     ),
//                   Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(right: 6),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: service.isActive ?? false
//                               ? ColorRes.green
//                               : ColorRes.leadGreyColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         alignment: Alignment.center,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Circular dot
//                             Container(
//                               width: 8,
//                               height: 8,
//                               margin: const EdgeInsets.only(right: 6),
//                               decoration: BoxDecoration(
//                                 color: Colors.white, // dot color
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             // Status text
//                             Text(
//                               service.isActive ?? false ? "ACTIVE" : "INACTIVE",
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.extraSmall,
//                                 color: ColorRes.white,
//                                 fontWeight: AppFontWeights.semiBold ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         'Updated: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(service.updatedAt ?? ''),)}',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.extraSmall,
//                           color: ColorRes.leadGreyColor,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       )
//
//                     ],
//                   ),
//
//
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/platform_service/platform_service_model.dart';

class PlatformServiceHorizontalList extends StatefulWidget {
  final List<PlatformServiceItem> services;
  final double cardWidth;
  final double cardHeight;
  final void Function(PlatformServiceItem)? onTap;

  const PlatformServiceHorizontalList({
    super.key,
    required this.services,
    this.cardWidth = 250,
    this.cardHeight = 210,
    this.onTap,
  });

  @override
  State<PlatformServiceHorizontalList> createState() => _PlatformServiceHorizontalListState();
}

class _PlatformServiceHorizontalListState extends State<PlatformServiceHorizontalList> {
  // Track expanded state for each service card
  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    if (widget.services.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No services available")),
      );
    }

    return SizedBox(
      height: widget.cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.services.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (context, index) => SizedBox(width: 12,),
        itemBuilder: (context, index) {
          final service = widget.services[index];
          // final isExpanded = _expandedStates[index] ?? false;
          // final hasMoreFeatures = (service.features?.length ?? 0) > 2;

          return GestureDetector(
            onTap: () => widget.onTap?.call(service),
            child: Container(
              width: widget.cardWidth,
              // margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorRes.leadGreyColor.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon or placeholder
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: ColorRes.blueColor.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                        service.icon != null
                            ? Image.network(
                          service.icon!,
                          fit: BoxFit.contain,
                        )
                            : Icon(
                          Icons.home_work,
                          color: ColorRes.blueColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title
                      Expanded(
                        child: Text(
                          service.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.bodySmall,
                              color: ColorRes.textPrimary
                          ),
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // Container(
                      //   padding: EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: ColorRes.primary.withOpacity(0.08),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: Text(
                      //     '#${index + 1}',
                      //     style: TextStyle(
                      //       fontWeight: AppFontWeights.semiBold,
                      //       fontSize: AppFontSizes.small,
                      //       color: ColorRes.primary,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Description
                  Text(
                    service.description ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.leadGreyColor.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (service.features != null && service.features!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                            service.features!
                                .map(
                                  (f) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.blueColor.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.extraSmall,
                                    color: ColorRes.blueColor,
                                    fontWeight: AppFontWeights.medium,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        // if (hasMoreFeatures)
                        //   GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         _expandedStates[index] = !isExpanded;
                        //       });
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(top: 4),
                        //       child: Text(
                        //         isExpanded ? 'Show less' : 'Read more (${service.features!.length - 2}+)',
                        //         style: TextStyle(
                        //           fontSize: AppFontSizes.extraSmall,
                        //           color: ColorRes.primary,
                        //           fontWeight: AppFontWeights.semiBold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: service.isActive ?? false
                              ? ColorRes.green
                              : ColorRes.leadGreyColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Circular dot
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white, // dot color
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Status text
                            Text(
                              service.isActive ?? false ? "ACTIVE" : "INACTIVE",
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.white,
                                fontWeight: AppFontWeights.semiBold ,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Updated: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(service.updatedAt ?? ''),)}',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          color: ColorRes.leadGreyColor,
                          fontWeight: AppFontWeights.medium,
                        ),
                      )

                    ],
                  ),


                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
