// =======================================================================
// NEW FILE: lib/models/tour_guide_model.dart
// DESCRIPTION: Defines the data structure for a Tour Guide.
// =======================================================================
import 'package:cloud_firestore/cloud_firestore.dart';

class TourGuide {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final List<String> languages;
  final double rating;

  TourGuide({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.languages,
    required this.rating,
  });

  factory TourGuide.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TourGuide(
      id: doc.id,
      name: data['name'] ?? 'No Name',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      languages: List<String>.from(data['languages'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}
