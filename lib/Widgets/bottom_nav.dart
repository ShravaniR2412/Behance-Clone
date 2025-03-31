import 'package:behnace/Screens/Details.dart';

import '../Screens/AddProject.dart';
import 'package:behnace/Screens/ArtistDetails.dart';
import 'package:behnace/Screens/ProjectInfo.dart';
import 'package:flutter/material.dart';
import '../Screens/Home.dart';  // Import HomePage
import '../Screens/Profile.dart'; // Import ProfilePage

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DetailsPage()),
      );
    }
    else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddProjectPage()),
      );
    }else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ArtistDetails()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);
        _navigate(context, index);
      },
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.message_rounded), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}
