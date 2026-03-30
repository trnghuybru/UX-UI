/// Model cho data/2.5/weather
class CurrentWeatherModel {
  final String cityName;
  final String country;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int clouds;
  final int visibility;
  final int sunrise;
  final int sunset;
  final String icon;
  final String description;
  final double? rain1h;

  CurrentWeatherModel({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.clouds,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.description,
    this.rain1h,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List)[0] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final clouds = json['clouds'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;
    final rain = json['rain'] as Map<String, dynamic>?;

    return CurrentWeatherModel(
      cityName: json['name'] ?? 'Vị trí của bạn',
      country: sys['country'] ?? '',
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: main['humidity'] as int,
      pressure: main['pressure'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      clouds: clouds['all'] as int,
      visibility: json['visibility'] as int? ?? 10000,
      sunrise: sys['sunrise'] as int,
      sunset: sys['sunset'] as int,
      icon: weather['icon'] as String,
      description: weather['description'] as String,
      rain1h: rain != null ? (rain['1h'] as num?)?.toDouble() : null,
    );
  }

  CurrentWeatherModel copyWith({String? cityName}) {
    return CurrentWeatherModel(
      cityName: cityName ?? this.cityName,
      country: country,
      temp: temp,
      feelsLike: feelsLike,
      tempMin: tempMin,
      tempMax: tempMax,
      humidity: humidity,
      pressure: pressure,
      windSpeed: windSpeed,
      clouds: clouds,
      visibility: visibility,
      sunrise: sunrise,
      sunset: sunset,
      icon: icon,
      description: description,
      rain1h: rain1h,
    );
  }
}

/// Model cho từng item trong data/2.5/forecast
class ForecastDayModel {
  final DateTime dateTime;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;

  ForecastDayModel({
    required this.dateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List)[0] as Map<String, dynamic>;
    return ForecastDayModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (main['temp'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      icon: weather['icon'] as String,
      description: weather['description'] as String,
    );
  }
}
