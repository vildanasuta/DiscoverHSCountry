// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_model.dart';
import 'package:discoverhscountry_mobile/models/service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/payment_canceled_page.dart';
import 'package:discoverhscountry_mobile/screens/payment_success_page.dart';
import 'package:discoverhscountry_mobile/screens/view_reservation_details.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages

// ignore: must_be_immutable
class ViewMyReservations extends StatefulWidget {
  User user;
  ViewMyReservations({super.key, required this.user});

  @override
  State<ViewMyReservations> createState() => _ViewMyReservationsState();
}

class _ViewMyReservationsState extends State<ViewMyReservations>
    with DataFetcher {
  bool isLoading = true;
  List<Reservation> reservations = [];
  List<Service> allServices = [];
  int? touristId;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getTouristId().then((_) {
      return _getReservationsForTourist();
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _getTouristId() async {
    touristId = await getTouristIdByUserId(widget.user.userId);
  }

  _getReservationsForTourist() async {
    reservations = await getReservationsForTourist(touristId!);
    allServices = await getServices();
  }

  Future<Location?>? _getLocationById(int locationId) async {
    return await getLocationById(locationId);
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
              'Your Reservations',
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
            : Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = reservations[index];
                      return FutureBuilder<Location?>(
                          future: _getLocationById(reservation.locationId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final location = snapshot.data;
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewReservationDetails(
                                                    user: widget.user,
                                                    reservation: reservation,
                                                    location: location)));
                                  },
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 49, 50, 102),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Location name: ${location!.name}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.italic),
                                              ),
                                              const SizedBox(width: 5),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Paid: ${reservation.isPaid ? 'YES' : 'NO'}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.italic),
                                              ),
                                              const SizedBox(width: 5),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Confirmed: ${reservation.isConfirmed ? 'YES' : 'NO'}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.italic),
                                              ),
                                              const SizedBox(width: 5),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  _sendCancellationRequest(
                                                      reservation);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: Colors.black),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Visibility(
                                                  visible: !reservation.isPaid,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      print('pay');
                                                      var reservationServices =
                                                          await getReservationServices(
                                                              reservation
                                                                  .reservationId);
                                                      var newContext = context;

                                                      final completer =
                                                          Completer<bool>();
                                                      await Navigator.of(
                                                              context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              UsePaypal(
                                                            sandboxMode: true,
                                                            clientId:
                                                                "AZm31Q22LOFbOKAjxt86nZrQpk0zF8Rr3HFkcAPsh7HAZ_d8ED4leIldByNFyN4wV_UK0hCwzmTl_XDb",
                                                            secretKey:
                                                                "EIW1EkL15cHAmDPYud7sttMEcOvUg_HPpuKmvX8wn7q3h-_zVVm4AHSeEhzuGExWDNer6c_SS2s2tgXK",
                                                            returnURL:
                                                                "https://samplesite.com/return",
                                                            cancelURL:
                                                                "https://samplesite.com/cancel",
                                                            transactions: [
                                                              {
                                                                "amount": {
                                                                  "total":
                                                                      (reservation
                                                                              .price *
                                                                          0.5),
                                                                  "currency":
                                                                      "USD",
                                                                },
                                                                "description":
                                                                    "Payment for reservation #${reservation.reservationId}",
                                                                "item_list": {
                                                                  "items": [
                                                                    for (var reservationservice
                                                                        in reservationServices)
                                                                      {
                                                                        "name":
                                                                            reservationservice.additionalDescription,
                                                                        "quantity":
                                                                            reservationservice.numberOfPeople,
                                                                        "price":
                                                                            price(reservationservice) *
                                                                                0.5,
                                                                        "currency":
                                                                            "USD"
                                                                      }
                                                                  ],
                                                                }
                                                              }
                                                            ],
                                                            note:
                                                                "Contact us for any questions on your order.",
                                                            onSuccess: (Map
                                                                params) async {
                                                              print(
                                                                  "onSuccess: $params");
                                                              String paymentId =
                                                                  params[
                                                                      'paymentId'];
                                                                      print("paymentid");
                                                                      print(paymentId);
                                                                      print(reservation.reservationId);
                                                              await addPayPalPaymentId(
                                                                  reservation
                                                                      .reservationId!,
                                                                  paymentId);
                                                              print(
                                                                  "sending email...");
                                                              _sendConfirmationEmail(
                                                                  widget.user,
                                                                  location);
                                                                                completer.complete(true);
                                                           
                                                              Navigator.of(
                                                                      newContext)
                                                                  .pop();
                                                              Navigator.of(
                                                                      newContext)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder: (newContext) =>
                                                                      PaymentSuccessPage(
                                                                          user:
                                                                              widget.user),
                                                                ),
                                                              );
                                                               print(
                                                                  "updating is paid...");
                                                                  await updateIsPaid(
                                                                  reservation
                                                                      .reservationId!,
                                                                  true);
                                                              
                                                            },
                                                            onError: (error) {
                                                              print(
                                                                  "onError: $error");
                                                                                completer.complete(false);
                                                            },
                                                            onCancel: (params) {
                                                              print(
                                                                  'cancelled: $params');
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                      final result = await completer.future;

      if (result) {
        if (mounted) {
          Navigator.of(newContext).push(
            MaterialPageRoute(
              builder: (newContext) => PaymentSuccessPage(user: widget.user),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(newContext).push(
            MaterialPageRoute(
              builder: (newContext) => PaymentCanceledPage(user: widget.user),
            ),
          );
        }
      }
                                                    },
                                                    child: Text(
                                                      'Pay',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ]));
                            }
                          });
                    },
                  ),
                ),
              ]));
  }

  _sendConfirmationEmail(User user, Location location) async {
    final emailData = {
      'sender': 'cdiscoverhs@gmail.com',
      'recipient': user.email,
      'subject': 'Reservation paid for ${location.name}',
      'content':
          "Dear ${user.firstName}, this email is informing you that reservation for ${location.name} has been paid. Owner of location will soon confirm your reservation and you'll be informed in another email. Thank you for using our app! (disclaimer: if you did not create reservation at ${location.name} be sure to reply to this email to report unusual activity)",
    };

    print(emailData);

    final response = await makeAuthenticatedRequest(
      Uri.parse('${ApiConstants.baseUrl}/Reservation/SendConfirmationEmail'),
      'POST',
      body: emailData,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print('Email sent successfully.');
    } else {
      print('Failed to send email.');
    }
  }

  _sendCancellationRequest(Reservation reservation) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancellation Confirmation'),
          content: const Text(
              'Are you sure you want to send a cancellation request?'),
          actions: [
            TextButton(
              onPressed: () {
                // User canceled the operation
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await sendCancellationRequestToTao(reservation);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  sendCancellationRequestToTao(Reservation reservation) async {
    var tao = await getTAOByLocation(reservation.locationId!);
    var user = await getUserById(tao);
    var taoEmail = user.email;
    var location = await getLocationById(reservation.locationId!);

    var subject = 'Cancellation Request for ${location!.name}';
    var body =
        'I would like to cancel my reservation for ${location.name}.\n\nPlease consider this as my formal cancellation request.\n\nSincerely,\n${widget.user.firstName}';
    _preFilledEmailReceipt = taoEmail;
    _preFilledEmailSubject = subject;
    _preFilledEmailBody = body;
    launchEmailApp();
  }

  String? _preFilledEmailReceipt;
  String? _preFilledEmailSubject;
  String? _preFilledEmailBody;

  void launchEmailApp() async {
    String email = Uri.encodeComponent(_preFilledEmailReceipt!);
    String subject = Uri.encodeComponent(_preFilledEmailSubject!);
    String body = Uri.encodeComponent(_preFilledEmailBody!);
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail, webOnlyWindowName: "_blank")) {
      print("opening email app...");
    } else {
      print("email app opening failed...");
    }
  }

  getReservationServices(int? reservationId) async {
    return await getReservationServicesByReservationId(reservationId!);
  }

  price(dynamic reservationservice) {
    DateTime startDate = reservationservice.startDate;
    DateTime endDate = reservationservice.endDate;
    int numberOfDays = endDate.difference(startDate).inDays;
    return allServices
            .firstWhere(
                (element) => element.serviceId == reservationservice.serviceId)
            .unitPrice *
        numberOfDays *
        reservationservice.numberOfPeople;
  }
}
