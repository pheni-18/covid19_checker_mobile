import 'package:http/http.dart' as http;
import 'constants.dart';
import 'dart:convert';
import 'prefectures.dart';

class Covid19APIClient {
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
