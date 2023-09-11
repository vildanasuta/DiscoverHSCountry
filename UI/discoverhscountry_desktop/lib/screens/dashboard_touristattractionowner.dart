import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/generate_report.dart';
import 'package:discoverhscountry_desktop/screens/new_event.dart';
import 'package:discoverhscountry_desktop/screens/new_location.dart';
import 'package:discoverhscountry_desktop/screens/report_problem.dart';
import 'package:discoverhscountry_desktop/screens/view_reservations.dart';
import 'package:discoverhscountry_desktop/screens/view_reviews.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class DashboardTouristAttractionOwner extends StatefulWidget {
  final User? user;
  final String? userType;
  const DashboardTouristAttractionOwner({super.key, required this.user, required this.userType});

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
        userType: widget.userType,
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewLocation(user: widget.user, userType: widget.userType)));
                    }
                    else if(label=='Dodaj novi događaj'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewEvent(user: widget.user, userType: widget.userType)));
                    }
                    else if(label=='Generiši izvještaj'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GenerateReport(user: widget.user)));
                    }
                    else if(label=='Pogledaj rezervacije'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewReservations(user: widget.user)));
                    }
                    else if(label=='Pogledaj recenzije'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewReviews(user: widget.user)));
                    }
                    else if(label=='Prijavi problem'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ReportProblem(user: widget.user)));
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



