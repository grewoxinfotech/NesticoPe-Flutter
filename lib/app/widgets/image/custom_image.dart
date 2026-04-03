// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// // Assuming this is your color file path
// // import '../../constants/color_res.dart';
//
// // Temporary placeholder for the color if the import is missing
// class ColorRes {
//   static const Color leadGreyColor = Colors.grey;
// }
//
// enum CustomImageType { asset, network, file, memory }
//
// class CustomImage extends StatelessWidget {
//   final String? src;
//   final File? file;
//   final Uint8List? bytes;
//   final CustomImageType type;
//   final BoxFit fit;
//   final double? width;
//   final double? height;
//
//   // New parameters to control memory usage manually if needed
//   final int? memCacheWidth;
//   final int? memCacheHeight;
//
//   final Widget Function(BuildContext, String)? networkPlaceholder;
//   final Widget Function(BuildContext, String, dynamic)? networkError;
//   final ImageErrorWidgetBuilder? errorBuilder;
//   final ImageFrameBuilder? frameBuilder;
//   final ImageLoadingBuilder? loadingBuilder;
//
//   const CustomImage({
//     super.key,
//     this.src,
//     this.file,
//     this.bytes,
//     required this.type,
//     this.fit = BoxFit.cover,
//     this.width,
//     this.height,
//     this.memCacheWidth,
//     this.memCacheHeight,
//     this.errorBuilder,
//     this.frameBuilder,
//     this.loadingBuilder,
//     this.networkPlaceholder,
//     this.networkError,
//   });
//
//   /// Helper to calculate optimal cache size based on display size
//   /// This prevents loading a 4000px image for a 50px icon.
//   int? _getCacheWidth(BuildContext context) {
//     if (memCacheWidth != null) return memCacheWidth;
//     if (width != null && width != double.infinity) {
//       return (width! * MediaQuery.of(context).devicePixelRatio).toInt();
//     }
//     return null;
//   }
//
//   int? _getCacheHeight(BuildContext context) {
//     if (memCacheHeight != null) return memCacheHeight;
//     if (height != null && height != double.infinity) {
//       return (height! * MediaQuery.of(context).devicePixelRatio).toInt();
//     }
//     return null;
//   }
//
//   /// ✅ Returns an ImageProvider.
//   /// Note: ResizeImage is used to prevent OOM crashes in providers too.
//   ImageProvider toImageProvider(BuildContext context) {
//     // Calculate cache sizes
//     final int? cacheW = _getCacheWidth(context);
//     final int? cacheH = _getCacheHeight(context);
//
//     ImageProvider provider;
//
//     switch (type) {
//       case CustomImageType.asset:
//         provider = AssetImage(src ?? "");
//         break;
//       case CustomImageType.network:
//         return CachedNetworkImageProvider(
//           src ?? "",
//           maxWidth: cacheW,
//           maxHeight: cacheH,
//         );
//       case CustomImageType.file:
//         provider = FileImage(file ?? File(""));
//         break;
//       case CustomImageType.memory:
//         provider = MemoryImage(bytes ?? Uint8List(0));
//         break;
//     }
//
//     // Wrap asset/file/memory in ResizeImage to optimize memory
//     if (cacheW != null || cacheH != null) {
//       return ResizeImage(provider, width: cacheW, height: cacheH);
//     }
//     return provider;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final int? cacheW = _getCacheWidth(context);
//     final int? cacheH = _getCacheHeight(context);
//
//     switch (type) {
//       case CustomImageType.asset:
//         return Image.asset(
//           src ?? "",
//           fit: fit,
//           width: width,
//           height: height,
//           cacheWidth: cacheW, // Optimized
//           cacheHeight: cacheH, // Optimized
//           errorBuilder: errorBuilder ?? _defaultErrorBuilder,
//           frameBuilder: frameBuilder ?? _defaultFrameBuilder,
//         );
//
//       case CustomImageType.network:
//         return CachedNetworkImage(
//           imageUrl: src ?? "",
//           fit: fit,
//           width: width,
//           height: height,
//           memCacheWidth: cacheW, // Optimized: Decodes only what is needed
//           memCacheHeight: cacheH, // Optimized
//           placeholder:
//               networkPlaceholder ??
//               (context, url) => const Center(
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 ),
//               ),
//           errorWidget:
//               networkError ??
//               (context, url, error) => const Icon(
//                 Icons.broken_image,
//                 size: 40,
//                 color: ColorRes.leadGreyColor,
//               ),
//         );
//
//       case CustomImageType.file:
//         return Image.file(
//           file ?? File(""),
//           fit: fit,
//           width: width,
//           height: height,
//           cacheWidth: cacheW, // Optimized
//           cacheHeight: cacheH, // Optimized
//           errorBuilder: errorBuilder ?? _defaultErrorBuilder,
//           frameBuilder: frameBuilder ?? _defaultFrameBuilder,
//         );
//
//       case CustomImageType.memory:
//         return Image.memory(
//           bytes ?? Uint8List(0),
//           fit: fit,
//           width: width,
//           height: height,
//           cacheWidth: cacheW, // Optimized
//           cacheHeight: cacheH, // Optimized
//           errorBuilder: errorBuilder ?? _defaultErrorBuilder,
//           frameBuilder: frameBuilder ?? _defaultFrameBuilder,
//         );
//     }
//   }
//
//   Widget _defaultErrorBuilder(
//     BuildContext context,
//     Object error,
//     StackTrace? stackTrace,
//   ) {
//     return const Icon(
//       Icons.broken_image,
//       color: ColorRes.leadGreyColor,
//       size: 40,
//     );
//   }
//
//   Widget _defaultFrameBuilder(
//     BuildContext context,
//     Widget child,
//     int? frame,
//     bool wasSynchronouslyLoaded,
//   ) {
//     if (wasSynchronouslyLoaded) return child;
//     return AnimatedOpacity(
//       opacity: frame == null ? 0 : 1,
//       duration: const Duration(
//         milliseconds: 300,
//       ), // Reduced duration for snappier feel
//       child: child,
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nesticope_app/utils/global.dart';
import 'package:shimmer/shimmer.dart'; // Import added



