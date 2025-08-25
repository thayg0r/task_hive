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

    final baseId = task.id.hashCode & 0x7fffffff;

    final preReminderDate = scheduledDate.subtract(const Duration(minutes: 5));
    if (preReminderDate.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: baseId,
          channelKey: 'taskhive_channel',
          title: 'Lembrete ⏰',
          body: 'Sua tarefa ${task.title} começa em 5 minutos!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(date: preReminderDate),
      );
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: baseId + 1,
        channelKey: 'taskhive_channel',
        title: 'Lembrete ⏰',
        body: 'Não esqueça de sua tarefa ${task.title}!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
  }

  Future<void> cancelTaskNotification(String taskId) async {
    final baseId = taskId.hashCode & 0x7fffffff;
    await AwesomeNotifications().cancel(baseId);
    await AwesomeNotifications().cancel(baseId + 1);
  }
}
