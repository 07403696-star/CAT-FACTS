import 'dart:convert';
import 'package:http/http.dart' as http;
import 'catfact.dart';

// SERVICE: all network calls live here.
// API used: https://catfact.ninja  (free, no API key)
class ApiService {
  static const String _base = 'https://catfact.ninja';
  static const Duration _timeout = Duration(seconds: 10);

  // Screen 1: get a LIST of facts (called once).
  Future<List<CatFact>> fetchFacts() async {
    final response = await http
        .get(Uri.parse('$_base/facts?limit=10'))
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>;
    return list
        .map((item) => CatFact.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Screen 2: get ONE random fact (a new one each time).
  Future<CatFact> fetchRandomFact() async {
    final response = await http.get(Uri.parse('$_base/fact')).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    return CatFact.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
