// =======================================================================
// FILE: lib/ui/widgets/weather_display.dart
// DESCRIPTION: A widget to fetch and display weather for a given location.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bahrain_tourism_app/services/weather_service.dart';
import 'package:bahrain_tourism_app/models/weather_model.dart';

class WeatherDisplay extends StatefulWidget {
  final GeoPoint location;
  const WeatherDisplay({super.key, required this.location});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService().getWeather(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LinearProgressIndicator());
        }
        if (snapshot.hasError) {
          return InfoRow(
            icon: Icons.thermostat,
            text: 'Could not load weather data.',
          );
        }
        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Image.network(weather.iconUrl, height: 40, width: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${weather.temp.toStringAsFixed(0)}°C, ${weather.condition}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}