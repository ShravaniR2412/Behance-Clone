import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/bottom_nav.dart';
import '../Screens/ProjectInfo.dart';

class ConnectInfo extends StatefulWidget {
  final String email;

  ConnectInfo({Key? key, required this.email}) : super(key: key);

  @override
  _ConnectInfoState createState() => _ConnectInfoState();
}

class _ConnectInfoState extends State<ConnectInfo> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjectsByEmail();
  }

  Future<void> fetchProjectsByEmail() async {
    try {
      var projectSnapshot = await db.collection("project").doc(widget.email).get();

      if (projectSnapshot.exists) {
        var projectData = projectSnapshot.data() ?? {};
        var profileDoc = await db.collection("profile").doc(widget.email).get();
        var profileData = profileDoc.data() ?? {};

        String firstName = profileData["first_name"] ?? "";
        String lastName = profileData["last_name"] ?? "";
        String birthMonth = profileData["birth_month"] ?? "";
        String profilePic = profileData["profile_pic"] ?? "";

        List<Map<String, dynamic>> projectList = [];

        var projectDetails = projectData["projectDetails"] ?? {};
        if (projectDetails is Map<String, dynamic>) {
          for (var project in projectDetails.values) {
            if (project is Map<String, dynamic>) {
              projectList.add({
                "email": widget.email,
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
        setState(() {
          projects = projectList;
        });
      } else {
        setState(() {
          projects = [];
        });
        print("No project found for email: ${widget.email}");
      }
    } catch (error) {
      print("Error fetching projects for email ${widget.email}: $error");
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
                                child: Text(
                                  project['birth_month'],
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project['name'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          project['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          project['tagline'],
                          style: TextStyle(color: Colors.grey[400]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
      // bottomNavigationBar: const BottomNav(),
    );
  }
}
