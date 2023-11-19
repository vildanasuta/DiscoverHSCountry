import 'dart:ui';

import 'package:discoverhscountry_mobile/models/event_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:flutter/material.dart';

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

  Future<void> _fetchEvents(int page, int pageSize) async {
    allEvents = await fetchEvents();
    if (isLoading) {
      return; // Prevent multiple simultaneous requests
    }

    setState(() {
      isLoading = true;
    });

    try {
      final List<Event> newEvents = await fetchEvents(
        page: page,
        pageSize: pageSize,
      );

      setState(() {
        if (newEvents.isNotEmpty) {
          newEvents.removeWhere((newEvent) {
            return events.any((event) => newEvent.eventId == event.eventId);
          });

          events = newEvents;
        }
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
    _fetchEvents(1, 6); // Load the initial page (page 1)
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
                      var locationId=await getLocationIdByEventId(event.eventId);
                      if(locationId!=null){
                        location=await getLocationById(locationId);
                      }
                      // ignore: use_build_context_synchronously
                      _showEventDetailsPopup(context, event, location);
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
                    _fetchEvents(currentPage - 1, pageSize);
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
                    _fetchEvents(currentPage + 1, pageSize);
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

  void _showEventDetailsPopup(
      BuildContext context, Event event, Location? location) {
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
              if (event.address != null)
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
}
