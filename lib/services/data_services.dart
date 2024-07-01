import 'dart:convert';

import 'package:eudaimonia_bakery/dto/datas.dart';
import 'package:eudaimonia_bakery/dto/news.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:eudaimonia_bakery/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataService {
  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(Endpoints.news));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => News.fromJson(item)).toList();
    } else {
      throw Exception('Failed to Load News!');
    }
  }

  static Future<List<Datas>> fetchDatas() async {
    final response = await http.get(Uri.parse(Endpoints.datas));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Datas.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load datas');
    }
  }

  static Future<void> deleteDatas(int id) async {
    final url = Uri.parse('${Endpoints.datas}/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }

  static Future<void> sendNews(String title, String body) async {
    Map<String, String> newsData = {
      "title": title,
      "body": body,
    };
    String jsonData = jsonEncode(newsData);
    await http.post(Uri.parse(Endpoints.news),
        body: jsonData, headers: {'Content-Type': 'application/json'});
  }

  static Future<void> deleteData(String id) async {
    await http.delete(Uri.parse('${Endpoints.news}/$id'),
        headers: {'Content-type': 'application/json'});
  }

  static Future<void> updateData(String id, String title, String body) async {
    Map<String, String> data = {"id": id, "title": title, "body": body};
    String jsonData = jsonEncode(data);
    await http.put(Uri.parse('${Endpoints.news}/$id'),
        body: jsonData, headers: {'Content-type': 'application/json'});
  }

  // * post login with email and password
  static Future<http.Response> sendLoginData(String email, String password) async {
    final url = Uri.parse(Endpoints.login);
    //final data = {'name': name, 'password': password};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'email=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(password)}',
    );

    return response;
  }

  // * post Register Data
  static Future<http.Response> sendRegisterData(
    String email,
    String name, 
    String phoneNumber,
    String address,
    String password,
  ) async {
    final url = Uri.parse(Endpoints.register);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'email=${Uri.encodeComponent(email)}'
            '&name=${Uri.encodeComponent(name)}'
            '&phone_number=${Uri.encodeComponent(phoneNumber)}'
            '&address=${Uri.encodeComponent(address)}' 
            '&password=${Uri.encodeComponent(password)}'
            // * default role is 'user'
            '&role=${Uri.encodeComponent('user')}',
    );

    return response;
  }

  // * logout
  
  static Future<http.Response> logoutData() async {
    final url = Uri.parse(Endpoints.logout);
    final String? accessToken =
      await SecureStorageUtil.storage.read(key: tokenStoreName);
    debugPrint("logout with $accessToken");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', 
      }
    );

    return response;
  }


  Future<void> sendPasswordResetEmail(String email) async {
    final response = await http.post(
      Uri.parse(Endpoints.forgetPass),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send password reset email');
    }
  }

  Future<bool> validateResetToken(String email, String token) async {
    final response = await http.post(
      Uri.parse(Endpoints.validateResetToken),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'token': token,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['msg']);
    }
  }

  Future<void> resetPassword(String email, String token, String newPassword) async {
    final response = await http.post(
      Uri.parse(Endpoints.resetPass),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'token': token,
        'password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['msg']);
    }
  }
}