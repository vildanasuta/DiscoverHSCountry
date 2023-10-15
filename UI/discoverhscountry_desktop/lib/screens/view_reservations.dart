import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/tourist_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/reservation_details.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class ViewReservations extends StatefulWidget {
  final User? user;
  const ViewReservations({super.key, this.user});

  @override
  State<ViewReservations> createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> with DataFetcher {
  final AuthenticationService authService = AuthenticationService();
  List<int> locationIds = [];
  List<Map<String, dynamic>> locations = [];
  List<Reservation> allReservations = [];
  bool isLoading=true;

  int? taoId;
  @override
  void initState() {
    super.initState();
    final userId = widget.user!.userId;
    getTouristAttractionOwnerIdByUserId(userId).then((taoId) {
      if (taoId != null) {
        setState(() {
          taoId = taoId;
        });

        fetchLocationIdsByTouristAttractionOwnerId(taoId!)
            .then((fetchedIds) async {
          setState(() {
            locationIds = fetchedIds;
          });
          return await fetchLocationsByIds(locationIds);
        }).then((fetchedLocations) async {
          setState(() {
            locations = fetchedLocations;
          });
          for (int locationId in locationIds) {
            allReservations = await fetchReservationsByLocationId(locationId);
          }
        }).then((value) => {
          isLoading=false
        });
      } else {
        // ignore: avoid_print
        print('Failed to fetch Tourist Attraction Owner ID');
      }
    });
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
            child: isLoading?const Center(
              child: CircularProgressIndicator(), // Loading indicator
            ):buildReservationList(),
          ),
        ],
      ),
    );
  }

  Widget buildReservationList() {
    return ListView.separated(
      itemCount: locations.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final location = locations[index];
        final locationName = location['name'] as String;
        final locationId = location['locationId'] as int;

        final locationReservations = allReservations
            .where((reservation) => reservation.locationId == locationId)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                locationName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.blueGrey),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 253, 253, 253),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0),
                },
                border: TableBorder.all(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                    ),
                    children: const [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Ime i prezime',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Cijena',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Detalji',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (final reservation in locationReservations)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<Tourist>(
                              future: getTouristById(reservation.touristId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    final tourist = snapshot.data!;
                                    final touristName =
                                        '${tourist.firstName} ${tourist.lastName}';
                                    return Center(child: Text(touristName));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                '${reservation.price.toStringAsFixed(2)} BAM',
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ReservationDetails(user: widget.user!, reservation: reservation)),
          );


                              },
                              child: const Text(
                                'Pogledaj detalje',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
