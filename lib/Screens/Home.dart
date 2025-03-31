import 'package:flutter/material.dart';
import '../Widgets/bottom_nav.dart';
import '../Widgets/top_nav.dart';
import '../Widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, String>> items = [
    {
      "title": "Cosmic Wonders",
      "imageUrl": "https://plus.unsplash.com/premium_photo-1667105168041-3fad1d08b58b?q=80&w=2127&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "title": "Illusive Texture",
      "imageUrl": "https://images.unsplash.com/photo-1541961017774-22349e4a1262?q=80&w=1958&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "title": "Nebula Magic",
      "imageUrl": "https://images.unsplash.com/photo-1612743138072-675de14392e1?q=80&w=1972&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "title": "Galactic Art",
      "imageUrl": "https://images.unsplash.com/photo-1607349877492-8f2410658848?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "title": "Abstract Flow",
      "imageUrl": "https://plus.unsplash.com/premium_photo-1661683887049-69e8ae0a6c92?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "title": "Wildlife Patterns",
      "imageUrl": "https://images.unsplash.com/photo-1543946207-39bd91e70ca7?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const TopNavBar(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  imageUrl: items[index]["imageUrl"]!,
                  title: items[index]["title"]!,
                  avatarUrl: "https://randomuser.me/api/portraits/men/${index + 1}.jpg",
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: _onNavTapped),
    );
  }
}
