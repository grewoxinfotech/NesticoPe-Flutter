import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/svg_res.dart';

class IconItem {
  final String key; // e.g. AppSvgRes.office
  final String title; // e.g. "Office"
  final IconData icon;
  final bool isMultiChoice;
  // fallback Material Icon

  IconItem({
    required this.key,
    required this.title,
    required this.icon,
    this.isMultiChoice = false,
  });
}

class IconManager {
  IconManager._();

  static final List<IconItem> items = [
    IconItem(key: AppSvgRes.area, title: "Plot", icon: Icons.square_foot),
    IconItem(
      key: AppSvgRes.circleDots,
      title: "Others",
      icon: Icons.blur_circular,
    ),
    IconItem(key: AppSvgRes.office, title: "Office", icon: Icons.business),
    IconItem(
      key: AppSvgRes.showroom,
      title: "Showroom",
      icon: Icons.storefront,
    ),
    IconItem(key: AppSvgRes.shop, title: "Shop", icon: Icons.shopping_bag),
    IconItem(
      key: AppSvgRes.warehouse,
      title: "Warehouse",
      icon: Icons.warehouse,
    ),
  ];
  static final List<IconItem> amenities = [
    IconItem(
      key: AppSvgRes.cafeterai,
      title: "Cafeteria",
      icon: Icons.local_cafe,
    ),
    IconItem(
      key: AppSvgRes.centralair,
      title: "Central Air Conditioning",
      icon: Icons.ac_unit,
    ),
    IconItem(
      key: AppSvgRes.aminentfurniture,
      title: "Furnishing",
      icon: Icons.chair_alt,
    ),
    IconItem(
      key: AppSvgRes.dg,
      title: "DG Availability",
      icon: Icons.electrical_services,
    ),
    IconItem(
      key: AppSvgRes.battery,
      title: "Power Backup",
      icon: Icons.battery_charging_full,
    ),
    IconItem(key: AppSvgRes.cctv, title: "CCTV", icon: Icons.videocam),
    IconItem(key: AppSvgRes.duct, title: "Oxygen Duct", icon: Icons.wind_power),
    IconItem(
      key: AppSvgRes.fire_alarm,
      title: "Fire senseor",
      icon: Icons.notification_important,
    ),
    IconItem(
      key: AppSvgRes.fire_extinguisher,
      title: "Fire Extinguisher",
      icon: Icons.fire_extinguisher,
    ),
    IconItem(
      key: AppSvgRes.fire_noc_certified,
      title: "Fire NOC Certified",
      icon: Icons.verified,
    ),
    IconItem(
      key: AppSvgRes.internet_connectivity,
      title: "Internet Connectivity",
      icon: Icons.wifi,
    ),
    IconItem(
      key: AppSvgRes.occupery_certificate,
      title: "Occupancy Certificate",
      icon: Icons.assignment_turned_in,
    ),
    IconItem(key: AppSvgRes.pantry, title: "Pantry", icon: Icons.kitchen),
    IconItem(
      key: AppSvgRes.reception,
      title: "Reception Area",
      icon: Icons.support_agent,
    ),
    IconItem(
      key: AppSvgRes.security,
      title: "Security Personnel",
      icon: Icons.security,
    ),
    IconItem(key: AppSvgRes.ups, title: "UPS", icon: Icons.power),
    IconItem(
      key: AppSvgRes.vastu,
      title: "Vastu Compliant",
      icon: Icons.temple_hindu,
    ),
    IconItem(
      key: AppSvgRes.water_storage,
      title: "Water Storage",
      icon: Icons.water,
    ),
    IconItem(
      key: AppSvgRes.swimming,
      title: "Swimming Pool",
      icon: Icons.water,
    ),
  ];
  static final List<IconItem> amenitiesDivided = [
    IconItem(
      key: AppSvgRes.cafeterai,
      title: "Cafeteria",
      icon: Icons.local_cafe,
    ),
    //IconItem(key: AppSvgRes.centralair, title: "Central Air Conditioning", icon: Icons.ac_unit),
    //IconItem(key: AppSvgRes.aminentfurniture, title: "Furnishing", icon: Icons.chair_alt),
    IconItem(
      key: AppSvgRes.dg,
      title: "DG Availability",
      icon: Icons.electrical_services,
    ),
    IconItem(
      key: AppSvgRes.battery,
      title: "Power Backup",
      icon: Icons.battery_charging_full,
    ),
    IconItem(key: AppSvgRes.cctv, title: "CCTV", icon: Icons.videocam),
    //IconItem(key: AppSvgRes.duct, title: "Oxygen Duct", icon: Icons.wind_power),
    //IconItem(key: AppSvgRes.fire_alarm, title: "Fire senseor", icon: Icons.notification_important),
    //IconItem(key: AppSvgRes.fire_extinguisher, title: "Fire Extinguisher", icon: Icons.fire_extinguisher),
    //IconItem(key: AppSvgRes.fire_noc_certified, title: "Fire NOC Certified", icon: Icons.verified),
    IconItem(
      key: AppSvgRes.internet_connectivity,
      title: "Internet Connectivity",
      icon: Icons.wifi,
    ),
    // IconItem(key: AppSvgRes.occupery_certificate, title: "Occupancy Certificate", icon: Icons.assignment_turned_in),
    //IconItem(key: AppSvgRes.pantry, title: "Pantry", icon: Icons.kitchen),
    //IconItem(key: AppSvgRes.reception, title: "Reception Area", icon: Icons.support_agent),
    IconItem(
      key: AppSvgRes.security,
      title: "Security Personnel",
      icon: Icons.security,
    ),
    //IconItem(key: AppSvgRes.ups, title: "UPS", icon: Icons.power),
    IconItem(
      key: AppSvgRes.vastu,
      title: "Vastu Compliant",
      icon: Icons.temple_hindu,
    ),
    IconItem(
      key: AppSvgRes.water_storage,
      title: "Water Storage",
      icon: Icons.water,
    ),
  ];

