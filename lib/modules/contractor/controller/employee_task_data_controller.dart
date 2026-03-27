import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contractor/model/employee/employee_task_model.dart';
import 'package:nesticope_app/data/network/contractor/service/employee/employee_task_data_service.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class EmployeeTaskDataController extends PaginatedController<EmployeeTaskItem> {
  late String employeeId;



  Future<void> init(String id) async {
    employeeId = id;
    await loadInitial();

    
  }
  Future<void> refreshTasks() async {
    try {
      await refreshList();
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh',
        contentType: ContentType.failure,
      );
    }
  }

  // Future<void> refreshTasks() async {
  //   isLoading.value = true;
  //   page.value = 1;
  //   try {
  //     final resp = await EmployeeTaskDataService.instance.fetchTasks(
  //       employeeId: employeeId,
  //       page: page.value,
  //       limit: limit.value,
  //     );
  //     tasks.assignAll(resp.items);
  //     hasMore.value = resp.hasMore;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  



  @override
  Future<PaginationResponse<EmployeeTaskItem>> fetchItems(int page) async {
    final resp = await EmployeeTaskDataService.instance.fetchTasks(
      employeeId: employeeId,
      page: page,
      limit: 10,
    );
    return resp;
  }
}
