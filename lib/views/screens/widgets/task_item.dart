import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/models/task_model.dart';
import '../../../viewmodels/task_viewmodel.dart';
import 'task_form_sheet.dart';
import 'clock_icon.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final TaskViewModel taskVM;

  const TaskItem({super.key, required this.task, required this.taskVM});

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
    return Slidable(
      key: ValueKey(task.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              TaskFormSheet.open(context, taskVM, task.taskDate, task: task);
            },
            padding: EdgeInsets.zero,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/pencil.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              final deletedTask = task;
              taskVM.deleteTask(task.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tarefa excluída com sucesso!'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    textColor: Colors.yellow[700],
                    onPressed: () {
                      taskVM.addTask(deletedTask);
                    },
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            padding: EdgeInsets.zero,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/trash.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF191919).withOpacity(0.05),
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
                      color: task.isCompleted ? Colors.green : Colors.grey,
                      width: 1),
                  color: task.isCompleted ? Colors.green : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.grey,
                  color:
                      task.isCompleted ? Colors.grey : const Color(0xFF191919),
                  fontSize: 16,
                ),
              ),
            ),
            if (task.notifyTime != null && task.notifyTime!.isNotEmpty) ...[
              Tooltip(
                message: "Notificação às ${task.notifyTime!}",
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
                margin: const EdgeInsets.only(right: 8),
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
  }
}
