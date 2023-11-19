import 'dart:ui';

import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/approve_new_location.dart';
import 'package:discoverhscountry_desktop/screens/new_event.dart';
import 'package:discoverhscountry_desktop/screens/new_historical_story.dart';
import 'package:discoverhscountry_desktop/screens/new_location.dart';
import 'package:discoverhscountry_desktop/screens/new_public_city_service.dart';
import 'package:discoverhscountry_desktop/screens/view_reported_issues.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class DashboardAdmin extends StatefulWidget {
  final User? user;
  final String? userType;
  const DashboardAdmin({super.key, required this.user, required this.userType});


  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final AuthenticationService authService = AuthenticationService();
  final List<String> buttonLabels = [
    'Dodaj novu lokaciju',
    'Dodaj novi događaj',
    'Dodaj novu historijsku priču',
    'Dodaj novi javni gradski servis',
    'Odobri nove lokacije',
    'Pogledaj prijavljene probleme',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        isLoggedIn: true,
        user: widget.user,
        userType: widget.userType,
        onLogout: () async {
          await authService.logout(); // Call logout from the service
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        },
      ),
      body: Stack(
          children: <Widget>[
            Image.asset(
              'assets/desktop-background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          Center(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: buttonLabels.map((label) {

        return SizedBox(
          width: MediaQuery.of(context).size.width / 4 - 16,
          child: ElevatedButton(
                  onPressed: () {
                    if (label == 'Dodaj novu lokaciju') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewLocation(user: widget.user, userType: widget.userType)));
                    } else if (label == 'Dodaj novi događaj') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewEvent(user: widget.user, userType: widget.userType)));
                    } else if (label == 'Dodaj novu historijsku priču') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewHistoricalStory(user: widget.user, userType: widget.userType)));
                    } else if (label == 'Odobri nove lokacije') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ApproveNewLocation(user: widget.user, userType: widget.userType)));
                    } else if (label == 'Pogledaj prijavljene probleme') {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewReportedIssues(user: widget.user, userType: widget.userType)));
                    } else if (label == 'Dodaj novi javni gradski servis'){
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => NewPublicCityService(user: widget.user, userType: widget.userType))));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 200),
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    width: 400,
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ));
              }).toList(),
            ),
          ),
        ),]
      ),
    );
  }
}
