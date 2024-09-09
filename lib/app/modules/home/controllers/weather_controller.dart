import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package
import '../../../data/models/weather_model.dart';
import '../../../services/api_services.dart'; // Adjust the import path as necessary

class WeatherController extends GetxController {
  var isLoading = false.obs;
  var weatherData =
      WeatherModel(temperature: 0.0, windSpeed: 0.0, humidity: 0).obs;
  var errorMessage = ''.obs;
  var location = ''.obs; // Store city name

  @override
  void onInit() {
    super.onInit();
    _getWeatherForCurrentLocation();
  }

  Future<void> _getWeatherForCurrentLocation() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Ambil posisi (latitude dan longitude)
      Position position = await _getCurrentLocation();

      // Konversi latitude dan longitude menjadi nama kota
      String city =
          await _getCityFromPosition(position.latitude, position.longitude);
      location.value = city; // Update nama lokasi dengan nama kota

      // Ambil data cuaca berdasarkan lokasi
      WeatherModel weather = await ApiService.fetchWeatherData();
      weatherData.value = weather;
    } catch (e) {
      // Log error dan tampilkan pesan error
      print('Error fetching weather data: $e');
      errorMessage.value = 'Gagal mendapatkan data cuaca: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position> _getCurrentLocation() async {
    // Minta izin lokasi
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      // Ambil lokasi jika izin diberikan
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      // Lempar exception jika izin ditolak
      throw Exception('Izin lokasi ditolak');
    }
  }

  Future<String> _getCityFromPosition(double latitude, double longitude) async {
    try {
      // Ambil daftar placemarks berdasarkan latitude dan longitude
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        print('Placemark: ${placemark.toJson()}'); // Debug log
        // Return nama kota
        return placemark.locality ?? 'Tidak diketahui';
      } else {
        return 'Tidak diketahui';
      }
    } catch (e) {
      print('Error: $e'); // Debug log
      return 'Tidak diketahui';
    }
  }
}
