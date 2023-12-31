
import 'dart:async';

import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/location_model.dart';
import 'package:discoverhscountry_mobile/models/technical_issue_tourist_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/screens/dashboard_screen.dart';
import 'package:discoverhscountry_mobile/services/authentication_service.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// ignore: depend_on_referenced_packages

class ReportAnIssueScreen extends StatefulWidget {
  final User? user;
  const ReportAnIssueScreen({super.key, this.user});

  @override
  State<ReportAnIssueScreen> createState() => _ReportAnIssueScreenState();
}

class _ReportAnIssueScreenState extends State<ReportAnIssueScreen>
    with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthenticationService authService = AuthenticationService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Location> locations = [];
  int? selectedLocationId;
  @override
  void initState() {
    super.initState();
    _getLocations();
  }

  _getLocations() async {
    locations = await fetchLocations();
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
              'Report an issue',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user!),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          FormBuilder(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 700),
                                            child: Card(
                                                color: Colors.white,
                                                elevation: 50,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          FormBuilderTextField(
                                                            name: 'title',
                                                            controller:
                                                                titleController,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Title',
                                                            ),
                                                            validator:
                                                                FormBuilderValidators
                                                                    .compose([
                                                              FormBuilderValidators
                                                                  .required(
                                                                      errorText:
                                                                          'This field is required!'),
                                                              FormBuilderValidators
                                                                  .minLength(3,
                                                                      errorText:
                                                                          'Headline needs to contain minimum of 3 characters.'),
                                                            ]),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          FormBuilderTextField(
                                                            name: 'description',
                                                            controller:
                                                                descriptionController,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Description',
                                                            ),
                                                            validator:
                                                                FormBuilderValidators
                                                                    .compose([
                                                              FormBuilderValidators
                                                                  .required(
                                                                      errorText:
                                                                          'This field is required!'),
                                                              FormBuilderValidators
                                                                  .minLength(3,
                                                                      errorText:
                                                                          'Description needs to contain minimum of 3 characters.'),
                                                            ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          DropdownButton<int>(
                                                            value:
                                                                selectedLocationId,
                                                            items: [
                                                              DropdownMenuItem<
                                                                  int>(
                                                                value: null,
                                                                child: Text(
                                                                    "Choose a location related (optional)",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall),
                                                              ),
                                                              ...locations.map(
                                                                  (Location
                                                                      location) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: location
                                                                      .locationId,
                                                                  child: Text(
                                                                      location
                                                                          .name),
                                                                );
                                                              }).toList(),
                                                            ],
                                                            onChanged: (int?
                                                                locationId) async {
                                                              setState(() {
                                                                selectedLocationId =
                                                                    locationId;
                                                              });
                                                            },
                                                          ),
                                                          const SizedBox(
                                                              height: 32),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              var idTourist =
                                                                  await getTouristIdByUserId(
                                                                      widget
                                                                          .user!
                                                                          .userId);
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                TechnicalIssueTourist
                                                                    newIssue =
                                                                    TechnicalIssueTourist(
                                                                  title:
                                                                      titleController
                                                                          .text,
                                                                  description:
                                                                      descriptionController
                                                                          .text,
                                                                  touristId:
                                                                      idTourist,
                                                                  locationId:
                                                                      selectedLocationId,
                                                                );
                                                                var url = Uri.parse(
                                                                    '${ApiConstants.baseUrl}/TechnicalIssueTourist');
                                                                final response =
                                                                    await makeAuthenticatedRequest(
                                                                  url,
                                                                  'POST',
                                                                  body: newIssue
                                                                      .toJson(),
                                                                );
                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  // ignore: use_build_context_synchronously
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('You have successfully reported an issue.'),
                                                                          actions: <Widget>[
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pushReplacement(
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => DashboardScreen(user: widget.user!),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: const Text('Go to Dashboard'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      });
                                                                } else {
                                                                  // ignore: use_build_context_synchronously
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Issue is not reported. Check your input fields.'),
                                                                          actions: <Widget>[
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text('OK'),
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                                }
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Continue'),
                                                          ),
                                                        ]))))
                                      ])))
                        ])))));
  }
}
