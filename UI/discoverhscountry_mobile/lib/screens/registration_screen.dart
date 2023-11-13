import 'dart:io';
import 'dart:typed_data';

import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/tourist_model.dart';
import 'package:discoverhscountry_mobile/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<String> emails = [];
  String? _profileImage;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    _fetchAllEmails();
  }

  _fetchAllEmails() async {
    emails = await fetchAllEmails();
  }

  bool _checkIfEmailExists(String email) {
    if (emails.contains(email)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create an account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromRGBO(0, 2, 89, 1.0),
                            width: 3,
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'firstName',
                          decoration: InputDecoration(
                            labelText: 'First name *',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)),
                            prefixIcon: const Icon(
                              CupertinoIcons.person,
                              color: Color.fromRGBO(0, 2, 89, 1.0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 228, 164, 160),
                                    fontSize: 9),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  color: const Color.fromRGBO(0, 2, 89, 1.0)),
                          controller: _firstNameController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required!'),
                            FormBuilderValidators.minLength(3,
                                errorText:
                                    'First name needs to have minimum 3 characters.'),
                            FormBuilderValidators.match(
                                r'^[a-zA-ZščćžđŠČĆŽĐ]+$', // Add the unicode flag here
                                errorText:
                                    'First name should contain only letters!'),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromRGBO(0, 2, 89, 1.0),
                            width: 3,
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'lastName',
                          decoration: InputDecoration(
                            labelText: 'Last name *',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)),
                            prefixIcon: const Icon(
                              CupertinoIcons.person,
                              color: Color.fromRGBO(0, 2, 89, 1.0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 228, 164, 160),
                                    fontSize: 9),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  color: const Color.fromRGBO(0, 2, 89, 1.0)),
                          controller: _lastNameController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required!'),
                            FormBuilderValidators.minLength(3,
                                errorText:
                                    'Last name needs to have minimum 3 characters.'),
                            FormBuilderValidators.match(
                                r'^[a-zA-ZžščćžđŠČĆŽĐ]+$', // Add the unicode flag here
                                errorText:
                                    'Last name should contain only letters!'),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromRGBO(0, 2, 89, 1.0),
                            width: 3,
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'email',
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email *',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)),
                            prefixIcon: const Icon(
                              CupertinoIcons.mail,
                              color: Color.fromRGBO(0, 2, 89, 1.0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 228, 164, 160),
                                    fontSize: 9),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  color: const Color.fromRGBO(0, 2, 89, 1.0)),
                          controller: _emailController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required!'),
                            FormBuilderValidators.email(
                                errorText:
                                    'Email needs to be formatted like: example@example.com.'),
                            (value) {
                              if (_checkIfEmailExists(value!)) {
                                return 'This email already exists. Choose another one.';
                              }
                              return null; // Return null if the email is unique
                            },
                          ]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromRGBO(0, 2, 89, 1.0),
                            width: 3,
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)),
                            prefixIcon: const Icon(
                              CupertinoIcons.lock,
                              color: Color.fromRGBO(0, 2, 89, 1.0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 228, 164, 160),
                                    fontSize: 9),
                          ),
                          obscureText: true,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  color: const Color.fromRGBO(0, 2, 89, 1.0)),
                          controller: _passwordController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required!'),
                            FormBuilderValidators.minLength(8,
                                errorText:
                                    'Password needs to contain minimum of 8 characters.'),
                            FormBuilderValidators.match(
                                r'^(?=.*[a-zščćžđ])(?=.*[A-ZŠŽČĆŽĐ])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-zžščćžđŠŽČĆŽĐ\d@$!%*?&.]+$',
                                errorText:
                                    'The password must contain at least one uppercase letter, a number, and a symbol.'),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color.fromRGBO(0, 2, 89, 1.0),
                            width: 3,
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'repeatPassword',
                          decoration: InputDecoration(
                            labelText: 'Repeat password *',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)),
                            prefixIcon: const Icon(
                              CupertinoIcons.lock,
                              color: Color.fromRGBO(0, 2, 89, 1.0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(15),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 228, 164, 160),
                                    fontSize: 9),
                          ),
                          obscureText: true,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  color: const Color.fromRGBO(0, 2, 89, 1.0)),
                          controller: _repeatPasswordController,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required!'),
                            (val) {
                              if (val != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromRGBO(0, 2, 89, 1.0),
                      width: 3,
                    ),
                  ),
                  child: FormBuilderDateTimePicker(
                    name: 'date',
                    inputType: InputType.date,
                    format: DateFormat('yyyy-MM-dd'),
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth *',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                              color: const Color.fromRGBO(0, 2, 89, 1.0)),
                      prefixIcon: const Icon(
                        CupertinoIcons.calendar,
                        color: Color.fromRGBO(0, 2, 89, 1.0),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                              color: const Color.fromARGB(255, 228, 164, 160),
                              fontSize: 9),
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: const Color.fromRGBO(0, 2, 89, 1.0)),
                    validator: FormBuilderValidators.required(),
                    onChanged: (value) {
                      dateTime = DateTime(value!.year, value.month, value.day);
                    },
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      PlatformFile file = result.files.first;
                      File imageFile = File(file.path!);
                      Uint8List imageBytes = await imageFile.readAsBytes();

                      // Resize the image to a smaller size
                      img.Image resizedImage = img.decodeImage(imageBytes)!;
                      int maxWidth = 800;
                      img.Image smallerImage =
                          img.copyResize(resizedImage, width: maxWidth);

                      List<int> smallerImageBytes = img.encodeJpg(smallerImage);

                      String base64Image = base64Encode(smallerImageBytes);
                      setState(() {
                        _profileImage = base64Image;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: const Color.fromRGBO(0, 2, 89, 1.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.upload_file,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text('Pick profile image (not required)',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var firstName = _firstNameController.text;
                      var lastName = _lastNameController.text;
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      var repeatedPassword = _repeatPasswordController.text;
                      String? profileImage;
                      if (_profileImage != null) {
                        profileImage = _profileImage;
                      }
                      if (password != repeatedPassword) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Passwords are not matching. Check input fields and try again!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        var tourist = Tourist(
                          email: email,
                          password: password,
                          firstName: firstName,
                          lastName: lastName,
                          profileImage: profileImage!,
                          dateOfBirth: dateTime!,
                        );
                        var url = Uri.parse(
                            '${ApiConstants.baseUrl}/Tourist/CreateTouristWithUserDetails');
                        var response = await makeAuthenticatedRequest(
                          url,
                          'POST',
                          body: jsonEncode(tourist.toJson()),
                        );
                        if (response.statusCode == 200) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Successfully created account.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text('Login'),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Account was not created. Check the input fields.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6,
                    backgroundColor: const Color.fromRGBO(0, 2, 89, 1.0),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Register',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text('Already have an account? Log in!',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
