import 'package:flutter/foundation.dart';

import '../../../data/network/builder/model/builder_model.dart';
import '../../../data/network/builder/service/variation_media_service.dart';

class VariantMediaController extends ChangeNotifier {
  final MediaUploadService _mediaService = MediaUploadService();

  List<MediaItem> _images = [];
  List<MediaItem> _videos = [];
  bool _isUploading = false;
  String? _errorMessage;

  // Getters
  List<MediaItem> get images => _images;
  List<MediaItem> get videos => _videos;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;

  int get imagesCount => _images.length;
  int get videosCount => _videos.length;

  bool get hasNewMedia =>
      _images.any((item) => item.isFile) || _videos.any((item) => item.isFile);

  // Load existing media from variant
  void loadExistingMedia(ProjectVariant? variant) {
    if (variant != null) {
      _images = variant.images.map((url) => MediaItem.url(url)).toList();
      _videos = variant.videos.map((url) => MediaItem.url(url)).toList();
      notifyListeners();
    }
  }

  // Pick images
  Future<void> pickImages({int maxImages = 5}) async {
    try {
      if (_images.length >= maxImages) {
        _errorMessage = 'Maximum $maxImages images allowed';
        notifyListeners();
        return;
      }

      final files = await _mediaService.pickImages();
      if (files.isNotEmpty) {
        _images.addAll(files.map((f) => MediaItem.file(f)));
        if (_images.length > maxImages) {
          _images = _images.sublist(0, maxImages);
        }
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Pick video
  Future<void> pickVideo({int maxVideos = 3}) async {
    try {
      if (_videos.length >= maxVideos) {
        _errorMessage = 'Maximum $maxVideos videos allowed';
        notifyListeners();
        return;
      }

      final file = await _mediaService.pickVideo();
      if (file != null) {
        _videos.add(MediaItem.file(file));
        if (_videos.length > maxVideos) {
          _videos = _videos.sublist(0, maxVideos);
        }
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Remove image
  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  // Remove video
  void removeVideo(int index) {
    if (index >= 0 && index < _videos.length) {
      _videos.removeAt(index);
      notifyListeners();
    }
  }

  // Upload media
  Future<bool> uploadMedia({
    required String projectId,
    required String variantId,
  }) async {
    // Get only new files
    final newImages =
        _images.where((item) => item.isFile).map((item) => item.file!).toList();
    final newVideos =
        _videos.where((item) => item.isFile).map((item) => item.file!).toList();

    if (newImages.isEmpty && newVideos.isEmpty) {
      _errorMessage = 'No new media to upload';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _mediaService.uploadMediaFiles(
        projectId: projectId,
        variantId: variantId,
        images: newImages,
        videos: newVideos,
      );

      if (result['success'] == true) {
        // Optionally convert uploaded files to URLs here if backend returns them
        _isUploading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Upload failed';
        _isUploading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Upload error: $e';
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeMedia({
    required String projectId,
    required String variantId,
    required String mediaType,
    required String mediaUrl,
  }) async {
    // Get only new files

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _mediaService.removeVariantMedia(
        projectId: projectId,
        variantId: variantId,
        mediaType: mediaType,
        mediaUrl: mediaUrl,
      );

      if (result['success'] == true) {
        // Optionally convert uploaded files to URLs here if backend returns them
        _isUploading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Delete failed';
        _isUploading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Delete error: $e';
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset all media
  void reset() {
    _images.clear();
    _videos.clear();
    _errorMessage = null;
    _isUploading = false;
    notifyListeners();
  }
}
