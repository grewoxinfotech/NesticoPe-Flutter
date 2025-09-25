import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  if (GetPlatform.isAndroid) {
    if (await Permission.storage.isGranted) return true;
    var result = await Permission.storage.request();
    return result.isGranted;
  } else if (GetPlatform.isIOS) {
    if (await Permission.photos.isGranted) return true;
    var result = await Permission.photos.request();
    return result.isGranted;
  }
  return false;
}
