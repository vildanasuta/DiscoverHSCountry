
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewReservationDetails extends StatefulWidget {
  User user;
  Reservation reservation;
  Location location;
  ViewReservationDetails(
      {super.key,
      required this.user,
      required this.reservation,
      required this.location});

  @override
  State<ViewReservationDetails> createState() => _ViewReservationDetailsState();
}

class _ViewReservationDetailsState extends State<ViewReservationDetails>
    with DataFetcher {
  bool isLoading = true;
  List<ReservationService> reservationServices = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getReservationServicesForReservation().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _getReservationServicesForReservation() async {
    reservationServices = await getReservationServicesByReservationId(
        widget.reservation.reservationId!);
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
            'Reservation details for: ${widget.location.name}',
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
          : ListView.builder(
              itemCount: reservationServices.length,
              itemBuilder: (context, index) {
                final reservation = reservationServices[index];
                String startDate =
                    '${reservation.startDate.day}/${reservation.startDate.month}/${reservation.startDate.year}';
                String endDate =
                    '${reservation.endDate.day}/${reservation.endDate.month}/${reservation.endDate.year}';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      'Start date: $startDate',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End date: $endDate',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Number of people: ${reservation.numberOfPeople}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Price: ${widget.reservation.price} BAM',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Visibility(
                          visible: reservation.additionalDescription.isNotEmpty,
                          child: Text(
                          'Additional description: ${reservation.additionalDescription}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),)
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
