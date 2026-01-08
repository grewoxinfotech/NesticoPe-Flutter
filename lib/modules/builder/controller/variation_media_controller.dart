// import 'package:flutter/foundation.dart';
//
// import '../../../data/network/builder/model/builder_model.dart';
// import '../../../data/network/builder/service/variation_media_service.dart';
//
// class VariantMediaController extends ChangeNotifier {
//   final MediaUploadService _mediaService = MediaUploadService();
//
//   List<MediaItem> _images = [];
//   List<MediaItem> _videos = [];
//   MediaItem? _model;
//
//   bool _isUploading = false;
//   String? _errorMessage;
//
//   // -------------------- Getters --------------------
//
//   List<MediaItem> get images => _images;
//   List<MediaItem> get videos => _videos;
//   MediaItem? get model => _model;
//
//   bool get isUploading => _isUploading;
//   String? get errorMessage => _errorMessage;
//
//   int get imagesCount => _images.length;
//   int get videosCount => _videos.length;
//
//   bool get hasModel => _model != null;
//   bool get hasNewModel => _model?.isFile == true;
//
//   bool get hasNewMedia =>
//       _images.any((item) => item.isFile) ||
//           _videos.any((item) => item.isFile) ||
//           _model?.isFile == true;
//
//   // -------------------- Load Existing Media --------------------
//
//   void loadExistingMedia(ProjectVariant? variant) {
//     if (variant != null) {
//       _images = variant.images.map((url) => MediaItem.url(url)).toList();
//       _videos = variant.videos.map((url) => MediaItem.url(url)).toList();
//       notifyListeners();
//     }
//   }
//
//   // Load existing 3D model
//   void loadExistingModel(String? modelUrl) {
//     if (modelUrl != null && modelUrl.isNotEmpty) {
//       _model = MediaItem.url(modelUrl);
//       notifyListeners();
//     }
//   }
//
//   // -------------------- Pick Images --------------------
//
//   Future<void> pickImages({int maxImages = 5}) async {
//     try {
//       if (_images.length >= maxImages) {
//         _errorMessage = 'Maximum $maxImages images allowed';
//         notifyListeners();
//         return;
//       }
//
//       final files = await _mediaService.pickImages();
//       if (files.isNotEmpty) {
//         _images.addAll(files.map((f) => MediaItem.file(f)));
//         if (_images.length > maxImages) {
//           _images = _images.sublist(0, maxImages);
//         }
//         _errorMessage = null;
//         notifyListeners();
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//       notifyListeners();
//     }
//   }
//
//   // -------------------- Pick Video --------------------
//
//   Future<void> pickVideo({int maxVideos = 3}) async {
//     try {
//       if (_videos.length >= maxVideos) {
//         _errorMessage = 'Maximum $maxVideos videos allowed';
//         notifyListeners();
//         return;
//       }
//
//       final file = await _mediaService.pickVideo();
//       if (file != null) {
//         _videos.add(MediaItem.file(file));
//         if (_videos.length > maxVideos) {
//           _videos = _videos.sublist(0, maxVideos);
//         }
//         _errorMessage = null;
//         notifyListeners();
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//       notifyListeners();
//     }
//   }
//
//   // -------------------- Pick 3D Model --------------------
//
//   Future<void> pick3DModel() async {
//     try {
//       if (_model != null) {
//         _errorMessage = 'Only one 3D model is allowed';
//         notifyListeners();
//         return;
//       }
//
//       final file = await _mediaService.pick3DModel();
//       if (file != null) {
//         _model = MediaItem.file(file);
//         _errorMessage = null;
//         notifyListeners();
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//       notifyListeners();
//     }
//   }
//
//   // -------------------- Remove Media --------------------
//
//   void removeImage(int index) {
//     if (index >= 0 && index < _images.length) {
//       _images.removeAt(index);
//       notifyListeners();
//     }
//   }
//
//   void removeVideo(int index) {
//     if (index >= 0 && index < _videos.length) {
//       _videos.removeAt(index);
//       notifyListeners();
//     }
//   }
//
//   void remove3DModel(int index) {
//     _model = null;
//     notifyListeners();
//   }
//
//   // -------------------- Upload Media --------------------
//
//   Future<bool> uploadMedia({
//     required String projectId,
//     required String variantId,
//   }) async {
//     final newImages =
//     _images.where((item) => item.isFile).map((item) => item.file!).toList();
//
//     final newVideos =
//     _videos.where((item) => item.isFile).map((item) => item.file!).toList();
//
//     final newModel = _model?.isFile == true ? _model!.file : null;
//
//     if (newImages.isEmpty && newVideos.isEmpty && newModel == null) {
//       _errorMessage = 'No new media to upload';
//       notifyListeners();
//       return false;
//     }
//
//     _isUploading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final result = await _mediaService.uploadMediaFiles(
//         projectId: projectId,
//         variantId: variantId,
//         images: newImages,
//         videos: newVideos,
//         model: newModel,
//       );
//
//       if (result['success'] == true) {
//         _isUploading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _errorMessage = result['message'] ?? 'Upload failed';
//         _isUploading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _errorMessage = 'Upload error: $e';
//       _isUploading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // -------------------- Remove Media from Server --------------------
//
//   Future<bool> removeMedia({
//     required String projectId,
//     required String variantId,
//     required String mediaType,
//     required String mediaUrl,
//   }) async {
//     _isUploading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final result = await _mediaService.removeVariantMedia(
//         projectId: projectId,
//         variantId: variantId,
//         mediaType: mediaType,
//         mediaUrl: mediaUrl,
//       );
//
//       if (result['success'] == true) {
//         _isUploading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _errorMessage = result['message'] ?? 'Delete failed';
//         _isUploading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _errorMessage = 'Delete error: $e';
//       _isUploading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // -------------------- Helpers --------------------
//
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
//
//   void reset() {
//     _images.clear();
//     _videos.clear();
//     _model = null;
//     _errorMessage = null;
//     _isUploading = false;
//     notifyListeners();
//   }
// }


