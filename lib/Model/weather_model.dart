class WeatherData {
  final String name;
  final Temperature temperature;

  final int humidity;
  final Wind wind;
  final double maxTemperature;
  final double minTemperature;
  final int pressure;
  final int seaLevel;
  final List<WeatherInfo> weather;
  

  WeatherData({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.pressure,
    required this.seaLevel,
    required this.weather,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      name: json['name'],
     temperature: Temperature.fromJson(json['main']['temp']),
      humidity: json['main']['humidity'],
      wind: Wind.fromJson(json['wind']),
      maxTemperature: (json['main']['temp_max']?.toDouble() ?? 0.0),
      minTemperature: (json['main']['temp_min']?.toDouble() ?? 0.0),
      pressure: json['main']['pressure'],
      seaLevel: json['main']['sea_level'] ?? 0,
      weather: List<WeatherInfo>.from(
        json['weather'].map(
          (weather) => WeatherInfo.fromJson(weather),
        ),
      ),
    );
  }
}

class WeatherInfo {
  final String main;
  final String? icon;

  WeatherInfo({
    required this.main,
    this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      main: json['main'],
      icon: json['icon'],
    );
  }
}

class Temperature {
  final double current;

  Temperature({required this.current});

  factory Temperature.fromJson(dynamic json) {
   
    double value;
    if (json is num) {
      value = json.toDouble();
    } else {
      value = double.tryParse(json.toString()) ?? 0.0;
    }
    return Temperature(current: value);
  }
}

class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    final s = json['speed'];
    return Wind(speed: (s is num) ? s.toDouble() : double.tryParse(s.toString()) ?? 0.0);
  }
}

class ForecastData {
  final String cityName;
  final List<ForecastItem> list;

  ForecastData({required this.cityName, required this.list});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      cityName: json['city'] != null ? json['city']['name'] ?? '' : '',
      list: List<ForecastItem>.from(
        (json['list'] as List<dynamic>).map(
          (item) => ForecastItem.fromJson(item as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class ForecastItem {
  final DateTime dateTime;
  final Temperature temperature;
  final int humidity;
  final int pressure;
  final Wind wind;
  final List<WeatherInfo> weather;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.wind,
    required this.weather,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.parse(json['dt_txt'] ?? DateTime.now().toIso8601String()),
      temperature: Temperature.fromJson(json['main']['temp']),
      humidity: json['main']['humidity'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,
      wind: Wind.fromJson(json['wind'] ?? {'speed': 0.0}),
      weather: (json['weather'] as List<dynamic>?)
              ?.map((w) => WeatherInfo.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}