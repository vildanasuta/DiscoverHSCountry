import 'dart:convert';
import 'dart:io';

import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/historical_event.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class NewHistoricalStory extends StatefulWidget {
  final User? user;
  final String? userType;
  const NewHistoricalStory({super.key, required this.user, required this.userType});

  @override
  State<NewHistoricalStory> createState() => _NewHistoricalStoryState();
}

class _NewHistoricalStoryState extends State<NewHistoricalStory> with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthenticationService authService = AuthenticationService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<City> cities = [];
  City? selectedCity;
  int selectedCityId = 0;
  Map<String, int> cityIdMap = {};
  String? historicalEventImage;

  @override
  void initState() {
    super.initState();
    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
      });
    }).catchError((error) {
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          isLoggedIn: true,
          user: widget.user,
          userType: widget.userType,
          onLogout: () async {
            await authService.logout();
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FirstPage()),
            );
          },
        ),
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
                              const Center(
                                child: Text(
                                  'Dodaj novi historijski događaj',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              FormBuilder(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 400),
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      FormBuilderTextField(
                                                        name: 'title',
                                                        controller:
                                                            titleController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Naslov *',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),
                                                          FormBuilderValidators
                                                              .minLength(3,
                                                                  errorText:
                                                                      'Naslov mora sadržavati minimalno 3 karaktera.'),
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      FormBuilderTextField(
                                                        name: 'description',
                                                        controller:
                                                            descriptionController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Opis *',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),
                                                          FormBuilderValidators
                                                              .minLength(3,
                                                                  errorText:
                                                                      'Opis mora sadržavati minimalno 3 karaktera.'),
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      DropdownButton<String>(
                                                        value: selectedCity !=
                                                                null
                                                            ? selectedCity!.name
                                                            : null,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selectedCity = cities
                                                                .firstWhere((city) =>
                                                                    city.name ==
                                                                    newValue);
                                                            selectedCityId =
                                                                cityIdMap[
                                                                    newValue]!;
                                                          });
                                                        },
                                                        items:
                                                            cities.map((city) {
                                                          cityIdMap[
                                                              city
                                                                  .name] = city
                                                              .id; // Store the mapping
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: city.name,
                                                            child:
                                                                Text(city.name),
                                                          );
                                                        }).toList(),
                                                        hint: const Text(
                                                            'Izaberi grad (opcionalno)'),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
                                                      onPressed: () async {
                                                        FilePickerResult?
                                                            result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                          type: FileType.image,
                                                        );

                                                        if (result != null &&
                                                            result.files
                                                                .isNotEmpty) {
                                                          PlatformFile file =
                                                              result
                                                                  .files.first;
                                                          File imageFile =
                                                              File(file.path!);
                                                          Uint8List imageBytes =
                                                              await imageFile
                                                                  .readAsBytes();
                                                          img.Image
                                                              resizedImage =
                                                              img.decodeImage(
                                                                  imageBytes)!;
                                                          int maxWidth = 800;
                                                          img.Image
                                                              smallerImage =
                                                              img.copyResize(
                                                                  resizedImage,
                                                                  width:
                                                                      maxWidth);

                                                          List<int>
                                                              smallerImageBytes =
                                                              img.encodeJpg(
                                                                  smallerImage);

                                                          String base64Image =
                                                              base64Encode(
                                                                  smallerImageBytes);
                                                          setState(() {
                                                            historicalEventImage =
                                                                base64Image;
                                                          });
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                      ),
                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons
                                                              .upload_file),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              'Izaberite naslovnu fotografiju lokacije!')
                                                        ],
                                                      ),
                                                    ),
                                                      const SizedBox(
                                                          height: 32),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            HistoricalEvent newEvent =
                                                                HistoricalEvent(
                                                              title:
                                                                  titleController
                                                                      .text,
                                                              description:
                                                                  descriptionController
                                                                      .text,
                                                              coverImage: historicalEventImage.toString(),
                                                              cityId:
                                                                  selectedCityId,

                                                            );
                                                            // ignore: avoid_print
                                                            print(newEvent
                                                                .toJson());
                                                            var url = Uri.parse(
                                                                '${ApiConstants.baseUrl}/HistoricalEvent');
                                                            var response =
                                                                await http.post(
                                                              url,
                                                              headers: {
                                                                'Content-Type':
                                                                    'application/json',
                                                              },
                                                              body: jsonEncode(
                                                                  newEvent
                                                                      .toJson()),
                                                            );
                                                            // ignore: avoid_print
                                                            print(response
                                                                .statusCode);
                                                            // ignore: avoid_print
                                                            print(
                                                                response.body);
                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              // ignore: use_build_context_synchronously
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Uspješno kreiran historijski događaj.'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (widget.userType ==
                                                                                'touristattractionowner') {
                                                                              Navigator.of(context).push(
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => DashboardTouristAttractionOwner(
                                                                                    user: widget.user,
                                                                                    userType: widget.userType,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            } else if (widget.userType ==
                                                                                'administrator') {
                                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                                builder: (context) => DashboardAdmin(user: widget.user, userType: widget.userType),
                                                                              ));
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text('Idi na Dashboard'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              // ignore: use_build_context_synchronously
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Historijski događaj nije uspješno spašen. Provjerite polja za unos.'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('OK'),
                                                                        )
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Spasi historijski događaj'),
                                                      ),
                                                    ]),
                                              ),
                                            ))
                                      ]),
                                ),
                              )
                            ]))))));
  }
}
