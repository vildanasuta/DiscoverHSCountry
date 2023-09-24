import 'dart:convert';

import 'package:discoverhscountry_mobile/models/user_model.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final User? user;
  const DashboardScreen({super.key, this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: MemoryImage(
                                      base64Decode(widget.user!.profileImage),
                                    
                                    ),radius: 20,
                                 
            ),
            const SizedBox(width: 8),
            Text('${widget.user?.firstName} ${widget.user?.lastName}'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu), 
            onPressed: () {
              // Handle menu icon tap
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9, 
            child: Image.asset('assets/dashboard-welcome.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Where do you want to go?\nExplore now, ${widget.user?.firstName}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle Recommended tap
                },
                child: const Text('Recommended'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle Trending tap
                },
                child: const Text('Trending'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle Most Viewed tap
                },
                child: const Text('Most Viewed'),
              ),
            ],
          ),
          // Add your city cards here
          // You can use a ListView or GridView for city cards
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add your menu buttons here
              // Example:
              ElevatedButton(
                onPressed: () {
                  // Handle button tap
                },
                child: const Text('Button 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle button tap
                },
                child: const Text('Button 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
