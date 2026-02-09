//
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart';
//
// // import '../../data/models/project_model.dart';
// import '../model/config_model.dart';
//
// class ProjectWizardController extends GetxController {
//   // step index: 0..4
//   final currentStep = 0.obs;
//   ImagePicker picker = ImagePicker();
//   RxList<String> selectedListOfAmenities = <String>[].obs;
//   final showAllAmenities = false.obs;
//   RxString builderPropertyType = ''.obs;
//   RxList<String> propertyStatusList =
//       <String>['Ongoing', 'Launch', 'Completed'].obs;
//   RxString selectedPropertyStatus = ''.obs;
//
//   RxString uploadBrocherName = ''.obs;
//   RxString uploadBrocherPath = ''.obs;
//
//   // form data
//   final project = AddProjectModel(
//     projectName: '',
//     projectArea: 0,
//     projectSize: ProjectSize(totalBuildings: 1, totalUnits: 1),
//     launchDate: DateTime.now(),
//     possessionDate: DateTime.now(),
//     configurations: [ProjectConfiguration(bhk: 1, variants: [
//       ProjectVariant(
//         name: '',
//         builtUpArea: 0,
//         carpetArea: 0,
//         price: 0,
//         pricePerSqFt: 0,
//         totalUnits: 1,
//         availableUnits: 1,
//         specifications: [],
//       )
//     ])],
//     reraId: '',
//     propertyTypes: 'apartment',
//     status: 'upcoming',
//     address: '',
//     city: '',
//     state: '',
//     zipCode: '',
//     location: '',
//     nearbyLocations: [],
//     amenities: [],
//     imageList: [],
//     videoList: [],
//     brochure: null,
//     projectHighlights: [],
//     projectContactInfo: ProjectContactInfo(
//       name: '',
//       phone: '',
//       email: '',
//     ),
//   ).obs;
//
//
//   // 🔹 Text controllers
//   late TextEditingController projectNameController;
//   late TextEditingController projectAreaController;
//   late TextEditingController totalBuildingsController;
//   late TextEditingController totalUnitsController;
//   late TextEditingController reraIdController;
//   late TextEditingController addressController;
//   late TextEditingController cityController;
//   late TextEditingController stateController;
//   late TextEditingController zipCodeController;
//   late TextEditingController locationController;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//
//     projectNameController =
//         TextEditingController(text: project.value.projectName);
//     projectAreaController =
//         TextEditingController(text: project.value.projectArea.toString());
//     totalBuildingsController =
//         TextEditingController(text: project.value.projectSize.totalBuildings.toString());
//     totalUnitsController =
//         TextEditingController(text: project.value.projectSize.totalUnits.toString());
//     reraIdController = TextEditingController(text: project.value.reraId);
//     addressController = TextEditingController(text: project.value.address);
//     cityController = TextEditingController(text: project.value.city);
//     stateController = TextEditingController(text: project.value.state);
//     zipCodeController = TextEditingController(text: project.value.zipCode);
//     locationController = TextEditingController(text: project.value.location);
//   }
//
//
//
//
//   void removeBuilderImage(int index) {
//     project.update((p) {
//       if (p == null) return;
//       if (index >= 0 && index < p.imageList.length) {
//         p.imageList.removeAt(index);
//       }
//     });
//   }
//
//   void removeBuilderVideo(int index) {
//     project.update((p) {
//       if (p == null) return;
//       if (index >= 0 && index < p.videoList.length) {
//         p.videoList.removeAt(index);
//       }
//     });
//   }
//
//
//
//   void setCommonMethodValue<T>(Rx<T> target, T value) {
//     target.value = value;
//     print('selected Property ${target.value}');
//   }
//
//   Future<void> builderImagePicker() async {
//     try {
//       List<XFile> files = await picker.pickMultiImage(
//         imageQuality: 80,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         limit: 5,
//       );
//
//       if (files.isNotEmpty) {
//
//         if ( project.value.imageList.length + files.length > 5) {
//           Get.snackbar(
//             'Limit Exceeded',
//             'You can only select up to 5 images in total',
//             snackPosition: SnackPosition.BOTTOM,
//           );
//           return;
//         }
//
//       project.update((p) {
//         if (p == null) return;
//         for (var file in files) {
//           p.imageList.add(file.path);
//           print('image added ${file.path}');
//         }
//       });
//         project.refresh();
//
//         Get.snackbar(
//           'Success',
//           '${files.length} image(s) added',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick images: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   Future<void> builderVideoPicker() async {
//     try {
//
//       List<XFile> videos = await picker.pickMultiVideo(
//         limit: 5,
//         maxDuration: Duration(seconds: 60),
//       );
//
//       if (videos.isNotEmpty) {
//
//         if ( project.value.videoList.length + videos.length > 5) {
//           Get.snackbar(
//             'Limit Exceeded',
//             'You can only select up to 5 videos in total',
//             snackPosition: SnackPosition.BOTTOM,
//           );
//           return;
//         }
//
//
//       project.update((p) {
//         if (p == null) return;
//         for (var video in videos) {
//           p.videoList.add(video.path);
//           print('Video added: ${video.path}');
//         }
//       });
//         project.refresh(
//
//         );
//
//         Get.snackbar(
//           'Success',
//           '${videos.length} video(s) added',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick videos: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   Future<void> pickFileInBuilder() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       // Or specify types like FileType.image, FileType.custom
//       allowMultiple: false,
//       // Set to true for multiple file selection
//       allowedExtensions: ['pdf', 'doc', 'txt'], // For FileType.custom
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//
//       print('Selected file: ${file.name}');
//       uploadBrocherPath.value = file.path ?? 'No Data Found';
//       uploadBrocherName.value = file.name;
//       print(
//         'Path: ${file.path}  ${uploadBrocherName.value} ${uploadBrocherPath.value}',
//       );
//       uploadBrocherPath.refresh();
//       // sync brochure path into AddProjectModel so print/export shows it
//       if (file.path != null && file.path!.isNotEmpty) {
//         project.update((p) {
//           p!.brochure = file.path;
//         });
//       }
//     } else {
//       print('File selection canceled.');
//     }
//   }
//
//   Future<void> pdfPreviewByDefaultApp(String path) async {
//     final result = await OpenFilex.open(path);
//     print('Open result: ${result.message}');
//   }
//
//   void removeBuilderBrocher() {
//     uploadBrocherPath.value = '';
//     uploadBrocherName.value = '';
//     uploadBrocherPath.refresh();
//     // also clear from AddProjectModel
//     project.update((p) {
//       p!.brochure = null;
//     });
//   }
//
//   // UI helpers
//   final formKeys = List.generate(6, (_) => GlobalKey<FormState>());
//
//   void next() {
//     if (_validateCurrentStep()) {
//       print('lenght of formkeey ${formKeys.length}');
//       if (currentStep.value < 5) currentStep.value++;
//
//     }
//   }
//
//   void selectedBuilderPropertyType(String index) {
//     builderPropertyType.value = index;
//     print('Selected Property Types ${builderPropertyType.value}');
//   }
//
//   void toggleAmenitiesView() {
//     showAllAmenities.value = !showAllAmenities.value;
//   }
//
//   void back() {
//     if (currentStep.value > 0) currentStep.value--;
//   }
//
//   void addBuilderAmenities(String items) {
//     if (selectedListOfAmenities.contains(items)) {
//       selectedListOfAmenities.remove(items);
//     } else {
//       selectedListOfAmenities.add(items);
//     }
//     selectedListOfAmenities.refresh();
//   }
//
//   bool _validateCurrentStep() {
//     final key = formKeys[currentStep.value];
//     final form = key.currentState;
//     if (form == null) return true;
//     if (form.validate()) {
//       form.save();
//       // cross-step custom validations
//       if (currentStep.value == 0) {
//         final err = _validateDates();
//         if (err != null) {
//           Get.snackbar('Validation Error', err);
//           return false;
//         }
//       }
//       return true;
//     }
//     return false;
//   }
//
//   String? _validateDates() {
//     final p = project.value;
//     if (p.possessionDate.isBefore(p.launchDate)) {
//       return 'Possession must be after Launch';
//     }
//     return null;
//   }
//
//   // Configurations dynamic controls
//   void addConfiguration() {
//     project.update((p) {
//       p!.configurations.add(ProjectConfiguration(bhk: 1, variants: []));
//     });
//   }
//
//   void removeConfiguration(int index) {
//     project.update((p) {
//       if (p!.configurations.length > 1) {
//         p.configurations.removeAt(index);
//       }
//     });
//   }
//
//   void addVariant(int configIndex) {
//     project.update((p) {
//       p!.configurations[configIndex].variants.add(
//         ProjectVariant(
//           name: '',
//           builtUpArea: 0,
//           carpetArea: 0,
//           price: 0,
//           totalUnits: 0,
//           availableUnits: 0,
//         ),
//       );
//     });
//   }
//
//   void removeVariant(int configIndex, int variantIndex) {
//     project.update((p) {
//       p!.configurations[configIndex].variants.removeAt(variantIndex);
//     });
//   }
//
//   void submit() {
//     // UI only; you can hook API here later.
//     print('jhdyuf');
//     Get.snackbar('Success', 'Project data is ready (UI-only)');
//     printProjectDetails();
//   }
//   void printProjectDetails() {
//     final p = project.value;
//
//     print('===== Project Details =====');
//     print('Name: ${p.projectName}');
//     print('Area: ${p.projectArea} sq.ft');
//     print('Total Buildings: ${p.projectSize.totalBuildings}');
//     print('Total Units: ${p.projectSize.totalUnits}');
//     print('Launch Date: ${p.launchDate}');
//     print('Possession Date: ${p.possessionDate}');
//     print('RERA ID: ${p.reraId}');
//     print('Property Type: ${p.propertyTypes}');
//     print('Status: ${p.status}');
//     print('Address: ${p.address}');
//     print('City: ${p.city}');
//     print('State: ${p.state}');
//     print('Zip Code: ${p.zipCode}');
//     print('Location: ${p.location}');
//
//     // Nearby locations
//     if (p.nearbyLocations.isNotEmpty) {
//       print('Nearby Locations:');
//       for (var i = 0; i < p.nearbyLocations.length; i++) {
//         print('  ${i + 1}: ${p.nearbyLocations[i]}');
//       }
//     }
//
//     // Amenities
//     if (p.amenities.isNotEmpty) {
//       print('Amenities: ${p.amenities.join(', ')}');
//     }
//
//     // Media
//     if (p.imageList.isNotEmpty) {
//       print('Images:');
//       for (var img in p.imageList) {
//         print('  $img');
//       }
//     }
//     if (p.videoList.isNotEmpty) {
//       print('Videos:');
//       for (var vid in p.videoList) {
//         print('  $vid');
//       }
//     }
//
//     // Brochure
//     if (p.brochure?.isNotEmpty??false) {
//       print('Brochure: ${p.brochure}');
//     }
//
//     // Highlights
//     if (p.projectHighlights.isNotEmpty) {
//       print('Project Highlights:');
//       for (var highlight in p.projectHighlights) {
//         print('  - $highlight');
//       }
//     }
//
//     // Contact Info
//     if (p.projectContactInfo != null) {
//       print('Contact Info:');
//       print('  Name: ${p.projectContactInfo!.name}');
//       print('  Phone: ${p.projectContactInfo!.phone}');
//       print('  Email: ${p.projectContactInfo!.email}');
//     }
//
//     // Configurations
//     if (p.configurations.isNotEmpty) {
//       print('Configurations:');
//       for (var i = 0; i < p.configurations.length; i++) {
//         final config = p.configurations[i];
//         print('  Configuration ${i + 1}: BHK ${config.bhk}');
//         if (config.variants.isNotEmpty) {
//           for (var j = 0; j < config.variants.length; j++) {
//             final variant = config.variants[j];
//             print(
//                 '    Variant ${j + 1}: ${variant.name}, BuiltUp: ${variant.builtUpArea}, Carpet: ${variant.carpetArea}, Price: ${variant.price}, Price/SqFt: ${variant.pricePerSqFt}, Total Units: ${variant.totalUnits}, Available Units: ${variant.availableUnits}');
//             if (variant.specifications.isNotEmpty) {
//               print('      Specifications: ${variant.specifications.join(', ')}');
//             }
//           }
//         }
//       }
//     }
//     print('============================');
//   }
//
//
//
//   Map<String, dynamic> getAllBuilderValues() {
//     return project.value.getAllBuilderValues();
//   }
//
//
//   void updateBuilderValues(Map<String, dynamic> values) {
//     project.update((p) {
//       p!.updateBuilderValues(values);
//     });
//   }
//
//
//   List<String> validateBuilderValues() {
//     return project.value.validateBuilderValues();
//   }
//
//
//   Map<String, dynamic> exportBuilderData() {
//     return project.value.toBuilderJson();
//   }
//
//
//   void importBuilderData(Map<String, dynamic> jsonData) {
//     final newProject = AddProjectModel.fromBuilderJson(jsonData);
//     project.value = newProject;
//
//     // Update text controllers with new values
//     projectNameController.text = newProject.projectName;
//     projectAreaController.text = newProject.projectArea.toString();
//     totalBuildingsController.text = newProject.projectSize.totalBuildings.toString();
//     totalUnitsController.text = newProject.projectSize.totalUnits.toString();
//     reraIdController.text = newProject.reraId;
//     addressController.text = newProject.address;
//     cityController.text = newProject.city;
//     stateController.text = newProject.state;
//     zipCodeController.text = newProject.zipCode;
//     locationController.text = newProject.location;
//
//
//     selectedListOfAmenities.value = List<String>.from(newProject.amenities);
//
//
//     if (newProject.propertyTypes != null) {
//       builderPropertyType.value = newProject.propertyTypes!;
//     }
//     selectedPropertyStatus.value = newProject.status;
//
//
//     project.value.imageList = List<String>.from(newProject.imageList);
//     project.value.videoList = List<String>.from(newProject.videoList);
//
//
//     if (newProject.brochure != null) {
//       uploadBrocherPath.value = newProject.brochure!;
//       uploadBrocherName.value = newProject.brochure!.split('/').last;
//     }
//   }
//
//   /// Builder folder ના values ને save કરવા માટે method (API call કરવા માટે)
//   Future<bool> saveBuilderData() async {
//     try {
//       // Validate data first
//       final errors = validateBuilderValues();
//       if (errors.isNotEmpty) {
//         Get.snackbar(
//           'Validation Error',
//           'Please fix the following errors:\n${errors.join('\n')}',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: Duration(seconds: 5),
//         );
//         return false;
//       }
//
//       // Get all builder values
//       final builderData = getAllBuilderValues();
//
//       // Here you can add API call to save the data
//       // For now, just print the data
//       print('Saving Builder Data: $builderData');
//
//       Get.snackbar(
//         'Success',
//         'Builder data saved successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//
//       return true;
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to save builder data: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return false;
//     }
//   }
//
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/builder/service/builder_service.dart';
import 'package:housing_flutter_app/modules/builder/view/builder_dashboard.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:housing_flutter_app/widgets/location_permission/location_permission_method.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/constants/color_res.dart';
import '../../../data/network/builder/model/builder_model.dart';
import '../../../data/network/property/services/property_service.dart';
import '../view/builder_main_screen.dart';

