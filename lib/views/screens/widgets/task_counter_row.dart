import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';

class TaskCounterRow extends StatelessWidget {
  final List<TaskModel> tasks;

  const TaskCounterRow({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final created = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCounter('Tarefas criadas', created, const Color(0xFFFFC40C)),
        _buildCounter('Tarefas concluídas', completed, Colors.green),
      ],
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
}
