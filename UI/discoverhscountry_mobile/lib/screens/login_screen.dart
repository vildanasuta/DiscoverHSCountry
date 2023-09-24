import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/models/login_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/dashboard_screen.dart';
import 'package:discoverhscountry_mobile/screens/registration_screen.dart';
import 'package:discoverhscountry_mobile/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// ignore: depend_on_referenced_packages
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
      body: Center(
       child: SingleChildScrollView(
      child: Container(          
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 10,
            ),
             Text(
              'Log in to your account',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                        
                      ],
                      border: Border.all(
                      color:const Color.fromARGB(255, 1, 38, 160),
      width: 3, 
    ),
                    ),
                    child: FormBuilderTextField(
                      name: 'email',
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:Theme.of(context).textTheme.displaySmall?.copyWith(                      color:const Color.fromARGB(255, 1, 38, 160),),
                        prefixIcon: const Icon(CupertinoIcons.mail, color:Color.fromARGB(255, 1, 38, 160),),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                        errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color:const Color.fromARGB(255, 228, 164, 160), fontSize: 9),
                      ),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(color:const Color.fromARGB(255, 1, 38, 160)),
                      controller: _emailController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'This field is required!'),
                        FormBuilderValidators.email(
                            errorText:
                                'Email needs to be formatted like: example@example.com.'),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                      color:const Color.fromARGB(255, 1, 38, 160),
      width: 3, 
                      ),
                    ),
                    child: FormBuilderTextField(
                      name: 'password',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:Theme.of(context).textTheme.displaySmall?.copyWith(color:const Color.fromARGB(255, 1, 38, 160)),
                        prefixIcon: const Icon(CupertinoIcons.lock, color:Color.fromARGB(255, 1, 38, 160)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                        errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color:const Color.fromARGB(255, 228, 164, 160), fontSize: 9),
                      ),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(color:const Color.fromARGB(255, 1, 38, 160)),
                      controller: _passwordController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'This field is required!'),
                      ]),
                      obscureText: true,
                    ),
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
                    deviceType: 'mobile',
                  );
                  var url = Uri.parse('${ApiConstants.baseUrl}/User/login');
                  var response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(loginModel.toJson()),
                  );
                  if (response.statusCode == 200) {
                    Map<String, dynamic> responseBody =
                        json.decode(response.body);
                    String? userType = responseBody['userType'];
                    if (userType != null) {
                      int userId = responseBody['userId'];
                      var getUserUrl =
                          Uri.parse('${ApiConstants.baseUrl}/User/$userId');
                      var userResponse = await http.get(getUserUrl);
                      User? user;
                      print(userResponse.body);
                      if (userResponse.statusCode == 200) {
                        Map<String, dynamic> userBody =
                            json.decode(userResponse.body);
                        user = User(
                          userId: userBody['userId'],
                          firstName: userBody['firstName'],
                          lastName: userBody['lastName'],
                          profileImage: userBody['profileImage'] ?? '',
                          email: userBody['email'] ?? '',
                        );
                      }
                      if (userType == 'tourist') {
                        await authService.login(); // Update isLoggedIn status
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(
                                user: user
                                ),
                          ),
                        );
                      }
                    } else {
                      // ignore: avoid_print
                      print('User type not provided in the response.');
                    }
                  } else {
                    // ignore: avoid_print
                    print(response.body);
                    if (response.body == "User not found.") {
                      // ignore: use_build_context_synchronously
                      Flushbar(
                        message: "User not found.",
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    } else if (response.body == "Invalid password.") {
                      // ignore: use_build_context_synchronously
                      Flushbar(
                        message: "Incorrect password. Try again!",
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  }
                }
              },
              child: Text('Log in', style: Theme.of(context).textTheme.displayMedium,),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RegistrationScreen()),
                  );
                },
                child: Text('You do not have account? Register now!', style: Theme.of(context).textTheme.displaySmall,)),
          ]),
        ),
      ),
    ));
  }
}
