// =======================================================================
// NEW FILE: lib/ui/screens/tour_guide_list_screen.dart
// DESCRIPTION: Displays a list of available tour guides.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bahrain_tourism_app/models/tour_guide_model.dart';
import 'package:bahrain_tourism_app/services/firestore_service.dart';
import 'package:bahrain_tourism_app/ui/widgets/tour_guide_card.dart';

class TourGuideListScreen extends StatelessWidget {
  const TourGuideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return StreamBuilder<List<TourGuide>>(
      stream: firestoreService.getTourGuidesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tour guides available at the moment.'));
        }

        final guides = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: guides.length,
          itemBuilder: (context, index) {
            return TourGuideCard(guide: guides[index]);
          },
        );
      },
    );
  }
}