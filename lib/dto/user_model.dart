import 'package:intl/intl.dart';

class User {
  final int userId;
  final String name;
  final String email;
  final String? role;
  final String phoneNumber;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    this.role,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      createdAt: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['created_at'] as String),
      updatedAt: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
         ? null
          : DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(json['deleted_at'] as String),
    );
  }
      

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'role': role,
      'created_at': DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(createdAt),
      'updated_at': DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(updatedAt),
      'deleted_at': deletedAt != null 
                    ? DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(deletedAt!) 
                    : null,
    };
  }
}
