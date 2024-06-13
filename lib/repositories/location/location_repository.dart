import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '/models/models.dart';
import '../repositories.dart';

class LocationRepository extends BaseLocationRepository {
  final String key = 'AIzaSyD9bFg3uV7G2VnJRERM11dme55uHrSO1vw';
  final String types = 'geocode';

  static const baseUrl = 'https://maps.googleapis.com/maps/api/place';

  @override
  // ignore: avoid_renaming_method_parameters
  Future<Location> getLocation(String location) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=place_id%2Cname%2Cgeometry&input=$location&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    if (json['status'] == 'ZERO_RESULTS') {
      // No place result found, return an empty Location object
      return const Location(lat: 0, lon: 0, name: '');
    }

    var results = json['candidates'][0] as Map<String, dynamic>;

    return Location.fromJson(results);
  }
}
