import 'dart:convert';

import 'package:discoverhscountry_mobile/common/data_fetcher.dart';
import 'package:discoverhscountry_mobile/models/city_model.dart';
import 'package:discoverhscountry_mobile/models/historical_story_model.dart';
import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ViewHistoricalStoryDetails extends StatefulWidget {
  User user;
  HistoricalStory historicalStory;
  ViewHistoricalStoryDetails(
      {super.key, required this.user, required this.historicalStory});

  @override
  State<ViewHistoricalStoryDetails> createState() =>
      _ViewHistoricalStoryDetailsState();
}

class _ViewHistoricalStoryDetailsState
    extends State<ViewHistoricalStoryDetails> with DataFetcher {
  bool isLoading = true;
  City? city;


  getCity() async {
    await getCityById(widget.historicalStory.cityId).then((value) {
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
              widget.historicalStory.title,
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
                      widget.historicalStory.coverImage=="null" || widget.historicalStory.coverImage==null ?Image.network("https://img.freepik.com/premium-vector/stylized-simple-outline-map-bosnia-herzegovina-icon-blue-sketch-map-bosnia-herzegovina-vector-illustration_160901-3633.jpg?w=360"):Image.memory(base64.decode(widget.historicalStory.coverImage!)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.historicalStory.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildRichTextWithClickableLinks(
                            widget.historicalStory.description),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InkWell(
                          onTap: () {
                           launchMaps(
                                city!.name, context);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                city!.name,
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