class ProjectWizardController extends PaginatedController<ProjectItem> {
  final BuilderService _builderService = BuilderService();
  final currentStep = 0.obs;
  final RxString selectedCity = ''.obs;
  ImagePicker picker = ImagePicker();
  RxList<ProjectItem> topProjects = <ProjectItem>[].obs;
  RxList<String> selectedListOfAmenities = <String>[].obs;
  final showAllAmenities = false.obs;
  RxString builderPropertyType = ''.obs;
  RxList<String> propertyStatusList =
      <String>['Ongoing', 'Upcoming', 'Completed'].obs;
  RxString selectedPropertyStatus = ''.obs;

  RxString uploadBrocherName = ''.obs;
  RxString uploadBrocherPath = ''.obs;

  RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  Map<String, String>? filters = {};

  // var favoriteProjectIds = <String>{}.obs;

  final project =
      AddProjectModel(
        projectName: '',
        projectArea: 0,
        buildingNames: {},
        projectSize: ProjectSize(totalBuildings: 0, totalUnits: 0),
        launchDate: DateTime.now(),
        possessionDate: DateTime.now(),
        configurations: [
          ProjectConfiguration(
            bhk: 1,
            variants: [
              ProjectVariant(
                name: '',
                builtUpArea: 0,
                carpetArea: 0,
                buildingName: '',
                price: 0,
                platformFees: 0,
                brokerCommission: 0,
                pricePerSqFt: 0,
                totalUnits: 0,
                availableUnits: 0,
                specifications: [],
              ),
            ],
          ),
        ],
        reraId: '',
        propertyTypes: 'apartment',
        status: '',
        address: '',
        city: '',
        state: '',
        zipCode: '',
        location: '',
        nearbyLocations: [],
        amenities: [],
        imageList: [],
        videoList: [],
        documentList: [],
        brochure: null,
        projectHighlights: [],
        projectContactInfo: ProjectContactInfo(name: "", phone: "", email: ""),
      ).obs;

