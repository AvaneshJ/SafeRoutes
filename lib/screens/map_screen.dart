import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../services/route_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  LatLng? _destination;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController _searchController = TextEditingController();
  final RouteService _routeService = RouteService();

  String _eta = '';
  String _distance = '';
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentLocation!,
        ),
      );
    });
  }

  Future<void> _searchAndNavigate() async {
    if (_searchController.text.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(
        _searchController.text,
      );
      if (locations.isNotEmpty) {
        LatLng destination = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        setState(() {
          _destination = destination;
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: destination,
            ),
          );
        });

        final routeResult = await _routeService.getRoute(
          _currentLocation!,
          destination,
        );

        setState(() {
          _polylines.clear();
          _polylines.add(routeResult['polyline']);
          _eta = routeResult['eta'];
          _distance = routeResult['distance'];
          _steps = routeResult['steps'];
        });

        _moveCameraToFitRoute();
      }
    } catch (e) {
      print('Error searching location: $e');
    }
  }

  void _moveCameraToFitRoute() {
    if (_currentLocation != null && _destination != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _currentLocation!.latitude < _destination!.latitude
              ? _currentLocation!.latitude
              : _destination!.latitude,
          _currentLocation!.longitude < _destination!.longitude
              ? _currentLocation!.longitude
              : _destination!.longitude,
        ),
        northeast: LatLng(
          _currentLocation!.latitude > _destination!.latitude
              ? _currentLocation!.latitude
              : _destination!.latitude,
          _currentLocation!.longitude > _destination!.longitude
              ? _currentLocation!.longitude
              : _destination!.longitude,
        ),
      );

      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Map')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(20.5937, 78.9629),
              zoom: 5,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Destination',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchAndNavigate,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 10,
            right: 10,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ETA: $_eta'),
                    Text('Distance: $_distance'),
                    const SizedBox(height: 5),
                    const Text('Steps:'),
                    ..._steps
                        .map((step) => Text('- ${_parseHtmlString(step)}'))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                if (_eta.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Journey Started!")),
                  );
                }
              },
              child: const Text(
                'Start Journey',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
