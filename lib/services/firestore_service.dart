// =======================================================================
// FILE: lib/services/firestore_service.dart
// DESCRIPTION: Handles all communication with the Firebase Firestore database.
// MODIFIED: Added methods for tour guides and reservations.
// =======================================================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bahrain_tourism_app/models/event_model.dart';
import 'package:bahrain_tourism_app/models/tour_guide_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Event>> getEventsStream() {
    return _db
        .collection('events')
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromFirestore(doc))
            .toList());
  }
  
  Future<void> toggleFavorite(String userId, String eventId, bool isCurrentlyFavorite) async {
    final docRef = _db.collection('users').doc(userId).collection('favorites').doc(eventId);
    if (isCurrentlyFavorite) {
      await docRef.delete();
    } else {
      await docRef.set({'favoritedAt': FieldValue.serverTimestamp()});
    }
  }

  Stream<List<String>> getFavoritesStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
  
  Stream<List<Event>> getFavoriteEventsStream(String userId) {
    return getFavoritesStream(userId).asyncMap((favoriteIds) async {
      if (favoriteIds.isEmpty) return [];
      final eventsSnapshot = await _db.collection('events').where(FieldPath.documentId, whereIn: favoriteIds).get();
      return eventsSnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }

  Stream<List<TourGuide>> getTourGuidesStream() {
    return _db
        .collection('tour_guides')
        .where('isApproved', isEqualTo: true)
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TourGuide.fromFirestore(doc))
            .toList());
  }

  Future<void> createReservationRequest({
    required String guideId,
    required String userId,
    required DateTime requestedDate,
    required String message,
  }) {
    return _db.collection('reservations').add({
      'guideId': guideId,
      'userId': userId,
      'requestedDate': Timestamp.fromDate(requestedDate),
      'message': message,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addReview(String eventId, String comment, double rating) {
    return _db.collection('reviews').add({
      'subjectId': eventId,
      'subjectType': 'event',
      'comment': comment,
      'rating': rating,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

