// api_constants.dart

class ApiConstants {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    final String host = '192.168.31.123';
    final String port = '7125';
    return 'http://$host:$port';
  }
}
