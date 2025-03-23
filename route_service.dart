import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:http/http.dart' as http;
import 'package:safety_app/const.dart';

class RouteService {
  Future<List<gmap.LatLng>> getRoute(gmap.LatLng start, gmap.LatLng end) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$GOOGLE_MAPS_API_KEY';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final points = _decodePolyline(
        data['routes'][0]['overview_polyline']['points'],
      );
      return points;
    } else {
      print("Route fetch error: ${data['status']}");
      return [];
    }
  }

  List<gmap.LatLng> _decodePolyline(String encoded) {
    List<gmap.LatLng> polylinePoints = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylinePoints.add(gmap.LatLng(lat / 1E5, lng / 1E5));
    }
    return polylinePoints;
  }
}
