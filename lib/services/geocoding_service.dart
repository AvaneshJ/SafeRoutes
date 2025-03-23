import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:safety_app/const.dart';

class GeocodingService {
  /// Geocode a place name or address and return LatLng coordinates
  Future<gmap.LatLng?> geocode(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$GOOGLE_MAPS_API_KEY';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return gmap.LatLng(location['lat'], location['lng']);
        } else {
          print('No geocoding results found for $address');
          return null;
        }
      } else {
        print('Geocoding API failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during geocoding: $e');
      return null;
    }
  }
}
