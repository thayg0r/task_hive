import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import '../core/services/notification_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<TaskModel> tasks = [];
  bool isLoading = false;

  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();

    tasks = await _repository.getTasks();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    final created = await _repository.addTask(task);
    await fetchTasks();

    await NotificationService.instance.scheduleTaskNotification(created);
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await NotificationService.instance.cancelTaskNotification(id);
    await fetchTasks();
  }

  Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await _repository.updateTask(id, data);
    await fetchTasks();

    final updated = tasks.firstWhere((t) => t.id == id);

    await NotificationService.instance.cancelTaskNotification(updated.id);

    if (!updated.isCompleted) {
      await NotificationService.instance.scheduleTaskNotification(updated);
    }
  }
}
