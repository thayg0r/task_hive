import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/task_model.dart';
import '../../../viewmodels/task_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskFormSheet {
  static void open(
      BuildContext context, TaskViewModel taskVM, DateTime? currentDate,
      {TaskModel? task}) {
    final TextEditingController titleController =
        TextEditingController(text: task?.title ?? "");
    final navigator = Navigator.of(context);
    String priority = task?.priority ?? "III";
    TimeOfDay? selectedTime;
    DateTime? selectedDate = task?.taskDate != null
        ? DateTime(
            task!.taskDate!.year, task.taskDate!.month, task.taskDate!.day)
        : currentDate;

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
                      task == null
                          ? SvgPicture.asset(
                              'assets/icons/add-square.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFFC40C),
                                BlendMode.srcIn,
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/icons/pencil.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFFC40C),
                                BlendMode.srcIn,
                              ),
                            ),
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
                          style:
                              TextStyle(color: Color(0xFF191919), fontSize: 16),
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
                    items: const [
                      DropdownMenuItem(
                        value: "I",
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 6, backgroundColor: Colors.red),
                            SizedBox(width: 6),
                            Text("Alta"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "II",
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 6, backgroundColor: Color(0xFFFFC40C)),
                            SizedBox(width: 6),
                            Text("Média"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "III",
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 6, backgroundColor: Colors.blue),
                            SizedBox(width: 6),
                            Text("Baixa"),
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
                          style:
                              TextStyle(color: Color(0xFF191919), fontSize: 16),
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
                      SizedBox(
                        width: 180,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              locale: const Locale('pt', 'BR'),
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                const brandYellow = Color(0xFFFFC40C);
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.fromSeed(
                                        seedColor: brandYellow),
                                    datePickerTheme: DatePickerThemeData(
                                      headerBackgroundColor: brandYellow,
                                      headerForegroundColor: Color(0xFF191919),
                                      todayForegroundColor:
                                          const MaterialStatePropertyAll(
                                              Color(0xFF191919)),
                                      todayBackgroundColor:
                                          const MaterialStatePropertyAll(
                                              brandYellow),
                                      dayForegroundColor:
                                          const MaterialStatePropertyAll(
                                              Color(0xFF191919)),
                                      dayBackgroundColor: MaterialStateProperty
                                          .resolveWith<Color?>(
                                        (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return brandYellow;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              selectedDate = picked;
                              setModalState(() {});
                            }
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFFC40C),
                              BlendMode.srcIn,
                            ),
                          ),
                          label: const Text(
                            "Escolher data",
                            style: TextStyle(color: Color(0xFF191919)),
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
                      SizedBox(
                        width: 180,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              selectedTime = picked;
                              setModalState(() {});
                            }
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/clock.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFFC40C),
                              BlendMode.srcIn,
                            ),
                          ),
                          label: const Text(
                            "Escolher horário",
                            style: TextStyle(color: Color(0xFF191919)),
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
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color(0x6D191919);
                          }
                          return const Color(0xFFE6E6E6);
                        },
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

                            navigator.pop();
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
