import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiData {
  final queryParameters = {
    'category': 'movies',
    'language': 'kannada',
    'genre': 'all',
    'sort_by': 'voting',
  };

  // post data to url and get response
  Future<String> getMovie() async {
    var response = await http.post(
        Uri.parse('https://hoblist.com/api/movieList'),
        body: queryParameters);
    // return response
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var jsonData = data["result"];
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
