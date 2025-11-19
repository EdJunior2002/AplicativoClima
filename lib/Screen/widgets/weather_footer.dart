import 'package:flutter/material.dart';
import 'package:app_clima/Model/weather_model.dart';

class WeatherFooter extends StatelessWidget {
  final WeatherData weather;
  final Color panelColor;
  final Color textColor;
  final Color iconColor;

  const WeatherFooter({super.key, required this.weather, this.panelColor = Colors.deepPurple, this.textColor = Colors.white, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: panelColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _InfoColumn(icon: Icons.wind_power, label: 'Vento', value: '${weather.wind.speed} km/h', textColor: textColor, iconColor: iconColor)),
              Expanded(child: _InfoColumn(icon: Icons.thermostat, label: 'Máx', value: '${weather.maxTemperature.toStringAsFixed(1)}°C', textColor: textColor, iconColor: iconColor)),
              Expanded(child: _InfoColumn(icon: Icons.thermostat_outlined, label: 'Mín', value: '${weather.minTemperature.toStringAsFixed(1)}°C', textColor: textColor, iconColor: iconColor)),
            ],
          ),
          Divider(color: textColor.withOpacity(0.24)),
          Row(
            children: [
              Expanded(child: _InfoColumn(icon: Icons.water_drop, label: 'Umidade', value: '${weather.humidity}%', textColor: textColor, iconColor: iconColor)),
              Expanded(child: _InfoColumn(icon: Icons.speed, label: 'Pressão', value: '${weather.pressure} hPa', textColor: textColor, iconColor: iconColor)),
              Expanded(child: _InfoColumn(icon: Icons.explore, label: 'Nível do mar', value: '${weather.seaLevel} m', textColor: textColor, iconColor: iconColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color iconColor;

  const _InfoColumn({required this.icon, required this.label, required this.value, required this.textColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: textColor.withOpacity(0.9))),
      ],
    );
  }
}
