import 'dart:ui';

import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/locations_by_city_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AllCitiesScreen extends StatefulWidget {
  User user;
  AllCitiesScreen({super.key, required this.user});

  @override
  State<AllCitiesScreen> createState() => _AllCitiesScreenState();
}

class _AllCitiesScreenState extends State<AllCitiesScreen> with DataFetcher {
  List<City> cities = [];
  List<City> loadedCities = [];
  List<City> allCities = [];
  int currentPage = 1;
  bool isLoading = false;
  int pageSize = 6;

  Future<void> _fetchCities(int page, int pageSize) async {
    allCities = await fetchCities();
    if (isLoading) {
      return; // Prevent multiple simultaneous requests
    }

    setState(() {
      isLoading = true;
    });

    try {
      final List<City> newCities = await fetchCities(
        page: page,
        pageSize: pageSize,
      );

      setState(() {
        if (newCities.isNotEmpty) {
          newCities.removeWhere((newCity) {
            return cities.any((city) => newCity.cityId == city.cityId);
          });

          cities = newCities;
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching cities: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCities(0, 6); // Load the initial page (page 0)
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
            'All cities',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
      endDrawer: TouristDrawer(user: widget.user),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return buildCityCard(cities[index], index);
              },
            ),
          ),
          buildPaginationRow(),
        ],
      ),
    );
  }

  Widget buildCityCard(City city, int index) {
    if (index % 2 == 0) {
      return Column(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, rowIndex) {
              final cityIndex = index + rowIndex;
              if (cityIndex < cities.length) {
                final city = cities[cityIndex];
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              LocationsByCity(user: widget.user, city: city)));
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
                            Image.network(
                              city.coverImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                              child: Container(
                                color: const Color.fromRGBO(0, 2, 89, 1.0)
                                    .withOpacity(0.2),
                                child: Center(
                                  child: Text(
                                    city.name.toUpperCase(),
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
                    ));
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  int calculateTotalPages(int totalCities, int pageSize) {
    return (totalCities / pageSize).ceil();
  }

  Widget buildPaginationRow() {
    final hasPreviousPage = currentPage > 1;
    final totalPages = calculateTotalPages(allCities.length, pageSize);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: hasPreviousPage
                ? () {
                    _fetchCities(0, pageSize);
                    setState(() {
                      currentPage -= 1;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
            'Page $currentPage of $totalPages',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: currentPage < totalPages
                ? () {
                    _fetchCities(0, pageSize * 2);
                    setState(() {
                      currentPage += 1;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
