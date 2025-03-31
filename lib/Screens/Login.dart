import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/theme.dart';
import '../Widgets/auth_provider.dart';
import '../Screens/Landing.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signInWithEmailPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        Provider.of<AuthProviderFunction>(context, listen: false).setEmail(user.email!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
      } else {
        setState(() {
          _errorMessage = "User not found. Please check your credentials.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Invalid email or password"; // Display a user-friendly error
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Close Button
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.hint),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Adobe Logo
                  Row(
                    children: [
                      Icon(Icons.adobe, size: 40, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Adobe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  SizedBox(height: 8),
                  Text('Step 1 of 2', style: TextStyle(color: AppColors.hint, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('Create an account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 16),

                  // Email Input
                  Text('Sign up with email', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Email address', style: TextStyle(fontSize: 16, color: Colors.black)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.hint)),
                      hintText: 'Enter your email ID',
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password Input
                  Text('Password', style: TextStyle(fontSize: 16, color: Colors.black)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.hint)),
                      hintText: 'Enter your password',
                    ),
                  ),

                  SizedBox(height: 8),
                  if (_errorMessage != null)
                    Text("Invalid email or password", style: TextStyle(color: Colors.red, fontSize: 14)),

                  SizedBox(height: 16),

                  // Password Rules
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('✔ Contain at least 8 characters', style: TextStyle(color: Colors.green[700], fontSize: 14)),
                      Text('✔ Contain both lower and upper case letters', style: TextStyle(color: Colors.green[700], fontSize: 14)),
                      Text('✔ Contain at least one number (0-9) or symbol', style: TextStyle(color: Colors.green[700], fontSize: 14)),
                      Text('✔ Is not commonly used', style: TextStyle(color: Colors.green[700], fontSize: 14)),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Continue Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isLoading ? null : _signInWithEmailPassword,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
