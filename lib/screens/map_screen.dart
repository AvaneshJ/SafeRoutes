import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:geolocator/geolocator.dart';
import '../models/review_model.dart';
import '../services/geocoding_service.dart';
import '../services/route_service.dart';
import '../widgets/review_bottom_sheet.dart';
import '../widgets/reviews_dialog.dart';

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

  gmap.LatLng? _currentPosition;
  gmap.LatLng? _destinationPosition;
  Map<gmap.PolylineId, gmap.Polyline> polylines = {};
  final Set<gmap.Marker> _markers = {};
  List<Review> reviews = [];
  bool _showReviewButton = false;

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
          permission == LocationPermission.deniedForever)
        return null;
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
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location not found')));
    }
  }

  double _calculateAverageRating() {
    if (reviews.isEmpty) return 0;
    double total = reviews.fold(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  Color _getPolylineColor(double avgRating) {
    if (avgRating >= 4) return Colors.green;
    if (avgRating >= 2.5) return Colors.yellow;
    if (avgRating >= 1 && avgRating <= 2) return Colors.red;
    return Colors.blue;
  }

  Future<void> _drawRouteWithSafety() async {
    if (_currentPosition == null || _destinationPosition == null) return;

    final routePoints = await _routeService.getRoute(
      _currentPosition!,
      _destinationPosition!,
    );
    if (routePoints.isEmpty) return;

    double avgRating = _calculateAverageRating();
    Color routeColor = _getPolylineColor(avgRating);

    debugPrint("Average Safety Rating: $avgRating");
    debugPrint(
      "Initial Route Color: ${avgRating >= 1 && avgRating <= 2 ? "Red (Unsafe)" : "Final Safety Color"}",
    );

    // Show red route only if avgRating is between 1-2, else show default color
    setState(() {
      polylines.clear();
      polylines[gmap.PolylineId("route")] = gmap.Polyline(
        polylineId: const gmap.PolylineId("route"),
        color: (avgRating >= 1 && avgRating <= 2) ? Colors.red : routeColor,
        width: 6,
        points: routePoints,
      );
    });

    if (avgRating >= 1 && avgRating <= 2) {
      await Future.delayed(const Duration(seconds: 3));

      // Change to safety-based color
      setState(() {
        polylines[gmap.PolylineId("route")] = gmap.Polyline(
          polylineId: const gmap.PolylineId("route"),
          color: routeColor,
          width: 6,
          points: routePoints,
        );
      });
    }

    setState(() {
      _showReviewButton = true;
    });
  }

  Future<void> _handleGetDirections() async {
    final position = await _getCurrentLocation();
    if (position == null) {
      await Geolocator.openLocationSettings();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enable GPS')));
      return;
    }
    setState(
      () =>
          _currentPosition = gmap.LatLng(position.latitude, position.longitude),
    );

    _drawRouteWithSafety();
  }

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ReviewBottomSheet(
          onSubmit: (review) {
            setState(() {
              reviews.add(review);
              _showReviewButton = false;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Review Submitted!")));
          },
        );
      },
    );
  }

  void _showReviewsDialog() {
    showDialog(
      context: context,
      builder: (context) => ReviewDialog(reviews: reviews),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.reviews),
            onPressed: () {
              if (reviews.isNotEmpty) {
                _showReviewsDialog();
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('No reviews yet')));
              }
            },
          ),
        ],
      ),
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
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('Get Direction'),
                  onPressed:
                      _destinationPosition != null
                          ? _handleGetDirections
                          : null,
                ),
                if (_showReviewButton)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.rate_review),
                    label: const Text('Submit Review'),
                    onPressed: _showReviewBottomSheet,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
