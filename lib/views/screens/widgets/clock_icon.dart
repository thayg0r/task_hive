import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClockIcon extends StatelessWidget {
  final TimeOfDay time;
  final double size;

  const ClockIcon({super.key, required this.time, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ClockPainter(time),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final TimeOfDay time;
  _ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintHour = Paint()
      ..color = const Color(0XFF191919)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final paintMinute = Paint()
      ..color = const Color(0XFF191919)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paintCircle);

    final hourAngle =
        ((time.hour % 12) + time.minute / 60) * 30 * (math.pi / 180);
    final minuteAngle = time.minute * 6 * (math.pi / 180);

    final hourHand = Offset(
      center.dx + radius * 0.5 * math.cos(hourAngle - math.pi / 2),
      center.dy + radius * 0.5 * math.sin(hourAngle - math.pi / 2),
    );
    canvas.drawLine(center, hourHand, paintHour);

    final minuteHand = Offset(
      center.dx + radius * 0.75 * math.cos(minuteAngle - math.pi / 2),
      center.dy + radius * 0.75 * math.sin(minuteAngle - math.pi / 2),
    );
    canvas.drawLine(center, minuteHand, paintMinute);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
