import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewBottomSheet extends StatefulWidget {
  final Function(Review) onSubmit;

  const ReviewBottomSheet({super.key, required this.onSubmit});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  double rating = 3;
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rate this Area', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: "${rating.round()} Stars",
              onChanged: (value) => setState(() => rating = value),
            ),
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (usernameController.text.isNotEmpty &&
                    reviewController.text.isNotEmpty) {
                  widget.onSubmit(
                    Review(
                      username: usernameController.text,
                      reviewText: reviewController.text,
                      rating: rating.round(),
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Submit & View Reviews'),
            ),
            const SizedBox(height: 20), // Padding below the submit button
          ],
        ),
      ),
    );
  }
}
