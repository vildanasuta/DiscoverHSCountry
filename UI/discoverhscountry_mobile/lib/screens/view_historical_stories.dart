import 'dart:convert';
import 'dart:ui';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/historical_story_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/view_historical_story_details.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewHistoricalStories extends StatefulWidget {
  User user;
  ViewHistoricalStories({super.key, required this.user});

  @override
  State<ViewHistoricalStories> createState() =>
      _ViewHistoricalStoriesState();
}

class _ViewHistoricalStoriesState extends State<ViewHistoricalStories>
    with DataFetcher {
  bool isLoading = true;
  List<HistoricalStory> historicalStories = [];
  List<City> cityList = [];
  int? selectedCityId;

  @override
  void initState() {
    super.initState();
    _getAllHistoricalEvents();
  }

bool _disposed = false;

@override
void dispose() {
  _disposed = true;
  super.dispose();
}

_getAllHistoricalEvents() async {
  try {
    historicalStories = await getAllHistoricalEvents();
    if (_disposed) {
      return; 
    }

    if (selectedCityId == null) {
      historicalStories = historicalStories;
    } else {
      List<HistoricalStory> newList = [];
      for (var service in historicalStories) {
        if (service.cityId == selectedCityId) {
          newList.add(service);
        }
      }
      if (!_disposed) {
        historicalStories = newList;
      }
    }

    cityList = await fetchCities();
    if (!_disposed) {
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    if (!_disposed) {
      // ignore: avoid_print
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}

  loadWithDelay() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _getAllHistoricalEvents();
      });
    });
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
              'Historical Events',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: Column(children: [
          DropdownButton<int>(
            value: selectedCityId,
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text("Choose a city"), // Placeholder text
              ),
              ...cityList.map((City city) {
                return DropdownMenuItem<int>(
                  value: city.cityId,
                  child: Text(city.name),
                );
              }).toList(),
            ],
            onChanged: (int? cityId) async {
              setState(() {
                selectedCityId = cityId;
              });
              await loadWithDelay();
            },
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: historicalStories.length,
                    itemBuilder: (context, index) {
                      final historicalStory = historicalStories[index];
                      // ignore: unnecessary_null_comparison
                      var image = historicalStory.coverImage=="null" || historicalStory.coverImage==null ?Image.network("https://img.freepik.com/premium-vector/stylized-simple-outline-map-bosnia-herzegovina-icon-blue-sketch-map-bosnia-herzegovina-vector-illustration_160901-3633.jpg?w=360",  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,):Image.memory(
                                  base64.decode(historicalStory.coverImage!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                      return GestureDetector(
                        onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewHistoricalStoryDetails(
                                    user: widget.user,
                                    historicalStory: historicalStory,
                                  )));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                image,
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)
                                        .withOpacity(0.2),
                                    child: Center(
                                      child: Text(
                                        historicalStory.title.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ]));
  }
}
