import 'dart:convert';

import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/technical_issue_owner.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class ReportProblem extends StatefulWidget {
  final User? user;
  const ReportProblem({super.key, this.user});

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthenticationService authService = AuthenticationService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          isLoggedIn: true,
          user: widget.user,
          userType: 'touristattractionowner',
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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Text(
                                  'Prijavi problem',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              FormBuilder(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 400),
                                                child: Card(
                                                    color: Colors.white,
                                                    elevation: 50,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
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
                                                                      'Naslov',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                ),
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .compose([
                                                                  FormBuilderValidators
                                                                      .required(
                                                                          errorText:
                                                                              'Ovo polje je obavezno!'),
                                                                  FormBuilderValidators
                                                                      .minLength(
                                                                          3,
                                                                          errorText:
                                                                              'Naslov mora sadržavati minimalno 3 karaktera.'),
                                                                ]),
                                                              ),
                                                              const SizedBox(
                                                                  height: 16),
                                                              FormBuilderTextField(
                                                                name:
                                                                    'description',
                                                                controller:
                                                                    descriptionController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Opis',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                ),
                                                                validator:
                                                                    FormBuilderValidators
                                                                        .compose([
                                                                  FormBuilderValidators
                                                                      .required(
                                                                          errorText:
                                                                              'Ovo polje je obavezno!'),
                                                                  FormBuilderValidators
                                                                      .minLength(
                                                                          3,
                                                                          errorText:
                                                                              'Opis mora sadržavati minimalno 3 karaktera.'),
                                                                ]),
                                                              ),
                                                              const SizedBox(
                                                                  height: 32),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    TechnicalIssueOwner
                                                                        newIssue =
                                                                        TechnicalIssueOwner(
                                                                      title: titleController
                                                                          .text,
                                                                      description:
                                                                          descriptionController
                                                                              .text,
                                                                      touristAttractionOwnerId: widget
                                                                          .user!
                                                                          .userId,
                                                                    );
                                                                    var url = Uri
                                                                        .parse(
                                                                            '${ApiConstants.baseUrl}/TechnicalIssueOwner');
                                                                    var response =
                                                                        await http
                                                                            .post(
                                                                      url,
                                                                      headers: {
                                                                        'Content-Type':
                                                                            'application/json',
                                                                      },
                                                                      body: jsonEncode(
                                                                          newIssue
                                                                              .toJson()),
                                                                    );
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      // ignore: use_build_context_synchronously
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: const Text('Uspješno prijavljen problem.'),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).push(
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => DashboardTouristAttractionOwner(user: widget.user, userType: 'touristattractionowner'),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  child: const Text('Idi na Dashboard'),
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
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: const Text('Problem nije prijavljen. Provjerite polja za unos.'),
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
                                                                    'Nastavi'),
                                                              ),
                                                            ]))))
                                          ])))
                            ]))))));
  }
}