  late TextEditingController projectNameController;
  late TextEditingController projectAreaController;
  TextEditingController totalBuildingsController = TextEditingController();
  late TextEditingController totalUnitsController;
  late TextEditingController reraIdController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipCodeController;
  late TextEditingController locationController;
  late TextEditingController brokerRageCommission;
  late TextEditingController platformFees;
  final buildingNameControllers = <TextEditingController>[].obs;
  final bool isBuilderView;
  var selectedBuilding = ''.obs;

  ProjectWizardController({required this.isBuilderView});

  @override
  void onInit() {
    super.onInit();
    getCity();

    if (isBuilderView) {
      print('isBuilderView');
      setUserIdFilter().then((_) => loadInitial());
      // loadTopProject();
    } else {
      print('isBuyerView');
      loadInitial();
      // loadTopProject();// buyer view, no filter
    }
    assignData();
  }

  void generateBuildingFields(String passTotalBuilding) {
    final totalBuildings = int.tryParse(passTotalBuilding) ?? 0;

    // Only regenerate if needed
    if (buildingNameControllers.length != totalBuildings) {
      // Dispose old controllers
      for (final c in buildingNameControllers) {
        c.dispose();
      }
      buildingNameControllers.clear();

      // Create new ones
      for (int i = 0; i < totalBuildings; i++) {
        buildingNameControllers.add(TextEditingController());
      }
    }
  }

