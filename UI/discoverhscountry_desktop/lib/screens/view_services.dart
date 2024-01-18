import 'package:discoverhscountry_desktop/models/service_model.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class ViewServices extends StatefulWidget {
  User user;
  String userType;
  int locationId;
  ViewServices(
      {Key? key,
      required this.user,
      required this.userType,
      required this.locationId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewServicesState createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> with DataFetcher {
  List<Location> locations = [];
  bool isLoading = true; // Added loading indicator state
  List<City> cities = [];
  List<LocationCategory> locationCategories = [];
  final AuthenticationService authService = AuthenticationService();

  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    try {
      services = await fetchServicesByLocationId(widget.locationId);
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
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(service.serviceName),
                    subtitle: Text(service.serviceDescription),
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
                            var isDeleted =
                                await deleteServiceById(service.serviceId!);

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
                                    builder: (context) => ViewServices(
                                          user: widget.user,
                                          userType: widget.userType,
                                          locationId: widget.locationId,
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
        TextEditingController(text: service.serviceName);
    final TextEditingController descriptionController =
        TextEditingController(text: service.serviceDescription);
    final TextEditingController unitPriceController =
        TextEditingController(text: service.unitPrice.toString());

    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    // ignore: use_build_context_synchronously
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Ažuriraj uslugu'),
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
                                          controller: unitPriceController,
                                          decoration: const InputDecoration(
                                            labelText: 'Cijena po osobi',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                errorText:
                                                    'Ovo polje je obavezno!'),
                                          ]),
                                        ),
                                        const SizedBox(height: 16),
                                        const SizedBox(height: 32),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              var serviceId = service.serviceId;
                                              Service editedService = Service(
                                                serviceId: serviceId,
                                                serviceName:
                                                    nameController.text,
                                                serviceDescription:
                                                    descriptionController.text,
                                                unitPrice: double.tryParse(
                                                    unitPriceController.text)!,
                                                locationId: widget.locationId,
                                              );
                                              var url = Uri.parse(
                                                  '${ApiConstants.baseUrl}/Service/$serviceId');
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
                                                                        ViewServices(
                                                                  user: widget
                                                                      .user,
                                                                  userType: widget
                                                                      .userType,
                                                                  locationId: widget
                                                                      .locationId,
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
                                                                builder: (context) => DashboardTouristAttractionOwner(
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
                                                            'Usluga nije uspješno editovana. Provjerite polja za unos.'),
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
