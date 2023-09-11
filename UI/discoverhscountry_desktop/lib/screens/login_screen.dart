import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/models/login_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/screens/registration_screen.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService authService = AuthenticationService();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  // ignore: prefer_final_fields
  TextEditingController _emailController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0054A6), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Card(
                      color: Colors.white,
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Prijavi se',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0054A6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FormBuilder(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  FormBuilderTextField(
                                    name: 'email',
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(CupertinoIcons.mail),
                                    ),
                                    controller: _emailController,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText: 'Ovo polje je obavezno!'),
                                      FormBuilderValidators.email(
                                          errorText:
                                              'Email mora biti u formatu: primjer@primjer.com.'),
                                    ]),
                                  ),
                                  const SizedBox(height: 16),
                                  FormBuilderTextField(
                                    name: 'password',
                                    decoration: const InputDecoration(
                                      labelText: 'Lozinka',
                                      prefixIcon: Icon(CupertinoIcons.lock),
                                    ),
                                    controller: _passwordController,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText: 'Ovo polje je obavezno!'),
                                    ]),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var loginModel = LoginModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    deviceType: 'desktop',
                                  );
                                  var url = Uri.parse(
                                      '${ApiConstants.baseUrl}/User/login');
                                  var response = await http.post(
                                    url,
                                    headers: {
                                      'Content-Type': 'application/json',
                                    },
                                    body: jsonEncode(loginModel.toJson()),
                                  );
                                  if (response.statusCode == 200) {
                                    // Parse the response body as JSON
                                    Map<String, dynamic> responseBody =
                                        json.decode(response.body);
                                    // Extract the UserType field
                                    String? userType = responseBody['userType'];
                                    if (userType != null) {
                                      int userId = responseBody['userId'];
                                      var getUserUrl = Uri.parse(
                                          '${ApiConstants.baseUrl}/User/$userId');
                                      var userResponse =
                                          await http.get(getUserUrl);
                                      User? user;
                                      if (userResponse.statusCode == 200) {
                                        Map<String, dynamic> userBody =
                                            json.decode(userResponse.body);
                                        user = User(
                                          userId: userBody['userId'],
                                          firstName: userBody['firstName'],
                                          lastName: userBody['lastName'],
                                          profileImage:
                                              userBody['profileImage'] ?? '',
                                          email: userBody['email'] ?? '',
                                        );
                                      }
                                      if (userType ==
                                          'touristattractionowner') {
                                        await authService
                                            .login(); // Update isLoggedIn status
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardTouristAttractionOwner(
                                              user: user, userType: userType
                                            ),
                                          ),
                                        );
                                      } else if (userType == "administrator") {
                                        await authService
                                            .login(); // Update isLoggedIn status
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DashboardAdmin(user: user, userType: userType),
                                        ));
                                      }
                                    } else {
                                      // ignore: avoid_print
                                      print(
                                          'User type not provided in the response.');
                                    }
                                  } else {
                                    // ignore: avoid_print
                                    print(response.body);
                                    if (response.body == "User not found.") {
                                      // ignore: use_build_context_synchronously
                                      Flushbar(
                                        message: "Korisnik nije pronađen.",
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 3),
                                      ).show(context);
                                    }
                                    else if(response.body=="Invalid password."){
                                      // ignore: use_build_context_synchronously
                                      Flushbar(
                                        message: "Netačna lozinka. Pokušajte ponovo!",
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 3),
                                      ).show(context);
                                    }
                                  }
                                }
                              },
                              child: const Text('Login'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationScreen()),
                                  );
                                },
                                child:
                                    const Text('Nemaš račun? Registruj se!')),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
