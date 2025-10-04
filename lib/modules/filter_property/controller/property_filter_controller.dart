import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyFilterControllerForFilter extends GetxController{

  ///=====================================Buyer variable=====================
  RxInt selectedPropertyTypeIndex = 0.obs;
  RxList<String> propertyType = ['Buy', 'Rent', 'Commercial', 'PG/Co-living'].obs;
  RxList<String> constructionStatus = <String>[
    'Ready to move',
    "Under Construction",
    "New Launch",
  ].obs;
  RxDouble min = 1000000.0.obs;
  RxString bhkType=''.obs;
  RxString subpropertyType=''.obs;
  RxString constructionStatusInBuy=''.obs;
  RxDouble max = 200000000.0.obs;
  // 🏠 Buy Budget
  RxDouble buyMin = 1000000.0.obs; // 1 million
  RxDouble buyMax = 200000000.0.obs; // 200 million
  Rx<RangeValues> buyRangeValues =
      const RangeValues(1000000, 200000000).obs;

// 🏡 Rent Budget
  RxDouble rentMin = 5000.0.obs; // example values
  RxDouble rentMax = 500000.0.obs;
  Rx<RangeValues> rentRangeValues =
      const RangeValues(5000, 500000).obs;

// 🏢 Commercial Budget
  RxDouble commercialMin = 2000000.0.obs;
  RxDouble commercialMax = 300000000.0.obs;
  Rx<RangeValues> commercialRangeValues =
      const RangeValues(2000000, 300000000).obs;

// 🛏 PG Budget
  RxDouble pgMin = 2000.0.obs;
  RxDouble pgMax = 50000.0.obs;
  Rx<RangeValues> pgRangeValues =
      const RangeValues(2000, 50000).obs;
  RxDouble areaMin = 200.0.obs;       // minimum area in sqft
  RxDouble areaMax = 5000.0.obs;      // maximum area in sqft
  Rx<RangeValues> areaRangeValues =
      const RangeValues(200, 5000).obs; // initial range

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

  final Rx<RangeValues> _rangeValues = const  RangeValues(1000000, 200000000).obs;
  ///=================================Rent============================================
  RxList<String> furnishingType = <String>[
    "Unfurnished",
    "Semi Furnished",
    "Fully Furnished",
  ].obs;
  RxString rentFurnishing=''.obs;


  ///================================Commercial=========================================
  RxList<String> commercialSubCategory=<String>[
    'Buy',
    'Rent'
  ].obs;
  RxString commercialSelectedSubCategory=''.obs;
  RxList<String> buyCommercialPropertyType = <String>[
    "Ready to use Office Space",
    "Bare Shell Office Space",
    "Shop",
    "Showroom",
    "Commercial Plot",
    "WareHouse",
    "Others",
  ].obs;
  RxString buySelectedCommercialPropertyTyp=''.obs;

  RxList<String> saleTypeCommercialProperty = <String>[
    "New Properties",
    "Resale Properties",
  ].obs;
  RxString selectedSalesType=''.obs;
  RxList<String> leaseTypeCommercialProperty = <String>['Pre-Leased', 'Non-Leased'].obs;
  List<String> possessionCommercialList = <String>["Ready to move", "Under Construction"].obs;
  RxString selectedCommercialPossession=''.obs;
  RxString selectedCommercialLeased=''.obs;
  RxList<String> availableList = <String>[
    'Within a week',
    'Within 15 days',
    'Within a month',
    'After a month',
  ].obs;
  RxString availableSelectedList=''.obs;


  ///===========================PG Living=======================================

  RxList<String> genderList = <String>['Male', 'Female', 'Both'].obs;
  RxString genderSelected=''.obs;
  RxList<String> roomTypeList = <String>[
    "Private Room",
    "Double Sharing",
    "Triple Sharing",
    "3+ Sharing",
  ].obs;
  RxString roomSelectedType=''.obs;
  RxList<String> foodAvailable = <String>['Yes', 'No'].obs;
  RxString foodSelected=''.obs;

  RxList<Map<String,dynamic>> builderList = <Map<String,dynamic>>[
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














  //============================================== Buyer Method
  RangeValues get rangeValues => _rangeValues.value;

  void changePropertyType(int index)
  {
    selectedPropertyTypeIndex.value = index;
    print(
      'print property type  ${propertyType[selectedPropertyTypeIndex.value]}',
    );
  }

  void buyerPriceRange(RangeValues value)
  {
    _rangeValues.value = value; // Update the private reactive variable
  }
  void updateFilter<T>(Rx<T>filterValue,T value)
  {
    filterValue.value=value;

  }



  ///======================================================
}