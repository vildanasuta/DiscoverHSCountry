import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:discoverhscountry_desktop/api_constants.dart';
import 'package:discoverhscountry_desktop/main.dart';
import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/services/authentication_service.dart';
import 'package:discoverhscountry_desktop/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

class UserProfileScreen extends StatefulWidget {
  final User? user;
  final String? userType;

  const UserProfileScreen({Key? key, required this.user, required this.userType}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isHover = false;
  bool _showNewPassword = false;
  bool _showRepeatPassword = false;
  void _changePassword() {
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _oldPasswordController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _passwordController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _repeatPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promjeni lozinku'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  child: FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: 'oldPassword',
                              decoration: const InputDecoration(
                                  labelText: 'Stara lozinka'),
                              controller: _oldPasswordController,
                              obscureText: true,
                            ),
                            FormBuilderTextField(
                              name: 'newPassword',
                              decoration: InputDecoration(
                                labelText: 'Nova lozinka',
                                suffixIcon: IconButton(
                                  icon: Icon(_showNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _showNewPassword = !_showNewPassword;
                                    });
                                  },
                                ),
                              ),
                              controller: _passwordController,
                              obscureText: !_showNewPassword,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: 'Ovo polje je obavezno!',
                                  ),
                                  FormBuilderValidators.minLength(8,
                                      errorText:
                                          'Lozinka mora imati minimalno 8 karaktera.'),
                                  FormBuilderValidators.match(
                                      r'^(?=.*[a-zščćžđ])(?=.*[A-ZŠŽČĆŽĐ])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-zžščćžđŠŽČĆŽĐ\d@$!%*?&.]+$',
                                      errorText:
                                          'Lozinka mora sadržavati barem jedno veliko slovo, broj i znak.'),
                                ],
                              ),
                            ),
                            FormBuilderTextField(
                              name: 'repeatNewPassword',
                              decoration: InputDecoration(
                                labelText: 'Ponovi lozinku',
                                suffixIcon: IconButton(
                                  icon: Icon(_showRepeatPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _showRepeatPassword =
                                          !_showRepeatPassword;
                                    });
                                  },
                                ),
                              ),
                              controller: _repeatPasswordController,
                              obscureText: !_showRepeatPassword,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Ovo polje je obavezno!'),
                                (val) {
                                  if (val != _passwordController.text) {
                                    return 'Lozinke se ne podudaraju';
                                  }
                                  return null;
                                },
                              ]),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () async {
                                var oldPasswordFromForm =
                                    _oldPasswordController.text;

                                if (_formKey.currentState!.validate()) {
                                  if (_passwordController.text ==
                                      _repeatPasswordController.text) {
                                    // ignore: use_build_context_synchronously
                                    sendChangePasswordRequest(
                                        widget.user!.userId,
                                        _passwordController.text,
                                        context,
                                        oldPasswordFromForm);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Flushbar(
                                      message:
                                          "Lozinka nije promijenjena. Provjerite polja za unos!",
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ).show(context);
                                  }
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.red.withOpacity(0.8);
                                    }
                                    return Colors.red;
                                  },
                                ),
                              ),
                              child: const Text('Promijeni lozinku'),
                            )
                          ],
                        ),
                      )));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        isLoggedIn: true,
        user: widget.user,
        userType: widget.userType,
        onLogout: () async {
          final AuthenticationService authService = AuthenticationService();
          await authService.logout();
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        },
      ),
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
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                              child: (widget.user?.profileImage != '' && widget.user?.profileImage !='string')
                                  ? Image.memory(
                                      base64Decode(widget.user!.profileImage),
                                      width: 120,
                                      height: 120,
                                    )
                                  : Image.asset('assets/default-user.png',
                                      width: 120, height: 120),
                            ),
                          ),
                          Positioned.fill(
                              child: InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );

                              if (result != null && result.files.isNotEmpty) {
                                PlatformFile file = result.files.first;
                                File imageFile = File(file.path!);
                                Uint8List imageBytes =
                                    await imageFile.readAsBytes();

                                // Resize the image to a smaller size
                                img.Image resizedImage =
                                    img.decodeImage(imageBytes)!;
                                int maxWidth = 800;
                                img.Image smallerImage = img
                                    .copyResize(resizedImage, width: maxWidth);

                                List<int> smallerImageBytes =
                                    img.encodeJpg(smallerImage);

                                var request = http.MultipartRequest(
                                  'PUT',
                                  Uri.parse(
                                      '${ApiConstants.baseUrl}/User/UpdateProfilePhoto/${widget.user?.userId}'),
                                );

                                // Set the 'Content-Type' header to 'multipart/form-data'
                                request.headers['Content-Type'] =
                                    'multipart/form-data';

                                request.files.add(
                                  http.MultipartFile(
                                    'profileImage',
                                    Stream.fromIterable([
                                      smallerImageBytes
                                    ]), // Convert List<int> to Stream<List<int>>
                                    smallerImageBytes.length,
                                    filename: file.name,
                                  ),
                                );

                                var response = await request.send();
                                if (response.statusCode == 200) {
                                  // After successful update, retrieve the updated user data
                                  var getUserResponse = await http.get(
                                    Uri.parse(
                                        '${ApiConstants.baseUrl}/User/${widget.user?.userId}'),
                                  );

                                  if (getUserResponse.statusCode == 200) {
                                    var userData =
                                        json.decode(getUserResponse.body);

                                    // Update the user data on your edit user screen
                                    setState(() {
                                      widget.user?.profileImage =
                                          userData['profileImage'];
                                    });
                                    // Show success message using Flushbar
                                    // ignore: use_build_context_synchronously
                                    Flushbar(
                                      message:
                                          "Uspješno ažurirana profilna fotografija",
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 3),
                                    ).show(context);
                                  }
                                } else {
                                  // Handle failure
                                }
                              }
                            },
                            onHover: (isHovering) {
                              setState(() {
                                isHover =
                                    isHovering;
                              });
                            },
                            child: ClipOval(
                              child: Visibility(
                                visible:
                                    isHover, 
                                child: Container(
                                  color: Colors.blue.withOpacity(0.8),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${widget.user?.firstName} ${widget.user?.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.user!.email,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 88, 87, 87)),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          _showEditPopup(context);
                        },
                        child: const Text('Uredi detalje'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _changePassword();
                        },
                        child: const Text('Promijeni lozinku'),
                      ),
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: () {
                          deleteProfile(context, widget.user!.userId);
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red.withOpacity(0.8);
                              }
                              return Colors.red;
                            },
                          ),
                        ),
                        child: const Text('Obriši profil'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPopup(BuildContext context) {
    TextEditingController firstNameController =
        TextEditingController(text: widget.user?.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: widget.user?.lastName);
    TextEditingController emailController =
        TextEditingController(text: widget.user?.email);
    String profileImage = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uredi detalje'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ime'),
                  controller: firstNameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prezime'),
                  controller: lastNameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: emailController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      PlatformFile file = result.files.first;
                      File imageFile = File(file.path!);
                      Uint8List imageBytes = await imageFile.readAsBytes();
                      // Resize the image to a smaller size
                      img.Image resizedImage = img.decodeImage(imageBytes)!;
                      int maxWidth = 800;
                      img.Image smallerImage =
                          img.copyResize(resizedImage, width: maxWidth);
                      List<int> smallerImageBytes = img.encodeJpg(smallerImage);
                      String base64Image = base64Encode(smallerImageBytes);
                      profileImage = base64Image;
                    }
                  },
                  child: const Text('Promijeni profilnu sliku'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                User editedUser = User(
                  userId: widget.user!.userId,
                  email: emailController.text,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  profileImage: profileImage,
                );
                var url = Uri.parse(
                    '${ApiConstants.baseUrl}/User/UpdateDetails/${editedUser.userId}');
                var response = await http.put(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(editedUser.toJson()),
                );
                if (response.statusCode == 200) {
                  // Show a dialog with a success message
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Uspješno spašene promjene'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                              // Close the edit dialog
                              Navigator.of(context).pop();
                              // Trigger a reload of the edit profile page
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) =>
                                    UserProfileScreen(user: editedUser, userType: widget.userType,),
                              ));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Spremi'),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Close the pop-up without saving changes
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Odustani'),
            ),
          ],
        );
      },
    );
  }
}

