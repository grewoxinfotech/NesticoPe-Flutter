//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../app/constants/ic_res.dart';
// import '../../app/constants/size_manager.dart';
// import '../../modules/auth/controllers/auth_controller.dart';
// import '../display/card.dart';
// import '../display/ic.dart';
//
// class NesticoPeDrawer extends StatelessWidget {
//   const NesticoPeDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     Get.lazyPut<DrawerController>(() => DrawerController());
//     DrawerController drawerController = Get.find();
//
//     final DrawerController drawerController = Get.put(DrawerController());
//
//     List<DrawerModel> items = [
//       DrawerModel(title: "DashBoard", iconPath: ICRes.customer),
//       DrawerModel(title: "Project", iconPath: ICRes.project),
//       DrawerModel(title: "Calendar", iconPath: ICRes.calendar),
//       DrawerModel(title: "Vacations", iconPath: ICRes.project),
//       DrawerModel(title: "Employees", iconPath: ICRes.employees),
//       DrawerModel(title: "Messenger", iconPath: ICRes.notifications),
//       DrawerModel(title: "Info Portal", iconPath: ICRes.file),
//
//     ];
//
//     Widget divider = Divider(
//       height: 0,
//       color: Get.theme.dividerColor,
//       endIndent: 10,
//       indent: 10,
//     );
//
//     return SafeArea(
//       child: NesticoPeCard(
//         width: Get.width * 0.6,
//         margin: const EdgeInsets.only(
//           left: AppPadding.small,
//           bottom: AppPadding.small,
//         ),
//         borderRadius: BorderRadius.circular(AppRadius.large),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListView.separated(
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: items.length,
//               padding: EdgeInsets.all(AppPadding.small),
//               shrinkWrap: true,
//               itemBuilder: (context, i) {
//                 return Obx(
//                       () => GestureDetector(
//                     onTap: () => drawerController.onchange(i),
//                     child: NesticoPeCard(
//                       padding: const EdgeInsets.all(AppPadding.small),
//                       boxShadow: [],
//                       borderRadius: BorderRadius.circular(
//                         AppRadius.large - AppPadding.small,
//                       ),
//                       color:
//                       (drawerController.selextedIndex == i)
//                           ? Get.theme.colorScheme.primary.withAlpha(20)
//                           : null,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           NesticoPeIc(
//                             iconPath: items[i].iconPath.toString(),
//                             width: 24,
//                             color:
//                             (drawerController.selextedIndex == i)
//                                 ? Get.theme.colorScheme.primary
//                                 : Get.theme.colorScheme.onSecondary,
//                           ),
//                           AppSpacing.horizontalSmall,
//                           Text(
//                             items[i].title.toString(),
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight:
//                               (drawerController.selextedIndex == i)
//                                   ? AppFontWeights.bold
//                                   : AppFontWeights.semiBold,
//                               color:
//                               (drawerController.selextedIndex == i)
//                                   ? Get.theme.colorScheme.primary
//                                   : Get.theme.colorScheme.onSecondary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               separatorBuilder: (context, i) => AppSpacing.verticalSmall,
//             ),
//             AppSpacing.verticalSmall,
//             Align(
//               alignment: Alignment.center,
//               child: FloatingActionButton.extended(
//                 label: Text(
//                   "Support",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: AppFontWeights.bold,
//                     color: ColorRes.white,
//                   ),
//                 ),
//                 icon: NesticoPeIc(iconPath: ICRes.notifications, color: ColorRes.white),
//                 onPressed: () {},
//               ),
//             ),
//             Spacer(),
//             Padding(
//               padding: EdgeInsets.all(AppPadding.medium),
//               child: GestureDetector(
//                 onTap: () => Get.put(AuthController()).logout(),
//                 child: Row(
//                   children: [
//                     NesticoPeIc(
//                       iconPath: ICRes.logout,
//                       color: Get.theme.colorScheme.onSecondary,
//                     ),
//                     AppSpacing.horizontalSmall,
//                     Text(
//                       "Logout",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: AppFontWeights.bold,
//                         color: Get.theme.colorScheme.onSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DrawerController extends GetxController {
//   RxInt selextedIndex = 0.obs;
//
//   onchange(int index) => selextedIndex(index);
// }
//
// class DrawerModel {
//   String? title;
//   String? iconPath;
//   Widget? widget;
//
//   DrawerModel({this.title, this.iconPath, this.widget});
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/color_res.dart';
import '../../app/constants/ic_res.dart';
import '../../app/constants/size_manager.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../display/card.dart';
import '../display/ic.dart';

class NesticoPeDrawer extends StatelessWidget {
  NesticoPeDrawer({super.key});

  final DrawerController drawerController = Get.put(DrawerController());

  final List<DrawerModel> items = [
    DrawerModel(title: "Home", icon: Icons.home_outlined),
    DrawerModel(title: "My Properties", icon: Icons.apartment_outlined),
    DrawerModel(title: "Post Property", icon: Icons.add_home_work_outlined),
    DrawerModel(title: "Saved Properties", icon: Icons.favorite_border),
    DrawerModel(title: "Leads & Inquiries", icon: Icons.people_alt_outlined),
    DrawerModel(title: "Subscription Plans", icon: Icons.workspace_premium),
    DrawerModel(title: "Support", icon: Icons.support_agent),
    DrawerModel(title: "Settings", icon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width * .75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            /// ================= HEADER =================
            _realEstateHeader(),

            /// ================= MENU =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return Obx(() {
                    final selected = drawerController.selectedIndex.value == i;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => drawerController.onChange(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color:
                              selected
                                  ? ColorRes.primary.withOpacity(.1)
                                  : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              items[i].icon,
                              size: 20,
                              color:
                                  selected
                                      ? ColorRes.primary
                                      : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              items[i].title,
                              style: TextStyle(
                                fontSize: AppFontSizes.bodySmall,
                                fontWeight:
                                    selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                color:
                                    selected
                                        ? ColorRes.primary
                                        : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            /// ================= LOGOUT =================
            _logout(),
          ],
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _realEstateHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: ColorRes.primary),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello, Seller 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Manage your properties",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= LOGOUT =================
  Widget _logout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => Get.find<AuthController>().logout(),
        child: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red, size: 20),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: AppFontWeights.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void onChange(int index) => selectedIndex.value = index;
}

class DrawerModel {
  final String title;
  final IconData icon;

  DrawerModel({required this.title, required this.icon});
}
