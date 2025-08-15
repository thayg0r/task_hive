import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../data/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  String? _editingId;
  final TextEditingController _editController = TextEditingController();

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Confirmar'),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const inputHeight = 48.0;
    final taskVM = context.watch<TaskViewModel>();

    final tarefasCriadas = taskVM.tasks.length;
    final tarefasConcluidas = taskVM.tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // topo
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icons/hive.png', height: 48),
                    const SizedBox(width: 4),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Task',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191919),
                            ),
                          ),
                          TextSpan(
                            text: 'Hive',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFC40C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: inputHeight,
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B6572),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Adicione uma nova tarefa',
                          hintStyle: const TextStyle(fontSize: 16),
                          filled: true,
                          fillColor: const Color(0xFFF0F0F0),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: inputHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          await taskVM.addTask(TaskModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            title: text,
                            isCompleted: false,
                          ));
                          _controller.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC40C),
                        fixedSize: const Size(48, inputHeight),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounter('Tarefas criadas', tarefasCriadas,
                      const Color(0xFFFFC40C)),
                  _buildCounter('Concluídas', tarefasConcluidas, Colors.green),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: taskVM.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskVM.tasks[index];
                    final isEditing = _editingId == task.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              taskVM.updateTask(
                                task.id,
                                {'is_completed': !task.isCompleted},
                              );
                            },
                            child: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: const Color(0xFFFFC40C),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: isEditing
                                ? TextField(
                                    controller: _editController,
                                    autofocus: true,
                                    style: const TextStyle(fontSize: 16),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 6),
                                    ),
                                  )
                                : Text(
                                    task.title,
                                    style: TextStyle(
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationColor: Colors.grey,
                                      color: task.isCompleted
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                          if (isEditing) ...[
                            IconButton(
                              tooltip: 'Salvar edição',
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                final newTitle = _editController.text.trim();
                                if (newTitle.isEmpty ||
                                    newTitle == task.title) {
                                  setState(() => _editingId = null);
                                  return;
                                }
                                _showConfirmDialog(
                                  context: context,
                                  title: 'Confirmar edição',
                                  message: 'Deseja salvar as alterações?',
                                  onConfirm: () async {
                                    await taskVM.updateTask(
                                        task.id, {'title': newTitle});
                                    setState(() => _editingId = null);
                                  },
                                );
                              },
                            ),
                            IconButton(
                              tooltip: 'Cancelar',
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () =>
                                  setState(() => _editingId = null),
                            ),
                          ] else ...[
                            IconButton(
                              tooltip: 'Editar',
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                setState(() {
                                  _editingId = task.id;
                                  _editController.text = task.title;
                                });
                              },
                            ),
                            IconButton(
                              tooltip: 'Excluir',
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.grey),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                _showConfirmDialog(
                                  context: context,
                                  title: "Confirmar exclusão",
                                  message:
                                      'Tem certeza que deseja excluir a tarefa?',
                                  onConfirm: () => taskVM.deleteTask(task.id),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int count, Color color) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}
