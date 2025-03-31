import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/bottom_nav.dart';
import '../Screens/ProjectInfo.dart'; // Import the new screen

class CreativesPage extends StatefulWidget {
  @override
  _CreativesPageState createState() => _CreativesPageState();
}

class _CreativesPageState extends State<CreativesPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    fetchAllProjects();
  }

  Future<void> fetchAllProjects() async {
    try {
      var projectSnapshot = await db.collection("project").get();
      List<Map<String, dynamic>> projectList = [];

      for (var doc in projectSnapshot.docs) {
        String email = doc.id;
        var projectData = doc.data();

        var profileDoc = await db.collection("profile").doc(email).get();
        var profileData = profileDoc.data() ?? {};

        String firstName = profileData["first_name"] ?? "";
        String lastName = profileData["last_name"] ?? "";
        String birthMonth = profileData["birth_month"] ?? "";
        String profilePic = profileData["profile_pic"] ?? "";

        var projectDetails = projectData["projectDetails"] ?? {};
        if (projectDetails is Map<String, dynamic>) {
          for (var project in projectDetails.values) {
            if (project is Map<String, dynamic>) {
              projectList.add({
                "email": email, // Store email to pass later
                "name": "$firstName $lastName".trim(),
                "birth_month": birthMonth,
                "title": project["title"] ?? "",
                "profilePic": profilePic,
                "portfolio": List<String>.from(project["imageLinks"] ?? []),
                "featured": project["featured"] ?? false,
                "tagline": project["tagline"] ?? "",
              });
            }
          }
        }
      }

      setState(() {
        projects = projectList;
      });
    } catch (error) {
      print("Error fetching projects: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Creatives",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: projects.isEmpty
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];

          return GestureDetector(
            onTap: () {
              // Navigate to ProjectInfo with email and project title
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectInfo(
                    email: project['email'],
                    projectTitle: project['title'],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: (project['portfolio'] as List<dynamic>)
                              .map<Widget>(
                                (image) => Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(image, width: 110, height: 110, fit: BoxFit.cover),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                      Positioned(
                        bottom: -25,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(project['profilePic']),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 18,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "PRO",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          project['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey, size: 14),
                            Text(
                              " ${project['birth_month']}",
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "• ${project['name']}",
                              style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (project['featured'])
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[700],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "★ Featured",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${project['tagline']} ",
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) {}),
    );
  }
}