  /*  void saveBuildingNames() {
    final map = <String, String>{};
    for (int i = 0; i < buildingNameControllers.length; i++) {
      final name = buildingNameControllers[i].text.trim();
      map["buildingName#${i + 1}"] = name.isEmpty ? "Building ${i + 1}" : name;
    }

    project.update((p) {
      p!.buildingNames = map;
    });
  }*/
  void saveBuildingNames() {
    final map = <String, String>{};

    for (int i = 0; i < buildingNameControllers.length; i++) {
      final name = buildingNameControllers[i].text.trim();
      final key = "buildingName#${i + 1}";
      final value = name.isEmpty ? "Building ${i + 1}" : name;

      map[key] = value;

      // 🧾 Log each building name as it’s processed
      log("🏢 Saved: $key = $value");
    }

    project.update((p) {
      p!.buildingNames = map;
    });

    // 🧠 Final summary log
    log("✅ All building names updated: ${map.toString()}");
    log(
      "📦 Project model now has buildingNames: ${project.value.buildingNames}",
    );
  }

  Future<void> assignData() async {
    projectNameController = TextEditingController(
      text: project.value.projectName,
    );
    projectAreaController = TextEditingController(
      text: project.value.projectArea.toStringAsFixed(0),
    );
    totalBuildingsController = TextEditingController(
      text: project.value.projectSize.totalBuildings.toString(),
    );
    totalUnitsController = TextEditingController(
      text: project.value.projectSize.totalUnits.toString(),
    );
    reraIdController = TextEditingController(text: project.value.reraId);
    addressController = TextEditingController(text: project.value.address);
    cityController = TextEditingController(text: project.value.city);
    stateController = TextEditingController(text: project.value.state);
    zipCodeController = TextEditingController(text: project.value.zipCode);
    locationController = TextEditingController(text: project.value.location);
    generateBuildingFields(project.value.projectSize.totalBuildings.toString());
    for (int i = 0; i < project.value.projectSize.totalBuildings; i++) {
      buildingNameControllers[i].text =
          project.value.buildingNames?["buildingName#${i + 1}"] ?? '';
    }
    brokerRageCommission = TextEditingController(
      text:
          project.value.configurations.first.variants.first.brokerCommission
              .toString(),
    );
    selectedListOfAmenities.value = List<String>.from(project.value.amenities);
    builderPropertyType.value = project.value.propertyTypes ?? '';
    selectedBuilding.value =
        project.value.configurations.first.variants.first.buildingName ?? '';
    selectedBuilding.refresh();
    selectedPropertyStatus.value = project.value.status;
    platformFees = TextEditingController(
      text:
          project.value.configurations.first.variants.first.platformFees
              .toString(),
    );
    await fetchUserData();
  }

