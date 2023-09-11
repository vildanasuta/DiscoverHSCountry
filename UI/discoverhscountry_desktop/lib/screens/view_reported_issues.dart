import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:flutter/material.dart';

class ViewReportedIssues extends StatefulWidget {
  final User? user;
  final String? userType;
  const ViewReportedIssues({super.key, required this.user, required this.userType});


  @override
  State<ViewReportedIssues> createState() => _ViewReportedIssuesState();
}

class _ViewReportedIssuesState extends State<ViewReportedIssues> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}