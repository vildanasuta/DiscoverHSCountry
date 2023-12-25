// api_constants.dart

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    final String host = Platform.environment['API_HOST']??'localhost';
    final String port = Platform.environment['API_PORT']??'7125';
    return 'http://$host:$port';
  }
}
