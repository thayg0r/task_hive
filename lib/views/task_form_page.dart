import 'package:flutter/material.dart';
import '../data/models/task_model.dart';

class TaskFormPage extends StatefulWidget {
  final TaskModel? task;
  final Function(TaskModel) onSave;

  const TaskFormPage({super.key, this.task, required this.onSave});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.task?.title ?? '';
  }

  void _confirmSave(TaskModel task) {
    if (widget.task != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Confirmar edição"),
          content: const Text("Deseja salvar as alterações desta tarefa?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Confirmar"),
              onPressed: () {
                Navigator.pop(context);
                widget.onSave(task); 
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      widget.onSave(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe um título' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final task = TaskModel(
                      id: widget.task?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      isCompleted: widget.task?.isCompleted ?? false,
                    );
                    _confirmSave(task);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
