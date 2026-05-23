import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  HttpService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await _client.get(Uri.parse(url), headers: headers);
    return _handle(response);
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: _jsonHeaders(headers),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _handle(response);
  }

  Future<dynamic> put(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.put(
      Uri.parse(url),
      headers: _jsonHeaders(headers),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _handle(response);
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await _client.delete(Uri.parse(url), headers: headers);
    return _handle(response);
  }

  Map<String, String> _jsonHeaders(Map<String, String>? headers) {
    return <String, String>{
      'Content-Type': 'application/json',
      ...?headers,
    };
  }

  dynamic _handle(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw HttpException(
      statusCode: response.statusCode,
      message: response.body,
    );
  }
}

class HttpException implements Exception {
  HttpException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'HttpException($statusCode): $message';
}
