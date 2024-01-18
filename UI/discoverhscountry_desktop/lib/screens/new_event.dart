import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/event_category.dart';
import 'package:discoverhscountry_desktop/models/event_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class NewEvent extends StatefulWidget {
  final User? user;
  final String? userType;
  const NewEvent({super.key, required this.user, required this.userType});

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthenticationService authService = AuthenticationService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ticketCostController = TextEditingController();

  DateTime? dateTime;
  double? ticketCost;
  List<EventCategory> eventCategories = [];
  List<City> cities = [];
  List<int> locationIds = [];
  List<Map<String, dynamic>> locations = [];
  City? selectedCity;
  EventCategory? selectedCategory;
  int selectedCityId = 0;
  Map<String, int> cityIdMap = {};
  String? selectedLocationName;
  int? selectedLocationId;

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

    fetchEventCategories().then((fetchedCategories) {
      setState(() {
        eventCategories = fetchedCategories;
      });
    }).catchError((error) {
      // Handle error
    });

    int taoId = 0;
    if (widget.userType == "touristattractionowner") {
      getTouristAttractionOwnerIdByUserId(widget.user!.userId).then((id) async {
        setState(() {
          taoId = id!;
          fetchLocationIdsByTouristAttractionOwnerId(taoId)
              .then((fetchedIds) async {
            setState(() {
              locationIds = fetchedIds;
            });
            return await fetchLocationsByIds(locationIds);
          }).then((fetchedLocations) {
            setState(() {
              locations = fetchedLocations;
            });
          }).catchError((error) {
            // Handle error
          });
        });
      });
    }
  }

  Map<String, String> eventCategoriesTranslations = {
    "Concerts": "Koncerti",
    "Festivals": "Festivali",
    "Sports": "Sportski događaji",
    "Theater": "Teatar",
    "Exhibitions": "Izložbe",
    "Workshops": "Radionice",
    "Outdoor Activities": "Aktivnosti na otvorenom",
    "Nighlife": "Noćni život",
    "Special Events": "Posebni događaji"
  };

  var initialDateNow = DateTime.now();

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
                                  'Dodaj novi događaj',
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
                                                      const Text(
                                                        'Napomena: Opis se popunjava na engleskom jeziku!',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
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
                                                          counterText:
                                                              "", // To hide the default character counter
                                                        ),
                                                        maxLength: 200,
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
                                                          (value) {
                                                            if (value != null &&
                                                                value.length >
                                                                    200) {
                                                              return 'Opis ne može sadržavati više od 200 karaktera.';
                                                            }
                                                            return null;
                                                          },
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      FormBuilderDateTimePicker(
                                                        name: 'date',
                                                        inputType:
                                                            InputType.date,
                                                        format: DateFormat(
                                                            'yyyy-MM-dd'),
                                                        controller:
                                                            dateController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Datum *',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        initialDate:
                                                            initialDateNow,
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),
                                                        ]),
                                                        firstDate: DateTime
                                                                .now()
                                                            .subtract(
                                                                const Duration(
                                                                    days: 0)),
                                                        onChanged: (value) {
                                                          if (value != null) {
                                                            dateTime = DateTime(
                                                                value.year,
                                                                value.month,
                                                                value.day);
                                                          }
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      FormBuilderTextField(
                                                        name: 'startTime',
                                                        controller:
                                                            startTimeController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Vrijeme početka *',
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
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      FormBuilderTextField(
                                                        name: 'address',
                                                        controller:
                                                            addressController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Adresa (opcionalno)',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      FormBuilderTextField(
                                                        name: 'ticketCost',
                                                        controller:
                                                            ticketCostController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Cijena ulaznice (opcionalno)',
                                                          border:
                                                              OutlineInputBorder(),
                                                          suffixText: 'BAM',
                                                        ),
                                                        keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^\d+\.?\d{0,2}')),
                                                        ],
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .numeric(
                                                                  errorText:
                                                                      'Upišite validan broj!'),
                                                        ]),
                                                        onChanged: (value) {
                                                          ticketCost =
                                                              double.tryParse(
                                                                  ticketCostController
                                                                      .text);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      DropdownButtonFormField<
                                                          String>(
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
                                                            'Izaberi grad *'),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      DropdownButtonFormField<
                                                          EventCategory>(
                                                        value: selectedCategory,
                                                        onChanged:
                                                            (newCategory) {
                                                          setState(() {
                                                            selectedCategory =
                                                                newCategory;
                                                          });
                                                        },
                                                        items: eventCategories
                                                            .map((category) {
                                                          return DropdownMenuItem<
                                                              EventCategory>(
                                                            value: category,
                                                            child: Text(
                                                                eventCategoriesTranslations[
                                                                        category
                                                                            .name] ??
                                                                    category
                                                                        .name),
                                                          );
                                                        }).toList(),
                                                        hint: const Text(
                                                            'Izaberi kategoriju *'),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      Visibility(
                                                        visible: widget
                                                                .userType ==
                                                            'touristattractionowner',
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          value:
                                                              selectedLocationName,
                                                          validator:
                                                              FormBuilderValidators
                                                                  .compose([
                                                            FormBuilderValidators
                                                                .required(
                                                                    errorText:
                                                                        'Ovo polje je obavezno!'),
                                                          ]),
                                                          onChanged:
                                                              (newValue) {
                                                            final selectedLocation =
                                                                locations.firstWhere(
                                                                    (location) =>
                                                                        location[
                                                                            'name'] ==
                                                                        newValue);
                                                            setState(() {
                                                              selectedLocationName =
                                                                  newValue;
                                                              selectedLocationId =
                                                                  selectedLocation[
                                                                          'locationId']
                                                                      as int;
                                                            });
                                                          },
                                                          items: locations
                                                              .map((location) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: location[
                                                                      'name']
                                                                  as String,
                                                              child: Text(
                                                                  location[
                                                                          'name']
                                                                      as String),
                                                            );
                                                          }).toList(),
                                                          hint: const Text(
                                                              'Izaberite svoju lokaciju *'),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 32),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            Event newEvent =
                                                                Event(
                                                              title:
                                                                  titleController
                                                                      .text,
                                                              description:
                                                                  descriptionController
                                                                      .text,
                                                              date: dateTime!,
                                                              startTime:
                                                                  startTimeController
                                                                      .text,
                                                              address:
                                                                  addressController
                                                                          .text,
                                                              ticketCost:
                                                                  ticketCost ??
                                                                      0.0,
                                                              cityId:
                                                                  selectedCityId,
                                                              eventCategoryId:
                                                                  selectedCategory!
                                                                      .id,
                                                              locationId:
                                                                  selectedLocationId,
                                                            );
                                                            // ignore: avoid_print
                                                            print(newEvent
                                                                .toJson());
                                                            var url = Uri.parse(
                                                                '${ApiConstants.baseUrl}/Event');
                                                            var response =
                                                                await makeAuthenticatedRequest(
                                                              url,
                                                              'POST',
                                                              body: newEvent
                                                                  .toJson(),
                                                            );
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
                                                                          'Uspješno kreiran događaj.'),
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
                                                                          'Događaj nije uspješno spašen. Provjerite polja za unos.'),
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
                                                            'Kreiraj event'),
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
