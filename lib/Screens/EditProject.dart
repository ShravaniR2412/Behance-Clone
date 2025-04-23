import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/auth_provider.dart';
import 'package:provider/provider.dart';

class EditProjectPage extends StatefulWidget {
  final Map<String, dynamic> project;
  final String projectId;

  EditProjectPage({required this.project, required this.projectId});

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  List<TextEditingController> _imageLinks = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _taglineController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _toolsUsedController = TextEditingController();
  List<String> _creativeFields = [];
  TextEditingController _creativeFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with project data
    _titleController.text = widget.project['title'] ?? '';
    _taglineController.text = widget.project['tagline'] ?? '';
    _descriptionController.text = widget.project['description'] ?? '';
    _toolsUsedController.text = widget.project['toolsUsed'] ?? '';
    _creativeFields = List<String>.from(widget.project['creativeFields'] ?? []);

    // Initialize image links
    List<dynamic> imageLinksData = widget.project['imageLinks'] ?? [];
    _imageLinks = imageLinksData.map((link) => TextEditingController(text: link.toString())).toList();
    if (_imageLinks.isEmpty) {
      _imageLinks.add(TextEditingController());
    }
  }

  void _addImageLink() {
    setState(() {
      _imageLinks.add(TextEditingController());
    });
  }

  void _addCreativeField() {
    if (_creativeFieldController.text.isNotEmpty) {
      setState(() {
        _creativeFields.add(_creativeFieldController.text);
        _creativeFieldController.clear();
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Error", style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.blue[400])),
          ),
        ],
      ),
    );
  }

  Future<void> _updateForm() async {
    if (_titleController.text.isEmpty ||
        _taglineController.text.isEmpty ||
        _imageLinks.any((controller) => controller.text.isEmpty) ||
        _descriptionController.text.isEmpty ||
        _toolsUsedController.text.isEmpty ||
        _creativeFields.isEmpty) {
      _showErrorDialog("Please fill in all fields before submitting.");
      return;
    }

    List<String> imageLinks = _imageLinks.map((controller) => controller.text).toList();
    String email = Provider.of<AuthProviderFunction>(context, listen: false).email ?? "";

    if (email.isEmpty) {
      _showErrorDialog("Email is missing. Please log in first.");
      return;
    }

    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('project').doc(email);

      // Prepare updated project data
      Map<String, dynamic> updatedProject = {
        "title": _titleController.text,
        "tagline": _taglineController.text,
        "imageLinks": imageLinks,
        "description": _descriptionController.text,
        "toolsUsed": _toolsUsedController.text,
        "creativeFields": _creativeFields,
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Update the project in Firestore
      DocumentSnapshot docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> existingProjects = (docSnapshot.data() as Map<String, dynamic>?)?['projectDetails'] as Map<String, dynamic>? ?? {};

        existingProjects[widget.projectId] = updatedProject; // Update existing project

        await userDocRef.set({
          "email": email,
          "projectDetails": existingProjects,
        }, SetOptions(merge: true));

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text("Success", style: TextStyle(color: Colors.white)),
            content: Text("Project updated successfully!", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: Colors.blue[400])),
              ),
            ],
          ),
        );
      } else {
        _showErrorDialog("User document not found.");
      }

    } catch (e) {
      _showErrorDialog("Failed to update project: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Edit Project",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              _buildTextInput(_titleController, "Project Title"),

              // Tagline Input
              _buildTextInput(_taglineController, "Tagline"),

              // Image Links Section
              const SizedBox(height: 16),
              _buildSectionHeader("Project Images"),
              ..._imageLinks.asMap().entries.map((entry) => Column(
                children: [
                  _buildTextInput(entry.value, "Image URL ${entry.key + 1}"),
                  if (entry.key == _imageLinks.length - 1)
                    _buildAddButton(
                      "Add Another Image",
                      _addImageLink,
                      icon: Icons.add_photo_alternate_outlined,
                    ),
                ],
              )),

              // Description
              const SizedBox(height: 16),
              _buildSectionHeader("Description"),
              _buildTextInput(_descriptionController, "Tell your project story...", maxLines: 5),

              // Tools Used
              const SizedBox(height: 16),
              _buildSectionHeader("Tools & Technologies"),
              _buildTextInput(_toolsUsedController, "Photoshop, Illustrator, etc."),

              // Creative Fields
              const SizedBox(height: 16),
              _buildSectionHeader("Creative Fields"),
              Row(
                children: [
                  Expanded(
                    child: _buildTextInput(
                      _creativeFieldController,
                      "Enter creative field",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addCreativeField,
                  ),
                ],
              ),
              Wrap(
                children: _creativeFields
                    .map((field) => Chip(
                  label: Text(
                    field,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey[800],
                ))
                    .toList(),
              ),

              // Submit Button
              const SizedBox(height: 20),
              Center(
                child: _buildSubmitButton("Update", _updateForm),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.blue[400]),
        label: Text(
          text,
          style: TextStyle(color: Colors.blue[400]),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.blue[400]!),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[400],
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }
}
