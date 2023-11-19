// api_constants.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    final String host = dotenv.env['API_HOST']??'localhost';
    final String port = dotenv.env['API_PORT']??'7125';
    return 'http://$host:$port';
  }
}
