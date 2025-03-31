import 'package:flutter/material.dart';

class ArtistDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/artist.jpg'), // Change with actual image
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jack R.',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.thumb_up, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('178198', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(Icons.group, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('23212', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(Icons.work, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('33', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: Text('Follow',style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: Text('Hire', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.white38),
                  SizedBox(height: 8),
                ],
              ),
            ),
            // Tab Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Work', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('Services', style: TextStyle(color: Colors.white54, fontSize: 16)),
                  Text('Moodboards', style: TextStyle(color: Colors.white54, fontSize: 16)),
                  Text('About', style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Portfolio Section
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: 4, // Example images
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1662452212461-6075942a8781?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
