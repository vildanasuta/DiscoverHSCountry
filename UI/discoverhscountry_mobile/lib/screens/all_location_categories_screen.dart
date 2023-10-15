import 'dart:ui';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_category_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/location_subcategories_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AllLocationCategoriesScreen extends StatefulWidget {
  User user;
  AllLocationCategoriesScreen({super.key, required this.user});

  @override
  State<AllLocationCategoriesScreen> createState() =>
      _AllLocationCategoriesScreenState();
}

class _AllLocationCategoriesScreenState
    extends State<AllLocationCategoriesScreen> with DataFetcher {
  List<LocationCategory> locationCatgeories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocationCategories();
  }

  Future<void> _fetchLocationCategories() async {
    await fetchLocationCategories().then((value) => {
      setState(()
      {
        locationCatgeories = value;
        isLoading = false;
      })
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
              'Location categories',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: Column(children: [
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
                    itemCount: locationCatgeories.length,
                    itemBuilder: (context, index) {
                      final locationCategory = locationCatgeories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LocationSubcategoriesScreen(
                                    user: widget.user,
                                    categoryId: locationCategory.id,
                                    categoryName: locationCategory.name,
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
                                Image.network(
                                  locationCategory.coverImage,
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
                                        locationCategory.name.toUpperCase(),
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
