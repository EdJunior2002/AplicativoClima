import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_clima/Model/weather_model.dart';
import 'package:app_clima/Service/services.dart';
import 'package:app_clima/config.dart';
import 'package:app_clima/Screen/widgets/weather_head.dart';
import 'package:app_clima/Screen/widgets/weather_body.dart';
import 'package:app_clima/Screen/widgets/weather_footer.dart';
import 'package:app_clima/Screen/widgets/forecast_list.dart';

class ThemePalette {
  final List<Color> background; // gradient
  final Color textColor;
  final Color cardColor;
  final Color accentColor;

  const ThemePalette({required this.background, required this.textColor, required this.cardColor, required this.accentColor});
}

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
    // compute palette from current weather (if available) so scaffold background follows theme
    final palette = _paletteForTemperature(_weather?.temperature.current);

    return Scaffold(
      backgroundColor: palette.background.first,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 12),
              Expanded(child: _buildContent(formattedDate, formattedTime, palette)),
            ],
          ),
        ),
      ),
    );
  }

  ThemePalette _paletteForTemperature(double? t) {
    if (t == null) {
      return const ThemePalette(
        background: [Color(0xFF667EEA), Color(0xFF764BA2)],
        textColor: Colors.white,
        cardColor: Color(0x553366EA),
        accentColor: Color(0xFF9F7AEA),
      );
    }

    if (t >= 25) {
      return const ThemePalette(
        background: [Color(0xFFFF7E5F), Color(0xFFFFB199)],
        textColor: Colors.white,
        cardColor: Color(0x66FF7E5F),
        accentColor: Color(0xFFFFD166),
      );
    } else if (t >= 15) {
      return const ThemePalette(
        background: [Color(0xFF667EEA), Color(0xFF764BA2)],
        textColor: Colors.white,
        cardColor: Color(0x553366EA),
        accentColor: Color(0xFF9F7AEA),
      );
    } else {
      return const ThemePalette(
        background: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
        textColor: Colors.white,
        cardColor: Color(0x552193B0),
        accentColor: Color(0xFF2EC4B6),
      );
    }
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: double.infinity,
      child: Row(
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
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _loadWeather(_searchController.text),
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: 'Pesquisar',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String formattedDate, String formattedTime, ThemePalette palette) {
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

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: palette.background, begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                WeatherHead(
                  name: w.name,
                  date: formattedDate,
                  time: formattedTime,
                  main: w.weather.isNotEmpty ? w.weather[0].main : '',
                  textColor: palette.textColor,
                ),
                const SizedBox(height: 12),
                WeatherBody(
                  temperature: w.temperature.current,
                  icon: w.weather.isNotEmpty ? w.weather[0].icon : null,
                  textColor: palette.textColor,
                  iconColor: palette.accentColor,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: WeatherFooter(weather: w, panelColor: palette.cardColor, textColor: palette.textColor, iconColor: palette.accentColor),
                ),
                const SizedBox(height: 12),
                ForecastList(forecast: _forecast, cardColor: palette.cardColor, textColor: palette.textColor),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
    }
  }
}

// Widgets moved to separate files in lib/Screen/widgets for better organization.