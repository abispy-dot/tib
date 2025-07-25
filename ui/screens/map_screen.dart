// =======================================================================
// FILE: lib/ui/screens/map_screen.dart
// DESCRIPTION: Displays all events on an interactive Google Map.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bahrain_tourism_app/models/event_model.dart';
import 'package:bahrain_tourism_app/services/firestore_service.dart';
import 'package:bahrain_tourism_app/ui/screens/event_detail_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(26.0667, 50.5577),
    zoom: 10.5,
  );

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return StreamBuilder<List<Event>>(
      stream: firestoreService.getEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Loading map data...'));
        }

        final events = snapshot.data!;
        final Set<Marker> markers = events.map((event) {
          return Marker(
            markerId: MarkerId(event.id),
            position: LatLng(event.geoPoint.latitude, event.geoPoint.longitude),
            infoWindow: InfoWindow(
              title: event.title,
              snippet: event.locationName,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  ),
                );
              },
            ),
          );
        }).toSet();

        return GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: markers,
        );
      },
    );
  }
}
