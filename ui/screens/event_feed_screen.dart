// =======================================================================
// FILE: lib/ui/screens/event_feed_screen.dart
// DESCRIPTION: Displays a real-time list of event cards.
// MODIFIED: No changes.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bahrain_tourism_app/models/event_model.dart';
import 'package:bahrain_tourism_app/services/firestore_service.dart';
import 'package:bahrain_tourism_app/ui/widgets/event_card.dart';

class EventFeedScreen extends StatelessWidget {
  const EventFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return StreamBuilder<List<Event>>(
      stream: firestoreService.getEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No events found.'));
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
