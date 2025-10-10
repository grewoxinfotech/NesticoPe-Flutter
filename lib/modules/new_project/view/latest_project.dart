
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/home/widgets/home_header.dart';
import 'package:housing_flutter_app/modules/new_project/view/widget/hotspot_location.dart';
import 'package:housing_flutter_app/modules/new_project/view/widget/top_developer.dart';


import '../../property/controllers/property_controller.dart';

class MumbaiProjectsScreen extends StatelessWidget {
  const MumbaiProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PropertyController());
    final PropertyController controller = Get.find();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarDividerColor: ColorRes.transparentColor,
        systemNavigationBarColor: Theme.of(context).secondaryHeaderColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: ColorRes.transparentColor,
      ),
      child: Scaffold(
        backgroundColor: ColorRes.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section (Image 1)
                Container(
                  decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //     'https://media.istockphoto.com/id/1135075538/vector/smart-city.jpg?s=612x612&w=0&k=20&c=SiaDcq5hzb-4OjNfCTpc71nwq3v9tUIFVhDwelSJaCE=',
                    //   ),
                    //   fit: BoxFit.cover,
                    // ),
                    color: Color(0xff091F48),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "You are looking for",
                          style: TextStyle(
                            color: ColorRes.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "New Projects in Mumbai",
                          style: TextStyle(
                            color: ColorRes.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: buildPositionedTextField(context, () {}),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Hotspots section
                      HotspotSection(
                        title: "Hotspots in Mumbai",
                        onMapView: () => print("Map view clicked"),
                        hotspots: [
                          Hotspot(
                            name: "Western Suburbs",
                            description: "Vibrant and fast-developing region",
                            projectsCount: "10442 projects",
                            appreciationText: "appreciation in last 1 year",
                            appreciationValue: 9.25,
                            isPositive: true,
                            items: controller.items.value, // your data
                          ),
                          Hotspot(
                            name: "Andheri - Dadar",
                            description: "Prime central location",
                            projectsCount: "8722 projects",
                            appreciationText: "appreciation in last 1 year",
                            appreciationValue: 12.6,
                            isPositive: false,
                            items: controller.items.value, // your data
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Top 5 Mumbai developers for new projects',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.w600,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                // Second Section (Image 2)
                DeveloperSection(
                  developerName: "Lodha Group",
                  developerEmail: "lodhagroup@domain.com",
                  developerImage: "https://i.pravatar.cc/150?img=7",
                  stats: const {
                    "Year estd": "1980",
                    "Live Projects": "32",
                    "Delivered": "23",
                  },
                  projectsTitle: "Projects by Lodha Group",
                  onSeeAll: () => print("See all clicked"),
                  isLoading: controller.isLoading.value,
                  projects: controller.items,
                ),
                DeveloperSection(
                  developerName: "Unimont Group",
                  developerEmail: "unimontgroup@gmail.com",
                  developerImage: "https://i.pravatar.cc/150?img=5",
                  stats: const {
                    "Year estd": "2010",
                    "Live Projects": "12",
                    "Delivered": "25",
                  },
                  projectsTitle: "Projects by Unimont Group",
                  onSeeAll: () => print("See all clicked"),
                  isLoading: controller.isLoading.value,
                  projects: controller.items,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
