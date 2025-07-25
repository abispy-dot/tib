// =======================================================================
// FILE: lib/models/event_model.dart
// DESCRIPTION: Defines the data structure for an Event.
// MODIFIED: Added instagramHandle field.
// =======================================================================
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final String category;
  final GeoPoint geoPoint;
  final String locationName;
  final String? instagramHandle;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.category,
    required this.geoPoint,
    required this.locationName,
    this.instagramHandle,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      imageUrl: data['imageUrl'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      category: data['category'] ?? 'General',
      geoPoint: data['location']?['geoPoint'] ?? const GeoPoint(0, 0),
      locationName: data['location']?['name'] ?? 'Unknown Location',
      instagramHandle: data['instagramHandle'],
    );
  }
}
