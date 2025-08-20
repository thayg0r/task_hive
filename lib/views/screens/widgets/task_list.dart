import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';
import '../../../viewmodels/task_viewmodel.dart';
import 'task_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final TaskViewModel taskVM;
  final DateTime currentDate;

  const TaskList({
    super.key,
    required this.tasks,
    required this.taskVM,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/note.svg',
              width: 68,
              height: 68,
              colorFilter: ColorFilter.mode(
                Colors.grey.shade400,
                BlendMode.srcIn,
              ),
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
              'Adicione suas tarefas no botão + abaixo',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final sortedTasks = [...tasks]..sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? 1 : -1;
      });

    return ListView.builder(
      itemCount: sortedTasks.length,
      itemBuilder: (context, i) {
        return TaskItem(task: sortedTasks[i], taskVM: taskVM);
      },
    );
  }
}
