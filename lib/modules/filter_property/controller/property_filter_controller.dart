import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'dart:convert';

import 'city_insigths_controller.dart';

class PropertyFilterControllerForFilter extends GetxController {
  ///=====================================Property Type Selection=====================
  RxInt selectedPropertyTypeIndex = 0.obs;
  RxList<String> propertyType =
      ['Sell', 'Rent', 'Commercial', "PG/Co-living"].obs;
  RxList<String> verificationStatus = <String>['Verified', 'Non-verified'].obs;
  RxString verifiedStatusIndex = ''.obs;
  RxString statusApplicateIndex = ''.obs;
  RxList<String> statusOfApplicant =
      <String>['Approved', 'Rejected', 'Pending'].obs;
  var searchFilterByID = TextEditingController();

  ///=====================================BUY PROPERTIES=====================
  RxList<String> constructionStatus =
      <String>['Ready to move', "Under Construction", "New Launch"].obs;

  RxDouble min = 1000000.0.obs;
  RxDouble max = 200000000.0.obs;
  final Rx<RangeValues> _rangeValues =
      const RangeValues(1000000, 200000000).obs;

  RxString bhkType = ''.obs;
  RxString subpropertyType = ''.obs;
  RxString constructionStatusInBuy = ''.obs;

  RxList<String> bHkType =
      <String>["1 BHK", "2 BHK", "3 BHK", "4 BHK", "5 BHK", "5+ BHK"].obs;

