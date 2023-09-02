import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/new_location.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class DashboardTouristAttractionOwner extends StatefulWidget {
  final User? user;

  const DashboardTouristAttractionOwner({super.key, required this.user});

  @override
  State<DashboardTouristAttractionOwner> createState() =>
      _DashboardTouristAttractionOwnerState();
}

class _DashboardTouristAttractionOwnerState extends State<DashboardTouristAttractionOwner> {
  final AuthenticationService authService = AuthenticationService();

  final List<String> buttonLabels = [
    'Dodaj novu lokaciju',
    'Dodaj novi događaj',
    'Generiši izvještaj',
    'Pogledaj rezervacije',
    'Pogledaj recenzije',
    'Prijavi problem',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        isLoggedIn: true,
        user: widget.user,
        onLogout: () async {
          await authService.logout(); // Call logout from the service
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0054A6), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: buttonLabels.map((label) {
                return ElevatedButton(
                  onPressed: () {
                    if(label=='Dodaj novu lokaciju'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewLocation(user: widget.user)));
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
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}



