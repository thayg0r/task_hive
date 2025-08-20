import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
              colorFilter: const ColorFilter.mode(
                Color(0xFF191919),
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              "${DateFormat.E('pt_BR').format(currentDate).substring(0, 1).toUpperCase()}"
              "${DateFormat.E('pt_BR').format(currentDate).substring(1, 3)} • "
              "${DateFormat('dd/MM/yyyy', 'pt_BR').format(currentDate)}",
              style: const TextStyle(fontSize: 14, color: Color(0xFF191919)),
            ),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                locale: const Locale('pt', 'BR'),
                initialDate: currentDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  const brandYellow = Color(0xFFFFC40C);
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSeed(seedColor: brandYellow),
                      datePickerTheme: DatePickerThemeData(
                        headerBackgroundColor: brandYellow,
                        headerForegroundColor: Colors.black,
                        todayForegroundColor:
                            const MaterialStatePropertyAll(Colors.black),
                        todayBackgroundColor:
                            const MaterialStatePropertyAll(brandYellow),
                        dayForegroundColor:
                            const MaterialStatePropertyAll(Colors.black),
                        dayBackgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
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
