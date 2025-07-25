// =======================================================================
// NEW FILE: lib/ui/widgets/tour_guide_card.dart
// DESCRIPTION: A reusable card widget to display a summary of a tour guide.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:bahrain_tourism_app/models/tour_guide_model.dart';
import 'package:bahrain_tourism_app/ui/screens/tour_guide_detail_screen.dart';

class TourGuideCard extends StatelessWidget {
  final TourGuide guide;

  const TourGuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourGuideDetailScreen(guide: guide),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(guide.profileImageUrl),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          guide.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guide.languages.join(', '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
