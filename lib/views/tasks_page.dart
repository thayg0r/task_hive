import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import 'task_form_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final repo = TaskRepository();
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await repo.getTasks();
    setState(() => tasks = data);
  }

  void _addOrEditTask(TaskModel? task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormPage(
          task: task,
          onSave: (newTask) async {
            if (task == null) {
              await repo.addTask(newTask);
            } else {
              await repo.updateTask(task.id, newTask.toJson());
            }
            _loadTasks();
          },
        ),
      ),
    );
  }

  Future<void> _deleteTask(String id) async {
    await repo.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _addOrEditTask(task)),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
