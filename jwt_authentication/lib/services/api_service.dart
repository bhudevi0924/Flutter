import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_authentication/model/candidate.dart';
import 'package:jwt_authentication/model/jwt_response.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8998/compass';

  static Future<JwtResponse> saveCandidate(Candidate candidate) async {
    final url = Uri.parse('$_baseUrl/api/auth/saveCandidate/true');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', 
      },
      body: json.encode(candidate.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("data $data");
      print("converted ${JwtResponse.fromJson(data)}");
      return JwtResponse.fromJson(data);
    } else {
      throw Exception('Failed to save candidate: ${response.body}');
    }
  }
}
