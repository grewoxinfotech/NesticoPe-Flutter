// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
//
// /// Supported image sources
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
//   /// Optional overrides
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
//     this.errorBuilder,
//     this.frameBuilder,
//     this.loadingBuilder,
//   });
//
//   /// ✅ Returns an ImageProvider for CircleAvatar, DecorationImage, etc.
//   ImageProvider toImageProvider() {
//     switch (type) {
//       case CustomImageType.asset:
//         return AssetImage(src ?? "");
//       case CustomImageType.network:
//         return NetworkImage(src ?? "");
//       case CustomImageType.file:
//         return FileImage(file ?? File(""));
//       case CustomImageType.memory:
//         return MemoryImage(bytes ?? Uint8List(0));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     switch (type) {
//       case CustomImageType.asset:
//         return Image.asset(
//           src ?? "",
//           fit: fit,
//           width: width,
//           height: height,
//           errorBuilder: errorBuilder ?? _defaultErrorBuilder,
//           frameBuilder: frameBuilder ?? _defaultFrameBuilder,
//           // loadingBuilder: loadingBuilder ?? _defaultLoadingBuilder,
//         );
//
//       case CustomImageType.network:
//         return Image.network(
//           src ?? "",
//           fit: fit,
//           width: width,
//           height: height,
//           errorBuilder: errorBuilder ?? _defaultErrorBuilder,
//           frameBuilder: frameBuilder ?? _defaultFrameBuilder,
//           loadingBuilder: loadingBuilder ?? _defaultLoadingBuilder,
//         );
//
//       case CustomImageType.file:
//         return Image.file(
//           file ?? File(""),
//           fit: fit,
//           width: width,
//           height: height,
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
//           errorBuilder: errorBuilder ?? _defaultErrorBuilder,
//           frameBuilder: frameBuilder ?? _defaultFrameBuilder,
//         );
//     }
//   }
//
//   /// Default error handler
//   Widget _defaultErrorBuilder(
//     BuildContext context,
//     Object error,
//     StackTrace? stackTrace,
//   ) {
//     return const Icon(Icons.broken_image, color: Colors.grey, size: 40);
//   }
//
//   /// Default frame handler (fade-in effect)
//   Widget _defaultFrameBuilder(
//     BuildContext context,
//     Widget child,
//     int? frame,
//     bool wasSynchronouslyLoaded,
//   ) {
//     if (wasSynchronouslyLoaded) return child;
//     return AnimatedOpacity(
//       opacity: frame == null ? 0 : 1,
//       duration: const Duration(milliseconds: 500),
//       child: child,
//     );
//   }
//
//   /// Default loading handler (progress indicator)
//   Widget _defaultLoadingBuilder(
//     BuildContext context,
//     Widget child,
//     ImageChunkEvent? loadingProgress,
//   ) {
//     if (loadingProgress == null) return child;
//     return Center(
//       child: CircularProgressIndicator(
//         value:
//             loadingProgress.expectedTotalBytes != null
//                 ? loadingProgress.cumulativeBytesLoaded /
//                     (loadingProgress.expectedTotalBytes ?? 1)
//                 : null,
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Supported image sources
enum CustomImageType { asset, network, file, memory }

class CustomImage extends StatelessWidget {
  final String? src;
  final File? file;
  final Uint8List? bytes;
  final CustomImageType type;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Optional overrides
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
    this.errorBuilder,
    this.frameBuilder,
    this.loadingBuilder,
    this.networkPlaceholder,
    this.networkError,
  });

  /// ✅ Returns an ImageProvider for CircleAvatar, DecorationImage, etc.
  ImageProvider toImageProvider() {
    switch (type) {
      case CustomImageType.asset:
        return AssetImage(src ?? "");
      case CustomImageType.network:
        return CachedNetworkImageProvider(src ?? "");
      case CustomImageType.file:
        return FileImage(file ?? File(""));
      case CustomImageType.memory:
        return MemoryImage(bytes ?? Uint8List(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CustomImageType.asset:
        return Image.asset(
          src ?? "",
          fit: fit,
          width: width,
          height: height,
          errorBuilder: errorBuilder ?? _defaultErrorBuilder,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
          // loadingBuilder: loadingBuilder ?? _defaultLoadingBuilder,
        );

      case CustomImageType.network:
        return CachedNetworkImage(
          imageUrl: src ?? "",
          fit: fit,
          width: width,
          height: height,
          placeholder:
              networkPlaceholder ??
              (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          errorWidget:
              networkError ??
              (context, url, error) =>
                  const Icon(Icons.broken_image, size: 40, color: Colors.grey),
        );

      case CustomImageType.file:
        return Image.file(
          file ?? File(""),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: errorBuilder ?? _defaultErrorBuilder,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
        );

      case CustomImageType.memory:
        return Image.memory(
          bytes ?? Uint8List(0),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: errorBuilder ?? _defaultErrorBuilder,
          frameBuilder: frameBuilder ?? _defaultFrameBuilder,
        );
    }
  }

  /// Default error handler
  Widget _defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const Icon(Icons.broken_image, color: Colors.grey, size: 40);
  }

  /// Default frame handler (fade-in effect)
  Widget _defaultFrameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }

  /// Default loading handler (progress indicator)
  Widget _defaultLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value:
            loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
      ),
    );
  }
}
