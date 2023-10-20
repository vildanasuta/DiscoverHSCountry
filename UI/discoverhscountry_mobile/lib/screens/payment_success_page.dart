import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:discoverhscountry_mobile/widgets/tourist_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaymentSuccessPage extends StatefulWidget {
  User user;
  PaymentSuccessPage({super.key, required this.user});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
     @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 2, 89, 1.0),
        foregroundColor: Colors.white,
                automaticallyImplyLeading: false, 
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
            'Payment was successful',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
      endDrawer: TouristDrawer(user: widget.user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
            'Payment was succesful. You will receive details on your email.',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
          ),
      ));}}