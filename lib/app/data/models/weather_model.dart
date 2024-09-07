class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int humidity;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temperature'] as double,
      windSpeed: json['windSpeed'] as double,
      humidity: json['humidity'] as int,
    );
  }
}
