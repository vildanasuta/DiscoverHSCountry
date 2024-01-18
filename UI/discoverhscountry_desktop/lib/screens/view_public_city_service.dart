import 'dart:convert';

import 'package:discoverhscountry_desktop/models/public_city_service.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class ViewPublicCityService extends StatefulWidget {
  User user;
  String userType;
  ViewPublicCityService({Key? key, required this.user, required this.userType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewPublicCityServiceState createState() => _ViewPublicCityServiceState();
}

class _ViewPublicCityServiceState extends State<ViewPublicCityService>
    with DataFetcher {
  City? selectedCity;
  int selectedCityId = 0;
  Map<String, int> cityIdMap = {};

  List<Location> locations = [];
  bool isLoading = true; // Added loading indicator state
  List<City> cities = [];
  List<LocationCategory> locationCategories = [];
  final AuthenticationService authService = AuthenticationService();

  List<PublicCityService> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
      });
    }).catchError((error) {
      // Handle error
    });
  }

  void fetchServices() async {
    try {
      services = await fetchAllPublicCityServices();
    } catch (e) {
      // Handle errors
    } finally {
      // Set isLoading to false when loading is complete
      setState(() {
        isLoading = false;
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
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                Image cimage;
                // ignore: unnecessary_null_comparison
                if (service.coverImage != null &&
                    service.coverImage != "null") {
                  cimage = Image.memory(base64.decode(service.coverImage!));
                } else {
                  cimage = Image.network(
                      'https://cms.uitp.org/thumbor/fit-in/1024x/--/uploads/2022/07/Copyright-CCR-Metro-Bahia-3-scaled-e1658341124673.jpg');
                }
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: cimage,
                    title: Text(service.name),
                    subtitle: Text(service.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            showEditService(service);
                          },
                          child: const Text("Ažuriraj"),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () async {
                            var isDeleted = await deletePublicCityServiceById(
                                service.publicCityServiceId!);

                            if (isDeleted) {
                              // ignore: use_build_context_synchronously
                              Flushbar(
                                message: "Usluga je obrisana",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ).show(context);
                              // ignore: use_build_context_synchronously
                              Future.delayed(const Duration(milliseconds: 3500),
                                  () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewPublicCityService(
                                          user: widget.user,
                                          userType: widget.userType,
                                        )));
                              });
                            }
                          },
                          child: const Text('Obriši'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  showEditService(var service) async {
    final TextEditingController nameController =
        TextEditingController(text: service.name);
    final TextEditingController descriptionController =
        TextEditingController(text: service.description);
    final TextEditingController addressController =
        TextEditingController(text: service.address);

    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    // ignore: use_build_context_synchronously
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj javni gradski servis'),
                content: SingleChildScrollView(
                    child: Column(children: [
                  FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
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
                                          name: 'name',
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Ime',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText:
                                                    'Ovo polje je obavezno!'),
                                            FormBuilderValidators.minLength(3,
                                                errorText:
                                                    'Naziv mora sadržavati minimalno 3 karaktera.'),
                                          ]),
                                        ),
                                        const SizedBox(height: 16),
                                        FormBuilderTextField(
                                          name: 'description',
                                          controller: descriptionController,
                                          decoration: const InputDecoration(
                                            labelText: 'Opis',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText:
                                                    'Ovo polje je obavezno!'),
                                            FormBuilderValidators.minLength(3,
                                                errorText:
                                                    'Opis mora sadržavati minimalno 3 karaktera.'),
                                            FormBuilderValidators.maxLength(200,
                                                errorText:
                                                    'Opis može sadržavati maximalno 200 karaktera.')
                                          ]),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: addressController,
                                          decoration: const InputDecoration(
                                            labelText: 'Adresa',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText:
                                                    'Ovo polje je obavezno!'),
                                            FormBuilderValidators.minLength(3,
                                                errorText:
                                                    'Adresa mora sadržavati minimalno 3 karaktera.'),
                                          ]),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<City>(
                                          decoration: const InputDecoration(
                                            labelText: 'Izaberi grad *',
                                            prefixIcon: Icon(
                                              CupertinoIcons.location,
                                              color:
                                                  Color.fromRGBO(0, 2, 89, 1.0),
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(15),
                                          ),
                                          value: cities.firstWhere((city) =>
                                              city.id == service.cityId),
                                          onChanged: (City? value) {
                                            setState(() {
                                              selectedCity = value;
                                              selectedCityId = value!.id;
                                            });
                                          },
                                          items: cities.map((City city) {
                                            return DropdownMenuItem<City>(
                                              value: city,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Text(
                                                      city.name,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          validator:
                                              FormBuilderValidators.required(),
                                        ),
                                        const SizedBox(height: 32),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              var serviceId =
                                                  service.publicCityServiceId;
                                              PublicCityService editedService =
                                                  PublicCityService(
                                                      publicCityServiceId:
                                                          serviceId,
                                                      name: nameController.text,
                                                      description:
                                                          descriptionController
                                                              .text,
                                                      address: addressController
                                                          .text,
                                                      // ignore: unnecessary_null_comparison
                                                      cityId: selectedCityId!=0?selectedCityId:service.cityId,
                                                      coverImage:
                                                          service.coverImage);
                                              var url = Uri.parse(
                                                  '${ApiConstants.baseUrl}/PublicCityService/$serviceId');
                                              var response =
                                                  await makeAuthenticatedRequest(
                                                url,
                                                'PUT',
                                                body: editedService.toJson(),
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
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ViewPublicCityService(
                                                                  user: widget
                                                                      .user,
                                                                  userType: widget
                                                                      .userType,
                                                                ),
                                                              ));
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder: (context) => DashboardAdmin(
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
                                                            'Javni gradski servis nije uspješno editovan. Provjerite polja za unos.'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                            }
                                          },
                                          child: const Text('Spasi'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ]),
                    ),
                  )
                ])));
          });
        });
  }
}
