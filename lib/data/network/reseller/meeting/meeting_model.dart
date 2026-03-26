class MeetingItem {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String meetingTitle;
  final String? meetingLink;
  final String date; // ISO yyyy-MM-dd
  final String time; // HH:mm
  final String? note;
  final String status; // scheduled/cancelled/etc.
  final String approvalStatus; // pending/approved/rejected
  final String resellerId;
  final String createdAt;
  final String updatedAt;

  MeetingItem({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.meetingTitle,
    this.meetingLink,
    required this.date,
    required this.time,
    this.note,
    required this.status,
    required this.approvalStatus,
    required this.resellerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeetingItem.fromJson(Map<String, dynamic> json) {
    return MeetingItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      meetingTitle: json['meetingTitle'] ?? '',
      meetingLink: json['meetingLink'],
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      note: json['note'],
      status: json['status'] ?? '',
      approvalStatus: json['approvalStatus'] ?? '',
      resellerId: json['resellerId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'meetingTitle': meetingTitle,
        'meetingLink': meetingLink,
        'date': date,
        'time': time,
        'note': note,
        'status': status,
        'approvalStatus': approvalStatus,
        'resellerId': resellerId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class CreateMeetingPayload {
  final String meetingTitle;
  final String date; // yyyy-MM-dd
  final String time; // HH:mm
  final String resellerId;
  final String? note;

  CreateMeetingPayload({
    required this.meetingTitle,
    required this.date,
    required this.time,
    required this.resellerId,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'meetingTitle': meetingTitle,
        'date': date,
        'time': time,
        'resellerId': resellerId,
        if (note != null && note!.isNotEmpty) 'note': note,
      };
}
