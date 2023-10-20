import 'dart:io';

import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_service_model.dart';
import 'package:discoverhscountry_desktop/models/service_model.dart';
import 'package:discoverhscountry_desktop/models/tourist_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/reservation_details.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as pp;


class ViewReservations extends StatefulWidget {
  final User? user;
  const ViewReservations({super.key, this.user});

  @override
  State<ViewReservations> createState() => _ViewReservationsState();
}

class _ViewReservationsState extends State<ViewReservations> with DataFetcher {
  final AuthenticationService authService = AuthenticationService();
  List<int> locationIds = [];
  List<Map<String, dynamic>> locations = [];
  List<Reservation> allReservations = [];
  bool isLoading=true;

  int? taoId;
  @override
  void initState() {
    super.initState();
    final userId = widget.user!.userId;
    getTouristAttractionOwnerIdByUserId(userId).then((taoId) {
      if (taoId != null) {
        setState(() {
          taoId = taoId;
        });

        fetchLocationIdsByTouristAttractionOwnerId(taoId!)
            .then((fetchedIds) async {
          setState(() {
            locationIds = fetchedIds;
          });
          return await fetchLocationsByIds(locationIds);
        }).then((fetchedLocations) async {
          setState(() {
            locations = fetchedLocations;
          });
          for (int locationId in locationIds) {
            allReservations = await fetchReservationsByLocationId(locationId);
          }
        }).then((value) => {
          isLoading=false
        });
      } else {
        // ignore: avoid_print
        print('Failed to fetch Tourist Attraction Owner ID');
      }
    });
  }

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
      body: Column(
        children: [
          Expanded(
            child: isLoading?const Center(
              child: CircularProgressIndicator(), // Loading indicator
            ):buildReservationList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showYearSelectionDialog(context, allReservations);
              },
              child: const Text('Generiši izvještaj'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReservationList() {
    return ListView.separated(
      itemCount: locations.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final location = locations[index];
        final locationName = location['name'] as String;
        final locationId = location['locationId'] as int;

        final locationReservations = allReservations
            .where((reservation) => reservation.locationId == locationId)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                locationName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.blueGrey),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 253, 253, 253),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0),
                },
                border: TableBorder.all(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                    ),
                    children: const [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Ime i prezime',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Cijena',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Detalji',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (final reservation in locationReservations)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<Tourist>(
                              future: getTouristById(reservation.touristId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    final tourist = snapshot.data!;
                                    final touristName =
                                        '${tourist.firstName} ${tourist.lastName}';
                                    return Center(child: Text(touristName));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                '${reservation.price.toStringAsFixed(2)} BAM',
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ReservationDetails(user: widget.user!, reservation: reservation)),
          );


                              },
                              child: const Text(
                                'Pogledaj detalje',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const Divider(),
            
          ],
        );
      },
    );
  }


 Future<void> showYearSelectionDialog(BuildContext context, List<Reservation> allReservations) async {
    int? selectedYear;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unesite godinu za izvještaj'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'year',
                decoration: const InputDecoration(
                  labelText: 'Godina',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno!',
                  ),
                ]),
                onChanged: (value) {
                  selectedYear = int.tryParse(value!);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (selectedYear != null) {
                  generateAndSavePDFReport(selectedYear!, allReservations);
                  
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Generiši'),
            ),
          ],
        );
      },
    );
  }

  void generateAndSavePDFReport(int year, List<Reservation> allReservations) async {
    List<Tourist> allTourists = [];
    List<Location> allLocations = [];
   for(var reservation in allReservations){
    var details = await getReservationDetailsById(reservation.reservationId!);
    for(var d in details){
      if(d.startDate.year==year){
         var tourist = await getTouristById(reservation.touristId!);
    allTourists.add(tourist);
    var location = await getLocationById(reservation.locationId!);
    allLocations.add(location);
      }
    }

   }
 final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Izvjestaj za godinu $year', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Lokacija', 'Ime i prezime turiste', 'Cijena'],
              data: [
                for (var i = 0; i < allReservations.length; i++)
                  [
                    allLocations[i].name, 
                    '${allTourists[i].firstName} ${allTourists[i].lastName}', 
                    '${allReservations[i].price.toStringAsFixed(2)} BAM', 
                  ],
              ],
            ),
          ],
        );
      },
    ),
  );

  final result = await FilePicker.platform.saveFile(
    dialogTitle: 'Save PDF Report',
    initialDirectory: await getApplicationDocumentsDirectory(),
    allowedExtensions: ['pdf'],
    fileName: 'reservation_report_$year.pdf',
  );

  if (result != null) {
    final file = File(result);
    await file.writeAsBytes(await pdf.save());
  }


  }
  
 Future<String> getApplicationDocumentsDirectory() async {
  final directory = await pp.getApplicationDocumentsDirectory();
  return directory.path;
}
}




