// =======================================================================
// NEW FILE: lib/ui/screens/tour_guide_detail_screen.dart
// DESCRIPTION: Displays the profile and details of a tour guide.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bahrain_tourism_app/models/tour_guide_model.dart';
import 'package:bahrain_tourism_app/services/firestore_service.dart';
import 'package:intl/intl.dart';

class TourGuideDetailScreen extends StatelessWidget {
  final TourGuide guide;

  const TourGuideDetailScreen({super.key, required this.guide});
  
  void _showReservationDialog(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final user = Provider.of<User?>(context, listen: false);
    final messageController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Request to Book ${guide.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select your desired date and send a message to inquire about availability.'),
              const SizedBox(height: 20),
              Text('Date: ${DateFormat.yMMMd().format(selectedDate)}'),
              ElevatedButton(
                child: const Text('Change Date'),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Your Message',
                  hintText: 'e.g., Number of people, preferred time',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Send Request'),
            onPressed: () {
              if (user != null && messageController.text.isNotEmpty) {
                firestoreService.createReservationRequest(
                  guideId: guide.id,
                  userId: user.uid,
                  requestedDate: selectedDate,
                  message: messageController.text,
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reservation request sent! The guide will contact you to confirm.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(guide.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              guide.profileImageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guide.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(guide.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('About', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(guide.bio, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
                  const SizedBox(height: 16),
                  Text('Languages', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: guide.languages.map((lang) => Chip(label: Text(lang))).toList(),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _showReservationDialog(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Request to Book'),
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
