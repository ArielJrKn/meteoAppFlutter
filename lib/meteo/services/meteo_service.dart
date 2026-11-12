import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/meteo.dart';
import 'package:http/http.dart' as http;

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.open-meteo.com/v1/forecast',
  connectTimeout: const Duration(seconds: 5),
));

final dio1 = Dio(BaseOptions(
  baseUrl: 'https://geocoding-api.open-meteo.com/v1/search',
  connectTimeout: const Duration(seconds: 5),
));

/// Renvoie (latitude, longitude) pour une ville donnée.
/// Géocode la ville puis récupère sa météo.
Future<Meteo> recupererMeteoParVille(String nom) async {
  // 1) Géocodage
  final res = await dio1.get(
    '',
    queryParameters: {
      'name': nom,
      'count': 1,
      'language': 'fr',
      'format': 'json',
    },
  );

  final results = res.data['results'] as List?;
  if (results == null || results.isEmpty) {
    throw Exception('Ville introuvable : $nom');
  }

  final ville = results.first as Map<String, dynamic>;
  final lat = (ville['latitude'] as num).toDouble();
  final lon = (ville['longitude'] as num).toDouble();

  // 2) Météo
  return recupererMeteo(lat, lon);
}

Future<Meteo> recupererMeteo(double latitude, double longitude) async {
  final response = await dio.get(
    '',
    queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'current_weather': true,
    },
  );
  return Meteo.fromJson(response.data as Map<String, dynamic>);
}