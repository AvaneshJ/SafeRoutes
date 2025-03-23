import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:geolocator/geolocator.dart';
import '../models/review_model.dart';
import '../services/geocoding_service.dart';
import '../services/route_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<gmap.GoogleMapController> _mapController = Completer();
  final RouteService _routeService = RouteService();
  final GeocodingService _geocodingService = GeocodingService();
  final TextEditingController _searchController = TextEditingController();

  final List<Review> _reviews = [];
  gmap.LatLng? _currentPosition;
  gmap.LatLng? _destinationPosition;
  Map<gmap.PolylineId, gmap.Polyline> polylines = {};
  Set<gmap.Marker> _markers = {};
  bool _showReviewSheet = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final position = await _getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = gmap.LatLng(position.latitude, position.longitude);
        _markers.add(
          gmap.Marker(
            markerId: const gmap.MarkerId("currentLocation"),
            position: _currentPosition!,
            infoWindow: const gmap.InfoWindow(title: "You are here"),
          ),
        );
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _searchLocation(String query) async {
    final gmap.LatLng? position = await _geocodingService.geocode(query);
    if (position != null) {
      setState(() {
        _destinationPosition = position;
        _markers.removeWhere((m) => m.markerId.value == 'destination');
        _markers.add(
          gmap.Marker(
            markerId: const gmap.MarkerId('destination'),
            position: position,
            infoWindow: const gmap.InfoWindow(title: 'Destination'),
          ),
        );
      });

      final controller = await _mapController.future;
      controller.animateCamera(gmap.CameraUpdate.newLatLngZoom(position, 14));

      await _drawRoute();
      setState(() {
        _showReviewSheet = true; // Auto show review sheet after search
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location not found')));
    }
  }

  Future<void> _drawRoute() async {
    if (_currentPosition == null || _destinationPosition == null) return;
    final routePoints = await _routeService.getRoute(
      _currentPosition!,
      _destinationPosition!,
    );
    if (routePoints.isEmpty) return;

    setState(() {
      polylines.clear();
      polylines[gmap.PolylineId("route")] = gmap.Polyline(
        polylineId: const gmap.PolylineId("route"),
        color: Colors.blue,
        width: 6,
        points: routePoints,
      );
    });
  }

  void _addReview(Review review) {
    setState(() {
      _reviews.add(review);
    });
  }

  void _viewReviews() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Reviews"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _reviews.length,
                itemBuilder: (ctx, index) {
                  final r = _reviews[index];
                  return ListTile(
                    title: Text(r.username),
                    subtitle: Text(r.reviewText),
                    trailing: Text('${r.rating}⭐'),
                  );
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Map')),
      body: Stack(
        children: [
          gmap.GoogleMap(
            initialCameraPosition: gmap.CameraPosition(
              target:
                  _currentPosition ?? const gmap.LatLng(23.0752426, 76.863119),
              zoom: 13,
            ),
            onMapCreated: (controller) => _mapController.complete(controller),
            markers: _markers,
            polylines: Set<gmap.Polyline>.of(polylines.values),
            myLocationEnabled: true,
          ),

          // 🔍 Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search destination...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _searchLocation(_searchController.text);
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) _searchLocation(value);
                },
              ),
            ),
          ),

          // 📄 Review Sheet Auto Show
          if (_showReviewSheet)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Rate this Area',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ReviewForm(
                      onSubmit: (review) {
                        _addReview(review);
                        _viewReviews();
                        setState(() => _showReviewSheet = false);
                      },
                    ),
                    const SizedBox(height: 20), // ✅ Extra padding below Submit
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReviewForm extends StatefulWidget {
  final Function(Review) onSubmit;
  const ReviewForm({super.key, required this.onSubmit});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  double rating = 3;
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
            }
          },
          child: const Text('Submit & View Reviews'),
        ),
      ],
    );
  }
}
