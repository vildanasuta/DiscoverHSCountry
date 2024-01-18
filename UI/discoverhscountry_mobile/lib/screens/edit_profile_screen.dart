import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:discoverhscountry_mobile/api_constants.dart';
import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/screens/dashboard_screen.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  User user;
  EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with DataFetcher {
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
          title: const Text('Change your password'),
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
                                  labelText: 'Old password'),
                              controller: _oldPasswordController,
                              obscureText: true,
                            ),
                            FormBuilderTextField(
                              name: 'newPassword',
                              decoration: InputDecoration(
                                labelText: 'New password',
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
                                    errorText: 'This field is required!',
                                  ),
                                  FormBuilderValidators.minLength(8,
                                      errorText:
                                          'Password needs to contain minimum of 8 characters.'),
                                  FormBuilderValidators.match(
                                      r'^(?=.*[a-zščćžđ])(?=.*[A-ZŠŽČĆŽĐ])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-zžščćžđŠŽČĆŽĐ\d@$!%*?&.]+$',
                                      errorText:
                                          'The password must contain at least one uppercase letter, a number, and a symbol.'),
                                ],
                              ),
                            ),
                            FormBuilderTextField(
                              name: 'repeatNewPassword',
                              decoration: InputDecoration(
                                labelText: 'Repeat your password',
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
                                  errorText: 'This field is required!',
                                ),
                                (val) {
                                  if (val != _passwordController.text) {
                                    return 'Passwords aren not matching!';
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
                                        widget.user.userId,
                                        _passwordController.text,
                                        context,
                                        oldPasswordFromForm);
                                        Navigator.of(context).pop();
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Flushbar(
                                      message:
                                          "Password is not changed. Check your input fields!",
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
                              child: const Text('Change password'),
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
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 60.0),
                  child: Card(
                    elevation: 5,
                    color: const Color.fromRGBO(230, 230, 245, 1),
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
                                  child: widget.user.profileImage != ''
                                      ? Image.memory(
                                          base64Decode(
                                              widget.user.profileImage!),
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

                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    PlatformFile file = result.files.first;
                                    File imageFile = File(file.path!);
                                    Uint8List imageBytes =
                                        await imageFile.readAsBytes();

                                    img.Image resizedImage =
                                        img.decodeImage(imageBytes)!;
                                    int maxWidth = 800;
                                    img.Image smallerImage = img.copyResize(
                                        resizedImage,
                                        width: maxWidth);

                                    List<int> smallerImageBytes =
                                        img.encodeJpg(smallerImage);

                                    var request = http.MultipartRequest(
                                      'PUT',
                                      Uri.parse(
                                          '${ApiConstants.baseUrl}/User/UpdateProfilePhoto/${widget.user.userId}'),
                                    );
                                    var storage = const FlutterSecureStorage();
                                    final token =
                                        await storage.read(key: 'token');
                                    request.headers['Authorization'] =
                                        'Bearer $token';
                                    request.headers['Content-Type'] =
                                        'multipart/form-data';

                                    request.files.add(
                                      http.MultipartFile(
                                        'profileImage',
                                        Stream.fromIterable(
                                            [smallerImageBytes]),
                                        smallerImageBytes.length,
                                        filename: file.name,
                                      ),
                                    );
                                    var response = await request.send();
                                    if (response.statusCode == 200) {
                                      // After successful update, retrieve the updated user data
                                      final getUserResponse =
                                          await makeAuthenticatedRequest(
                                        Uri.parse(
                                            '${ApiConstants.baseUrl}/User/${widget.user.userId}'),
                                        'GET',
                                      );

                                      if (getUserResponse.statusCode == 200) {
                                        var userData =
                                            json.decode(getUserResponse.body);

                                        setState(() {
                                          widget.user.profileImage =
                                              userData['profileImage'];
                                        });
                                        // ignore: use_build_context_synchronously
                                        Flushbar(
                                          message:
                                              "Profile photo is successfully changed!",
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
                                    isHover = isHovering;
                                  });
                                },
                                child: ClipOval(
                                  child: Visibility(
                                    visible: isHover,
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
                            '${widget.user.firstName} ${widget.user.lastName}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    color:
                                        const Color.fromARGB(255, 1, 38, 160)),
                          ),
                          Text(
                            widget.user.email,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                              onPressed: () {
                                _showEditPopup(context);
                              },
                              child: Text('Edit your details',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: const Color.fromARGB(
                                            255, 1, 38, 160),
                                      ))),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                _changePassword();
                              },
                              child: Text(
                                'Change password',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color:
                                          const Color.fromARGB(255, 1, 38, 160),
                                    ),
                              )),
                          const SizedBox(height: 32),
                          TextButton(
                              onPressed: () {
                                deleteProfile(context, widget.user.userId);
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
                              child: Text(
                                'Delete your profile',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.red),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  void _showEditPopup(BuildContext context) {
        // ignore: no_leading_underscores_for_local_identifiers
        final _formKey = GlobalKey<FormBuilderState>();
    TextEditingController firstNameController =
        TextEditingController(text: widget.user.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: widget.user.lastName);
    TextEditingController emailController =
        TextEditingController(text: widget.user.email);
    // ignore: unused_local_variable
    String profileImage = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit your details'),
          content: SizedBox(
              height: 300,
              child: FormBuilder(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'firstName',
                      decoration: const InputDecoration(labelText: 'First name'),
                      controller: firstNameController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'This field is required!',
                        ),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'lastName',
                      decoration: const InputDecoration(labelText: 'Last name'),
                      controller: lastNameController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'This field is required!',
                        ),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'Email'),
                      controller: emailController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'This field is required!',
                        ),
                        FormBuilderValidators.email(
                          errorText: 'Check the email format!',
                        ),
                      ]),
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
                  child: const Text('Change profile photo'),
                ),
              ],
            ),
          )),
          actions: [
            ElevatedButton(
              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                User editedUser = User(
                  userId: widget.user.userId,
                  email: emailController.text,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  profileImage: widget.user.profileImage,
                );
                var url = Uri.parse(
                    '${ApiConstants.baseUrl}/User/UpdateDetails/${editedUser.userId}');

                var response = await makeAuthenticatedRequest(
                  url,
                  'PUT',
                  body: editedUser.toJson(),
                );
                if (response.statusCode == 200) {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Your changes are saved!'),
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
                                    EditProfile(user: editedUser),
                              ));
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Save'),
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
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void sendChangePasswordRequest(int userId, String newPassword,
      BuildContext context, String oldPassword) async {
    var savePasswordUrl =
        Uri.parse('${ApiConstants.baseUrl}/User/UpdatePassword/$userId');

    var response = await makeAuthenticatedRequest(
      savePasswordUrl,
      'PUT',
      body: {'password': newPassword, 'oldPassword': oldPassword},
    );
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Flushbar(
        message: "Password is changed!",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ).show(context);
    } else {
      // ignore: use_build_context_synchronously
      Flushbar(
        message: "Password is not changed. Check your input fields!",
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
            Navigator.of(context).pop(false);
            return false;
          },
          child: AlertDialog(
            title: const Text('Are you sure you want to delete your profile?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
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
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
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
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
    );

    if (confirmDelete == true) {
      int touristId = 0;
      var getTouristId = Uri.parse(
          '${ApiConstants.baseUrl}/Tourist/GetTouristIdByUserId/$userId');
      var response = await makeAuthenticatedRequest(getTouristId, 'GET');
      if (response.statusCode == 200) {
        touristId = int.parse(response.body);
      }

      var deleteTourist =
          Uri.parse('${ApiConstants.baseUrl}/Tourist/$touristId');
      var deleteResponse =
          await makeAuthenticatedRequest(deleteTourist, 'DELETE');

      if (deleteResponse.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardScreen(
                    user: widget.user,
                  )),
        );

        // ignore: use_build_context_synchronously
        Flushbar(
          message: "Your profile is deleted!",
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ).show(context);
      } else {
        // ignore: use_build_context_synchronously
        Flushbar(
          message: "Profile is not deleted!",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } else {
      // User cancelled profile deletion or dismissed dialog
    }
  }
}
