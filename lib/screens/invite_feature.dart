import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import 'home_page.dart'; // For generating random invite codes

class InvitePage extends StatelessWidget {
  const InvitePage({super.key});

  // Function to generate a random invite code
  String _generateInviteCode() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // Characters for the code
    final Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        8, // Length of the invite code
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String inviteCode =
        _generateInviteCode(); // Generate a random invite code

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text("Invite Friends"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          color: Colors.white, // Set the title text color to white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Invite Illustration
            Image.asset(
              'images/convert.webp', // Your illustration asset
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              "Invite Your Friends",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Subtitle
            const Text(
              "Share the EventMatch app with your friends and enjoy events together!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Invite Button
            ElevatedButton.icon(
              onPressed: () {
                _shareApp(context,
                    inviteCode); // Pass the invite code to the share function
              },
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text(
                "Share App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Invite Code Section
            const Text(
              "Your Unique Invite Code:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                inviteCode, // Display the dynamically generated invite code
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to share the app with an invite code
  void _shareApp(BuildContext context, String inviteCode) {
    final String appLink = "https://yourapplink.com"; // Placeholder link
    final String message =
        "Hey! Check out EventMatch, an awesome app for discovering and joining events. Use my invite code ($inviteCode) to join: $appLink";

    Share.share(message).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invite sent successfully!"),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
