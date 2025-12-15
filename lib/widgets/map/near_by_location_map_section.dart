import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/color_res.dart';
import '../../app/utils/helper_function/contact_helper.dart';
import '../../modules/search_property/controller/search_controller.dart';

class NearbyLocationMapSection extends StatefulWidget {
  final String address;
  final GoogleMapSearchController mapController;

  const NearbyLocationMapSection({
    super.key,
    required this.address,
    required this.mapController,
  });

  @override
  State<NearbyLocationMapSection> createState() =>
      _NearbyLocationMapSectionState();
}

class _NearbyLocationMapSectionState extends State<NearbyLocationMapSection> {
  gmaps.GoogleMapController? _googleMapController;

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  // Build markers based on current data (without setState)
  Set<gmaps.Marker> _buildMarkers() {
    final latLng = widget.mapController.propertyLatLng.value;
    if (latLng == null) return {};

    final markers = <gmaps.Marker>{};

    // Add property marker (Blue)
    markers.add(
      gmaps.Marker(
        markerId: const gmaps.MarkerId('property'),
        position: gmaps.LatLng(latLng['lat']!, latLng['lng']!),
        infoWindow: gmaps.InfoWindow(
          title: 'Property Location',
          snippet: widget.address,
        ),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          gmaps.BitmapDescriptor.hueBlue,
        ),
      ),
    );

    // Add nearby places markers (Red)
    final categoryPlaces = widget.mapController.categoryPlaces;
    for (var i = 0; i < categoryPlaces.length; i++) {
      final place = categoryPlaces[i];
      if (place['lat'] != null && place['lng'] != null) {
        markers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId('place_$i'),
            position: gmaps.LatLng(place['lat'], place['lng']),
            infoWindow: gmaps.InfoWindow(
              title: place['name'] ?? 'Location',
              snippet: place['distanceText'] ?? '',
            ),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueRed,
            ),
          ),
        );
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map Preview with Categories
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorRes.leadGreyColor.shade300,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Google Map with property marker
              Obx(() {
                final latLng = widget.mapController.propertyLatLng.value;
                final categoryPlaces = widget.mapController.categoryPlaces;

                // Build markers based on current data
                final markers = _buildMarkers();

                if (latLng == null) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: ColorRes.leadGreyColor.shade200,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 48,
                            color: ColorRes.leadGreyColor.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.address,
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.leadGreyColor.shade600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final initialPosition = gmaps.LatLng(
                  latLng['lat']!,
                  latLng['lng']!,
                );

                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: gmaps.GoogleMap(
                      initialCameraPosition: gmaps.CameraPosition(
                        target: initialPosition,
                        zoom: 14.5,
                      ),
                      markers: markers,
                      // Enable all gestures
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      // Map controls
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: true,
                      // Map type
                      mapType: gmaps.MapType.normal,
                      // Fix gesture conflicts with parent scroll
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                      onMapCreated: (controller) {
                        _googleMapController = controller;
                      },
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Category Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schools around your location',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryButton(
                            'Education',
                            Icons.school_outlined,
                            'school',
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryButton(
                            'Healthcare',
                            Icons.local_hospital_outlined,
                            'hospital',
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryButton(
                            'Food & Dining',
                            Icons.restaurant_outlined,
                            'restaurant',
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryButton(
                            'Shopping',
                            Icons.shopping_bag_outlined,
                            'shopping_mall',
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryButton(
                            'Entertainment',
                            Icons.movie_outlined,
                            'movie_theater',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Selected Category Places List
              Obx(() {
                if (widget.mapController.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (widget.mapController.categoryPlaces.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Divider(height: 1, color: ColorRes.grey.withOpacity(0.3)),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      itemCount:
                          widget.mapController.categoryPlaces.length > 5
                              ? 5
                              : widget.mapController.categoryPlaces.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final place =
                            widget.mapController.categoryPlaces[index];
                        return GestureDetector(
                          onTap: () {
                            ContactHelper.openInGoogleMaps(place['address']);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ColorRes.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: ColorRes.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: ColorRes.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place['name'] ?? '-',
                                        style: const TextStyle(
                                          fontWeight: AppFontWeights.semiBold,
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            place['distanceText'] ?? '-',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.caption,
                                              color:
                                                  ColorRes
                                                      .leadGreyColor
                                                      .shade600,
                                            ),
                                          ),
                                          Text(
                                            ' • ',
                                            style: TextStyle(
                                              color:
                                                  ColorRes
                                                      .leadGreyColor
                                                      .shade600,
                                            ),
                                          ),
                                          Text(
                                            place['walkTime'] ?? '-',
                                            style: TextStyle(
                                              fontSize: AppFontSizes.caption,
                                              color:
                                                  ColorRes
                                                      .leadGreyColor
                                                      .shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: ColorRes.leadGreyColor.shade400,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String label, IconData icon, String type) {
    return Obx(() {
      final isSelected = widget.mapController.selectedCategory.value == type;
      return GestureDetector(
        onTap: () {
          widget.mapController.selectCategory(type);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected
                      ? ColorRes.primary
                      : ColorRes.leadGreyColor.shade300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    isSelected
                        ? ColorRes.white
                        : ColorRes.leadGreyColor.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSizes.caption,
                  fontWeight:
                      isSelected
                          ? AppFontWeights.semiBold
                          : AppFontWeights.medium,
                  color:
                      isSelected
                          ? ColorRes.white
                          : ColorRes.leadGreyColor.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
