import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Base URL for Tranquility API (Vercel). Override at build/run time:
/// `flutter run --dart-define=TRANQUILITY_API_URL=https://your-deployment.vercel.app`
class TranquilityApi {
  TranquilityApi._();

  static const String _defaultBase = 'https://tranquility-hydrotherapy.vercel.app';

  static String get baseUrl {
    const String fromEnv = String.fromEnvironment('TRANQUILITY_API_URL');
    if (fromEnv.isNotEmpty) return fromEnv.replaceAll(RegExp(r'/$'), '');
    return _defaultBase;
  }

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<void> submitAppointment({
    required String name,
    required String phone,
    required String email,
    required DateTime visitAt,
    String source = 'app',
  }) async {
    final http.Response res = await http
        .post(
          _uri('/api/appointments'),
          headers: const <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'name': name,
            'phone': phone,
            'email': email,
            'visitAt': visitAt.toUtc().toIso8601String(),
            'source': source,
          }),
        )
        .timeout(const Duration(seconds: 25));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint('TranquilityApi.submitAppointment ${res.statusCode} ${res.body}');
      throw TranquilityApiException('Could not save appointment (${res.statusCode})');
    }
  }

  static Future<void> submitConsultation({
    required String kind,
    required Map<String, dynamic> payload,
    String source = 'app',
  }) async {
    final http.Response res = await http
        .post(
          _uri('/api/consultations'),
          headers: const <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'kind': kind,
            'payload': payload,
            'source': source,
          }),
        )
        .timeout(const Duration(seconds: 25));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint('TranquilityApi.submitConsultation ${res.statusCode} ${res.body}');
      throw TranquilityApiException('Could not save consultation (${res.statusCode})');
    }
  }
}

class TranquilityApiException implements Exception {
  TranquilityApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
