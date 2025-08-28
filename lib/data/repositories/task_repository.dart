import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_hive/core/constants/app_keys.dart';
import '../models/task_model.dart';

class TaskRepository {
  final String baseUrl = "${AppKeys.supabaseUrl}/rest/v1/tasks";
  final Map<String, String> headers = {
    "apikey": AppKeys.supabaseAnonKey,
    "Authorization": "Bearer ${AppKeys.supabaseAnonKey}",
    "Content-Type": "application/json",
  };

  Future<List<TaskModel>> getTasks() async {
    final res = await http.get(
      Uri.parse("$baseUrl?select=*"),
      headers: headers,
    );                                                                                                                     

    if (res.statusCode != 200) {
      throw Exception("Erro ao buscar tarefas: ${res.body}");
    }

    final List data = jsonDecode(res.body);
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> addTask(TaskModel task) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        ...headers,
        "Prefer": "return=representation",
      },
      body: jsonEncode(task.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception("Erro ao criar tarefa: ${res.body}");
    }

    final List data = jsonDecode(res.body);
    return TaskModel.fromJson(data.first);
  }

  Future<TaskModel> updateTask(String id, Map<String, dynamic> data) async {
    final res = await http.patch(
      Uri.parse("$baseUrl?id=eq.$id"),
      headers: {
        ...headers,
        "Prefer": "return=representation",
      },
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception("Erro ao atualizar tarefa: ${res.body}");
    }

    final List<dynamic> responseData = jsonDecode(res.body);
    return TaskModel.fromJson(responseData.first);
  }

  Future<void> deleteTask(String id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl?id=eq.$id"),
      headers: headers,
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Erro ao deletar tarefa: ${res.body}");
    }
  }
}
