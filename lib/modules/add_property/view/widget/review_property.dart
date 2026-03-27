import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/add_property/controller/create_property_controller.dart';
import 'package:nesticope_app/modules/add_property/model/review_property_model.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../model/commercial_model.dart';

class ListingReviewCard extends StatelessWidget {
  final CreatePropertyController controller;
  const ListingReviewCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.lookingTo.value == "PG/Co-Living") {
        if (controller.review.value == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No review yet.',
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  color: ColorRes.leadGreyColor,
                ),
              ),
            ),
          );
        }
        final review = controller.review.value!;

        // DEBUG: Print image paths
        debugPrint("=== PG/CO-LIVING REVIEW IMAGES ===");
        for (var img in review.images) {
          debugPrint("Image path: ${img.path}");
        }
        debugPrint("==================================");

        return SingleChildScrollView(
          child: Column(
            children: [
              _ReviewCardItem(review: review, controller: controller),
              const SizedBox(height: 24),
              // Congratulation message
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.green.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ColorRes.green.shade200, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: ColorRes.green,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Congratulations! Your property listing has been created.",
                        style: TextStyle(
                          color: ColorRes.green.shade800,
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: AppFontSizes.small,
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
      } else if ((controller.lookingTo.value == 'Rent' ||
              controller.lookingTo.value == "Sell") &&
          controller.propertyType.value == "Commercial") {
        if (controller.commercialReview.value == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No review yet.',
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  color: ColorRes.leadGreyColor,
                ),
              ),
            ),
          );
        }
        final review =
            controller.commercialReview.value ??
            CommercialPropertyModel(
              buildingName: 'No Define',
              localityName: 'No Define',
            );

        // DEBUG: Print image paths
        debugPrint("=== COMMERCIAL REVIEW IMAGES ===");
        for (var img in review.photos) {
          debugPrint("Image path: ${img.path}");
        }
        debugPrint("=================================");

        return SingleChildScrollView(
          child: Column(
            children: [
              _CommercialReviewCardItem(review: review, controller: controller),
              const SizedBox(height: 24),
              // Congratulation message
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.green.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ColorRes.green.shade200, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: ColorRes.green,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Congratulations! Your property listing has been created.",
                        style: TextStyle(
                          color: ColorRes.green.shade800,
                          fontWeight: AppFontWeights.semiBold,
                          fontSize: AppFontSizes.small,
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
  final CreatePropertyController controller;

  const _ReviewCardItem({required this.review, required this.controller});

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

    // Try to get image from review first, fallback to controller's imageList
    String? imagePath;
    if (review.images.isNotEmpty) {
      imagePath = review.images.first.path;
    } else if (controller.imageList.value.isNotEmpty) {
      imagePath = controller.imageList.value.first;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
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
    debugPrint("PG Image path: $imagePath");

    if (imagePath == null || imagePath.isEmpty) {
      return _buildPlaceholderImage();
    }

    // Check if it's a network URL
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        cacheWidth: 200,
        cacheHeight: 240,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint("Error loading network image: $error");
          return _buildPlaceholderImage();
        },
      );
    }

    // Otherwise, try local file
    final file = File(imagePath);
    if (!file.existsSync()) {
      debugPrint("Local file does not exist: $imagePath");
      return _buildPlaceholderImage();
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      cacheWidth: 200,
      cacheHeight: 240,
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Error loading file image: $error");
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: ColorRes.leadGreyColor.shade200,
      child: Icon(
        Icons.image,
        size: 50,
        color: ColorRes.leadGreyColor.shade400,
      ),
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
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.semiBold,
          ),
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
    final sanitized = text.toLowerCase().contains('null')
        ? text.replaceAll(RegExp('null', caseSensitive: false), '').trim()
        : text;
    if (sanitized.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      sanitized,
      style: TextStyle(
        fontSize: AppFontSizes.caption,
        color: ColorRes.leadGreyColor.shade600,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Under Review',
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.green.shade800,
          fontWeight: AppFontWeights.semiBold,
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
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.extraBold,
              color: ColorRes.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            "Notice: $noticePeriod days",
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor.shade600,
            ),
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
  final CreatePropertyController controller;

  const _CommercialReviewCardItem({
    required this.review,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-compute values to avoid repeated calculations
    String? imagePath;
    if (review.photos.isNotEmpty) {
      imagePath = review.photos.first.path;
    } else if (controller.imageList.value.isNotEmpty) {
      imagePath = controller.imageList.value.first;
    }

    final buildingName =
        review.buildingName.isNotEmpty ? review.buildingName : "Building";
    final locality =
        review.localityName.isNotEmpty ? review.localityName : "Locality";
    final rent =
        review.expectedRent?.isNotEmpty ?? false ? review.expectedRent! : "0";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
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
    debugPrint("Commercial Image path: $imagePath");

    if (imagePath == null || imagePath.isEmpty) {
      return _buildPlaceholderImage();
    }

    // Check if it's a network URL
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        cacheWidth: 200,
        cacheHeight: 240,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint("Error loading network image: $error");
          return _buildPlaceholderImage();
        },
      );
    }

    // Otherwise, try local file
    final file = File(imagePath);
    if (!file.existsSync()) {
      debugPrint("Local file does not exist: $imagePath");
      return _buildPlaceholderImage();
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      cacheWidth: 200,
      cacheHeight: 240,
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Error loading file image: $error");
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: ColorRes.leadGreyColor.shade200,
      child: Icon(
        Icons.image,
        size: 50,
        color: ColorRes.leadGreyColor.shade400,
      ),
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
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.semiBold,
          ),
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
      style: TextStyle(
        fontSize: AppFontSizes.caption,
        color: ColorRes.leadGreyColor.shade600,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Under Review',
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.green.shade800,
          fontWeight: AppFontWeights.semiBold,
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
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.extraBold,
              color: ColorRes.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
