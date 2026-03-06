import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/model/employee/employee_task_model.dart';
import 'package:housing_flutter_app/data/network/contractor/service/employee/employee_task_service.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';

class EmployeeTaskController extends PaginatedController<EmployeeTaskItem> {
  final RxList<EmployeeTaskItem> tasks = <EmployeeTaskItem>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;
  final page = 1.obs;
  final hasMore = true.obs;

  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final priority = 'medium'.obs;
  final status = 'pending'.obs;
  final dueDate = Rxn<DateTime>();
  final projectId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (projectId.value.isNotEmpty) {
      loadInitial();
    }
  }

  void setProjectId(String id) {
    projectId.value = id;
    loadInitial();
  }

  Future<void> refreshtask() async {
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

  Future<bool> createTask({
    required String employeeId,
    required String projectId,
  }) async {
    try {
      isCreating.value = true;
      final payload = {
        "taskTitle": taskTitleController.text.trim(),
        "taskDescription": taskDescriptionController.text.trim(),
        "priority": priority.value,
        "status": status.value,
        "dueDate": (dueDate.value)?.toIso8601String().split('T').first,
        "employeeId": employeeId,
        "projectId": projectId,
      };
      final ok = await EmployeeTaskService.instance.createTask(payload);
      if (ok) {
        clearForm();
        await refreshtask();
      }
      return ok;
    } catch (_) {
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  Future<bool> updateTask(String id) async {
    final payload = {
      "taskTitle": taskTitleController.text.trim(),
      "taskDescription": taskDescriptionController.text.trim(),
      "priority": priority.value,
      "status": status.value,
      "dueDate": (dueDate.value)?.toIso8601String().split('T').first,
    };
    return await EmployeeTaskService.instance.updateTask(id, payload);
  }

  void clearForm() {
    taskTitleController.clear();
    taskDescriptionController.clear();
    priority.value = 'medium';
    status.value = 'pending';
    dueDate.value = null;
  }

  @override
  Future<PaginationResponse<EmployeeTaskItem>> fetchItems(int page) async {
    return await EmployeeTaskService.instance.fetchTasks(
      page: page,
      limit: 10,
      projectId: projectId.value,
    );
  }
}