import 'package:flutter/foundation.dart';

import '../../../data/network/builder/model/builder_model.dart';
import '../../../data/network/builder/service/variation_media_service.dart';

class VariantMediaController extends ChangeNotifier {
  final MediaUploadService _mediaService = MediaUploadService();

  List<MediaItem> _images = [];
  List<MediaItem> _videos = [];
  MediaItem? _model;

  bool _isUploading = false;
  String? _errorMessage;

  // -------------------- Getters --------------------

  List<MediaItem> get images => _images;
  List<MediaItem> get videos => _videos;
  MediaItem? get model => _model;

  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;

  int get imagesCount => _images.length;
  int get videosCount => _videos.length;

  bool get hasModel => _model != null;
  bool get hasNewModel => _model?.isFile == true;

  bool get hasNewMedia =>
      _images.any((item) => item.isFile) ||
          _videos.any((item) => item.isFile) ||
          _model?.isFile == true;

  // -------------------- Load Existing Media --------------------

  void loadExistingMedia(ProjectVariant? variant) {
    if (variant != null) {
      _images = variant.images.map((url) => MediaItem.url(url)).toList();
      _videos = variant.videos.map((url) => MediaItem.url(url)).toList();

      // Load existing 3D model if available
      if (variant.models.isNotEmpty) {
        _model = MediaItem.url(variant.models.first);
      }

      notifyListeners();
    }
  }

  // Load existing 3D model (alternative method if needed separately)
  void loadExistingModel(String? modelUrl) {
    if (modelUrl != null && modelUrl.isNotEmpty) {
      _model = MediaItem.url(modelUrl);
      notifyListeners();
    }
  }

  // -------------------- Pick Images --------------------

  Future<void> pickImages({int maxImages = 5}) async {
    try {
      if (_images.length >= maxImages) {
        _errorMessage = 'Maximum $maxImages images allowed';
        notifyListeners();
        return;
      }

      final files = await _mediaService.pickImages();
      if (files.isNotEmpty) {
        final remainingSlots = maxImages - _images.length;
        final filesToAdd = files.take(remainingSlots).toList();
        _images.addAll(filesToAdd.map((f) => MediaItem.file(f)));
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // -------------------- Pick Video --------------------

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
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // -------------------- Pick 3D Model --------------------

  Future<void> pick3DModel() async {
    try {
      if (_model != null) {
        _errorMessage = 'Only one 3D model is allowed. Please remove the existing one first.';
        notifyListeners();
        return;
      }

      final file = await _mediaService.pick3DModel();
      if (file != null) {
        // Validate file extension
        final fileName = file.path.toLowerCase();
        final validExtensions = ['.glb', '.gltf', '.fbx', '.obj', '.stl', '.dae'];
        final isValid = validExtensions.any((ext) => fileName.endsWith(ext));

        if (!isValid) {
          _errorMessage = 'Invalid file format. Please select a valid 3D model file (GLB, GLTF, FBX, OBJ, STL, DAE)';
          notifyListeners();
          return;
        }

        _model = MediaItem.file(file);
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // -------------------- Remove Media --------------------

  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  void removeVideo(int index) {
    if (index >= 0 && index < _videos.length) {
      _videos.removeAt(index);
      notifyListeners();
    }
  }

  void remove3DModel(int index) {
    _model = null;
    notifyListeners();
  }

  // -------------------- Upload Media --------------------

  Future<bool> uploadMedia({
    required String projectId,
    required String variantId,
  }) async {
    final newImages =
    _images.where((item) => item.isFile).map((item) => item.file!).toList();

    final newVideos =
    _videos.where((item) => item.isFile).map((item) => item.file!).toList();

    final newModel = _model?.isFile == true ? _model!.file : null;

    if (newImages.isEmpty && newVideos.isEmpty && newModel == null) {
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
        model: newModel,
      );

      if (result['success'] == true) {
        // Convert uploaded files to URL items after successful upload
        if (newImages.isNotEmpty) {
          _images = _images.map((item) {
            if (item.isFile) {
              // In a real scenario, you'd get the URL from the server response
              return item; // Keep as is, or update with server URL if available
            }
            return item;
          }).toList();
        }

        if (newVideos.isNotEmpty) {
          _videos = _videos.map((item) {
            if (item.isFile) {
              return item; // Keep as is, or update with server URL if available
            }
            return item;
          }).toList();
        }

        if (newModel != null && _model != null) {
          // Keep the model as is, or update with server URL if available
          // _model = MediaItem.url(serverReturnedUrl);
        }

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

  // -------------------- Remove Media from Server --------------------

  Future<bool> removeMedia({
    required String projectId,
    required String variantId,
    required String mediaType,
    required String mediaUrl,
  }) async {
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

  // -------------------- Helpers --------------------

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _images.clear();
    _videos.clear();
    _model = null;
    _errorMessage = null;
    _isUploading = false;
    notifyListeners();
  }
}