import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/modules/add_property/model/furnishing_,model.dart';
import 'package:housing_flutter_app/modules/add_property/model/photo_model.dart';
import 'package:housing_flutter_app/modules/add_property/model/review_property_model.dart';
import 'package:housing_flutter_app/modules/add_property/model/room_detail_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../model/commercial_model.dart';

enum SellerType { owner, builder }

class CreatePropertyController extends GetxController {
  late MultiImagePickerController pickerController;

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
  var rent_MonthilyRent = TextEditingController();
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
    "Industrial",
    "Commercial",
    "Residential",
    "Special Economical",
    "Open Spaces",
    "Agriclture Zone",
    "Other",
  ];

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

  final tempRoomType = ''.obs;
  final tempMonthlyRent = TextEditingController();
  final tempDeposit = TextEditingController();

  RxString selectedIndex = "".obs;
  final int maxImages = 5;
  var selectedItems = <String>[].obs;
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

  @override
  void onInit() {
    checkSellerAuthentication();
    super.onInit();
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
        colorText: Colors.white,
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

  void previousStep() {
    // if (stepperSelectedIndex.value > 0) {
    //   stepperSelectedIndex.value--;
    // }
    if (stepperSelectedIndex.value > 0) {
      stepperSelectedIndex.value--;

      print('settper ${stepperSelectedIndex.value}');
      if (stepperSelectedIndex.value == 0) {
        clearAllVariablesExceptPropertyType();
      }
    }
  }

  void finalsubmitForm() {
    // Final submit logic
    debugPrint("Final form submission");
  }

  bool isSelected(String item) => selectedItems.contains(item);

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

      if (isOwner.value) {
        authController.sellerRegister(
          phone: phoneController.text.trim(),
          userType: "seller",
          sellerType: "owner",
        );
      }
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
  void saveRoom() {
    if (tempRoomType.value.isNotEmpty &&
        tempMonthlyRent.text.isNotEmpty &&
        tempDeposit.text.isNotEmpty) {
      final room = RoomModel(
        roomType: tempRoomType.value,
        monthlyRent: tempMonthlyRent.text,
        deposit: tempDeposit.text,
      );

      if (editingIndex.value == -1) {
        rooms.add(room);
      } else {
        rooms[editingIndex.value] = room;
        editingIndex.value = -1;
      }

      // Clear inputs and hide card
      clearRoomDetail();
      showAddRoomCard.value = false;
    }
  }

  // Modify clearRoomDetail method
  void clearRoomDetail() {
    tempRoomType.value = '';
    tempMonthlyRent.clear();
    tempDeposit.clear();
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
        colorText: Colors.white,
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
        colorText: Colors.white,
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
      backgroundColor: Colors.white,
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
    debugPrint(
      "selectedItems (${selectedItems.length}): ${selectedItems.join(', ')}",
    );
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

      debugPrint("Clearing all variables except propertyType...");
      String preservedPropertyType = propertyType.value;
      String isLooking = lookingTo.value; // Preserve property type

      // Clear basic reactive variables (except propertyType)
      isOwner.value = true;
      // propertyType.value = ""; // DON'T clear this
      rent_propertyType.value = "";
      lookingTo.value = "";
      countryCode.value = '+91';
      bhkType.value = "";
      isShareWithAgents.value = false;
      rent_Bathroom.value = 0;
      isLogin.value = false;
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
      selectedIndex.value = "";
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
      selectedItems.clear();
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

      // Clear review model
      review.value = null;

      // Reset stepper to step 0
      stepperSelectedIndex.value = 0;

      // Restore property type
      propertyType.value = preservedPropertyType;
      lookingTo.value = isLooking;

      debugPrint(
        "All variables cleared except propertyType: ${propertyType.value}",
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
      selectedItems.clear();
      mealAvailableList.clear();
      bestSuitedList.clear();
      commonAreasList.clear();
    } finally {
      isProcessing.value = false;
    }
  }
}
