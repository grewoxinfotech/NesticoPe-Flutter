import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/widgets/video_player/custom_video_player.dart';
import '../../../../utils/common_widget/rera_widget.dart';
// import '../property_detail_screen.dart';

class PropertyMediaGallery extends StatefulWidget {
  final List<String>? images;
  final List<String>? videos;
  final String? itemId;
  final bool showReraTag;
  final bool showFavorite;
  final bool showShare;
  final bool showBackButton;
  final double height;

  /// Optional callbacks for dynamic actions
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final Function(String id)? onFavoriteToggle;
  final bool Function(String id)? isFavorite;

  const PropertyMediaGallery({
    super.key,
    this.images,
    this.videos,
    this.itemId,
    this.showReraTag = false,
    this.showFavorite = true,
    this.showShare = true,
    this.showBackButton = true,
    this.height = 300,
    this.onBack,
    this.onShare,
    this.onFavoriteToggle,
    this.isFavorite,
  });

  @override
  State<PropertyMediaGallery> createState() => _DynamicMediaBannerState();
}

class _DynamicMediaBannerState extends State<PropertyMediaGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> get _mediaList {
    final images = widget.images ?? [];
    final videos = widget.videos ?? [];
    return [
      ...images.map((e) => {"type": "image", "url": e}),
      ...videos.map((e) => {"type": "video", "url": e}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaList = _mediaList;
    if (mediaList.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(child: Text("No media available")),
      );
    }

    return SafeArea(
      child: Stack(
        children: [
          /// --- PageView for Images/Videos ---
          SizedBox(
            height: widget.height,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: mediaList.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final item = mediaList[index];
                return item["type"] == "video"
                    ? CustomVideoPlayer(url: item["url"]!)
                    : CustomImage(
                      type: CustomImageType.network,
                      src: item["url"]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
              },
            ),
          ),

          /// --- Back Button ---
          if (widget.showBackButton)
            Positioned(
              top: 16,
              left: 16,
              child: CircularIcon(
                icon: Icons.arrow_back_rounded,
                backgroundColor: ColorRes.white,
                onPressed: widget.onBack ?? () => Get.back(),
              ),
            ),

          /// --- Action Buttons (Favorite + Share) ---
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                if (widget.showFavorite && widget.itemId != null)
                  Obx(() {
                    final isFav =
                        widget.isFavorite?.call(widget.itemId!) ?? false;
                    return CircularIcon(
                      icon:
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                      backgroundColor: ColorRes.white,
                      iconColor:
                          isFav ? ColorRes.redAccentColor : ColorRes.black,
                      onPressed:
                          () => widget.onFavoriteToggle?.call(widget.itemId!),
                    );
                  }),
                if (widget.showShare) const SizedBox(width: 12),
                if (widget.showShare)
                  CircularIcon(
                    icon: Icons.share_outlined,
                    onPressed: widget.onShare,
                    backgroundColor: ColorRes.white,
                  ),
              ],
            ),
          ),

          /// --- Page Indicator ---
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorRes.blackShade54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_currentPage + 1}/${mediaList.length}',
                style: const TextStyle(
                  color: ColorRes.white,
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),

          /// --- Optional RERA Tag ---
          if (widget.showReraTag)
            Positioned(
              left: 16,
              bottom: 16,
              child: ReraComponent(
                text: "Verified",
                backgroundColor: ColorRes.black.withOpacity(0.7),
                textColor: ColorRes.background,
                fontSize: AppFontSizes.small,
                borderRadius: AppRadius.small,
                fontWeight: AppFontWeights.bold,
                showIcon: true,
                iconColor: ColorRes.success,
                iconSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
