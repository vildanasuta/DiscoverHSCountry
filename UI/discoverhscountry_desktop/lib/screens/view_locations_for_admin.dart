import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/city_model.dart';
import 'package:discoverhscountry_desktop/models/location_category_model.dart';
import 'package:discoverhscountry_desktop/models/location_model.dart';
import 'package:discoverhscountry_desktop/models/location_subcategory_model.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_admin.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/screens/view_locations.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/util/dataFetcher.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image/image.dart' as img;

// ignore: must_be_immutable
class ViewLocationsForAdmin extends StatefulWidget {
  User user;
  String userType;
  ViewLocationsForAdmin({Key? key, required this.user, required this.userType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewLocationsForAdminState createState() => _ViewLocationsForAdminState();
}

class _ViewLocationsForAdminState extends State<ViewLocationsForAdmin>
    with DataFetcher {
  List<Location> locations = [];
  List<City> cities=[];
  List<LocationCategory> locationCategories=[];
  bool isLoading = true;
  final AuthenticationService authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    fetchLocations();

    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
      });
    }).catchError((error) {
      // Handle error
    });

    fetchLocationCategories(false).then((fetchedCategories) {
      setState(() => locationCategories=fetchedCategories
      );
    }).catchError((error){
      // Handle error
    });
  }

  void fetchLocations() async {
    try {
      List<Map<String, dynamic>> taoIDAndLocationID = await fetchLocationTAO();
      locations = await getAllLocations();

      for (var location in locations) {

        Map<String, dynamic> matchingData = taoIDAndLocationID.firstWhere(
          (element) => element['locationId'] == location.locationId.toString(),
          orElse: () => Map<String, dynamic>.from({}),
        );

        if (matchingData.isNotEmpty) {
          location.touristAttractionOwnerId =
              matchingData['touristAttractionOwnerId'];
        } else {
        }
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                Image cimage;
                // ignore: unnecessary_null_comparison
                if (location.coverImage != null &&
                    location.coverImage.isNotEmpty &&
                    location.coverImage != "null") {
                  cimage = Image.memory(base64.decode(location.coverImage));
                } else {
                  cimage = Image.network(
                      'https://static.thenounproject.com/png/250091-200.png');
                }
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: cimage,
                    title: Text(location.name),
                    subtitle: Text(location.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: location.touristAttractionOwnerId == null,
                          child: ElevatedButton(
                            onPressed: () async {
                              showEditLocation(location, cities, locationCategories);
                            },
                            child: const Text("Ažuriraj"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var isDeleted =
                                await deleteLocationById(location.locationId!);

                            if (isDeleted) {
                              // ignore: use_build_context_synchronously
                              Flushbar(
                                message: "Lokacija je obrisana",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ).show(context);
                              // ignore: use_build_context_synchronously
                              Future.delayed(const Duration(milliseconds: 3500),
                                  () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewLocationsForAdmin(
                                        user: widget.user,
                                        userType: widget.userType)));
                              });
                            }
                          },
                          child: const Text('Obriši'),
                        ),
                        const SizedBox(width: 8.0),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }


  showEditLocation(Location location, List<City> cities, List<LocationCategory> locationCategories) async {
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
  String? locationCoverImage=location.coverImage;

  final TextEditingController nameController = TextEditingController(text: location.name);
  final TextEditingController descriptionController = TextEditingController(text: location.description);
  final TextEditingController addressController = TextEditingController(text : location.address);
  final TextEditingController facebookUrlController = TextEditingController(text : location.facebookUrl);
  final TextEditingController instagramUrlController = TextEditingController( text: location.instagramUrl);
  final TextEditingController bookingUrlController = TextEditingController(text: location.bookingUrl);
    int selectedCityId=location.cityId;
    City? selectedCity=cities.firstWhere((element) => element.id ==selectedCityId);
    int selectedCategoryId=location.locationCategoryId;
    LocationCategory? selectedCategory=locationCategories.firstWhere((element) => element.id==selectedCategoryId);

    List<LocationSubcategory> locationSubcategories = await fetchLocationSubcategories(selectedCategoryId);
    int selectedSubcategoryId=location.locationSubcategoryId;
    LocationSubcategory? selectedSubcategory=locationSubcategories.firstWhere((element) => element.id==selectedSubcategoryId);
    Map<String, int> cityIdMap = {};
    Map<String, int> categoryIdMap = {};
    
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Ažuriraj lokaciju'),
            content: SingleChildScrollView(
              child: Column(children: [
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
                                                            locationCategories
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
                                                          locationSubcategories =
                                                              fetchedSubcategories;
                                                          selectedSubcategory =
                                                              null; // Reset the selected subcategory
                                                        });
                                                      },
                                                      items: locationCategories
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
                                                          selectedSubcategoryId=newSubcategory!.id;
                                                        });
                                                      },
                                                      items: locationSubcategories
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
                                                          var taoId = await getTouristAttractionOwnerIdByUserId(widget.user.userId);
                                                          Location editedLocation = Location(
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
                                                                  selectedSubcategoryId,
                                                              touristAttractionOwnerId:
                                                                  taoId!=null && taoId!=0?taoId:null,
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
                                                              '${ApiConstants.baseUrl}/Location/${location.locationId}');
                                                          var response =
                                                              await makeAuthenticatedRequest(
                                                            url,
                                                            'PUT',
                                                            body: editedLocation
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
                                                                        'Uspješno spašene promjene.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                            if(widget.userType=="administrator"){
                                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => ViewLocationsForAdmin(user: widget.user, userType: widget.userType),
                                                                            ));}
                                                                            else{
                                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => ViewLocations(user: widget.user, userType: widget.userType),
                                                                            ));
                                                                            }
                                                                        },
                                                                        child: const Text(
                                                                            'OK'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                              if(widget.userType=="administrator"){
                                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => DashboardAdmin(user: widget.user, userType: widget.userType),
                                                                            ));}
                                                                            else{
                                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                              builder: (context) => DashboardTouristAttractionOwner(user: widget.user, userType: widget.userType),
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
                                                                        'Lokacija nije uspješno editovana. Provjerite polja za unos.'),
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
                                                          const Text('Spasi'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]),
                                ),
                              )]
              )));});});
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
