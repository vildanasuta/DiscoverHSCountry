import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/location_subcategory_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image/image.dart' as img;

class NewLocation extends StatefulWidget {
  final User? user;
  final String? userType;
  const NewLocation({super.key, required this.user, required this.userType});

  @override
  State<NewLocation> createState() => _NewLocationState();
}

class _NewLocationState extends State<NewLocation> with DataFetcher {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AuthenticationService authService = AuthenticationService();
  String? locationCoverImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController facebookUrlController = TextEditingController();
  final TextEditingController instagramUrlController = TextEditingController();
  final TextEditingController bookingUrlController = TextEditingController();

  City? selectedCity;
  LocationCategory? selectedCategory;
  LocationSubcategory? selectedSubcategory;
  int selectedCityId = 0;
  int selectedCategoryId = 0;
  int selectedSubcategoryId = 0;
  List<City> cities = [];
  List<LocationCategory> categories = [];
  List<LocationSubcategory> subcategories = [];
  Map<String, int> cityIdMap = {};
  Map<String, int> categoryIdMap = {};
  int? taoId;

  @override
  void initState() {
    super.initState();
    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
      });
    }).catchError((error) {
      // Handle error
    });

    fetchLocationCategories(
            widget.userType == 'touristattractionowner' ? true : false)
        .then((fetchedCategories) {
      setState(() {
        categories = fetchedCategories;
      });
    }).catchError((error) {
      // Handle error
    });

    if (widget.userType == 'touristattractionowner') {
      getTAOid();
    }
  }

  void getTAOid() async {
    taoId = await getTouristAttractionOwnerIdByUserId(widget.user!.userId);
  }

  Map<String, String> categoryTranslations = {
    "Historical & Religious Sites": "Historijski i vjerski lokaliteti",
    "Natural Landmarks": "Prirodne znamenitosti",
    "Hospitality Spots": "Gostoprimstvo",
    "Adventure and Sports": "Avantura i sport",
    "Shopping": "Kupovina",
    "Other": "Drugo"
  };

  Map<String, String> subcategoryTranslations = {
    "Old Towns and Fortresses": "Stari gradovi i tvrđave",
    "UNESCO World Heritage Sites": "UNESCO svjetska baština",
    "Religious Sites": "Vjerski lokaliteti",
    "Ottoman Architecture": "Osmanska arhitektura",
    "Medieval Monuments": "Srednjovjekovni spomenici",
    "Mountains": "Planine",
    "Rivers": "Rijeke",
    "Lakes": "Jezera",
    "Waterfalls": "Vodopadi",
    "Caves": "Pećine",
    "Cafes": "Kafići",
    "Restaurants": "Restorani",
    "Hotels": "Hoteli",
    "Apartments": "Apartmani",
    "Rafting": "Rafting",
    "Hiking": "Planinarenje",
    "Parasailing and Paragliding": "Parasailing i paragliding",
    "Skiing": "Skijanje",
    "Shops/Boutiques": "Prodajna mjesta/butici",
    "Unique Souvenirs": "Suvenirnice",
    "Local Produce": "Lokalni proizvodi",
    "Not specified": "Nije definisano"
  };

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
                                  'Dodaj turističku atrakciju',
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
                                                        labelText: 'Ime',
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
                                                    const SizedBox(height: 16),
                                                    FormBuilderTextField(
                                                      name: 'description',
                                                      controller:
                                                          descriptionController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Opis',
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
                                                        FormBuilderValidators
                                                            .maxLength(200,
                                                                errorText:
                                                                    'Opis može sadržavati maximalno 200 karaktera.')
                                                      ]),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    TextFormField(
                                                      controller:
                                                          addressController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Adresa',
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
                                                                    'Adresa mora sadržavati minimalno 3 karaktera.'),
                                                      ]),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    DropdownButtonFormField<String>(
                                                      validator:  FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),]),
                                                      value: selectedCity !=
                                                              null
                                                          ? selectedCity!.name
                                                          : null,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedCity =
                                                              cities.firstWhere(
                                                                  (city) =>
                                                                      city.name ==
                                                                      newValue);
                                                          selectedCityId =
                                                              cityIdMap[
                                                                  newValue]!;
                                                        });
                                                      },
                                                      items: cities.map((city) {
                                                        cityIdMap[city.name] =
                                                            city.id;
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: city.name,
                                                          child:
                                                              Text(city.name),
                                                        );
                                                      }).toList(),
                                                      hint: const Text(
                                                          'Izaberi grad (obavezno polje)'),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    TextButton(
                                                      child: const Text(
                                                          'Ako grad nije na listi, klikni da dodaš isti',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                      onPressed: () => {
                                                        showCityDialog(context)
                                                      },
                                                    ),
                                                    const SizedBox(height: 16),
                                                    DropdownButtonFormField<String>(
                                                      validator:  FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),]),
                                                      value: selectedCategory !=
                                                              null
                                                          ? categoryTranslations[
                                                              selectedCategory!
                                                                  .name]
                                                          : null,
                                                      onChanged:
                                                          (newValue) async {
                                                        final newCategory =
                                                            categories
                                                                .firstWhere(
                                                          (category) =>
                                                              categoryTranslations[
                                                                  category
                                                                      .name] ==
                                                              newValue,
                                                        );
                                                        final newCategoryId =
                                                            categoryIdMap[
                                                                newCategory
                                                                    .name]!;

                                                        List<LocationSubcategory>
                                                            fetchedSubcategories =
                                                            await fetchLocationSubcategories(
                                                                newCategoryId);

                                                        setState(() {
                                                          selectedCategory =
                                                              newCategory;
                                                          selectedCategoryId =
                                                              newCategoryId;
                                                          subcategories =
                                                              fetchedSubcategories;
                                                          selectedSubcategory =
                                                              null; // Reset the selected subcategory
                                                        });
                                                      },
                                                      items: categories
                                                          .map((category) {
                                                        categoryIdMap[
                                                                category.name] =
                                                            category.id;
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: categoryTranslations[
                                                                  category
                                                                      .name] ??
                                                              category.name,
                                                          child: Text(
                                                              categoryTranslations[
                                                                      category
                                                                          .name] ??
                                                                  category
                                                                      .name),
                                                        );
                                                      }).toList(),
                                                      hint: const Text(
                                                          'Izaberi kategoriju (obavezno polje)'),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    DropdownButtonFormField<
                                                        LocationSubcategory>(
                                                          validator:  FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(
                                                                  errorText:
                                                                      'Ovo polje je obavezno!'),]),
                                                      value:
                                                          selectedSubcategory,
                                                      onChanged:
                                                          (newSubcategory) {
                                                        setState(() {
                                                          selectedSubcategory =
                                                              newSubcategory;
                                                        });
                                                      },
                                                      items: subcategories
                                                          .map((subcategory) {
                                                        return DropdownMenuItem<
                                                            LocationSubcategory>(
                                                          value: subcategory,
                                                          child: Text(
                                                              subcategoryTranslations[
                                                                      subcategory
                                                                          .name] ??
                                                                  subcategory
                                                                      .name),
                                                        );
                                                      }).toList(),
                                                      hint: const Text(
                                                          'Izaberi potkategoriju (obavezno polje)'),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    FormBuilderTextField(
                                                      name: 'facebookUrl',
                                                      controller:
                                                          facebookUrlController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Facebook URL',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .url(
                                                          errorText:
                                                              'Unesite ispravan URL format.',
                                                        ),
                                                      ]),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    FormBuilderTextField(
                                                      name: 'instagramUrl',
                                                      controller:
                                                          instagramUrlController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Instagram URL',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .url(
                                                          errorText:
                                                              'Unesite ispravan URL format.',
                                                        ),
                                                      ]),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    FormBuilderTextField(
                                                      name: 'bookingUrl',
                                                      controller:
                                                          bookingUrlController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Booking URL',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      validator:
                                                          FormBuilderValidators
                                                              .compose([
                                                        FormBuilderValidators
                                                            .url(
                                                          errorText:
                                                              'Unesite ispravan URL format.',
                                                        ),
                                                      ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        FilePickerResult?
                                                            result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                          type: FileType.image,
                                                        );

                                                        if (result != null &&
                                                            result.files
                                                                .isNotEmpty) {
                                                          PlatformFile file =
                                                              result
                                                                  .files.first;
                                                          File imageFile =
                                                              File(file.path!);
                                                          Uint8List imageBytes =
                                                              await imageFile
                                                                  .readAsBytes();
                                                          img.Image
                                                              resizedImage =
                                                              img.decodeImage(
                                                                  imageBytes)!;
                                                          int maxWidth = 800;
                                                          img.Image
                                                              smallerImage =
                                                              img.copyResize(
                                                                  resizedImage,
                                                                  width:
                                                                      maxWidth);

                                                          List<int>
                                                              smallerImageBytes =
                                                              img.encodeJpg(
                                                                  smallerImage);

                                                          String base64Image =
                                                              base64Encode(
                                                                  smallerImageBytes);
                                                          setState(() {
                                                            locationCoverImage =
                                                                base64Image;
                                                          });
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                      ),
                                                      child: const Row(
                                                        children: [
                                                          Icon(Icons
                                                              .upload_file),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              'Izaberite naslovnu fotografiju lokacije!')
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 32),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          Location newLocation = Location(
                                                              name: nameController
                                                                  .text,
                                                              description:
                                                                  descriptionController
                                                                      .text,
                                                              coverImage: locationCoverImage
                                                                  .toString(),
                                                              address:
                                                                  addressController
                                                                      .text,
                                                              cityId:
                                                                  selectedCityId,
                                                              locationCategoryId:
                                                                  selectedCategoryId,
                                                              locationSubcategoryId:
                                                                  selectedSubcategory!
                                                                      .id,
                                                              touristAttractionOwnerId:
                                                                  widget.userType ==
                                                                          'touristattractionowner'
                                                                      ? taoId
                                                                      : null,
                                                              facebookUrl:
                                                                  facebookUrlController
                                                                      .text,
                                                              instagramUrl:
                                                                  instagramUrlController
                                                                      .text,
                                                              bookingUrl:
                                                                  bookingUrlController
                                                                      .text,
                                                              isApproved: widget
                                                                          .userType ==
                                                                      'touristattractionowner'
                                                                  ? false
                                                                  : true);
                                                          var url = Uri.parse(
                                                              '${ApiConstants.baseUrl}/Location');
                                                          var response =
                                                              await makeAuthenticatedRequest(
                                                            url,
                                                            'POST',
                                                            body: newLocation
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
                                                                        'Uspješno kreirana lokacija.'),
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
                                                                        child: const Text(
                                                                            'Idi na Dashboard'),
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
                                                                        'Lokacija nije uspješno dodana. Provjerite polja za unos.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'OK'),
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        }
                                                      },
                                                      child:
                                                          const Text('Nastavi'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]),
                                ),
                              )
                            ]))))));
  }

  showCityDialog(var context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Dodaj grad'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Ime grada'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageController,
                  decoration:
                      const InputDecoration(labelText: 'URL fotografije grada'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String cityName = nameController.text;
                  String imageUrl = imageController.text;
                  Map<String, dynamic> newCity = {
                    'name': cityName,
                    'coverImage': imageUrl,
                  };
                  var url = Uri.parse('${ApiConstants.baseUrl}/City');
                  var response = await makeAuthenticatedRequest(
                    url,
                    'POST',
                    body: newCity,
                  );
                  if (response.statusCode == 200) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text('Uspješno dodan grad.'),
                        );
                      },
                    );

                    fetchCities().then((fetchedCities) {
                      setState(() {
                        cities = fetchedCities;
                      });
                    }).catchError((error) {
                      // Handle error
                    });
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: const Text('Dodaj'),
              ),
            ],
          );
        });
  }
}
