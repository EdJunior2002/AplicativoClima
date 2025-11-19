import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_clima/Model/weather_model.dart';

class ForecastList extends StatelessWidget {
  final ForecastData? forecast;
  final Color cardColor;
  final Color textColor;

  const ForecastList({super.key, required this.forecast, this.cardColor = const Color(0x44FFFFFF), this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    if (forecast == null || forecast!.list.isEmpty) {
      return const SizedBox.shrink();
    }

    final items = forecast!.list.take(8).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text('Previsão', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final it = items[index];
              final time = DateFormat('dd/MM HH:mm').format(it.dateTime);
              final temp = it.temperature.current.toStringAsFixed(1);
              final descr = it.weather.isNotEmpty ? it.weather[0].main : '';
              final icon = it.weather.isNotEmpty ? it.weather[0].icon : null;

              return Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Image.network('https://openweathermap.org/img/wn/$icon.png', width: 36, height: 36)
                    else
                      const SizedBox(height: 36),
                    const SizedBox(height: 4),
                    Text(time, style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('$temp°C', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(descr, style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
