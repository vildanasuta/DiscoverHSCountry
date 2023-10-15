import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_service_model.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class ReservationDetails extends StatefulWidget {
  User user;
  Reservation reservation;
  ReservationDetails(
      {super.key, required this.user, required this.reservation});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails>
    with DataFetcher {
  final AuthenticationService authService = AuthenticationService();
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
        } else if (snapshot.hasData) {
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
          return const Text('No data available.');
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
        _buildServiceInfo("Početni datum", DateFormat('dd/MM/yyyy').format(reservationService.startDate)),
        _buildServiceInfo("Završni datum",  DateFormat('dd/MM/yyyy').format(reservationService.endDate)),
        _buildServiceInfo("Broj osoba/količina", reservationService.numberOfPeople),
        _buildServiceInfo(
          "Dodatni opis",
          reservationService.additionalDescription,
        ),
        _buildServiceInfo(
          "Cijena",
          "${serviceDetails.unitPrice.toStringAsFixed(2)} BAM",
        ),
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

}
