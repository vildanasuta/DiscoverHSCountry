import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/all_cities_screen.dart';
import 'package:discoverhscountry_mobile/screens/dashboard_screen.dart';
import 'package:discoverhscountry_mobile/screens/edit_profile_screen.dart';
import 'package:discoverhscountry_mobile/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TouristDrawer extends StatefulWidget {
  User? user;
  TouristDrawer({super.key, this.user});

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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfile(user: widget.user)));
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AllCitiesScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.folder,
              color: Colors.black,
            ),
            title: Text(
              'Location categories',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                  ),
            ),
            onTap: () {
              /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfile(user: widget.user)));*/
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
              /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfile(user: widget.user)));*/
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
              /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfile(user: widget.user)));*/
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.gear,
              color: Colors.black,
            ),
            title: Text(
              'Report an issue',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.black),
            ),
            onTap: () {
              /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfile(user: widget.user)));*/
            },
          ),
          const SizedBox(
            height: 170,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // Adjust padding as needed
            child: ElevatedButton(
              onPressed: () {
                authService.logout();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(255, 1, 1, 0.5), // Semi-transparent red
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(255, 255, 255, 1), // White text color
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Adjust border radius
                  ),
                ),
              ),
              child: const Text('Log out'),
            ),
          )
        ],
      ),
    );
  }
}