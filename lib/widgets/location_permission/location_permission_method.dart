import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';

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

/// Resolves locality from GPS + geocoding. Triggers the system location
/// permission dialog when needed. Does not read cached city from storage.
Future<String?> getCurrentCityFromDevice() async {
  var serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.denied) {
    await openAppSettings();
    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      return null;
    }
  }

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );

  final placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isEmpty) return null;

  print(
    "Market App Current City: $placemarks    ${placemarks.first.locality ?? ""}   ${position.latitude}   ${position.longitude}",
  );
  print("Market App Current City: ${placemarks.first.locality ?? ""}");
  print(
    "Market App Current City: ${position.latitude}   ${position.longitude}",
  );
  print("Market App Current City: ${position.accuracy}");
  print("Market App Current City: ${position.speed}");
  print(
    "Market App Current City: ${placemarks.map((e) => e.toJson()).toList()}",
  );
  print("Market App Current City: ${position.toJson()}");

  return placemarks.first.locality;
}

Future<String?> getCurrentCity() async {
  // If a city was already chosen via SelectCityScreen, return it immediately
  // to avoid asking for location permissions repeatedly.
  try {
    final savedCity = await SecureStorage.getSelectedCity();
    if (savedCity != null && savedCity.isNotEmpty) return savedCity;
  } catch (_) {}

  return getCurrentCityFromDevice();
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

  var status = await permission.status;

  if (status.isGranted || status.isLimited) {
    return true;
  }

  final result = await permission.request();

  if (result.isGranted || result.isLimited) {
    return true;
  }

  if (result.isPermanentlyDenied) {
    await openAppSettings();
    status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }
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

  final permission = Permission.storage;
  var status = await permission.status;

  if (status.isGranted) {
    return true;
  }

  final result = await permission.request();

  if (result.isGranted) {
    return true;
  }

  if (result.isPermanentlyDenied) {
    await openAppSettings();
    status = await permission.status;
    if (status.isGranted) {
      return true;
    }
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
  final permission = Permission.camera;
  var status = await permission.status;

  if (status.isGranted) {
    return true;
  }

  final result = await permission.request();

  if (result.isGranted) {
    return true;
  }

  if (result.isPermanentlyDenied) {
    await openAppSettings();
    status = await permission.status;
    if (status.isGranted) {
      return true;
    }
  }

  return false;
}
