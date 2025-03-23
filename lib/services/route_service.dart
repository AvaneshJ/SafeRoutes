import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteService {
  final String _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  Future<Map<String, dynamic>> getRoute(
    LatLng origin,
    LatLng destination,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final polylinePoints = route['overview_polyline']['points'];
        final eta = route['legs'][0]['duration']['text'];
        final distance = route['legs'][0]['distance']['text'];
        final steps =
            route['legs'][0]['steps']
                .map<String>((step) => step['html_instructions'].toString())
                .toList();

        return {
          'polyline': _createPolyline(polylinePoints),
          'eta': eta,
          'distance': distance,
          'steps': steps,
        };
      }
    }
    throw Exception('Failed to load route');
  }

  Polyline _createPolyline(String encodedPolyline) {
    List<LatLng> points = _decodePolyline(encodedPolyline);
    return Polyline(
      polylineId: const PolylineId('route'),
      color: const Color(0xFF4285F4),
      width: 5,
      points: points,
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }
}
