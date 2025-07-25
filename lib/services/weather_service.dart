// =======================================================================
// FILE: lib/services/weather_service.dart
// DESCRIPTION: Handles API calls to the OpenWeatherMap service.
// =======================================================================
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bahrain_tourism_app/models/weather_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherService {
  static const String _apiKey = 'b9d4fa64f86195a92969f0f6f3da72a1';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(GeoPoint location) async {
    final lat = location.latitude;
    final lon = location.longitude;
    final url = '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to weather service');
    }
  }
}