class ColorResImg {
  static const Color leadGreyColor = Colors.grey;
  static final Color shimmerBase = Colors.grey[300]!;
  static final Color shimmerHighlight = Colors.grey[100]!;
}

enum CustomImageType { asset, network, file, memory }

class CustomImage extends StatelessWidget {
  final String? src;
  final File? file;
  final Uint8List? bytes;
  final CustomImageType type;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;

  final Widget Function(BuildContext, String)? networkPlaceholder;
  final Widget Function(BuildContext, String, dynamic)? networkError;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;

  const CustomImage({
    super.key,
    this.src,
    this.file,
    this.bytes,
    required this.type,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.memCacheWidth,
    this.memCacheHeight,
    this.errorBuilder,
    this.frameBuilder,
    this.loadingBuilder,
    this.networkPlaceholder,
    this.networkError,
  });

  // Helper for Cache calculations...
  int? _getCacheWidth(BuildContext context) {
    if (memCacheWidth != null) return memCacheWidth;
    if (width != null && width != double.infinity) {
      return (width! * MediaQuery.of(context).devicePixelRatio).toInt();
    }
    return null;
  }

  int? _getCacheHeight(BuildContext context) {
    if (memCacheHeight != null) return memCacheHeight;
    if (height != null && height != double.infinity) {
      return (height! * MediaQuery.of(context).devicePixelRatio).toInt();
    }
    return null;
  }

  /// ✅ Shimmer Placeholder Widget
  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: ColorResImg.shimmerBase,
      highlightColor: ColorResImg.shimmerHighlight,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          // If you use rounded corners elsewhere, add a borderRadius here
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fallback() {
      return Image.asset(
        imageOfNotAvailable,
        fit: fit,
        width: width,
        height: height,
      );
    }

    final int? cacheW = _getCacheWidth(context);
    final int? cacheH = _getCacheHeight(context);

    switch (type) {
      case CustomImageType.asset:
        if (src == null || src!.trim().isEmpty) {
          return fallback();
        }
        return Image.asset(
          src ?? "",
          fit: fit,
          width: width,
          height: height,
          cacheWidth: cacheW,
          cacheHeight: cacheH,
          errorBuilder: errorBuilder ?? _defaultErrorBuilder,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
        );

      case CustomImageType.network:
        if (src == null || src!.trim().isEmpty) {
          print("src is empty ${src}");
          return fallback();
        }
        print("src is not empty ${src}");
        return CachedNetworkImage(
          imageUrl: src ?? "",
          fit: fit,
          width: width,
          height: height,
          memCacheWidth: cacheW,
          memCacheHeight: cacheH,
          placeholder:
              networkPlaceholder ?? (context, url) => _shimmerPlaceholder(),
    errorWidget: networkError ?? (context, url, error) {
  debugPrint("❌ Image failed: $url | Error: $error");
  return fallback();
},
        );

      case CustomImageType.file:
        if (file == null) {
          return fallback();
        }
        return Image.file(
          file ?? File(""),
          fit: fit,
          width: width,
          height: height,
          cacheWidth: cacheW,
          cacheHeight: cacheH,
          errorBuilder: errorBuilder ?? _defaultErrorBuilder,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
        );

      case CustomImageType.memory:
        if (bytes == null || bytes!.isEmpty) {
          return fallback();
        }
        return Image.memory(
          bytes ?? Uint8List(0),
          fit: fit,
          width: width,
          height: height,
          cacheWidth: cacheW,
          cacheHeight: cacheH,
          errorBuilder: errorBuilder ?? _defaultErrorBuilder,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
        );
    }
  }

  Widget _defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Image.asset(
      imageOfNotAvailable,
      fit: fit,
      width: width,
      height: height,
    );
  }

  Widget _defaultFrameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
