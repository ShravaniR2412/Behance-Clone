import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/auth_provider.dart';
import '../Screens/ProjectInfo.dart';
import '../Screens/AddProject.dart';
import '../Screens/EditProject.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProviderFunction>(context, listen: false);
    final email = authProvider.email ?? "darshankhapekar12@gmail.com";

    try {
      // Get user profile data
      final userDoc = await _firestore.collection('profile').doc(email).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data();
        });
      }

      // Get user projects
      final projectsDoc = await _firestore.collection('project').doc(email).get();
      if (projectsDoc.exists) {
        final projectsData = projectsDoc.data()?['projectDetails'] as Map<String, dynamic>? ?? {};
        final projectsList = projectsData.entries.map((entry) {
          return {
            'id': entry.key,
            ...(entry.value as Map).cast<String, dynamic>(),
          };
        }).toList();

        setState(() {
          _projects = projectsList;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteProject(String projectId) async {
    final authProvider = Provider.of<AuthProviderFunction>(context, listen: false);
    final email = authProvider.email ?? "darshankhapekar12@gmail.com";

    try {
      await _firestore.collection('project').doc(email).update({
        'projectDetails.$projectId': FieldValue.delete(),
      });
      _loadUserData(); // Refresh data
    } catch (e) {
      print("Error deleting project: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to edit profile page
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16), // Fixed overflow
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey[900]!, Colors.black],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      _userData?['profile_pic'] ?? 'https://avatar.iran.liara.run/public/60',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${_userData?['first_name'] ?? ''} ${_userData?['last_name'] ?? ''}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userData?['bio'] ?? 'Photographer & Digital Artist',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem(Icons.cake, "${_userData?['birth_month'] ?? ''} ${_userData?['birth_year'] ?? ''}"),
                      const SizedBox(height: 20),
                      _buildStatItem(Icons.email, _userData?['email'] ?? ''),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton("Follow", Colors.blue[600]!),
                      const SizedBox(width: 16),
                      _buildActionButton("Message", Colors.grey[800]!),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Projects Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Projects",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProjectPage()),
                    ).then((_) => _loadUserData());
                  },
                  child: const Text(
                    "Add New +",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Projects List (1 per row)
            if (_projects.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      color: Colors.grey[600],
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No projects yet",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create your first project to showcase your work",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  final project = _projects[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: _buildProjectCard(project),
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectInfo(
              email: Provider.of<AuthProviderFunction>(context, listen: false).email ?? "",
              projectTitle: project['title'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            AspectRatio(
              aspectRatio: 16/9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: project['imageLinks'] != null && (project['imageLinks'] as List).isNotEmpty
                    ? Image.network(
                  (project['imageLinks'] as List).first,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            // Project Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'] ?? 'Untitled Project',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project['tagline'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          project['creativeFields']?.join(', ') ?? '',
                          style: TextStyle(
                            color: Colors.blue[300],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProjectPage(
                                  project: project,
                                  projectId: project['id'],
                                ),
                              ),
                            ).then((_) => _loadUserData());
                          } else if (value == 'delete') {
                            _deleteProject(project['id']);
                          }
                        },
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
  }
}