import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const.dart'; 

class PlaceService {
  Future<List<String>> fetchSuggestions(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&components=country:in&key=$GOOGLE_MAPS_API_KEY';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'OK') {
          return (jsonData['predictions'] as List)
              .map((p) => p['description'] as String)
              .toList();
        } else {
          print("Places API Error: ${jsonData['status']}");
          return [];
        }
      } else {
        print('Failed to fetch suggestions');
        return [];
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }
}
