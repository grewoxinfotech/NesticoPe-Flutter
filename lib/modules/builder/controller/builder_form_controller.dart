import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../data/models/project_model.dart';
import '../model/config_model.dart';

class ProjectWizardController extends GetxController {
  // step index: 0..4
  final currentStep = 0.obs;

  // form data
  final project = ProjectModel(
    projectName: '',
    projectArea: 0,
    projectSize: ProjectSize(totalBuildings: 1, totalUnits: 1),
    launchDate: DateTime.now(),
    possessionDate: DateTime.now(),
    configurations: [ProjectConfiguration(bhk: 1)],
    reraId: '',
    status: 'upcoming',
    address: '',
    city: '',
    state: '',
    zipCode: '',
    location: '',
  ).obs;

  // UI helpers
  final formKeys = List.generate(5, (_) => GlobalKey<FormState>());

  void next() {
    if (_validateCurrentStep()) {
      if (currentStep.value < 4) currentStep.value++;
    }
  }

  void back() {
    if (currentStep.value > 0) currentStep.value--;
  }

  bool _validateCurrentStep() {
    final key = formKeys[currentStep.value];
    final form = key.currentState;
    if (form == null) return true;
    if (form.validate()) {
      form.save();
      // cross-step custom validations
      if (currentStep.value == 0) {
        final err = _validateDates();
        if (err != null) {
          Get.snackbar('વૈધતા ભૂલ', err);
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
      return 'Possession Launch પછી હોવું જોઈએ';
    }
    return null;
  }

  // Configurations dynamic controls
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
      p!.configurations[configIndex].variants.add(ProjectVariant(
        name: '',
        builtUpArea: 0,
        carpetArea: 0,
        price: 0,
        totalUnits: 0,
        availableUnits: 0,
      ));
    });
  }

  void removeVariant(int configIndex, int variantIndex) {
    project.update((p) {
      p!.configurations[configIndex].variants.removeAt(variantIndex);
    });
  }

  void submit() {
    // UI only; you can hook API here later.
    Get.snackbar('સફળતા', 'પ્રોજેક્ટ ડેટા તૈયાર છે (UI-only)');
  }
}