void sendChangePasswordRequest(int userId, String newPassword,
    BuildContext context, String oldPassword) async {
  var savePasswordUrl =
      Uri.parse('${ApiConstants.baseUrl}/User/UpdatePassword/$userId');

  var response = await http.put(
    savePasswordUrl,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'password': newPassword, 'oldPassword': oldPassword}),
  );

  if (response.statusCode == 200) {
    // ignore: use_build_context_synchronously
    Flushbar(
      message: "Uspješno promijenjena lozinka!",
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    ).show(context);
  } else {
    // ignore: use_build_context_synchronously
    Flushbar(
      message: "Lozinka nije promijenjena. Provjerite polja za unos!",
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}

void deleteProfile(BuildContext context, int userId) async {
  // Display a confirmation dialog
  bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(false); // User cancelled delete
          return false; // Prevent dialog from being popped by back button
        },
        child: AlertDialog(
          title: const Text('Jeste li sigurni da želite obrisati Vaš profil?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancelled delete
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.green;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.white;
                }),
              ),
              child: const Text('Odustani'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed delete
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.red;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.white;
                }),
              ),
              child: const Text('Da'),
            )
          ],
        ),
      );
    },
  );

  if (confirmDelete == true) {
    int taoId = 0;
    var getTAOId = Uri.parse(
        '${ApiConstants.baseUrl}/TouristAttractionOwner/GetTouristAttractionOwnerIdByUserId/$userId');
    var taoResponse = await http.get(getTAOId);
    if (taoResponse.statusCode == 200) {
      taoId = int.parse(taoResponse.body);
    }

    var deleteTAO =
        Uri.parse('${ApiConstants.baseUrl}/TouristAttractionOwner/$taoId');
    var deleteResponse = await http.delete(deleteTAO);

    if (deleteResponse.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstPage()),
      );

      // Show success message
      // ignore: use_build_context_synchronously
      Flushbar(
        message: "Uspješno ste obrisali profil!",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ).show(context);
    } else {
      // Show error message
      // ignore: use_build_context_synchronously
      Flushbar(
        message: "Profil nije obrisan!",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  } else {
    // User cancelled profile deletion or dismissed dialog
  }
}
