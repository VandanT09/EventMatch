import 'package:flutter/material.dart';
import 'about_page.dart'; // Import About Page

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  void _showComingSoonMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature feature coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(221, 12, 11, 11),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            subtitle: const Text("Turn on/off event notifications"),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark mode theme"),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.language),
          //   title: const Text("Change Language"),
          //   onTap: () => _showComingSoonMessage("Language settings"),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.lock),
          //   title: const Text("Privacy & Security"),
          //   onTap: () => _showComingSoonMessage("Privacy settings"),
          // ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
