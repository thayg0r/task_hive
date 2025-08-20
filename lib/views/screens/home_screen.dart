import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_viewmodel.dart';
import 'widgets/app_logo_header.dart';
import 'widgets/date_selector.dart';
import 'widgets/task_counter_row.dart';
import 'widgets/task_list.dart';
import 'widgets/task_form_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentDate = _onlyDate(DateTime.now());

  static DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();

    final tasksOfDay = taskVM.tasks.where((t) {
      final d = t.taskDate;
      if (d == null) return false;
      return _isSameDay(_onlyDate(d), _currentDate);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppLogoHeader(),
              const SizedBox(height: 16),
              DateSelector(
                currentDate: _currentDate,
                onPrev: () => setState(
                  () => _currentDate = _onlyDate(
                    _currentDate.subtract(const Duration(days: 1)),
                  ),
                ),
                onNext: () => setState(
                  () => _currentDate = _onlyDate(
                    _currentDate.add(const Duration(days: 1)),
                  ),
                ),
                onPickDate: (d) => setState(() => _currentDate = d),
              ),
              const SizedBox(height: 16),
              TaskCounterRow(tasks: tasksOfDay),
              const SizedBox(height: 20),
              Expanded(
                child: TaskList(
                  tasks: tasksOfDay,
                  taskVM: taskVM,
                  currentDate: _currentDate,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FloatingActionButton(
              onPressed: () =>
                  TaskFormSheet.open(context, taskVM, _currentDate),
              backgroundColor: const Color(0xFFFFC40C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(33),
              ),
              child: SvgPicture.asset(
                'assets/icons/plus.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ))),
    );
  }
}
