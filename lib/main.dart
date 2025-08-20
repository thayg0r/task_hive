import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'core/services/supabase_service.dart';
import 'viewmodels/task_viewmodel.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';

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
          colorScheme: ColorScheme.fromSeed(seedColor: brandYellow),
          useMaterial3: true,
          datePickerTheme: const DatePickerThemeData(
            headerBackgroundColor: brandYellow,
            headerForegroundColor: Colors.black,
            surfaceTintColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
