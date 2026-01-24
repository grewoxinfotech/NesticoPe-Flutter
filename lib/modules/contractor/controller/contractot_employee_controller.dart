import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/employee/contractor_employee_model.dart';
import '../../../data/network/contractor/service/employee/contractor_employee_services.dart';
import '../../../widgets/messages/snack_bar.dart';

class ContractorEmployeeController
    extends PaginatedController<ContractorEmployeeItem> {
  var txtName = TextEditingController();
  var txtPhone = TextEditingController();
  var txtExp = TextEditingController();
  var txtEmail = TextEditingController();
  final addEmployeeFormKey = GlobalKey<FormState>();
  var isEditing = false.obs;
  var employeeId = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadInitial();
  }

  @override
  Future<PaginationResponse<ContractorEmployeeItem>> fetchItems(
    int page,
  ) async {
    try {
      final user = await SecureStorage.getUserData();
      final createdBy = user?.user?.id ?? '';
      return await ContractorEmployeeServices.instance.fetchContractorEmployees(
        page: page,
        createdBy: createdBy,
      );
    } catch (e) {
      rethrow;
    }
  }

  void populateControllers(ContractorEmployeeItem item, bool editing) {
    txtName.text = item.name ?? '';
    txtPhone.text = item.phone ?? '';
    txtExp.text = item.experience?.toString() ?? '';
    txtEmail.text = item.email ?? '';
    employeeId.value = item.id ?? '';
    isEditing.value = editing;
  }

  Future<void> refreshEmployee() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> deletedContractorEmployeeData(String id) async {
    final response = await ContractorEmployeeServices.instance
        .deleteContractorEmployee(id);
    if (response) {
      refreshList();
    }
  }

  void updateEmployee() async {
    try {
      final employeeData = {
        'name': txtName.text,
        'phone': txtPhone.text,
        'experience': txtExp.text,
        'email': txtEmail.text,
      };

      final success = await ContractorEmployeeServices.instance
          .updateContractorEmployee(employeeData, employeeId.value);
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Employee updated successfully',
          contentType: ContentType.success,
        );
        clearControllers();
        refreshList();
      } else {
        clearControllers();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to update employee',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'An error occurred',
        contentType: ContentType.failure,
      );
    }
  }

  void addEmployee() async {
    try {
      final employeeData = {
        'name': txtName.text,
        'phone': txtPhone.text,
        'experience': txtExp.text,
        'email': txtEmail.text,
      };

      final success = await ContractorEmployeeServices.instance
          .addContractorEmployee(employeeData);
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Employee added successfully',
          contentType: ContentType.success,
        );
        clearControllers();
        refreshList();
      } else {
        clearControllers();

        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to add employee',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'An error occurred',
        contentType: ContentType.failure,
      );
    }
  }

  void clearControllers() {
    txtName.clear();
    txtPhone.clear();
    txtExp.clear();
    txtEmail.clear();
    addEmployeeFormKey.currentState?.reset();
  }
}
