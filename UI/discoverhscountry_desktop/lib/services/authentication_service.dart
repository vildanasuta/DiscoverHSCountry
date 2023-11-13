import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  bool isLoggedIn = false;
  // ignore: prefer_const_constructors
  final storage = FlutterSecureStorage();
  Future<void> login(String? token) async {
    // Simulate user login logic
    await Future.delayed(const Duration(seconds: 1));
    isLoggedIn = true;
    storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    // Simulate user logout logic
    await Future.delayed(const Duration(seconds: 1));
    isLoggedIn = false;
  }
}
