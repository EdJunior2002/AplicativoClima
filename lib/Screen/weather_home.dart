import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_clima/Model/weather_model.dart';
import 'package:app_clima/Service/services.dart';
import 'package:app_clima/config.dart';

enum LoadState { loading, success, error }

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherServices _services = WeatherServices();

  WeatherData? _weather;
  ForecastData? _forecast;
  LoadState _state = LoadState.loading;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather([String? city]) async {
    setState(() {
      _state = LoadState.loading;
      _errorMessage = null;
    });

    final q = (city == null || city.trim().isEmpty) ? null : city.trim();
    try {
      final c = q ?? kDefaultCity;
      final results = await Future.wait([
        _services.fetchWeather(city: c),
        _services.fetchForecast(city: c),
      ]);

      setState(() {
        _weather = results[0] as WeatherData;
        _forecast = results[1] as ForecastData;
        _state = LoadState.success;
      });
    } catch (e) {
      setState(() {
        _state = LoadState.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    final formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 12),
              Expanded(child: _buildContent(formattedDate, formattedTime)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Pesquisar cidade (ex: São Paulo)',
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8)),
              filled: true,
              fillColor: Color.fromRGBO(255, 255, 255, 0.12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
            onSubmitted: (v) => _loadWeather(v),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _loadWeather(_searchController.text),
          icon: const Icon(Icons.search, color: Colors.white),
          tooltip: 'Pesquisar',
        ),
      ],
    );
  }

  Widget _buildContent(String formattedDate, String formattedTime) {
    switch (_state) {
      case LoadState.loading:
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      case LoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage ?? 'Erro desconhecido', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => _loadWeather(), child: const Text('Tentar novamente')),
            ],
          ),
        );
      case LoadState.success:
        final w = _weather!;
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WeatherHead(name: w.name, date: formattedDate, time: formattedTime, main: w.weather.isNotEmpty ? w.weather[0].main : ''),
              const SizedBox(height: 12),
              WeatherBody(temperature: w.temperature.current, icon: w.weather.isNotEmpty ? w.weather[0].icon : null),
              const SizedBox(height: 12),
              WeatherFooter(weather: w),
              const SizedBox(height: 12),
              ForecastList(forecast: _forecast),
            ],
          ),
        );
    }
  }
}

class WeatherHead extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final String main;

  const WeatherHead({super.key, required this.name, required this.date, required this.time, required this.main});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        if (main.isNotEmpty) Text(main, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Text(date, style: const TextStyle(color: Colors.white70)),
        Text(time, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class WeatherBody extends StatelessWidget {
  final double temperature;
  final String? icon;

  const WeatherBody({super.key, required this.temperature, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Image.network('https://openweathermap.org/img/wn/${icon}@4x.png', width: 120, height: 120, fit: BoxFit.cover)
        else
          Icon(Icons.cloud, size: 120, color: Colors.white70),
        const SizedBox(height: 8),
        Text('${temperature.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 44, color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class WeatherFooter extends StatelessWidget {
  final WeatherData weather;

  const WeatherFooter({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _infoColumn(icon: Icons.wind_power, label: 'Vento', value: '${weather.wind.speed} km/h')),
              Expanded(child: _infoColumn(icon: Icons.thermostat, label: 'Máx', value: '${weather.maxTemperature.toStringAsFixed(1)}°C')),
              Expanded(child: _infoColumn(icon: Icons.thermostat_outlined, label: 'Mín', value: '${weather.minTemperature.toStringAsFixed(1)}°C')),
            ],
          ),
          const Divider(color: Colors.white24),
          Row(
            children: [
              Expanded(child: _infoColumn(icon: Icons.water_drop, label: 'Umidade', value: '${weather.humidity}%')),
              Expanded(child: _infoColumn(icon: Icons.speed, label: 'Pressão', value: '${weather.pressure} hPa')),
              Expanded(child: _infoColumn(icon: Icons.explore, label: 'Nível do mar', value: '${weather.seaLevel} m')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class ForecastList extends StatelessWidget {
  final ForecastData? forecast;

  const ForecastList({super.key, required this.forecast});

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
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Image.network('https://openweathermap.org/img/wn/${icon}.png', width: 36, height: 36)
                    else
                      const SizedBox(height: 36),
                    const SizedBox(height: 4),
                    Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('$temp°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(descr, style: const TextStyle(color: Colors.white70, fontSize: 12)),
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