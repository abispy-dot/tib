// =======================================================================
// FILE: lib/ui/screens/favorites_screen.dart
// DESCRIPTION: Displays a list of the user's favorited events.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bahrain_tourism_app/models/event_model.dart';
import 'package:bahrain_tourism_app/services/firestore_service.dart';
import 'package:bahrain_tourism_app/ui/widgets/event_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Center(child: Text('Please log in to see your favorites.'));
    }

    return StreamBuilder<List<Event>>(
      stream: firestoreService.getFavoriteEventsStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('You have no favorite events yet.'));
        }

        final events = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventCard(event: events[index]);
          },
        );
      },
    );
  }
}
