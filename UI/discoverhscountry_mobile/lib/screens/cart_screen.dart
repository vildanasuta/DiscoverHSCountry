// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_service_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/payment_canceled_page.dart';
import 'package:discoverhscountry_mobile/screens/payment_success_page.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {
  User user;
  Location location;
  List<ReservationService> cartItems;
  List<Service> addedToCartServices;
  CartScreen(
      {super.key,
      required this.user,
      required this.location,
      required this.cartItems,
      required this.addedToCartServices});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with DataFetcher {
  bool isLoading = false;
  Future<double>? totalPriceFuture;
  int? touristId;
  double? totalPrice;
  @override
  void initState() {
    super.initState();
    totalPriceFuture = calculateTotalPriceAsync();
    getTouristId();
  }

  Future<void> getTouristId() async {
    touristId = await getTouristIdByUserId(widget.user.userId);
  }

  Future<double> calculateTotalPriceAsync() async {
    double totalPrice = 0.0;

    for (var reservationService in widget.cartItems) {
      double itemTotalPrice = calculateTotalPrice(reservationService);
      totalPrice += itemTotalPrice;
    }

    return totalPrice;
  }

  double calculateTotalPrice(ReservationService reservationService) {
    int numberOfPeople = reservationService.numberOfPeople;
    var unitPrice = widget.addedToCartServices
        .firstWhere(
            (service) => service.serviceId == reservationService.serviceId)
        .unitPrice;
    DateTime startDate = reservationService.startDate;
    DateTime endDate = reservationService.endDate;
    int numberOfDays = endDate.difference(startDate).inDays;
    return numberOfPeople * unitPrice * numberOfDays.toDouble();
  }

  Service getServiceById(int serviceId) {
    return widget.addedToCartServices
        .firstWhere((service) => service.serviceId == serviceId);
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
      body: FutureBuilder<double>(
          future: totalPriceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              totalPrice = snapshot.data ?? 0.0;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        ReservationService reservationService =
                            widget.cartItems[index];
                        double itemTotalPrice =
                            calculateTotalPrice(reservationService);

                        Service service =
                            getServiceById(reservationService.serviceId);
                        return ListTile(
                          title: Text('Service: ${service.serviceName}'),
                          subtitle: Text(
                              'Price: BAM${itemTotalPrice.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Price: BAM${totalPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          onPressed: () {
                            _saveReservation();
                          },
                          child: const Text('Proceed to payment')),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  _saveReservation() async {
    Reservation newReservation = Reservation(
        touristId: touristId!,
        locationId: widget.location.locationId!,
        price: totalPrice!);
    var url = Uri.parse('${ApiConstants.baseUrl}/Reservation');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newReservation.toJson()),
    );
    print(touristId);

    var user = await getUserById(widget.user.userId);
    var location = await getLocationById(widget.location.locationId!);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      int newReservationId = responseData['reservationId'];
      for (var reservationService in widget.cartItems) {
        reservationService.reservationId = newReservationId;
        var url = Uri.parse('${ApiConstants.baseUrl}/ReservationService');
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reservationService.toJson()),
        );
        if (response.statusCode != 200) {
          print(response.body);
        } else {
          print(response.statusCode);
          print('Saved');
        }
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AZm31Q22LOFbOKAjxt86nZrQpk0zF8Rr3HFkcAPsh7HAZ_d8ED4leIldByNFyN4wV_UK0hCwzmTl_XDb",
            secretKey:
                "EIW1EkL15cHAmDPYud7sttMEcOvUg_HPpuKmvX8wn7q3h-_zVVm4AHSeEhzuGExWDNer6c_SS2s2tgXK",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": (totalPrice! * 0.5),
                  "currency": "USD",
                },
                "description": "Payment for reservation #$newReservationId.",
                "item_list": {
                  "items": [
                    for (var reservationservice in widget.cartItems)
                      {
                        "name": reservationservice.additionalDescription,
                        "quantity": reservationservice.numberOfPeople,
                        "price": ((calculateTotalPrice(reservationservice) /
                                reservationservice.numberOfPeople) *
                            0.5),
                        "currency": "USD"
                      }
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              print("sending email...");
              _sendConfirmationEmail(user, location!);
              _navigateToSuccessPage();
            },
            onError: (error) {
              print("onError: $error");
              /* Navigator.of(context).push(
 MaterialPageRoute(
                              builder: (context) => PaymentCanceledPage(user: widget.user),
                            ));*/
            },
            onCancel: (params) {
              print('cancelled: $params');
              /* Navigator.of(context).push(
 MaterialPageRoute(
                              builder: (context) => PaymentCanceledPage(user: widget.user),
                            ));*/
            },
          ),
        ),
      );
    }
    setState(() {
      widget.cartItems = [];
    });
  }

  void _navigateToSuccessPage() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PaymentSuccessPage(user: widget.user),
    ));
  }

  _sendConfirmationEmail(User user, Location location) async {
    final emailData = {
      'sender': 'cdiscoverhs@gmail.com',
      'recipient': user.email,
      'subject': 'Reservation confirmation for ${location.name}',
      'content':
          "Dear ${user.firstName}, this email is confirmation of your reservation for ${location.name}. Thank you for using our app! (disclaimer: if you did not create reservation at ${location.name} be sure to reply to this email to report unusual activity)",
    };

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/Reservation/SendConfirmationEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(emailData),
    );
    if (response.statusCode == 200) {
      print('Email sent successfully.');
    } else {
      print('Failed to send email.');
    }
  }
}
