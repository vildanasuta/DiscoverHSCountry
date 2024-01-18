// ignore_for_file: avoid_print

import 'dart:io';

import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/country_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/reservation_model.dart';
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
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:table_calendar/table_calendar.dart';

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
  Map<DateTime, List<Reservation>> reservations = {};
  List<Reservation> allReservations = [];
  bool isLoading = true;
  // ignore: prefer_typing_uninitialized_variables
  var tourist;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Reservation> selectedDayReservations = [];
  List<Country> countries = [];
  int? taoId;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userId = widget.user!.userId;
      final taoId = await getTouristAttractionOwnerIdByUserId(userId);

      if (taoId != null) {
        setState(() {
          this.taoId = taoId;
        });

        final fetchedIds =
            await fetchLocationIdsByTouristAttractionOwnerId(taoId);
        setState(() {
          locationIds = fetchedIds;
        });

        final fetchedLocations = await fetchLocationsByIds(locationIds);

        setState(() {
          locations = fetchedLocations;
        });

        for (int locationId in locationIds) {
          allReservations = await fetchReservationsByLocationId(locationId);
          for (var reservation in allReservations) {
            var details =
                await getReservationDetailsById(reservation.reservationId!);
            for (var detail in details) {
              DateTime reservationDate = detail.startDate;
              if (reservations.containsKey(reservationDate)) {
                reservations[reservationDate]!.add(reservation);
              } else {
                reservations[reservationDate] = [reservation];
              }
            }
          }
        }

        final fetchedCountries = await fetchCountries();
        setState(() {
          countries = fetchedCountries;
        });


        setState(() {
          isLoading = false;
        });
      } else {
        print('Failed to fetch Tourist Attraction Owner ID');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Reservation> _getReservationsForDay(DateTime day) {
    List<Reservation> reservationsOnSelectedDay = [];
    for (var entry in reservations.entries) {
      DateTime eventDate = entry.key;

      if (isSameDay(eventDate, day)) {
        reservationsOnSelectedDay.addAll(entry.value);
      }
    }

    return reservationsOnSelectedDay;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> fetchReservationsForSelectedDay(DateTime selectedDay) async {
    // ignore: await_only_futures
    selectedDayReservations = await _getReservationsForDay(selectedDay);
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
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      StatefulBuilder(builder: (context, setState) {
                        return TableCalendar(
                          calendarFormat: _calendarFormat,
                          focusedDay: _focusedDay,
                          currentDay: _selectedDay,
                          firstDay: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDay:
                              DateTime.now().add(const Duration(days: 365)),
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                          ),
                          eventLoader: _getReservationsForDay,
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          onDaySelected: (selectedDay, focusedDay) async {
                            await fetchReservationsForSelectedDay(selectedDay);
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                            rebuildReservationList();
                          },
                        );
                      }),
                      // ignore: unnecessary_null_comparison
                      _selectedDay != null
                          ? buildReservationList(context)
                          : Container(),
                    ],
                  ),
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

  rebuildReservationList() {
    setState(() {});
  }

  Widget buildReservationList(var context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(child: StatefulBuilder(builder: (context, setState) {
            return ListView.separated(
              itemCount: locations.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final location = locations[index];
                final locationName = location['name'] as String;
                final locationId = location['locationId'] as int;

                final locationReservations = selectedDayReservations
                    .where(
                        (reservation) => reservation.locationId == locationId)
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
                                      future: getTouristById(
                                          reservation.touristId!),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            tourist = snapshot.data!;
                                            final touristName =
                                                '${tourist.firstName} ${tourist.lastName}';
                                            return Center(
                                                child: Text(touristName));
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
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
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReservationDetails(
                                                      user: widget.user!,
                                                      reservation: reservation,
                                                      tourist: tourist)),
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
          }));
  }

  Future<void> showYearSelectionDialog(
      BuildContext context, List<Reservation> allReservations) async {
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

  void generateAndSavePDFReport(
      int year, List<Reservation> allReservations) async {
    List<Tourist> allTourists = [];
    List<Location> allLocations = [];
    Map<int, Map<int, int>> countryTouristCount =
        {}; // Map<LocationId, Map<CountryId, TouristCount>>

    for (var reservation in allReservations) {
      var details = await getReservationDetailsById(reservation.reservationId!);
      for (var d in details) {
        if (d.startDate.year == year) {
          var tourist = await getTouristById(reservation.touristId!);
          allTourists.add(tourist);
          var location = await getLocationById(reservation.locationId!);
          allLocations.add(location);

          if (!countryTouristCount.containsKey(location.locationId)) {
            countryTouristCount[location.locationId!] = {};
          }

          if (!countryTouristCount[location.locationId]!
              .containsKey(tourist.countryId)) {
            countryTouristCount[location.locationId]!
                .putIfAbsent(tourist.countryId, () => 1);
          } else {
            countryTouristCount[location.locationId]!
                .update(tourist.countryId, (value) => value + 1);
          }
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
              pw.Text('Izvjesaj za godinu $year',
                  style: const pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 20),
              // Reservations Table
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
              pw.SizedBox(height: 20),
              // Top Countries Table
              pw.Text(
                  'Turisti najcesce dolaze iz sljedecih drzava za Vase lokacije: ',
                  style: const pw.TextStyle(fontSize: 16)),
              for (var locationId in countryTouristCount.keys)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 5),
                    pw.Text(
                        'Lokacija: ${allLocations.firstWhere((loc) => loc.locationId == locationId).name}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Table.fromTextArray(
                      context: context,
                      headers: ['Drzava', 'Broj turista'],
                      data: countryTouristCount[locationId]!
                          .entries
                          .map((entry) {
                            final country = getCountryById(entry.key);
                            return [country, entry.value.toString()];
                          })
                          .toList()
                          .reversed
                          .toList(),
                    ),
                    pw.SizedBox(height: 10),
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
  
  String getCountryById(int key) {
  var country = countries.firstWhere((element) => element.countryId == key);
  return country.name; 
}


}
