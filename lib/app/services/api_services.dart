import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/weather_model.dart';

class ApiService {
  static const String apiKey =
      'rW5no9oD4y6fMyz2LF6PP1kKy4XD8OxG'; // Masukkan API key Anda
  static const String baseUrl = 'https://api.tomorrow.io/v4/weather/forecast';

  static Future<WeatherModel> fetchWeatherData(String location) async {
    final url = '$baseUrl?location=$location&apikey=$apiKey&timesteps=current';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel(
        temperature: data['data']['timelines'][0]['intervals'][0]['values']
            ['temperature'],
        windSpeed: data['data']['timelines'][0]['intervals'][0]['values']
            ['windSpeed'],
        humidity: data['data']['timelines'][0]['intervals'][0]['values']
            ['humidity'],
      );
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }
}
