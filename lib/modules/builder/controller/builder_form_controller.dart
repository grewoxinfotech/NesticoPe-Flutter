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
//   final project = ProjectModel(
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
//       // sync brochure path into ProjectModel so print/export shows it
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
//     // also clear from ProjectModel
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
//     final newProject = ProjectModel.fromBuilderJson(jsonData);
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

import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/builder/service/builder_service.dart';
import 'package:housing_flutter_app/modules/builder/view/builder_dashboard.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/network/builder/model/builder_model.dart';

class ProjectWizardController extends PaginatedController {
  final BuilderService _builderService = BuilderService();
  final currentStep = 0.obs;
  ImagePicker picker = ImagePicker();
  RxList<String> selectedListOfAmenities = <String>[].obs;
  final showAllAmenities = false.obs;
  RxString builderPropertyType = ''.obs;
  RxList<String> propertyStatusList =
      <String>['Ongoing', 'Launch', 'Completed'].obs;
  RxString selectedPropertyStatus = ''.obs;

  RxString uploadBrocherName = ''.obs;
  RxString uploadBrocherPath = ''.obs;

  RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  Map<String, String>? filters = {};

  final project =
      ProjectModel(
        mediaGallery: MediaGallery(images: [], videos: []),
        projectName: '',
        projectArea: 0,
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
      ).obs;

  late TextEditingController projectNameController;
  late TextEditingController projectAreaController;
  late TextEditingController totalBuildingsController;
  late TextEditingController totalUnitsController;
  late TextEditingController reraIdController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipCodeController;
  late TextEditingController locationController;

  @override
  void onInit() {
    super.onInit();
    setUserIdFilter().then((_) => loadInitial());
    assignData();
  }

  Future<void> assignData() async {
    projectNameController = TextEditingController(
      text: project.value.projectName,
    );
    projectAreaController = TextEditingController(
      text: project.value.projectArea.toString(),
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
    await fetchUserData();
  }

  @override
  Future<PaginationResponse> fetchItems(int page) async {
    try {
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

  Future<void> setUserIdFilter() async {
    final userData = await SecureStorage.getUserData();
    final userId = userData?.user?.id ?? '';
    filters = {'created_by': userId};
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
    try {
      List<XFile> files = await picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
        limit: 5,
      );

      if (files.isNotEmpty) {
        if (project.value.imageList.length + files.length > 5) {
          Get.snackbar(
            'Limit Exceeded',
            'You can only select up to 5 images in total',
            snackPosition: SnackPosition.BOTTOM,
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

        Get.snackbar(
          'Success',
          '${files.length} image(s) added',
          snackPosition: SnackPosition.BOTTOM,
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

  Future<void> builderVideoPicker() async {
    try {
      List<XFile> videos = await picker.pickMultiVideo(
        limit: 5,
        maxDuration: Duration(seconds: 60),
      );

      if (videos.isNotEmpty) {
        if (project.value.videoList.length + videos.length > 5) {
          Get.snackbar(
            'Limit Exceeded',
            'You can only select up to 5 videos in total',
            snackPosition: SnackPosition.BOTTOM,
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
          Get.snackbar('Validation Error', err);
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
          price: 0,
          totalUnits: 0,
          availableUnits: 0,
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
      final success = await _builderService.createProject(
        projectData: await _buildProjectPayload(),
        images: project.value.imageList.map((path) => File(path)).toList(),
        videos: project.value.videoList.map((path) => File(path)).toList(),
        documents:
            project.value.brochure != null
                ? File(project.value.pdfPath ?? '')
                : null,
      );
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Project Created Successfully",
          message: "",
          contentType: ContentType.success,
        );
        Get.offUntil(
          MaterialPageRoute(builder: (_) => BuilderDashboard()),
          (route) => route.isFirst,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Failed to Create Project",
          message: "",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print('Create builder project error: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Failed to Create Project",
        message: "",
        contentType: ContentType.failure,
      );
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
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Project Updated Successfully",
          message: "",
          contentType: ContentType.success,
        );
        Get.offUntil(
          MaterialPageRoute(builder: (_) => BuilderDashboard()),
          (route) => route.isFirst,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Failed to Update Project",
          message: "",
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print('Update builder project error: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Failed to Update Project",
        message: "",
        contentType: ContentType.failure,
      );
    }
  }

  Future<ProjectModel> _buildProjectPayload() async {
    final ProjectModel p = project.value;
    print('Building payload ---- > ${p.projectContactInfo?.toJson()}');
    final user = await SecureStorage.getUserData();
    return ProjectModel(
      mediaGallery: MediaGallery(images: p.imageList, videos: p.videoList),
      projectName: p.projectName,
      projectArea: p.projectArea,
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

  // Future<ProjectModel> updateProjectData(ProjectModel updatedData) async {
  //   final ProjectModel p = project.value;
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

  Future<ProjectModel> updateProjectData(ProjectModel updatedData) async {
    final user = await SecureStorage.getUserData();
    print("Images : ${updatedData.mediaGallery.images!}");
    project.update((p) {
      if (p == null) return;
      p.id = updatedData.id;
      p.pdfPath = updatedData.brochure;
      p.imageList =
          updatedData.mediaGallery.images!.isNotEmpty
              ? updatedData.mediaGallery.images!
              : p.imageList;
      p.videoList =
          updatedData.mediaGallery.videos!.isNotEmpty
              ? updatedData.mediaGallery.videos!
              : p.videoList;
      p.projectName = updatedData.projectName;
      p.projectArea = updatedData.projectArea;
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
      p.amenities = updatedData.amenities;
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
      // p.imageList = updatedData.mea
    });

    await assignData();

    return project.value;
  }

  void printProjectDetails() {
    final ProjectModel p = project.value;

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
              '    Variant ${j + 1}: ${variant.name}, BuiltUp: ${variant.builtUpArea}, Carpet: ${variant.carpetArea}, Price: ${variant.price}, Price/SqFt: ${variant.pricePerSqFt}, Total Units: ${variant.totalUnits}, Available Units: ${variant.availableUnits}',
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

      // TODO: Add API call here
      print('Saving Project Data: $projectData');

      Get.snackbar(
        'Success',
        'Project data saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save project data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
