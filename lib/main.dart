import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'core/services/supabase_service.dart';
import 'viewmodels/task_viewmodel.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'taskhive_channel',
        channelName: 'Lembretes de Tarefas',
        channelDescription: 'Notificações de lembrete de tarefas TaskHive',
        defaultColor: const Color(0xFFFFC40C),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    debug: true,
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const TaskHiveApp());
}

class TaskHiveApp extends StatelessWidget {
  const TaskHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandYellow = Color(0xFFFFC40C);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel()..fetchTasks(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Hive',
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          fontFamily: 'HankenGrotesk',
          colorScheme: ColorScheme.fromSeed(seedColor: brandYellow),
          useMaterial3: true,
          datePickerTheme: const DatePickerThemeData(
            headerBackgroundColor: brandYellow,
            headerForegroundColor: Color(0xFF191919),
            surfaceTintColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