  static final List<IconItem> furnitureItems = [
    // ---------- Boolean Furnishings ----------
    IconItem(
      key: AppSvgRes.table,
      title: "Dining Table",
      icon: Icons.table_restaurant,
    ),
    IconItem(
      key: AppSvgRes.washing,
      title: "Washing Machine",
      icon: Icons.local_laundry_service,
    ),
    IconItem(key: AppSvgRes.cupboard, title: "Cupboard", icon: Icons.cabin),
    IconItem(key: AppSvgRes.sofa, title: "Sofa", icon: Icons.chair_alt),
    IconItem(
      key: AppSvgRes.microwave,
      title: "Microwave",
      icon: Icons.microwave_outlined,
    ),
    IconItem(
      key: AppSvgRes.stove,
      title: "Stove",
      icon: Icons.local_fire_department,
    ),
    IconItem(key: AppSvgRes.refrigerate, title: "Fridge", icon: Icons.kitchen),
    IconItem(
      key: AppSvgRes.water_purifier,
      title: "Water Purifier",
      icon: Icons.water_drop,
    ),
    IconItem(
      key: AppSvgRes.gas_pipeline,
      title: "Gas Pipeline",
      icon: Icons.gas_meter,
    ),
    IconItem(key: AppSvgRes.chimney, title: "Chimney", icon: Icons.wind_power),
    IconItem(
      key: AppSvgRes.modular_kitchen,
      title: "Modular Kitchen",
      icon: Icons.kitchen_outlined,
    ),

    // ---------- Number Furnishings (Multi-choice) ----------
    IconItem(
      key: AppSvgRes.fan,
      title: "Fan",
      icon: Icons.air_rounded,
      isMultiChoice: true,
    ),
    IconItem(
      key: AppSvgRes.light,
      title: "Light",
      icon: Icons.lightbulb_outline,
      isMultiChoice: true,
    ),
    IconItem(
      key: AppSvgRes.ac,
      title: "AC",
      icon: Icons.ac_unit,
      isMultiChoice: true,
    ),
    IconItem(
      key: AppSvgRes.wardrobe,
      title: "Wardrobe",
      icon: Icons.inventory_2,
      isMultiChoice: true,
    ),
    IconItem(
      key: AppSvgRes.tv,
      title: "TV",
      icon: Icons.tv,
      isMultiChoice: true,
    ),
    IconItem(
      key: AppSvgRes.bed,
      title: "Bed",
      icon: Icons.bed,
      isMultiChoice: true,
    ),
    IconItem(
      key: AppSvgRes.geyser,
      title: "Geyser",
      icon: Icons.hot_tub_outlined,
      isMultiChoice: true,
    ),
  ];
  // static final List<IconItem> furnitureItems = [
  //   IconItem(key: AppSvgRes.cupboard, title: "Cupboard", icon: Icons.cabin),
  //
  //   IconItem(
  //     key: AppSvgRes.microwave,
  //     title: "Microwave",
  //     icon: Icons.microwave_outlined,
  //   ),
  //
  //   IconItem(key: AppSvgRes.sofa, title: "Sofa", icon: Icons.chair_alt),
  //   IconItem(key: AppSvgRes.stove, title: "Stove", icon: Icons.stairs),
  //   IconItem(key: AppSvgRes.table, title: "Table", icon: Icons.table_bar),
  //
  //   IconItem(
  //     key: AppSvgRes.washing,
  //     title: "Washing Machine",
  //     icon: Icons.local_laundry_service,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.refrigerate,
  //     title: "Refrigerator",
  //     icon: Icons.kitchen,
  //     isMultiChoice: true,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.shower,
  //     title: "Shower",
  //     icon: Icons.shower,
  //     isMultiChoice: true,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.tv,
  //     title: "TV",
  //     icon: Icons.tv,
  //     isMultiChoice: true,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.hot,
  //     title: "Hot Water",
  //     icon: Icons.hot_tub,
  //     isMultiChoice: true,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.bed,
  //     title: "Bed",
  //     icon: Icons.bed,
  //     isMultiChoice: true,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.water,
  //     title: "Water Heater",
  //     icon: Icons.water,
  //     isMultiChoice: true,
  //   ),
  // ];
  static final List<IconItem> amenitiesItems = [
    IconItem(key: AppSvgRes.cctv, title: "CCTV", icon: Icons.videocam),
    IconItem(key: AppSvgRes.club, title: "Club House", icon: Icons.house),
    IconItem(
      key: AppSvgRes.gate,
      title: "Gated Community",
      icon: Icons.door_front_door,
    ),
    IconItem(key: AppSvgRes.gym, title: "Gym", icon: Icons.fitness_center),
    IconItem(
      key: AppSvgRes.battery,
      title: "Power Backup",
      icon: Icons.battery_charging_full_outlined,
    ),

    IconItem(
      key: AppSvgRes.elevator,
      title: "Lift",
      icon: Icons.elevator_outlined,
    ),
    IconItem(key: AppSvgRes.garden, title: "Garden", icon: Icons.park),
    IconItem(
      key: AppSvgRes.hall,
      title: "Community Hall",
      icon: Icons.holiday_village,
    ),
    IconItem(
      key: AppSvgRes.intercom,
      title: "Intercom",
      icon: Icons.phone_in_talk,
    ),
    IconItem(
      key: AppSvgRes.playground,
      title: "Kids Area",
      icon: Icons.sports_soccer,
    ),
    IconItem(
      key: AppSvgRes.sports,
      title: "Sports",
      icon: Icons.sports_basketball,
    ),
    IconItem(key: AppSvgRes.swimming, title: "Swimming Pool", icon: Icons.pool),
    IconItem(
      key: AppSvgRes.tap,
      title: "Regular Water Supply",
      icon: Icons.water_drop,
    ),
    IconItem(
      key: AppSvgRes.rain_water_harvesting,
      title: "Rainwater Harvesting",
      icon: Icons.water_drop,
    ),
    IconItem(
      key: AppSvgRes.security,
      title: "24/7 Security",
      icon: Icons.water_drop,
    ),
    IconItem(key: AppSvgRes.parking, title: "Parking", icon: Icons.water_drop),
    IconItem(
      key: AppSvgRes.sunlight,
      title: "Sunlight",
      icon: Icons.water_drop,
    ),
    IconItem(
      key: AppSvgRes.ventilator,
      title: "Ventilation",
      icon: Icons.water_drop,
    ),
  ];
  static final List<IconItem> roomAmenities = [
    IconItem(key: AppSvgRes.wifi, title: "Wifi", icon: Icons.wifi),
    IconItem(key: AppSvgRes.tv, title: "TV", icon: Icons.tv),
    IconItem(key: AppSvgRes.ac, title: "Ac", icon: Icons.ac_unit),
    IconItem(
      key: AppSvgRes.geyser,
      title: "Geyser",
      icon: Icons.hot_tub_outlined,
    ),
    IconItem(key: AppSvgRes.refrigerate, title: "Fridge", icon: Icons.kitchen),
    IconItem(key: AppSvgRes.cupboard, title: "Cupboard", icon: Icons.inventory),
  ];

