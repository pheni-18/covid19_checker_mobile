import 'package:http/http.dart' as http;
import 'dart:convert';
import 'prefectures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Covid19APIClient {
  final String apiURL = env['API_URL'];

  Future<List<Prefecture>> getAll(String date) async {
    final String url = '$apiURL/all';
    http.Response response = await http.get('$url?date=$date');
    if (response.statusCode != 200) {
      print('API error!');
      return [];
    }
    List<Prefecture> prefectures = [];
    for (var prefecture in json.decode(utf8.decode(response.bodyBytes))) {
      prefectures.add(Prefecture.fromJson(prefecture));
    }

    return prefectures;
  }
}
