import 'package:flutter/material.dart';
import '../Widgets/bottom_nav.dart';

class AboutInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          "About",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Information"),
            _buildInputField('First Name'),
            _buildInputField('Last Name'),
            _buildInputField('Birth Month'),
            _buildInputField('Birth Year'),

            _buildSectionTitle("Social Links"),
            _buildInputField('Instagram Link', icon: Icons.link),
            _buildInputField('LinkedIn Link', icon: Icons.link),
            _buildInputField('Website Link', icon: Icons.web),

            _buildSectionTitle("Professional Details"),
            _buildInputField('Work Experience', maxLines: 3),
            _buildInputField('Focus Area', maxLines: 2),

            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {},
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildInputField(String label, {IconData? icon, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 8),
          TextField(
            style: TextStyle(color: Colors.white),
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
              hintText: 'Enter your $label',
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
