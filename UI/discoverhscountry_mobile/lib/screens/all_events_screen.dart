import 'dart:ui';

import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/event_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AllEventsScreen extends StatefulWidget {
  User user;
  AllEventsScreen({super.key, required this.user});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> with DataFetcher {
  List<Event> events = [];
  List<Event> loadedEvents = [];
  List<Event> allEvents = [];
  int currentPage = 1;
  bool isLoading = false;
  int pageSize = 6;
  // ignore: avoid_init_to_null
  DateTime? selectedDate = null;
  List<int> selectedCityIds = [];
  List<int> selectedCategoryIds = [];

  Future<void> _fetchEvents(int page, int pageSize, DateTime? selectedDate,
      List<int> selectedCityIds, List<int> selectedCategoryIds) async {
    allEvents = await fetchEvents();
    if (isLoading) {
      return; // Prevent multiple simultaneous requests
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Event> newEvents = await fetchEvents(
        page: page,
        pageSize: pageSize,
        selectedDate: selectedDate,
      );

      if (selectedCityIds.isNotEmpty) {
        newEvents = newEvents.where((event) {
          return selectedCityIds.contains(event.cityId);
        }).toList();
      }

      if (selectedCategoryIds.isNotEmpty) {
        newEvents = newEvents.where((event) {
          return selectedCategoryIds.contains(event.eventCategoryId);
        }).toList();
      }
      setState(() {
        events = newEvents;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching events: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents(1, 6, selectedDate, selectedCityIds,
        selectedCategoryIds); // Load the initial page (page 1)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 2, 89, 1.0),
        foregroundColor: Colors.white,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
        title: Center(
          child: Text(
            'All events',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
      endDrawer: TouristDrawer(user: widget.user),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          buildDatePicker(),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 10, 45, 73)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ElevatedButton(
              onPressed: () async {
                var cities = await fetchCities();
                buildPickCitiesPopUp(cities);
              },
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.transparent),
                elevation: MaterialStateProperty.all(0.0),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Color.fromARGB(255, 10, 45, 73),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Pick cities',
                    style: TextStyle(
                        color: Color.fromARGB(255, 10, 45, 73),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 10, 45, 73)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ElevatedButton(
              onPressed: () async {
                var eventCategories = await fetchEventCategories();
                buildPickCategoriesPopUp(eventCategories);
              },
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.transparent),
                elevation: MaterialStateProperty.all(0.0),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.category,
                    color: Color.fromARGB(255, 10, 45, 73),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Pick categories',
                    style: TextStyle(
                        color: Color.fromARGB(255, 10, 45, 73),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return buildEventCard(events[index], index);
              },
            ),
          ),
          buildPaginationRow(),
        ],
      ),
    );
  }

  Future<void> buildPickCitiesPopUp(List<City> cities) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Cities'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    for (City city in cities)
                      CheckboxListTile(
                        title: Text(city.name),
                        value: selectedCityIds.contains(city.cityId),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                selectedCityIds.add(city.cityId);
                              } else {
                                selectedCityIds.remove(city.cityId);
                              }
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _fetchEvents(1, pageSize, selectedDate, selectedCityIds,
                        selectedCategoryIds);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> buildPickCategoriesPopUp(var categories) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select categories'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var category in categories)
                      CheckboxListTile(
                        title: Text(category['categoryName'] as String),
                        value: selectedCategoryIds
                            .contains(category['eventCategoryId'] as int),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                selectedCategoryIds
                                    .add(category['eventCategoryId'] as int);
                              } else {
                                selectedCategoryIds
                                    .remove(category['eventCategoryId'] as int);
                              }
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _fetchEvents(1, pageSize, selectedDate, selectedCityIds,
                        selectedCategoryIds);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildEventCard(Event event, int index) {
    if (index % 2 == 0) {
      return Column(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, rowIndex) {
              final eventIndex = index + rowIndex;
              if (eventIndex < events.length) {
                final event = events[eventIndex];
                return GestureDetector(
                    onTap: () async {
                      Location? location;
                      var locationId =
                          await getLocationIdByEventId(event.eventId);
                      if (locationId != null) {
                        location = await getLocationById(locationId);
                      }

                      var categoryName =
                          await getEventCategoryById(event.eventCategoryId!);
                      var city = await getCityById(event.cityId!);
                      // ignore: use_build_context_synchronously
                      _showEventDetailsPopup(
                          context, event, location, categoryName, city);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amber,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                              child: Container(
                                color: const Color.fromRGBO(0, 2, 89, 1.0)
                                    .withOpacity(0.2),
                                child: Center(
                                  child: Text(
                                    event.title.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  int calculateTotalPages(int totalEvents, int pageSize) {
    return (totalEvents / pageSize).ceil();
  }

  Widget buildPaginationRow() {
    final hasPreviousPage = currentPage > 1;
    final totalPages = calculateTotalPages(allEvents.length, pageSize);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: hasPreviousPage
                ? () {
                    _fetchEvents(currentPage - 1, pageSize, selectedDate,
                        selectedCityIds, selectedCategoryIds);
                    setState(() {
                      currentPage -= 1;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
            'Page $currentPage of $totalPages',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: currentPage < totalPages
                ? () {
                    _fetchEvents(currentPage + 1, pageSize, selectedDate,
                        selectedCityIds, selectedCategoryIds);
                    setState(() {
                      currentPage += 1;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  void _showEventDetailsPopup(BuildContext context, Event event,
      Location? location, String? categoryName, City city) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.black)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (location != null)
                Text(
                  'at location: ${location.name}',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Description: ${event.description}',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Date: ${event.date.day}/${event.date.month}/${event.date.year}',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Start Time: ${event.startTime}',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              if (event.address != null && event.address!.isNotEmpty)
                Text(
                  'Address: ${event.address}',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
              const SizedBox(
                height: 15,
              ),
              if (event.ticketCost != null)
                Text(
                  'Ticket Cost: BAM${event.ticketCost}',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
              const SizedBox(
                height: 15,
              ),
              if (categoryName != null)
                Text(
                  'Category: $categoryName',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
              const SizedBox(
                height: 15,
              ),
              // ignore: unnecessary_null_comparison
              if (city != null)
                Text(
                  'City: ${city.name}',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.black),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101), // Some distant future year
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
            _fetchEvents(1, pageSize, selectedDate, selectedCityIds,
                selectedCategoryIds);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 10, 45, 73)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: Color.fromARGB(255, 10, 45, 73),
            ),
            const SizedBox(width: 8.0),
            Text(
              selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                  : 'Select Date',
              style: const TextStyle(
                  color: Color.fromARGB(255, 10, 45, 73),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