  RxList<String> propertyTypesList =
      <String>[
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

  RxList<String> furnishingType =
      <String>["Unfurnished", "Semi Furnished", "Fully Furnished"].obs;
  RxString rentFurnishing = ''.obs;

  ///=====================================COMMERCIAL PROPERTIES=====================
  // Commercial Buy
  RxDouble commercialMin = 2000000.0.obs;
  RxDouble commercialMax = 300000000.0.obs;
  Rx<RangeValues> commercialRangeValues =
      const RangeValues(2000000, 300000000).obs;

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
  Rx<RangeValues> commercialRentRangeValue =
      const RangeValues(100000.0, 600000.0).obs;

  // Commercial Rent Area
  RxDouble commercialRentAreaMin = 200.0.obs;
  RxDouble commercialRentAreaMax = 5000.0.obs;
  Rx<RangeValues> commercialRentAreaRangeValue =
      const RangeValues(200.0, 5000.0).obs;

  // Commercial Categories
  RxList<String> commercialSubCategory = <String>['Buy', 'Rent'].obs;
  RxString commercialSelectedSubCategory = ''.obs;

  RxList<String> buyCommercialPropertyType =
      <String>[
        "Ready to use Office Space",
        "Bare Shell Office Space",
        "Shop",
        "Showroom",
        "Commercial Plot",
        "WareHouse",
        "Others",
      ].obs;
  RxString buySelectedCommercialPropertyTyp = ''.obs;

  RxList<String> saleTypeCommercialProperty =
      <String>["New Properties", "Resale Properties"].obs;
  RxString selectedSalesType = ''.obs;

  RxList<String> leaseTypeCommercialProperty =
      <String>['Pre-Leased', 'Non-Leased'].obs;
  RxString selectedCommercialLeased = ''.obs;

  List<String> possessionCommercialList =
      <String>["Ready to move", "Under Construction"].obs;
  RxString selectedCommercialPossession = ''.obs;

  RxList<String> availableList =
      <String>[
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

  RxList<String> roomTypeList =
      <String>[
        "Private Room",
        "Double Sharing",
        "Triple Sharing",
        "3+ Sharing",
      ].obs;
  RxString roomSelectedType = ''.obs;

  RxList<String> foodAvailable = <String>['Yes', 'No'].obs;
  RxString foodSelected = ''.obs;

  ///=====================================BUILDER DATA=====================
  RxList<Map<String, dynamic>> builderList =
      <Map<String, dynamic>>[
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

  ///=====================================STATE & CITY=====================
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;

  // CityController to fetch states and cities dynamically
  final CityController cityController = Get.put(CityController());

  // Available states (unique)
  RxList<String> availableStates = <String>[].obs;
  RxList<String> availableCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch city data
    fetchCities();
  }

  void fetchCities() async {
    await cityController.fetchCities();

    // Set unique states
    availableStates.value = cityController.uniqueStates;

    // If a state is selected, update cities
    selectedState.listen((state) {
      availableCities.value =
          cityController.stateCityMap[state]
              ?.map((city) => city.city)
              .toList() ??
          [];
      selectedCity.value = ''; // reset city when state changes
    });
  }

  void updateState(String? state) {
    if (state != null) {
      selectedState.value = state;
    }
  }

  void updateCity(String? city) {
    if (city != null) {
      selectedCity.value = city;
    }
  }

  ///=====================================GETTERS=====================
  RangeValues get rangeValues => _rangeValues.value;

  ///=====================================METHODS=====================

  /// Change property type and reset values to avoid out-of-bounds errors
  void changePropertyType(int index) {
    selectedPropertyTypeIndex.value = index;

    // Reset range values based on selected property type to prevent out-of-bounds errors
    switch (propertyType[index]) {
      case 'Sell':
        // Ensure Buy range values are within bounds
        if (_rangeValues.value.start < min.value ||
            _rangeValues.value.end > max.value) {
          _rangeValues.value = RangeValues(min.value, max.value);
        }
        break;
      case 'Rent':
        // Ensure Rent range values are within bounds
        if (rentRangeValues.value.start < rentMin.value ||
            rentRangeValues.value.end > rentMax.value) {
          rentRangeValues.value = RangeValues(rentMin.value, rentMax.value);
        }
        break;
      case 'Commercial':
        // Reset commercial values based on sub-category
        if (commercialSelectedSubCategory.value == 'Buy' ||
            commercialSelectedSubCategory.value.isEmpty) {
          if (commercialRangeValues.value.start < commercialMin.value ||
              commercialRangeValues.value.end > commercialMax.value) {
            commercialRangeValues.value = RangeValues(
              commercialMin.value,
              commercialMax.value,
            );
          }
        } else {
          if (commercialRentRangeValue.value.start < commercialRentMin.value ||
              commercialRentRangeValue.value.end > commercialRentMax.value) {
            commercialRentRangeValue.value = RangeValues(
              commercialRentMin.value,
              commercialRentMax.value,
            );
          }
        }
        // Reset area values
        if (areaRangeValues.value.start < areaMin.value ||
            areaRangeValues.value.end > areaMax.value) {
          areaRangeValues.value = RangeValues(areaMin.value, areaMax.value);
        }
        // Reset ROI values
        if (roiRangeValue.value.start < roiMin.value ||
            roiRangeValue.value.end > roiMax.value) {
          roiRangeValue.value = RangeValues(roiMin.value, roiMax.value);
        }
        // Reset commercial rent area values
        if (commercialRentAreaRangeValue.value.start <
                commercialRentAreaMin.value ||
            commercialRentAreaRangeValue.value.end >
                commercialRentAreaMax.value) {
          commercialRentAreaRangeValue.value = RangeValues(
            commercialRentAreaMin.value,
            commercialRentAreaMax.value,
          );
        }
        break;
      case 'PG/Co-living':
        // Ensure PG range values are within bounds
        if (pgRangeValues.value.start < pgMin.value ||
            pgRangeValues.value.end > pgMax.value) {
          pgRangeValues.value = RangeValues(pgMin.value, pgMax.value);
        }
        break;
    }

    print(
      'Property type changed to: ${propertyType[selectedPropertyTypeIndex.value]}',
    );
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
    final clampedStart = value.start.clamp(
      commercialMin.value,
      commercialMax.value,
    );
    final clampedEnd = value.end.clamp(
      commercialMin.value,
      commercialMax.value,
    );
    commercialRangeValues.value = RangeValues(clampedStart, clampedEnd);
  }

  /// Commercial rent price range with validation
  void changeCommercialRent(RangeValues value) {
    final clampedStart = value.start.clamp(
      commercialRentMin.value,
      commercialRentMax.value,
    );
    final clampedEnd = value.end.clamp(
      commercialRentMin.value,
      commercialRentMax.value,
    );
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
    final clampedStart = value.start.clamp(
      commercialRentAreaMin.value,
      commercialRentAreaMax.value,
    );
    final clampedEnd = value.end.clamp(
      commercialRentAreaMin.value,
      commercialRentAreaMax.value,
    );
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

  /// Reset most filters to defaults (used when switching property type)
  void resetFilters() {
    // Reset Buy filters
    _rangeValues.value = RangeValues(min.value, max.value);
    bhkType.value = '';
    subpropertyType.value = '';
    constructionStatusInBuy.value = '';

    // Reset Rent filters
    rentRangeValues.value = RangeValues(rentMin.value, rentMax.value);
    rentFurnishing.value = '';

    // Reset Commercial filters
    commercialRangeValues.value = RangeValues(
      commercialMin.value,
      commercialMax.value,
    );
    commercialRentRangeValue.value = RangeValues(
      commercialRentMin.value,
      commercialRentMax.value,
    );
    areaRangeValues.value = RangeValues(areaMin.value, areaMax.value);
    commercialRentAreaRangeValue.value = RangeValues(
      commercialRentAreaMin.value,
      commercialRentAreaMax.value,
    );
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
  }

  /// Reset ALL filters including search, verification and location (used by Reset button)
  void resetAllFilters() {
    resetFilters();
    // Common
    verifiedStatusIndex.value = '';
    statusApplicateIndex.value = '';
    searchFilterByID.clear();

    // Location
    selectedState.value = '';
    selectedCity.value = '';
  }

  /// Clear a specific filter by key used in getAllFilters()
  void clearFilterByKey(String key) {
    switch (key) {
      case 'listingType':
        // Keep property type selection as-is to avoid confusing tab jump.
        break;
      case 'isVerified':
        verifiedStatusIndex.value = '';
        break;
      case 'approval_status':
        statusApplicateIndex.value = '';
        break;
      case 'propertyId':
        searchFilterByID.clear();
        break;
      case 'priceRange':
        _rangeValues.value = RangeValues(min.value, max.value);
        break;
      case 'bhk':
        bhkType.value = '';
        break;
      case 'propertyType':
        subpropertyType.value = '';
        buySelectedCommercialPropertyTyp.value = '';
        break;
      case 'possession_status':
        constructionStatusInBuy.value = '';
        break;
      case 'rentRangeValues':
        rentRangeValues.value = RangeValues(rentMin.value, rentMax.value);
        break;
      case 'furnish_type':
        rentFurnishing.value = '';
        break;
      case 'commercialRangeValues':
        commercialRangeValues.value = RangeValues(
          commercialMin.value,
          commercialMax.value,
        );
        break;
      case 'commercialRentRangeValue':
        commercialRentRangeValue.value = RangeValues(
          commercialRentMin.value,
          commercialRentMax.value,
        );
        break;
      case 'areaRangeValues':
        areaRangeValues.value = RangeValues(areaMin.value, areaMax.value);
        break;
      case 'commercialRentAreaRangeValue':
        commercialRentAreaRangeValue.value = RangeValues(
          commercialRentAreaMin.value,
          commercialRentAreaMax.value,
        );
        break;
      case 'roiRangeValue':
        roiRangeValue.value = RangeValues(roiMin.value, roiMax.value);
        break;
      case 'commercialSelectedSubCategory':
        commercialSelectedSubCategory.value = '';
        break;
      case 'buySelectedCommercialPropertyTyp':
        buySelectedCommercialPropertyTyp.value = '';
        break;
      case 'property_condition':
        buySelectedCommercialPropertyTyp.value = '';
        break;
      case 'selectedSalesType':
        selectedSalesType.value = '';
        break;
      case 'selectedCommercialLeased':
        selectedCommercialLeased.value = '';
        break;
      case 'selectedCommercialPossession':
        selectedCommercialPossession.value = '';
        break;
      case 'availableSelectedList':
        availableSelectedList.value = '';
        break;
      case 'pgRangeValues':
        pgRangeValues.value = RangeValues(pgMin.value, pgMax.value);
        break;
      case 'genderSelected':
        genderSelected.value = '';
        break;
      case 'roomSelectedType':
        roomSelectedType.value = '';
        break;
      case 'foodSelected':
        foodSelected.value = '';
        break;
      case 'selectedMap':
        selectedMap.value = {};
        break;
      case 'state':
        selectedState.value = '';
        break;
      case 'city':
        selectedCity.value = '';
        break;
      default:
        break;
    }
  }

  /// Get selected filters as readable chip labels with keys for clearing
  List<Map<String, String>> getSelectedFilterChips() {
    final filters = getAllFilters();
    final List<Map<String, String>> chips = [];

    String priceLabel(double a, double b) =>
        '${Formatter.formatPrice(a)} - ${Formatter.formatPrice(b)}';

    filters.forEach((key, value) {
      if (value == null) return;
      switch (key) {
        case 'isVerified':
          chips.add({
            'key': key,
            'label': 'Verified: ${value == true ? 'Yes' : 'No'}',
          });
          break;
        case 'approval_status':
          chips.add({'key': key, 'label': 'Status: $value'});
          break;
        case 'propertyId':
          chips.add({'key': key, 'label': 'ID: $value'});
          break;
        case 'priceRange':
          final minV = (value['min'] as num).toDouble();
          final maxV = (value['max'] as num).toDouble();
          chips.add({'key': key, 'label': 'Price: ${priceLabel(minV, maxV)}'});
          break;
        case 'bhk':
          chips.add({'key': key, 'label': 'BHK: $value'});
          break;
        case 'propertyType':
          chips.add({'key': key, 'label': 'Type: $value'});
          break;
        case 'possession_status':
          chips.add({'key': key, 'label': 'Possession: $value'});
          break;
        case 'furnish_type':
          chips.add({'key': key, 'label': 'Furnish: $value'});
          break;
        case 'property_condition':
          chips.add({'key': key, 'label': 'Condition: $value'});
          break;
        case 'state':
          chips.add({'key': key, 'label': 'State: $value'});
          break;
        case 'city':
          chips.add({'key': key, 'label': 'City: $value'});
          break;
        default:
          // Skip other internal keys not displayed as chips
          break;
      }
    });

    return chips;
  }

  // RxString selectedState = ''.obs;
  // RxString selectedCity = ''.obs;
  //
  // // Sample Indian states
  // final List<String> states = [
  //   'Andhra Pradesh',
  //   'Arunachal Pradesh',
  //   'Assam',
  //   'Bihar',
  //   'Chhattisgarh',
  //   'Goa',
  //   'Gujarat',
  //   'Haryana',
  //   'Himachal Pradesh',
  //   'Jharkhand',
  //   'Karnataka',
  //   'Kerala',
  //   'Madhya Pradesh',
  //   'Maharashtra',
  //   'Manipur',
  //   'Meghalaya',
  //   'Mizoram',
  //   'Nagaland',
  //   'Odisha',
  //   'Punjab',
  //   'Rajasthan',
  //   'Sikkim',
  //   'Tamil Nadu',
  //   'Telangana',
  //   'Tripura',
  //   'Uttar Pradesh',
  //   'Uttarakhand',
  //   'West Bengal',
  // ];
  //
  // // Cities by state
  // final Map<String, List<String>> citiesByState = {
  //   'Gujarat': [
  //     'Ahmedabad',
  //     'Surat',
  //     'Vadodara',
  //     'Rajkot',
  //     'Bhavnagar',
  //     'Jamnagar',
  //     'Junagadh',
  //     'Gandhinagar',
  //     'Anand',
  //     'Nadiad',
  //     'Morbi',
  //     'Bharuch',
  //     'Vapi',
  //   ],
  //   'Maharashtra': [
  //     'Mumbai',
  //     'Pune',
  //     'Nagpur',
  //     'Thane',
  //     'Nashik',
  //     'Aurangabad',
  //     'Solapur',
  //     'Kolhapur',
  //     'Amravati',
  //     'Navi Mumbai',
  //   ],
  //   'Karnataka': [
  //     'Bangalore',
  //     'Mysore',
  //     'Mangalore',
  //     'Hubli',
  //     'Belgaum',
  //     'Dharwad',
  //     'Gulbarga',
  //     'Bellary',
  //   ],
  //   'Tamil Nadu': [
  //     'Chennai',
  //     'Coimbatore',
  //     'Madurai',
  //     'Tiruchirappalli',
  //     'Salem',
  //     'Tirunelveli',
  //     'Erode',
  //     'Vellore',
  //   ],
  //   'Telangana': [
  //     'Hyderabad',
  //     'Warangal',
  //     'Nizamabad',
  //     'Karimnagar',
  //     'Khammam',
  //     'Ramagundam',
  //   ],
  //   'Rajasthan': [
  //     'Jaipur',
  //     'Jodhpur',
  //     'Udaipur',
  //     'Kota',
  //     'Ajmer',
  //     'Bikaner',
  //     'Alwar',
  //     'Bharatpur',
  //   ],
  //   'Uttar Pradesh': [
  //     'Lucknow',
  //     'Kanpur',
  //     'Ghaziabad',
  //     'Agra',
  //     'Varanasi',
  //     'Meerut',
  //     'Prayagraj',
  //     'Noida',
  //     'Greater Noida',
  //   ],
  //   'West Bengal': [
  //     'Kolkata',
  //     'Howrah',
  //     'Durgapur',
  //     'Asansol',
  //     'Siliguri',
  //     'Darjeeling',
  //   ],
  //   'Delhi': [
  //     'New Delhi',
  //     'Central Delhi',
  //     'North Delhi',
  //     'South Delhi',
  //     'East Delhi',
  //     'West Delhi',
  //   ],
  //   'Haryana': [
  //     'Gurugram',
  //     'Faridabad',
  //     'Panipat',
  //     'Ambala',
  //     'Yamunanagar',
  //     'Rohtak',
  //     'Hisar',
  //   ],
  //   'Punjab': [
  //     'Chandigarh',
  //     'Ludhiana',
  //     'Amritsar',
  //     'Jalandhar',
  //     'Patiala',
  //     'Bathinda',
  //     'Mohali',
  //   ],
  //   'Kerala': [
  //     'Thiruvananthapuram',
  //     'Kochi',
  //     'Kozhikode',
  //     'Thrissur',
  //     'Kollam',
  //     'Palakkad',
  //     'Kannur',
  //   ],
  //   'Madhya Pradesh': [
  //     'Bhopal',
  //     'Indore',
  //     'Jabalpur',
  //     'Gwalior',
  //     'Ujjain',
  //     'Sagar',
  //     'Ratlam',
  //   ],
  // };
  //
  // // Get cities for selected state
  // List<String> get availableCities {
  //   if (selectedState.value.isEmpty) return [];
  //   return citiesByState[selectedState.value] ?? [];
  // }
  //
  // // Update state and reset city
  // void updateState(String? state) {
  //   if (state != null) {
  //     selectedState.value = state;
  //     selectedCity.value = ''; // Reset city when state changes
  //   }
  // }
  //
  // // Update city
  // void updateCity(String? city) {
  //   if (city != null) {
  //     selectedCity.value = city;
  //   }
  // }

  // Map<String, dynamic> getAllFilters() {
  //   return {
  //     // Common
  //     'selectedPropertyTypeIndex': selectedPropertyTypeIndex.value,
  //     'propertyType': propertyType[selectedPropertyTypeIndex.value],
  //     'verifiedStatusIndex': verifiedStatusIndex.value,
  //     'statusApplicateIndex': statusApplicateIndex.value,
  //     'searchFilterByID': searchFilterByID.text,
  //
  //     // Buy
  //     'buyRangeValues': {
  //       'min': _rangeValues.value.start,
  //       'max': _rangeValues.value.end,
  //     },
  //     'bhkType': bhkType.value,
  //     'subpropertyType': subpropertyType.value,
  //     'constructionStatusInBuy': constructionStatusInBuy.value,
  //
  //     // Rent
  //     'rentRangeValues': {
  //       'min': rentRangeValues.value.start,
  //       'max': rentRangeValues.value.end,
  //     },
  //     'rentFurnishing': rentFurnishing.value,
  //
  //     // Commercial Buy / Rent
  //     'commercialRangeValues': {
  //       'min': commercialRangeValues.value.start,
  //       'max': commercialRangeValues.value.end,
  //     },
  //     'commercialRentRangeValue': {
  //       'min': commercialRentRangeValue.value.start,
  //       'max': commercialRentRangeValue.value.end,
  //     },
  //     'areaRangeValues': {
  //       'min': areaRangeValues.value.start,
  //       'max': areaRangeValues.value.end,
  //     },
  //     'commercialRentAreaRangeValue': {
  //       'min': commercialRentAreaRangeValue.value.start,
  //       'max': commercialRentAreaRangeValue.value.end,
  //     },
  //     'roiRangeValue': {
  //       'min': roiRangeValue.value.start,
  //       'max': roiRangeValue.value.end,
  //     },
  //     'commercialSelectedSubCategory': commercialSelectedSubCategory.value,
  //     'buySelectedCommercialPropertyTyp':
  //         buySelectedCommercialPropertyTyp.value,
  //     'selectedSalesType': selectedSalesType.value,
  //     'selectedCommercialLeased': selectedCommercialLeased.value,
  //     'selectedCommercialPossession': selectedCommercialPossession.value,
  //     'availableSelectedList': availableSelectedList.value,
  //
  //     // PG/Co-living
  //     'pgRangeValues': {
  //       'min': pgRangeValues.value.start,
  //       'max': pgRangeValues.value.end,
  //     },
  //     'genderSelected': genderSelected.value,
  //     'roomSelectedType': roomSelectedType.value,
  //     'foodSelected': foodSelected.value,
  //
  //     // Builder
  //     'selectedMap': selectedMap,
  //
  //     // Location
  //     'selectedState': selectedState.value,
  //     'selectedCity': selectedCity.value,
  //   };
  // }

  Map<String, dynamic> getAllFilters() {
    // Helpers
    String slug(String? s) =>
        (s ?? '').trim().toLowerCase().replaceAll(' ', '_');
    String hyphenSlug(String? s) => (s ?? '')
        .trim()
        .toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('_', '-');

    String? mapListingType() {
      final tab = propertyType[selectedPropertyTypeIndex.value];
      if (tab == 'Sell') return 'Sell';
      if (tab == 'Rent') return 'Rent';
      if (tab == 'Commercial') {
        if (commercialSelectedSubCategory.value.toLowerCase() == 'rent') {
          return 'Rent';
        }
        return 'Sell';
      }
      if (tab == 'PG/Co-living')
        return 'PG'; // Changed from 'Rent' to 'PG' for proper API mapping
      return null;
    }

    // Map UI property type labels to backend slugs
    String? mapPropertyType() {
      final tab = propertyType[selectedPropertyTypeIndex.value];
      if (tab == 'Commercial') {
        final t = buySelectedCommercialPropertyTyp.value;
        switch (t) {
          case 'Ready to use Office Space':
          case 'Bare Shell Office Space':
            return 'office';
          case 'Shop':
            return 'retail_shop';
          case 'Showroom':
            return 'showroom';
          case 'Commercial Plot':
            return 'plot';
          case 'WareHouse':
            return 'warehouse';
          case 'Others':
            return 'others';
          default:
            return null;
        }
      } else {
        final t = subpropertyType.value;
        switch (t) {
          case 'Apartments':
            return 'apartment';
          case 'Independent House':
            return 'independent_house';
          case 'Plot':
            return 'plot';
          case 'Studio':
            return 'studio';
          case 'Duplex':
            return 'duplex';
          case 'PentHouse':
            return 'penthouse';
          case 'Builder Floor':
            return 'builder_floor';
          case 'Villa':
            return 'villa';
          default:
            return null;
        }
      }
    }

    // Extract BHK number (e.g., "2 BHK" -> 2)
    String? mapBhk() {
      if (bhkType.value.isEmpty) return null;
      final digits = RegExp(r'\d+').firstMatch(bhkType.value)?.group(0);
      return digits;
    }

    // Map furnishing
    String? mapFurnishType() {
      if (rentFurnishing.value.isEmpty) return null;
      final v = hyphenSlug(rentFurnishing.value);
      // normalize common variants
      if (v.contains('semi')) return 'semi-furnished';
      if (v.contains('fully')) return 'fully-furnished';
      if (v.contains('un')) return 'unfurnished';
      return v;
    }

    // Compute priceRange based on context
    Map<String, dynamic>? mapPriceRange() {
      final tab = propertyType[selectedPropertyTypeIndex.value];
      if (tab == 'Sell') {
        return {'min': _rangeValues.value.start, 'max': _rangeValues.value.end};
      } else if (tab == 'Rent') {
        return {
          'min': rentRangeValues.value.start,
          'max': rentRangeValues.value.end,
        };
      } else if (tab == 'Commercial') {
        if (commercialSelectedSubCategory.value.toLowerCase() == 'rent') {
          return {
            'min': commercialRentRangeValue.value.start,
            'max': commercialRentRangeValue.value.end,
          };
        } else {
          return {
            'min': commercialRangeValues.value.start,
            'max': commercialRangeValues.value.end,
          };
        }
      } else if (tab == 'PG/Co-living') {
        return {
          'min': pgRangeValues.value.start,
          'max': pgRangeValues.value.end,
        };
      }
      return null;
    }

    // Optionally set property_condition for commercial office
    String? mapPropertyCondition() {
      if (propertyType[selectedPropertyTypeIndex.value] != 'Commercial') {
        return null;
      }
      final t = buySelectedCommercialPropertyTyp.value;
      if (t == 'Ready to use Office Space') return 'ready_to_use';
      if (t == 'Bare Shell Office Space') return 'bare_shell';
      return null;
    }

    final mappedListingType = mapListingType();
    final mappedPropertyType = mapPropertyType();
    final priceRange = mapPriceRange();
    final propertyCondition = mapPropertyCondition();

    Map<String, dynamic> filters = {
      // Core filters
      if (propertyType[selectedPropertyTypeIndex.value].isNotEmpty)
        'type':
            propertyType[selectedPropertyTypeIndex.value] == "Commercial"
                ? 'commercial'
                : 'residential',
      if (mappedListingType != null) 'listingType': mappedListingType,
      if (mappedPropertyType != null) 'propertyType': mappedPropertyType,
      if (priceRange != null) 'priceRange': priceRange,

      // Flags
      if (verifiedStatusIndex.value.isNotEmpty)
        'isVerified': verifiedStatusIndex.value == 'Verified',
      if (statusApplicateIndex.value.isNotEmpty)
        'approval_status': slug(statusApplicateIndex.value),

      // Search by property id
      if (searchFilterByID.text.trim().isNotEmpty)
        'propertyId': searchFilterByID.text.trim(),

      // BHK for residential
      if (mapBhk() != null) 'bhk': mapBhk(),

      // Possession status (buy)
      if (constructionStatusInBuy.value.isNotEmpty)
        'possession_status': slug(constructionStatusInBuy.value),

      // Furnishing (rent)
      if (mapFurnishType() != null) 'furnish_type': mapFurnishType(),

      // Location
      if (selectedState.value.isNotEmpty) 'state': selectedState.value,
      if (selectedCity.value.isNotEmpty) 'city': selectedCity.value,

      // Commercial-specific extras (optional, only when known)
      if (propertyCondition != null) 'property_condition': propertyCondition,

      // Type (only when Commercial tab)
      if (propertyType[selectedPropertyTypeIndex.value] == 'Commercial')
        'type': 'commercial',

      // PG-specific filters
      if (propertyType[selectedPropertyTypeIndex.value] == 'PG/Co-living')
        if (mapPgFor() != null) 'pg_for': mapPgFor(),
      if (mapPgRoomType() != null) 'room_type': mapPgRoomType(),
      if (foodSelected.value.isNotEmpty)
        'pg_meal_offered': foodSelected.value.toLowerCase(),
    };

    // Clean up null and empty values
    dynamic clean(dynamic value) {
      if (value == null) return null;
      if (value is String && value.isEmpty) return null;
      if (value is Iterable && value.isEmpty) return null;
      if (value is Map) {
        value = Map.from(value)..removeWhere((k, v) => clean(v) == null);
        return value.isEmpty ? null : value;
      }
      return value;
    }

    // Clean top-level map
    filters = filters.map((k, v) => MapEntry(k, clean(v)))
      ..removeWhere((k, v) => v == null);

    return filters;
  }

  // Map PG room type
  String? mapPgRoomType() {
    switch (roomSelectedType.value.toLowerCase()) {
      case 'private room':
        return 'single';
      case 'double sharing':
        return 'double';
      case 'triple sharing':
        return 'triple';
      case '3+ sharing':
        return 'multiple';
      default:
        return null;
    }
  }

  // Map PG gender
  String? mapPgFor() {
    switch (genderSelected.value.toLowerCase()) {
      case 'male':
        return 'Boys';
      case 'female':
        return 'Girls';
      case 'both':
        return 'Co-ed';
      default:
        return null;
    }
  }

  void initializeWithFilters(Map<String, String> initialFilters) {
    try {
      // Handle listing type first to set correct tab
      if (initialFilters['listingType'] != null) {
        String listingType = initialFilters['listingType']!;
        int index;
        switch (listingType) {
          case 'Sell':
            index = propertyType.indexOf('Sell');
            break;
          case 'Rent':
            index = propertyType.indexOf('Rent');
            break;
          case 'PG':
            index = propertyType.indexOf('PG/Co-living');
            break;
          default:
            index = 0;
        }
        selectedPropertyTypeIndex.value = index;
      }

      // Handle verification status
      if (initialFilters['isVerified'] != null) {
        verifiedStatusIndex.value =
            initialFilters['isVerified'] == 'true'
                ? 'Verified'
                : 'Non-verified';
      }

      // Handle approval status
      if (initialFilters['approval_status'] != null) {
        String status = initialFilters['approval_status']!;
        status = status.substring(0, 1).toUpperCase() + status.substring(1);
        statusApplicateIndex.value = status;
      }

      // Handle property type
      if (initialFilters['propertyType'] != null) {
        String pType = initialFilters['propertyType']!;
        // Map API property types to UI property types
        String uiType = '';
        switch (pType) {
          case 'apartment':
            uiType = 'Apartments';
            break;
          case 'independent_house':
            uiType = 'Independent House';
            break;
          case 'plot':
            uiType = 'Plot';
            break;
          case 'studio':
            uiType = 'Studio';
            break;
          case 'duplex':
            uiType = 'Duplex';
            break;
          case 'penthouse':
            uiType = 'PentHouse';
            break;
          case 'builder_floor':
            uiType = 'Builder Floor';
            break;
          case 'villa':
            uiType = 'Villa';
            break;
          // Commercial types
          case 'office':
            uiType = 'Ready to use Office Space';
            break;
          case 'retail_shop':
            uiType = 'Shop';
            break;
          case 'showroom':
            uiType = 'Showroom';
            break;
          case 'warehouse':
            uiType = 'WareHouse';
            break;
        }

        if (propertyType[selectedPropertyTypeIndex.value] == 'Commercial') {
          buySelectedCommercialPropertyTyp.value = uiType;
        } else {
          subpropertyType.value = uiType;
        }
      }

      // Handle price ranges
      if (initialFilters['priceRange'] != null) {
        try {
          final Map<String, dynamic> range = json.decode(
            initialFilters['priceRange']!,
          );
          double minValue = (range['min'] as num).toDouble();
          double maxValue = (range['max'] as num).toDouble();

          switch (propertyType[selectedPropertyTypeIndex.value]) {
            case 'Sell':
              _rangeValues.value = RangeValues(minValue, maxValue);
              break;
            case 'Rent':
              rentRangeValues.value = RangeValues(minValue, maxValue);
              break;
            case 'Commercial':
              if (commercialSelectedSubCategory.value.toLowerCase() == 'rent') {
                commercialRentRangeValue.value = RangeValues(
                  minValue,
                  maxValue,
                );
              } else {
                commercialRangeValues.value = RangeValues(minValue, maxValue);
              }
              break;
            case 'PG/Co-living':
              pgRangeValues.value = RangeValues(minValue, maxValue);
              break;
          }
        } catch (e) {
          debugPrint('Error parsing price range: $e');
        }
      }

      // Handle PG specific filters
      if (initialFilters['pg_info'] != null) {
        try {
          final Map<String, dynamic> pgInfo = json.decode(
            initialFilters['pg_info']!,
          );

          // Handle pg_for (gender)
          if (pgInfo['pg_for'] != null) {
            String pgFor = pgInfo['pg_for'];
            switch (pgFor) {
              case 'Boys':
                genderSelected.value = 'Male';
                break;
              case 'Girls':
                genderSelected.value = 'Female';
                break;
              case 'Co-ed':
                genderSelected.value = 'Both';
                break;
            }
          }

          // Handle room type
          if (pgInfo['pg_room_info'] != null &&
              (pgInfo['pg_room_info'] as List).isNotEmpty) {
            String roomType = pgInfo['pg_room_info'][0]['room_type'];
            switch (roomType) {
              case 'single':
                roomSelectedType.value = 'Private Room';
                break;
              case 'double':
                roomSelectedType.value = 'Double Sharing';
                break;
              case 'triple':
                roomSelectedType.value = 'Triple Sharing';
                break;
              case 'multiple':
                roomSelectedType.value = '3+ Sharing';
                break;
            }
          }

          // Handle meal preference
          if (pgInfo['pg_meal_offered'] != null) {
            foodSelected.value =
                pgInfo['pg_meal_offered'].toString().toLowerCase() == 'yes'
                    ? 'Yes'
                    : 'No';
          }
        } catch (e) {
          debugPrint('Error parsing PG info: $e');
        }
      }

      // Handle location
      if (initialFilters['state'] != null) {
        selectedState.value = initialFilters['state']!;
      }
      if (initialFilters['city'] != null) {
        selectedCity.value = initialFilters['city']!;
      }

      // Handle furnishing type
      if (initialFilters['furnish_type'] != null) {
        String furnishType = initialFilters['furnish_type']!;
        switch (furnishType) {
          case 'semi-furnished':
            rentFurnishing.value = 'Semi Furnished';
            break;
          case 'fully-furnished':
            rentFurnishing.value = 'Fully Furnished';
            break;
          case 'unfurnished':
            rentFurnishing.value = 'Unfurnished';
            break;
        }
      }
    } catch (e) {
      debugPrint('Error initializing filters: $e');
    }
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
