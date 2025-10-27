import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';

import '../../../app/manager/property/property_pricemanager.dart';
import '../../../app/manager/property_highlight_manager.dart';
import '../controller/builder_form_controller.dart';
import 'builder_form_screen.dart';

class BuilderPropertyListing extends StatelessWidget {
  const BuilderPropertyListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProjectWizardController());
    final controller = Get.find<ProjectWizardController>();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Properties',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text('No projects found'));
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final ProjectModel data = controller.items[index];

            return Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  // 👉 Navigate to project detail screen here
                  // Get.to(() => ProjectDetailScreen(project: data));
                },
                child: BuilderProjectCard(
                  project: data,
                  developersName: data.projectContactInfo?.name ?? 'Unknown',
                  imageUrl:
                      data.imageList.isNotEmpty
                          ? data.imageList.first
                          : IMGRes.home3,
                  projectName:
                      data.projectName.isNotEmpty ? data.projectName : 'N/A',
                  location:
                      data.address.isNotEmpty ? data.address : 'Not specified',
                  price: '₹500',
                  // You can format dynamic price here
                  propertySize: data.projectSize.totalBuildings.toString(),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class BuilderProjectCard extends StatelessWidget {
  final ProjectModel project;
  final String imageUrl;
  final String projectName;
  final String location;
  final String developersName;
  final String propertySize;
  final String price;
  final double height;
  final double width;

  const BuilderProjectCard({
    Key? key,
    required this.imageUrl,
    required this.projectName,
    required this.location,
    required this.developersName,
    required this.propertySize,
    required this.price,
    this.height = 220,
    this.width = 200,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectWizardController>();
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: IconButton(
          //     onPressed: () async {
          //       await controller.updateProjectData(project);
          //       Get.to(
          //         () => ProjectWizardView(),
          //         binding: BindingsBuilder(() {
          //           Get.put(ProjectWizardController());
          //         }),
          //       );
          //     },
          //     icon: Icon(Icons.edit),
          //   ),
          // ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () async {
                // Navigate to ProjectWizardView and wait for result
                final result = await Get.to(
                  () => CreateProjectScreen(isFromEdit: true),
                  arguments: project.id,
                  binding: BindingsBuilder(() async {
                    // Create a new controller instance with the project data
                    final wizardController = Get.put(ProjectWizardController());
                    // Update the controller with existing project data
                    await wizardController.updateProjectData(project);
                  }),
                );

                // After returning, refresh the current list
                if (result == true) {
                  // If the wizard was successful, reload the data
                  controller.loadInitial(); // Refresh the list
                }
              },
              icon: Icon(Icons.edit),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                // child: Image.network(
                //   imageUrl,
                //   height: height * 0.5,
                //   width: width,
                //   fit: BoxFit.cover,
                // ),
                child: Container(color: ColorRes.primary),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: TextStyle(
                        fontSize: AppFontSizes.subtitle,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: ColorRes.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              color: ColorRes.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By $developersName',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: ColorRes.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      propertySize,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: ColorRes.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: AppFontSizes.subtitle,
                        fontWeight: AppFontWeights.bold,
                        color: ColorRes.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
