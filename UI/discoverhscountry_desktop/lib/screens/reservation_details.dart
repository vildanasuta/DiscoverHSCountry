import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_service_model.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/tourist_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ReservationDetails extends StatefulWidget {
  User user;
  Reservation reservation;
  Tourist tourist;
  ReservationDetails(
      {super.key,
      required this.user,
      required this.reservation,
      required this.tourist});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails>
    with DataFetcher {
  final AuthenticationService authService = AuthenticationService();
  // ignore: prefer_typing_uninitialized_variables
  var userTourist;
  // ignore: prefer_typing_uninitialized_variables
  var location;

  bool confirmationEmailSent = false;
  bool issuesEmailSent = false;

  @override
  initState() {
    super.initState();
    getUserByTourist();
    getLocation();
    if(widget.reservation.isConfirmed){
      confirmationEmailSent=true;
    }
  }

  getUserByTourist() async {
    userTourist = await getUserByUserId(widget.tourist.userId);
  }

  getLocation() async {
    location = await getLocationById(widget.reservation.locationId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        isLoggedIn: true,
        user: widget.user,
        userType: 'touristattractionowner',
        onLogout: () async {
          await authService.logout();
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: buildDetailsList(),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsList() {
    return FutureBuilder<List<ReservationService>>(
      future: getReservationDetailsById(widget.reservation.reservationId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data!.isNotEmpty && widget.reservation.isPaid) {
          final reservationServices = snapshot.data;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: reservationServices!.length,
                  itemBuilder: (context, index) {
                    final reservationService = reservationServices[index];
                    return FutureBuilder<Service>(
                      future:
                          getServiceByServiceId(reservationService.serviceId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child:
                                CircularProgressIndicator(), // Loading indicator
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final serviceDetails = snapshot.data;
                          return buildReservationServiceTile(
                              reservationService, serviceDetails!);
                        }
                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Column(children: [
            const Row(
              children: [
                Text('Podaci nisu dostupni. Narudžba nije kompletirana.')
              ],
            ),
            Row(children: [
              Visibility(
                  visible: !issuesEmailSent,
                  child: ElevatedButton(
                    onPressed: () async{
                      if (await _sendIssuesEmail(userTourist, location)) {
                        setState(() {
                          issuesEmailSent = true;
                        });
                        _showFlushBar(
                            true, 'Email o nekompletiranoj narudžbi poslan.');
                      } else {
                        _showFlushBar(false, 'Email nije poslan...');
                      }
                    },
                    child:
                        const Text('Pošalji Email o nekompletiranoj narudžbi'),
                  )),
            ])
          ]);
        }
      },
    );
  }

  Widget buildReservationServiceTile(
    ReservationService reservationService,
    Service serviceDetails,
  ) {
    return ListTile(
      title: Text(
        'Naziv usluge: ${serviceDetails.serviceName}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceInfo("Početni datum",
              DateFormat('dd/MM/yyyy').format(reservationService.startDate)),
          _buildServiceInfo("Završni datum",
              DateFormat('dd/MM/yyyy').format(reservationService.endDate)),
          _buildServiceInfo(
              "Broj osoba/količina", reservationService.numberOfPeople),
          _buildServiceInfo(
            "Dodatni opis",
            reservationService.additionalDescription,
          ),
          _buildServiceInfo(
            "Cijena",
            "${serviceDetails.unitPrice.toStringAsFixed(2)} BAM",
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: !confirmationEmailSent,
            child: ElevatedButton(
                onPressed: () async {
                  if (await _sendConfirmationEmail(userTourist, location)) {
                                          await updateIsConfirmed(reservationService.reservationId, true);
                    setState(() {
                                            confirmationEmailSent = true;
                    });
                    _showFlushBar(true, 'Email potvrde uspješno poslan!');
                  } else {
                    _showFlushBar(false, 'Email nije poslan...');
                  }
                },
                child: const Text('Potvrdi rezervaciju')),
          )
        ],
      ),
    );
  }

  Widget _buildServiceInfo(String label, dynamic value) {
    return Text(
      '$label: $value',
      style: const TextStyle(fontSize: 16),
    );
  }

  _sendIssuesEmail(User user, Location location) async {
    final emailData = {
      'sender': 'cdiscoverhs@gmail.com',
      'recipient': user.email,
      'subject': 'Reservation issues for ${location.name}',
      'content':
          "Dear ${user.firstName}, this email is informing you that reservation for ${location.name} has been created but it seems like reservation wasn't completed (uncompleted payment). Therefore, we cannot confirm your reservation. If you want to keep your reservation, please contact us so we can send you details on how to submit a payment. If this Email is not replied to, owner of the tourist attraction will delete your reservation. Thank you for using our app! (disclaimer: if you did not create reservation at ${location.name} be sure to reply to this email to report unusual activity)",
    };

    final response = await makeAuthenticatedRequest(
      Uri.parse('${ApiConstants.baseUrl}/Reservation/SendConfirmationEmail'),
      'POST',
      body: emailData,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  _sendConfirmationEmail(User user, Location location) async {
    final emailData = {
      'sender': 'cdiscoverhs@gmail.com',
      'recipient': user.email,
      'subject': 'Reservation confirmed for ${location.name}',
      'content':
          "Dear ${user.firstName}, this email is informing you that reservation for ${location.name} has been confirmed. Thank you for using our app! (disclaimer: if you did not create reservation at ${location.name} be sure to reply to this email to report unusual activity)",
    };

    final response = await makeAuthenticatedRequest(
      Uri.parse('${ApiConstants.baseUrl}/Reservation/SendConfirmationEmail'),
      'POST',
      body: emailData,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  _showFlushBar(bool success, String message) {
    return Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: success ? Colors.green : Colors.red,
    ).show(context);
  }
}
