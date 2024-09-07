import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package

class WeatherController extends GetxController {
  var isLoading = false.obs;
  var weatherData = Rx<Weather>(Weather());
  var errorMessage = ''.obs;
  var location = ''.obs; // Update to store city name

  @override
  void onInit() {
    super.onInit();
    _getWeatherForCurrentLocation();
  }

  Future<void> _getWeatherForCurrentLocation() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      Position position = await _getCurrentLocation();
      String city =
          await _getCityFromPosition(position.latitude, position.longitude);
      location.value = city; // Update location to city name
      final response =
          await fetchWeatherData(position.latitude, position.longitude);
      weatherData.value = Weather.fromJson(response);
    } catch (e) {
      errorMessage.value = 'Gagal mendapatkan data cuaca: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position> _getCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      throw Exception('Izin lokasi ditolak');
    }
  }

  Future<String> _getCityFromPosition(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print('Placemark: ${placemark.toJson()}'); // Tambahkan log untuk debug
        return placemark.locality ?? 'Tidak diketahui';
      } else {
        return 'Tidak diketahui';
      }
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debug
      return 'Tidak diketahui';
    }
  }

  Future<Map<String, dynamic>> fetchWeatherData(
      double latitude, double longitude) async {
    // Implement the actual API call to fetch weather data here
    // Example dummy response
    return {
      'temperature': 25.0,
      'windSpeed': 10.0,
      'humidity': 60,
    };
  }
}

class Weather {
  final double temperature;
  final double windSpeed;
  final int humidity;

  Weather({
    this.temperature = 0.0,
    this.windSpeed = 0.0,
    this.humidity = 0,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['temperature'] ?? 0.0,
      windSpeed: json['windSpeed'] ?? 0.0,
      humidity: json['humidity'] ?? 0,
    );
  }
}
