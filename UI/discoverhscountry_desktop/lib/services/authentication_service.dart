class AuthenticationService {
  bool isLoggedIn = false;

  Future<void> login() async {
    // Simulate user login logic
    await Future.delayed(const Duration(seconds: 1));
    isLoggedIn = true;
  }

  Future<void> logout() async {
    // Simulate user logout logic
    await Future.delayed(const Duration(seconds: 1));
    isLoggedIn = false;
  }
}
