// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:video_thumbnail/video_thumbnail.dart';
//
// import '../../../../../app/constants/api_constants.dart';
// import '../../../../../data/network/builder/model/builder_model.dart';
//
// // Media item that can be either a File or URL
// class MediaItem {
//   final File? file;
//   final String? url;
//   final bool isExisting;
//
//   MediaItem.file(this.file) : url = null, isExisting = false;
//
//   MediaItem.url(this.url) : file = null, isExisting = true;
//
//   String get path => file?.path ?? url ?? '';
//   bool get isFile => file != null;
//   bool get isUrl => url != null;
// }
//
// class VariantMediaUploadWidget extends StatefulWidget {
//   final String projectId;
//   final String variantId;
//   final ProjectVariant? variant; // Optional variant with existing media
//
//   const VariantMediaUploadWidget({
//     super.key,
//     required this.projectId,
//     required this.variantId,
//     this.variant,
//   });
//
//   @override
//   State<VariantMediaUploadWidget> createState() =>
//       _VariantMediaUploadWidgetState();
// }
//
// class _VariantMediaUploadWidgetState extends State<VariantMediaUploadWidget> {
//   final ImagePicker _picker = ImagePicker();
//   List<MediaItem> _images = [];
//   List<MediaItem> _videos = [];
//   bool _isUploading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadExistingMedia();
//   }
//
//   void _loadExistingMedia() {
//     if (widget.variant != null) {
//       setState(() {
//         // Load existing images from URLs
//         _images =
//             widget.variant!.images.map((url) => MediaItem.url(url)).toList();
//
//         // Load existing videos from URLs
//         _videos =
//             widget.variant!.videos.map((url) => MediaItem.url(url)).toList();
//       });
//     }
//   }
//
//   Future<void> _pickImages() async {
//     try {
//       final List<XFile>? pickedFiles = await _picker.pickMultiImage(
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 80,
//       );
//       if (pickedFiles != null) {
//         setState(() {
//           _images.addAll(pickedFiles.map((x) => MediaItem.file(File(x.path))));
//           if (_images.length > 5) _images = _images.sublist(0, 5);
//         });
//       }
//     } catch (e) {
//       _showError('Failed to pick images: $e');
//     }
//   }
//
//   Future<void> _pickVideo() async {
//     try {
//       final XFile? pickedFile = await _picker.pickVideo(
//         source: ImageSource.gallery,
//       );
//       if (pickedFile != null) {
//         setState(() {
//           _videos.add(MediaItem.file(File(pickedFile.path)));
//           if (_videos.length > 3) _videos = _videos.sublist(0, 3);
//         });
//       }
//     } catch (e) {
//       _showError('Failed to pick video: $e');
//     }
//   }
//
//   Future<void> _uploadMedia() async {
//     // Get only new files (not existing URLs)
//     final newImages = _images.where((item) => item.isFile).toList();
//     final newVideos = _videos.where((item) => item.isFile).toList();
//
//     if (newImages.isEmpty && newVideos.isEmpty) {
//       _showError('No new media to upload');
//       return;
//     }
//
//     setState(() => _isUploading = true);
//     try {
//       Future<Map<String, String>> header() async {
//         return await ApiConstants.getHeaders();
//       }
//
//       final uri = Uri.parse(
//         '${ApiConstants.builderProject}/${widget.projectId}/${widget.variantId}/media',
//       );
//
//       print("Variant URI: $uri");
//
//       var request = http.MultipartRequest('POST', uri);
//
//       // Add only new images
//       for (var imageItem in newImages) {
//         if (imageItem.file != null) {
//           request.files.add(
//             await http.MultipartFile.fromPath(
//               'variant_images',
//               imageItem.file!.path,
//             ),
//           );
//         }
//       }
//
//       // Add only new videos
//       for (var videoItem in newVideos) {
//         if (videoItem.file != null) {
//           request.files.add(
//             await http.MultipartFile.fromPath(
//               'variant_videos',
//               videoItem.file!.path,
//             ),
//           );
//         }
//       }
//
//       // Add authorization header
//       request.headers.addAll(await header());
//
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Upload successful!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//
//           // Optionally reload existing media or refresh the variant data
//           // You might want to call a callback here to refresh the variant
//         }
//       } else {
//         _showError('Upload failed (${response.statusCode}): $responseBody');
//       }
//     } catch (e) {
//       _showError('Upload error: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isUploading = false);
//       }
//     }
//   }
//
//   void _showError(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.red),
//       );
//     }
//   }
//
//   Widget _buildMediaPreview(List<MediaItem> items, {bool isVideo = false}) {
//     if (items.isEmpty) {
//       return Container(
//         height: 120,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.grey[50],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isVideo
//                   ? Icons.video_library_outlined
//                   : Icons.photo_library_outlined,
//               size: 32,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'No ${isVideo ? 'videos' : 'images'} selected',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               isVideo ? 'Add up to 3 videos' : 'Add up to 5 images',
//               style: TextStyle(color: Colors.grey[400], fontSize: 12),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return SizedBox(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: Stack(
//               children: [
//                 Container(
//                   width: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color:
//                           item.isExisting
//                               ? Colors.blue[300]!
//                               : Colors.grey[300]!,
//                       width: item.isExisting ? 2 : 1,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey[200]!,
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   clipBehavior: Clip.antiAlias,
//                   child: Stack(
//                     children: [
//                       isVideo
//                           ? _buildVideoThumbnail(item)
//                           : _buildImagePreview(item),
//                       // Badge for existing media
//                       if (item.isExisting)
//                         Positioned(
//                           top: 4,
//                           left: 4,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'Saved',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       // Index badge
//                       Positioned(
//                         bottom: 4,
//                         right: 4,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.black54,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${index + 1}/${items.length}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Remove button
//                 Positioned(
//                   top: 4,
//                   right: 4,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (isVideo) {
//                           _videos.removeAt(index);
//                         } else {
//                           _images.removeAt(index);
//                         }
//                       });
//                     },
//                     child: Container(
//                       width: 24,
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color:
//                             item.isExisting
//                                 ? Colors.red.withOpacity(0.8)
//                                 : Colors.black54,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildVideoThumbnail(MediaItem item) {
//     if (item.isUrl) {
//       // For URL videos, show a placeholder with play button
//       return Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             color: Colors.black87,
//             child: const Icon(Icons.videocam, size: 40, color: Colors.white54),
//           ),
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.9),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.play_arrow_rounded,
//               color: Theme.of(context).primaryColor,
//               size: 24,
//             ),
//           ),
//         ],
//       );
//     }
//
//     // For local files, generate thumbnail
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
//           return Container(
//             color: Colors.black87,
//             child: const Icon(Icons.videocam, size: 40, color: Colors.white54),
//           );
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
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.play_arrow_rounded,
//                 color: Theme.of(context).primaryColor,
//                 size: 24,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildImagePreview(MediaItem item) {
//     return InkWell(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder:
//               (context) => Dialog(
//                 child: Stack(
//                   children: [
//                     InteractiveViewer(
//                       child:
//                           item.isUrl
//                               ? Image.network(item.url!, fit: BoxFit.contain)
//                               : Image.file(item.file!, fit: BoxFit.contain),
//                     ),
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.close),
//                         color: Colors.white,
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.black54,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//         );
//       },
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
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.broken_image, size: 40),
//                   );
//                 },
//               )
//               : Image.file(
//                 item.file!,
//                 fit: BoxFit.cover,
//                 width: 120,
//                 height: 120,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.broken_image, size: 40),
//                   );
//                 },
//               ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final hasNewMedia =
//         _images.any((item) => item.isFile) ||
//         _videos.any((item) => item.isFile);
//
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey[200]!),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.perm_media_rounded,
//                   size: 24,
//                   color: theme.primaryColor,
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'Media Upload',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Icon(
//                   Icons.photo_library_outlined,
//                   size: 20,
//                   color: Colors.grey[600],
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Images',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: theme.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${_images.length}/5',
//                     style: TextStyle(
//                       color: theme.primaryColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             _buildMediaPreview(_images),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Icon(
//                   Icons.video_library_outlined,
//                   size: 20,
//                   color: Colors.grey[600],
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Videos',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: theme.primaryColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${_videos.length}/3',
//                     style: TextStyle(
//                       color: theme.primaryColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             _buildMediaPreview(_videos, isVideo: true),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _images.length >= 5 ? null : _pickImages,
//                     icon: const Icon(Icons.add_rounded),
//                     label: const Text('Images'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme.primaryColor.withOpacity(0.1),
//                       foregroundColor: theme.primaryColor,
//                       disabledBackgroundColor: Colors.grey[100],
//                       disabledForegroundColor: Colors.grey[400],
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         side: BorderSide(
//                           color:
//                               _images.length >= 5
//                                   ? Colors.grey[300]!
//                                   : theme.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _videos.length >= 3 ? null : _pickVideo,
//                     icon: const Icon(Icons.add_rounded),
//                     label: const Text('Video'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme.primaryColor.withOpacity(0.1),
//                       foregroundColor: theme.primaryColor,
//                       disabledBackgroundColor: Colors.grey[100],
//                       disabledForegroundColor: Colors.grey[400],
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         side: BorderSide(
//                           color:
//                               _videos.length >= 3
//                                   ? Colors.grey[300]!
//                                   : theme.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (hasNewMedia) ...[
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isUploading ? null : _uploadMedia,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: theme.primaryColor,
//                     foregroundColor: Colors.white,
//                     disabledBackgroundColor: Colors.grey[300],
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child:
//                       _isUploading
//                           ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 12),
//                               Text(
//                                 'Uploading...',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           )
//                           : const Text(
//                             'Upload New Media',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/builder/view/property_detail/widget/variant_media_preview.dart';
import 'package:provider/provider.dart';

import '../../../../../data/network/builder/model/builder_model.dart';
import '../../../controller/variation_media_controller.dart';
import 'package:get/get.dart';

class VariantMediaUploadWidget extends StatefulWidget {
  final String projectId;
  final String variantId;
  final ProjectVariant? variant;
  final VoidCallback? onUploadSuccess;

  const VariantMediaUploadWidget({
    super.key,
    required this.projectId,
    required this.variantId,
    this.variant,
    this.onUploadSuccess,
  });

  @override
  State<VariantMediaUploadWidget> createState() =>
      _VariantMediaUploadWidgetState();
}

class _VariantMediaUploadWidgetState extends State<VariantMediaUploadWidget> {
  late VariantMediaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(VariantMediaController());
    _controller.loadExistingMedia(widget.variant);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  Future<void> _handleUpload() async {
    final success = await _controller.uploadMedia(
      projectId: widget.projectId,
      variantId: widget.variantId,
    );

    if (success) {
      _showMessage('Upload successful!');
      widget.onUploadSuccess?.call();
    } else {
      _showMessage(_controller.errorMessage ?? 'Upload failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<VariantMediaController>(
        builder: (context, controller, child) {
          // Show error messages
          if (controller.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showMessage(controller.errorMessage!, isError: true);
              controller.clearError();
            });
          }

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(theme),
                  const SizedBox(height: 16),

                  // Images Section
                  _buildMediaSection(
                    theme: theme,
                    title: 'Images',
                    icon: Icons.photo_library_outlined,
                    count: controller.imagesCount,
                    maxCount: 5,
                    items: controller.images,
                    onRemove: controller.removeImage,
                    projectId: widget.projectId,
                    variantId: widget.variantId,
                  ),
                  const SizedBox(height: 16),

                  // Videos Section
                  _buildMediaSection(
                    theme: theme,
                    title: 'Videos',
                    icon: Icons.video_library_outlined,
                    count: controller.videosCount,
                    maxCount: 3,
                    items: controller.videos,
                    onRemove: controller.removeVideo,
                    isVideo: true,
                    projectId: widget.projectId,
                    variantId: widget.variantId,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(theme, controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.perm_media_rounded, size: 24, color: theme.primaryColor),
        const SizedBox(width: 12),
        Text(
          'Media Upload',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required int count,
    required int maxCount,
    required List<MediaItem> items,
    required Function(int) onRemove,
    required String projectId,
    required String variantId,
    bool isVideo = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count/$maxCount',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        MediaPreviewList(
          items: items,
          isVideo: isVideo,
          onRemove: onRemove,
          projectId: projectId,
          variantId: variantId,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    ThemeData theme,
    VariantMediaController controller,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    controller.imagesCount >= 5
                        ? null
                        : () => controller.pickImages(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Images'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  foregroundColor: theme.primaryColor,
                  disabledBackgroundColor: Colors.grey[100],
                  disabledForegroundColor: Colors.grey[400],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          controller.imagesCount >= 5
                              ? Colors.grey[300]!
                              : theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    controller.videosCount >= 3
                        ? null
                        : () => controller.pickVideo(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  foregroundColor: theme.primaryColor,
                  disabledBackgroundColor: Colors.grey[100],
                  disabledForegroundColor: Colors.grey[400],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          controller.videosCount >= 3
                              ? Colors.grey[300]!
                              : theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (controller.hasNewMedia) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isUploading ? null : _handleUpload,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  controller.isUploading
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Uploading...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      : const Text(
                        'Upload New Media',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
            ),
          ),
        ],
      ],
    );
  }
}

// widgets/media_preview_list.dart
class MediaPreviewList extends StatelessWidget {
  final List<MediaItem> items;
  final String projectId;
  final String variantId;
  final bool isVideo;
  final Function(int) onRemove;

  const MediaPreviewList({
    super.key,
    required this.items,
    required this.isVideo,
    required this.onRemove,
    required this.projectId,
    required this.variantId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VariantMediaController>();

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return MediaPreviewItem(
            item: items[index],
            index: index,
            totalCount: items.length,
            isVideo: isVideo,
            onRemove: () async {
              if (items[index].isExisting) {
                final success = await controller.removeMedia(
                  projectId: projectId,
                  variantId: variantId,
                  mediaType: isVideo ? 'video' : 'image',
                  mediaUrl: items[index].url!,
                );
                if (success) {
                  onRemove(index);
                }
              } else {
                onRemove(index);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isVideo
                ? Icons.video_library_outlined
                : Icons.photo_library_outlined,
            size: 32,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'No ${isVideo ? 'videos' : 'images'} selected',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            isVideo ? 'Add up to 3 videos' : 'Add up to 5 images',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
