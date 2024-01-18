import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/historical_event.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image/image.dart' as img;

// ignore: must_be_immutable
class ViewHistoricalEventsForAdmin extends StatefulWidget {
  User user;
  String userType;
  ViewHistoricalEventsForAdmin(
      {Key? key, required this.user, required this.userType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewHistoricalEventsForAdminState createState() =>
      _ViewHistoricalEventsForAdminState();
}

class _ViewHistoricalEventsForAdminState
    extends State<ViewHistoricalEventsForAdmin> with DataFetcher {
  List historicalEvents = [];
  List<City> cities = [];
  List filteredEvents = [];
  City? selectedCity;
  bool isLoading = true; // Added loading indicator state
  final AuthenticationService authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    fetchHistoricalEvents();

    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
      });
    }).catchError((error) {
      // Handle error
    });
  }

  void fetchHistoricalEvents() async {
    try {
      historicalEvents = await getAllHistoricalEvents();
      filteredEvents = historicalEvents;
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterEventsByCity() {
    if (selectedCity != null) {
      setState(() {
        filteredEvents = historicalEvents
            .where((event) => event.cityId == selectedCity!.id)
            .toList();
      });
    } else {
      setState(() {
        filteredEvents = historicalEvents;
      });
    }
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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(), // Loading indicator
              )
            : Column(children: [
                Center( child:SizedBox(
                  width: 300,
                  height: 40,
                  child: DropdownButtonFormField<City>(
                    value: selectedCity,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCity = newValue;
                        filterEventsByCity();
                      });
                    },
                    items: cities.map((city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text(
                          city.name,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                      'Izaberi grad',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final historicalEvent = filteredEvents[index];
                      Image image = historicalEvent.coverImage != null &&
                              historicalEvent.coverImage.isNotEmpty &&
                              historicalEvent.coverImage != "null"
                          ? Image.memory(
                              base64Decode(historicalEvent.coverImage))
                          : Image.network(
                              "https://stav.ba/cms/uploads/2022/02/e76d09a30e8e9ab46b5541afc58dbe4b.jpg");
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: image,
                          title: Text(historicalEvent.title),
                          subtitle: Text(historicalEvent.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // Open the edit event dialog
                                  await _showEditHistoricalEventForAdmin(
                                      historicalEvent, cities);
                                },
                                child: const Text('Ažuriraj'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  var isDeleted =
                                      await deleteHistoricalEventById(
                                          historicalEvent.historicalEventId);
                                  if (isDeleted) {
                                    // ignore: use_build_context_synchronously
                                    Flushbar(
                                      message: "Historijski događaj je obrisan",
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ).show(context);
                                    // ignore: use_build_context_synchronously
                                    Future.delayed(
                                        const Duration(milliseconds: 3500),
                                        () async {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewHistoricalEventsForAdmin(
                                                      user: widget.user,
                                                      userType:
                                                          widget.userType)));
                                    });
                                  }
                                },
                                child: const Text('Obriši'),
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]));
  }

  _showEditHistoricalEventForAdmin(
      var historicalEvent, List<City> cities) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final TextEditingController titleController =
        TextEditingController(text: historicalEvent.title);
    final TextEditingController descriptionController =
        TextEditingController(text: historicalEvent.title);
    City? selectedCity =
        cities.firstWhere((element) => element.id == historicalEvent.cityId);
    int selectedCityId = historicalEvent.cityId;
    Map<String, int> cityIdMap = {};
    String? historicalEventImage = historicalEvent.coverImage;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Ažuriraj historijski događaj'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Napomena: Opis se popunjava na engleskom jeziku!',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    FormBuilderTextField(
                                      name: 'title',
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        labelText: 'Naslov *',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        FormBuilderValidators.minLength(3,
                                            errorText:
                                                'Naslov mora sadržavati minimalno 3 karaktera.'),
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'description',
                                      controller: descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Opis *',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                        FormBuilderValidators.minLength(3,
                                            errorText:
                                                'Opis mora sadržavati minimalno 3 karaktera.'),
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    DropdownButtonFormField<String>(
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                      ]),
                                      value: selectedCity != null
                                          ? selectedCity!.name
                                          : null,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCity = cities.firstWhere(
                                              (city) => city.name == newValue);
                                          selectedCityId = cityIdMap[newValue]!;
                                        });
                                      },
                                      items: cities.map((city) {
                                        cityIdMap[city.name] =
                                            city.id; // Store the mapping
                                        return DropdownMenuItem<String>(
                                          value: city.name,
                                          child: Text(city.name),
                                        );
                                      }).toList(),
                                      hint: const Text('Izaberi grad *'),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.image,
                                        );

                                        if (result != null &&
                                            result.files.isNotEmpty) {
                                          PlatformFile file =
                                              result.files.first;
                                          File imageFile = File(file.path!);
                                          Uint8List imageBytes =
                                              await imageFile.readAsBytes();
                                          img.Image resizedImage =
                                              img.decodeImage(imageBytes)!;
                                          int maxWidth = 800;
                                          img.Image smallerImage =
                                              img.copyResize(resizedImage,
                                                  width: maxWidth);

                                          List<int> smallerImageBytes =
                                              img.encodeJpg(smallerImage);

                                          String base64Image =
                                              base64Encode(smallerImageBytes);
                                          setState(() {
                                            historicalEventImage = base64Image;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.upload_file),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Izaberite naslovnu fotografiju događaja!')
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (selectedCity?.id == null) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Historijski događaj nije uspješno spašen. Provjerite polja za unos. Grad ne smije ostati neselektovan!'),
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
                                          return;
                                        }

                                        if (_formKey.currentState!.validate()) {
                                          HistoricalEvent newEvent =
                                              HistoricalEvent(
                                            title: titleController.text,
                                            description:
                                                descriptionController.text,
                                            coverImage:
                                                historicalEventImage.toString(),
                                            cityId: selectedCityId,
                                          );
                                          var url = Uri.parse(
                                              '${ApiConstants.baseUrl}/HistoricalEvent/${historicalEvent.historicalEventId}');
                                          var response =
                                              await makeAuthenticatedRequest(
                                            url,
                                            'PUT',
                                            body: newEvent.toJson(),
                                          );

                                          if (response.statusCode == 200) {
                                            // ignore: use_build_context_synchronously
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Uspješno spašene promjene.'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewHistoricalEventsForAdmin(
                                                                    user: widget
                                                                        .user,
                                                                    userType: widget
                                                                        .userType),
                                                          ));
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                DashboardAdmin(
                                                                    user: widget
                                                                        .user,
                                                                    userType: widget
                                                                        .userType),
                                                          ));
                                                        },
                                                        child: const Text(
                                                            'Idi na Dashboard'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Historijski događaj nije uspješno spašen. Provjerite polja za unos.'),
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
                                      },
                                      child: const Text(
                                          'Spasi historijski događaj'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
