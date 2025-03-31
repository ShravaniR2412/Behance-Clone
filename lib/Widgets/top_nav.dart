import 'package:behnace/Screens/Connect.dart';
import 'package:flutter/material.dart';
import '../Screens/ForYou.dart';
import '../Screens/Connect.dart';
import '../Screens/Creatives.dart'; // Ensure the correct import for CreativesPage
import '../Screens/AboutInfo.dart'; // Ensure this file contains AboutInfoPage
import '../Screens/ArtistDetails.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality here
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Explore",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForYouPage()),
                      );
                    },
                    child: const Text(
                      "For You",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreativesPage()),
                      );
                    },
                    child: const Text(
                      "Following",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectPage()), // Ensure ConnectPage exists
                      );
                    },
                    child: const Text(
                      "Connect",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreativesPage()), // Ensure CreativesPage exists
              );
            },
          ),
        ],
      ),
    );
  }
}
