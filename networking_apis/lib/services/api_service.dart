import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class ApiService {
  static Future<List<User>> fetchRandomUsers({int count = 10}) async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=$count'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
