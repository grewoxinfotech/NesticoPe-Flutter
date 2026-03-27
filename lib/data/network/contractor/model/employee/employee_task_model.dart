
class EmployeeTaskItem {
  final String id;
  final String createdBy;
  final String? updatedBy;
  final String employeeId;
  final String projectId;
  final String taskTitle;
  final String taskDescription;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectSummary? project;
  final EmployeeSummary? employee;

  EmployeeTaskItem({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.employeeId,
    required this.projectId,
    required this.taskTitle,
    required this.taskDescription,
    required this.status,
    required this.priority,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.project,
    this.employee,
  });

  factory EmployeeTaskItem.fromJson(Map<String, dynamic> json) {
    return EmployeeTaskItem(
      id: json['id']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString(),
      employeeId: json['employeeId']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      taskTitle: json['taskTitle']?.toString() ?? '',
      taskDescription: json['taskDescription']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      priority: json['priority']?.toString() ?? 'low',
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      project: json['project'] is Map<String, dynamic>
          ? ProjectSummary.fromJson(json['project'] as Map<String, dynamic>)
          : null,
      employee: json['employee'] is Map<String, dynamic>
          ? EmployeeSummary.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'employeeId': employeeId,
      'projectId': projectId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'project': project?.toMap(),
      'employee': employee?.toMap(),
    };
  }
}

class EmployeeTaskListResponse {
  final List<EmployeeTaskItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  EmployeeTaskListResponse({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory EmployeeTaskListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final items = (data['items'] as List?)
            ?.map((e) => EmployeeTaskItem.fromJson(e))
            .toList() ??
        [];
    return EmployeeTaskListResponse(
      items: items,
      total: data['total'] ?? 0,
      currentPage: data['currentPage'] ?? 1,
      totalPages: data['totalPages'] ?? 1,
      hasMore: data['hasMore'] ?? false,
      fetchedAll: data['fetchedAll'] ?? false,
    );
  }
}

class ProjectSummary {
  final String id;
  final String title;
  ProjectSummary({required this.id, required this.title});
  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}

class EmployeeSummary {
  final String id;
  final String name;
  final String email;
  EmployeeSummary({
    required this.id,
    required this.name,
    required this.email,
  });
  factory EmployeeSummary.fromJson(Map<String, dynamic> json) {
    return EmployeeSummary(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}
