import 'dart:convert';
import 'dart:io';

import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/location_visits_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_service_model.dart';
import 'package:discoverhscountry_mobile/models/review_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_image_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_model.dart';
import 'package:discoverhscountry_mobile/screens/cart_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

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
  List<Service> addedToCartServices = [];
  int? touristId;
  List<Review> reviews = [];
  double? averageRate;
  LocationVisits? locationVisits;

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

  Future<void> _loadData() {
    return _getCityById(widget.location.cityId)
        .then((_) => _getServicesByLocationId(widget.location.locationId!))
        .then((_) => _getTouristId())
        .then((_) => _getReviews())
        .then((_) => _getLocationVisitsByLocationIdAndTouristId())
        .then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {});
  }

  _getTouristId() async {
    touristId = await getTouristIdByUserId(widget.user.userId);
  }

  _getReviews() async {
    reviews = await getReviewByLocationId(widget.location.locationId!);
  }

  _calculateAverageRate() async {
    double sum = 0.0;
    if (reviews.isNotEmpty) {
      for (var review in reviews) {
        sum += review.rate;
      }
      averageRate = sum / reviews.length;
    }
  }

  Future<void> _getLocationVisitsByLocationIdAndTouristId() async {
    locationVisits = await getLocationVisitsByLocationIdAndTouristId(
        widget.location.locationId!, touristId!);

    if (locationVisits == null) {
      final newLocationVisit = LocationVisits(
          locationId: widget.location.locationId!,
          touristId: touristId!,
          numberOfVisits: 0);
      final requestBody = jsonEncode(newLocationVisit);
      final Uri uri = Uri.parse('${ApiConstants.baseUrl}/LocationVisits');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final createdLocationVisits = LocationVisits(
            locationVisitsId: jsonData['locationVisitsId'],
            locationId: jsonData['locationId'],
            touristId: jsonData['touristId'],
            numberOfVisits: jsonData['numberOfVisits']);
        locationVisits = createdLocationVisits;
      }
    }
  }

  _increaseVisitNumber() async {
    int numberOfVisits = locationVisits!.numberOfVisits + 1;
    final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/LocationVisits/${locationVisits!.locationVisitsId}');

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'numberOfVisits': numberOfVisits}),
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('increased number of visits to: $numberOfVisits');
    } else {
      // ignore: avoid_print
      print('fail');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData().then((_) => _increaseVisitNumber());
  }

  @override
  Widget build(BuildContext context) {
    _calculateAverageRate();
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.location.name
                                        .split(' ')
                                        .take(3)
                                        .join(' '), // Take the first 3 words
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  if (widget.location.name.split(' ').length >
                                      3)
                                    Text(
                                      widget.location.name.split(' ').skip(3).join(
                                          ' '),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                ],
                              ),
                              Tooltip(
                                message: "Add to Visited Locations",
                                child: IconButton(
                                  onPressed: () {
                                    _showVisitedLocationDialog(
                                        context); 
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: Colors.green,
                                    size: 32.0,
                                  ),
                                ),
                              ),
                            ])),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(widget.location.description,
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          launchMaps(
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
                                              launchUrl(Uri.parse(
                                                  widget.location.facebookUrl));
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
                                              launchUrl(Uri.parse(
                                                  widget.location.bookingUrl));
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
                                              ?.copyWith(color: Colors.black)),
                                      Text(
                                          'Price: BAM${service.unitPrice.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      _makeReservation(
                                          service.serviceId!, service);
                                    },
                                    child: const Text('Reserve'),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Text(''),
                    ElevatedButton(
                      onPressed: _showAddReviewDialog,
                      child: const Text('Add Review'),
                    ),
                    if (reviews.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Reviews:',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Average rate: $averageRate',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return FutureBuilder<String>(
                                  future: getUserNameForReviewDisplay(
                                      review.touristId),
                                  builder: (context, fullNameSnapshot) {
                                    if (fullNameSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (fullNameSnapshot.hasError) {
                                      return Text(
                                          'Error: ${fullNameSnapshot.error}');
                                    } else {
                                      final fullName = fullNameSnapshot.data;
                                      return Card(
                                        margin: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: Text(review.title!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Author: ${fullName!}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          color: Colors.black,
                                                          fontStyle: FontStyle
                                                              .italic)),
                                              Text(review.description!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          color: Colors.black)),
                                              Text(
                                                  'Rate: ${review.rate.toStringAsFixed(2)}'),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }),
                        ],
                      ),
                  ])));
  }

  Future<void> _showAddReviewDialog() async {
    double rate = 0.0;
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Review',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.black)),
          content: SingleChildScrollView(
              child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FormBuilderTextField(
                  name: 'title',
                  controller: titleController,
                  decoration: InputDecoration(
                    errorStyle: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontSize: 9, color: Colors.red),
                    labelText: 'Title',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.black),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'This field is required!'),
                    FormBuilderValidators.minLength(3,
                        errorText:
                            'Headline needs to contain minimum 3 characters.'),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'description',
                  controller: descriptionController,
                  decoration: InputDecoration(
                    errorStyle: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontSize: 9, color: Colors.red),
                    labelText: 'Description',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.black),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'This field is required!'),
                    FormBuilderValidators.minLength(3,
                        errorText:
                            'Description needs to contain minimum of 3 characters.'),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Your rate:',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color.fromARGB(255, 94, 93, 93))),
                RatingBar(
                  initialRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Image.asset('assets/heart.png'),
                    half: Image.asset('assets/heart_half.png'),
                    empty: Image.asset('assets/heart_border.png'),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                  },
                )
              ],
            ),
          )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newReview = Review(
                      title: titleController.text,
                      description: descriptionController.text,
                      rate: rate,
                      reviewDate: DateTime.now(),
                      touristId: touristId!,
                      locationId: widget.location.locationId!);
                  var url = Uri.parse('${ApiConstants.baseUrl}/Review');
                  var response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(newReview.toJson()),
                  );
                  if (response.statusCode == 200) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                'You have successfully saved your review.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LocationDetailsScreen(
                                        user: widget.user,
                                        location: widget.location,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('OK'),
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
                                'Review is not saved. Check your input fields.'),
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
                }
              },
              child: const Text('Add Review'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
  BuildContext context,
  TextEditingController controller,
  bool reservation,
) async {
  final DateTime currentDate = DateTime.now();
  DateTime firstDate;
  DateTime lastDate;

  if (reservation) {
    // For reservations, allows dates only in the future
    firstDate = currentDate;
    lastDate = DateTime(currentDate.year + 1); // Limit to one year in the future
  } else {
    // For visited locations, allows dates only in the past
    firstDate = DateTime(currentDate.year - 1); // Limit to one year in the past
    lastDate = currentDate;
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (picked != null) {
      controller.text = picked.toLocal().toString().split(' ')[0];
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Date'),
            content: const Text('Please select a date in the allowed range.'),
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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () =>
                          _selectDate(context, startDateController, true),
                    ),
                  ),
                ),
                TextFormField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(context, endDateController, true),
                      ),
                    )),
                TextField(
                  controller: numberOfPeopleController,
                  decoration: const InputDecoration(
                      labelText: 'Amount (number of people)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: additionalDescriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Additional Description'),
                ),
              ],
            ),
          ),
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
                  reservationId:
                      0, // Replace with the actual reservation ID later on
                  serviceId: serviceId,
                );

                cartItems.add(reservationService);
                addedToCartServices.add(service);
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Added to Cart',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Colors.black,
                              )),
                      content: Text(
                          'Do you want to proceed to checkout or add another service from this location?',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.black,
                              )),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(
                                    user: widget.user,
                                    location: widget.location,
                                    cartItems: cartItems,
                                    addedToCartServices: addedToCartServices),
                              ),
                            );
                          },
                          child: Text('Proceed to Checkout',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                  )),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Add Another Service',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
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

  void _showVisitedLocationDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add to Visited Locations"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Select the date you visited this location',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, dateController, false),
                  ),
                ),
              ),
              TextField(
                controller: notesController, // Use the notes controller
                maxLines: null,
                decoration:
                    const InputDecoration(labelText: "Notes about this place"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                VisitedLocation newVisitedLocation = VisitedLocation(
                    locationId: widget.location.locationId!,
                    touristId: touristId!,
                    visitDate: DateTime.parse(dateController.text),
                    notes: notesController.text);
                var url = Uri.parse('${ApiConstants.baseUrl}/VisitedLocation');
                var response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(newVisitedLocation.toJson()),
                );
                if (response.statusCode == 200) {
                  // Parse the response JSON to get the ID
                  Map<String, dynamic> responseJson = jsonDecode(response.body);

                  int newVisitedLocationId = responseJson["visitedLocationId"];
                  // ignore: use_build_context_synchronously
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                              'You have successfully saved this location to visited locations.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LocationDetailsScreen(
                                      user: widget.user,
                                      location: widget.location,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                            TextButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                  allowMultiple: true,
                                );

                                if (result != null) {
                                  List<File> imageFiles = result.paths
                                      .map((path) => File(path!))
                                      .toList();

                                  for (var imageFile in imageFiles) {
                                    List<int> imageBytes =
                                        await imageFile.readAsBytes();
                                    String base64Image =
                                        base64Encode(imageBytes);
                                    VisitedLocationImage
                                        newVisitedLocationImage =
                                        VisitedLocationImage(
                                            visitedLocationId:
                                                newVisitedLocationId,
                                            image: base64Image);
                                    var url = Uri.parse(
                                        '${ApiConstants.baseUrl}/VisitedLocationImage');
                                    var response = await http.post(
                                      url,
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                      body: jsonEncode(
                                          newVisitedLocationImage.toJson()),
                                    );
                                    if (response.statusCode == 200) {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: const Text(
                                                    'You have successfully saved images.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              LocationDetailsScreen(
                                                            user: widget.user,
                                                            location:
                                                                widget.location,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ]);
                                          });
                                    }
                                  }
                                } else {
                                  // Handle the case where no files were picked
                                }
                              },
                              child: const Text('Add photos'),
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
                              'Visited location is not saved. Check your input fields.'),
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
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
