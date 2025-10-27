import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
import '../../../app/constants/color_res.dart';
import '../../search_property/controller/search_controller.dart';

class SelectCityScreen extends StatelessWidget {
  SelectCityScreen({super.key});

  final GoogleMapController controller = Get.put(GoogleMapController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: const Text('Select City'),
        centerTitle: true,
        elevation: 0,
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

                return ListView.separated(
                  itemCount: controller.predictions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final Prediction prediction = controller.predictions[index];
                    return ListTile(
                      title: Text(prediction.description.toString()),
                      onTap: () async {
                        // Extract city name only (e.g., "Ahmedabad" from "Ahmedabad, Gujarat, India")
                        final city =
                            prediction.description
                                .toString()
                                .split(',')
                                .first
                                .trim();
                        Get.back(result: city);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
