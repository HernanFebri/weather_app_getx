import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl package

import '../../../../constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../controllers/weather_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final WeatherController weatherController = Get.put(WeatherController());

  // Function to get formatted date (only day and month)
  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('d MMMM').format(now); // Updated format
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF47BFDF),
                  Color(0xFF4A91FF),
                ],
              ),
            ),
          ),
          // Top-left image
          Positioned(
            top: 130,
            left: 0,
            child: Image.asset(
              'assets/images/garis1.png',
            ),
          ),
          // Top-right image
          Positioned(
            right: 0,
            child: Image.asset(
              'assets/images/garis2.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                    height:
                        50), // Increased height to avoid overlap with images
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    Obx(() {
                      return Text(
                        weatherController.location.value,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    const Icon(Icons.notifications, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 100),
                Expanded(
                  child: Obx(() {
                    if (weatherController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (weatherController.errorMessage.isNotEmpty) {
                      return Center(
                          child:
                              Text('Error: ${weatherController.errorMessage}'));
                    } else {
                      final weather = weatherController.weatherData.value;
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Today, ${getCurrentDate()}', // Updated date display
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${weather.temperature}°',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Cloudy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(Icons.air,
                                          color: Colors.white),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Wind',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${weather.windSpeed} km/h',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(Icons.water_drop,
                                          color: Colors.white),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Hum',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${weather.humidity} %',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to weather details
                  },
                  child: const Text(
                    "Weather Details >",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.buttonBackgroundColor,
                      foregroundColor: AppColors.buttonTextColor),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