  // static final List<IconItem> allAmenities = [
  //
  //   IconItem(
  //     key: AppSvgRes.dg,
  //     title: "Ev Charging",
  //     icon: Icons.electrical_services,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.battery,
  //     title: "Power Backup",
  //     icon: Icons.battery_charging_full,
  //   ),
  //   IconItem(key: AppSvgRes.cctv, title: "CCTV Surveillance", icon: Icons.videocam),
  //
  //   IconItem(
  //     key: AppSvgRes.internet_connectivity,
  //     title: "Wi-Fi Connectivity",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.covered_parking,
  //     title: "Covered Parking",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.visitor_parking,
  //     title: "Visitor Parking",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.maintenanace_staff,
  //     title: "Maintenance Staff",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.meditation_area,
  //     title: "Meditation Area",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.multi_purpose_hall,
  //     title: "Multipurpose Hall",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.solar_panel,
  //     title: "Solar Panels",
  //     icon: Icons.wifi,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.waste_disposal,
  //     title: "Waste Disposal",
  //     icon: Icons.wifi,
  //   ),
  //
  //    IconItem(key: AppSvgRes.security, title: "24x7 Security", icon: Icons.security),
  //   // IconItem(key: AppSvgRes.parking, title: "Parking", icon: Icons.water_drop),
  //   // IconItem(key: AppSvgRes.sunlight, title: "Sunlight", icon: Icons.water_drop),
  //   // IconItem(key: AppSvgRes.ventilator, title: "Ventilation", icon: Icons.water_drop),
  //   // IconItem(key: AppSvgRes.rain_water_harvesting, title: "Rainwater Harvesting", icon: Icons.water_drop),
  //
  //   IconItem(
  //     key: AppSvgRes.washing,
  //     title: "Laundry Service",
  //     icon: Icons.water_drop,
  //   ),
  //
  //   // Residential Amenities
  //   IconItem(key: AppSvgRes.club, title: "Club House", icon: Icons.house),
  //
  //   IconItem(key: AppSvgRes.gym, title: "Gymnasium", icon: Icons.fitness_center),
  //   IconItem(
  //     key: AppSvgRes.elevator,
  //     title: "Lift",
  //     icon: Icons.elevator_outlined,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.elevator,
  //     title: "Service Lift",
  //     icon: Icons.elevator_outlined,
  //   ),
  //   IconItem(key: AppSvgRes.garden, title: "Gardens", icon: Icons.park),
  //   IconItem(
  //     key: AppSvgRes.hall,
  //     title: "Temple",
  //     icon: Icons.holiday_village,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.playground,
  //     title: "Children Play Area",
  //     icon: Icons.sports_soccer,
  //   ),
  //   IconItem(
  //     key: AppSvgRes.sports,
  //     title: "Jogging Track",
  //     icon: Icons.sports_basketball,
  //   ),
  //   IconItem(key: AppSvgRes.swimming, title: "Swimming Pool", icon: Icons.pool),
  //   IconItem(key: AppSvgRes.fire_extinguisher, title: "Fire Safety", icon: Icons.water_drop),
  //   // IconItem(
  //   //   key: AppSvgRes.bbq_area,
  //   //   title: 'BBQ Area',
  //   //   icon: Icons.area_chart,
  //   // ),
  //   IconItem(
  //     key: AppSvgRes.home_theater,
  //     title: 'Amphitheatre',
  //     icon: Icons.video_call_outlined,
  //   ),
  // ];
  // static final List<IconItem> allAmenities = [
    // // ✅ Existing + corrected + newly added items
    // IconItem(key: AppSvgRes.cctv, title: "cctv", icon: Icons.videocam),
    // IconItem(key: AppSvgRes.club, title: "club_house", icon: Icons.house),
    // IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    // IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    // IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    // IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    // IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    // IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    // IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    // IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    // IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    // IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    // IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    // IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    // IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    // IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // // Add fallback variants
    // IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    // IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    // IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    // IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
  // ];

