import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/reservation_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';
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
                                    /* Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VisitedLocationDetailsScreen(
                                            user: widget.user,
                                            visitedLocation: visitedLocation,
                                            location: location
                                          )));*/
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
                                              )
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
                // ignore: use_build_context_synchronously
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
      // ignore: avoid_print
      print("opening email app...");
    } else {
      // ignore: avoid_print
      print("email app opening failed...");
    }
  }
}
