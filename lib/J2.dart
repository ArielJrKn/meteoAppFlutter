import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class J2 extends StatefulWidget{
  @override
  State<J2> createState() => _J2();
}

class _J2 extends State<J2> {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  Future<void> SendPost(String titre, String content) async{
    final response = await dio.post('/posts',
      data: {
        'titre': titre,
        'content': content,
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Envoi réussi !"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'envoi"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
 bool isLoading = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              isLoading ? null : () async {
                setState(() {
                  isLoading = true;
                });
                await SendPost('titre envoye', 'contenu envoye');
                setState(() {
                  isLoading = false;
                });
              };

          }, child: isLoading ? CircularProgressIndicator.adaptive() : Text('Envoyer')
        ),
      )
    );
  }
}