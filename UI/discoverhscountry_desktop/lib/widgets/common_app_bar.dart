import 'dart:convert';

import 'package:discoverhscountry_desktop/models/user_model.dart';
import 'package:discoverhscountry_desktop/screens/dashboard_touristattractionowner.dart';
import 'package:discoverhscountry_desktop/screens/user_profile.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final User? user;
  final VoidCallback onLogout;
  const CommonAppBar({
    required this.isLoggedIn,
    required this.user,
    required this.onLogout,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String username = '${user?.firstName} ${user!.lastName}';
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.blue,), // Burger menu icon
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DashboardTouristAttractionOwner(
                    user: user,
                  ),
                ),
              );
            },
          );
        },
      ),
      automaticallyImplyLeading: false,
      title: const Text('Discover Heart-Shaped Country'),
      actions: isLoggedIn
          ? [
              TextButton(
                onPressed: () {
                  // Navigate to user's profile screen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfileScreen(user: user),
                  ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Container(
                        child: user?.profileImage != ''
                            ? Image.memory(
                                base64Decode(user!.profileImage),
                                width: 120,
                                height: 120,
                              )
                            : Image.asset(
                              'assets/default-user.png',
                              width: 120, height: 120),
                      ),
                    ),

                    const SizedBox(
                        width: 8), // Add spacing between avatar and text
                    Text(username),
                  ],
                ),
              ),
              TextButton(
                onPressed: onLogout,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white
                ),
                child: const Text('Odjava'),
              ),
              const SizedBox(width: 16), // Add some spacing
            ]
          : null,
      centerTitle: true, // Center the title
    );
  }
}
