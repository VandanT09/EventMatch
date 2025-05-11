import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'event_preferences_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailControllerLogin = TextEditingController();
  final TextEditingController _passwordControllerLogin =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool isLogin = true;
  static const Color brandColor = Color(0xFFE86343);

  Future<void> signupWithEmailPass(String emailAddress, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Set additional user info including displayName and bio
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': 'Pranjal',
          'email': emailAddress,
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'location': _locationController.text.trim(),
          'bio':
              'Hello! I am Pranjal, 50, from Mumbai. I love doing various art work, and Music.', // Add predefined bio here
          'displayName': 'Pranjal', // Add displayName here
          'createdAt': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EventPreferencePage(name: 'Pranjal'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorDialog("Email already in use.");
      } else if (e.code == 'weak-password') {
        _showErrorDialog("The password provided is too weak.");
      } else {
        _showErrorDialog(e.message ?? "Authentication error.");
      }
    } catch (e) {
      _showErrorDialog("Unexpected error: $e");
    }
  }

  Future<void> signinWithEmailPass(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog('No account found. Please sign up first.');
      } else {
        _showErrorDialog(e.message ?? "An error occurred");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _checkAdminPasscode() {
    TextEditingController passcodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Admin Access"),
        content: TextField(
          controller: passcodeController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Enter Admin Passcode'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: brandColor),
            onPressed: () {
              if (passcodeController.text.trim() == 'pass@123') {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Incorrect admin passcode.")),
                );
              }
            },
            child: const Text('Enter'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: brandColor),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
      {required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: brandColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("images/EventMatch_NoBg.jpg", height: 100),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.email,
            controller: _emailControllerLogin,
            label: 'Email'),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.lock,
            controller: _passwordControllerLogin,
            label: 'Password',
            isPassword: true),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          text: 'Sign in',
          onPressed: () {
            signinWithEmailPass(
              _emailControllerLogin.text.trim(),
              _passwordControllerLogin.text.trim(),
            );
          },
        ),
        TextButton(
          onPressed: _checkAdminPasscode,
          child: const Text('Sign in as Admin',
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Don't have an account?",
              style: TextStyle(color: Colors.black54)),
          TextButton(
            onPressed: () => setState(() => isLogin = false),
            child: const Text("Create Account!",
                style: TextStyle(color: Colors.blue)),
          ),
        ]),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("images/EventMatch_NoBg.jpg", height: 100),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.person, controller: _nameController, label: 'Name'),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.calendar_today,
            controller: _ageController,
            label: 'Age',
            keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.location_on,
            controller: _locationController,
            label: 'Location'),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.email, controller: _emailController, label: 'Email'),
        const SizedBox(height: 16),
        _buildTextField(
            icon: Icons.lock,
            controller: _passwordController,
            label: 'Password',
            isPassword: true),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          text: 'Sign Up',
          onPressed: () {
            signupWithEmailPass(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
          },
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Already have an account?",
              style: TextStyle(color: Colors.black54)),
          TextButton(
            onPressed: () => setState(() => isLogin = true),
            child: const Text("Login", style: TextStyle(color: Colors.blue)),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    'EventMatch',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => isLogin = true),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: isLogin ? brandColor : Colors.grey,
                                fontWeight: isLogin
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() => isLogin = false),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: !isLogin ? brandColor : Colors.grey,
                                fontWeight: !isLogin
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 24),
                          child:
                              isLogin ? _buildSignInForm() : _buildSignUpForm(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 16
                            : 0,
                        top: 16,
                      ),
                      child: const Text(
                        'By proceeding, you agree to EventMatch\'s Privacy Policy, User Agreement and T&Cs.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
