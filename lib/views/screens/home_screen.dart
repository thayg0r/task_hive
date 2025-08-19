import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_hive/views/screens/widgets/clock_icon.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../data/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _editingId;
  final TextEditingController _editController = TextEditingController();

  DateTime _currentDate = _onlyDate(DateTime.now());

  static DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatShort(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm';
  }

  String _labelFor(DateTime d) {
    final today = _onlyDate(DateTime.now());
    final tomorrow = _onlyDate(today.add(const Duration(days: 1)));
    if (_isSameDay(d, today)) return 'Hoje • ${_formatShort(d)}';
    if (_isSameDay(d, tomorrow)) return 'Amanhã • ${_formatShort(d)}';
    return '${_weekdayPt(d.weekday)} • ${_formatShort(d)}';
  }

  String _weekdayPt(int weekday) {
    const names = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return names[(weekday - 1) % 7];
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(" ");
      final hm = parts[0].split(":");
      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);

      if (parts.length > 1) {
        final period = parts[1].toUpperCase();
        if (period == "PM" && hour != 12) hour += 12;
        if (period == "AM" && hour == 12) hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();

    final tasksOfDay = taskVM.tasks.where((t) {
      final d = t.taskDate;
      if (d == null) return false;
      return _isSameDay(_onlyDate(d), _currentDate);
    }).toList();

    final tarefasCriadas = tasksOfDay.length;
    final tarefasConcluidas = tasksOfDay.where((t) => t.isCompleted).length;

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
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            setState(() {
                              _currentDate = _onlyDate(_currentDate
                                  .subtract(const Duration(days: 1)));
                            });
                          },
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.event),
                          label: Text(_labelFor(_currentDate)),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _currentDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _currentDate = _onlyDate(picked));
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: Color(0x00E0E0E0)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            foregroundColor: const Color(0xFF191919),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          padding: EdgeInsets.zero, 
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            setState(() {
                              _currentDate = _onlyDate(
                                  _currentDate.add(const Duration(days: 1)));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    child: tasksOfDay.isEmpty
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
                        : ListView.builder(
                            itemCount: tasksOfDay.length,
                            itemBuilder: (context, index) {
                              final sortedTasks = [...tasksOfDay]..sort((a, b) {
                                  if (a.isCompleted == b.isCompleted) return 0;
                                  return a.isCompleted ? 1 : -1;
                                });
                              final task = sortedTasks[index];
                              final isEditing = _editingId == task.id;

                              return Slidable(
                                key: ValueKey(task.id),
                                startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.15,
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        _openTaskForm(context, taskVM,
                                            task: task);
                                      },
                                      backgroundColor: const Color(0xFF2196F3),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.15,
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
                                      backgroundColor: const Color(0xFFE53935),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete_outline,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                            {'is_completed': !task.isCompleted},
                                          );
                                        },
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: task.isCompleted
                                                    ? Colors.green
                                                    : Colors.grey,
                                                width: 2),
                                            color: task.isCompleted
                                                ? Colors.green
                                                : Colors.transparent,
                                          ),
                                          child: task.isCompleted
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              : null,
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
                                                            child: child),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    task.title,
                                                    key: ValueKey(
                                                        task.isCompleted),
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      decoration:
                                                          task.isCompleted
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                      decorationColor:
                                                          Colors.grey,
                                                      color: task.isCompleted
                                                          ? Colors.grey
                                                          : Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      if (task.notifyTime != null &&
                                          task.notifyTime!.isNotEmpty) ...[
                                        Tooltip(
                                          message:
                                              "Notificação às ${task.notifyTime!}",
                                          child: ClockIcon(
                                            time: _parseTime(task.notifyTime!),
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                      Tooltip(
                                        message: task.priority == "I"
                                            ? "Prioridade Alta"
                                            : task.priority == "II"
                                                ? "Prioridade Média"
                                                : "Prioridade Baixa",
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: task.priority == "I"
                                                ? Colors.red
                                                : task.priority == "II"
                                                    ? const Color(0xFFFFC40C)
                                                    : Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () => _openTaskForm(context, taskVM),
          backgroundColor: const Color(0xFFFFC40C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
          child: const Icon(Icons.add, color: Colors.white),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

  void _openTaskForm(BuildContext context, TaskViewModel taskVM,
      {TaskModel? task}) {
    final TextEditingController titleController =
        TextEditingController(text: task?.title ?? "");
    String priority = task?.priority ?? "III";
    TimeOfDay? selectedTime;

    DateTime? selectedDate =
        task?.taskDate != null ? _onlyDate(task!.taskDate!) : _currentDate;

    if (task?.notifyTime != null) {
      final parts = task!.notifyTime!.split(":");
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          selectedTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              bool isFormValid =
                  titleController.text.trim().isNotEmpty && priority.isNotEmpty;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(task == null ? Icons.add_task : Icons.edit,
                          color: const Color(0xFFFFC40C)),
                      const SizedBox(width: 8),
                      Text(
                        task == null ? "Nova Tarefa" : "Editar Tarefa",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  TextField(
                    controller: titleController,
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      label: RichText(
                        text: const TextSpan(
                          text: "Descrição da tarefa ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: [
                      DropdownMenuItem(
                        value: "I",
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(" Alta"),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "II",
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC40C),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(" Média"),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "III",
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(" Baixa"),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      priority = value!;
                      setModalState(() {});
                    },
                    decoration: InputDecoration(
                      label: RichText(
                        text: const TextSpan(
                          text: "Prioridade ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? "Data da tarefa"
                              : "Data: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                            setModalState(() {});
                          }
                        },
                        icon: const Icon(Icons.event, color: Color(0xFFFFC40C)),
                        label: const Text("Escolher data"),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedTime == null
                              ? "Horário Notificação"
                              : "Notificação: ${selectedTime!.format(context)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedTime = picked);
                            setModalState(() {});
                          }
                        },
                        icon: const Icon(Icons.access_time,
                            color: Color(0xFFFFC40C)),
                        label: const Text("Escolher horário"),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid
                          ? const Color(0xFFFFC40C)
                          : Colors.grey.shade400,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isFormValid
                        ? () async {
                            if (task == null) {
                              await taskVM.addTask(TaskModel(
                                id: '',
                                title: titleController.text.trim(),
                                isCompleted: false,
                                priority: priority,
                                notifyTime: selectedTime?.format(context),
                                taskDate: selectedDate,
                              ));
                            } else {
                              taskVM.updateTask(task.id, {
                                'title': titleController.text.trim(),
                                'priority': priority,
                                'notify_time': selectedTime?.format(context),
                                'task_date': selectedDate?.toIso8601String(),
                              });
                            }

                            Navigator.pop(context);
                          }
                        : null,
                    child: Text(
                      task == null ? "Salvar" : "Atualizar",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
