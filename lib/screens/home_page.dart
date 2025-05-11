import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_eventmatch/screens/invite_feature.dart';
import 'eventcard.dart';
import 'search_page.dart';
import 'videos_page.dart';
import 'profile_page.dart';
import 'calender_page.dart';
import 'settings_page.dart';
import 'help_feedback_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<bool> _isHovering = [false, false, false, false];

  // Events list
  List<Map<String, dynamic>> _events = [];
  bool _isLoadingEvents = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Fetch events from Firestore
  Future<void> _fetchEvents() async {
    setState(() {
      _isLoadingEvents = true;
    });

    try {
      // Fetch all available events
      final eventsSnapshot =
          await FirebaseFirestore.instance.collection('events').get();

      _events = eventsSnapshot.docs
          .map((doc) => doc.data()..addAll({'id': doc.id}))
          .toList();

      // Shuffle events for variety
      _events.shuffle();

      setState(() {
        _isLoadingEvents = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        _isLoadingEvents = false;
      });
    }
  }

  Future<void> saveBookmarkedEvent(Map<String, dynamic> eventData) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // Ensure we have an ID for the event
      String eventId =
          eventData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

      // Check if the event is already bookmarked
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bookmarkedEvents')
          .doc(eventId);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Add missing fields if necessary
        final completeEventData = {
          ...eventData,
          'id': eventId,
          'bookmarkedAt': FieldValue.serverTimestamp(),
          'title': eventData['title'] ?? 'Untitled Event',
          'description': eventData['description'] ?? 'No description available',
          'category': eventData['category'] ?? 'General',
          // Any other fields you want to include
        };

        // Save to Firestore
        await docRef.set(completeEventData);

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Event bookmarked!"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Already bookmarked
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Event already bookmarked"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error bookmarking event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error bookmarking event: ${e.toString()}"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void onBookmarkPressed(Map<String, dynamic> eventData) {
    saveBookmarkedEvent(eventData);
  }

  // Basic event interaction recording
  Future<void> _recordEventInteraction(String eventId, bool isLiked) async {
    await saveUserInteraction(eventId, isLiked);
  }

  // Event like/dislike handler
  void onEventRated(String eventId, String eventCategory, bool isLiked) {
    _recordEventInteraction(eventId, isLiked);
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideosPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      default:
        break;
    }
  }

  void _onHover(int index, bool hovering) {
    setState(() {
      _isHovering[index] = hovering;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await FirebaseAuth.instance.signOut(); // 🔐 Sign out

                // ✅ Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You have been logged out."),
                    duration: Duration(seconds: 2),
                  ),
                );

                // 🔁 Navigate to login/auth page
                Navigator.pushReplacementNamed(context, '/auth');
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Refresh events
  void _refreshEvents() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Refreshing events..."),
        duration: Duration(seconds: 2),
      ),
    );

    await _fetchEvents();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Events updated!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      label: label,
      icon: MouseRegion(
        onEnter: (_) => _onHover(index, true),
        onExit: (_) => _onHover(index, false),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isHovering[index] ? 40 : 0,
              height: _isHovering[index] ? 40 : 0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
            ),
            isDarkMode && isSelected
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      icon,
                      color: index == 2
                          ? Colors.red
                          : index == 1
                              ? Colors.tealAccent[400]
                              : index == 3
                                  ? Colors.blue
                                  : Colors.black54,
                    ),
                  )
                : Icon(icon),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            const Text('Home Page'),
            if (_isLoadingEvents)
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 15,
                height: 15,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh events',
            onPressed: _refreshEvents,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.messenger_outline_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Messenger coming soon!")),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black87),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/EventMatch_Adobe.png',
                      height: 80, width: 80, fit: BoxFit.contain),
                  const SizedBox(height: 10),
                  const Text(
                    'EventMatch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalendarPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Invite Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvitePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpAndFeedbackPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Main event list
          Expanded(
            child: EventCardScreen(
              onBookmark: onBookmarkPressed,
              onEventRated: onEventRated, // Basic rating callback
              recommendedEvents: _events, // Pass events
              isLoading: _isLoadingEvents,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          _buildNavItem(Icons.home_filled, 'Home', 0),
          _buildNavItem(Icons.search, 'Search', 1),
          _buildNavItem(Icons.video_library_outlined, 'Videos', 2),
          _buildNavItem(Icons.person_outline, 'Profile', 3),
        ],
      ),
    );
  }
}

// 🔄 Save interaction to Firestore (Like/Dislike)
Future<void> saveUserInteraction(String eventId, bool isLiked) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final userDocRef =
      FirebaseFirestore.instance.collection('user_interactions').doc(uid);

  final fieldToUpdate = isLiked ? 'likedEvents' : 'dislikedEvents';
  final oppositeField = isLiked ? 'dislikedEvents' : 'likedEvents';

  // Atomic update to add to one array and remove from the other
  await userDocRef.set({
    fieldToUpdate: FieldValue.arrayUnion([eventId]),
    oppositeField: FieldValue.arrayRemove(
        [eventId]), // Remove from opposite list if exists
    'lastInteractionAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
