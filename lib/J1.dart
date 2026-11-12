
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class J1 extends StatefulWidget {
  const J1({super.key});

  @override
  State<J1> createState() => _J1();
}

class _J1 extends State<J1> {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 3)
  ));

  Future<List<dynamic>> getUser() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/'),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      return users;
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API GET'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun utilisateur trouvé'),
            );
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(user['id'].toString()),
                ),
                title: Text(user['name']),
                subtitle: Text(user['email']),
                trailing: const Icon(Icons.person),
              );
            },
          );
        },
      ),
    );
  }
}
