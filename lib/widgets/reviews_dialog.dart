import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewDialog extends StatelessWidget {
  final List<Review> reviews;

  const ReviewDialog({super.key, required this.reviews});

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
              leading: CircleAvatar(child: Text('${review.rating}⭐')),
              title: Text(review.review),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
