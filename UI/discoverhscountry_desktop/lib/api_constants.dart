// api_constants.dart

import 'dart:io';

class ApiConstants {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    const String host = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
    const String port = String.fromEnvironment('API_PORT', defaultValue: '7125');

    return 'http://$host:$port';
  }
}