  @override
  Future<void> getCity() async {
    try {
      final city = await SecureStorage.getSelectedCity();
      if (city != null && city.isNotEmpty) {
        print("🏙️ City retrieved: $city");
        selectedCity.value = city;

        // Fetch
      } else {
        print("⚠️ No city selected");
      }

      // Apply city filter and load properties
      final filter = {'city': selectedCity.value};
      await applyFilters(filter);
      await loadInitial();
      await loadTopProject();
    } catch (e) {
      print("❌ Error getting city: $e");
    }
  }

  Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
    try {
      log("dkvjcvifj $filters");
      final response = await _builderService.fetchProjects(
        page: page,
        filters: filters,
      );

      print("Fetched items: ${response.items.length}");
      return response; // ✅ full response with items + meta
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  void cityAssign(String city) {
    selectedCity.value = city;
    log("dhgfyfg ${selectedCity.value}");
    //refresh();
  }

  void applyFilter(String key, String val) {
    filters ??= {};
    print('jfgig $key');
    if (key == 'propertyTypes') {
      // Add/replace property type while keeping city
      final cityValue = filters!['city'];
      filters = {
        if (cityValue != null) 'city': cityValue,
        'propertyTypes': val,
      };
      print("🔍 Top Applied: propertyTypes=$val, city=${cityValue ?? '-'}");
    } else if (key == 'city') {
      // When changing city, REMOVE propertyType & listingType
      filters = {'city': val};

      selectedCity.value = val;
      print("🏙️ City changed → Reset filters. city=$val");
      // Reload top properties when city changes
      loadTopProject();
    } else if (key == 'listingType') {
      // Add/replace listingType while keeping city
      final cityValue = filters!['city'];
      filters = {
        if (cityValue != null) 'city': cityValue,
        'listingType': val.toUpperCase(),
      };
      print("🔍Top Applied: listingType=$val, city=${cityValue ?? '-'}");
    } else {
      // Generic filter
      filters![key] = val;
      print("🔧 Top Applied filter: $key=$val");
    }

    print("📊 Current filters: $filters");

    // Reset pagination
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  Future<void> loadTopProject({int page = 1}) async {
    try {
      print("🏗️ Loading top properties, page $page...");
      final response = await fetchTopItems(page);
      if (page == 1) {
        topProjects.assignAll(response.items);
      } else {
        topProjects.addAll(response.items);
      }
      print(
        "✅ Loaded ${response.items.length} top properties ${topProjects.value.map((e) => e.toJson())}",
      );
    } catch (e) {
      print("❌ Error loading top properties: $e");
    }
  }

  /// Apply filters and refresh (expects a plain Map)
  Future<void> applyFilters(Map<String, String> newFilters) async {
    try {
      isLoading.value = true;
      filters = Map<String, String>.from(newFilters);
      currentPage.value = 1;
      items.clear();
      await refreshList();
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear a specific filter while maintaining other filters
  void clearFilter(String key) {
    filters ??= {};
    filters!.remove(key);

    print("🗑️ Cleared filter - $key");
    print("📊 Current filters: $filters");

    // reset pagination state
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  /// Clear all filters except city (to show all property types for selected city)
  void clearPropertyTypeFilter() {
    clearFilter('propertyType');
  }

  Future<void> refreshLead() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<PaginationResponse<ProjectItem>> fetchTopItems(int page) async {
    try {
      final response = await _builderService.fetchProjects(
        page: page,
        filters: filters,
      );

      print("Fetched ydyfgyfdgyfd items: ${response.items.length}  ${filters}");
      return response; // ✅ full response with items + meta
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  Future<void> setUserIdFilter() async {
    final userData = await SecureStorage.getUserData();
    final userId = userData?.user?.id ?? '';

    filters = {'created_by': userId};
    applyFilters(filters!);
    // await loadTopProject();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final userData = await SecureStorage.getUserData();
      if (userData != null) {
        user.value = userData;
        // Update contact info with fetched user data
        project.update((p) {
          p?.projectContactInfo?.name = userData.user?.username ?? '';
          p?.projectContactInfo?.phone = userData.user?.phone ?? '';
          p?.projectContactInfo?.email = userData.user?.email ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void removeBuilderImage(int index) {
    project.update((p) {
      if (p == null) return;
      if (index >= 0 && index < p.imageList.length) {
        p.imageList.removeAt(index);
      }
    });
  }

  void removeBuilderVideo(int index) {
    project.update((p) {
      if (p == null) return;
      if (index >= 0 && index < p.videoList.length) {
        p.videoList.removeAt(index);
      }
    });
  }

  void setCommonMethodValue<T>(Rx<T> target, T value) {
    target.value = value;
    print('selected Property ${target.value}');
  }

  Future<void> builderImagePicker() async {
    final isGranted = await requestGalleryPermission();
    if (isGranted) {
      try {
        List<XFile> files = await picker.pickMultiImage(
          imageQuality: 80,
          maxWidth: 1024,
          maxHeight: 1024,
          limit: 5,
        );

        if (files.isNotEmpty) {
          if (project.value.imageList.length + files.length > 5) {
            NesticoPeSnackBar.showAwesomeSnackbar(
              title: 'Limit Exceeded',
              message: 'You can only select up to 5 images in total',
              contentType: ContentType.failure,
            );
            return;
          }

          project.update((p) {
            if (p == null) return;
            for (var file in files) {
              p.imageList.add(file.path);
              print('image added ${file.path}');
            }
          });
          project.refresh();

          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: '${files.length} image(s) added',
            contentType: ContentType.success,
          );
        }
      } catch (e) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to pick images: $e',
          contentType: ContentType.failure,
        );
      }
    }
  }

  Future<void> builderVideoPicker() async {
    final isGranted = await requestGalleryPermission();
    if (isGranted) {
      try {
        List<XFile> videos = await picker.pickMultiVideo(
          limit: 5,
          maxDuration: Duration(seconds: 60),
        );

        if (videos.isNotEmpty) {
          if (project.value.videoList.length + videos.length > 5) {
            NesticoPeSnackBar.showAwesomeSnackbar(
              title: "Limit Exceeded",
              message: 'You can only select up to 5 videos in total',
              contentType: ContentType.failure,
            );
            return;
          }

          project.update((p) {
            if (p == null) return;
            for (var video in videos) {
              p.videoList.add(video.path);
              print('Video added: ${video.path}');
            }
          });
          project.refresh();

          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Success",
            message: '${videos.length} video(s) added',
            contentType: ContentType.success,
          );
        }
      } catch (e) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to pick videos: $e',
          contentType: ContentType.failure,
        );
      }
    }
  }

  Future<void> pickFileInBuilder() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf', 'doc', 'txt'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print('Selected file: ${file.name}');
      uploadBrocherPath.value = file.path ?? 'No Data Found';
      uploadBrocherName.value = file.name;
      print(
        'Path: ${file.path}  ${uploadBrocherName.value} ${uploadBrocherPath.value}',
      );
      uploadBrocherPath.refresh();

      if (file.path != null && file.path!.isNotEmpty) {
        project.update((p) {
          p!.brochure = file.name;
          p!.pdfPath = file.path;
        });
      }
    } else {
      print('File selection canceled.');
    }
  }

  // Future<void> pdfPreviewByDefaultApp(String path) async {
  //   final result = await OpenFilex.open(path);
  //   print('Open result: ${result.message}');
  // }
  // Future<void> pdfPreviewByDefaultApp(String pathOrUrl) async {
  //   try {
  //     String localPath = pathOrUrl;
  //
  //     // Check if it's a network URL
  //     final isNetwork = Uri.tryParse(pathOrUrl)?.isAbsolute ?? false;
  //
  //     if (isNetwork) {
  //       // Download the PDF to temporary directory
  //       final response = await http.get(Uri.parse(pathOrUrl));
  //       if (response.statusCode != 200) {
  //         print('Failed to download PDF');
  //         return;
  //       }
  //
  //       final tempDir = await getTemporaryDirectory();
  //       final fileName = pathOrUrl.split('/').last;
  //       final file = File('${tempDir.path}/$fileName');
  //       await file.writeAsBytes(response.bodyBytes);
  //       localPath = file.path;
  //     }
  //
  //     // Open the PDF using the default app
  //     final result = await OpenFilex.open(localPath);
  //     print('Open result: ${result.message}');
  //   } catch (e) {
  //     print('PDF open error: $e');
  //   }
  // }

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

  void removeBuilderBrocher() {
    uploadBrocherPath.value = '';
    uploadBrocherName.value = '';
    uploadBrocherPath.refresh();
    project.update((p) {
      p!.brochure = null;
    });
  }

  // Document picker - Allow up to 2 documents
  Future<void> builderDocumentPicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        // Check total limit
        if (project.value.documentList.length + result.files.length > 2) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Limit Exceeded",
            message: 'You can only select up to 2 documents in total',
            contentType: ContentType.failure,
          );
          return;
        }

        project.update((p) {
          if (p == null) return;

          // Make sure documentList is modifiable
          p.documentList = List<String>.from(p.documentList);

          for (var file in result.files) {
            if (file.path != null) {
              p.documentList.add(file.path!);
              print('Document added: ${file.path}');
            }
          }
        });

        project.refresh();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: '${result.files.length} document(s) added',
          contentType: ContentType.success,
        );
      }
    } catch (e) {
      print('Failed to pick documents: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to pick documents: $e',
        contentType: ContentType.failure,
      );
    }
  }

  void removeBuilderDocument(int index) {
    project.update((p) {
      if (p == null) return;
      if (index >= 0 && index < p.documentList.length) {
        p.documentList.removeAt(index);
      }
    });
  }

  // Get single project by ID (returns cached one if found)
  Future<ProjectItem?> getProjectById(String id) async {
    try {
      // Check cache first
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) {
        return existing;
      } else {
        final data = await _builderService.getProjectById(id);
        print('Fetched item: ${data}');
        items.add(data);
        return data;
      }

      // If not in cache, fetch from API
      // Note: You may need to add this method to BuilderService
      // For now, return null if not in cach
    } catch (e) {
      print('Get project error: $e');
    }
    return null;
  }

  final formKeys = List.generate(6, (_) => GlobalKey<FormState>());

  void next() {
    if (_validateCurrentStep()) {
      print('length of formkey ${formKeys.length}');
      if (currentStep.value < 5) currentStep.value++;
    }
  }

  void selectedBuilderPropertyType(String index) {
    builderPropertyType.value = index;
    print('Selected Property Types ${builderPropertyType.value}');
  }

  void toggleAmenitiesView() {
    showAllAmenities.value = !showAllAmenities.value;
  }

  void back() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void addBuilderAmenities(String items) {
    if (project.value.amenities.contains(items)) {
      project.value.amenities.remove(items);
    } else {
      project.value.amenities.add(items);
    }
    project.refresh();
  }

  bool _validateCurrentStep() {
    final key = formKeys[currentStep.value];
    final form = key.currentState;
    if (form == null) return true;
    if (form.validate()) {
      form.save();
      if (currentStep.value == 0) {
        final err = _validateDates();
        if (err != null) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Error",
            message: 'Validation Error: $err',
            contentType: ContentType.failure,
          );
          return false;
        }
      }
      return true;
    }
    return false;
  }

  String? _validateDates() {
    final p = project.value;
    if (p.possessionDate.isBefore(p.launchDate)) {
      return 'Possession must be after Launch';
    }
    return null;
  }

  void addConfiguration() {
    project.update((p) {
      p!.configurations.add(ProjectConfiguration(bhk: 1, variants: []));
    });
  }

  void removeConfiguration(int index) {
    project.update((p) {
      if (p!.configurations.length > 1) {
        p.configurations.removeAt(index);
      }
    });
  }

  void addVariant(int configIndex) {
    project.update((p) {
      p!.configurations[configIndex].variants.add(
        ProjectVariant(
          name: '',
          builtUpArea: 0,
          carpetArea: 0,
          pricePerSqFt: 0.0,
          price: 0,
          totalUnits: 0,
          buildingName: '',
          availableUnits: 0,
          brokerCommission: 0,
          platformFees: 0,
        ),
      );
    });
  }

  void removeVariant(int configIndex, int variantIndex) {
    project.update((p) {
      p!.configurations[configIndex].variants.removeAt(variantIndex);
    });
  }

  Future<void> submit() async {
    try {
      isLoading.value = true;
      printProjectDetails();
      await createBuilderProject();
    } catch (e) {
      print('Create builder project error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProject(String projectId) async {
    try {
      isLoading.value = true;
      printProjectDetails();
      await updateBuilderProject(projectId);
    } catch (e) {
      print('Create builder project error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createBuilderProject() async {
    try {
      final jsonBody = jsonEncode(project.value.toJson());
      log(
        "📦 Final Payload:\n${const JsonEncoder.withIndent('  ').convert(project.value.toJson())}",
      );
      var data=await _buildProjectPayload();
         AppLogger.structured(
        "📦 Final dsjcdjhdjhdsd :\n",data.toJson(),
      );

      final success = await _builderService.createProject(
        projectData: await _buildProjectPayload(),
        images: project.value.imageList.map((path) => File(path)).toList(),
        videos: project.value.videoList.map((path) => File(path)).toList(),
        brochures:
            project.value.brochure != null
                ? File(project.value.pdfPath ?? '')
                : null,
        documents:
            project.value.documentList.map((path) => File(path)).toList(),
      );
      if (success) {
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: "Project Created Successfully",
        //   message: "",
        //   contentType: ContentType.success,
        // );
        refreshList();
        resetForm();
        Get.offUntil(
          MaterialPageRoute(builder: (_) => BuilderMainScreen()),
          (route) => route.isFirst,
        );
      } else {
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: "Failed to Create Project",
        //   message: "",
        //   contentType: ContentType.failure,
        // );
      }
    } catch (e) {
      print('Create builder project error: $e');
      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: "Failed to Create Project",
      //   message: "",
      //   contentType: ContentType.failure,
      // );
    }
  }

  Future<void> updateBuilderProject(String projectId) async {
    try {
      final success = await _builderService.updateProject(
        projectId: projectId,
        projectData: await _buildProjectPayload(),
        images: project.value.imageList.map((path) => File(path)).toList(),
        videos: project.value.videoList.map((path) => File(path)).toList(),
        documents:
            project.value.brochure != null
                ? File(project.value.brochure ?? '')
                : null,
      );

      if (success) {
        refreshList();
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: "Success",
        //   message: "Project Updated Successfully",
        //   contentType: ContentType.success,
        // );
        Get.offUntil(
          MaterialPageRoute(builder: (_) => BuilderMainScreen()),
          (route) => route.isFirst,
        );
      } else {
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: "Error",
        //   message: "Failed to Update Project",
        //   contentType: ContentType.failure,
        // );
      }
    } catch (e) {
      print('Update builder project error: $e');
      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: "Failed to Update Project",
      //   message: "",
      //   contentType: ContentType.failure,
      // );
    }
  }

  Future<AddProjectModel> _buildProjectPayload() async {
    final AddProjectModel p = project.value;
    print('Building payload ---- > ${p.projectContactInfo?.toJson()}');
    final user = await SecureStorage.getUserData();
    return AddProjectModel(
      projectName: p.projectName,
      projectArea: p.projectArea,
      buildingNames: p.buildingNames,
      projectSize: ProjectSize(
        totalBuildings: p.projectSize.totalBuildings,
        totalUnits: p.projectSize.totalUnits,
      ),
      launchDate: p.launchDate,
      possessionDate: p.possessionDate,
      configurations: p.configurations,
      reraId: p.reraId,
      address: p.address,
      status: p.status,
      city: p.city,
      state: p.state,
      zipCode: p.zipCode,
      location: p.location,
      amenities: p.amenities,
      brochure: p.brochure,
      nearbyLocations: p.nearbyLocations,
      projectContactInfo: ProjectContactInfo(
        name: user?.user?.username ?? '',
        phone: user?.user?.phone ?? '',
        email: user?.user?.email ?? '',
      ),
      propertyTypes: p.propertyTypes,
      projectHighlights: p.projectHighlights,
    );
  }

  // Future<AddProjectModel> updateProjectData(AddProjectModel updatedData) async {
  //   final AddProjectModel p = project.value;
  //   final user = await SecureStorage.getUserData();
  //
  //   // Reverse assignment: fill existing project `p` with new `updatedData`
  //   p.projectName = updatedData.projectName;
  //   p.projectArea = updatedData.projectArea;
  //   p.projectSize = ProjectSize(
  //     totalBuildings: updatedData.projectSize.totalBuildings,
  //     totalUnits: updatedData.projectSize.totalUnits,
  //   );
  //   p.launchDate = updatedData.launchDate;
  //   p.possessionDate = updatedData.possessionDate;
  //   p.configurations = updatedData.configurations;
  //   p.reraId = updatedData.reraId;
  //   p.address = updatedData.address;
  //   p.status = updatedData.status;
  //   p.city = updatedData.city;
  //   p.state = updatedData.state;
  //   p.zipCode = updatedData.zipCode;
  //   p.location = updatedData.location;
  //   p.amenities = updatedData.amenities;
  //   p.brochure = updatedData.brochure;
  //   p.nearbyLocations = updatedData.nearbyLocations;
  //   p.projectContactInfo = ProjectContactInfo(
  //     name: user?.user?.username ?? updatedData.projectContactInfo?.name ?? '',
  //     phone: user?.user?.phone ?? updatedData.projectContactInfo?.phone ?? '',
  //     email: user?.user?.email ?? updatedData.projectContactInfo?.email ?? '',
  //   );
  //   p.propertyTypes = updatedData.propertyTypes;
  //   p.projectHighlights = updatedData.projectHighlights;
  //   await assignData();
  //   print("Updated Project Data: ${p.toJson()}");
  //   return p;
  // }

  // Future<AddProjectModel> updateProjectData(AddProjectModel updatedData) async {
  //   currentStep.value = 0;
  //   final user = await SecureStorage.getUserData();
  //
  //   AppLogger("Update Project of Builder", updatedData);
  //
  //   project.update((p) {
  //     if (p == null) return;
  //     p.id = updatedData.id;
  //     p.pdfPath = updatedData.brochure;
  //     p.imageList =
  //         updatedData.mediaGallery!.images.isNotEmpty
  //             ? updatedData.mediaGallery!.images
  //             : p.imageList;
  //     p.videoList =
  //         updatedData.mediaGallery!.videos.isNotEmpty
  //             ? updatedData.mediaGallery!.videos
  //             : p.videoList;
  //     p.projectName = updatedData.projectName;
  //     p.projectArea = updatedData.projectArea;
  //     p.projectSize = ProjectSize(
  //       totalBuildings: updatedData.projectSize.totalBuildings,
  //       totalUnits: updatedData.projectSize.totalUnits,
  //     );
  //     p.launchDate = updatedData.launchDate;
  //     p.possessionDate = updatedData.possessionDate;
  //     p.configurations = updatedData.configurations;
  //     p.reraId = updatedData.reraId;
  //     p.address = updatedData.address;
  //     p.status = updatedData.status;
  //     p.city = updatedData.city;
  //     p.state = updatedData.state;
  //     p.zipCode = updatedData.zipCode;
  //     p.location = updatedData.location;
  //     p.amenities = updatedData.amenities;
  //     p.brochure = updatedData.brochure;
  //     p.nearbyLocations = updatedData.nearbyLocations;
  //     p.projectContactInfo = ProjectContactInfo(
  //       name:
  //           user?.user?.username ?? updatedData.projectContactInfo?.name ?? '',
  //       phone: user?.user?.phone ?? updatedData.projectContactInfo?.phone ?? '',
  //       email: user?.user?.email ?? updatedData.projectContactInfo?.email ?? '',
  //     );
  //     p.propertyTypes = updatedData.propertyTypes;
  //     p.projectHighlights = updatedData.projectHighlights;
  //     p.brochure = updatedData.brochure;
  //     print("✅ Updated Project Data: ${p.toJson()}");
  //     // p.imageList = updatedData.mea
  //   });
  //
  //   await assignData();
  //
  //   return project.value;
  // }

  Future<AddProjectModel> updateProjectData(AddProjectModel updatedData) async {
    currentStep.value = 0;
    final user = await SecureStorage.getUserData();

    AppLogger("Update Project of Builder", updatedData);

    project.update((p) {
      if (p == null) return;
      p.id = updatedData.id;
      p.pdfPath = updatedData.brochure;
      p.imageList =
          updatedData.mediaGallery!.images.isNotEmpty
              ? updatedData.mediaGallery!.images
              : p.imageList;
      p.videoList =
          updatedData.mediaGallery!.videos.isNotEmpty
              ? updatedData.mediaGallery!.videos
              : p.videoList;
      p.projectName = updatedData.projectName;
      p.projectArea = updatedData.projectArea;
      p.buildingNames = updatedData.buildingNames;
      p.projectSize = ProjectSize(
        totalBuildings: updatedData.projectSize.totalBuildings,
        totalUnits: updatedData.projectSize.totalUnits,
      );
      p.launchDate = updatedData.launchDate;
      p.possessionDate = updatedData.possessionDate;
      p.configurations = updatedData.configurations;
      p.reraId = updatedData.reraId;
      p.address = updatedData.address;
      p.status = updatedData.status;
      p.city = updatedData.city;
      p.state = updatedData.state;
      p.zipCode = updatedData.zipCode;
      p.location = updatedData.location;
      p.amenities =
          updatedData.amenities
              .map((item) => item.toLowerCase().replaceAll(" ", "_"))
              .toList();
      p.brochure = updatedData.brochure;
      p.nearbyLocations = updatedData.nearbyLocations;
      p.projectContactInfo = ProjectContactInfo(
        name:
            user?.user?.username ?? updatedData.projectContactInfo?.name ?? '',
        phone: user?.user?.phone ?? updatedData.projectContactInfo?.phone ?? '',
        email: user?.user?.email ?? updatedData.projectContactInfo?.email ?? '',
      );
      p.propertyTypes = updatedData.propertyTypes;
      p.projectHighlights = updatedData.projectHighlights;
      p.brochure = updatedData.brochure;
      print("✅ Updated Project Data: ${p.toJson()}");
    });

    // ✅ Populate the controllers with existing variant data
    if (project.value.configurations.isNotEmpty) {
      for (var config in project.value.configurations) {
        for (var variant in config.variants) {
          if (variant.platformFees != null && variant.platformFees! > 0) {
            platformFees.text = variant.platformFees!.toStringAsFixed(2);
          }
          if (variant.brokerCommission != null &&
              variant.brokerCommission! > 0) {
            brokerRageCommission.text = variant.brokerCommission!
                .toStringAsFixed(2);
          }
          // Only update first variant's values to controllers (or loop for all if needed)
          break;
        }
        break;
      }
    }

    await assignData();

    return project.value;
  }

  void printProjectDetails() {
    final AddProjectModel p = project.value;

    print('===== Project Details =====');
    print('Name: ${p.projectName}');
    print('Area: ${p.projectArea} sq.ft');
    print('Total Buildings: ${p.projectSize.totalBuildings}');
    print('Total Units: ${p.projectSize.totalUnits}');
    print('Launch Date: ${p.launchDate}');
    print('Possession Date: ${p.possessionDate}');
    print('RERA ID: ${p.reraId}');
    print('Property Type: ${p.propertyTypes}');
    print('Status: ${p.status}');
    print('Address: ${p.address}');
    print('City: ${p.city}');
    print('State: ${p.state}');
    print('Zip Code: ${p.zipCode}');
    print('Location: ${p.location}');

    if (p.nearbyLocations.isNotEmpty) {
      print('Nearby Locations:');
      for (var i = 0; i < p.nearbyLocations.length; i++) {
        print('  ${i + 1}: ${p.nearbyLocations[i]}');
      }
    }

    if (p.amenities.isNotEmpty) {
      print('Amenities: ${p.amenities.join(', ')}');
    }

    if (p.imageList.isNotEmpty) {
      print('Images:');
      for (var img in p.imageList) {
        print('  $img');
      }
    }
    if (p.videoList.isNotEmpty) {
      print('Videos:');
      for (var vid in p.videoList) {
        print('  $vid');
      }
    }

    if (p.brochure?.isNotEmpty ?? false) {
      print('Brochure: ${p.brochure}');
    }

    if (p.projectHighlights.isNotEmpty) {
      print('Project Highlights:');
      for (var highlight in p.projectHighlights) {
        print('  - $highlight');
      }
    }

    if (p.projectContactInfo != null) {
      print('Contact Info:');
      print('  Name: ${p.projectContactInfo!.name}');
      print('  Phone: ${p.projectContactInfo!.phone}');
      print('  Email: ${p.projectContactInfo!.email}');
    }

    if (p.configurations.isNotEmpty) {
      print('Configurations:');
      for (var i = 0; i < p.configurations.length; i++) {
        final config = p.configurations[i];
        print('  Configuration ${i + 1}: BHK ${config.bhk}');
        if (config.variants.isNotEmpty) {
          for (var j = 0; j < config.variants.length; j++) {
            final variant = config.variants[j];
            print(
              '    Variant ${j + 1}: ${variant.name}, BuiltUp: ${variant.builtUpArea}, BuiltUp: ${variant.pricePerSqFt}, Carpet: ${variant.carpetArea}, Price: ${variant.price}, Total Units: ${variant.totalUnits}, Available Units: ${variant.availableUnits}',
            );
            if (variant.specifications.isNotEmpty) {
              print(
                '      Specifications: ${variant.specifications.join(', ')}',
              );
            }
          }
        }
      }
    }
    print('============================');
  }

  Map<String, dynamic> exportData() {
    return project.value.toJson();
  }

  Future<bool> saveData() async {
    try {
      final projectData = project.value.toJson();

      final jsonBody = jsonEncode(project.value.toJson());
      log(
        "📦 Final Payload:\n${const JsonEncoder.withIndent('  ').convert(project.value.toJson())}",
      );

      // TODO: Add API call here
      print('Saving Project Data: $projectData');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Success",
        message: 'Project data saved successfully!',
        contentType: ContentType.success,
      );

      return true;
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to save project data: $e',
        contentType: ContentType.failure,
      );
      return false;
    }
  }

  void resetForm() {
    // Reset current step
    currentStep.value = 0;

    // Reset reactive fields
    selectedListOfAmenities.clear();
    showAllAmenities.value = false;
    builderPropertyType.value = '';
    selectedPropertyStatus.value = '';
    uploadBrocherName.value = '';
    uploadBrocherPath.value = '';
    isLoading.value = false;

    // Reset Project model
    project.value = AddProjectModel(
      projectName: '',
      projectArea: 0,
      buildingNames: {},
      projectSize: ProjectSize(totalBuildings: 1, totalUnits: 1),
      launchDate: DateTime.now(),
      possessionDate: DateTime.now(),
      configurations: [
        ProjectConfiguration(
          bhk: 1,
          variants: [
            ProjectVariant(
              name: '',
              builtUpArea: 0,
              buildingName: '',
              carpetArea: 0,
              price: 0,
              pricePerSqFt: 0,
              totalUnits: 1,
              availableUnits: 1,
              specifications: [],
            ),
          ],
        ),
      ],
      reraId: '',
      propertyTypes: 'apartment',
      status: 'upcoming',
      address: '',
      city: '',
      state: '',
      zipCode: '',
      location: '',
      nearbyLocations: [],
      amenities: [],
      imageList: [],
      videoList: [],
      brochure: null,
      projectHighlights: [],
      projectContactInfo: ProjectContactInfo(name: "", phone: "", email: ""),
    );

    // Reset text controllers
    projectNameController.clear();
    projectAreaController.clear();
    totalBuildingsController.clear();
    totalUnitsController.clear();
    reraIdController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
    locationController.clear();

    // Reassign default contact info from stored user data
    fetchUserData();

    // Refresh observables
    project.refresh();
    uploadBrocherPath.refresh();
    for (final c in buildingNameControllers) {
      c.clear();
    }
    print('✅ Form has been reset successfully');
  }
}
