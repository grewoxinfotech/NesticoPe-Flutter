import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/modules/filter_property/view/filter_screen.dart';

import 'package:housing_flutter_app/modules/propert_detail/view/widget/property_card_widget.dart';

import '../../../data/network/property/models/property_model.dart';

import '../../property/controllers/property_controller.dart';

class PropertyDetail extends StatelessWidget {
  List<Map<String, String>>? filters;
  final bool isAppBarShow;
  final Color backgroundColor;
  final PropertyController controller = Get.put(PropertyController());

  final List<Map<String, dynamic>> properties = [
    {
      'title': 'The White Abode',
      'imageUrl': 'https://picsum.photos/400/200',
      'location': '33, Laxmi Palace, S V Road, Near...',
      'role': ' Developer',
      'price': 'Rs. 8,00,000',
      'apartments': [
        {'bhk': '2 BHK Apartment', 'priceRange': '50 L - 1.2 Cr'},
        {'bhk': '4 BHK Apartment', 'priceRange': '92 L - 1.5 Cr'},
        {'bhk': '5 BHK Apartment', 'priceRange': '2.5 Cr - 3.2 Cr'},
      ],
      'beds': 4,
      'baths': 4,
      'area': 874,
      'ownerName': 'James Aldeio',
      'ownerAvatar': 'https://i.pravatar.cc/150?img=3',
      'images': [
        'https://picsum.photos/seed/white1/600/400',
        'https://picsum.photos/seed/white2/600/400',
        'https://picsum.photos/seed/white3/600/400',
      ],
    },
    {
      'title': 'Sunset Villa',
      'imageUrl': 'https://picsum.photos/401/200',
      'location': 'Palm Street, Ocean View',
      'price': 'Rs. 12,50,000',
      'role': ' Agents',
      'beds': 5,
      'apartments': [
        {'bhk': '2 BHK Apartment', 'priceRange': '50 L - 1.2 Cr'},
        {'bhk': '4 BHK Apartment', 'priceRange': '92 L - 1.5 Cr'},
      ],
      'baths': 3,
      'area': 1200,
      'ownerName': 'Sophia Turner',
      'ownerAvatar': 'https://i.pravatar.cc/150?img=5',
      'images': [
        'https://picsum.photos/seed/villa1/600/400',
        'https://picsum.photos/seed/villa2/600/400',
        'https://picsum.photos/seed/villa3/600/400',
        'https://picsum.photos/seed/villa4/600/400',
      ],
    },
    {
      'title': 'City Heights',
      'imageUrl': 'https://picsum.photos/402/200',
      'location': 'Metro Plaza, Downtown',
      'price': 'Rs. 6,75,000',
      'beds': 3,
      'baths': 2,
      'role': ' Owner',
      'area': 690,
      'apartments': [
        {'bhk': '2 BHK Apartment', 'priceRange': '50 L - 1.2 Cr'},
      ],
      'ownerName': 'David Smith',
      'ownerAvatar': 'https://i.pravatar.cc/150?img=7',
      'images': [
        'https://picsum.photos/seed/city1/600/400',
        'https://picsum.photos/seed/city2/600/400',
        'https://picsum.photos/seed/city3/600/400',
      ],
    },
  ];
  RxMap<String, String> selectedFilters = <String, String>{}.obs;

  PropertyDetail({
    super.key,
    this.isAppBarShow = true,
    this.backgroundColor = Colors.white,
    this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar:
          isAppBarShow
              ? AppBar(
                elevation: 0,
                backgroundColor: ColorRes.white,
                title: const Text(
                  "Property List",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorRes.textColor,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Get.to<RxMap<String, String>>(
                          () => RealEstateFilterScreen(),
                        );
                        if (result != null) {
                          selectedFilters.clear();
                          selectedFilters.addAll(result);
                        }
                      },

                      child: Icon(Icons.filter_list),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Obx(() {
                    if (selectedFilters.isEmpty) return const SizedBox.shrink();
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: Colors.grey[100],
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              selectedFilters.entries.map((e) {
                                if (e.value.isEmpty)
                                  return const SizedBox.shrink();
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${e.key}: ${e.value}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    );
                  }),
                ),
              )
              : null,
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: Text("No Property found."));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge && metrics.pixels != 0) {
              controller.loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.refreshList,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.small,
                horizontal: AppPadding.small,
              ),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final property = properties[index % properties.length];
                final data = controller.items[index];
                return PropertyCardWidget(
                  property: data,
                  role: property['role'],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
