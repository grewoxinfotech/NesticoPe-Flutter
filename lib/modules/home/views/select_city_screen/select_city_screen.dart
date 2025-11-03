import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import '../../../../app/constants/color_res.dart';
import '../../../search_property/controller/search_controller.dart';

class SelectCityScreen extends StatelessWidget {
  SelectCityScreen({super.key});

  final GoogleMapController controller = Get.put(GoogleMapController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ❌ Prevent system back navigation
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Select City",
            message: "Please select a city to continue",
            contentType: ContentType.warning,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorRes.white,
        appBar: AppBar(
          title: const Text('Select City'),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorRes.white,
          foregroundColor: ColorRes.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // 🔍 Search Field
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.fetchPredictionsCity(value.trim());
                  } else {
                    controller.predictions.clear();
                  }
                },
              ),
              const SizedBox(height: 16),

              // 📋 Results
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.predictions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // return ListView.separated(
                  //   itemCount: controller.predictions.length,
                  //   separatorBuilder: (_, __) =>  SizedBox(height: 1),
                  //   itemBuilder: (context, index) {
                  //     final Prediction prediction = controller.predictions[index];
                  //     return ListTile(
                  //       title: Text(prediction.description.toString(),style: TextStyle(fontSize: AppFontSizes.small),),
                  //       onTap: () async {
                  //         // Extract city name only (e.g., "Ahmedabad" from "Ahmedabad, Gujarat, India")
                  //         final city =
                  //             prediction.description
                  //                 .toString()
                  //                 .split(',')
                  //                 .first
                  //                 .trim();
                  //         Get.back(result: city);
                  //       },
                  //     );
                  //   },
                  // );
                  return ListView.separated(
                    itemCount: controller.predictions.length,
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade200,
                        ),
                    itemBuilder: (context, index) {
                      final Prediction prediction =
                          controller.predictions[index];
                      final description = prediction.description.toString();
                      final parts =
                          description.split(',').map((e) => e.trim()).toList();
                      final city = parts.isNotEmpty ? parts[0] : '';
                      final location =
                          parts.length > 1 ? parts.sublist(1).join(', ') : '';
                      return InkWell(
                        onTap: () async {
                          final city =
                              prediction.description
                                  .toString()
                                  .split(',')
                                  .first
                                  .trim();
                          Get.back(result: city);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      city,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.small + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    if (location.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        location,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.small - 1,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
