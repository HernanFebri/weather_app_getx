import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../data/models/weather_model.dart'; // Adjust import path as necessary

class ApiService {
  static const String apiKey =
      'rW5no9oD4y6fMyz2LF6PP1kKy4XD8OxG'; // Ganti dengan API key Tomorrow.io Anda
  static const String baseUrl = 'https://api.tomorrow.io/v4/timelines';

  /// Fungsi untuk mengambil data cuaca berdasarkan lokasi perangkat
  static Future<WeatherModel> fetchWeatherData() async {
    try {
      // Mendapatkan posisi perangkat (latitude dan longitude)
      Position position = await _determinePosition();

      // URL untuk request ke API Tomorrow.io
      final url =
          '$baseUrl?location=${position.latitude},${position.longitude}&fields=temperature,windSpeed,humidity&timesteps=1h&units=metric&apikey=$apiKey';

      // Mengirim request GET ke API
      final response = await http.get(Uri.parse(url));

      // Debugging untuk melihat URL dan respons dari API
      print('Request URL: $url');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Jika respons berhasil (status code 200)
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Mengakses data cuaca dari respons API
        final timelines = data['data']['timelines']?[0]['intervals'] ?? [];
        if (timelines.isNotEmpty) {
          final firstInterval = timelines[0]['values'] ?? {};

          // Mengembalikan objek WeatherModel dengan data cuaca yang diambil
          return WeatherModel(
            temperature: firstInterval['temperature']?.toDouble() ?? 0.0,
            windSpeed: firstInterval['windSpeed']?.toDouble() ?? 0.0,
            humidity: firstInterval['humidity']?.toInt() ?? 0,
          );
        } else {
          // Jika tidak ada data yang tersedia
          throw Exception('No data available in the response.');
        }
      } else {
        // Jika status code bukan 200, lemparkan error
        throw Exception(
            'Failed to load weather data: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      // Menangkap semua error dan mengembalikan WeatherModel dengan nilai default
      print('Error: $e');
      return WeatherModel(
        temperature: 0.0,
        windSpeed: 0.0,
        humidity: 0,
      );
    }
  }

  /// Fungsi untuk mendapatkan posisi perangkat (latitude & longitude)
  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi di perangkat aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Cek apakah aplikasi memiliki izin untuk mengakses lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Mengambil posisi saat ini dengan akurasi tinggi
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
