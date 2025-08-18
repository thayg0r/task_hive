import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  @override
  Widget build(BuildContext context) {
    const inputHeight = 48.0;
    final taskVM = context.watch<TaskViewModel>();

    final tarefasCriadas = taskVM.tasks.length;
    final tarefasConcluidas = taskVM.tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              color: Color.fromARGB(230, 175, 175, 175),
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Adicione uma nova tarefa',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 126, 126, 126),
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(110, 236, 236, 236),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(129, 158, 158, 158),
                                    width: 1),
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
                      _buildCounter(
                          'Concluídas', tarefasConcluidas, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: taskVM.tasks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 68,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Você ainda não tem tarefas cadastradas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF191919),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Crie tarefas e organize seus itens a fazer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ReorderableListView.builder(
                            itemCount: taskVM.tasks.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final movedTask =
                                    taskVM.tasks.removeAt(oldIndex);
                                taskVM.tasks.insert(newIndex, movedTask);
                              });
                            },
                            buildDefaultDragHandles: false,
                            itemBuilder: (context, index) {
                              final sortedTasks = [...taskVM.tasks]
                                ..sort((a, b) {
                                  if (a.isCompleted == b.isCompleted) return 0;
                                  return a.isCompleted ? 1 : -1;
                                });

                              final task = sortedTasks[index];
                              final isEditing = _editingId == task.id;

                              return ReorderableDragStartListener(
                                key: ValueKey(task.id),
                                index: index,
                                enabled: true,
                                child: Slidable(
                                  startActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    extentRatio: 0.25,
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) {
                                          setState(() {
                                            _editingId = task.id;
                                            _editController.text = task.title;
                                          });
                                        },
                                        backgroundColor:
                                            const Color(0xFF2196F3),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    extentRatio: 0.25,
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) {
                                          final deletedTask = task;
                                          taskVM.deleteTask(task.id);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Tarefa excluída com sucesso!'),
                                              action: SnackBarAction(
                                                label: 'Desfazer',
                                                textColor: Colors.yellow[700],
                                                onPressed: () {
                                                  taskVM.addTask(deletedTask);
                                                },
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        },
                                        backgroundColor:
                                            const Color(0xFFE53935),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_outline,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            taskVM.updateTask(
                                              task.id,
                                              {
                                                'is_completed':
                                                    !task.isCompleted
                                              },
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
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6),
                                                  ),
                                                )
                                              : AnimatedSwitcher(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  transitionBuilder:
                                                      (child, animation) =>
                                                          FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  ),
                                                  child: Text(
                                                    task.title,
                                                    key: ValueKey(
                                                        task.isCompleted),
                                                    style: TextStyle(
                                                      decoration:
                                                          task.isCompleted
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                      color: task.isCompleted
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        if (isEditing) ...[
                                          IconButton(
                                            iconSize: 20,
                                            tooltip: 'Salvar edição',
                                            icon: const Icon(Icons.check,
                                                color: Colors.green),
                                            onPressed: () {
                                              final newTitle =
                                                  _editController.text.trim();
                                              if (newTitle.isEmpty ||
                                                  newTitle == task.title) {
                                                setState(
                                                    () => _editingId = null);
                                                return;
                                              }
                                              final oldTitle = task.title;

                                              setState(() {
                                                taskVM.updateTask(task.id,
                                                    {'title': newTitle});
                                                _editingId = null;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                      'Tarefa atualizada com sucesso!'),
                                                  action: SnackBarAction(
                                                    label: 'Desfazer',
                                                    textColor:
                                                        Colors.yellow[700],
                                                    onPressed: () {
                                                      setState(() {
                                                        taskVM.updateTask(
                                                            task.id, {
                                                          'title': oldTitle
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            iconSize: 20,
                                            tooltip: 'Cancelar',
                                            icon: const Icon(Icons.close,
                                                color: Colors.red),
                                            onPressed: () => setState(
                                                () => _editingId = null),
                                          ),
                                        ] else ...[
                                          IconButton(
                                            tooltip: 'Editar',
                                            iconSize: 20,
                                            icon: const Icon(Icons.edit,
                                                color: Colors.grey),
                                            padding: EdgeInsets.zero,
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () {
                                              setState(() {
                                                _editingId = task.id;
                                                _editController.text =
                                                    task.title;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            tooltip: 'Excluir',
                                            iconSize: 20,
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.grey),
                                            padding: EdgeInsets.zero,
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () {
                                              final removedTask = task;
                                              final removedIndex = index;

                                              setState(() {
                                                taskVM.tasks.removeAt(index);
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                      'Tarefa excluída com sucesso!'),
                                                  action: SnackBarAction(
                                                    label: 'Desfazer',
                                                    textColor:
                                                        Colors.yellow[700],
                                                    onPressed: () {
                                                      setState(() {
                                                        taskVM.tasks.insert(
                                                            removedIndex,
                                                            removedTask);
                                                      });
                                                    },
                                                  ),
                                                  duration: const Duration(
                                                      seconds: 5),
                                                ),
                                              );

                                              Future.delayed(
                                                  const Duration(seconds: 5),
                                                  () {
                                                if (!taskVM.tasks
                                                    .contains(removedTask)) {
                                                  taskVM.deleteTask(task.id);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
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
