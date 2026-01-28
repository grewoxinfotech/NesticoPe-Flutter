import 'dart:io';
import 'dart:typed_data';

import 'package:housing_flutter_app/widgets/location_permission/location_permission_method.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

// import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<List<ImageFile>> pickImagesUsingImagePicker(int pickCount) async {
  bool isGranted = await requestGalleryPermission();
  if (isGranted) {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? files = await picker.pickMultiImage();

    if (files == null || files.isEmpty) return [];

    return Future.wait(
      files.map((file) async {
        final fileName = p.basename(file.path); // e.g., image.jpg
        final ext = p.extension(file.path).replaceFirst('.', ''); // e.g., "jpg"

        final bytes = await file.readAsBytes();

        return ImageFile(
          file.path, // key
          name: fileName, // required
          extension: ext, // required
          path: file.path, // optional, but we have it
          bytes: bytes,
        );
      }).toList(),
    );
  }
  return [];
}

Future<File> uint8ListToFile(Uint8List bytes, String fileName) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$fileName');
  return await file.writeAsBytes(bytes);
}
