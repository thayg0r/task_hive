import 'package:awesome_notifications/awesome_notifications.dart';
import '../../data/models/task_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  Future<void> scheduleTaskNotification(TaskModel task) async {
    if (task.taskDate == null || task.notifyTime == null) return;

    final parts = task.notifyTime!.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final scheduledDate = DateTime(
      task.taskDate!.year,
      task.taskDate!.month,
      task.taskDate!.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(DateTime.now())) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id.hashCode & 0x7fffffff,
        channelKey: 'taskhive_channel',
        title: 'Lembrete ⏰',
        body: 'Sua tarefa começa agora!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
  }

  Future<void> cancelTaskNotification(String taskId) async {
    await AwesomeNotifications().cancel(taskId.hashCode & 0x7fffffff);
  }
}
