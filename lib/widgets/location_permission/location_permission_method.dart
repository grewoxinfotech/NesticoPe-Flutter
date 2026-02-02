import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<String?> getCurrentCity() async {
  // Step 1: Request permission
  var status = await Permission.location.status;
  if (status.isDenied || status.isRestricted) {
    status = await Permission.location.request();
  }

  // If still denied or permanently denied, just return null
  if (status.isDenied || status.isPermanentlyDenied) {
    return null;
  }

  // Step 2: Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Step 3: Get current position
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Step 4: Get placemarks from coordinates
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  // Step 5: Extract city name
  if (placemarks.isNotEmpty) {
    final city = placemarks.first.locality;
    print("🏙️ Current City: $city");
    return city;
  }

  return null;
}


Future<bool> requestGalleryPermission() async {
  // Check current permission status
  final status = await Permission.photos.status;

  if (status.isGranted) {
    return true; // already granted
  }

  // Request permission
  final result = await Permission.photos.request();

  if (result.isGranted) {
    return true;
  } else if (result.isPermanentlyDenied) {
    // Open app settings if permission is permanently denied
    await openAppSettings();
  }

  return false;
}
Future<bool> requestStoragePermission() async {
  // Check current permission status
  final status = await Permission.storage.status;

  if (status.isGranted) {
    return true; // already granted
  }

  // Request permission
  final result = await Permission.storage.request();

  if (result.isGranted) {
    return true;
  } else if (result.isPermanentlyDenied) {
    // Open app settings if permission is permanently denied
    await openAppSettings();
  }

  return false;
}

Future<bool> requestCameraPermission() async {
  // Check current permission status
  final status = await Permission.camera.status;

  if (status.isGranted) {
    return true; // already granted
  }

  // Request permission
  final result = await Permission.camera.request();

  if (result.isGranted) {
    return true;
  }
  else if (result.isPermanentlyDenied) {
    // Open app settings if permission is permanently denied
    await Permission.camera.request();
  }

  return false;
}