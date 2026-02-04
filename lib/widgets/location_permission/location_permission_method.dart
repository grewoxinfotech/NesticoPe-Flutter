import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Future<String?> getCurrentCity() async {
//   // Step 1: Request permission
//   var status = await Permission.location.status;
//   if (status.isDenied || status.isRestricted) {
//     status = await Permission.location.request();
//   }
//
//   // If still denied or permanently denied, just return null
//   if (status.isDenied || status.isPermanentlyDenied) {
//     return null;
//   }
//
//   // Step 2: Check if location services are enabled
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return null;
//   }
//
//   // Step 3: Get current position
//   Position position = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );
//
//   // Step 4: Get placemarks from coordinates
//   List<Placemark> placemarks = await placemarkFromCoordinates(
//     position.latitude,
//     position.longitude,
//   );
//
//   // Step 5: Extract city name
//   if (placemarks.isNotEmpty) {
//     final city = placemarks.first.locality;
//     print("🏙️ Current City: $city");
//     return city;
//   }
//
//   return null;
// }

Future<String?> getCurrentCity() async {
  // 1️⃣ Check if location services are enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // 2️⃣ Check permission
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  // 3️⃣ Get position
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // 4️⃣ Reverse geocoding
  final placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    return placemarks.first.locality;
  }

  return null;
}

// Future<bool> requestGalleryPermission() async {
//   // Check current permission status
//   final status = await Permission.photos.status;
//
//   if (status.isGranted) {
//     return true; // already granted
//   }
//
//   // Request permission
//   final result = await Permission.photos.request();
//
//   if (result.isGranted) {
//     return true;
//   } else if (result.isPermanentlyDenied) {
//     // Open app settings if permission is permanently denied
//     await openAppSettings();
//   }
//
//   return false;
// }

Future<bool> requestGalleryPermission() async {
  Permission permission;

  if (Platform.isAndroid) {
    final sdkInt = await DeviceInfoPlugin().androidInfo.then(
      (v) => v.version.sdkInt,
    );

    permission = sdkInt >= 33 ? Permission.photos : Permission.storage;
  } else if (Platform.isIOS) {
    permission = Permission.photos;
  } else {
    return false;
  }

  final status = await permission.status;

  if (status.isGranted || status.isLimited) {
    return true;
  }

  final result = await permission.request();

  if (result.isGranted || result.isLimited) {
    return true;
  }

  if (result.isPermanentlyDenied) {
    await openAppSettings();
  }

  return false;
}

// Future<bool> requestStoragePermission() async {
//   // Check current permission status
//   final status = await Permission.storage.status;
//
//   if (status.isGranted) {
//     return true; // already granted
//   }
//
//   // Request permission
//   final result = await Permission.storage.request();
//
//   if (result.isGranted) {
//     return true;
//   } else if (result.isPermanentlyDenied) {
//     // Open app settings if permission is permanently denied
//     await openAppSettings();
//   }
//
//   return false;
// }

Future<bool> requestStoragePermission() async {
  if (!Platform.isAndroid) return true;

  final status = await Permission.storage.status;

  if (status.isGranted) {
    return true;
  }

  final result = await Permission.storage.request();

  if (result.isGranted) {
    return true;
  }

  if (result.isPermanentlyDenied) {
    await openAppSettings();
  }

  return false;
}

// Future<bool> requestCameraPermission() async {
//   // Check current permission status
//   final status = await Permission.camera.status;
//
//   if (status.isGranted) {
//     return true; // already granted
//   }
//
//   // Request permission
//   final result = await Permission.camera.request();
//
//   if (result.isGranted) {
//     return true;
//   } else if (result.isPermanentlyDenied) {
//     // Open app settings if permission is permanently denied
//     await Permission.camera.request();
//   }
//
//   return false;
// }

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  }

  final result = await Permission.camera.request();

  if (result.isGranted) {
    return true;
  }

  if (result.isPermanentlyDenied) {
    await openAppSettings();
  }

  return false;
}
