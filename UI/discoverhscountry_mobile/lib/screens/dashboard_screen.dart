import 'dart:convert';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/recommendation_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/location_details_screen.dart';
import 'package:discoverhscountry_mobile/screens/locations_by_city_screen.dart';
import 'package:discoverhscountry_mobile/screens/report_an_issue_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:discoverhscountry_mobile/widgets/search_bar.dart' as sb;
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with DataFetcher {
  List<City> cities = [];
  List<City> searchResults = [];
  bool isLoading = true;
  bool _isSearching = false;
  List<Location> locations = [];

  @override
  void initState() {
    super.initState();
    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
        isLoading = false;
      });
    }).catchError((error) {
      // Handle error
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _endSearch() {
    setState(() {
      _isSearching = false;
      _clearSearch();
    });
  }

  void _clearSearch() {
    setState(() {
      searchResults.clear();
    });
  }

  bool _isCities = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: MemoryImage(
                base64Decode(widget.user.profileImage),
              ),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Hi, ${widget.user.firstName} ${widget.user.lastName}',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: const Color.fromARGB(255, 1, 38, 160)),
            ),
          ],
        ),
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
      ),
      endDrawer: TouristDrawer(user: widget.user),
      body: buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _launchEmail(
                      'support@discoverhscountry.com', 'Support Request', '');
                },
                child: const Text('Contact support'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ReportAnIssueScreen(user: widget.user)));
                },
                child: const Text('Report issue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBody() {
    if (_isCities) {
      return Stack(children: [
        if (!_isSearching)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset('assets/dashboard-welcome.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Where do you want to go?\nExplore now, ${widget.user.firstName}!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: const Color.fromARGB(255, 1, 38, 160)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onTap: _startSearch,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(CupertinoIcons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isCities = true;
                        });
                      },
                      child: const Text('All cities'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        locations = await getRecommendationsForUser();
                        setState(() {
                          _isCities = false;
                        });
                      },
                      child: const Text('Recommended places'),
                    ),
                  ],
                ),
              ),
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LocationsByCity(
                                    city: city,
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Image.network(
                                  city.coverImage,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: const Color.fromARGB(255, 1, 38, 160)
                                        .withOpacity(0.7),
                                    child: Text(
                                      city.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
            ],
          ),
        if (_isSearching)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  sb.SearchBar(
                    cities: cities,
                    onSearch: (results) {
                      setState(() {
                        searchResults = results;
                      });
                    },
                    onCancel: _endSearch,
                  ),
                  if (searchResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final city = searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LocationsByCity(
                                    city: city,
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(city.name),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
      ]);
    } else {
      return Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset('assets/dashboard-welcome.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Where do you want to go?\nExplore now, ${widget.user.firstName}!',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: const Color.fromARGB(255, 1, 38, 160)),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isCities = true;
                      });
                    },
                    child: const Text('All cities'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      locations.clear(); 
                      locations = await getRecommendationsForUser();
                      setState(() async{
                        _isCities = false;
                      });
                    },
                    child: const Text('Recommended places'),
                  ),
                ],
              ),
            ),
            if (!isLoading)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LocationDetailsScreen(
                                  user: widget.user,
                                  location: location,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.memory(
                                base64Decode(location.coverImage),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  color: const Color.fromARGB(255, 1, 38, 160)
                                      .withOpacity(0.7),
                                  child: Text(
                                    location.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),
          ],
        )
      ]);
    }
  }

  void _launchEmail(String toEmail, String subject, String body) async {
    final url = 'mailto:$toEmail?subject=$subject&body=$body';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Location>> getRecommendationsForUser() async {
    List<Recommendation> recommendations =
        await getRecommendationByTouristId(widget.user.userId);
    List<Location> locations = [];
    if (recommendations.isNotEmpty) {
      for (var recommendation in recommendations) {
        var location = await getLocationById(recommendation.locationId);
        if(location!=null){
        locations.add(location);}
      }
    }
    return locations;
  }
}
