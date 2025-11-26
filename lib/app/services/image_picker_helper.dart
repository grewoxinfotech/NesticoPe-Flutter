import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
// import 'dart:io';
import 'package:path/path.dart' as p;

Future<List<ImageFile>> pickImagesUsingImagePicker(int pickCount) async {
  final ImagePicker picker = ImagePicker();
  final List<XFile>? files = await picker.pickMultiImage();

  if (files == null || files.isEmpty) return [];

  return files.map((file) {
    final fileName = p.basename(file.path); // e.g., image.jpg
    final ext = p.extension(file.path).replaceFirst('.', ''); // e.g., "jpg"
    return ImageFile(
      file.path, // key
      name: fileName, // required
      extension: ext, // required
      path: file.path, // optional, but we have it
    );
  }).toList();
}
