import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  if (GetPlatform.isAndroid) {
    final sdkInt = await DeviceInfoPlugin().androidInfo.then(
      (v) => v.version.sdkInt,
    );
    if (sdkInt >= 33) return true;
    final permission = Permission.storage;

    final status = await permission.status;
    if (status.isGranted || status.isLimited) return true;

    final result = await permission.request();
    return result.isGranted || result.isLimited;
  } else if (GetPlatform.isIOS) {
    if (await Permission.photos.isGranted) return true;
    var result = await Permission.photos.request();
    return result.isGranted;
  }
  return false;
}
