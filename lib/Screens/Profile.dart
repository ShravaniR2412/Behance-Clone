import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/auth_provider.dart';
import 'package:provider/provider.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final List<TextEditingController> _imageLinks = [TextEditingController()];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _toolsUsedController = TextEditingController();
  final List<String> _creativeFields = [];
  final TextEditingController _creativeFieldController = TextEditingController();

  // Add image link
  void _addImageLink() {
    setState(() {
      _imageLinks.add(TextEditingController());
    });
  }

  // Add creative field
  void _addCreativeField() {
    if (_creativeFieldController.text.isNotEmpty) {
      setState(() {
        _creativeFields.add(_creativeFieldController.text);
        _creativeFieldController.clear();
      });
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // Submit form data
  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty ||
        _taglineController.text.isEmpty ||
        _imageLinks.any((controller) => controller.text.isEmpty) ||
        _descriptionController.text.isEmpty ||
        _toolsUsedController.text.isEmpty ||
        _creativeFields.isEmpty) {
      _showErrorDialog("Please fill in all fields before submitting.");
      return;
    }

    // Convert image controllers to a list of links
    List<String> imageLinks = _imageLinks.map((controller) => controller.text).toList();
    String email = Provider.of<AuthProviderFunction>(context, listen: false).email ?? "";

    if (email.isEmpty) {
      _showErrorDialog("Email is missing. Please log in first.");
      return;
    }

    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('project').doc(email);

      DocumentSnapshot docSnapshot = await userDocRef.get();
      Map<String, dynamic> existingProjects = {};

      if (docSnapshot.exists) {
        existingProjects = (docSnapshot.data() as Map<String, dynamic>?)?['projectDetails'] as Map<String, dynamic>? ?? {};
      }

      int nextIndex = existingProjects.keys.isEmpty
          ? 0
          : existingProjects.keys.map(int.parse).reduce((a, b) => a > b ? a : b) + 1;

      // New project entry
      Map<String, dynamic> newProject = {
        "title": _titleController.text,
        "tagline": _taglineController.text,
        "imageLinks": imageLinks,
        "description": _descriptionController.text,
        "toolsUsed": _toolsUsedController.text,
        "creativeFields": _creativeFields,
        "timestamp": FieldValue.serverTimestamp(),
      };

      existingProjects["$nextIndex"] = newProject;

      await userDocRef.set({
        "email": email,
        "projectDetails": existingProjects,
      }, SetOptions(merge: true));

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text("Project saved successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );

      // Clear fields
      _titleController.clear();
      _taglineController.clear();
      _descriptionController.clear();
      _toolsUsedController.clear();
      _creativeFields.clear();
      setState(() {
        _imageLinks.clear();
        _imageLinks.add(TextEditingController());
      });

    } catch (e) {
      _showErrorDialog("Failed to save project: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Project", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                _buildTextInput(_titleController, "Project Title"),

                // Tagline Input
                _buildTextInput(_taglineController, "Tagline"),

                // Image Links
                Text("Project Images", style: _sectionTitleStyle),
                ..._imageLinks.map((controller) => _buildTextInput(controller, "Image URL")),
                _buildAddButton("Add More Images", _addImageLink),

                // Description
                Text("Description", style: _sectionTitleStyle),
                _buildTextInput(_descriptionController, "Enter project description", maxLines: 3),

                // Tools Used
                Text("Tools Used", style: _sectionTitleStyle),
                _buildTextInput(_toolsUsedController, "Enter tools used"),

                // Creative Fields
                Text("Creative Fields", style: _sectionTitleStyle),
                Row(
                  children: [
                    Expanded(child: _buildTextInput(_creativeFieldController, "Enter creative field")),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: _addCreativeField,
                    ),
                  ],
                ),
                Wrap(
                  children: _creativeFields
                      .map((field) => Chip(label: Text(field), backgroundColor: Colors.teal))
                      .toList(),
                ),

                // Submit Button
                SizedBox(height: 20),
                Center(child: _buildSubmitButton("Submit", _submitForm)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
    );
  }

  Widget _buildSubmitButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
    );
  }

  TextStyle get _sectionTitleStyle => TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
}
