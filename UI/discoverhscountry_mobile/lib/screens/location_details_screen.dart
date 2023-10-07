import 'dart:convert';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_service_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/cart_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class LocationDetailsScreen extends StatefulWidget {
  User user;
  Location location;
  LocationDetailsScreen(
      {super.key, required this.user, required this.location});

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen>
    with DataFetcher {
  City? city;
  List<Service> services = [];
  bool isLoading = true;
  List<ReservationService> cartItems = [];
  List<Service> addedToCartServices=[];

  _getCityById(int cityId) async {
    city = await getCityById(cityId);
  }

  _getServicesByLocationId(int locationId) async {
    try {
      services = await getServicesByLocationId(locationId);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching services: $e');
    }
  }
Future<void> _loadData() async {
  await Future.wait<void>([ 
    _getCityById(widget.location.cityId),
    _getServicesByLocationId(widget.location.locationId!),
  ]);
  setState(() {
    isLoading = false;
  });
}



  @override
  void initState() {
    super.initState();
    _loadData();
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
              widget.location.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.memory(base64.decode(widget.location.coverImage)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.location.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(widget.location.description,
                            style: Theme.of(context).textTheme.displaySmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            _launchMaps(
                                '${widget.location.address} ${city!.name}');
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.location.address} ${city!.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                      widget.location.facebookUrl != '' ||
                              widget.location.instagramUrl != '' ||
                              widget.location.bookingUrl != ''
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Social Media Links:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  Row(
                                    children: [
                                      widget.location.facebookUrl != ''
                                          ? GestureDetector(
                                              onTap: () {
                                                launchUrl(Uri.parse(widget
                                                    .location.facebookUrl));
                                              },
                                              child: SizedBox(
                                                width: 41,
                                                height: 41,
                                                child: Image.asset(
                                                  'assets/facebook-icon.png',
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      widget.location.instagramUrl != ''
                                          ? GestureDetector(
                                              onTap: () {
                                                launchUrl(Uri.parse(widget
                                                    .location.instagramUrl));
                                              },
                                              child: SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: Image.asset(
                                                  'assets/instagram_icon.png',
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      widget.location.bookingUrl != ''
                                          ? GestureDetector(
                                              onTap: () {
                                                launchUrl(Uri.parse(widget
                                                    .location.bookingUrl));
                                              },
                                              child: SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: Image.asset(
                                                  'assets/booking-icon.png',
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const Text(''),
                      services.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Services:',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            )
                          : const Text(''),
                      services.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                final service = services[index];
                                return Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(service.serviceName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(service.serviceDescription,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall
                                                ?.copyWith(
                                                    color: Colors.black)),
                                        Text(
                                            'Price: BAM${service.unitPrice.toStringAsFixed(2)}'),
                                      ],
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        _makeReservation(service.serviceId!, service);
                                      },
                                      child: const Text('Reserve'),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text(''),
                    ]),
              ));
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != DateTime.now()) {
      controller.text = picked.toLocal().toString().split(' ')[0];
    }
  }

  void _makeReservation(int serviceId, Service service) async {
    var startDateController = TextEditingController();
    var endDateController = TextEditingController();
    var numberOfPeopleController = TextEditingController();
    var additionalDescriptionController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make a reservation for selected service',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.black,
                  )),
          content:SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, startDateController),
                  ),
                ),
              ),
              TextFormField(
                  controller: endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, endDateController),
                    ),
                  )),
              TextField(
                controller: numberOfPeopleController,
                decoration:
                    const InputDecoration(labelText: 'Amount (number of people)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: additionalDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Additional Description'),
              ),
            ],
          ),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String startDate = startDateController.text;
                String endDate = endDateController.text;
                int numberOfPeople =
                    int.tryParse(numberOfPeopleController.text) ?? 0;
                String additionalDescription =
                    additionalDescriptionController.text;

                ReservationService reservationService = ReservationService(
                  startDate: DateTime.parse(startDate),
                  endDate: DateTime.parse(endDate),
                  numberOfPeople: numberOfPeople,
                  additionalDescription: additionalDescription,
                  reservationId: 0, // Replace with the actual reservation ID later on
                  serviceId: serviceId,
                );

                cartItems.add(reservationService);
                addedToCartServices.add(service);
                Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:  Text('Added to Cart',  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.black,
                  )),
                    content: Text('Do you want to proceed to checkout or add another service from this location?',  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                  )),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(user: widget.user, location: widget.location, cartItems: cartItems, addedToCartServices: addedToCartServices),
                            ),
                          );
                        },
                        child: Text('Proceed to Checkout', style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.black,
                  )),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Add Another Service',  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.black,
                  )),
                      ),
                    ],
                  );
                },
              );

              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _launchMaps(String locationName) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$locationName';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}
