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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Rate this Area', style: TextStyle(fontSize: 18)),
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
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              widget.onSubmit(
                Review(rating: rating.round(), review: reviewController.text),
              );
              Navigator.pop(context);
            },
            child: const Text('Submit & View Reviews'),
          ),
        ],
      ),
    );
  }
}
