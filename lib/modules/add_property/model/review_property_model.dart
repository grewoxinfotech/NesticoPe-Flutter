// ...existing code...
import 'package:housing_flutter_app/modules/add_property/model/photo_model.dart';
import 'package:housing_flutter_app/modules/add_property/model/room_detail_model.dart';

class PropertyReviewModel {
  final bool isOwner;
  final String propertyType;
  final String lookingTo;
  final String countryCode;
  final String phone;
  final String name;
  final String city;
  final String locality;
  final String pgName;
  final String totalRooms;
  final String noticePeriod;
  final String lockPeriod;
  final List<RoomModel> rooms;
  final List<PhotoImageModel> images;
  final List<String> bestSuitedList;
  final List<String> commonAreasList;
  final List<String> mealAvailableList;

  PropertyReviewModel({
    required this.isOwner,
    required this.propertyType,
    required this.lookingTo,
    required this.countryCode,
    required this.phone,
    required this.name,
    required this.city,
    required this.locality,
    required this.pgName,
    required this.totalRooms,
    required this.noticePeriod,
    required this.lockPeriod,
    required this.rooms,
    required this.images,
    required this.bestSuitedList,
    required this.commonAreasList,
    required this.mealAvailableList,
  });

  Map<String, dynamic> toMap() {
    return {
      'isOwner': isOwner,
      'propertyType': propertyType,
      'lookingTo': lookingTo,
      'countryCode': countryCode,
      'phone': phone,
      'name': name,
      'city': city,
      'locality': locality,
      'pgName': pgName,
      'totalRooms': totalRooms,
      'noticePeriod': noticePeriod,
      'lockPeriod': lockPeriod,
      'rooms': rooms.map((e) => e.toMap()).toList(),
      'images': images.map((e) => e.toMap()).toList(),
      'bestSuitedList': bestSuitedList,
      'commonAreasList': commonAreasList,
      'mealAvailableList': mealAvailableList,
    };
  }
}
// ...existing code...