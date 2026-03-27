// // import 'package:carousel_slider/carousel_slider.dart' as cs;
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:nesticope_app/modules/home/controllers/banner_controller.dart';
// //
// // class HorizontalBannerList extends StatefulWidget {
// //   const HorizontalBannerList({super.key});
// //
// //   @override
// //   State<HorizontalBannerList> createState() => _HorizontalBannerListState();
// // }
// //
// // class _HorizontalBannerListState extends State<HorizontalBannerList> {
// //   final BannerController bannerController = Get.put(BannerController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         /// Carousel Slider
// //         cs.CarouselSlider(
// //           options: cs.CarouselOptions(
// //             viewportFraction: 1,
// //             onPageChanged:
// //                 (index, _) => bannerController.updatePageIndecator(index),
// //           ),
// //           items:
// //               bannerController.banners
// //                   .map(
// //                     (banner) => ClipRRect(
// //                       borderRadius: BorderRadius.circular(12),
// //                       child: Image.asset(
// //                         banner,
// //                         fit: BoxFit.cover,
// //                         width: double.infinity,
// //                       ),
// //                     ),
// //                   )
// //                   .toList(),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// import 'package:nesticope_app/app/constants/img_res.dart';

// class HorizontalBannerList extends StatelessWidget {
//   HorizontalBannerList({Key? key}) : super(key: key);

//   // Example banner image URLs or local asset paths
//   final List<String> banners = [IMGRes.banner1, IMGRes.banner2, IMGRes.banner3];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 125,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: banners.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.asset(
//               banners[index],
//               width: 300,
//               height: 120,
//               fit: BoxFit.fill,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
