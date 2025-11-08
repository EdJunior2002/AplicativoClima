import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app_clima/Model/weather_model.dart';
import 'package:app_clima/config.dart';

class WeatherServices {
  final http.Client client;

  WeatherServices({http.Client? client}) : client = client ?? http.Client();


  Future<WeatherData> fetchWeather({String city = kDefaultCity}) async {
    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'q': city,
        'appid': kOpenWeatherApiKey,
        'units': 'metric',
      },
    );

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
  
        throw Exception('Erro ao carregar dados do tempo (status: ${response.statusCode})');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo limite excedido ao buscar dados do tempo.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
  
      throw Exception('Erro inesperado: $e');
    }
  }


  Future<ForecastData> fetchForecast({String city = kDefaultCity}) async {
    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/forecast',
      {
        'q': city,
        'appid': kOpenWeatherApiKey,
        'units': 'metric',
      },
    );

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ForecastData.fromJson(json);
      } else {
        throw Exception('Erro ao carregar forecast (status: ${response.statusCode})');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo limite excedido ao buscar forecast.');
    } catch (e) {
      throw Exception('Erro ao buscar forecast: $e');
    }
  }
}
