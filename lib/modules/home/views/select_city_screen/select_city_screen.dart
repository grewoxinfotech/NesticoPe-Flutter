import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/filter_property/controller/city_insigths_controller.dart';
import 'package:nesticope_app/modules/history/controller/search_history_controller.dart';
import 'package:nesticope_app/modules/search_property/model/search_model.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import '../../../../app/constants/color_res.dart';
import '../../../other/trending_city/controllers/trending_city_controller.dart';
import '../../../search_property/controller/search_controller.dart';
import '../../../search_property/view/search_screen.dart';

class SelectCityScreen extends StatefulWidget {
  bool? isFromLogin;
  String? title;

  SelectCityScreen({super.key, this.isFromLogin = false, this.title});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final GoogleMapSearchController controller = Get.put(
    GoogleMapSearchController(),
  );

  final CityController cityController = Get.put(CityController());
  final popularController = Get.put(TrendingCityController());

  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // 👈 for managing focus
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cityController.isFromLoginSide.value = widget.isFromLogin ?? false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
          title:
              (widget.isFromLogin ?? false)
                  ? Text(
                    '${widget.title}',
                    style: TextStyle(fontWeight: AppFontWeights.semiBold),
                  )
                  : Text(
                    'Select City',
                    style: TextStyle(fontWeight: AppFontWeights.semiBold),
                  ),
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
                  setState(() {
                    if (value.trim().isNotEmpty) {
                      cityController.selectedCity.value = value;
                      controller.fetchGooglePlaces(value.trim());
                    } else {
                      controller.predictions.clear();
                      _focusNode.unfocus();
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // 📋 Results
              Expanded(
                child: Obx(() {
                  if ((cityController.isFromLoginSide.value) &&
                      cityController.selectedCity.isEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 📍 Popular Locations
                          /*  Obx(() {
                            if (popularController.allTrendingCities.isEmpty) {

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return buildSection(
                              "Popular Locations",
                              cityController.allCities,
                              isFromLoginSide: cityController.isFromLoginSide.value,
                            );
                          }),*/
                          // 📍 Popular Locations
                          Obx(() {
                            if (popularController.allTrendingCities.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final cities = popularController.allTrendingCities;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                       Text(
                                        "Popular Cities",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: ColorRes.textColor,
                                        ),
                                      ),
                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(
                                      //     horizontal: 10,
                                      //     vertical: 4,
                                      //   ),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.orange.shade100,
                                      //     borderRadius: BorderRadius.circular(
                                      //       12,
                                      //     ),
                                      //   ),
                                      //   child: const Text(
                                      //     "New Hotspots",
                                      //     style: TextStyle(
                                      //       fontSize: 11,
                                      //       color: Colors.deepOrange,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // Grid of Cities
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cities.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 2,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 0.70,
                                        ),
                                    itemBuilder: (context, index) {
                                      final city = cities[index];
                                      final isSelected =
                                          cityController.selectedCity.value ==
                                          city.city;

                                      return GestureDetector(
                                        onTap: () {
                                          // cityController.selectedCity.value =
                                          //     city.city;
                                         if(cityController.isFromLoginSide.value){
                                           final selectedCity = city.city.trim();
                                           Get.back(result: selectedCity);
                                         }

                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          isSelected
                                                              ? Colors
                                                                  .blueAccent
                                                              : Colors
                                                                  .transparent,
                                                      width: 2,
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        city.cityImage ?? '',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 6,
                                                        offset: const Offset(
                                                          0,
                                                          3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                      size: 26,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              city.city ?? '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    isSelected
                                                        ? Colors.blueAccent
                                                        : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
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
                          _focusNode.unfocus();
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
