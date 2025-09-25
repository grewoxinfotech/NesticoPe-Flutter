import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/model/review_property_model.dart';

import '../../model/commercial_model.dart';

class ListingReviewCard extends StatelessWidget {
  final CreatePropertyController controller;
  const ListingReviewCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
     if(controller.lookingTo.value=="PG/Co-Living")
       {
         if (controller.review.value == null) {
           return const Center(
             child: Padding(
               padding: EdgeInsets.all(20.0),
               child: Text(
                 'No review yet.',
                 style: TextStyle(fontSize: 16, color: Colors.grey),
               ),
             ),
           );
         }
         final review = controller.review.value!;
         return SingleChildScrollView(
           child: Column(
             children: [
               _ReviewCardItem(review: review),
               const SizedBox(height: 24),
               // Congratulation message
               Container(
                 width: double.infinity,
                 margin: const EdgeInsets.symmetric(horizontal: 12),
                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                 decoration: BoxDecoration(
                   color: Colors.green.shade50,
                   borderRadius: BorderRadius.circular(14),
                   border: Border.all(color: Colors.green.shade200, width: 1),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.check_circle, color: Colors.green, size: 28),
                     const SizedBox(width: 12),
                     Expanded(
                       child: Text(
                         "Congratulations! Your property listing has been created.",
                         style: TextStyle(
                           color: Colors.green.shade800,
                           fontWeight: FontWeight.w600,
                           fontSize: 12,
                         ),
                         textAlign: TextAlign.start,
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         );
       }
     else if((controller.lookingTo.value=='Rent'||controller.lookingTo.value=="Sell") && controller.propertyType.value=="Commercial")
       {
         if (controller.commercialReview.value == null) {
           return const Center(
             child: Padding(
               padding: EdgeInsets.all(20.0),
               child: Text(
                 'No review yet.',
                 style: TextStyle(fontSize: 16, color: Colors.grey),
               ),
             ),
           );
         }
         final review = controller.commercialReview.value??CommercialPropertyModel(buildingName: 'No Define', localityName: 'No Define');

         return SingleChildScrollView(
           child: Column(
             children: [
               _CommercialReviewCardItem(review: review),
               const SizedBox(height: 24),
               // Congratulation message
               Container(
                 width: double.infinity,
                 margin: const EdgeInsets.symmetric(horizontal: 12),
                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                 decoration: BoxDecoration(
                   color: Colors.green.shade50,
                   borderRadius: BorderRadius.circular(14),
                   border: Border.all(color: Colors.green.shade200, width: 1),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.check_circle, color: Colors.green, size: 28),
                     const SizedBox(width: 12),
                     Expanded(
                       child: Text(
                         "Congratulations! Your property listing has been created.",
                         style: TextStyle(
                           color: Colors.green.shade800,
                           fontWeight: FontWeight.w600,
                           fontSize: 12,
                         ),
                         textAlign: TextAlign.start,
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         );
       }
     return SizedBox.shrink();
    });
  }
}

class _ReviewCardItem extends StatelessWidget {
  final PropertyReviewModel review;

  const _ReviewCardItem({required this.review});

  @override
  Widget build(BuildContext context) {
    // Pre-compute values to avoid repeated calculations
    final room = review.rooms.isNotEmpty ? review.rooms.first : null;
    final pgName = review.pgName.isNotEmpty ? review.pgName : "PG Name";
    final noticePeriod =
        review.noticePeriod.isNotEmpty ? review.noticePeriod : "N/A";
    final rent =
        (room?.monthlyRent.isNotEmpty ?? false) ? room!.monthlyRent : "0";
    final availableFor =
        review.bestSuitedList.isNotEmpty
            ? review.bestSuitedList.join(', ')
            : "Not specified";
    final location = review.locality.isNotEmpty ? review.locality : "Location";
    final imagePath =
        review.images.isNotEmpty ? review.images.first.path : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 2,

        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              _buildImageThumbnail(imagePath),
              const SizedBox(width: 12),
              // Property details
              Expanded(
                child: _buildPropertyDetails(
                  pgName: pgName,
                  availableFor: availableFor,
                  location: location,
                  rent: rent,
                  noticePeriod: noticePeriod,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String? imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 100,
        height: 120,
        child: _buildImageWidget(imagePath),
      ),
    );
  }

  Widget _buildImageWidget(String? imagePath) {
    // Optimize image loading to prevent memory issues
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          // Add memory optimizations
          cacheWidth: 200, // Reduce cache size
          cacheHeight: 240,
          errorBuilder: (context, error, stackTrace) {
            debugPrint("Error loading image: $error");
            return _buildPlaceholderImage();
          },
        );
      }
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.image, size: 50, color: Colors.grey.shade400),
    );
  }

  Widget _buildPropertyDetails({
    required String pgName,
    required String availableFor,
    required String location,
    required String rent,
    required String noticePeriod,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // PG Name
        Text(
          pgName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 6),

        // Available for
        _buildInfoText("Available for: $availableFor"),
        const SizedBox(height: 4),

        // Location
        _buildInfoText("Locality: $location"),
        const SizedBox(height: 8),

        // Status Tag
        _buildStatusTag(),
        const SizedBox(height: 8),

        // Rent & Notice Row
        _buildRentNoticeRow(rent, noticePeriod),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Under Review',
        style: TextStyle(
          fontSize: 11,
          color: Colors.green.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRentNoticeRow(String rent, String noticePeriod) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "₹ $rent",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            "Notice: $noticePeriod days",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _CommercialReviewCardItem extends StatelessWidget {
  final CommercialPropertyModel review;

  const _CommercialReviewCardItem({required this.review});

  @override
  Widget build(BuildContext context) {
    // Pre-compute values to avoid repeated calculations
    final imagePath = review.photos.isNotEmpty ? review.photos.first.path : null;
    final buildingName = review.buildingName.isNotEmpty ? review.buildingName : "Building";
    final locality = review.localityName.isNotEmpty ? review.localityName : "Locality";
    final rent = review.expectedRent?.isNotEmpty ?? false ? review.expectedRent! : "0";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              _buildImageThumbnail(imagePath),
              const SizedBox(width: 12),
              // Property details
              Expanded(
                child: _buildPropertyDetails(
                  buildingName: buildingName,
                  locality: locality,
                  rent: rent,
                  amenities: review.amenities,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String? imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 100,
        height: 120,
        child: _buildImageWidget(imagePath),
      ),
    );
  }

  Widget _buildImageWidget(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          cacheWidth: 200,
          cacheHeight: 240,
          errorBuilder: (context, error, stackTrace) {
            debugPrint("Error loading image: $error");
            return _buildPlaceholderImage();
          },
        );
      }
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.image, size: 50, color: Colors.grey.shade400),
    );
  }

  Widget _buildPropertyDetails({
    required String buildingName,
    required String locality,
    required String rent,
    required List<String> amenities,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Building Name
        Text(
          buildingName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 6),

        // Locality
        _buildInfoText("Locality: $locality"),
        const SizedBox(height: 6),

        // Amenities (comma-separated)
        if (amenities.isNotEmpty)
          _buildInfoText("Amenities: ${amenities.join(', ')}"),
        const SizedBox(height: 8),

        // Status Tag
        _buildStatusTag(),
        const SizedBox(height: 8),

        // Rent Row
        _buildRentRow(rent),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Under Review',
        style: TextStyle(
          fontSize: 11,
          color: Colors.green.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRentRow(String rent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "₹ $rent",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

