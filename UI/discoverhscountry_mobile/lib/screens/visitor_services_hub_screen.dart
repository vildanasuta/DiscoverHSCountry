import 'dart:convert';
import 'dart:ui';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/public_city_service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/public_city_service_details_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VisitorServicesHubScreen extends StatefulWidget {
  User user;
  VisitorServicesHubScreen({super.key, required this.user});

  @override
  State<VisitorServicesHubScreen> createState() =>
      _VisitorServicesHubScreenState();
}

class _VisitorServicesHubScreenState extends State<VisitorServicesHubScreen>
    with DataFetcher {
  bool isLoading = true;
  List<PublicCityService> publicCityServicesList = [];
  List<City> cityList = [];
  int? selectedCityId;

  @override
  void initState() {
    super.initState();
    _getAllPublicCityServices();
  }

bool _disposed = false;

@override
void dispose() {
  _disposed = true;
  super.dispose();
}

_getAllPublicCityServices() async {
  try {
    publicCityServicesList = await getAllPublicCityServices();
    if (_disposed) {
      return; 
    }

    if (selectedCityId == null) {
      publicCityServicesList = publicCityServicesList;
    } else {
      List<PublicCityService> newList = [];
      for (var service in publicCityServicesList) {
        if (service.cityId == selectedCityId) {
          newList.add(service);
        }
      }
      if (!_disposed) {
        publicCityServicesList = newList;
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

  loadCityServicesWithDelay() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _getAllPublicCityServices();
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
              'Public City Services',
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
              await loadCityServicesWithDelay();
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
                    itemCount: publicCityServicesList.length,
                    itemBuilder: (context, index) {
                      final publicCityService = publicCityServicesList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PublicCityServiceDetailsScreen(
                                    user: widget.user,
                                    publicCityService: publicCityService,
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
                                Image.memory(
                                  base64.decode(publicCityService.coverImage),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    color: const Color.fromRGBO(0, 2, 89, 1.0)
                                        .withOpacity(0.2),
                                    child: Center(
                                      child: Text(
                                        publicCityService.name.toUpperCase(),
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
