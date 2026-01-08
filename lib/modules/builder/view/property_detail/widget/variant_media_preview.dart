// // widgets/media_preview_item.dart
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
//
// import '../../../../../data/network/builder/model/builder_model.dart';
//
// class MediaPreviewItem extends StatelessWidget {
//   final MediaItem item;
//   final int index;
//   final int totalCount;
//   final bool isVideo;
//   final VoidCallback onRemove;
//
//   const MediaPreviewItem({
//     super.key,
//     required this.item,
//     required this.index,
//     required this.totalCount,
//     required this.isVideo,
//     required this.onRemove,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: Stack(
//         children: [
//           Container(
//             width: 120,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: item.isExisting ? Colors.blue[300]! : Colors.grey[300]!,
//                 width: item.isExisting ? 2 : 1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey[200]!,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: Stack(
//               children: [
//                 isVideo
//                     ? _VideoThumbnail(item: item)
//                     : _ImagePreview(item: item),
//                 if (item.isExisting) _buildSavedBadge(),
//                 _buildIndexBadge(),
//               ],
//             ),
//           ),
//           _buildRemoveButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSavedBadge() {
//     return Positioned(
//       top: 4,
//       left: 4,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Text(
//           'Saved',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 9,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildIndexBadge() {
//     return Positioned(
//       bottom: 4,
//       right: 4,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: Colors.black54,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           '${index + 1}/$totalCount',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRemoveButton() {
//     return Positioned(
//       top: 4,
//       right: 4,
//       child: GestureDetector(
//         onTap: onRemove,
//         child: Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             color:
//                 item.isExisting ? Colors.red.withOpacity(0.8) : Colors.black54,
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.close, color: Colors.white, size: 16),
//         ),
//       ),
//     );
//   }
// }
//
// class _ImagePreview extends StatelessWidget {
//   final MediaItem item;
//
//   const _ImagePreview({required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => _showFullScreen(context),
//       child:
//           item.isUrl
//               ? Image.network(
//                 item.url!,
//                 fit: BoxFit.cover,
//                 width: 120,
//                 height: 120,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value:
//                           progress.expectedTotalBytes != null
//                               ? progress.cumulativeBytesLoaded /
//                                   progress.expectedTotalBytes!
//                               : null,
//                       strokeWidth: 2,
//                     ),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) => _buildErrorWidget(),
//               )
//               : Image.file(
//                 item.file!,
//                 fit: BoxFit.cover,
//                 width: 120,
//                 height: 120,
//                 errorBuilder: (_, __, ___) => _buildErrorWidget(),
//               ),
//     );
//   }
//
//   void _showFullScreen(BuildContext context) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => Dialog(
//             child: Stack(
//               children: [
//                 InteractiveViewer(
//                   child:
//                       item.isUrl
//                           ? Image.network(item.url!, fit: BoxFit.contain)
//                           : Image.file(item.file!, fit: BoxFit.contain),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close),
//                     color: Colors.white,
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.black54,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }
//
//   Widget _buildErrorWidget() {
//     return Container(
//       color: Colors.grey[300],
//       child: const Icon(Icons.broken_image, size: 40),
//     );
//   }
// }
//
// class _VideoThumbnail extends StatelessWidget {
//   final MediaItem item;
//
//   const _VideoThumbnail({required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     if (item.isUrl) {
//       return _buildUrlVideoPlaceholder(context);
//     }
//
//     return FutureBuilder<String?>(
//       future: VideoThumbnail.thumbnailFile(
//         video: item.file!.path,
//         imageFormat: ImageFormat.PNG,
//         maxHeight: 120,
//         quality: 75,
//       ),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             color: Colors.black87,
//             child: const Center(
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//           );
//         }
//
//         if (snapshot.hasError || snapshot.data == null) {
//           return _buildUrlVideoPlaceholder(context);
//         }
//
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Image.file(
//               File(snapshot.data!),
//               fit: BoxFit.cover,
//               width: 120,
//               height: 120,
//             ),
//             _buildPlayButton(context),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildUrlVideoPlaceholder(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           color: Colors.black87,
//           child: const Icon(Icons.videocam, size: 40, color: Colors.white54),
//         ),
//         _buildPlayButton(context),
//       ],
//     );
//   }
//
//   Widget _buildPlayButton(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.play_arrow_rounded,
//         color: Theme.of(context).primaryColor,
//         size: 24,
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../data/network/builder/model/builder_model.dart';

class MediaPreviewItem extends StatelessWidget {
  final MediaItem item;
  final int index;
  final int totalCount;
  final bool isVideo;
  final bool is3DModel;
  final VoidCallback onRemove;

  const MediaPreviewItem({
    super.key,
    required this.item,
    required this.index,
    required this.totalCount,
    required this.isVideo,
    this.is3DModel = false,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: index < totalCount - 1 ? 12 : 0,
      ),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildPreview(),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    if (is3DModel) {
      return _build3DModelPreview();
    } else if (isVideo) {
      return _buildVideoPreview();
    } else {
      return _buildImagePreview();
    }
  }

  Widget _buildImagePreview() {
    if (item.isFile) {
      return Image.file(
        File(item.file!.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else if (item.isUrl) {
      return Image.network(
        item.url!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }
    return _buildErrorWidget();
  }

  Widget _buildVideoPreview() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 4),
            Text(
              'Video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DModelPreview() {
    String fileName = 'Model';
    if (item.isFile) {
      fileName = item.file!.path.split('/').last;
    } else if (item.isUrl) {
      fileName = item.url!.split('/').last;
    }

    // Get file extension
    String extension = '';
    if (fileName.contains('.')) {
      extension = fileName.split('.').last.toUpperCase();
    }

    return Container(
      color: Colors.blue.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_in_ar,
              color: Colors.blue.shade700,
              size: 40,
            ),
            const SizedBox(height: 8),
            if (extension.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  extension,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                fileName,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 10,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Icon(
        Icons.error_outline,
        color: Colors.red[300],
        size: 32,
      ),
    );
  }
}