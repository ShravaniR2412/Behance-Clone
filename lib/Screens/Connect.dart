import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../Widgets/auth_provider.dart';
import '../Screens/ConnectInfo.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  List<Map<String, dynamic>> allProfiles = [];
  List<Map<String, dynamic>> matchedProfiles = [];
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    String email = Provider.of<AuthProviderFunction>(context, listen: false).email ?? "";
    List<Map<String, dynamic>> fetchedProfiles = [];
    Map<String, dynamic>? loggedInUserProfile;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profile').get();
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userEmail = doc.id;
        data['email'] = userEmail;
        fetchedProfiles.add(data);
        if (userEmail == email) {
          loggedInUserProfile = data;
        }
      }
    } catch (e) {
      debugPrint("Error fetching profiles: $e");
    }

    setState(() {
      allProfiles = fetchedProfiles;
      userProfile = loggedInUserProfile;
    });

    if (userProfile != null) {
      filterMatchingBios();
    }
  }

  void filterMatchingBios() {
    if (userProfile == null || userProfile!["bio"].isEmpty) {
      setState(() {
        matchedProfiles = [];
      });
      return;
    }

    final userBio = userProfile!["bio"].toLowerCase();
    final userKeywords = extractKeywords(userBio);

    List<Map<String, dynamic>> localMatches = [];

    for (var profile in allProfiles) {
      if (profile["email"] == userProfile!["email"]) continue;
      final profileBio = profile["bio"].toLowerCase();
      final profileKeywords = extractKeywords(profileBio);

      double similarity = calculateJaccardIndex(userKeywords, profileKeywords);
      if (similarity > 0.1) {
        localMatches.add(profile);
      }
    }

    setState(() {
      matchedProfiles = localMatches;
    });
  }

  Set<String> extractKeywords(String bio) {
    String cleanedBio = bio.replaceAll(RegExp(r'[^\w\s]'), '');
    List<String> words = cleanedBio.split(' ');
    List<String> stopWords = ['the', 'and', 'a', 'an', 'in', 'to', 'is', 'are', 'i', 'am'];
    List<String> meaningfulWords = words.where((word) => !stopWords.contains(word)).toList();
    return meaningfulWords.toSet();
  }

  double calculateJaccardIndex(Set<String> set1, Set<String> set2) {
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);
    return intersection.length / union.length;
  }

  Widget buildProfileCard(Map<String, dynamic> profile, {bool isUser = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile["profile_pic"] != null && profile["profile_pic"].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                profile["profile_pic"],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          const SizedBox(height: 8),
          Text("${profile["first_name"]} ${profile["last_name"]}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          const SizedBox(height: 4),
          Text("Email: ${profile["email"]}", style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
          const SizedBox(height: 4),
          Text("Bio: ${profile["bio"]}", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text("Birth Month: ${profile["birth_month"]}", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text("Birth Year: ${profile["birth_year"]}", style: const TextStyle(color: Colors.white70)),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectInfo(email: profile["email"]),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Connect"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Connect", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userProfile != null) ...[
              const Text(
                "Your Profile:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              buildProfileCard(userProfile!, isUser: true),
              const SizedBox(height: 10),
            ],
            const Text(
              "All Profiles:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchedProfiles.length,
                itemBuilder: (context, index) {
                  return buildProfileCard(allProfiles[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}