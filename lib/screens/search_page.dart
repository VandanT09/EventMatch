import 'package:flutter/material.dart';
import 'home_page.dart';
import 'videos_page.dart';
import 'profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _selectedIndex = 1; // Search tab is selected

  final List<String> _categories = [
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

  final Map<String, List<Map<String, String>>> _allEvents = {
    "Music": [
      {
        'title': 'Rock Music Fest',
        'genre': 'Music',
        'location': 'New York',
        'date': '15 May 2025',
        'image': 'https://picsum.photos/400?1'
      },
      {
        'title': 'Jazz Night Live',
        'genre': 'Music',
        'location': 'Paris',
        'date': '18 May 2025',
        'image': 'https://picsum.photos/400?2'
      },
      {
        'title': 'Electronic Beats Festival',
        'genre': 'Music',
        'location': 'Berlin',
        'date': '22 May 2025',
        'image': 'https://picsum.photos/400?3'
      }
    ],
    "Sports": [
      {
        'title': 'Soccer World Cup',
        'genre': 'Sports',
        'location': 'London',
        'date': '25 May 2025',
        'image': 'https://picsum.photos/400?4'
      },
      {
        'title': 'Tennis Grand Slam',
        'genre': 'Sports',
        'location': 'Paris',
        'date': '28 May 2025',
        'image': 'https://picsum.photos/400?5'
      },
      {
        'title': 'Basketball Championship',
        'genre': 'Sports',
        'location': 'Los Angeles',
        'date': '30 May 2025',
        'image': 'https://picsum.photos/400?6'
      }
    ],
    "Technology": [
      {
        'title': 'Tech Innovations Expo',
        'genre': 'Technology',
        'location': 'San Francisco',
        'date': '10 May 2025',
        'image': 'https://picsum.photos/400?7'
      },
      {
        'title': 'AI & Robotics Summit',
        'genre': 'Technology',
        'location': 'Tokyo',
        'date': '12 May 2025',
        'image': 'https://picsum.photos/400?8'
      },
      {
        'title': 'Web Development Conference',
        'genre': 'Technology',
        'location': 'Austin',
        'date': '14 May 2025',
        'image': 'https://picsum.photos/400?9'
      }
    ],
    "Art": [
      {
        'title': 'Modern Art Exhibition',
        'genre': 'Art',
        'location': 'London',
        'date': '16 May 2025',
        'image': 'https://picsum.photos/400?10'
      },
      {
        'title': 'Sculpture Show',
        'genre': 'Art',
        'location': 'New York',
        'date': '18 May 2025',
        'image': 'https://picsum.photos/400?11'
      },
      {
        'title': 'Street Art Festival',
        'genre': 'Art',
        'location': 'Berlin',
        'date': '20 May 2025',
        'image': 'https://picsum.photos/400?12'
      }
    ],
    "Theatre": [
      {
        'title': 'Shakespeare’s Globe Performance',
        'genre': 'Theatre',
        'location': 'London',
        'date': '23 May 2025',
        'image': 'https://picsum.photos/400?13'
      },
      {
        'title': 'Broadway Musical Night',
        'genre': 'Theatre',
        'location': 'New York',
        'date': '25 May 2025',
        'image': 'https://picsum.photos/400?14'
      },
      {
        'title': 'Modern Drama Play',
        'genre': 'Theatre',
        'location': 'Paris',
        'date': '27 May 2025',
        'image': 'https://picsum.photos/400?15'
      }
    ],
    "Workshops": [
      {
        'title': 'Digital Art Workshop',
        'genre': 'Workshops',
        'location': 'London',
        'date': '30 May 2025',
        'image': 'https://picsum.photos/400?16'
      },
      {
        'title': 'Coding Bootcamp',
        'genre': 'Workshops',
        'location': 'New York',
        'date': '2 June 2025',
        'image': 'https://picsum.photos/400?17'
      },
      {
        'title': 'Creative Writing Workshop',
        'genre': 'Workshops',
        'location': 'Paris',
        'date': '5 June 2025',
        'image': 'https://picsum.photos/400?18'
      }
    ],
    "Gaming": [
      {
        'title': 'E-sports Tournament',
        'genre': 'Gaming',
        'location': 'Los Angeles',
        'date': '9 June 2025',
        'image': 'https://picsum.photos/400?19'
      },
      {
        'title': 'VR Gaming Experience',
        'genre': 'Gaming',
        'location': 'Tokyo',
        'date': '12 June 2025',
        'image': 'https://picsum.photos/400?20'
      },
      {
        'title': 'Indie Game Showcase',
        'genre': 'Gaming',
        'location': 'Berlin',
        'date': '15 June 2025',
        'image': 'https://picsum.photos/400?21'
      }
    ],
    "Food": [
      {
        'title': 'Food Festival',
        'genre': 'Food',
        'location': 'New York',
        'date': '17 June 2025',
        'image': 'https://picsum.photos/400?22'
      },
      {
        'title': 'Vegan Cooking Class',
        'genre': 'Food',
        'location': 'Los Angeles',
        'date': '20 June 2025',
        'image': 'https://picsum.photos/400?23'
      },
      {
        'title': 'Gourmet Dinner Party',
        'genre': 'Food',
        'location': 'Paris',
        'date': '23 June 2025',
        'image': 'https://picsum.photos/400?24'
      }
    ],
    "Fashion": [
      {
        'title': 'Fashion Week',
        'genre': 'Fashion',
        'location': 'Paris',
        'date': '25 June 2025',
        'image': 'https://picsum.photos/400?25'
      },
      {
        'title': 'Sustainable Fashion Show',
        'genre': 'Fashion',
        'location': 'London',
        'date': '28 June 2025',
        'image': 'https://picsum.photos/400?26'
      },
      {
        'title': 'Vintage Clothing Market',
        'genre': 'Fashion',
        'location': 'New York',
        'date': '30 June 2025',
        'image': 'https://picsum.photos/400?27'
      }
    ],
    "Travel": [
      {
        'title': 'Adventure Trip to Iceland',
        'genre': 'Travel',
        'location': 'Iceland',
        'date': '3 July 2025',
        'image': 'https://picsum.photos/400?28'
      },
      {
        'title': 'Solo Travel Meetup',
        'genre': 'Travel',
        'location': 'Paris',
        'date': '5 July 2025',
        'image': 'https://picsum.photos/400?29'
      },
      {
        'title': 'Group Travel to Bali',
        'genre': 'Travel',
        'location': 'Bali',
        'date': '8 July 2025',
        'image': 'https://picsum.photos/400?30'
      }
    ],
    "Photography": [
      {
        'title': 'Landscape Photography Workshop',
        'genre': 'Photography',
        'location': 'Sydney',
        'date': '10 July 2025',
        'image': 'https://picsum.photos/400?31'
      },
      {
        'title': 'Street Photography Tour',
        'genre': 'Photography',
        'location': 'Tokyo',
        'date': '12 July 2025',
        'image': 'https://picsum.photos/400?32'
      },
      {
        'title': 'Portrait Photography Masterclass',
        'genre': 'Photography',
        'location': 'London',
        'date': '15 July 2025',
        'image': 'https://picsum.photos/400?33'
      }
    ],
    "Comedy": [
      {
        'title': 'Stand-Up Comedy Night',
        'genre': 'Comedy',
        'location': 'New York',
        'date': '17 July 2025',
        'image': 'https://picsum.photos/400?34'
      },
      {
        'title': 'Improv Comedy Show',
        'genre': 'Comedy',
        'location': 'Los Angeles',
        'date': '19 July 2025',
        'image': 'https://picsum.photos/400?35'
      },
      {
        'title': 'Comedy Roast Battle',
        'genre': 'Comedy',
        'location': 'London',
        'date': '21 July 2025',
        'image': 'https://picsum.photos/400?36'
      }
    ],
    "Health": [
      {
        'title': 'Wellness Retreat',
        'genre': 'Health',
        'location': 'Costa Rica',
        'date': '23 July 2025',
        'image': 'https://picsum.photos/400?37'
      },
      {
        'title': 'Yoga & Meditation Class',
        'genre': 'Health',
        'location': 'Bali',
        'date': '26 July 2025',
        'image': 'https://picsum.photos/400?38'
      },
      {
        'title': 'Mental Health Awareness Seminar',
        'genre': 'Health',
        'location': 'Paris',
        'date': '29 July 2025',
        'image': 'https://picsum.photos/400?39'
      }
    ],
    "Startup": [
      {
        'title': 'Startup Networking Event',
        'genre': 'Startup',
        'location': 'Silicon Valley',
        'date': '2 August 2025',
        'image': 'https://picsum.photos/400?40'
      },
      {
        'title': 'Tech Startup Pitch Night',
        'genre': 'Startup',
        'location': 'New York',
        'date': '4 August 2025',
        'image': 'https://picsum.photos/400?41'
      },
      {
        'title': 'Entrepreneurship Workshop',
        'genre': 'Startup',
        'location': 'London',
        'date': '6 August 2025',
        'image': 'https://picsum.photos/400?42'
      }
    ],
    "Networking": [
      {
        'title': 'Business Networking Event',
        'genre': 'Networking',
        'location': 'San Francisco',
        'date': '8 August 2025',
        'image': 'https://picsum.photos/400?43'
      },
      {
        'title': 'Marketing Networking Meetup',
        'genre': 'Networking',
        'location': 'Berlin',
        'date': '10 August 2025',
        'image': 'https://picsum.photos/400?44'
      },
      {
        'title': 'Entrepreneur Networking Conference',
        'genre': 'Networking',
        'location': 'Tokyo',
        'date': '12 August 2025',
        'image': 'https://picsum.photos/400?45'
      }
    ],
    "Education": [
      {
        'title': 'AI Education Summit',
        'genre': 'Education',
        'location': 'London',
        'date': '14 August 2025',
        'image': 'https://picsum.photos/400?46'
      },
      {
        'title': 'Tech Education Conference',
        'genre': 'Education',
        'location': 'New York',
        'date': '16 August 2025',
        'image': 'https://picsum.photos/400?47'
      },
      {
        'title': 'Coding Bootcamp for Beginners',
        'genre': 'Education',
        'location': 'Paris',
        'date': '18 August 2025',
        'image': 'https://picsum.photos/400?48'
      }
    ],
    "Spirituality": [
      {
        'title': 'Meditation and Healing Retreat',
        'genre': 'Spirituality',
        'location': 'India',
        'date': '20 August 2025',
        'image': 'https://picsum.photos/400?49'
      },
      {
        'title': 'Spiritual Awakening Conference',
        'genre': 'Spirituality',
        'location': 'California',
        'date': '22 August 2025',
        'image': 'https://picsum.photos/400?50'
      },
      {
        'title': 'Yoga and Spirituality Workshop',
        'genre': 'Spirituality',
        'location': 'Bali',
        'date': '24 August 2025',
        'image': 'https://picsum.photos/400?51'
      }
    ]
  };

  List<Map<String, String>> get _filteredEvents {
    final selectedCategory = _categories[_selectedCategoryIndex];
    final allCategoryEvents = _allEvents[selectedCategory] ?? [];

    if (_searchController.text.isEmpty) {
      return allCategoryEvents; // Show all events in the selected category
    }

    final query = _searchController.text.toLowerCase();
    return allCategoryEvents.where((event) {
      return event['title']!.toLowerCase().contains(query) ||
          event['location']!.toLowerCase().contains(query) ||
          event['date']!.toLowerCase().contains(query);
    }).toList();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const VideosPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ProfilePage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildCategoryChip(int index) {
    bool isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(
          _categories[index],
          style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              event['image']!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title']!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${event['location']} • ${event['date']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 12),
                            child: Icon(Icons.search,
                                color: Colors.grey.shade600, size: 26),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 50, minHeight: 50),
                          hintText: 'Search for events...',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              height: 1,
                              fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune,
                          color: Colors.grey.shade600, size: 26),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Filter Options',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                const Text('Filter options will be added here'),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Apply Filters')),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) => _buildCategoryChip(index),
              ),
            ),
            Expanded(
              child: _filteredEvents.isEmpty
                  ? const Center(child: Text('No matching events found.'))
                  : ListView.builder(
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) =>
                          _buildEventCard(_filteredEvents[index]),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined), label: 'Videos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
