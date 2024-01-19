import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/all_cities_screen.dart';
import 'package:discoverhscountry_mobile/screens/all_events_screen.dart';
import 'package:discoverhscountry_mobile/screens/all_location_categories_screen.dart';
import 'package:discoverhscountry_mobile/screens/dashboard_screen.dart';
import 'package:discoverhscountry_mobile/screens/edit_profile_screen.dart';
import 'package:discoverhscountry_mobile/screens/login_screen.dart';
import 'package:discoverhscountry_mobile/screens/report_an_issue_screen.dart';
import 'package:discoverhscountry_mobile/screens/view_historical_stories.dart';
import 'package:discoverhscountry_mobile/screens/view_my_reservations.dart';
import 'package:discoverhscountry_mobile/screens/visited_locations_screen.dart';
import 'package:discoverhscountry_mobile/screens/visitor_services_hub_screen.dart';
import 'package:discoverhscountry_mobile/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TouristDrawer extends StatefulWidget {
  User user;
  TouristDrawer({super.key, required this.user});

  @override
  State<TouristDrawer> createState() => _TouristDrawerState();
}

class _TouristDrawerState extends State<TouristDrawer> {
  final AuthenticationService authService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 2, 89, 0.8),
              ),
              child: Text(
                'Menu',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.home,
              color: Colors.black,
            ),
            title: Text(
              'Home',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => DashboardScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.profile_circled,
              color: Colors.black,
            ),
            title: Text(
              'My profile',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => EditProfile(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.calendar,
              color: Colors.black,
            ),
            title: Text(
              'View my Reservations',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ViewMyReservations(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.location_circle,
              color: Colors.black,
            ),
            title: Text(
              'Cities',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AllCitiesScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.calendar,
              color: Colors.black,
            ),
            title: Text(
              'Events',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AllEventsScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.folder,
              color: Colors.black,
            ),
            title: Text(
              'Location Categories',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                  ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AllLocationCategoriesScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.arrow_counterclockwise_circle,
              color: Colors.black,
            ),
            title: Text(
              'Visited Locations',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
               Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => VisitedLocationsScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
            title: Text(
              'Visitor Services Hub',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => VisitorServicesHubScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.news,
              color: Colors.black,
            ),
            title: Text(
              'View Historical Stories',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
             Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ViewHistoricalStories(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.gear,
              color: Colors.black,
            ),
            title: Text(
              'Report an Issue',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
             Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ReportAnIssueScreen(user: widget.user)));
            },
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                authService.logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const LoginScreen())));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(255, 1, 1, 0.5),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(255, 255, 255, 1),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), 
                  ),
                ),
              ),
              child: const Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }
}
