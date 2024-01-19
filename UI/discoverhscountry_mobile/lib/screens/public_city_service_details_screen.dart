import 'dart:convert';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/public_city_service_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PublicCityServiceDetailsScreen extends StatefulWidget {
  User user;
  PublicCityService publicCityService;
  PublicCityServiceDetailsScreen(
      {super.key, required this.user, required this.publicCityService});

  @override
  State<PublicCityServiceDetailsScreen> createState() =>
      _PublicCityServiceDetailsScreenState();
}

class _PublicCityServiceDetailsScreenState
    extends State<PublicCityServiceDetailsScreen> with DataFetcher {
  bool isLoading = true;
  City? city;

  getCity() async {
    await getCityById(widget.publicCityService.cityId).then((value) {
      setState(() {
        city = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCity();
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
              widget.publicCityService.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        endDrawer: TouristDrawer(user: widget.user),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ignore: unnecessary_null_comparison
                      widget.publicCityService.coverImage=="null" || widget.publicCityService.coverImage==null ?Image.network("https://cms.uitp.org/thumbor/fit-in/1024x/--/uploads/2022/07/Copyright-CCR-Metro-Bahia-3-scaled-e1658341124673.jpg"):Image.memory(
                                  base64.decode(widget.publicCityService.coverImage),
                                ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.publicCityService.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildRichTextWithClickableLinks(
                            widget.publicCityService.description),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                            launchMaps(
                                '${widget.publicCityService.address} ${city!.name}', context);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.publicCityService.address} ${city!.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ));
  }
}

Widget buildRichTextWithClickableLinks(String description) {
  final RegExp linkRegExp = RegExp(r'https?://\S+');

  List<TextSpan> textSpans = [];
  int start = 0;
  for (final match in linkRegExp.allMatches(description)) {
    if (match.start > start) {
      textSpans.add(TextSpan(
        text: description.substring(start, match.start),
        style: const TextStyle(color: Colors.black),
      ));
    }

    textSpans.add(TextSpan(
      text: match.group(0),
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launchUrl(Uri.parse(match.group(0)!));
        },
    ));

    start = match.end;
  }

  if (start < description.length) {
    textSpans.add(TextSpan(
      text: description.substring(start),
      style: const TextStyle(color: Colors.black),
    ));
  }

  return RichText(
    text: TextSpan(
      style: const TextStyle(color: Colors.black),
      children: textSpans,
    ),
  );
}
