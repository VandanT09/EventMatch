import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class EventPreferencePage extends StatefulWidget {
  final String name;
  const EventPreferencePage({super.key, required this.name});

  @override
  _EventPreferencePageState createState() => _EventPreferencePageState();
}

class _EventPreferencePageState extends State<EventPreferencePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> allGenres = [
    "Music",
    "Sports",
    "Technology",
    "Art",
    "Theatre",
    "Workshops",
    "Gaming",
    "Food",
    "Fashion",
    "Travel",
    "Photography",
    "Comedy",
    "Health",
    "Startup",
    "Networking",
    "Education",
    "Spirituality",
    "Literature",
    "Fitness",
    "Adventure",
    "Dance",
    "Marathon",
    "Environment",
    "Wildlife",
    "Film",
    "Poetry",
    "Book Clubs",
    "Coding",
    "Cryptocurrency",
    "Robotics",
    "Finance",
    "Investments"
  ];

  List<String> filteredGenres = [];
  List<String> selectedGenres = [];

  @override
  void initState() {
    super.initState();
    filteredGenres = List.from(allGenres);
  }

  void _filterGenres(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredGenres = List.from(allGenres);
      } else {
        filteredGenres = allGenres
            .where((g) => g.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleGenreSelection(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  Future<void> saveUserPreferences() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': widget.name,
        'displayName':
            widget.name, // Add this line to save the name to displayName field
        'eventPreferences':
            selectedGenres, // Change from 'preferences' to 'eventPreferences'
        'interests':
            selectedGenres, // Optionally save to interests field too for compatibility
        'updatedAt': FieldValue.serverTimestamp(), // Add updatedAt field
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving preferences: $e')),
      );
    }
  }

  void _onContinuePressed() async {
    if (selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one preference!')),
      );
      return;
    }

    await saveUserPreferences();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Event Preference',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterGenres,
              decoration: InputDecoration(
                hintText: 'Search event genre...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: filteredGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return GestureDetector(
                    onTap: () => _toggleGenreSelection(genre),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        genre,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _onContinuePressed,
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
