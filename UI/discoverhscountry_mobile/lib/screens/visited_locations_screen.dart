import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_model.dart';
import 'package:discoverhscountry_mobile/screens/visited_location_details_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VisitedLocationsScreen extends StatefulWidget {
  User user;
  VisitedLocationsScreen({super.key, required this.user});

  @override
  State<VisitedLocationsScreen> createState() => _VisitedLocationsScreenState();
}

class _VisitedLocationsScreenState extends State<VisitedLocationsScreen>
    with DataFetcher {
  bool isLoading = true;
  List<VisitedLocation> visitedLocations = [];
  int? touristId;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getTouristId().then((_) {
      return _getVisitedLocations();
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _getTouristId() async {
    touristId = await getTouristIdByUserId(widget.user.userId);
  }

  _getVisitedLocations() async {
    visitedLocations = await getAllVisitedLocations(touristId!);
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
              'Your Visited Locations',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: Column(children: [
          const SizedBox(height: 10,),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: visitedLocations.length,
                    itemBuilder: (context, index) {
                      final visitedLocation = visitedLocations[index];
                      return FutureBuilder<Location?>(
                          future: _getLocationById(visitedLocation.locationId),
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VisitedLocationDetailsScreen(
                                            user: widget.user,
                                            visitedLocation: visitedLocation,
                                            location: location
                                          )));
                                },
                                child: Column(children: [
                                  const SizedBox(height: 10,),
                                  Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 49, 50, 102),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Location name: ${location!.name}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),]
                              ));
                            }
                            
                          });
                    },
                  ),
          ),
        ]));
  }
}
