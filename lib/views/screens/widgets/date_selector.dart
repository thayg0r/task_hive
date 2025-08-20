import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateSelector extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onPickDate;

  const DateSelector({
    super.key,
    required this.currentDate,
    required this.onPrev,
    required this.onNext,
    required this.onPickDate,
  });

  static DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatShort(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}";

  String _weekdayPt(int weekday) {
    const names = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return names[(weekday - 1) % 7];
  }

  String _labelFor(DateTime d) {
    final today = _onlyDate(DateTime.now());
    final tomorrow = _onlyDate(today.add(const Duration(days: 1)));
    if (_isSameDay(d, today)) return 'Hoje • ${_formatShort(d)}';
    if (_isSameDay(d, tomorrow)) return 'Amanhã • ${_formatShort(d)}';
    return '${_weekdayPt(d.weekday)} • ${_formatShort(d)}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow-left.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF191919),
                BlendMode.srcIn,
              ),
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: onPrev,
          ),
          OutlinedButton.icon(
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF191919),
            ),
            label: Text(_labelFor(currentDate)),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) onPickDate(_onlyDate(picked));
            },
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              side: const BorderSide(color: Color(0x00E0E0E0)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              foregroundColor: const Color(0xFF191919),
              backgroundColor: Colors.white,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow-right.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF191919),
                BlendMode.srcIn,
              ),
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
