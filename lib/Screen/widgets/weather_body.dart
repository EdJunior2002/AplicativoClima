import 'package:flutter/material.dart';

class WeatherBody extends StatelessWidget {
  final double temperature;
  final String? icon;
  final Color textColor;
  final Color iconColor;

  const WeatherBody({super.key, required this.temperature, this.icon, this.textColor = Colors.white, this.iconColor = Colors.white70});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Image.network('https://openweathermap.org/img/wn/$icon@4x.png', width: 120, height: 120, fit: BoxFit.cover)
        else
          Icon(Icons.cloud, size: 120, color: iconColor),
        const SizedBox(height: 8),
        Text('${temperature.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 44, color: textColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
