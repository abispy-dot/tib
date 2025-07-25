// =======================================================================
// FILE: lib/ui/screens/event_detail_screen.dart
// DESCRIPTION: Shows the full details for a single event.
// MODIFIED: Added Instagram launch button.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bahrain_tourism_app/models/event_model.dart';
import 'package:bahrain_tourism_app/services/firestore_service.dart';
import 'package:bahrain_tourism_app/ui/widgets/weather_display.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  void _launchMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchInstagram(String handle) async {
    final isHashtag = handle.startsWith('#');
    final cleanHandle = isHashtag ? handle.substring(1) : handle;
    final url = isHashtag
        ? 'https://www.instagram.com/explore/tags/$cleanHandle/'
        : 'https://www.instagram.com/$cleanHandle/';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          if (user != null)
            StreamBuilder<List<String>>(
              stream: firestoreService.getFavoritesStream(user.uid),
              builder: (context, snapshot) {
                final isFavorite = snapshot.hasData && snapshot.data!.contains(event.id);
                return IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    firestoreService.toggleFavorite(user.uid, event.id, isFavorite);
                  },
                  tooltip: 'Favorite',
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 50)),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(event.category),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  InfoRow(
                    icon: Icons.calendar_today,
                    text: DateFormat('EEEE, MMMM d, yyyy').format(event.startDate),
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    icon: Icons.access_time,
                    text: DateFormat('h:mm a').format(event.startDate),
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    icon: Icons.location_on,
                    text: event.locationName,
                  ),
                  const SizedBox(height: 16),
                  WeatherDisplay(location: event.geoPoint),
                  const SizedBox(height: 24),
                  Text(
                    'About this event',
                     style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchMaps(event.geoPoint.latitude, event.geoPoint.longitude),
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (event.instagramHandle != null && event.instagramHandle!.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () => _launchInstagram(event.instagramHandle!),
                          icon: const Icon(Icons.camera_alt),
                          iconSize: 30,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.pink.withOpacity(0.1),
                            foregroundColor: Colors.pink,
                          ),
                          tooltip: 'View on Instagram',
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
