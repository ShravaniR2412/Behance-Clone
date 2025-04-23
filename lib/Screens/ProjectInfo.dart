import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectInfo extends StatefulWidget {
  final String email;
  final String projectTitle;

  const ProjectInfo({required this.email, required this.projectTitle});

  @override
  _ProjectInfoState createState() => _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, dynamic>? projectDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjectDetails();
  }

  Future<void> fetchProjectDetails() async {
    try {
      DocumentSnapshot doc =
      await db.collection("project").doc(widget.email).get();

      if (doc.exists) {
        Map<String, dynamic> projectData = doc.data() as Map<String, dynamic>;

        if (projectData.containsKey("projectDetails")) {
          Map<String, dynamic> projects = projectData["projectDetails"];

          // Find the project with the matching title
          for (var key in projects.keys) {
            if (projects[key]["title"] == widget.projectTitle) {
              setState(() {
                projectDetails = projects[key];
                isLoading = false;
              });
              return;
            }
          }
        }
      }

      // If project not found
      print("Project not found");
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching project details: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.projectTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: projectDetails != null
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Project Image (First one from the list)
            if (projectDetails!['imageLinks'] != null &&
                projectDetails!['imageLinks'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  projectDetails!['imageLinks'][0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // 🔹 Title + Likes, Comments, Views (Dummy values for now)
            Text(
              projectDetails!['title'],
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 5),
            Row(
              children: const [
                Icon(Icons.thumb_up, color: Colors.white, size: 18),
                SizedBox(width: 5),
                Text("408", style: TextStyle(color: Colors.white)),
                SizedBox(width: 15),
                Icon(Icons.comment, color: Colors.white, size: 18),
                SizedBox(width: 5),
                Text("61", style: TextStyle(color: Colors.white)),
                SizedBox(width: 15),
                Icon(Icons.remove_red_eye,
                    color: Colors.white, size: 18),
                SizedBox(width: 5),
                Text("4,910", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Description
            const Text(
              "Description",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              projectDetails!['description'],
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),

            // 🔹 Tools Used
            const Text(
              "Tools Used",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                projectDetails!['toolsUsed'],
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Creative Fields
            const Text(
              "Creative Fields",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: (projectDetails!['creativeFields'] as List<dynamic>)
                  .map(
                    (field) => Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    field,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 20),

            // 🔹 Additional Images
            if (projectDetails!['imageLinks'] != null &&
                projectDetails!['imageLinks'].length > 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "More Images",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: (projectDetails!['imageLinks']
                    as List<dynamic>)
                        .skip(1) // Skipping first image
                        .map(
                          (img) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            img,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      )
          : const Center(
        child: Text("Project details not found",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}