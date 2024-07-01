import 'package:eudaimonia_bakery/dto/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              // Add a Card for structure
              child: Padding(
                // Introduce internal padding
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      // Keep the image centered
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          // Use a Container for background color and sizing
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[300], // A light grey background
                          child: Center(
                            // Center the icon within the Container
                            child: Icon(
                              Icons.person,
                              size: 120, // Adjust for desired size
                              color: Colors
                                  .grey[700], // A darker grey for contrast
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Name: ${user.name}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${user.phoneNumber}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Address: ${user.address}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Role: ${user.role}',
                      style: const TextStyle(fontSize: 14),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date Created: ${DateFormat('MMMM dd, yyyy hh:mm:ss a').format(user.createdAt)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                    Text(
                      'Date Updated: ${DateFormat('MMMM dd, yyyy hh:mm:ss a').format(user.updatedAt)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      softWrap: true, // Enable wrapping
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
