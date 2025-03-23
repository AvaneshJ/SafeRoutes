// Add to state class
final FirebaseService _firebaseService = FirebaseService();
double _currentRating = 3.0;
final TextEditingController _reviewController = TextEditingController();

// Modify submit button
ElevatedButton(
  onPressed: () async {
    final position = await Geolocator.getCurrentPosition();
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      await _firebaseService.submitSafetyReview(
        reviewText: _reviewController.text,
        rating: _currentRating,
        position: position,
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
      );
      Navigator.of(context).pop();
    }
  },
  child: Text('Submit Safety Report'),
)