import 'package:flutter/material.dart';

class WeatherHead extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final String main;
  final Color textColor;

  const WeatherHead({super.key, required this.name, required this.date, required this.time, required this.main, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 26, color: textColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        if (main.isNotEmpty) Text(main, style: TextStyle(color: textColor.withOpacity(0.9))),
        const SizedBox(height: 6),
        Text(date, style: TextStyle(color: textColor.withOpacity(0.9))),
        Text(time, style: TextStyle(color: textColor.withOpacity(0.9))),
      ],
    );
  }
}
