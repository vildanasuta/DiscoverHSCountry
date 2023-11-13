import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class ApproveNewLocation extends StatefulWidget {
  final User? user;
  final String? userType;
  const ApproveNewLocation(
      {super.key, required this.user, required this.userType});

  @override
  State<ApproveNewLocation> createState() => _ApproveNewLocationState();
}

class _ApproveNewLocationState extends State<ApproveNewLocation>
    with DataFetcher {
  final AuthenticationService authService = AuthenticationService();
  List<Location> disapprovedLocations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllDisapprovedLocations().then((fetchedDisapprovedLocations) {
      setState(() {
        disapprovedLocations = fetchedDisapprovedLocations;
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
          padding: const EdgeInsets.all(40.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Nove lokacije koje čekaju odobrenje",
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
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: disapprovedLocations.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 30.0);
                    },
                    itemBuilder: (context, index) {
                      final location = disapprovedLocations[index];
                      return Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              location.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            leading: CircleAvatar(
                              radius: 70,
                              backgroundImage: MemoryImage(
                                  base64Decode(location.coverImage)),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _showLocationDetailsDialog(location);
                              },
                              child: const Text(
                                "Pogledaj detalje",
                                style: TextStyle(),
                              ),
                            ),
                          ));
                    },
                  ),
          ]),
        )),
      )),
    );
  }

  void _showLocationDetailsDialog(Location location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(location.name),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left side for the cover image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      MemoryImage(base64Decode(location.coverImage)),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Opis:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(location.description),
                    const Text("Adresa:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(location.address),
                    _buildUrlText("Facebook URL:", location.facebookUrl),
                    _buildUrlText("Instagram URL:", location.instagramUrl),
                    _buildUrlText("Booking URL:", location.bookingUrl),
                  ],
                ),
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
                final response = await makeAuthenticatedRequest(
                  Uri.parse(
                      '${ApiConstants.baseUrl}/Location/Approve/${location.locationId}'),
                  'PUT',
                );
                if (response.statusCode == 200) {
                  // ignore: use_build_context_synchronously
                  Flushbar(
                    message: "Uspješno odobrena lokacija",
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ).show(context);
                  // ignore: use_build_context_synchronously
                  Future.delayed(const Duration(milliseconds: 3500), () async {
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ApproveNewLocation(
                            user: widget.user, userType: widget.userType))));
                  });
                }
              },
              child: const Text("Odobri lokaciju"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final response = await makeAuthenticatedRequest(
                  Uri.parse(
                      '${ApiConstants.baseUrl}/Location/DeleteById/${location.locationId}'),
                  'DELETE',
                );
                if (response.statusCode == 200) {
                  // ignore: use_build_context_synchronously
                  Flushbar(
                    message: "Lokacija je obrisana",
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ).show(context);
                  // ignore: use_build_context_synchronously
                  Future.delayed(const Duration(milliseconds: 3500), () async {
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ApproveNewLocation(
                            user: widget.user, userType: widget.userType))));
                  });
                }
              },
              child: const Text("Obriši lokaciju"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUrlText(String label, String? url) {
    if (url != null && url.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          InkWell(
            onTap: () {
              launchURL(url);
            },
            child: Text(
              url,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
