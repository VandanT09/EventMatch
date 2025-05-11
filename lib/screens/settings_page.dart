import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  void _showComingSoonMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature feature coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

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
            value: isDarkMode,
            onChanged: (bool value) {
              themeNotifier.toggleTheme(value);
            },
          ),
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
