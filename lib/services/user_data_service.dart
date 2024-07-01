import 'dart:convert';

import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class UserDataService {
  // Replace with your API base URL
// ! USER SECTION
  // * get User
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('${Endpoints.users}/read'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

    static Future<http.Response> getUserByToken(String accessToken) async {
    try {
      final headers = {'Authorization': 'Bearer $accessToken'}; // Assuming bearer token authentication
      final response = await http.get(
        Uri.parse('${Endpoints.baseAPI}/users/me'), // Adjust the endpoint as needed
        headers: headers,
      );
      return response;
    } catch (e) {
      // Handle errors appropriately (e.g., network errors, authentication errors)
      rethrow;
    }
  }
}
