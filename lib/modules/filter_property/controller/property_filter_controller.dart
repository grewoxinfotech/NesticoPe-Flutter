





import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyFilterControllerForFilter extends GetxController {
  ///=====================================Property Type Selection=====================
  RxInt selectedPropertyTypeIndex = 0.obs;
  RxList<String> propertyType = ['Buy', 'Rent', 'Commercial', 'PG/Co-living'].obs;
  RxList<String> verificationStatus=<String>['Verified','Non-verified'].obs;
  RxString verifiedStatusIndex=''.obs;
  RxString statusApplicateIndex=''.obs;
  RxList<String> statusOfApplicant=<String>['Approved','Rejected','Pending'].obs;
  var searchFilterByID=TextEditingController();

  ///=====================================BUY PROPERTIES=====================
  RxList<String> constructionStatus = <String>[
    'Ready to move',
    "Under Construction",
    "New Launch",
  ].obs;

  RxDouble min = 1000000.0.obs;
  RxDouble max = 200000000.0.obs;
  final Rx<RangeValues> _rangeValues = const RangeValues(1000000, 200000000).obs;

  RxString bhkType = ''.obs;
  RxString subpropertyType = ''.obs;
  RxString constructionStatusInBuy = ''.obs;

  RxList<String> bHkType = <String>[
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK",
    "5 BHK",
    "5+ BHK",
  ].obs;

  RxList<String> propertyTypesList = <String>[
    "Apartments",
    "Independent House",
    "Plot",
    "Studio",
    "Duplex",
    "PentHouse",
    "Builder Floor",
    "Villa",
  ].obs;

  ///=====================================RENT PROPERTIES=====================
  RxDouble rentMin = 5000.0.obs;
  RxDouble rentMax = 500000.0.obs;
  Rx<RangeValues> rentRangeValues = const RangeValues(5000, 500000).obs;

  RxList<String> furnishingType = <String>[
    "Unfurnished",
    "Semi Furnished",
    "Fully Furnished",
  ].obs;
  RxString rentFurnishing = ''.obs;

  ///=====================================COMMERCIAL PROPERTIES=====================
  // Commercial Buy
  RxDouble commercialMin = 2000000.0.obs;
  RxDouble commercialMax = 300000000.0.obs;
  Rx<RangeValues> commercialRangeValues = const RangeValues(2000000, 300000000).obs;

  // Commercial Area
  RxDouble areaMin = 200.0.obs;
  RxDouble areaMax = 5000.0.obs;
  Rx<RangeValues> areaRangeValues = const RangeValues(200, 5000).obs;

  // Commercial ROI
  RxDouble roiMin = 4.0.obs;
  RxDouble roiMax = 8.0.obs;
  Rx<RangeValues> roiRangeValue = const RangeValues(4.0, 8.0).obs;

  // Commercial Rent
  RxDouble commercialRentMin = 100000.0.obs;
  RxDouble commercialRentMax = 600000.0.obs;
  Rx<RangeValues> commercialRentRangeValue = const RangeValues(100000.0, 600000.0).obs;

  // Commercial Rent Area
  RxDouble commercialRentAreaMin = 200.0.obs;
  RxDouble commercialRentAreaMax = 5000.0.obs;
  Rx<RangeValues> commercialRentAreaRangeValue = const RangeValues(200.0, 5000.0).obs;

  // Commercial Categories
  RxList<String> commercialSubCategory = <String>['Buy', 'Rent'].obs;
  RxString commercialSelectedSubCategory = ''.obs;

  RxList<String> buyCommercialPropertyType = <String>[
    "Ready to use Office Space",
    "Bare Shell Office Space",
    "Shop",
    "Showroom",
    "Commercial Plot",
    "WareHouse",
    "Others",
  ].obs;
  RxString buySelectedCommercialPropertyTyp = ''.obs;

  RxList<String> saleTypeCommercialProperty = <String>[
    "New Properties",
    "Resale Properties",
  ].obs;
  RxString selectedSalesType = ''.obs;

  RxList<String> leaseTypeCommercialProperty = <String>['Pre-Leased', 'Non-Leased'].obs;
  RxString selectedCommercialLeased = ''.obs;

  List<String> possessionCommercialList = <String>["Ready to move", "Under Construction"].obs;
  RxString selectedCommercialPossession = ''.obs;

  RxList<String> availableList = <String>[
    'Within a week',
    'Within 15 days',
    'Within a month',
    'After a month',
  ].obs;
  RxString availableSelectedList = ''.obs;

  ///=====================================PG/CO-LIVING=====================
  RxDouble pgMin = 2000.0.obs;
  RxDouble pgMax = 50000.0.obs;
  Rx<RangeValues> pgRangeValues = const RangeValues(2000, 50000).obs;

  RxList<String> genderList = <String>['Male', 'Female', 'Both'].obs;
  RxString genderSelected = ''.obs;

  RxList<String> roomTypeList = <String>[
    "Private Room",
    "Double Sharing",
    "Triple Sharing",
    "3+ Sharing",
  ].obs;
  RxString roomSelectedType = ''.obs;

  RxList<String> foodAvailable = <String>['Yes', 'No'].obs;
  RxString foodSelected = ''.obs;

  ///=====================================BUILDER DATA=====================
  RxList<Map<String, dynamic>> builderList = <Map<String, dynamic>>[
    {
      "title": "ABC Builders",
      "establish_year": 1995,
      "projects_count": 12,
      "image": "assets/logo/Avant.jpg",
    },
    {
      "title": "XYZ Constructions",
      "establish_year": 2002,
      "projects_count": 7,
      "image": "assets/logo/professional.jpg",
    },
    {
      "title": "Dream Homes Pvt Ltd",
      "establish_year": 2010,
      "projects_count": 4,
      "image": "assets/logo/xYZ.jpg",
    },
  ].obs;
  RxMap<String, dynamic> selectedMap = <String, dynamic>{}.obs;

  ///=====================================GETTERS=====================
  RangeValues get rangeValues => _rangeValues.value;

  ///=====================================METHODS=====================

  /// Change property type and reset values to avoid out-of-bounds errors
  void changePropertyType(int index) {
    selectedPropertyTypeIndex.value = index;

    // Reset range values based on selected property type to prevent out-of-bounds errors
    switch (propertyType[index]) {
      case 'Buy':
      // Ensure Buy range values are within bounds
        if (_rangeValues.value.start < min.value || _rangeValues.value.end > max.value) {
          _rangeValues.value = RangeValues(min.value, max.value);
        }
        break;
      case 'Rent':
      // Ensure Rent range values are within bounds
        if (rentRangeValues.value.start < rentMin.value || rentRangeValues.value.end > rentMax.value) {
          rentRangeValues.value = RangeValues(rentMin.value, rentMax.value);
        }
        break;
      case 'Commercial':
      // Reset commercial values based on sub-category
        if (commercialSelectedSubCategory.value == 'Buy' || commercialSelectedSubCategory.value.isEmpty) {
          if (commercialRangeValues.value.start < commercialMin.value || commercialRangeValues.value.end > commercialMax.value) {
            commercialRangeValues.value = RangeValues(commercialMin.value, commercialMax.value);
          }
        } else {
          if (commercialRentRangeValue.value.start < commercialRentMin.value || commercialRentRangeValue.value.end > commercialRentMax.value) {
            commercialRentRangeValue.value = RangeValues(commercialRentMin.value, commercialRentMax.value);
          }
        }
        // Reset area values
        if (areaRangeValues.value.start < areaMin.value || areaRangeValues.value.end > areaMax.value) {
          areaRangeValues.value = RangeValues(areaMin.value, areaMax.value);
        }
        // Reset ROI values
        if (roiRangeValue.value.start < roiMin.value || roiRangeValue.value.end > roiMax.value) {
          roiRangeValue.value = RangeValues(roiMin.value, roiMax.value);
        }
        // Reset commercial rent area values
        if (commercialRentAreaRangeValue.value.start < commercialRentAreaMin.value || commercialRentAreaRangeValue.value.end > commercialRentAreaMax.value) {
          commercialRentAreaRangeValue.value = RangeValues(commercialRentAreaMin.value, commercialRentAreaMax.value);
        }
        break;
      case 'PG/Co-living':
      // Ensure PG range values are within bounds
        if (pgRangeValues.value.start < pgMin.value || pgRangeValues.value.end > pgMax.value) {
          pgRangeValues.value = RangeValues(pgMin.value, pgMax.value);
        }
        break;
    }

    print('Property type changed to: ${propertyType[selectedPropertyTypeIndex.value]}');
    resetFilters();
  }

  /// Buy property price range with validation
  void buyerPriceRange(RangeValues value) {
    // Ensure values are within bounds
    final clampedStart = value.start.clamp(min.value, max.value);
    final clampedEnd = value.end.clamp(min.value, max.value);
    _rangeValues.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Rent property price range with validation
  void dynamicRentChangeValue(RangeValues value) {
    final clampedStart = value.start.clamp(rentMin.value, rentMax.value);
    final clampedEnd = value.end.clamp(rentMin.value, rentMax.value);
    rentRangeValues.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Commercial buy price range with validation
  void changeTheValueOfCommercial(RangeValues value) {
    final clampedStart = value.start.clamp(commercialMin.value, commercialMax.value);
    final clampedEnd = value.end.clamp(commercialMin.value, commercialMax.value);
    commercialRangeValues.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Commercial rent price range with validation
  void changeCommercialRent(RangeValues value) {
    final clampedStart = value.start.clamp(commercialRentMin.value, commercialRentMax.value);
    final clampedEnd = value.end.clamp(commercialRentMin.value, commercialRentMax.value);
    commercialRentRangeValue.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Commercial area range with validation
  void changeCommercialArea(RangeValues value) {
    final clampedStart = value.start.clamp(areaMin.value, areaMax.value);
    final clampedEnd = value.end.clamp(areaMin.value, areaMax.value);
    areaRangeValues.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Commercial rent area range with validation
  void changeCommercialAreaRent(RangeValues value) {
    final clampedStart = value.start.clamp(commercialRentAreaMin.value, commercialRentAreaMax.value);
    final clampedEnd = value.end.clamp(commercialRentAreaMin.value, commercialRentAreaMax.value);
    commercialRentAreaRangeValue.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Commercial ROI range with validation
  void changeCommercialRoi(RangeValues value) {
    final clampedStart = value.start.clamp(roiMin.value, roiMax.value);
    final clampedEnd = value.end.clamp(roiMin.value, roiMax.value);
    roiRangeValue.value = RangeValues(clampedStart, clampedEnd);
  }

  /// PG rent range with validation
  void changePGRent(RangeValues value) {
    final clampedStart = value.start.clamp(pgMin.value, pgMax.value);
    final clampedEnd = value.end.clamp(pgMin.value, pgMax.value);
    pgRangeValues.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Generic filter update method
  void updateFilter<T>(Rx<T> filterValue, T value) {
    filterValue.value = value;
  }

  /// Reset all filters to default
  // void resetFilters() {
  //   // Reset Buy filters
  //   _rangeValues.value = RangeValues(min.value, max.value);
  //   bhkType.value = '';
  //   subpropertyType.value = '';
  //   constructionStatusInBuy.value = '';
  //
  //   // Reset Rent filters
  //   rentRangeValues.value = RangeValues(rentMin.value, rentMax.value);
  //   rentFurnishing.value = '';
  //
  //   // Reset Commercial filters
  //   commercialRangeValues.value = RangeValues(commercialMin.value, commercialMax.value);
  //   commercialRentRangeValue.value = RangeValues(commercialRentMin.value, commercialRentMax.value);
  //   areaRangeValues.value = RangeValues(areaMin.value, areaMax.value);
  //   commercialRentAreaRangeValue.value = RangeValues(commercialRentAreaMin.value, commercialRentAreaMax.value);
  //   roiRangeValue.value = RangeValues(roiMin.value, roiMax.value);
  //   commercialSelectedSubCategory.value = '';
  //   buySelectedCommercialPropertyTyp.value = '';
  //   selectedSalesType.value = '';
  //   selectedCommercialLeased.value = '';
  //   selectedCommercialPossession.value = '';
  //   availableSelectedList.value = '';
  //
  //   // Reset PG filters
  //   pgRangeValues.value = RangeValues(pgMin.value, pgMax.value);
  //   genderSelected.value = '';
  //   roomSelectedType.value = '';
  //   foodSelected.value = '';
  //
  //   // Reset common filters
  //   selectedMap.value = {};
  // }



  /// Reset all filters to default
  void resetFilters() {
    // Reset property type selection


    // Reset Buy filters
    _rangeValues.value = RangeValues(min.value, max.value);
    bhkType.value = '';
    subpropertyType.value = '';
    constructionStatusInBuy.value = '';

    // Reset Rent filters
    rentRangeValues.value = RangeValues(rentMin.value, rentMax.value);
    rentFurnishing.value = '';

    // Reset Commercial filters
    commercialRangeValues.value = RangeValues(commercialMin.value, commercialMax.value);
    commercialRentRangeValue.value = RangeValues(commercialRentMin.value, commercialRentMax.value);
    areaRangeValues.value = RangeValues(areaMin.value, areaMax.value);
    commercialRentAreaRangeValue.value = RangeValues(commercialRentAreaMin.value, commercialRentAreaMax.value);
    roiRangeValue.value = RangeValues(roiMin.value, roiMax.value);
    commercialSelectedSubCategory.value = '';
    buySelectedCommercialPropertyTyp.value = '';
    selectedSalesType.value = '';
    selectedCommercialLeased.value = '';
    selectedCommercialPossession.value = '';
    availableSelectedList.value = '';

    // Reset PG filters
    pgRangeValues.value = RangeValues(pgMin.value, pgMax.value);
    genderSelected.value = '';
    roomSelectedType.value = '';
    foodSelected.value = '';

    // Reset builder selection
    selectedMap.value = {};

    // Note: searchFilterByID, selectedState, selectedCity, verifiedStatusIndex, and statusApplicateIndex are NOT reset
  }

  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;

  // Sample Indian states
  final List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  // Cities by state
  final Map<String, List<String>> citiesByState = {
    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Bhavnagar',
      'Jamnagar',
      'Junagadh',
      'Gandhinagar',
      'Anand',
      'Nadiad',
      'Morbi',
      'Bharuch',
      'Vapi',
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Thane',
      'Nashik',
      'Aurangabad',
      'Solapur',
      'Kolhapur',
      'Amravati',
      'Navi Mumbai',
    ],
    'Karnataka': [
      'Bangalore',
      'Mysore',
      'Mangalore',
      'Hubli',
      'Belgaum',
      'Dharwad',
      'Gulbarga',
      'Bellary',
    ],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
      'Tirunelveli',
      'Erode',
      'Vellore',
    ],
    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Karimnagar',
      'Khammam',
      'Ramagundam',
    ],
    'Rajasthan': [
      'Jaipur',
      'Jodhpur',
      'Udaipur',
      'Kota',
      'Ajmer',
      'Bikaner',
      'Alwar',
      'Bharatpur',
    ],
    'Uttar Pradesh': [
      'Lucknow',
      'Kanpur',
      'Ghaziabad',
      'Agra',
      'Varanasi',
      'Meerut',
      'Prayagraj',
      'Noida',
      'Greater Noida',
    ],
    'West Bengal': [
      'Kolkata',
      'Howrah',
      'Durgapur',
      'Asansol',
      'Siliguri',
      'Darjeeling',
    ],
    'Delhi': [
      'New Delhi',
      'Central Delhi',
      'North Delhi',
      'South Delhi',
      'East Delhi',
      'West Delhi',
    ],
    'Haryana': [
      'Gurugram',
      'Faridabad',
      'Panipat',
      'Ambala',
      'Yamunanagar',
      'Rohtak',
      'Hisar',
    ],
    'Punjab': [
      'Chandigarh',
      'Ludhiana',
      'Amritsar',
      'Jalandhar',
      'Patiala',
      'Bathinda',
      'Mohali',
    ],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam',
      'Palakkad',
      'Kannur',
    ],
    'Madhya Pradesh': [
      'Bhopal',
      'Indore',
      'Jabalpur',
      'Gwalior',
      'Ujjain',
      'Sagar',
      'Ratlam',
    ],
  };

  // Get cities for selected state
  List<String> get availableCities {
    if (selectedState.value.isEmpty) return [];
    return citiesByState[selectedState.value] ?? [];
  }

  // Update state and reset city
  void updateState(String? state) {
    if (state != null) {
      selectedState.value = state;
      selectedCity.value = ''; // Reset city when state changes
    }
  }

  // Update city
  void updateCity(String? city) {
    if (city != null) {
      selectedCity.value = city;
    }
  }
  Map<String, dynamic> getAllFilters() {
    return {
      // Common
      'selectedPropertyTypeIndex': selectedPropertyTypeIndex.value,
      'propertyType': propertyType[selectedPropertyTypeIndex.value],
      'verifiedStatusIndex': verifiedStatusIndex.value,
      'statusApplicateIndex': statusApplicateIndex.value,
      'statusOfApplicant': statusOfApplicant,
      'searchFilterByID': searchFilterByID.text,

      // Buy
      'buyRangeValues': {
        'min': _rangeValues.value.start,
        'max': _rangeValues.value.end,
      },
      'bhkType': bhkType.value,
      'subpropertyType': subpropertyType.value,
      'constructionStatusInBuy': constructionStatusInBuy.value,

      // Rent
      'rentRangeValues': {
        'min': rentRangeValues.value.start,
        'max': rentRangeValues.value.end,
      },
      'rentFurnishing': rentFurnishing.value,

      // Commercial Buy / Rent
      'commercialRangeValues': {
        'min': commercialRangeValues.value.start,
        'max': commercialRangeValues.value.end,
      },
      'commercialRentRangeValue': {
        'min': commercialRentRangeValue.value.start,
        'max': commercialRentRangeValue.value.end,
      },
      'areaRangeValues': {
        'min': areaRangeValues.value.start,
        'max': areaRangeValues.value.end,
      },
      'commercialRentAreaRangeValue': {
        'min': commercialRentAreaRangeValue.value.start,
        'max': commercialRentAreaRangeValue.value.end,
      },
      'roiRangeValue': {
        'min': roiRangeValue.value.start,
        'max': roiRangeValue.value.end,
      },
      'commercialSelectedSubCategory': commercialSelectedSubCategory.value,
      'buySelectedCommercialPropertyTyp': buySelectedCommercialPropertyTyp.value,
      'selectedSalesType': selectedSalesType.value,
      'selectedCommercialLeased': selectedCommercialLeased.value,
      'selectedCommercialPossession': selectedCommercialPossession.value,
      'availableSelectedList': availableSelectedList.value,

      // PG/Co-living
      'pgRangeValues': {
        'min': pgRangeValues.value.start,
        'max': pgRangeValues.value.end,
      },
      'genderSelected': genderSelected.value,
      'roomSelectedType': roomSelectedType.value,
      'foodSelected': foodSelected.value,

      // Builder
      'selectedMap': selectedMap,

      // Location
      'selectedState': selectedState.value,
      'selectedCity': selectedCity.value,
    };
  }


  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}