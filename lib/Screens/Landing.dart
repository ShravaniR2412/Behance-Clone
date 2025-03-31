
import 'package:flutter/material.dart';
import '../Screens/Home.dart';// import 'Home.dart';
import '../Widgets/theme.dart'; // Assuming AppColors is imported from theme.dart
import '../Screens/AddProject.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [
      'https://media.istockphoto.com/id/182062885/photo/space-station-in-earth-orbit.webp?a=1&b=1&s=612x612&w=0&k=20&c=alGFjcWNyVs4fLL9cWWtYZybeef0X1S1iROLA-bbx_8=',
      'https://images.unsplash.com/photo-1577084381380-3b9ea4153664?q=80&w=2012&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://media.istockphoto.com/id/452192145/photo/ancient-thai-painting.webp?a=1&b=1&s=612x612&w=0&k=20&c=VeU1WbFs5ns4TFftXU8ud8PTMq3l9VeNNk-ub2DnWzE=',
      'https://images.unsplash.com/photo-1549716679-95380658d5cd?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGNhbnZhc3xlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1471899236350-e3016bf1e69e?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Top Bar
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              color: Colors.black,
              child: Text(
                'Gallery',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            // Content Feed
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(imageUrls.length, (index) => ArtworkCard(imageUrl: imageUrls[index])),
                ),
              ),
            ),

            // Call-to-Action Section
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtworkCard extends StatelessWidget {
  final String imageUrl;

  ArtworkCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Artwork Title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://media.istockphoto.com/id/177247796/photo/night-sky-filled-with-stars-and-nebulae.jpg?s=1024x1024&w=is&k=20&c=iKWp9X2wvjXd5kb0xIV5K_tLzrOSL6FGZggDwDpFXOI='
                      ),
                      radius: 15,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Creator Name',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}