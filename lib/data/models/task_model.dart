class TaskModel {
  final String id;
  final String title;
  final String priority;
  final String? notifyTime;
  final bool isCompleted;
  final DateTime? taskDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.isCompleted,
    required this.notifyTime,
    this.taskDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      priority: json['priority'] ?? 'III',
      notifyTime: json['notify_time'],
      isCompleted: json['is_completed'] ?? false,
      taskDate:
          json['task_date'] != null ? DateTime.parse(json['task_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'notify_time': notifyTime,
      'is_completed': isCompleted,
      'task_date': taskDate != null
          ? "${taskDate!.year.toString().padLeft(4, '0')}-"
              "${taskDate!.month.toString().padLeft(2, '0')}-"
              "${taskDate!.day.toString().padLeft(2, '0')}"
          : null,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? priority,
    String? notifyTime,
    bool? isCompleted,
    DateTime? taskDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      notifyTime: notifyTime ?? this.notifyTime,
      isCompleted: isCompleted ?? this.isCompleted,
      taskDate: taskDate ?? this.taskDate,
    );
  }
}
