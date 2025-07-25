// =======================================================================
// FILE: lib/models/weather_model.dart
// DESCRIPTION: Defines the data structure for Weather data from the API.
// =======================================================================
class Weather {
  final String condition;
  final String description;
  final double temp;
  final String iconCode;

  Weather({
    required this.condition,
    required this.description,
    required this.temp,
    required this.iconCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temp: json['main']['temp'].toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
