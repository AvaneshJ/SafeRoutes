import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../const.dart';

class GeocodingService {
  Future<LatLng?> geocode(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$GOOGLE_MAPS_API_KEY';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'OK') {
          final location = jsonData['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
    } catch (e) {
      print("Geocoding error: $e");
    }
    return null;
  }
}
