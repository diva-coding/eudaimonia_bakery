import 'package:eudaimonia_bakery/dto/user_model.dart';

class Login {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final User userData; // Add a field to store the User object

  Login({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.userData,
  });

  factory Login.fromJson(Map<String, dynamic> json) { 
    return Login(
      accessToken: json['access_token'] as String,
      tokenType: json['type'] as String,
      expiresIn: json['expires_in'] as int,
      userData: User.fromJson(json['user_data']), // Parse user data
    );
  }
}