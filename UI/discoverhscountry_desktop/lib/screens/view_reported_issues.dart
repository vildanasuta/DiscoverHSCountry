import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_owner.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_tourist.dart';
import 'package:discoverhscountry_desktop/models/tourist_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewReportedIssues extends StatefulWidget {
  final User? user;
  final String? userType;
  const ViewReportedIssues(
      {super.key, required this.user, required this.userType});

  @override
  State<ViewReportedIssues> createState() => _ViewReportedIssuesState();
}

class _ViewReportedIssuesState extends State<ViewReportedIssues>
    with DataFetcher {
  List<TechnicalIssueOwner> technicalIssuesOwner = [];
  List<TechnicalIssueTourist> technicalIssuesTourist = [];
  final AuthenticationService authService = AuthenticationService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.wait([
      fetchAllTechnicalIssuesOwner(),
      fetchAllTechnicalIssuesTourist(),
    ]).then((List<dynamic> results) {
      setState(() {
        technicalIssuesOwner = results[0];
        technicalIssuesTourist = results[1];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          isLoggedIn: true,
          user: widget.user,
          userType: widget.userType,
          onLogout: () async {
            await authService.logout();
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FirstPage()),
            );
          },
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Prijavljeni problemi vlasnika turističkih atrakcija",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 16, 40, 107),
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: technicalIssuesOwner.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(
                                          technicalIssuesOwner[index].title),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          _showDetailsOwnerDialog(
                                              technicalIssuesOwner[index]);
                                        },
                                        child: const Text(
                                          "Pogledaj detalje",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Prijavljeni problemi turista",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(
                                      color: Color.fromARGB(255, 16, 40, 107),
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: technicalIssuesTourist.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(
                                          technicalIssuesTourist[index].title),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          _showDetailsTouristDialog(
                                              technicalIssuesTourist[index]);
                                        },
                                        child: const Text(
                                          "Pogledaj detalje",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ))));
  }

  void _showDetailsOwnerDialog(TechnicalIssueOwner technicalIssueOwner) async {
    var tao = await getTouristAttractionOwnerById(
        technicalIssueOwner.touristAttractionOwnerId!);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(technicalIssueOwner.title),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Opis:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(technicalIssueOwner.description),
                      const Text(
                          "Ime i prezime vlasnika turističkih atrakcija:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${tao.firstName} ${tao.lastName}'),
                       const Text(
                          "Kontakt:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(tao.email),
                    ]),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final response = await http.delete(Uri.parse(
                    '${ApiConstants.baseUrl}/TechnicalIssueOwner/${technicalIssueOwner.tehnicalIssueOwnerId}'));
                if (response.statusCode == 200) {
                  // ignore: use_build_context_synchronously
                  Flushbar(
                    message: "Problem je obrisan",
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ).show(context);
                  // ignore: use_build_context_synchronously
                  Future.delayed(const Duration(milliseconds: 3500), () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text("Problem riješen"),
            ),
          ],
        );
      },
    );
  }

    void _showDetailsTouristDialog(TechnicalIssueTourist technicalIssueTourist) async {
    var tourist = await getTouristById(
        technicalIssueTourist.touristId!);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(technicalIssueTourist.title),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Opis:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(technicalIssueTourist.description),
                       const Text(
                          "Ime i prezime vlasnika turiste:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${tourist.firstName} ${tourist.lastName}'),
                      const Text(
                          "Kontakt:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(tourist.email),
                      
                    ]),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final response = await http.delete(Uri.parse(
                    '${ApiConstants.baseUrl}/TechnicalIssueTourist/${technicalIssueTourist.tehnicalIssueTouristId}'));
                if (response.statusCode == 200) {
                  // ignore: use_build_context_synchronously
                  Flushbar(
                    message: "Problem je obrisan",
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ).show(context);
                  // ignore: use_build_context_synchronously
                  Future.delayed(const Duration(milliseconds: 3500), () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text("Problem riješen"),
            ),
          ],
        );
      },
    );
  }
}
