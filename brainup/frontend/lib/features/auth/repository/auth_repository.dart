import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_config.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/$role/login',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Login gagal',
      );
    }

    return data;
  }
}
