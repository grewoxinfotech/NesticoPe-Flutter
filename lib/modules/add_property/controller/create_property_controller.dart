import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart'
    hide
        PropertyDetails,
        PossessionInfo,
        FinancialInfo,
        FloorInfo,
        ParkingInfo,
        LiftInfo,
        FurnishDetails,
        FacilitiesInfo,
        PgInfo,
        PgRoomInfo,
        RoomFacilityInfo,
        PgRules,
        PlotInfo,
        removeDots;
import 'package:housing_flutter_app/data/network/property/services/property_service.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/modules/add_property/model/furnishing_,model.dart';
import 'package:housing_flutter_app/modules/add_property/model/photo_model.dart';
import 'package:housing_flutter_app/modules/add_property/model/review_property_model.dart';
import 'package:housing_flutter_app/modules/add_property/model/room_detail_model.dart';
import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../model/add_property_model.dart';
import '../model/commercial_model.dart';

// enum SellerType { owner, builder }

class CreatePropertyController extends GetxController {
  final _propertyService = PropertyService();
  ImagePicker picker = ImagePicker();
  RxBool isLoading = false.obs;

  ///=======================================26-12-2025=============================================================
  final isPredefinedCostEnabled = false.obs;

  final pastPrices = List.generate(5, (_) => TextEditingController());
  final futurePrices = List.generate(5, (_) => TextEditingController());

  // /// 🏠 Past 5 Years Prices (Required)
  // List<PropertyPriceYearly> getPastPriceData() {
  //   final currentYear = DateTime.now().year;
  //
  //   return List.generate(5, (index) {
  //     final year = currentYear - (index + 1);
  //     final priceText = pastPrices[index].text.trim();
  //     final price = double.tryParse(priceText) ?? 0.0;
  //
  //     return PropertyPriceYearly(year: year, price: price);
  //   });
  // }
  //
  // /// 🔮 Future 5 Years Prices (Optional)
  // List<PropertyPriceYearly> getFuturePriceData() {
  //   final currentYear = DateTime.now().year;
  //
  //   return List.generate(5, (index) {
  //     final year = currentYear + (index + 1);
  //     final priceText = futurePrices[index].text.trim();
  //     final price = double.tryParse(priceText.isEmpty ? "0" : priceText) ?? 0;
  //
  //     return PropertyPriceYearly(year: year, price: price);
  //   });
  // }

  ////////////document upload //////////////////

  /// 📈 Price Trend (Past + Future Combined)
  List<PropertyPriceYearly> getPriceTrendData() {
    final int currentYear = DateTime.now().year;
    final List<PropertyPriceYearly> trend = [];

    // Past 5 years
    for (int i = 0; i < 5; i++) {
      final year = currentYear - (5 - i);
      final priceText = pastPrices[i].text.trim();
      final price = double.tryParse(priceText) ?? 0.0;

      trend.add(PropertyPriceYearly(year: year, price: price));
    }

    // Future 5 years
    for (int i = 0; i < 5; i++) {
      final year = currentYear + (i + 1);
      final priceText = futurePrices[i].text.trim();
      final price = double.tryParse(priceText.isEmpty ? '0' : priceText) ?? 0.0;

      trend.add(PropertyPriceYearly(year: year, price: price));
    }

    if (sell_ExpectedPrice.text.trim().isNotEmpty &&
        double.tryParse(sell_ExpectedPrice.text.trim()) != 0) {
      trend.add(
        PropertyPriceYearly(
          year: currentYear,
          price: double.tryParse(sell_ExpectedPrice.text.trim()) ?? 0.0,
        ),
      );
    }
    // current year
    if (commercial_rent_cost.text.trim().isNotEmpty &&
        double.tryParse(commercial_rent_cost.text.trim()) != 0) {
      trend.add(
        PropertyPriceYearly(
          year: currentYear,
          price: double.tryParse(commercial_rent_cost.text.trim()) ?? 0.0,
        ),
      );
    }

    debugPrint(
      "[DEBUG]====> Property Price Trends Add Property: ${trend.map((e) => e.toJson())}",
    );

    return trend;
  }

  ///======================================================================
  RxList<String> imageList = <String>[].obs;
  RxList<String> videoList = <String>[].obs;
  RxList<String> documentList = <String>[].obs;

  /// Post Media=============PG/Co-Living===================
  var mealCharges = "".obs;
  var mealChargesTextFiled = TextEditingController();
  var electricityCharges = ''.obs;
  var electricityChargesTextFiled = TextEditingController();
  var pgRulesAvailable = "".obs;
  var nonVegAllowed = "".obs;
  var smokingAllowed = "".obs;
  var drinkingAllowed = "".obs;
  var letEntryAllowed = "".obs;
  var visitorsAllowed = "".obs;
  var petAllowed = "".obs;
  var propertyManagedBy = "".obs;
  var managerStaysAtProperty = "".obs;
  var pgTotalFloor = TextEditingController();
  var pgFloorNumber = TextEditingController();
  var selectedRoomAmenitiesDataForPG = <String>[].obs;
  var roomFacilityAvailableOrNot = "".obs;
  var otherFacility = TextEditingController();
  var pastFiveYearPrice = TextEditingController();
  var futureFiveYearPrice = TextEditingController();

  ///=============================Residential Rent apartment===============
  var doYouWantBrokerage = "".obs;
  var lift_info = "".obs;
  var brokerageChargeNegotiable = "".obs;
  var tenantType = ''.obs;

  ///============================Main variable=============================
  var negotiablePriceOrNot = "".obs;

  ///===================================Residential Sell=============================

  var transactionType = "".obs;
  var plotWidth = TextEditingController();
  var plotLength = TextEditingController();

  final RxBool isEdited = true.obs;

  ///=======================================

  ///=============================================New Variable======================
  // Reactive states
  var selectedSellerType = SellerType.owner.obs; // New: selected user type
  var isOwner = true.obs;
  var propertyType = "".obs;
  var rent_propertyType = "".obs;
  var lookingTo = "".obs;
  var countryCode = '+91'.obs;
  var bhkType = "".obs;
  var isShareWithAgents = false.obs;
  var rent_Bathroom = 0.obs;
  RxBool isLogin = false.obs;
  var furnishingType = "".obs;
  var stepIndex = 0.obs;
  var rent_Painting_Charges = "".obs;

  var areaUnit = "sq.ft.".obs;
  var commercial_plotArea = "sq.ft.".obs;
  var commercial_plot = TextEditingController();
  var commercial_Property_Name = TextEditingController();
  var rent_Parking_Charges = "".obs;
  var carpetAreaUnit = "sq.ft.".obs;
  final countryRules = {
    '+91': 10, // India: 10 digits
    '+1': 10, // USA: 10 digits
    '+44': 10, // UK: usually 10 digits after 0
    '+61': 9, // Australia
    '+1-CA': 10,
    '+49': 11, // Germany varies but 11 is common
    '+33': 9, // France
    '+65': 8, // Singapore
    '+971': 9, // UAE
    '+81': 10, // Japan
  };

  var mealAvailable = " ".obs;
  var rooms = <RoomModel>[].obs;
  var rent_Custom_Painting_Charges = TextEditingController();
  var rent_facing = "".obs;
  var sell_rent_Address = TextEditingController();
  var selectedDate = Rxn<DateTime>();
  var rent_Balcony = 0.obs;
  var rent_OpenParking = '0'.obs;
  var rent_maintenanceChargeType = "".obs;
  var labelOfPhoto = "Other".obs;
  var rent_Custom_Parking_Charges = TextEditingController();
  var sell_rent_Maintenance_Charges = TextEditingController();
  var rent_Pet_Friendly = "".obs;
  var rent_lockInPeriod = "".obs;
  var rent_Custom_LockIn_Period = TextEditingController();
  var rent_CoveredParking = '0'.obs;
  var rent_MonthilyRent = TextEditingController(text: 0.toString());
  var rent_SecurityDeposit = TextEditingController();
  var rent_AvailableFrom = TextEditingController();
  var sell_rent_Flat_No = TextEditingController();
  var rent_depositType = "".obs;
  var sell_rent_Servent_Room = "".obs;
  var sell_rent_Floor_No = TextEditingController();
  var sell_rent_propertyDescriptionController = TextEditingController();
  var sell_rent_Total_Floor = TextEditingController();
  var sell_AvailableFrom = TextEditingController();
  var sell_ExpectedPrice = TextEditingController();
  var commercial_rent_AvailableFrom = TextEditingController();
  var commercial_rent_AgeOfPropertInYear = TextEditingController();
  var sell_constructionStatus = "".obs;
  var selectedFurnishing = <String, FurnishingItemModel>{}.obs;
  var selectedRoomAmenities = <String>[].obs;

  var selectedCommercialAmenities = <String>[].obs;
  var commercial_isPreLeased = ''.obs;
  var commercial_current_rent_preLeasedTill = TextEditingController();
  var commercial_lease_years = TextEditingController();
  var commercial_returned_RIO = TextEditingController();

  // Add a computed getter for stepsList
  List<String> get stepsList {
    // Example: change steps based on lookingTo.value
    if (lookingTo.value == "Rent" && propertyType.value == "Residential") {
      return [
        "Basic Detail",
        "Property Details",
        "Price Details",
        "Photos",
        "Advanced Details",
        "Amenities",
        "Verify",
      ];
    } else if (lookingTo.value == "Sell" &&
        propertyType.value == "Residential") {
      return [
        "Basic Detail",
        "Property Details",
        "Price Details",
        "Photos",
        "Advanced Details",
        "Amenities",
        "Verify",
      ];
    }
    // Default steps
    else if (lookingTo.value == "PG/Co-Living" &&
        propertyType.value == "Residential") {
      return [
        "Basic Detail",
        "Property Details",
        "Room Details",
        "Amenities",
        "Photos",
        "Review",
      ];
    } else if ((lookingTo.value == "Rent" || lookingTo.value == "Sell") &&
        propertyType.value == "Commercial") {
      return [
        "Basic Detail",
        "Property Details",
        "Price Details",
        "Amenities",
        "Photos",
        "Review",
      ];
    } else {
      return [
        "Basic Detail",
        "Property Details",
        "Room Details",
        "Photos",
        "Review",
      ];
    }
  }

  // Perfect getter method for photo labels
  List<String> get labelsPhoto {
    if (propertyType.value == "Residential" &&
        lookingTo.value == "PG/Co-Living") {
      return [
        "Single Room",
        "Double Sharing Room",
        "Triple Sharing Room",
        "Kitchen",
        "Bathroom",
        "Servant Room",
        "Pooja Room",
        "Study Room",
        "Balcony",
        "Common Area",
        "Entrance",
        "Building",
        "Outside View",
        "Others",
      ];
    }
    // Residential Rent/Sell properties
    else if (propertyType.value == "Residential" &&
        (lookingTo.value == "Rent" || lookingTo.value == "Sell")) {
      return [
        "Living Room",
        "Bedroom",
        "Kitchen",
        "Bathroom",
        "Master Bedroom",
        "Dining Room",
        "Balcony",
        "Servant Room",
        "Pooja Room",
        "Study Room",
        "Common Area",
        "Entrance",
        "Building",
        "Outside View",
        "Floor Plan",
        "Master Layout",
        "Site Plan",
        "Brochure",
        "Furnishings",
        "Others",
      ];
    }
    // Commercial Office
    else if (propertyType.value == "Commercial") {
      return [
        "Entrance",
        "Reception",
        "Hall",
        "Meeting Room",
        "Cabin",
        "Staircase",
        "Elevator",
        "Floor Plan",
        "Outside View",
        "Others",
      ];
    }

    // Default fallback
    return ["Main Area", "Entrance", "Outside View", "Others"];
  }

  List<String> zoneType = [
    "industrial",
    "commercial",
    "residential",
    "sez",
    "open_spaces",
    "agricultural",
    "others",
  ];

  // List<String> zoneType = [
  //   "Industrial",
  //   "Commercial",
  //   "Residential",
  //   "Special Economical",
  //   "Open Spaces",
  //   "Agriclture Zone",
  //   "Other",
  // ];

  List<String> get locationHub {
    if (selectedIndex.value == 'Office') {
      return ['IT Park', 'Business', 'Park', 'Other'];
    } else if (selectedIndex.value == "Shop" ||
        selectedIndex.value == "Showroom" ||
        selectedIndex.value == "Warehouse" ||
        selectedIndex.value == "Other") {
      return [
        'Mall',
        'Commercial Project',
        'Residential Project',
        'Retail Complex',
        'Market/High Street',
        'Other',
      ];
    } else if (selectedIndex.value == "Plot") {
      return [
        'Freehold',
        'Leasehold',
        'Residential',
        'Special economical',
        'Open Spaces',
        'Agricultural zone',
        'Other',
      ];
    }
    return [];
  }

  var commercial_ZoneType = "".obs;
  var commercial_LocationHub = "".obs;
  var commercial_other_Location = TextEditingController();
  var commercial_property_condition = "".obs;
  var commercial_Square_BuildArea = TextEditingController();
  var commercial_Square_CarpetArea = TextEditingController();
  var commercial_Square_AreaUnti_Build = "sq.yd.".obs;
  var commercial_Square_AreaUnti_Carpet = "sq.yd.".obs;
  var commercial_ownerShipList = "".obs;
  var commercial_construction_status_value = ''.obs;
  var commercial_seats = TextEditingController();
  var commercial_cabins = TextEditingController();
  var commercial_meeting_room = TextEditingController();
  var commercial_total_floor = TextEditingController();
  var commercial_your_floor = TextEditingController();
  RxList<String> selectedFloors = <String>[].obs;

  void updateSelectedFloors(List<String> floors) {
    selectedFloors.value = floors;
    commercial_your_floor.text = floors.isNotEmpty ? floors.join(', ') : '';
  }

  RxList<PhotoImageModel> selectedImages = <PhotoImageModel>[].obs;

  // Change from list to single review
  // RxList<PropertyReviewModel> reviewList = <PropertyReviewModel>[].obs;
  Rxn<PropertyReviewModel> review = Rxn<PropertyReviewModel>();
  Rxn<CommercialPropertyModel> commercialReview =
      Rxn<CommercialPropertyModel>();

  // Text Controllers
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final localityController = TextEditingController();
  final pgNameController = TextEditingController();
  final totalRoomsController = TextEditingController();
  final noticPeriodController = TextEditingController();
  final ageOfPropertyController = TextEditingController();
  final rentBuildingController = TextEditingController();
  final lockPeriodController = TextEditingController();
  final sell_Rera_Id = TextEditingController();
  final areaController = TextEditingController();
  final carpetAreaController = TextEditingController();
  final commercial_rent_cost = TextEditingController();

  var commercial_rent_posessionStatus = "".obs;
  var commercial_rent_building_Name = TextEditingController();
  var commercial_rent_Loaclity_Name = TextEditingController();
  var commercial_rent_security_deposite = TextEditingController();
  var commercial_rent_description = TextEditingController();
  var commercial_rent_price_negotiable = "".obs;
  var commercial_rent_brokage = "".obs;
  var commercial_rent_brokerage = TextEditingController();
  var commercial_rent_brokage_negotiable = "".obs;
  var commercial_rent_maintainance_charge = "".obs;
  var commercial_rent_mainatainance_charge = TextEditingController();

