import 'package:url_launcher/url_launcher.dart';

mixin Common{
Future<void> launchURL(String url) async {
  if (await canLaunchUrl(url as Uri)) {
    await launchUrl(url as Uri);
  } else {
    throw 'Could not launch $url';
  }
}}