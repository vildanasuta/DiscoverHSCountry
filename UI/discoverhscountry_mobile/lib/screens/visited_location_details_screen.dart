import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_image_model.dart';
import 'package:discoverhscountry_mobile/models/visited_location_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VisitedLocationDetailsScreen extends StatefulWidget {
  User user;
  VisitedLocation visitedLocation;
  Location location;
  VisitedLocationDetailsScreen(
      {super.key,
      required this.user,
      required this.visitedLocation,
      required this.location});

  @override
  State<VisitedLocationDetailsScreen> createState() =>
      _VisitedLocationDetailsScreenState();
}

class _VisitedLocationDetailsScreenState
    extends State<VisitedLocationDetailsScreen> with DataFetcher {
  bool isLoading = true;
  List<VisitedLocationImage> visitedLocationImages = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getImagesForVisitedLocation().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  _getImagesForVisitedLocation() async {
    visitedLocationImages = await getVisitedLocationImages(
        widget.visitedLocation.visitedLocationId!);
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
              'Your visited location: ${widget.location.name}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: Column(
          children: [
            const SizedBox(height: 10,),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                reverse: false,
                autoPlay: visitedLocationImages.length>1?true:false,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1,
              ),
              items: visitedLocationImages.map((image) {
                return Image.memory(
                  base64.decode(image.image),
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            Container(
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey), 
    borderRadius: BorderRadius.circular(10), 
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Visited Date: ${widget.visitedLocation.visitDate.day}/${widget.visitedLocation.visitDate.month}/${widget.visitedLocation.visitDate.year}',
        style: Theme.of(context)
            .textTheme
            .displaySmall
            ?.copyWith(color: Colors.black),
      ),
      const SizedBox(height: 16),
      Text(
        'Notes: ${widget.visitedLocation.notes}',
        style: Theme.of(context)
            .textTheme
            .displaySmall
            ?.copyWith(color: Colors.black),
      ),
    ],
  ),
)

          ],
        ));
  }
}
