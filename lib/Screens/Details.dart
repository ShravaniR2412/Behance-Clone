import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _artworkTitle;
  String? _artworkDescription;
  String? _imageUrl;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchArtwork() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter an artwork name!";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDDayMTCqv07XNcLT6DoqANosTP66bQRMU"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "Tell me about the artwork '$query' in an artistic and detailed way. Also suggest a related image."
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? resultText = data['candidates']?[0]['content']['parts'][0]['text'] ?? "No description available.";

        setState(() {
          _artworkTitle = query;
          _artworkDescription = resultText;
          _imageUrl = "https://source.unsplash.com/800x600/?$query"; // Placeholder image
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to fetch details. Try again.";
        });
        print("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Behance-style dark theme
      appBar: AppBar(
        title: Text("Artwork Details", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search artwork (e.g. Mona Lisa, Digital Art)",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: _searchArtwork,
                ),
              ),
            ),
            SizedBox(height: 20),

            // 🕒 Loading Indicator
            if (_isLoading) Center(child: CircularProgressIndicator()),

            // ❌ Error Message
            if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            // 🎨 Artwork Details Display
            if (_artworkTitle != null && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 🖼 Artwork Image
                      if (_imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _imageUrl!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 20),

                      // 🏷 Artwork Title
                      Text(
                        _artworkTitle!,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),

                      // 📝 Artwork Description
                      Text(
                        _artworkDescription!,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
