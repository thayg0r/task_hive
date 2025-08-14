import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

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
    await _repository.addTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await fetchTasks();
  }

  Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await _repository.updateTask(id, data);
    await fetchTasks();
  }
}