  static final List<IconItem> builderAdditionalAmenities = [
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.gym, title: "gymnasium", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.club, title: "club_house", icon: Icons.house),
    IconItem(
      key: AppSvgRes.meditation,
      title: "meditation_area",
      icon: Icons.self_improvement,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(
      key: AppSvgRes.amphitheatre,
      title: "amphitheatre",
      icon: Icons.stadium,
    ),
    IconItem(
      key: AppSvgRes.temple,
      title: "temple",
      icon: Icons.temple_hindu_outlined,
    ),
    IconItem(
      key: AppSvgRes.security,
      title: "security_24x7",
      icon: Icons.security,
    ),
    IconItem(
      key: AppSvgRes.cctv,
      title: "cctv_surveillance",
      icon: Icons.videocam,
    ),
    IconItem(
      key: AppSvgRes.hall,
      title: "multipurpose_hall",
      icon: Icons.groups,
    ),
    IconItem(
      key: AppSvgRes.playground,
      title: "children_play_area",
      icon: Icons.child_care,
    ),
    IconItem(
      key: AppSvgRes.visitor_parking,
      title: "visitor_parking",
      icon: Icons.local_parking,
    ),
    IconItem(
      key: AppSvgRes.covered_parking,
      title: "covered_parking",
      icon: Icons.local_parking,
    ),
    IconItem(
      key: AppSvgRes.fire_safety,
      title: "fire_safety",
      icon: Icons.fire_extinguisher,
    ),
    IconItem(
      key: AppSvgRes.battery,
      title: "power_backup",
      icon: Icons.battery_charging_full_outlined,
    ),
    IconItem(
      key: AppSvgRes.solar,
      title: "solar_panels",
      icon: Icons.solar_power,
    ),
    IconItem(
      key: AppSvgRes.waste_disposal,
      title: "waste_disposal",
      icon: Icons.recycling,
    ),
    IconItem(
      key: AppSvgRes.service_lift,
      title: "service_lift",
      icon: Icons.elevator_outlined,
    ),
    IconItem(
      key: AppSvgRes.elevator,
      title: "lift",
      icon: Icons.elevator_outlined,
    ),
    IconItem(
      key: AppSvgRes.ev_charging,
      title: "ev_charging",
      icon: Icons.electric_car,
    ),
    IconItem(
      key: AppSvgRes.wifi,
      title: "wifi_connectivity",
      icon: Icons.wifi,
    ),
    IconItem(
      key: AppSvgRes.maintenance,
      title: "maintenance_staff",
      icon: Icons.engineering,
    ),
    IconItem(
      key: AppSvgRes.laundry,
      title: "laundry_service",
      icon: Icons.local_laundry_service,
    ),
  ];

