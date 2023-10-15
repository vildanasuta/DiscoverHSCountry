import 'dart:ui';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_subcategory_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/locations_by_subcategory_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LocationSubcategoriesScreen extends StatefulWidget {
  User user;
  final int categoryId;
  final String categoryName;
  LocationSubcategoriesScreen(
      {super.key,
      required this.user,
      required this.categoryId,
      required this.categoryName});

  @override
  State<LocationSubcategoriesScreen> createState() =>
      _LocationSubcategoriesScreenState();
}

class _LocationSubcategoriesScreenState
    extends State<LocationSubcategoriesScreen> with DataFetcher {
  List<LocationSubcategory> locationSubcategories = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchLocationSubcategories(widget.categoryId);
  }

  fetchLocationSubcategories(int categoryId) async {
    await fetchSubcategoriesByCategoryId(categoryId).then((value)=>{
        setState(() {
          locationSubcategories=value;
          isLoading=false;
        },)
      }
    );
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
              'Subcategories for ${widget.categoryName}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
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
                    itemCount: locationSubcategories.length,
                    itemBuilder: (context, index) {
                      final locationSubcategory = locationSubcategories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LocationsBySubcategoryScreen(
                                    user: widget.user,
                                    categoryId: widget.categoryId,
                                    subcategoryId: locationSubcategory.id,
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
                                  locationSubcategory.coverImage,
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
                                        locationSubcategory.name.toUpperCase(),
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
