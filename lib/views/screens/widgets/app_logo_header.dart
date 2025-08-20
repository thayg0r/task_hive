import 'package:flutter/material.dart';

class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/hive.png', height: 48),
          const SizedBox(width: 4),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Task',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
                TextSpan(
                  text: 'Hive',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC40C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
