class TaskModel {
  final String id;
  final String title;
  final String priority;
  final String? notifyTime;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.isCompleted,
    required this.notifyTime,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      priority: json['priority'] ?? 'III',
      notifyTime: json['notify_time'],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'notify_time': notifyTime,
      'is_completed': isCompleted,
    };
  }
}
