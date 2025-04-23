import 'package:flutter/material.dart';
import '../Screens/ForYou.dart';
import '../Screens/Connect.dart';
import '../Screens/Creatives.dart'; // Ensure the correct import for CreativesPage
import '../Widgets/view.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
        children: [
          // Behance Text on Top
          const Text(
            "Behance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24, // Adjust the size as needed
              fontWeight: FontWeight.bold, // Make it stand out
            ),
          ),
          const SizedBox(height: 8), // Spacing between "Behance" and the navigation items

          // Navigation Items
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the navigation items
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
                      MaterialPageRoute(builder: (context) => CreativesPage()),
                    );
                  },
                  child: const Text(
                    "Creatives",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
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
                    "Find",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModelGridPage()), // Ensure ConnectPage exists
                    );
                  },
                  child: const Text(
                    "GalleryView",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
