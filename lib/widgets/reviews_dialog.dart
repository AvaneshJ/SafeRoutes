import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewDialog extends StatelessWidget {
  final List<Review> reviews;

  const ReviewDialog({required this.reviews, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reviews'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ListTile(
              title: Text(review.username),
              subtitle: Text(review.reviewText),
              trailing: Text('${review.rating}/5'),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
