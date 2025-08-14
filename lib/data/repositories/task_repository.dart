import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/supabase_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  final SupabaseClient _client = SupabaseService.client;
  final String tableName = 'tasks';

  Future<List<TaskModel>> getTasks() async {
    final response = await _client.from(tableName).select();
    return response.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _client.from(tableName).insert(task.toJson());
  }

  Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await _client.from(tableName).update(data).eq('id', id);
  }

  Future<void> deleteTask(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }
}
