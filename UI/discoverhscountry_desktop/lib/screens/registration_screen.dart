import 'dart:io';
import 'dart:typed_data';

import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/screens/login_screen.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:discoverhscountry_desktop/models/tourist_attraction_owner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  // ignore: prefer_final_fields
  TextEditingController _firstNameController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _lastNameController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _emailController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _passwordController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _repeatPasswordController = TextEditingController();
  String? _profileImage;
  List<String> emails = [];
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
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Napravi korisnički račun',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0054A6),
                                ),
                              ),
                              const SizedBox(height: 10),
                              FormBuilder(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    FormBuilderTextField(
                                      name: 'firstName',
                                      decoration: const InputDecoration(
                                        labelText: 'Ime *',
                                        prefixIcon: Icon(CupertinoIcons.person),
                                      ),
                                      controller: _firstNameController,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        FormBuilderValidators.minLength(3,
                                            errorText:
                                                'Ime mora sadržavati minimalno 3 karaktera.'),
                                        FormBuilderValidators.match(
                                            r'^[a-zA-ZščćžđŠČĆŽĐ]+$', // Add the unicode flag here
                                            errorText:
                                                'Ime smije sadržavati samo slova!'),
                                      ]),
                                    ),
                                    const SizedBox(height: 10),
                                    FormBuilderTextField(
                                      name: 'lastName',
                                      decoration: const InputDecoration(
                                        labelText: 'Prezime *',
                                        prefixIcon: Icon(CupertinoIcons.person),
                                      ),
                                      controller: _lastNameController,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        FormBuilderValidators.minLength(3,
                                            errorText:
                                                'Prezime mora sadržavati minimalno 3 karaktera.'),
                                        FormBuilderValidators.match(
                                            r'^[a-zA-ZžščćžđŠČĆŽĐ]+$', // Add the unicode flag here
                                            errorText:
                                                'Prezime smije sadržavati samo slova!'),
                                      ]),
                                    ),
                                    const SizedBox(height: 10),
                                    FormBuilderTextField(
                                      name: 'email',
                                      decoration: const InputDecoration(
                                        labelText: 'Email *',
                                        prefixIcon: Icon(CupertinoIcons.mail),
                                      ),
                                      controller: _emailController,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        FormBuilderValidators.email(
                                            errorText:
                                                'Email mora biti u formatu: primjer@primjer.com.'),
                                        (value) {
                                          if (_checkIfEmailExists(value!)) {
                                            return 'Email već postoji. Odaberite drugi email.';
                                          }
                                          return null; // Return null if the email is unique
                                        },
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'password',
                                      decoration: const InputDecoration(
                                        labelText: 'Lozinka *',
                                        prefixIcon: Icon(CupertinoIcons.lock),
                                      ),
                                      obscureText: true,
                                      controller: _passwordController,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        FormBuilderValidators.minLength(8,
                                            errorText:
                                                'Lozinka mora imati minimalno 8 karaktera.'),
                                        FormBuilderValidators.match(
                                            r'^(?=.*[a-zščćžđ])(?=.*[A-ZŠŽČĆŽĐ])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-zžščćžđŠŽČĆŽĐ\d@$!%*?&.]+$',
                                            errorText:
                                                'Lozinka mora sadržavati barem jedno veliko slovo, broj i znak.'),
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'repeatPassword',
                                      decoration: const InputDecoration(
                                        labelText: 'Ponovi lozinku *',
                                        prefixIcon: Icon(CupertinoIcons.lock),
                                      ),
                                      obscureText: true,
                                      controller: _repeatPasswordController,
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        (val) {
                                          if (val != _passwordController.text) {
                                            return 'Lozinke se ne podudaraju';
                                          }
                                          return null;
                                        },
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                  );

                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    PlatformFile file = result.files.first;
                                    File imageFile = File(file.path!);
                                    Uint8List imageBytes =
                                        await imageFile.readAsBytes();

                                    // Resize the image to a smaller size
                                    img.Image resizedImage =
                                        img.decodeImage(imageBytes)!;
                                    int maxWidth = 800;
                                    img.Image smallerImage = img.copyResize(
                                        resizedImage,
                                        width: maxWidth);

                                    List<int> smallerImageBytes =
                                        img.encodeJpg(smallerImage);

                                    String base64Image =
                                        base64Encode(smallerImageBytes);
                                    setState(() {
                                      _profileImage = base64Image;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: Colors.blue),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.upload_file),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Izaberite profilnu fotografiju! (opcionalno)')
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
                                    var repeatedPassword =
                                        _repeatPasswordController.text;
                                    String? profileImage;
                                    if (_profileImage != null) {
                                      profileImage = _profileImage;
                                    }
                                    if (password != repeatedPassword) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Greška'),
                                            content: const Text(
                                                'Lozinke nisu jednake. Provjerite unos i pokušajte ponovo!'),
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
                                      var touristAttractionOwner =
                                          TouristAttractionOwner(
                                        email: email,
                                        password: password,
                                        firstName: firstName,
                                        lastName: lastName,
                                        profileImage: profileImage,
                                      );
                                      var url = Uri.parse(
                                          '${ApiConstants.baseUrl}/TouristAttractionOwner/CreateTouristAttractionOwnerWithUserDetails');
                                      var response = await http.post(
                                        url,
                                        headers: {
                                          'Content-Type': 'application/json',
                                        },
                                        body: jsonEncode(
                                            touristAttractionOwner.toJson()),
                                      );
                                      if (response.statusCode == 200) {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Uspješno kreiran korisnički račun.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
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
                                                    'Račun nije uspješno kreiran. Provjerite polja za unos.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 6,
                                  backgroundColor: const Color(0xFF0054A6),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Registruj se',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  },
                                  child: const Text(
                                      'Već imaš račun? Prijavi se!')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
