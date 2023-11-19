
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class AddService extends StatefulWidget {
  User user;
  String userType;
  int? locationId;
  AddService(
      {super.key,
      required this.user,
      required this.userType,
      required this.locationId});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthenticationService authService = AuthenticationService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  double? unitPrice;
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
                              const Center(
                                child: Text(
                                  'Dodaj novu uslugu za lokaciju',
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
                                            constraints: const BoxConstraints(
                                                maxWidth: 400),
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      const Text(
                                                        'Napomena: Opis se popunjava na engleskom jeziku!',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      FormBuilderTextField(
                                                        name: 'name',
                                                        controller:
                                                            nameController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Naziv *',
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
                                                              .minLength(3,
                                                                  errorText:
                                                                      'Naziv mora sadržavati minimalno 3 karaktera.'),
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
                                                          labelText: 'Opis *',
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
                                                              .minLength(3,
                                                                  errorText:
                                                                      'Opis mora sadržavati minimalno 3 karaktera.'),
                                                        ]),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      FormBuilderTextField(
                                                        name: 'unitPrice',
                                                        controller:
                                                            unitPriceController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Cijena po osobi',
                                                          border:
                                                              OutlineInputBorder(),
                                                          suffixText: 'BAM',
                                                        ),
                                                        keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^\d+\.?\d{0,2}')),
                                                        ],
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .numeric(
                                                                  errorText:
                                                                      'Upišite validan broj!'),
                                                        ]),
                                                        onChanged: (value) {
                                                          unitPrice =
                                                              double.tryParse(
                                                                  unitPriceController
                                                                      .text);
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 32),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            Service newService =
                                                                Service(
                                                              serviceName:
                                                                  nameController
                                                                      .text,
                                                              serviceDescription:
                                                                  descriptionController
                                                                      .text,
                                                              unitPrice:
                                                                  unitPrice!,
                                                              locationId: widget
                                                                  .locationId!,
                                                            );
                                                            // ignore: avoid_print
                                                            print(newService
                                                                .toJson());
                                                            var url = Uri.parse(
                                                                '${ApiConstants.baseUrl}/Service');
                                                            var response =
                                                                await makeAuthenticatedRequest(
                                                              url,
                                                              'POST',
                                                              body: newService
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
                                                                      title: const Text(
                                                                          'Uspješno kreirana usluga.'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (widget.userType ==
                                                                                'touristattractionowner') {
                                                                              Navigator.of(context).push(
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => DashboardTouristAttractionOwner(
                                                                                    user: widget.user,
                                                                                    userType: widget.userType,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            } else if (widget.userType ==
                                                                                'administrator') {
                                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                                builder: (context) => DashboardAdmin(user: widget.user, userType: widget.userType),
                                                                              ));
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text('Idi na Dashboard'),
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
                                                                      title: const Text(
                                                                          'Usluga nije uspješno spašena. Provjerite polja za unos.'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('OK'),
                                                                        )
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Spasi uslugu'),
                                                      ),
                                                    ]),
                                              ),
                                            ))
                                      ]),
                                ),
                              )
                            ]))))));
  }
}