  final tempRoomType = ''.obs;
  final tempMonthlyRent = TextEditingController();
  final tempDeposit = TextEditingController();

  RxString selectedIndex = "".obs;
  final int maxImages = 5;

  // var selectedItems = <String>[].obs;
  RxString pgFor = ''.obs;
  var mealAvailableList = <String>[].obs;
  var editingIndex = (-1).obs;
  var stepperSelectedIndex = 0.obs;
  var bestSuitedList = <String>[].obs;
  var rent_Legal = <String>[].obs;
  var sell_Brokerage = <String>[].obs;
  var sell_Registration_Charges = <String>[].obs;
  var sell_Amenities_Furniture = <String>[].obs;
  var rent_Rentals = <String>[].obs;
  var rent_Security_DepositType = <String>[].obs;
  var rent_HomeServices = <String>[].obs;
  var rent_Preferred_Tenants = <String>[].obs;
  var rent_Selected_Tenants_for_Bachelors = "".obs;

  var commonAreasList = <String>[].obs;

  // Loading state to prevent multiple operations
  var isProcessing = false.obs;

  // Add this new variable
  final showAddRoomCard = true.obs; // Start with card visible for first room
  final showPropertyTypeError = false.obs; // <-- Add this observable
  final showBHKChooseToError = false.obs;
  final showBasicPropertyType = false.obs;
  final showBasicLookingTo = false.obs; // <-- Add this observable
  final hasShownCommercialCategory = false.obs;
  final selectedDepositFromPrice = false.obs;
  final selectedSellFromPriceDetail = false.obs;
  final selectedZoneTypeInCommercial = false.obs;
  final seletedOwnerShipInCommercial = false.obs;
  final selectedChoiceAnyoneInPriceSection = false.obs;
  final selectedPossessionStatus = false.obs;
  final selectedConstructionStatusRent_Commercial = false.obs;

  ////////////=============New Varibale -===================================

  var platformFees = TextEditingController();
  var brokerRageCommission = TextEditingController();

  @override
  void onInit() {
    checkSellerAuthentication();
    super.onInit();
  }