  static final List<IconItem> allAmenities = [
    // Canonical project amenity list (deduplicated + API-aligned keys)
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.gym, title: "gymnasium", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.club, title: "club_house", icon: Icons.house),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(key: AppSvgRes.gate, title: "gated_community", icon: Icons.door_front_door),
    IconItem(key: AppSvgRes.gym, title: "gym", icon: Icons.fitness_center),
    IconItem(key: AppSvgRes.battery, title: "power_backup", icon: Icons.battery_charging_full_outlined),
    IconItem(key: AppSvgRes.elevator, title: "lift", icon: Icons.elevator_outlined),
    IconItem(key: AppSvgRes.garden, title: "garden", icon: Icons.park),
    IconItem(key: AppSvgRes.hall, title: "community_hall", icon: Icons.holiday_village),
    IconItem(key: AppSvgRes.intercom, title: "intercom", icon: Icons.phone_in_talk),
    IconItem(key: AppSvgRes.playground, title: "kids_area", icon: Icons.sports_soccer),
    IconItem(key: AppSvgRes.sports, title: "sports", icon: Icons.sports_basketball),
    IconItem(key: AppSvgRes.swimming, title: "swimming_pool", icon: Icons.pool),
    IconItem(key: AppSvgRes.tap, title: "regular_water_supply", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.parking, title: "parking", icon: Icons.local_parking),
    IconItem(key: AppSvgRes.rain_water_harvesting, title: "rainwater_harvesting", icon: Icons.water_drop),
    IconItem(key: AppSvgRes.security, title: "security", icon: Icons.security),
    // Add fallback variants
    IconItem(key: "wifi", title: "wifi", icon: Icons.wifi),
    IconItem(key: "ventilation", title: "ventilation", icon: Icons.air),
    IconItem(key: "sunlight", title: "sunlight", icon: Icons.wb_sunny_outlined),
    IconItem(key: "ev_charging", title: "ev_charging", icon: Icons.electric_car),
    IconItem(
      key: AppSvgRes.jogging,
      title: "jogging_track",
      icon: Icons.directions_run,
    ),
    IconItem(key: AppSvgRes.garden, title: "gardens", icon: Icons.park),
    IconItem(
      key: AppSvgRes.meditation,
      title: "meditation_area",
      icon: Icons.self_improvement,
    ),
    IconItem(
      key: AppSvgRes.hall,
      title: "multipurpose_hall",
      icon: Icons.groups,
    ),
    IconItem(
      key: AppSvgRes.amphitheatre,
      title: "amphitheatre",
      icon: Icons.stadium,
    ),
    IconItem(
      key: AppSvgRes.temple,
      title: "temple",
      icon: Icons.temple_hindu_outlined,
    ),
    IconItem(
      key: AppSvgRes.security,
      title: "24x7_security",
      icon: Icons.security,
    ),
    IconItem(
      key: AppSvgRes.cctv,
      title: "cctv_surveillance",
      icon: Icons.videocam,
    ),
    IconItem(
      key: AppSvgRes.parking,
      title: "visitor_parking",
      icon: Icons.local_parking,
    ),
    IconItem(
      key: AppSvgRes.parking,
      title: "covered_parking",
      icon: Icons.local_parking,
    ),
    IconItem(
      key: AppSvgRes.fire_safety,
      title: "fire_safety",
      icon: Icons.fire_extinguisher,
    ),
    IconItem(
      key: AppSvgRes.battery,
      title: "power_backup",
      icon: Icons.battery_charging_full_outlined,
    ),
    IconItem(
      key: AppSvgRes.elevator,
      title: "lift",
      icon: Icons.elevator_outlined,
    ),
    IconItem(
      key: AppSvgRes.service_lift,
      title: "service_lift",
      icon: Icons.elevator_outlined,
    ),
    IconItem(
      key: AppSvgRes.waste_disposal,
      title: "waste_disposal",
      icon: Icons.recycling,
    ),
    IconItem(
      key: AppSvgRes.solar,
      title: "solar_panels",
      icon: Icons.solar_power,
    ),
    IconItem(
      key: AppSvgRes.ev_charging,
      title: "ev_charging",
      icon: Icons.electric_car,
    ),
    IconItem(key: AppSvgRes.wifi, title: "wifi_connectivity", icon: Icons.wifi),
    IconItem(
      key: AppSvgRes.maintenance,
      title: "maintenance_staff",
      icon: Icons.engineering,
    ),
    IconItem(
      key: AppSvgRes.laundry,
      title: "laundry_service",
      icon: Icons.local_laundry_service,
    ),
  ];

  /// 🔹 Return `IconData` (Material icon) for fallback UI
  static IconData getIcon(String key) {
    debugPrint('[DEBUG]=> icons : $key');
    return items
        .firstWhere(
          (item) => item.key == key,
          orElse:
              () => IconItem(
                key: "unknown",
                title: "Unknown",
                icon: Icons.help_outline,
              ),
        )
        .icon;
  }

  /// 🔹 Return the SVG key (e.g. AppSvgRes.office)
  static String getSvgKey(String title) {
    return items
        .firstWhere(
          (item) => item.title == title,
          orElse:
              () => IconItem(
                key: "unknown",
                title: "Unknown",
                icon: Icons.help_outline,
              ),
        )
        .key;
  }

  /// 🔹 Return full item (title + key + icon)
  static IconItem getItem(String key) {
    return items.firstWhere(
      (item) => item.key == key,
      orElse:
          () => IconItem(
            key: "unknown",
            title: "Unknown",
            icon: Icons.help_outline,
          ),
    );
  }

  // static IconData? getAmenitiesIcon(String keyOrTitle) {
  //   try {
  //     final item = allAmenities.firstWhere(
  //       (amenity) =>
  //           amenity.key == keyOrTitle ||
  //           amenity.title.toLowerCase() == keyOrTitle.toLowerCase(),
  //       orElse: () => IconItem(key: '', title: '', icon: Icons.help_outline),
  //     );
  //     return item.icon;
  //   } catch (e) {
  //     return Icons.help_outline; // default fallback
  //   }
  // }
  static IconData getAmenitiesIcon(String keyOrTitle) {

    debugPrint('getAmenitiesIcon: $keyOrTitle');
    try {
      final normalized = keyOrTitle.toLowerCase().replaceAll('-', '_').trim();

      final item = allAmenities.firstWhere(
        (amenity) =>
            amenity.key.toLowerCase() == normalized ||
            amenity.title.toLowerCase() == normalized ||
            amenity.key.toLowerCase().contains(normalized) ||
            normalized.contains(amenity.key.toLowerCase()),
        orElse:
            () => IconItem(
              key: 'unknown',
              title: 'Unknown',
              icon: Icons.help_outline,
            ),
      );

      return item.icon;
    } catch (e) {
      debugPrint("⚠️ Unknown amenity icon for: $keyOrTitle");
      return Icons.help_outline;
    }
  }
}
