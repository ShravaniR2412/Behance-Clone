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

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Success", style: TextStyle(color: Colors.white)),
          content: Text("Project saved successfully!", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: Colors.blue[400])),
            ),
          ],
        ),
      );

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Add New Project",
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
                    child: _buildTextInput(_creativeFieldController, "Add a field (e.g. Graphic Design)"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 28),
                    onPressed: _addCreativeField,
                  ),
                ],
              ),
              if (_creativeFields.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _creativeFields.map((field) => Chip(
                    label: Text(field, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.blue[800],
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _creativeFields.remove(field);
                      });
                    },
                  )).toList(),
                ),
              ],

              // Submit Button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "PUBLISH PROJECT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.add, color: Colors.blue[400], size: 20),
        label: Text(
          text,
          style: TextStyle(
            color: Colors.blue[400],
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.blue[400]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}