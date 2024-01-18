import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/event_category.dart';
import 'package:discoverhscountry_desktop/models/event_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class ViewEventsForAdmin extends StatefulWidget {
  User user;
  String userType;
  ViewEventsForAdmin({Key? key, required this.user, required this.userType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewEventsForAdminState createState() => _ViewEventsForAdminState();
}

class _ViewEventsForAdminState extends State<ViewEventsForAdmin>
    with DataFetcher {
  List events = [];
  bool isLoading = true; // Added loading indicator state
  final AuthenticationService authService = AuthenticationService();
  List<EventCategory> eventCategories = [];
  List<City> cities = [];
  @override
  void initState() {
    super.initState();
    fetchEvents();

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
  }

  void fetchEvents() async {
    try {
      events = await getAllEvents();
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        isLoading = false;
      });
      _initializeEvents();
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Event> selectedDayEvents = []; // Separate list for selected day events

  final Map<DateTime, List<Event>> _events = {};

  void _initializeEvents() {
    for (var event in events) {
      DateTime eventDate = DateTime.parse(event.date);
      _events[eventDate] = _events[eventDate] ?? [];
      Event eventNew = Event(
          address: event.address,
          cityId: event.cityId,
          eventCategoryId: event.eventCategoryId,
          eventId: event.eventId,
          locationId: event.locationId,
          ticketCost: event.ticketCost,
          title: event.title,
          description: event.description,
          date: DateTime.parse(event.date),
          startTime: event.startTime);
      _events[eventDate]!.add(eventNew);
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
          : Column(
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return TableCalendar(
                    calendarFormat: _calendarFormat,
                    focusedDay: _focusedDay,
                    currentDay: _selectedDay,
                    firstDay:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                    ),
                    eventLoader: _getEventsForDay,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        selectedDayEvents = _getEventsForDay(selectedDay);
                      });
                    },
                  );
                }),
                createListOfEvents(context),
              ],
            ),
    );
  }

  createListOfEvents(var context) {
      fetchEvents();
    return Expanded(
      child: StatefulBuilder(builder: (context, setState) {
        return ListView.builder(
          itemCount: selectedDayEvents.length,
          itemBuilder: (context, index) {
            if (index >= 0 && index < selectedDayEvents.length) {
              final Event event = selectedDayEvents[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                      'https://www.aal-europe.eu/wp-content/uploads/2013/04/events_medium.jpg'),
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Open the edit event dialog
                          await _showEditEventDialog(
                              event, eventCategories, cities);
                        },
                        child: const Text('Ažuriraj'),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          var isDeleted = await deleteEventById(event.eventId!);
                          if (isDeleted) {
                            // ignore: use_build_context_synchronously
                            Flushbar(
                              message: "Događaj je obrisan",
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ).show(context);
                            // ignore: use_build_context_synchronously
                            Future.delayed(
                              const Duration(milliseconds: 3500),
                              () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewEventsForAdmin(
                                      user: widget.user,
                                      userType: widget.userType,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Obriši'),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    List<Event> eventsOnSelectedDay = [];
    for (var event in events) {
      DateTime eventDate = DateTime.parse(event.date);
      if (isSameDay(eventDate, day)) {
        Event eventForAdding = Event(
          address: event.address,
          cityId: event.cityId,
          eventCategoryId: event.eventCategoryId,
          eventId: event.eventId,
          locationId: event.locationId,
          ticketCost: event.ticketCost,
          title: event.title,
          description: event.description,
          date: eventDate,
          startTime: event.startTime,
        );
        eventsOnSelectedDay.add(eventForAdding);
      }
    }

    return eventsOnSelectedDay;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _showEditEventDialog(
      var event, var eventCategoriess, var citiess) async {
    List<EventCategory> eventCategories = eventCategoriess;
    List<City> cities = citiess;
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

    City? selectedCity;
    EventCategory? selectedCategory;
    int? selectedCityId = 0;
    Map<String, int> cityIdMap = {};

    // ignore: avoid_init_to_null
    var location = null;
    if (event.locationId != null) {
      location = await getLocationById(event.locationId);
    }
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    TextEditingController titleController =
        TextEditingController(text: event.title);
    TextEditingController descriptionController =
        TextEditingController(text: event.description);
    DateTime eventDate = event.date;

    TextEditingController dateController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(eventDate));
    TextEditingController startTimeController =
        TextEditingController(text: event.startTime);
    TextEditingController addressController =
        TextEditingController(text: event.address);
    TextEditingController ticketCostController =
        TextEditingController(text: event.ticketCost.toString());

    if (event.ticketCost == null) {
      ticketCostController.text = '0.0';
    }
    DateTime? dateTime;
    double? ticketCost;

    var alreadySavedCity = cities.firstWhere((city) => city.id == event.cityId);
    var alreadySavedCategory = eventCategories
        .firstWhere((category) => category.id == event.eventCategoryId);

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Ažuriraj event'),
            content: SingleChildScrollView(
              child: Column(children: [
                if (location != null) Text("Lokacija: ${location.name}"),
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FormBuilderDateTimePicker(
                                      name: 'date',
                                      inputType: InputType.date,
                                      format: DateFormat('yyyy-MM-dd'),
                                      controller: dateController,
                                      initialValue: eventDate,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 0)),
                                      decoration: const InputDecoration(
                                        labelText: 'Datum *',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                      ]),
                                      onChanged: (value) {
                                        if (value != null) {
                                          dateTime = DateTime(value.year,
                                              value.month, value.day);
                                        } else {
                                          dateTime = eventDate;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FormBuilderTextField(
                                      name: 'startTime',
                                      controller: startTimeController,
                                      decoration: const InputDecoration(
                                        labelText: 'Vrijeme početka *',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(
                                            errorText:
                                                'Ovo polje je obavezno!'),
                                      ]),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FormBuilderTextField(
                                      name: 'address',
                                      controller: addressController,
                                      decoration: const InputDecoration(
                                        labelText: 'Adresa (opcionalno)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FormBuilderTextField(
                                      name: 'ticketCost',
                                      controller: ticketCostController,
                                      decoration: const InputDecoration(
                                        labelText:
                                            'Cijena ulaznice (opcionalno)',
                                        border: OutlineInputBorder(),
                                        suffixText: 'BAM',
                                      ),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.numeric(
                                            errorText: 'Upišite validan broj!'),
                                      ]),
                                      onChanged: (value) {
                                        ticketCost = double.tryParse(
                                            ticketCostController.text);
                                      },
                                    ),
                                    DropdownButtonFormField<String>(
                                      validator:  FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),]),
                                      value: selectedCity != null
                                          ? selectedCity!.name
                                          : alreadySavedCity.name,
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
                                      height: 16,
                                    ),
                                    DropdownButtonFormField<EventCategory>(
                                      validator:  FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),]),
                                      value: selectedCategory ??
                                          alreadySavedCategory,
                                      onChanged: (newCategory) {
                                        setState(() {
                                          selectedCategory = newCategory;
                                        });
                                      },
                                      items: eventCategories.map((category) {
                                        return DropdownMenuItem<EventCategory>(
                                          value: category,
                                          child: Text(
                                              eventCategoriesTranslations[
                                                      category.name] ??
                                                  category.name),
                                        );
                                      }).toList(),
                                      hint: const Text('Izaberi kategoriju *'),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var selectedCategoryId = selectedCategory?.id;
                  if (_formKey.currentState!.validate()) {
                    await updateEvent(
                      event.eventId!,
                      titleController.text,
                      descriptionController.text,
                      dateTime ?? eventDate,
                      startTimeController.text,
                      addressController.text,
                      ticketCost ?? event.ticketCost,
                      selectedCityId != null && selectedCityId != 0
                          ? selectedCityId
                          : event.cityId,
                      selectedCategoryId ?? event.eventCategoryId,
                      event.locationId,
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Close the dialog

                    // ignore: use_build_context_synchronously
                    Flushbar(
                      message: "Uspješno ažuriran događaj",
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ).show(context);
                    // ignore: use_build_context_synchronously
                    if (context.mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewEventsForAdmin(
                              user: widget.user, userType: widget.userType)));
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                'Događaj nije uspješno spašen. Provjerite polja za unos.'),
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
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  updateEvent(
      int eventId,
      String title,
      String description,
      DateTime dateTime,
      String startTime,
      String address,
      double? ticketCost,
      int cityId,
      int eventCategoryId,
      int? locationId) async {
    var eventForUpdate = Event(
        title: title,
        description: description,
        date: dateTime,
        startTime: startTime,
        address: address,
        ticketCost: ticketCost,
        cityId: cityId,
        eventCategoryId: eventCategoryId,
        locationId: locationId);
    await editEventById(eventId, eventForUpdate);
  }
}