  Future<void> builderImagePicker() async {
    try {
      List<XFile> files = await picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
        limit: 5,
      );

      if (files.isNotEmpty) {
        if (imageList.value.length + files.length > 5) {
          Get.snackbar(
            'Limit Exceeded',
            'You can only select up to 5 images in total',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        for (var file in files) {
          imageList.add(file.path);
          print('Image added: ${file.path}');
        }
        imageList.refresh();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: '${files.length} image(s) added',
          contentType: ContentType.success,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeBuilderImage(int index) {
    if (index >= 0 && index < imageList.length) {
      imageList.removeAt(index);
      print('Image removed at index $index');
    }
  }

  void removeBuilderVideo(int index) {
    if (index >= 0 && index < videoList.length) {
      videoList.removeAt(index);
      print('video removed at index $index');
    }
  }

  Future<void> builderVideoPicker() async {
    try {
      List<XFile> videos = await picker.pickMultiVideo(
        limit: 5,
        maxDuration: Duration(seconds: 60),
      );

      if (videos.isNotEmpty) {
        if (videoList.value.length + videos.length > 5) {
          Get.snackbar(
            'Limit Exceeded',
            'You can only select up to 5 videos in total',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // project.update((p) {
        //   if (p == null) return;
        //   for (var video in videos) {
        //     p.videoList.add(video.path);
        //     print('Video added: ${video.path}');
        //   }
        // });
        for (var video in videos) {
          videoList.add(video.path);
          print('video added: ${video.path}');
        }
        videoList.refresh();

        Get.snackbar(
          'Success',
          '${videos.length} video(s) added',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick videos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> builderDocumentPicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        // Check total limit
        if (documentList.value.length + result.files.length > 2) {
          Get.snackbar(
            'Limit Exceeded',
            'You can only select up to 2 documents in total',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        for (var file in result.files) {
          if (file.path != null) {
            documentList.add(file.path!);
            print('Document added: ${file.path}');
          }
        }

        documentList.refresh();

        Get.snackbar(
          'Success',
          '${result.files.length} document(s) added',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Failed to pick documents: $e');
      Get.snackbar(
        'Error',
        'Failed to pick documents: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pdfPreviewByDefaultApp(String pathOrUrl) async {
    // Show loading dialog
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String localPath = pathOrUrl;

      // Check if it's a network URL
      final isNetwork = Uri.tryParse(pathOrUrl)?.isAbsolute ?? false;

      if (isNetwork) {
        // Download the PDF to temporary directory
        final response = await http.get(Uri.parse(pathOrUrl));
        if (response.statusCode != 200) {
          print('Failed to download PDF');
          Navigator.of(Get.context!).pop(); // close loader
          return;
        }

        final tempDir = await getTemporaryDirectory();
        final fileName = pathOrUrl.split('/').last;
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        localPath = file.path;
      }

      // Open the PDF using the default app
      final result = await OpenFilex.open(localPath);
      print('Open result: ${result.message}');
    } catch (e) {
      print('PDF open error: $e');
    } finally {
      // Close loader
      Navigator.of(Get.context!).pop();
    }
  }

  void removeBuilderDocument(int index) {
    if (index >= 0 && index < documentList.length) {
      documentList.removeAt(index);
      print('Removed document at index $index');
    }
  }

  Future<void> checkSellerAuthentication() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      final userType = user.user!.userType;
      if (userType!.toLowerCase() == "seller") {
        isLogin.value = true;
      }
    }
  }

  @override
  void dispose() {
    // Properly dispose controllers
    phoneController.dispose();
    nameController.dispose();
    cityController.dispose();
    localityController.dispose();
    pgNameController.dispose();
    totalRoomsController.dispose();
    noticPeriodController.dispose();
    lockPeriodController.dispose();
    tempMonthlyRent.dispose();
    tempDeposit.dispose();
    super.dispose();
  }

  void addOrUpdateAmenities(String item) {
    if (selectedRoomAmenities.contains(item)) {
      selectedRoomAmenities.remove(item);
    } else {
      selectedRoomAmenities.add(item);
    }
    selectedRoomAmenities.refresh();
    print("Selected Amenities: $selectedRoomAmenities");
  }

  void addOrUpdateRoomAmenities(String item) {
    if (selectedRoomAmenitiesDataForPG.contains(item)) {
      selectedRoomAmenitiesDataForPG.remove(item);
    } else {
      selectedRoomAmenitiesDataForPG.add(item);
    }
    selectedRoomAmenitiesDataForPG.refresh();
    print(
      "Selected selectedRoomAmenitiesDataForPG: $selectedRoomAmenitiesDataForPG",
    );
  }

  void addCommercialAmenities(String items) {
    if (selectedCommercialAmenities.contains(items)) {
      selectedCommercialAmenities.remove(items);
    } else {
      selectedCommercialAmenities.add(items);
    }
    selectedCommercialAmenities.refresh();
  }

  // Add methods:
  void addOrUpdateFurnishing(IconItem item) {
    if (selectedFurnishing.containsKey(item.key)) {
      // If multi-choice, increase quantity
      if (item.isMultiChoice) {
        selectedFurnishing[item.key]!.quantity++;
        selectedFurnishing.refresh();
        print("Updated Furnishing: ${selectedFurnishing[item.key]}");
      }
    } else {
      selectedFurnishing[item.key] = FurnishingItemModel(
        key: item.key,
        title: item.title,
        quantity: 1,
      );
      print(
        "Added Furnishing: ${FurnishingItemModel(key: item.key, title: item.title, quantity: 1)}",
      );
    }
    selectedFurnishing.refresh();
  }

  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  void setDateTime(DateTime date, TimeOfDay time) {
    selectedDate.value = date;
    selectedTime.value = time;
  }

  String get formattedTime =>
      selectedTime.value != null
          ? selectedTime.value!.format(Get.context!)
          : "";

  void decreaseFurnishing(IconItem item) {
    if (selectedFurnishing.containsKey(item.key) && item.isMultiChoice) {
      if (selectedFurnishing[item.key]!.quantity > 1) {
        selectedFurnishing[item.key]!.quantity--;
        print("Decrease Furnishing: ${selectedFurnishing[item.key]}");
      } else {
        selectedFurnishing.remove(item.key);
        print("Removed Furnishing: ${item.key}");
      }
      selectedFurnishing.refresh();
    }
  }

  ///dgs_fFds5455451
  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  String get formattedDate {
    if (selectedDate.value == null) return "";
    return DateFormat("d MMM").format(selectedDate.value!);
  }

  void removeFurnishing(IconItem item) {
    selectedFurnishing.remove(item.key);
    selectedFurnishing.refresh();
  }

  void toggleItemInList(RxList<String> list, String item) {
    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }
    list.refresh();
    debugPrint("Updated List: $list");
  }

  void nextStep() {
    if (isProcessing.value) return; // Prevent multiple calls

    if (stepperSelectedIndex.value < stepsList.length) {
      isProcessing.value = true;

      try {
        stepperSelectedIndex.value++;
        debugPrint("Current Step: ${stepperSelectedIndex.value}");

        if (stepsList[stepperSelectedIndex.value] == "Review" ||
            stepsList[stepperSelectedIndex.value] == "Verify") {
          if (propertyType.value == "Commercial") {
            _prepareCommercialReviewData();
          } else {
            _prepareReviewData();
          }
        }
      } finally {
        isProcessing.value = false;
      }
    }
  }

  // Separate method to handle review preparation
  Future<void> _prepareReviewData() async {
    try {
      debugPrint("Preparing review data...");

      // Use microtask to prevent blocking UI
      await Future.microtask(() async {
        await _printAllDataAsync();
        await _addReviewModelAsync();
      });

      debugPrint("Review Model Added.");
    } catch (e) {
      debugPrint("Error preparing review data: $e");
      Get.snackbar(
        "Error",
        "Failed to prepare review data. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: ColorRes.white,
      );
    }
  }

  Future<void> _prepareCommercialReviewData() async {
    try {
      debugPrint("Preparing commercial review data...");
      await Future.microtask(() async {
        await _addCommercialReviewModelAsync();
      });
      debugPrint("Commercial Review Model Added.");
    } catch (e) {
      debugPrint("Error preparing commercial review data: $e");
      // Handle error appropriately
    }
  }

  // void previousStep() {
  //   // if (stepperSelectedIndex.value > 0) {
  //   //   stepperSelectedIndex.value--;
  //   // }
  //   if (stepperSelectedIndex.value > 0) {
  //     stepperSelectedIndex.value--;
  //
  //     print('settper ${stepperSelectedIndex.value}');
  //     if (stepperSelectedIndex.value == 0) {
  //       clearAllVariablesExceptPropertyType();
  //     }
  //   }
  // }
  void previousStep() {
    if (stepperSelectedIndex.value > 0) {
      stepperSelectedIndex.value--;
      print('stepper: ${stepperSelectedIndex.value}');
      if (stepperSelectedIndex.value == 0) {
        clearAllVariablesExceptPropertyType();
      }
    }
  }

  void finalsubmitForm() {
    // Final submit logic
    debugPrint("Final form submission");
  }

  // bool isSelected(String item) => selectedItems.contains(item);

  void select(String index) {
    selectedIndex.value = index;
    debugPrint("Selected index: $index");
  }

  // Toggle user type
  void toggleUserType(SellerType type) {
    selectedSellerType.value = type;
    // Update isOwner reactive accordingly
    isOwner.value = (type == SellerType.owner);
    print("Selected User Type: $type"); // Debug log
  }

  void toggleOwner(bool ownerSelected) {
    isOwner.value = ownerSelected;
  }

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }

  void submitForm() {
    if (isProcessing.value) return;
    print("1===================== ${isLogin.value}======================");

    if (!isLogin.value) {
      Get.lazyPut(() => AuthController());
      final authController = Get.find<AuthController>();
      print("2===================== ${isLogin.value}======================");

      // if (isOwner.value) {
      //   authController.sellerRegister(
      //     phone: phoneController.text.trim(),
      //     userType: "seller",
      //     sellerType: "owner",
      //   );
      // }
    }
    // isLogin.value = true;
    // Get.snackbar(
    //   "Form Submitted",
    //   "Owner: ${isOwner.value ? "Owner" : "Broker/Builder"}\n"
    //       "Property: ${propertyType.value}\n"
    //       "Looking to: ${lookingTo.value}\n"
    //       "Phone: $countryCode ${phoneController.text}\n"
    //       "Name: ${nameController.text}\n"
    //       "City: ${cityController.text}",
    //   snackPosition: SnackPosition.TOP,
    //   colorText: ColorRes.white,
    //   backgroundColor: ColorRes.primary.withOpacity(0.2),
    //   duration: const Duration(seconds: 4),
    // );
  }

  // Modify saveRoom method
  // void saveRoom() {
  //   if (tempRoomType.value.isNotEmpty &&
  //       tempMonthlyRent.text.isNotEmpty &&
  //       tempDeposit.text.isNotEmpty) {
  //     final room = RoomModel(
  //       roomType: tempRoomType.value,
  //       monthlyRent: tempMonthlyRent.text,
  //       other: otherFacility.text,
  //       deposit: tempDeposit.text,
  //       amenities: selectedRoomAmenitiesDataForPG,
  //     );
  //
  //     if (editingIndex.value == -1) {
  //       rooms.add(room);
  //       print("Room: ${rooms.map((element) => element.toMap())}");
  //     } else {
  //       print("Room: ${rooms.map((element) => element.toMap())}");
  //
  //       rooms[editingIndex.value] = room;
  //       editingIndex.value = -1;
  //     }
  //
  //     // Clear inputs and hide card
  //     clearRoomDetail();
  //     showAddRoomCard.value = false;
  //   }
  // }

  void saveRoom() {
    if (tempRoomType.value.isNotEmpty &&
        tempMonthlyRent.text.isNotEmpty &&
        tempDeposit.text.isNotEmpty) {
      // 🔥 Make a fresh copy of the list to avoid shared reference
      final clonedAmenities = List<String>.from(selectedRoomAmenitiesDataForPG);

      final room = RoomModel(
        roomType: tempRoomType.value,
        monthlyRent: tempMonthlyRent.text,
        deposit: tempDeposit.text,
        other: otherFacility.text,
        amenities: clonedAmenities,
      );

      if (editingIndex.value == -1) {
        rooms.add(room);
        print("Room: ${rooms.map((r) => r.toMap()).toList()}");
      } else {
        print("Room: ${rooms.map((element) => element.toMap())}");
        rooms[editingIndex.value] = room;
        editingIndex.value = -1;
      }

      clearRoomDetail();
      showAddRoomCard.value = false;
    }
  }

  // Modify clearRoomDetail method
  void clearRoomDetail() {
    tempRoomType.value = '';
    tempMonthlyRent.clear();
    tempDeposit.clear();
    selectedRoomAmenitiesDataForPG.clear();
    otherFacility.clear();
    editingIndex.value = -1;
  }

  void deleteRoom(int index) {
    if (index >= 0 && index < rooms.length) {
      rooms.removeAt(index);
    }
  }

  Future<void> pickImageFromCamera() async {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (file != null) {
        if (selectedImages.length >= maxImages) {
          _showImageLimitSnackbar(
            "You can only select up to $maxImages images.",
          );
          return;
        }
        selectedImages.add(PhotoImageModel(path: file.path));
      }
    } catch (e) {
      debugPrint("Error picking image from camera: $e");
      Get.snackbar(
        "Error",
        "Failed to pick image: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: ColorRes.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> pickImagesFromGallery() async {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;

      final ImagePicker picker = ImagePicker();
      final List<XFile>? files = await picker.pickMultiImage(
        imageQuality: 80, // Compress images
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (files != null && files.isNotEmpty) {
        final remainingSlots = maxImages - selectedImages.length;

        if (remainingSlots <= 0) {
          _showImageLimitSnackbar(
            "You can only select up to $maxImages images.",
          );
          return;
        }

        final filesToAdd = files.take(remainingSlots);

        // Process images in batches to prevent ANR
        await Future.microtask(() {
          selectedImages.addAll(
            filesToAdd.map((e) => PhotoImageModel(path: e.path)),
          );
        });

        if (files.length > remainingSlots) {
          _showImageLimitSnackbar(
            "Only $remainingSlots image(s) added. Max $maxImages images allowed.",
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
      Get.snackbar(
        "Error",
        "Failed to pick images: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: ColorRes.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void _showImageLimitSnackbar(String message) {
    Get.snackbar(
      "Limit Reached",
      message,
      snackPosition: SnackPosition.TOP,
      borderColor: Colors.redAccent,
      backgroundColor: ColorRes.white,
      colorText: Colors.black,
      duration: const Duration(seconds: 3),
    );
  }

  void removeImageByPath(String path) {
    selectedImages.removeWhere((img) => img.path == path);
  }

  void setImageLabel(int index, String label) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages[index].label = label;
      selectedImages.refresh();
    }
  }

  // Async version of printAllData
  Future<void> _printAllDataAsync() async {
    await Future.delayed(Duration.zero);

    debugPrint("========== Property Data ==========");
    debugPrint("Is Owner: ${isOwner.value}");
    debugPrint("Property Type: ${propertyType.value}");
    debugPrint("Looking To: ${lookingTo.value}");
    debugPrint("Phone: ${phoneController.text}");
    debugPrint("Name: ${nameController.text}");
    debugPrint("City: ${cityController.text}");
    debugPrint("Locality: ${localityController.text}");
    debugPrint("PG Name: ${pgNameController.text}");

    // Print collections efficiently
    debugPrint(
      "Rooms (${rooms.length}): ${rooms.map((r) => r.roomType).join(', ')}",
    );
    debugPrint(
      "Images (${selectedImages.length}): ${selectedImages.length} selected",
    );
    debugPrint(
      "Images (${selectedImages.length}): ${selectedImages.length} selected",
    );
    debugPrint(
      "Images (${selectedImages.length}): ${selectedImages.length} selected",
    );
    debugPrint("Meal Available: ${mealAvailableList.join(', ')}");
    debugPrint("Best Suited: ${bestSuitedList.join(', ')}");
    debugPrint("Common Areas: ${commonAreasList.join(', ')}");
    debugPrint("Step Index: ${stepperSelectedIndex.value}");
    debugPrint("===================================");
  }

  // Async version of addReviewModel
  Future<void> _addReviewModelAsync() async {
    try {
      // Create copies to avoid concurrent modification
      final imagesCopy =
          selectedImages
              .where((img) => img.path.isNotEmpty)
              .map(
                (img) => PhotoImageModel(
                  path: img.path,
                  label: img.label,
                  isCover: img.isCover,
                ),
              )
              .toList();
      //dysadg663
      final roomsCopy =
          rooms
              .map(
                (room) => RoomModel(
                  roomType: room.roomType,
                  monthlyRent: room.monthlyRent,
                  deposit: room.deposit,
                  amenities: room.amenities,
                  other: room.other,
                ),
              )
              .toList();

      // Use compute for heavy data processing if needed
      await Future.microtask(() {
        final reviewModel = PropertyReviewModel(
          isOwner: isOwner.value,
          propertyType: propertyType.value,
          lookingTo: lookingTo.value,
          countryCode: countryCode.value,
          phone: phoneController.text,
          name: nameController.text,
          city: cityController.text,
          locality: localityController.text,
          pgName: pgNameController.text,
          totalRooms: totalRoomsController.text,
          noticePeriod: noticPeriodController.text,
          lockPeriod: lockPeriodController.text,
          rooms: roomsCopy,
          images: imagesCopy,
          bestSuitedList: List<String>.from(bestSuitedList),
          commonAreasList: List<String>.from(commonAreasList),
          mealAvailableList: List<String>.from(mealAvailableList),
        );

        review.value = reviewModel;
      });

      // Do NOT reset stepperSelectedIndex here!
      // clearAllData();
      // stepperSelectedIndex.value = 0; // <-- REMOVE THIS LINE
    } catch (e) {
      debugPrint("Error creating review model: $e");
      rethrow;
    }
  }

  // Async version of addReviewModel
  // Updated _addCommercialReviewModelAsync method matching CommercialPropertyModel
  Future<void> _addCommercialReviewModelAsync() async {
    try {
      debugPrint("Preparing commercial review data...");

      // Use microtask to prevent blocking UI
      await Future.microtask(() {
        // Use the factory method from CommercialPropertyModel
        final commercialReviewModel = CommercialPropertyModel.fromController(
          this,
        );

        // Assign to the commercialReview observable
        commercialReview.value = commercialReviewModel;
      });

      debugPrint("Commercial Review Model created successfully");
    } catch (e) {
      debugPrint("Error creating commercial review model: $e");
      rethrow;
    }
  }

  // Alternative approach if you want to manually create the model:
  // Updated _addCommercialReviewModelAsync method matching CommercialPropertyMode

  // Alternative approach if you want to manually create the model:
  Future<void> _addCommercialReviewModelAsyncManual() async {
    try {
      // Create copies to avoid concurrent modification
      final imagesCopy =
          selectedImages
              .where((img) => img.path.isNotEmpty)
              .map(
                (img) => PhotoImageModel(
                  path: img.path,
                  label: img.label,
                  isCover: img.isCover,
                ),
              )
              .toList();

      await Future.microtask(() {
        final commercialReviewModel = CommercialPropertyModel(
          // Required fields
          buildingName: commercial_rent_building_Name.text,
          localityName: commercial_rent_Loaclity_Name.text,

          // Optional fields
          propertyName:
              commercial_Property_Name.text.isEmpty
                  ? null
                  : commercial_Property_Name.text,
          possessionStatus:
              commercial_rent_posessionStatus.value.isEmpty
                  ? null
                  : commercial_rent_posessionStatus.value,
          availableFrom:
              commercial_rent_AvailableFrom.text.isEmpty
                  ? null
                  : commercial_rent_AvailableFrom.text,
          ageOfProperty:
              commercial_rent_AgeOfPropertInYear.text.isEmpty
                  ? null
                  : commercial_rent_AgeOfPropertInYear.text,

          // Property details
          zoneType:
              commercial_ZoneType.value.isEmpty
                  ? null
                  : commercial_ZoneType.value,
          locationHub:
              commercial_LocationHub.value.isEmpty
                  ? null
                  : commercial_LocationHub.value,
          otherLocation:
              commercial_other_Location.text.isEmpty
                  ? null
                  : commercial_other_Location.text,

          // Property condition and areas
          propertyCondition:
              commercial_property_condition.value.isEmpty
                  ? null
                  : commercial_property_condition.value,
          carpetArea:
              commercial_Square_CarpetArea.text.isEmpty
                  ? null
                  : commercial_Square_CarpetArea.text,
          carpetAreaUnit:
              commercial_Square_AreaUnti_Carpet.value.isEmpty
                  ? null
                  : commercial_Square_AreaUnti_Carpet.value,
          plotArea: commercial_plot.text.isEmpty ? null : commercial_plot.text,
          plotAreaUnit:
              commercial_plotArea.value.isEmpty
                  ? null
                  : commercial_plotArea.value,
          buildUpArea:
              commercial_Square_BuildArea.text.isEmpty
                  ? null
                  : commercial_Square_BuildArea.text,
          buildUpAreaUnit:
              commercial_Square_AreaUnti_Build.value.isEmpty
                  ? null
                  : commercial_Square_AreaUnti_Build.value,

          // Ownership and construction
          ownership:
              commercial_ownerShipList.value.isEmpty
                  ? null
                  : commercial_ownerShipList.value,
          constructionStatus:
              commercial_construction_status_value.value.isEmpty
                  ? null
                  : commercial_construction_status_value.value,

          // Office specific (if applicable)
          seats: commercial_seats.text.isEmpty ? null : commercial_seats.text,
          cabins:
              commercial_cabins.text.isEmpty ? null : commercial_cabins.text,
          meetingRooms:
              commercial_meeting_room.text.isEmpty
                  ? null
                  : commercial_meeting_room.text,

          // Floor details
          totalFloor:
              commercial_total_floor.text.isEmpty
                  ? null
                  : commercial_total_floor.text,
          yourFloor:
              commercial_your_floor.text.isEmpty
                  ? null
                  : commercial_your_floor.text,

          // Financial
          expectedRent:
              commercial_rent_cost.text.isEmpty
                  ? null
                  : commercial_rent_cost.text,

          // Collections
          amenities: List<String>.from(selectedCommercialAmenities),
          photos: imagesCopy,
        );

        commercialReview.value = commercialReviewModel;
      });

      debugPrint("Commercial Review Model created successfully");
    } catch (e) {
      debugPrint("Error creating commercial review model: $e");
      rethrow;
    }
  }

  // Add these methods to your CreatePropertyController class

  /// Prints all variables in the controller for debugging purposes
  Future<void> printAllControllerVariables() async {
    await Future.delayed(Duration.zero);

    debugPrint("========== ALL CONTROLLER VARIABLES ==========");

    // Basic reactive variables
    debugPrint("--- Basic Variables ---");
    debugPrint("isOwner: ${isOwner.value}");
    debugPrint("propertyType: ${propertyType.value}");
    debugPrint("rent_propertyType: ${rent_propertyType.value}");
    debugPrint("lookingTo: ${lookingTo.value}");
    debugPrint("countryCode: ${countryCode.value}");
    debugPrint("bhkType: ${bhkType.value}");
    debugPrint("isShareWithAgents: ${isShareWithAgents.value}");
    debugPrint("rent_Bathroom: ${rent_Bathroom.value}");
    debugPrint("isLogin: ${isLogin.value}");
    debugPrint("furnishingType: ${furnishingType.value}");
    debugPrint("stepIndex: ${stepIndex.value}");
    debugPrint("stepperSelectedIndex: ${stepperSelectedIndex.value}");

    // Area and property details
    debugPrint("--- Area & Property Details ---");
    debugPrint("areaUnit: ${areaUnit.value}");
    debugPrint("carpetAreaUnit: ${carpetAreaUnit.value}");
    debugPrint("commercial_plotArea: ${commercial_plotArea.value}");
    debugPrint("rent_facing: ${rent_facing.value}");
    debugPrint("selectedDate: ${selectedDate.value}");
    debugPrint("selectedTime: ${selectedTime.value}");

    // Rent specific variables
    debugPrint("--- Rent Specific Variables ---");
    debugPrint("rent_Painting_Charges: ${rent_Painting_Charges.value}");
    debugPrint("rent_Parking_Charges: ${rent_Parking_Charges.value}");
    debugPrint("rent_Balcony: ${rent_Balcony.value}");
    debugPrint("rent_OpenParking: ${rent_OpenParking.value}");
    debugPrint("rent_CoveredParking: ${rent_CoveredParking.value}");
    debugPrint(
      "rent_maintenanceChargeType: ${rent_maintenanceChargeType.value}",
    );
    debugPrint("rent_Pet_Friendly: ${rent_Pet_Friendly.value}");
    debugPrint("rent_lockInPeriod: ${rent_lockInPeriod.value}");
    debugPrint("rent_depositType: ${rent_depositType.value}");
    debugPrint(
      "rent_Selected_Tenants_for_Bachelors: ${rent_Selected_Tenants_for_Bachelors.value}",
    );

    // Commercial properties
    debugPrint("--- Commercial Properties ---");
    debugPrint("commercial_ZoneType: ${commercial_ZoneType.value}");
    debugPrint("commercial_LocationHub: ${commercial_LocationHub.value}");
    debugPrint(
      "commercial_property_condition: ${commercial_property_condition.value}",
    );
    debugPrint(
      "commercial_Square_AreaUnti_Build: ${commercial_Square_AreaUnti_Build.value}",
    );
    debugPrint(
      "commercial_Square_AreaUnti_Carpet: ${commercial_Square_AreaUnti_Carpet.value}",
    );
    debugPrint("commercial_ownerShipList: ${commercial_ownerShipList.value}");
    debugPrint(
      "commercial_construction_status_value: ${commercial_construction_status_value.value}",
    );
    debugPrint(
      "commercial_rent_posessionStatus: ${commercial_rent_posessionStatus.value}",
    );
    debugPrint("selectedFloors: ${selectedFloors.toList()}");

    // Sell properties
    debugPrint("--- Sell Properties ---");
    debugPrint("sell_rent_Servent_Room: ${sell_rent_Servent_Room.value}");
    debugPrint("sell_constructionStatus: ${sell_constructionStatus.value}");

    // Other variables
    debugPrint("--- Other Variables ---");
    debugPrint("mealAvailable: ${mealAvailable.value}");
    debugPrint("labelOfPhoto: ${labelOfPhoto.value}");
    debugPrint("selectedIndex: ${selectedIndex.value}");
    debugPrint("tempRoomType: ${tempRoomType.value}");
    debugPrint("editingIndex: ${editingIndex.value}");
    debugPrint("isProcessing: ${isProcessing.value}");

    // Text Controllers
    debugPrint("--- Text Controllers ---");
    debugPrint("phoneController: ${phoneController.text}");
    debugPrint("nameController: ${nameController.text}");
    debugPrint("cityController: ${cityController.text}");
    debugPrint("localityController: ${localityController.text}");
    debugPrint("pgNameController: ${pgNameController.text}");
    debugPrint("totalRoomsController: ${totalRoomsController.text}");
    debugPrint("noticPeriodController: ${noticPeriodController.text}");
    debugPrint("ageOfPropertyController: ${ageOfPropertyController.text}");
    debugPrint("rentBuildingController: ${rentBuildingController.text}");
    debugPrint("lockPeriodController: ${lockPeriodController.text}");
    debugPrint("areaController: ${areaController.text}");
    debugPrint("carpetAreaController: ${carpetAreaController.text}");
    debugPrint("tempMonthlyRent: ${tempMonthlyRent.text}");
    debugPrint("tempDeposit: ${tempDeposit.text}");

    // Commercial text controllers
    debugPrint("commercial_plot: ${commercial_plot.text}");
    debugPrint("commercial_Property_Name: ${commercial_Property_Name.text}");
    debugPrint("commercial_other_Location: ${commercial_other_Location.text}");
    debugPrint(
      "commercial_Square_BuildArea: ${commercial_Square_BuildArea.text}",
    );
    debugPrint(
      "commercial_Square_CarpetArea: ${commercial_Square_CarpetArea.text}",
    );
    debugPrint("commercial_seats: ${commercial_seats.text}");
    debugPrint("commercial_cabins: ${commercial_cabins.text}");
    debugPrint("commercial_meeting_room: ${commercial_meeting_room.text}");
    debugPrint("commercial_total_floor: ${commercial_total_floor.text}");
    debugPrint("commercial_your_floor: ${commercial_your_floor.text}");
    debugPrint(
      "commercial_rent_building_Name: ${commercial_rent_building_Name.text}",
    );
    debugPrint(
      "commercial_rent_Loaclity_Name: ${commercial_rent_Loaclity_Name.text}",
    );
    debugPrint(
      "commercial_rent_AvailableFrom: ${commercial_rent_AvailableFrom.text}",
    );
    debugPrint(
      "commercial_rent_AgeOfPropertInYear: ${commercial_rent_AgeOfPropertInYear.text}",
    );

    // Rent text controllers
    debugPrint(
      "rent_Custom_Painting_Charges: ${rent_Custom_Painting_Charges.text}",
    );
    debugPrint(
      "rent_Custom_Parking_Charges: ${rent_Custom_Parking_Charges.text}",
    );
    debugPrint("rent_Custom_LockIn_Period: ${rent_Custom_LockIn_Period.text}");
    debugPrint("rent_MonthilyRent: ${rent_MonthilyRent.text}");
    debugPrint("rent_SecurityDeposit: ${rent_SecurityDeposit.text}");
    debugPrint("rent_AvailableFrom: ${rent_AvailableFrom.text}");

    // Sell text controllers
    debugPrint("sell_rent_Address: ${sell_rent_Address.text}");
    debugPrint("sell_rent_Flat_No: ${sell_rent_Flat_No.text}");
    debugPrint("sell_rent_Floor_No: ${sell_rent_Floor_No.text}");
    debugPrint(
      "sell_rent_propertyDescriptionController: ${sell_rent_propertyDescriptionController.text}",
    );
    debugPrint("sell_rent_Total_Floor: ${sell_rent_Total_Floor.text}");
    debugPrint("sell_AvailableFrom: ${sell_AvailableFrom.text}");
    debugPrint("sell_ExpectedPrice: ${sell_ExpectedPrice.text}");
    debugPrint(
      "sell_rent_Maintenance_Charges: ${sell_rent_Maintenance_Charges.text}",
    );
    debugPrint("sell_Rera_Id: ${sell_Rera_Id.text}");

    // Collections
    debugPrint("--- Collections ---");
    debugPrint(
      "rooms (${rooms.length}): ${rooms.map((r) => '${r.roomType}: ${r.monthlyRent}').join(', ')}",
    );
    debugPrint(
      "selectedImages (${selectedImages.length}): ${selectedImages.map((img) => '${img.label}: ${img.path}').join(', ')}",
    );
    debugPrint(
      "selectedFurnishing (${selectedFurnishing.length}): ${selectedFurnishing.keys.join(', ')}",
    );
    debugPrint(
      "selectedRoomAmenities (${selectedRoomAmenities.length}): ${selectedRoomAmenities.join(', ')}",
    );
    // debugPrint(
    //   "selectedItems (${selectedItems.length}): ${selectedItems.join(', ')}",
    // );
    debugPrint(
      "mealAvailableList (${mealAvailableList.length}): ${mealAvailableList.join(', ')}",
    );
    debugPrint(
      "bestSuitedList (${bestSuitedList.length}): ${bestSuitedList.join(', ')}",
    );
    debugPrint(
      "commonAreasList (${commonAreasList.length}): ${commonAreasList.join(', ')}",
    );
    debugPrint("rent_Legal (${rent_Legal.length}): ${rent_Legal.join(', ')}");
    debugPrint(
      "sell_Brokerage (${sell_Brokerage.length}): ${sell_Brokerage.join(', ')}",
    );
    debugPrint(
      "sell_Registration_Charges (${sell_Registration_Charges.length}): ${sell_Registration_Charges.join(', ')}",
    );
    debugPrint(
      "sell_Amenities_Furniture (${sell_Amenities_Furniture.length}): ${sell_Amenities_Furniture.join(', ')}",
    );
    debugPrint(
      "rent_Rentals (${rent_Rentals.length}): ${rent_Rentals.join(', ')}",
    );
    debugPrint(
      "rent_Security_DepositType (${rent_Security_DepositType.length}): ${rent_Security_DepositType.join(', ')}",
    );
    debugPrint(
      "rent_HomeServices (${rent_HomeServices.length}): ${rent_HomeServices.join(', ')}",
    );
    debugPrint(
      "rent_Preferred_Tenants (${rent_Preferred_Tenants.length}): ${rent_Preferred_Tenants.join(', ')}",
    );

    // Review model
    debugPrint("--- Review Model ---");
    if (review.value != null) {
      debugPrint("Review Model exists: ${review.value?.pgName}");
    } else {
      debugPrint("Review Model: null");
    }

    debugPrint("============================================");
  }

  /// Clears all variables except propertyType - called when returning to step 0
  void clearAllVariablesExceptPropertyType() {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;

      debugPrint("Clearing all variables except propertyType and lookingTo...");

      // Preserve these critical values
      String preservedPropertyType = propertyType.value;
      String preservedLookingTo = lookingTo.value;
      String preservedSelectedIndex =
          selectedIndex.value; // For commercial properties

      // Clear basic reactive variables (except preserved ones)
      isOwner.value = true;
      // propertyType.value = ""; // DON'T clear
      rent_propertyType.value = "";
      // lookingTo.value = ""; // DON'T clear
      countryCode.value = '+91';
      bhkType.value = "";
      isShareWithAgents.value = false;
      rent_Bathroom.value = 0;
      // isLogin stays as is
      furnishingType.value = "";
      stepIndex.value = 0;

      // Clear area and property details
      areaUnit.value = "sq.ft.";
      carpetAreaUnit.value = "sq.ft.";
      commercial_plotArea.value = "sq.ft.";
      rent_facing.value = "";
      selectedDate.value = null;
      selectedTime.value = null;

      // Clear rent specific variables
      rent_Painting_Charges.value = "";
      rent_Parking_Charges.value = "";
      rent_Balcony.value = 0;
      rent_OpenParking.value = '0';
      rent_CoveredParking.value = '0';
      rent_maintenanceChargeType.value = "";
      rent_Pet_Friendly.value = "";
      rent_lockInPeriod.value = "";
      rent_depositType.value = "";
      rent_Selected_Tenants_for_Bachelors.value = "";

      // Clear commercial properties
      commercial_ZoneType.value = "";
      commercial_LocationHub.value = "";
      commercial_property_condition.value = "";
      commercial_Square_AreaUnti_Build.value = "sq.yd.";
      commercial_Square_AreaUnti_Carpet.value = "sq.yd.";
      commercial_ownerShipList.value = "";
      commercial_construction_status_value.value = '';
      commercial_rent_posessionStatus.value = "";
      selectedFloors.clear();

      // Clear sell properties
      sell_rent_Servent_Room.value = "";
      sell_constructionStatus.value = "";

      // Clear other variables
      mealAvailable.value = " ";
      labelOfPhoto.value = "Other";
      // selectedIndex.value = ""; // DON'T clear for commercial
      tempRoomType.value = '';
      editingIndex.value = -1;

      // Clear all text controllers
      phoneController.clear();
      nameController.clear();
      cityController.clear();
      localityController.clear();
      pgNameController.clear();
      totalRoomsController.clear();
      noticPeriodController.clear();
      ageOfPropertyController.clear();
      rentBuildingController.clear();
      lockPeriodController.clear();
      areaController.clear();
      carpetAreaController.clear();
      tempMonthlyRent.clear();
      tempDeposit.clear();

      // Clear commercial text controllers
      commercial_plot.clear();
      commercial_Property_Name.clear();
      commercial_other_Location.clear();
      commercial_Square_BuildArea.clear();
      commercial_Square_CarpetArea.clear();
      commercial_seats.clear();
      commercial_cabins.clear();
      commercial_meeting_room.clear();
      commercial_total_floor.clear();
      commercial_your_floor.clear();
      commercial_rent_building_Name.clear();
      commercial_rent_Loaclity_Name.clear();
      commercial_rent_AvailableFrom.clear();
      commercial_rent_AgeOfPropertInYear.clear();
      commercial_isPreLeased.value = '';
      commercial_current_rent_preLeasedTill.clear();
      commercial_lease_years.clear();
      commercial_returned_RIO.clear();
      commercial_rent_cost.clear();

      // Clear rent text controllers
      rent_Custom_Painting_Charges.clear();
      rent_Custom_Parking_Charges.clear();
      rent_Custom_LockIn_Period.clear();
      rent_MonthilyRent.clear();
      rent_SecurityDeposit.clear();
      rent_AvailableFrom.clear();

      // Clear sell text controllers
      sell_rent_Address.clear();
      sell_rent_Flat_No.clear();
      sell_rent_Floor_No.clear();
      sell_rent_propertyDescriptionController.clear();
      sell_rent_Total_Floor.clear();
      sell_AvailableFrom.clear();
      sell_ExpectedPrice.clear();
      sell_rent_Maintenance_Charges.clear();
      sell_Rera_Id.clear();

      // Clear all collections
      rooms.clear();
      selectedImages.clear();
      selectedFurnishing.clear();
      selectedRoomAmenities.clear();
      // selectedItems.clear();
      mealAvailableList.clear();
      bestSuitedList.clear();
      commonAreasList.clear();
      rent_Legal.clear();
      sell_Brokerage.clear();
      sell_Registration_Charges.clear();
      sell_Amenities_Furniture.clear();
      rent_Rentals.clear();
      rent_Security_DepositType.clear();
      rent_HomeServices.clear();
      rent_Preferred_Tenants.clear();
      selectedCommercialAmenities.clear();

      // Clear review models
      review.value = null;
      commercialReview.value = null;

      // Clear error flags
      showPropertyTypeError.value = false;
      showBHKChooseToError.value = false;
      showBasicPropertyType.value = false;
      showBasicLookingTo.value = false;
      hasShownCommercialCategory.value = false;
      selectedDepositFromPrice.value = false;
      selectedSellFromPriceDetail.value = false;
      selectedZoneTypeInCommercial.value = false;
      seletedOwnerShipInCommercial.value = false;
      selectedChoiceAnyoneInPriceSection.value = false;
      selectedPossessionStatus.value = false;
      selectedConstructionStatusRent_Commercial.value = false;

      // Reset stepper to step 0
      stepperSelectedIndex.value = 0;

      // Restore preserved values
      propertyType.value = preservedPropertyType;
      lookingTo.value = preservedLookingTo;
      if (preservedPropertyType == "Commercial" &&
          preservedSelectedIndex.isNotEmpty) {
        selectedIndex.value = preservedSelectedIndex;
      }

      debugPrint(
        "Variables cleared. Preserved - propertyType: ${propertyType.value}, lookingTo: ${lookingTo.value}, selectedIndex: ${selectedIndex.value}",
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void clearAllData() {
    isProcessing.value = true;

    try {
      // Clear all form data
      phoneController.clear();
      nameController.clear();
      cityController.clear();
      localityController.clear();
      pgNameController.clear();
      totalRoomsController.clear();
      noticPeriodController.clear();
      lockPeriodController.clear();
      tempMonthlyRent.clear();
      tempDeposit.clear();

      // Clear reactive variables
      isOwner.value = true;
      propertyType.value = "";
      lookingTo.value = "";
      tempRoomType.value = '';
      // stepperSelectedIndex.value = 0; // <-- REMOVE THIS LINE
      editingIndex.value = -1;

      // Clear lists
      rooms.clear();
      selectedImages.clear();
      // reviewList.clear();
      // selectedItems.clear();
      mealAvailableList.clear();
      bestSuitedList.clear();
      commonAreasList.clear();
    } finally {
      isProcessing.value = false;
    }
  }

  /// CRUD Property Operations
  /// Eidt
  Future<void> updateProperty(String propertyId) async {
    try {
      isLoading.value = true;

      final type = propertyType.value.toLowerCase();
      final action = lookingTo.value.toLowerCase();
      final subtype = selectedIndex.value.toLowerCase(); // For commercial cases

      if (type.isEmpty || action.isEmpty) {
        print("Error: Property type or action is empty.");
        return;
      }

      bool success = false;

      if (type == "residential") {
        switch (action) {
          case "rent":
            success = await _addPropertyResidentialRent(
              isEdit: true,
              propertyId: propertyId,
            );
            break;
          case "sell":
            success = await _addPropertyResidentialSell(
              isEdit: true,
              propertyId: propertyId,
            );
            break;
          case "pg/co-living":
            success = await _addPropertyResidentialPg(
              isEdit: true,
              propertyId: propertyId,
            );
            break;
          default:
            print("Error: Invalid residential action");
        }
      } else if (type == "commercial") {
        switch (action) {
          case "rent":
            success = await _editPropertyCommercialRent(
              subtype,
              isEdit: true,
              propertyId: propertyId,
            );
            break;
          case "sell":
            success = await _editPropertyCommercialSell(
              subtype,
              isEdit: true,
              propertyId: propertyId,
            );
            break;
          default:
            print("Error: Invalid commercial action");
        }
      } else {
        print("Error: Invalid property type");
      }
      if (success) {
        print("Property added successfully ✅");
        Get.offAll(() => DashboardScreen());
      } else {
        print("Failed to Updater property ❌");
      }
    } catch (e) {
      print("Error adding property: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Create
  Future<void> addProperty() async {
    try {
      isLoading.value = true;
      log('🧩 addProperty() called');
      final subtypeSection = rent_propertyType.value.toLowerCase();

      log('steps length: ${stepsList.length}');
      log(
        'propertyType: ${propertyType.value}, lookingTo: ${lookingTo.value},subtype: ${subtypeSection} ',
      );

      final type = propertyType.value.toLowerCase();
      final action = lookingTo.value.toLowerCase();

      final subtype = selectedIndex.value.toLowerCase(); // For commercial cases

      if (type.isEmpty || action.isEmpty) {
        print("Error: Property type or action is empty.");
        return;
      }

      bool success = false;

      if (type == "residential") {
        switch (action) {
          case "rent":
            success = await _addPropertyResidentialRent();
            break;
          case "sell":
            if ((subtypeSection == "plot") ||
                (subtypeSection == "agricultural land")) {
              success = await _addPropertyResidentialSellPlot();
            } else {
              success = await _addPropertyResidentialSell();
            }
            break;

          case "pg/co-living":
            success = await _addPropertyResidentialPg();
            break;
          default:
            print("Error: Invalid residential action");
        }
      } else if (type == "commercial") {
        switch (action) {
          case "rent":
            success = await _addPropertyCommercialRent(subtype);
            break;
          case "sell":
            success = await _addPropertyCommercialSell(subtype);
            break;
          default:
            print("Error: Invalid commercial action");
        }
      } else {
        print("Error: Invalid property type");
      }
      if (success) {
        print("Property added successfully ✅");
        Get.offAll(() => DashboardScreen());
      } else {
        print("Failed to add property ❌");
      }
    } catch (e, s) {
      log('❌ addProperty error: $e');
      log('Stacktrace: $s');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _addPropertyResidentialSellPlot({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadResidentialSellPlot();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential sell: $e");
      return false;
    }
  }

  //
  // ---------- RESIDENTIAL ----------
  //
  Future<bool> _addPropertyResidentialRent({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadResidentialRent();
      debugPrint("Payload : ${payload.toJson()}");
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential rent: $e");
      return false;
    }
  }

  Future<bool> _addPropertyResidentialSell({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadResidentialSell();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential sell: $e");
      return false;
    }
  }

  Future<bool> _addPropertyResidentialPg({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadResidentialPG();
      AppLogger.structured(
        "Payload : ",
        payload.propertyDetails?.furnishInfo?.toJson(),
      );
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  //
  // ---------- COMMERCIAL RENT ----------
  //
  Future<bool> _addPropertyCommercialRent(
    String subtype, {
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      switch (subtype) {
        case "plot":
          print("Adding Commercial Rent → Plot");
          return await _addPropertyCommercialRentPlot();
          break;
        case "other":
          print("Adding Commercial Rent → Other");
          return await _addPropertyCommercialRentOther();
          break;
        case "office":
          print("Adding Commercial Rent → Office");
          return await _addPropertyCommercialRentOffice();
          break;
        case "showroom":
          print("Adding Commercial Rent → Showroom");
          return await _addPropertyCommercialRentShowRoom();
          break;
        case "shop":
          print("Adding Commercial Rent → Shop");
          return await _addPropertyCommercialRentShop();
          break;
        case "warehouse":
          print("Adding Commercial Rent → Warehouse");
          return await _addPropertyCommercialRentWarehouse();
          break;
        default:
          print("Error: Invalid commercial rent subtype");
          return false;
      }
    } catch (e) {
      print("Error adding commercial rent: $e");
      return false;
    }
  }

  Future<bool> _editPropertyCommercialRent(
    String subtype, {
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      switch (subtype) {
        case "plot":
          print("Adding Commercial Rent → Plot");
          return await _addPropertyCommercialRentPlot(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "other":
          print("Adding Commercial Rent → Other");
          return await _addPropertyCommercialRentOther(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "office":
          print("Adding Commercial Rent → Office");
          return await _addPropertyCommercialRentOffice(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "showroom":
          print("Adding Commercial Rent → Showroom");
          return await _addPropertyCommercialRentShowRoom(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "shop":
          print("Adding Commercial Rent → Shop");
          return await _addPropertyCommercialRentShop(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "warehouse":
          print("Adding Commercial Rent → Warehouse");
          return await _addPropertyCommercialRentWarehouse(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        default:
          print("Error: Invalid commercial rent subtype");
          return false;
      }
    } catch (e) {
      print("Error adding commercial rent: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialRentPlot({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadCommercialRentPlot();
      AppLogger.structured(
        "Payload Rent Plot In Commercial  : ",
        payload.toJson(),
      );
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialRentOther({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadCommercialRentOther();
      AppLogger.structured("Payload for Commercial other : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialRentOffice({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // }
      // debugPrint(
      //   "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      // );
      // debugPrint("Zone Type : ${commercial_ZoneType.value}");
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      // debugPrint("Property Condition : ${commercial_property_condition.value}");
      // if (commercial_property_condition.value == "Ready to use") {
      //   debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      //   debugPrint(
      //     "Built Up Area : ${commercial_Square_BuildArea.text.trim()}",
      //   );
      //   debugPrint("ownership : ${commercial_ownerShipList.value}");
      //   debugPrint("Seats : ${commercial_seats.text.trim()}");
      //   debugPrint("Cabins : ${commercial_cabins.text.trim()}");
      //   debugPrint("Meeting Rooms : ${commercial_meeting_room.text.trim()}");
      //   debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      //   debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // } else {
      //   debugPrint(
      //     "Built Up Area : ${commercial_Square_BuildArea.text.trim()}",
      //   );
      //   debugPrint("ownership : ${commercial_ownerShipList.value}");
      //   debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      //   debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // }
      //
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialRentOffice();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialRentShowRoom({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // }
      // debugPrint(
      //   "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      // );
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      //
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      //
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialRentShowRoom();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialRentShop({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // }
      // debugPrint(
      //   "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      // );
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      //
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      //
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialRentShop();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialRentWarehouse({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // }
      // debugPrint(
      //   "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      // );
      // debugPrint("Zone Type : ${commercial_ZoneType.value}");
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      //
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      //
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialRentWarehouse();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  //
  // ---------- COMMERCIAL SELL ----------
  //
  Future<bool> _addPropertyCommercialSell(String subtype) async {
    try {
      switch (subtype) {
        case "plot":
          print("Adding Commercial Sell → Plot");
          return await _addPropertyCommercialSellPlot();
          break;
        case "other":
          print("Adding Commercial Sell → Other");
          return await _addPropertyCommercialSellOther();
          break;
        case "office":
          print("Adding Commercial Sell → Office");
          return await _addPropertyCommercialSellOffice();
          break;
        case "showroom":
          print("Adding Commercial Sell → Showroom");
          return await _addPropertyCommercialSellShowRoom();
          break;
        case "shop":
          print("Adding Commercial Sell → Shop");
          return await _addPropertyCommercialSellShop();
          break;
        case "warehouse":
          print("Adding Commercial Sell → Warehouse");
          return await _addPropertyCommercialSellWarehouse();
          break;
        default:
          print("Error: Invalid commercial sell subtype");
          return false;
      }
    } catch (e) {
      print("Error adding commercial sell: $e");
      return false;
    }
  }

  Future<bool> _editPropertyCommercialSell(
    String subtype, {
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      switch (subtype) {
        case "plot":
          print("Adding Commercial Sell → Plot");
          return await _addPropertyCommercialSellPlot(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "other":
          print("Adding Commercial Sell → Other");
          return await _addPropertyCommercialSellOther();
          break;
        case "office":
          print("Adding Commercial Sell → Office");
          return await _addPropertyCommercialSellOffice(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "showroom":
          print("Adding Commercial Sell → Showroom");
          return await _addPropertyCommercialSellShowRoom(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "shop":
          print("Adding Commercial Sell → Shop");
          return await _addPropertyCommercialSellShop(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        case "warehouse":
          print("Adding Commercial Sell → Warehouse");
          return await _addPropertyCommercialSellWarehouse(
            isEdit: true,
            propertyId: propertyId,
          );
          break;
        default:
          print("Error: Invalid commercial sell subtype");
          return false;
      }
    } catch (e) {
      print("Error adding commercial sell: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialSellPlot({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      final payload = await buildPropertyPayloadCommercialSellPlot();
      AppLogger.structured("Payload Commercial Sell Plot : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialSellOther() async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Property Name: : ${commercial_Property_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // } else {
      //   debugPrint(
      //     "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      //   );
      // }
      // debugPrint("Zone Type : ${commercial_ZoneType.value}");
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected cost : ${commercial_rent_cost.text.trim()}");
      // debugPrint("is Pre leased : ${commercial_isPreLeased.value}");
      // if (commercial_isPreLeased.value.toLowerCase() == "yes") {
      //   debugPrint(
      //     "current rent per month ${commercial_current_rent_preLeasedTill.text.trim()}",
      //   );
      //   debugPrint("Lease Year ${commercial_lease_years.text.trim()}");
      // } else {
      //   debugPrint("Expected R.O.I % ${commercial_returned_RIO.text.trim()}");
      // }
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialSellOther();
      AppLogger.structured("Payload : ", payload.toJson());
      final success = await _propertyService.createProperty(
        payload.toJson(),
        imageList.map((element) => File(element)).toList(),
        videoList.map((element) => File(element)).toList(),
        documentList.map((element) => File(element)).toList(),
      );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialSellOffice({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // } else {
      //   debugPrint(
      //     "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      //   );
      // }
      // debugPrint("Zone Type : ${commercial_ZoneType.value}");
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      // debugPrint("Property Condition : ${commercial_property_condition.value}");
      // if (commercial_property_condition.value == "Ready to use") {
      //   debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      //   debugPrint(
      //     "Built Up Area : ${commercial_Square_BuildArea.text.trim()}",
      //   );
      //   debugPrint("ownership : ${commercial_ownerShipList.value}");
      //   debugPrint("Seats : ${commercial_seats.text.trim()}");
      //   debugPrint("Cabins : ${commercial_cabins.text.trim()}");
      //   debugPrint("Meeting Rooms : ${commercial_meeting_room.text.trim()}");
      //   debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      //   debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // } else {
      //   debugPrint(
      //     "Built Up Area : ${commercial_Square_BuildArea.text.trim()}",
      //   );
      //   debugPrint("ownership : ${commercial_ownerShipList.value}");
      //   debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      //   debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // }
      //
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialSellOffice();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialSellShowRoom({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // } else {
      //   debugPrint(
      //     "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      //   );
      // }
      //
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      //
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      //
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialSellShowRoom();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialSellShop({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // } else {
      //   debugPrint(
      //     "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      //   );
      // }
      //
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      //
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      //
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialSellShop();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<bool> _addPropertyCommercialSellWarehouse({
    bool isEdit = false,
    String? propertyId,
  }) async {
    try {
      // debugPrint("Property Type : ${propertyType.value}");
      // debugPrint("Looking to Type : ${lookingTo.value}");
      // debugPrint("City : ${cityController.text.trim()}");
      // debugPrint("Sub Category : ${selectedIndex.value}");
      // debugPrint("Building : ${commercial_rent_building_Name.text.trim()}");
      // debugPrint("Locality : ${commercial_rent_Loaclity_Name.text.trim()}");
      // debugPrint("Possession Status: ${commercial_rent_posessionStatus.value}");
      // if (commercial_rent_posessionStatus.value == "Ready to move") {
      //   debugPrint(
      //     "Age of Property : ${commercial_rent_AgeOfPropertInYear.text.trim()}",
      //   );
      // } else {
      //   debugPrint(
      //     "Available From: ${commercial_rent_AvailableFrom.text.trim()}",
      //   );
      // }
      //
      // debugPrint("Zone Type : ${commercial_ZoneType.value}");
      // debugPrint("Location Hub : ${commercial_LocationHub.value}");
      //
      // debugPrint("Carpet Area : ${commercial_Square_CarpetArea.text.trim()}");
      // debugPrint("Built Up Area : ${commercial_Square_BuildArea.text.trim()}");
      // debugPrint("ownership : ${commercial_ownerShipList.value}");
      //
      // debugPrint("Floor Available : ${commercial_total_floor.text.trim()}");
      // debugPrint("Your Floor : ${commercial_your_floor.text.trim()}");
      // debugPrint("Expected Rent : ${commercial_rent_cost.text.trim()}");
      // debugPrint(
      //   "Amenities : ${selectedCommercialAmenities.map((element) => element.toLowerCase()).join(", ")}",
      // );

      final payload = await buildPropertyPayloadCommercialSellWarehouse();
      AppLogger.structured("Payload : ", payload.toJson());
      final success =
          isEdit
              ? await _propertyService.updateProperty(
                propertyId ?? '',
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              )
              : await _propertyService.createProperty(
                payload.toJson(),
                imageList.map((element) => File(element)).toList(),
                videoList.map((element) => File(element)).toList(),
                documentList.map((element) => File(element)).toList(),
              );
      return success;
    } catch (e) {
      print("Error adding residential pg: $e");
      return false;
    }
  }

  Future<AddPropertyModel> buildPropertyPayloadResidentialRent() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";
    final parsedDate = DateFormat(
      'dd/MM/yyyy',
    ).parse(rent_AvailableFrom.text.trim());
    final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return AddPropertyModel(
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      propertyType:
          rent_propertyType.value.isNotEmpty
              ? rent_propertyType.value.toLowerCase().replaceAll(" ", "_")
              : null,
      propertyDescription:
          sell_rent_propertyDescriptionController.text.trim().isNotEmpty
              ? sell_rent_propertyDescriptionController.text.trim()
              : null,
      propertyDetails: PropertyDetails(
        bhk: int.tryParse(bhkType.value.substring(0, 1)),
        bathroom: rent_Bathroom.value,
        balcony: rent_Balcony.value,

        petFriendly:
            rent_Pet_Friendly.value.toLowerCase() == 'yes' ? true : false,
        propertyBuiltUpArea:
            areaController.text.trim().isNotEmpty
                ? double.tryParse(areaController.text.trim())
                : null,
        propertyCarpetArea:
            carpetAreaController.text.trim().isNotEmpty
                ? double.tryParse(carpetAreaController.text.trim())
                : null,

        propertyBuiltUpAreaUnit:
            areaUnit.value.isNotEmpty ? removeDots(areaUnit.value) : null,
        propertyCarpetAreaUnit:
            carpetAreaUnit.value.isNotEmpty
                ? removeDots(carpetAreaUnit.value)
                : null,
        propertyFacing: rent_facing.value.isNotEmpty ? rent_facing.value : null,
        serventRoom:
            sell_rent_Servent_Room.value.toLowerCase() == 'yes' ? true : false,
        amenities:
            selectedRoomAmenities.value.isNotEmpty
                ? selectedRoomAmenities.value
                : null,
        possessionInfo: PossessionInfo(
          possessionDate:
              rent_AvailableFrom.text.trim().isNotEmpty ? formattedDate : null,
        ),
        lifInfo: LiftInfo(
          serviceLift:
              lift_info.value.isNotEmpty &&
                      lift_info.value.toLowerCase() == 'yes'
                  ? true
                  : false,
        ),
        floorInfo:
            (sell_rent_Floor_No.text.trim().isNotEmpty ||
                    sell_rent_Total_Floor.text.trim().isNotEmpty)
                ? FloorInfo(
                  floorNumber: int.tryParse(sell_rent_Floor_No.text.trim()),
                  totalFloors: int.tryParse(sell_rent_Total_Floor.text.trim()),
                )
                : null,
        parkingInfo:
            (rent_CoveredParking.value.isNotEmpty ||
                    rent_OpenParking.value.isNotEmpty)
                ? ParkingInfo(
                  coveredParking:
                      int.tryParse(rent_CoveredParking.value) != null &&
                      int.tryParse(rent_CoveredParking.value)! > 0,
                  openParking:
                      int.tryParse(rent_OpenParking.value) != null &&
                      int.tryParse(rent_OpenParking.value)! > 0,
                )
                : null,
        financialInfo:
            (rent_MonthilyRent.text.trim().isNotEmpty ||
                    rent_SecurityDeposit.text.trim().isNotEmpty)
                ? FinancialInfo(
                  propertyRentPerMonth: double.tryParse(
                    rent_MonthilyRent.text.trim(),
                  ),

                  propertySecurityDeposit: double.tryParse(
                    rent_SecurityDeposit.text.trim(),
                  ),
                  is_for_sellorrent: isPredefinedCostEnabled.value,
                  propertyPrice: double.tryParse(
                    sell_ExpectedPrice.text.trim(),
                  ),
                  negotiable:
                      negotiablePriceOrNot.value.toLowerCase() == 'yes'
                          ? true
                          : false,
                  lockInPeriod:
                      lockPeriodController.text.isNotEmpty
                          ? int.tryParse(lockPeriodController.text.trim())
                          : null,
                  noticePeriod:
                      noticPeriodController.text.isNotEmpty
                          ? int.tryParse(noticPeriodController.text.trim())
                          : null,
                  brokerCommission: double.tryParse(
                    brokerRageCommission.text.trim(),
                  ),
                  platformFees: double.tryParse(platformFees.text.trim()),
                  maintenanceCharges:
                      rent_maintenanceChargeType.value.toLowerCase() ==
                              "separate"
                          ? double.tryParse(
                            sell_rent_Maintenance_Charges.text.trim(),
                          )
                          : null,
                  brokerNegotiable:
                      brokerageChargeNegotiable.value.toLowerCase() == 'yes'
                          ? true
                          : false,
                  parkingCharges:
                      rent_Parking_Charges.value.toLowerCase() == "separate"
                          ? rent_Custom_Parking_Charges.text.trim()
                          : null,
                )
                : null,
        furnishInfo:
            furnishingType.value.isNotEmpty
                ? PropertyFurnishInfo(
                  furnishType: furnishingType.value,
                  furnishDetails: FurnishDetails(
                    // ---------- Multi-choice (int) ----------
                    fan: int.tryParse(
                      selectedFurnishing.value['fan']?.quantity.toString() ??
                          '',
                    ),
                    light: int.tryParse(
                      selectedFurnishing.value['light']?.quantity.toString() ??
                          '',
                    ),
                    ac: int.tryParse(
                      selectedFurnishing.value['ac']?.quantity.toString() ?? '',
                    ),
                    wardrobe: int.tryParse(
                      selectedFurnishing.value['wardrobe']?.quantity
                              .toString() ??
                          '',
                    ),
                    tv: int.tryParse(
                      selectedFurnishing.value['tv']?.quantity.toString() ?? '',
                    ),
                    bed: int.tryParse(
                      selectedFurnishing.value['bed']?.quantity.toString() ??
                          '',
                    ),
                    geyser: int.tryParse(
                      selectedFurnishing.value['geyser']?.quantity.toString() ??
                          '',
                    ),

                    // ---------- Boolean Furnishings ----------
                    diningTable:
                        selectedFurnishing.value['table']?.quantity == 1
                            ? true
                            : false,
                    washingMachine:
                        selectedFurnishing.value['washing']?.quantity == 1
                            ? true
                            : false,
                    cupboard:
                        selectedFurnishing.value['cupboard']?.quantity == 1
                            ? true
                            : false,
                    sofa:
                        selectedFurnishing.value['sofa']?.quantity == 1
                            ? true
                            : false,
                    microwave:
                        selectedFurnishing.value['microwave']?.quantity == 1
                            ? true
                            : false,
                    stove:
                        selectedFurnishing.value['stove']?.quantity == 1
                            ? true
                            : false,
                    fridge:
                        selectedFurnishing.value['refrigerate']?.quantity == 1
                            ? true
                            : false,
                    waterPurifier:
                        selectedFurnishing.value['water-purifier']?.quantity ==
                                1
                            ? true
                            : false,
                    gasPipeline:
                        selectedFurnishing.value['gas-pipline']?.quantity == 1
                            ? true
                            : false,
                    chimney:
                        selectedFurnishing.value['chimeny']?.quantity == 1
                            ? true
                            : false,
                    modularKitchen:
                        selectedFurnishing.value['modular-kitchen']?.quantity ==
                                1
                            ? true
                            : false,
                  ),
                )
                : null,
      ),
      location:
          localityController.text.trim().isNotEmpty
              ? localityController.text.trim()
              : null,
      state: extractState(localityController.text.trim()),

      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadResidentialSell() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";
    final parsedDate = DateFormat(
      'dd/MM/yyyy',
    ).tryParse(sell_AvailableFrom.text.trim());
    final formattedDate =
        (parsedDate != null)
            ? DateFormat('yyyy-MM-dd').format(parsedDate)
            : null;
    final data = AddPropertyModel(
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,

      propertyType:
          rent_propertyType.value.isNotEmpty
              ? rent_propertyType.value.toLowerCase().replaceAll(" ", "_")
              : null,
      propertyDescription:
          sell_rent_propertyDescriptionController.text.trim().isNotEmpty
              ? sell_rent_propertyDescriptionController.text.trim()
              : null,
      propertyDetails: PropertyDetails(
        bhk: int.tryParse(
          bhkType.value
              .split(RegExp(r'\D'))
              .firstWhere((e) => e.isNotEmpty, orElse: () => ''),
        ),

        transactionType:
            transactionType.value.isNotEmpty
                ? transactionType.value.toLowerCase().replaceAll(" ", "_")
                : null,
        bathroom: rent_Bathroom.value,
        balcony: rent_Balcony.value,
        serventRoom: sell_rent_Servent_Room.value.toLowerCase() == 'yes',

        propertyBuiltUpArea:
            areaController.text.trim().isNotEmpty
                ? double.tryParse(areaController.text.trim())
                : null,
        propertyCarpetArea:
            carpetAreaController.text.trim().isNotEmpty
                ? double.tryParse(carpetAreaController.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            areaUnit.value.isNotEmpty ? removeDots(areaUnit.value) : null,
        propertyCarpetAreaUnit:
            carpetAreaUnit.value.isNotEmpty
                ? removeDots(carpetAreaUnit.value)
                : null,
        propertyFacing: rent_facing.value.isNotEmpty ? rent_facing.value : null,
        amenities:
            selectedRoomAmenities.value.isNotEmpty
                ? selectedRoomAmenities.value
                : null,

        floorInfo:
            (sell_rent_Floor_No.text.trim().isNotEmpty ||
                    sell_rent_Total_Floor.text.trim().isNotEmpty)
                ? FloorInfo(
                  floorNumber: int.tryParse(sell_rent_Floor_No.text.trim()),
                  totalFloors: int.tryParse(sell_rent_Total_Floor.text.trim()),
                )
                : null,
        possessionInfo: PossessionInfo(
          propertyAgeInYear:
              sell_constructionStatus.value.toLowerCase() == 'ready to move'
                  ? ageOfPropertyController.text.trim().isNotEmpty
                      ? ageOfPropertyController.text.trim()
                      : null
                  : null,
          possessionDate:
              sell_constructionStatus.value.toLowerCase() ==
                      'under construction'
                  ? ((sell_AvailableFrom.text.trim().isNotEmpty) &&
                          (formattedDate != null))
                      ? formattedDate
                      : null
                  : null,
          possessionStatus: sell_constructionStatus.value
              .toLowerCase()
              .replaceAll(" ", "_"),
        ),
        parkingInfo:
            (rent_CoveredParking.value.isNotEmpty ||
                    rent_OpenParking.value.isNotEmpty)
                ? ParkingInfo(
                  coveredParking:
                      int.tryParse(rent_CoveredParking.value) != null &&
                      int.tryParse(rent_CoveredParking.value)! > 0,
                  openParking:
                      int.tryParse(rent_OpenParking.value) != null &&
                      int.tryParse(rent_OpenParking.value)! > 0,
                )
                : null,
        lifInfo: LiftInfo(
          serviceLift: lift_info.value.toLowerCase() == 'yes' ? true : false,
        ),
        financialInfo:
            (sell_ExpectedPrice.text.trim().isNotEmpty)
                ? FinancialInfo(
                  propertyPrice: double.tryParse(
                    sell_ExpectedPrice.text.trim(),
                  ),
                  is_for_sellorrent: isPredefinedCostEnabled.value,
                  propertyRentPerMonth: double.tryParse(
                    rent_MonthilyRent.text.trim(),
                  ),
                  // propertyPricePast: List.generate(5, (index) {
                  //   final currentYear = DateTime.now().year;
                  //   final year = currentYear - (index + 1);
                  //   final priceText = pastPrices[index].text.trim();
                  //   final price = double.tryParse(priceText) ?? 0.0;
                  //   return PropertyPriceYearly(
                  //     year: year,
                  //     price: price,
                  //
                  //   );
                  // }),
                  // propertyPricePast: getPastPriceData(),

                  // 🔮 Future 5 Years Prices
                  // propertyPriceFuture: List.generate(5, (index) {
                  //   final currentYear = DateTime.now().year;
                  //   final year = currentYear + (index + 1);
                  //   final priceText = futurePrices[index].text.trim();
                  //   final price = double.tryParse(priceText) ?? 0.0;
                  //   return PropertyPriceYearly(
                  //     year: year,
                  //     price: price,
                  //
                  //   );
                  // }),
                  // propertyPriceFuture: getFuturePriceData(),
                  propertyPriceTrend: getPriceTrendData(),
                  negotiable:
                      negotiablePriceOrNot.value.toLowerCase() == 'yes'
                          ? true
                          : false,

                  maintenanceCharges:
                      sell_rent_Maintenance_Charges.text.trim().isNotEmpty
                          ? double.tryParse(
                            sell_rent_Maintenance_Charges.text.trim(),
                          )
                          : null,
                  brokerCommission: double.tryParse(
                    brokerRageCommission.text.trim(),
                  ),
                  platformFees: double.tryParse(platformFees.text.trim()),
                  brokerNegotiable:
                      doYouWantBrokerage.value.toLowerCase() == 'yes'
                          ? brokerageChargeNegotiable.value.toLowerCase() ==
                              'yes'
                          : null,
                )
                : null,
        furnishInfo:
            furnishingType.value.isNotEmpty
                ? PropertyFurnishInfo(
                  furnishType: furnishingType.value,
                  furnishDetails: FurnishDetails(
                    // ---------- Multi-choice (int) ----------
                    fan: int.tryParse(
                      selectedFurnishing.value['fan']?.quantity.toString() ??
                          '',
                    ),
                    light: int.tryParse(
                      selectedFurnishing.value['light']?.quantity.toString() ??
                          '',
                    ),
                    ac: int.tryParse(
                      selectedFurnishing.value['ac']?.quantity.toString() ?? '',
                    ),
                    wardrobe: int.tryParse(
                      selectedFurnishing.value['wardrobe']?.quantity
                              .toString() ??
                          '',
                    ),
                    tv: int.tryParse(
                      selectedFurnishing.value['tv']?.quantity.toString() ?? '',
                    ),
                    bed: int.tryParse(
                      selectedFurnishing.value['bed']?.quantity.toString() ??
                          '',
                    ),
                    geyser: int.tryParse(
                      selectedFurnishing.value['geyser']?.quantity.toString() ??
                          '',
                    ),

                    // ---------- Boolean Furnishings ----------
                    diningTable:
                        selectedFurnishing.value['table']?.quantity == 1
                            ? true
                            : false,
                    washingMachine:
                        selectedFurnishing.value['washing']?.quantity == 1
                            ? true
                            : false,
                    cupboard:
                        selectedFurnishing.value['cupboard']?.quantity == 1
                            ? true
                            : false,
                    sofa:
                        selectedFurnishing.value['sofa']?.quantity == 1
                            ? true
                            : false,
                    microwave:
                        selectedFurnishing.value['microwave']?.quantity == 1
                            ? true
                            : false,
                    stove:
                        selectedFurnishing.value['stove']?.quantity == 1
                            ? true
                            : false,
                    fridge:
                        selectedFurnishing.value['refrigerate']?.quantity == 1
                            ? true
                            : false,
                    waterPurifier:
                        selectedFurnishing.value['water-purifier']?.quantity ==
                                1
                            ? true
                            : false,
                    gasPipeline:
                        selectedFurnishing.value['gas-pipline']?.quantity == 1
                            ? true
                            : false,
                    chimney:
                        selectedFurnishing.value['chimeny']?.quantity == 1
                            ? true
                            : false,
                    modularKitchen:
                        selectedFurnishing.value['modular-kitchen']?.quantity ==
                                1
                            ? true
                            : false,
                  ),
                )
                : null,
      ),
      location:
          localityController.text.trim().isNotEmpty
              ? localityController.text.trim()
              : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      state: extractState(localityController.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
      reraId:
          sell_Rera_Id.text.trim().isNotEmpty ? sell_Rera_Id.text.trim() : null,
    );
    print("Data of residential sale : ${data.toJson()}");
    return data;
  }

  Future<AddPropertyModel> buildPropertyPayloadResidentialSellPlot() async {
    log("Containetr check any missimn");
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";
    final parsedDate = DateFormat(
      'dd/MM/yyyy',
    ).tryParse(sell_AvailableFrom.text.trim());
    final formattedDate =
        (parsedDate != null)
            ? DateFormat('yyyy-MM-dd').format(parsedDate)
            : null;
    final data = AddPropertyModel(
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,

      propertyType:
          rent_propertyType.value.isNotEmpty
              ? rent_propertyType.value.toLowerCase().replaceAll(" ", "_")
              : null,
      propertyDescription:
          sell_rent_propertyDescriptionController.text.trim().isNotEmpty
              ? sell_rent_propertyDescriptionController.text.trim()
              : null,
      propertyDetails: PropertyDetails(
        bhk: int.tryParse(
          bhkType.value
              .split(RegExp(r'\D'))
              .firstWhere((e) => e.isNotEmpty, orElse: () => ''),
        ),

        transactionType:
            transactionType.value.isNotEmpty
                ? transactionType.value.toLowerCase().replaceAll(" ", "_")
                : null,
        bathroom: rent_Bathroom.value,
        balcony: rent_Balcony.value,
        serventRoom: sell_rent_Servent_Room.value.toLowerCase() == 'yes',

        propertyBuiltUpArea:
            areaController.text.trim().isNotEmpty
                ? double.tryParse(areaController.text.trim())
                : null,
        propertyCarpetArea:
            carpetAreaController.text.trim().isNotEmpty
                ? double.tryParse(carpetAreaController.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            areaUnit.value.isNotEmpty ? removeDots(areaUnit.value) : null,
        propertyCarpetAreaUnit:
            carpetAreaUnit.value.isNotEmpty
                ? removeDots(carpetAreaUnit.value)
                : null,
        propertyFacing: rent_facing.value.isNotEmpty ? rent_facing.value : null,
        amenities:
            selectedRoomAmenities.value.isNotEmpty
                ? selectedRoomAmenities.value
                : null,

        floorInfo:
            (sell_rent_Floor_No.text.trim().isNotEmpty ||
                    sell_rent_Total_Floor.text.trim().isNotEmpty)
                ? FloorInfo(
                  floorNumber: int.tryParse(sell_rent_Floor_No.text.trim()),
                  totalFloors: int.tryParse(sell_rent_Total_Floor.text.trim()),
                )
                : null,
        parkingInfo:
            (rent_CoveredParking.value.isNotEmpty ||
                    rent_OpenParking.value.isNotEmpty)
                ? ParkingInfo(
                  coveredParking:
                      int.tryParse(rent_CoveredParking.value) != null &&
                      int.tryParse(rent_CoveredParking.value)! > 0,
                  openParking:
                      int.tryParse(rent_OpenParking.value) != null &&
                      int.tryParse(rent_OpenParking.value)! > 0,
                )
                : null,
        lifInfo: LiftInfo(
          serviceLift: lift_info.value.toLowerCase() == 'yes' ? true : false,
        ),
        financialInfo:
            (sell_ExpectedPrice.text.trim().isNotEmpty)
                ? FinancialInfo(
                  propertyPrice: double.tryParse(
                    sell_ExpectedPrice.text.trim(),
                  ),
                  is_for_sellorrent: isPredefinedCostEnabled.value,
                  propertyRentPerMonth: double.tryParse(
                    rent_MonthilyRent.text.trim(),
                  ),
                  // propertyPricePast: List.generate(5, (index) {
                  //   final currentYear = DateTime.now().year;
                  //   final year = currentYear - (index + 1);
                  //   final priceText = pastPrices[index].text.trim();
                  //   final price = double.tryParse(priceText) ?? 0.0;
                  //   return PropertyPriceYearly(
                  //     year: year,
                  //     price: price,
                  //
                  //   );
                  // }),
                  // propertyPricePast: getPastPriceData(),

                  // 🔮 Future 5 Years Prices
                  // propertyPriceFuture: List.generate(5, (index) {
                  //   final currentYear = DateTime.now().year;
                  //   final year = currentYear + (index + 1);
                  //   final priceText = futurePrices[index].text.trim();
                  //   final price = double.tryParse(priceText) ?? 0.0;
                  //   return PropertyPriceYearly(
                  //     year: year,
                  //     price: price,
                  //
                  //   );
                  // }),
                  // propertyPriceFuture: getFuturePriceData(),
                  propertyPriceTrend: getPriceTrendData(),

                  negotiable:
                      negotiablePriceOrNot.value.toLowerCase() == 'yes'
                          ? true
                          : false,

                  maintenanceCharges:
                      sell_rent_Maintenance_Charges.text.trim().isNotEmpty
                          ? double.tryParse(
                            sell_rent_Maintenance_Charges.text.trim(),
                          )
                          : null,
                  brokerCommission: double.tryParse(
                    brokerRageCommission.text.trim(),
                  ),
                  platformFees: double.tryParse(platformFees.text.trim()),
                  brokerNegotiable:
                      doYouWantBrokerage.value.toLowerCase() == 'yes'
                          ? brokerageChargeNegotiable.value.toLowerCase() ==
                              'yes'
                          : null,
                )
                : null,
        plotInfo: PlotInfo(
          // TODO: Dynamic
          plotLength:
              plotLength.text.trim().isNotEmpty
                  ? double.tryParse(plotLength.text.trim())
                  : null,
          plotWidth:
              plotWidth.text.trim().isNotEmpty
                  ? double.tryParse(plotWidth.text.trim())
                  : null,
          possessionStatus: sell_constructionStatus.value,

          plotArea:
              commercial_plot.text.trim().isNotEmpty
                  ? double.tryParse(commercial_plot.text.trim())
                  : null,
          plotAreaUnit:
              commercial_plotArea.value.isNotEmpty
                  ? commercial_plotArea.value
                  : null,

          possessionDate:
              sell_constructionStatus.value.toLowerCase() == 'in future' &&
                      sell_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(sell_AvailableFrom.text.trim())
                  : null,
        ),
        furnishInfo:
            furnishingType.value.isNotEmpty
                ? PropertyFurnishInfo(
                  furnishType: furnishingType.value,
                  furnishDetails: FurnishDetails(
                    // ---------- Multi-choice (int) ----------
                    fan: int.tryParse(
                      selectedFurnishing.value['fan']?.quantity.toString() ??
                          '',
                    ),
                    light: int.tryParse(
                      selectedFurnishing.value['light']?.quantity.toString() ??
                          '',
                    ),
                    ac: int.tryParse(
                      selectedFurnishing.value['ac']?.quantity.toString() ?? '',
                    ),
                    wardrobe: int.tryParse(
                      selectedFurnishing.value['wardrobe']?.quantity
                              .toString() ??
                          '',
                    ),
                    tv: int.tryParse(
                      selectedFurnishing.value['tv']?.quantity.toString() ?? '',
                    ),
                    bed: int.tryParse(
                      selectedFurnishing.value['bed']?.quantity.toString() ??
                          '',
                    ),
                    geyser: int.tryParse(
                      selectedFurnishing.value['geyser']?.quantity.toString() ??
                          '',
                    ),

                    // ---------- Boolean Furnishings ----------
                    diningTable:
                        selectedFurnishing.value['table']?.quantity == 1
                            ? true
                            : false,
                    washingMachine:
                        selectedFurnishing.value['washing']?.quantity == 1
                            ? true
                            : false,
                    cupboard:
                        selectedFurnishing.value['cupboard']?.quantity == 1
                            ? true
                            : false,
                    sofa:
                        selectedFurnishing.value['sofa']?.quantity == 1
                            ? true
                            : false,
                    microwave:
                        selectedFurnishing.value['microwave']?.quantity == 1
                            ? true
                            : false,
                    stove:
                        selectedFurnishing.value['stove']?.quantity == 1
                            ? true
                            : false,
                    fridge:
                        selectedFurnishing.value['refrigerate']?.quantity == 1
                            ? true
                            : false,
                    waterPurifier:
                        selectedFurnishing.value['water-purifier']?.quantity ==
                                1
                            ? true
                            : false,
                    gasPipeline:
                        selectedFurnishing.value['gas-pipline']?.quantity == 1
                            ? true
                            : false,
                    chimney:
                        selectedFurnishing.value['chimeny']?.quantity == 1
                            ? true
                            : false,
                    modularKitchen:
                        selectedFurnishing.value['modular-kitchen']?.quantity ==
                                1
                            ? true
                            : false,
                  ),
                )
                : null,
      ),
      location:
          localityController.text.trim().isNotEmpty
              ? localityController.text.trim()
              : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      state: extractState(localityController.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
      reraId:
          sell_Rera_Id.text.trim().isNotEmpty ? sell_Rera_Id.text.trim() : null,
    );
    print("Data of residential sale : ${data.toJson()}");
    return data;
  }

  Future<AddPropertyModel> buildPropertyPayloadResidentialPG() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";
    // print("PG For: ${selectedItems.value}");
    return AddPropertyModel(
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType:
          (lookingTo.value.isNotEmpty &&
                  lookingTo.value.toLowerCase() == "pg/co-living")
              ? "PG"
              : null,
      // TODO: property Type
      propertyType: "apartment",
      propertyDetails: PropertyDetails(
        pgInfo: PgInfo(
          pgName: pgNameController.text.trim(),
          pgCommonArea: commonAreasList.value.join(", "),
          totalBed:
              totalRoomsController.text.trim().isNotEmpty
                  ? int.tryParse(totalRoomsController.text.trim())
                  : 0,
          pgFor: pgFor.value,
          pgSuitedFor: bestSuitedList.value.join(", "),
          pgMealOffered:
              mealAvailable.value.toLowerCase() == 'yes'
                  ? mealAvailableList.value.first
                  : null,
          mealChargesPerMonth:
              mealCharges.value.toLowerCase() == 'separate'
                  ? int.tryParse(mealChargesTextFiled.text.trim())
                  : null,
          electricityChargesPerMonth:
              electricityCharges.value.toLowerCase() == 'separate'
                  ? int.tryParse(electricityChargesTextFiled.text.trim())
                  : null,
          pgRules:
              pgRulesAvailable.value.toLowerCase() == 'yes'
                  ? PgRules(
                    lateEntryAllowed:
                        letEntryAllowed.value.toLowerCase() == "yes"
                            ? true
                            : false,
                    nonVegAllowed:
                        nonVegAllowed.value.toLowerCase() == "yes"
                            ? true
                            : false,
                    petsAllowed:
                        petAllowed.value.toLowerCase() == "yes" ? true : false,
                    drinkingAllowed:
                        drinkingAllowed.value.toLowerCase() == "yes"
                            ? true
                            : false,
                    smokingAllowed:
                        smokingAllowed.value.toLowerCase() == "yes"
                            ? true
                            : false,
                    visitorAllowed:
                        visitorsAllowed.value.toLowerCase() == "yes"
                            ? true
                            : false,
                  )
                  : null,
          pgManageBy:
              propertyManagedBy.value.isNotEmpty
                  ? propertyManagedBy.value.toLowerCase() == "professional"
                      ? "other"
                      : propertyManagedBy.value.toLowerCase()
                  : null,
          pgOwnerStaysAtPg:
              managerStaysAtProperty.value.toLowerCase() == 'yes'
                  ? true
                  : false,
          pgRoomInfo:
              rooms.isNotEmpty
                  ? rooms
                      .map(
                        (element) => PgRoomInfo(
                          rent:
                              element.monthlyRent.isNotEmpty
                                  ? int.tryParse(element.monthlyRent)
                                  : null,
                          securityDeposit:
                              element.deposit.isNotEmpty
                                  ? int.tryParse(element.deposit)
                                  : null,
                          roomType:
                              element.roomType.isNotEmpty
                                  ? element.roomType.toLowerCase()
                                  : null,
                          roomFacilityInfo: RoomFacilityInfo(
                            wifi: element.amenities.contains('wifi'),
                            ac: element.amenities.contains('ac'),
                            tv: element.amenities.contains('tv'),
                            geyser: element.amenities.contains('geyser'),
                            fridge: element.amenities.contains('fridge'),
                            cupboard: element.amenities.contains('cupboard'),
                            other:
                                element.other.isNotEmpty ? element.other : null,
                          ),

                          // add other fields as needed
                        ),
                      )
                      .toList()
                  : null,
        ),
        amenities: selectedRoomAmenities.value,
        financialInfo: FinancialInfo(
          lockInPeriod:
              lockPeriodController.text.isNotEmpty
                  ? int.tryParse(lockPeriodController.text.trim())
                  : null,
          noticePeriod:
              noticPeriodController.text.isNotEmpty
                  ? int.tryParse(noticPeriodController.text.trim())
                  : null,
        ),
        furnishInfo: PropertyFurnishInfo(
          furnishType:
              furnishingType.value.isNotEmpty
                  ? furnishingType.value.toLowerCase().replaceAll(" ", "-")
                  : null,
          furnishDetails: FurnishDetails(
            // ---------- Multi-choice (int) ----------
            fan: int.tryParse(
              selectedFurnishing.value['fan']?.quantity.toString() ?? '',
            ),
            light: int.tryParse(
              selectedFurnishing.value['light']?.quantity.toString() ?? '',
            ),
            ac: int.tryParse(
              selectedFurnishing.value['ac']?.quantity.toString() ?? '',
            ),
            wardrobe: int.tryParse(
              selectedFurnishing.value['wardrobe']?.quantity.toString() ?? '',
            ),
            tv: int.tryParse(
              selectedFurnishing.value['tv']?.quantity.toString() ?? '',
            ),
            bed: int.tryParse(
              selectedFurnishing.value['bed']?.quantity.toString() ?? '',
            ),
            geyser: int.tryParse(
              selectedFurnishing.value['geyser']?.quantity.toString() ?? '',
            ),

            // ---------- Boolean Furnishings ----------
            diningTable:
                selectedFurnishing.value['table']?.quantity == 1 ? true : false,
            washingMachine:
                selectedFurnishing.value['washing']?.quantity == 1
                    ? true
                    : false,
            cupboard:
                selectedFurnishing.value['cupboard']?.quantity == 1
                    ? true
                    : false,
            sofa:
                selectedFurnishing.value['sofa']?.quantity == 1 ? true : false,
            microwave:
                selectedFurnishing.value['microwave']?.quantity == 1
                    ? true
                    : false,
            stove:
                selectedFurnishing.value['stove']?.quantity == 1 ? true : false,
            fridge:
                selectedFurnishing.value['refrigerate']?.quantity == 1
                    ? true
                    : false,
            waterPurifier:
                selectedFurnishing.value['water-purifier']?.quantity == 1
                    ? true
                    : false,
            gasPipeline:
                selectedFurnishing.value['gas-pipline']?.quantity == 1
                    ? true
                    : false,
            chimney:
                selectedFurnishing.value['chimeny']?.quantity == 1
                    ? true
                    : false,
            modularKitchen:
                selectedFurnishing.value['modular-kitchen']?.quantity == 1
                    ? true
                    : false,
          ),
        ),
      ),

      location:
          localityController.text.trim().isNotEmpty
              ? localityController.text.trim()
              : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      state: extractState(localityController.text.trim()),
      address:
          localityController.text.trim().isNotEmpty
              ? localityController.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialRentPlot() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        // possessionInfo: PossessionInfo(
        //   possessionDate:
        //       commercial_rent_AvailableFrom.text.trim().isNotEmpty
        //           ? formatDateForBackend(
        //             commercial_rent_AvailableFrom.text.trim(),
        //           )
        //           : null,
        // ),
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          monthlyRent:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyPrice: double.tryParse(sell_ExpectedPrice.text.trim()),
          propertyRentPerMonth:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
        ),
        plotInfo: PlotInfo(
          // TODO: Dynamic
          plotLength:
              plotLength.text.trim().isNotEmpty
                  ? double.tryParse(plotLength.text.trim())
                  : null,
          plotWidth:
              plotWidth.text.trim().isNotEmpty
                  ? double.tryParse(plotWidth.text.trim())
                  : null,
          possessionStatus: commercial_rent_posessionStatus.value,
          plotArea:
              commercial_plot.text.trim().isNotEmpty
                  ? double.tryParse(commercial_plot.text.trim())
                  : null,
          plotAreaUnit:
              commercial_plotArea.value.isNotEmpty
                  ? commercial_plotArea.value
                  : null,
          // possessionDate: formatDateForBackend(
          //   commercial_rent_AvailableFrom.text.trim(),
          // ),
          possessionDate:
              commercial_rent_posessionStatus.value.toLowerCase() ==
                          'in future' &&
                      commercial_rent_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(
                    commercial_rent_AvailableFrom.text.trim(),
                  )
                  : null,
        ),
      ),
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,

      state: extractState(commercial_rent_Loaclity_Name.text.trim()),

      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialRentOther() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building,available from, floor, rent, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      propertyType: selectedIndex.value.isNotEmpty ? "others" : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(
                    commercial_rent_AvailableFrom.text.trim(),
                  )
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),
        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,

        financialInfo: FinancialInfo(
          //TODO: Implement Remain
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyPrice: double.tryParse(sell_ExpectedPrice.text.trim()),
          propertyRentPerMonth:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          monthlyRent:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          // propertyPrice:
          //     commercial_rent_cost.text.trim().isNotEmpty
          //         ? double.tryParse(commercial_rent_cost.text.trim())
          //         : null,
        ),
        // floorInfo: FloorInfo(
        //   totalFloors: commercial_total_floor.text.trim().isNotEmpty ?
        //   int.tryParse(commercial_total_floor.text.trim()):null,
        // )
      ),
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),

      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,

      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialRentOffice() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(
                    commercial_rent_AvailableFrom.text.trim(),
                  )
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        propertyCondition:
            commercial_property_condition.value.isNotEmpty
                ? commercial_property_condition.value.toLowerCase().replaceAll(
                  " ",
                  "_",
                )
                : null,
        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_property_condition.value == "Ready to use"
                ? commercial_Square_CarpetArea.text.trim().isNotEmpty
                    ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                    : null
                : null,
        propertyBuiltUpAreaUnit:
            commercial_property_condition.value == "Ready to use"
                ? commercial_Square_AreaUnti_Build.value.isNotEmpty
                    ? commercial_Square_AreaUnti_Build.value
                    : null
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,
        facilitiesInfo:
            commercial_property_condition.value == "Ready to use"
                ? FacilitiesInfo(
                  minSeats:
                      commercial_seats.text.trim().isNotEmpty
                          ? asInt(commercial_seats.text.trim())
                          : null,
                  minSeatsCamel:
                      commercial_seats.text.trim().isNotEmpty
                          ? asInt(commercial_seats.text.trim())
                          : null,
                  numberOfCabins:
                      commercial_cabins.text.trim().isNotEmpty
                          ? asInt(commercial_cabins.text.trim())
                          : null,
                  numberOfCabinsCamel:
                      commercial_cabins.text.trim().isNotEmpty
                          ? asInt(commercial_cabins.text.trim())
                          : null,
                  numberOfMeetingRooms:
                      commercial_meeting_room.text.trim().isNotEmpty
                          ? asInt(commercial_meeting_room.text.trim())
                          : null,
                  numberOfMeetingRoomsCamel:
                      commercial_meeting_room.text.trim().isNotEmpty
                          ? asInt(commercial_meeting_room.text.trim())
                          : null,
                )
                : null,
        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          propertyRentPerMonth:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyPrice: double.tryParse(sell_ExpectedPrice.text.trim()),
          negotiable:
              commercial_rent_price_negotiable.value.toLowerCase() == 'yes'
                  ? true
                  : false,
          brokerNegotiable:
              commercial_rent_brokage_negotiable.value.toLowerCase() == 'yes'
                  ? true
                  : false,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          maintenanceCharges:
              commercial_rent_maintainance_charge.value.toLowerCase() ==
                      'separate'
                  ? double.tryParse(
                    commercial_rent_mainatainance_charge.text.trim(),
                  )
                  : null,
        ),
      ),
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,

      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,

      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialRentShowRoom() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(
                    commercial_rent_AvailableFrom.text.trim(),
                  )
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),

        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyPrice: double.tryParse(sell_ExpectedPrice.text.trim()),
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          propertyRentPerMonth:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
        ),
      ),
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialRentShop() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType: selectedIndex.value.isNotEmpty ? "retail_shop" : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(
                    commercial_rent_AvailableFrom.text.trim(),
                  )
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),

        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyPrice: double.tryParse(sell_ExpectedPrice.text.trim()),
          propertyRentPerMonth:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialRentWarehouse() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_AvailableFrom.text.trim().isNotEmpty
                  ? formatDateForBackend(
                    commercial_rent_AvailableFrom.text.trim(),
                  )
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyPrice: double.tryParse(sell_ExpectedPrice.text.trim()),
          propertyRentPerMonth:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialSellPlot() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          // propertyPricePast: getPastPriceData(),
          //
          // // 🔮 Future 5 Years Prices
          // propertyPriceFuture: getFuturePriceData(),
          propertyPriceTrend: getPriceTrendData(),

          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyRentPerMonth: double.tryParse(rent_MonthilyRent.text.trim()),
          propertyPrice:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          // TODO: Lease Year
          // propertyRentPerMonth:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // monthlyRent:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // TODO: R.O.I
        ),
        plotInfo: PlotInfo(
          // TODO: Dynamic
          // TODO: possession date Available From
          plotLength:
              plotLength.text.trim().isNotEmpty
                  ? double.tryParse(plotLength.text.trim())
                  : null,
          plotWidth:
              plotWidth.text.trim().isNotEmpty
                  ? double.tryParse(plotWidth.text.trim())
                  : null,
          possessionStatus: "In Future",
          plotArea:
              commercial_plot.text.trim().isNotEmpty
                  ? double.tryParse(commercial_plot.text.trim())
                  : null,
          plotAreaUnit:
              commercial_plotArea.value.isNotEmpty
                  ? commercial_plotArea.value
                  : null,
          possessionDate: formatDateForBackend(
            // commercial_rent_AvailableFrom.text.trim(),
            DateTime.now().toIso8601String(),
          ),
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialSellOther() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership, locality
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType: selectedIndex.value.isNotEmpty ? "others" : null,

      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_posessionStatus.value == "Under Construction"
                  ? commercial_rent_AvailableFrom.text.trim().isNotEmpty
                      ? formatDateForBackend(
                        commercial_rent_AvailableFrom.text.trim(),
                      )
                      : null
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,
        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        financialInfo: FinancialInfo(
          // propertyPricePast: getPastPriceData(),
          //
          // // 🔮 Future 5 Years Prices
          // propertyPriceFuture: getFuturePriceData(),
          propertyPriceTrend: getPriceTrendData(),

          propertyPrice:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          // TODO: Lease Year
          // propertyRentPerMonth:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // monthlyRent:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyRentPerMonth: double.tryParse(rent_MonthilyRent.text.trim()),
          // TODO: R.O.I
        ),

        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialSellOffice() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_posessionStatus.value == "Under Construction"
                  ? commercial_rent_AvailableFrom.text.trim().isNotEmpty
                      ? formatDateForBackend(
                        commercial_rent_AvailableFrom.text.trim(),
                      )
                      : null
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        propertyCondition:
            commercial_property_condition.value.isNotEmpty
                ? commercial_property_condition.value.toLowerCase().replaceAll(
                  " ",
                  "_",
                )
                : null,
        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_property_condition.value == "Ready to use"
                ? commercial_Square_CarpetArea.text.trim().isNotEmpty
                    ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                    : null
                : null,
        propertyBuiltUpAreaUnit:
            commercial_property_condition.value == "Ready to use"
                ? commercial_Square_AreaUnti_Build.value.isNotEmpty
                    ? commercial_Square_AreaUnti_Build.value
                    : null
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,
        facilitiesInfo:
            commercial_property_condition.value == "Ready to use"
                ? FacilitiesInfo(
                  minSeats:
                      commercial_seats.text.trim().isNotEmpty
                          ? asInt(commercial_seats.text.trim())
                          : null,
                  minSeatsCamel:
                      commercial_seats.text.trim().isNotEmpty
                          ? asInt(commercial_seats.text.trim())
                          : null,
                  numberOfCabins:
                      commercial_cabins.text.trim().isNotEmpty
                          ? asInt(commercial_cabins.text.trim())
                          : null,
                  numberOfCabinsCamel:
                      commercial_cabins.text.trim().isNotEmpty
                          ? asInt(commercial_cabins.text.trim())
                          : null,
                  numberOfMeetingRooms:
                      commercial_meeting_room.text.trim().isNotEmpty
                          ? asInt(commercial_meeting_room.text.trim())
                          : null,
                  numberOfMeetingRoomsCamel:
                      commercial_meeting_room.text.trim().isNotEmpty
                          ? asInt(commercial_meeting_room.text.trim())
                          : null,
                )
                : null,
        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          // propertyPricePast: getPastPriceData(),
          //
          // // 🔮 Future 5 Years Prices
          // propertyPriceFuture: getFuturePriceData(),
          propertyPriceTrend: getPriceTrendData(),

          propertyPrice:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,

          // TODO: Lease Year
          // propertyRentPerMonth:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // monthlyRent:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyRentPerMonth: double.tryParse(rent_MonthilyRent.text.trim()),
          // TODO: R.O.I
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialSellShowRoom() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_posessionStatus.value == "Under Construction"
                  ? commercial_rent_AvailableFrom.text.trim().isNotEmpty
                      ? formatDateForBackend(
                        commercial_rent_AvailableFrom.text.trim(),
                      )
                      : null
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),

        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          // propertyPricePast: getPastPriceData(),
          //
          // // 🔮 Future 5 Years Prices
          // propertyPriceFuture: getFuturePriceData(),
          propertyPriceTrend: getPriceTrendData(),

          propertyPrice:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          // TODO: Lease Year
          // propertyRentPerMonth:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // monthlyRent:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyRentPerMonth: double.tryParse(rent_MonthilyRent.text.trim()),
          // TODO: R.O.I
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialSellShop() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType: selectedIndex.value.isNotEmpty ? "retail_shop" : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_posessionStatus.value == "Under Construction"
                  ? commercial_rent_AvailableFrom.text.trim().isNotEmpty
                      ? formatDateForBackend(
                        commercial_rent_AvailableFrom.text.trim(),
                      )
                      : null
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),

        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          // propertyPricePast: getPastPriceData(),
          //
          // // 🔮 Future 5 Years Prices
          // propertyPriceFuture: getFuturePriceData(),
          propertyPriceTrend: getPriceTrendData(),

          propertyPrice:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          // TODO: Lease Year
          // propertyRentPerMonth:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // monthlyRent:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyRentPerMonth: double.tryParse(rent_MonthilyRent.text.trim()),
          // TODO: R.O.I
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }

  Future<AddPropertyModel> buildPropertyPayloadCommercialSellWarehouse() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? "";

    return AddPropertyModel(
      // TODO: Building, location hub, ownership
      type:
          propertyType.value.isNotEmpty
              ? propertyType.value.toLowerCase()
              : null,
      listingType: lookingTo.value.isNotEmpty ? lookingTo.value : null,
      city:
          cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
      propertyType:
          selectedIndex.value.isNotEmpty
              ? selectedIndex.value.toLowerCase()
              : null,
      propertyDetails: PropertyDetails(
        possessionInfo: PossessionInfo(
          possessionDate:
              commercial_rent_posessionStatus.value == "Under Construction"
                  ? commercial_rent_AvailableFrom.text.trim().isNotEmpty
                      ? formatDateForBackend(
                        commercial_rent_AvailableFrom.text.trim(),
                      )
                      : null
                  : null,
          possessionStatus:
              commercial_rent_posessionStatus.value.isNotEmpty
                  ? commercial_rent_posessionStatus.value
                  : null,
          propertyAgeInYear:
              commercial_rent_posessionStatus.value == "Ready to move"
                  ? commercial_rent_AgeOfPropertInYear.text.trim().isNotEmpty
                      ? commercial_rent_AgeOfPropertInYear.text.trim()
                      : null
                  : null,
        ),
        zoneType:
            commercial_ZoneType.value.isNotEmpty
                ? commercial_ZoneType.value
                : null,
        propertyBuiltUpArea:
            commercial_Square_BuildArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_BuildArea.text.trim())
                : null,
        propertyCarpetArea:
            commercial_Square_CarpetArea.text.trim().isNotEmpty
                ? double.tryParse(commercial_Square_CarpetArea.text.trim())
                : null,
        propertyBuiltUpAreaUnit:
            commercial_Square_AreaUnti_Build.value.isNotEmpty
                ? commercial_Square_AreaUnti_Build.value
                : null,
        propertyCarpetAreaUnit:
            commercial_Square_AreaUnti_Carpet.value.isNotEmpty
                ? commercial_Square_AreaUnti_Carpet.value
                : null,

        floorInfo: FloorInfo(
          totalFloors:
              commercial_total_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_total_floor.text.trim())
                  : null,
          floorNumber:
              commercial_your_floor.text.trim().isNotEmpty
                  ? int.tryParse(commercial_your_floor.text.trim())
                  : null,
        ),
        amenities:
            selectedCommercialAmenities.value.isNotEmpty
                ? selectedCommercialAmenities.value
                : null,

        financialInfo: FinancialInfo(
          // propertyPricePast: getPastPriceData(),
          //
          // // 🔮 Future 5 Years Prices
          // propertyPriceFuture: getFuturePriceData(),
          propertyPriceTrend: getPriceTrendData(),

          propertyPrice:
              commercial_rent_cost.text.trim().isNotEmpty
                  ? double.tryParse(commercial_rent_cost.text.trim())
                  : null,
          // TODO: Lease Year
          // propertyRentPerMonth:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          // monthlyRent:
          //     (commercial_isPreLeased.value.toLowerCase() == "yes")
          //         ? double.tryParse(
          //           commercial_current_rent_preLeasedTill.text.trim(),
          //         )
          //         : null,
          brokerCommission: double.tryParse(brokerRageCommission.text.trim()),
          platformFees: double.tryParse(platformFees.text.trim()),
          is_for_sellorrent: isPredefinedCostEnabled.value,
          propertyRentPerMonth: double.tryParse(rent_MonthilyRent.text.trim()),
          // TODO: R.O.I
        ),
      ),

      // location:
      //     commercial_rent_building_Name.text.trim().isNotEmpty
      //         ? commercial_rent_building_Name.text.trim()
      //         : null,
      // state: extractState(localityController.text.trim()),
      //
      // address:
      //     commercial_rent_Loaclity_Name.text.trim().isNotEmpty
      //         ? commercial_rent_Loaclity_Name.text.trim()
      //         : null,
      buildingName:
          commercial_rent_building_Name.text.trim().isNotEmpty
              ? commercial_rent_building_Name.text.trim()
              : null,
      location:
          commercial_rent_Loaclity_Name.text.trim().isNotEmpty
              ? commercial_rent_Loaclity_Name.text.trim()
              : null,
      state: extractState(commercial_rent_Loaclity_Name.text.trim()),
      address:
          sell_rent_Address.text.trim().isNotEmpty
              ? sell_rent_Address.text.trim()
              : null,
      ownerEmail: user != null ? user.user?.email : "",
      ownerPhone: user != null ? user.user?.phone : "",
      ownerName:
          user != null ? "${user.user?.firstName} ${user.user?.firstName}" : "",
    );
  }
}

String? extractState(String input) {
  final parts = input.split(',').map((e) => e.trim()).toList();
  if (parts.length >= 2) {
    return parts[parts.length - 2]; // second last is usually state
  }
  return null;
}
