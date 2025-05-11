import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ticket_booking_page.dart';
import 'dart:math';

// Function to generate a random date within the next 30 days
String generateRandomDate() {
  final random = Random();
  final now = DateTime.now();
  final randomDays =
      random.nextInt(30); // Random number of days within the next 30 days
  final randomDate = now.add(Duration(days: randomDays));

  // Format the date (e.g., 2025-05-30)
  return '${randomDate.year}-${randomDate.month.toString().padLeft(2, '0')}-${randomDate.day.toString().padLeft(2, '0')}';
}

// Function to generate a random price between 100 and 1000
double generateRandomPrice() {
  final random = Random();
  // Random price between 100 and 1000
  return 100 + random.nextInt(900).toDouble();
}

class EventCardScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onBookmark;

  const EventCardScreen(
      {super.key,
      this.onBookmark,
      required void Function(String eventId, String eventCategory, bool isLiked)
          onEventRated,
      required List<Map<String, dynamic>> recommendedEvents,
      required bool isLoading});

  @override
  _EventCardScreenState createState() => _EventCardScreenState();
}

class _EventCardScreenState extends State<EventCardScreen> {
  final CardSwiperController _controller = CardSwiperController();
  String? _swipeFeedback;
  int? _currentEventIndex;

  final List<bool> _savedEvents = List.filled(22, false);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = 'test_user_123'; // Replace with FirebaseAuth UID later

  final List<Map<String, String>> events = [
    {
      "name": "ColdPlay",
      "description":
          "Coldplay is a British rock band formed in London in 1997...",
      "image": "images/convert.webp"
    },
    {
      "name": "Music Fest",
      "description": "A great music event featuring top artists!",
      "image": "images/360_F_1035112255_A9mSbSC4sSJJj4S9Y4eDzxNa7DIqUzed.webp"
    },
    {
      "name": "ChainSmokers",
      "description": "The Chainsmokers are an American electronic DJ duo...",
      "image": "images/celebration-with-balloons-hats-and-horns.webp"
    },
    {
      "name": "SunBurn",
      "description":
          "Sunburn Festival is a commercial electronic dance music festival...",
      "image": "images/cropped-hands-holding-sparkler-at-night-bangladesh.webp"
    },
    {
      "name": "Food Carnival",
      "description":
          "A food carnival showcasing mouth-watering dishes from around the world.",
      "image": "images/crowd-music-concert_1048944-10571616.webp"
    },
    {
      "name": "YouTube FanFest",
      "description":
          "YouTube FanFest brings together fans of games, sports, and entertainment.",
      "image": "images/party-time.webp"
    },
    {
      "name": "Electronic Beats Festival",
      "description":
          "Electronic Beats Festival brings together fans of music, sports, and entertainment.",
      "image": "images/DJ-crowd.webp"
    },
    {
      "name": "Soccer World Cup",
      "description":
          "Soccer World Cup brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_116250654_SNR51fpqWlyj6WrvQbaYTiR8RLefa8rt.webp"
    },
    {
      "name": "Tennis Grand Slam",
      "description":
          "Tennis Grand Slam brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_1158125502_lpWGmBXtgRMdIkvAkDT2KmM0BpkIqHz3.webp"
    },
    {
      "name": "Tech Innovations Expo",
      "description":
          "Tech Innovations Expo brings together fans of tech enthusiasts and entertainment.",
      "image": "images/0x0.webp"
    },
    {
      "name": "AI & Robotics Summit",
      "description":
          "AI & Robotics Summit brings together AI, ML & lots of complex architecture into picture.",
      "image": "images/image-generator-freepik-7.webp"
    },
    {
      "name": "Web Development",
      "description":
          "Web Development Conference. Web 2.0, 3.0 is here! Explore the realm thrill of making and designing websites from scratch!",
      "image": "images/360_F_552794679_X6Jg3Hn2MdCHvMNTyBPzHx5vOTqoaE2e.webp"
    },
    {
      "name": "Modern Art Exhibit",
      "description":
          "Modern Art Exhibitio brings together fans of art, music, and fashion.",
      "image": "images/360_F_1036665878_9xNdHickJpGkgXucpSFDoyapCBmUN5tY.webp"
    },
    {
      "name": "Street Art Festival",
      "description":
          "Street Art Festival brings together fans of streets of India, sports, and entertainment.",
      "image": "images/chi-street-art-1800x900.webp"
    },
    {
      "name": "Modern Drama Play",
      "description":
          "Modern Drama Play brings together fans of games, sports, and entertainment.",
      "image": "images/classical-theatre.webp"
    },
    {
      "name": "Coding Bootcamp",
      "description":
          "Coding Bootcamp brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_297078136_J3kH3VoAy4QcVuGbF0HQP2BaNCpaF7gP.webp"
    },
    {
      "name": "Creative Writing Workshop",
      "description":
          "Creative Writing Workshop brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_1411553904_hpm4ZNjpUMRaWTea57ML423oWB0eKjLl.webp"
    },
    {
      "name": "E-sports Tournament",
      "description":
          "E-sports Tournament brings together fans of games, sports, and entertainment.",
      "image": "images/esports-arena.webp"
    },
    {
      "name": "Gourmet Dinner Party",
      "description":
          "Gourmet Dinner Party brings together fans of games, sports, and entertainment.",
      "image":
          "images/smiling-mature-husband-and-wife-toasting-with-wine-at-dinner.webp"
    },
    {
      "name": "VR Gaming Experience",
      "description":
          "VR Gaming Experience brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_1144239139_4QWN1AoLoMH1TWuuRZ7c7DwDenPfeYSh.webp"
    },
    {
      "name": "Vintage Clothing Market",
      "description":
          "Vintage Clothing Market brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_111505345_gWgyxCe1ujllUf3Ww5XDZW09i4D4MHFs.webp"
    },
    {
      "name": "Shakespeare’s Art",
      "description":
          "Shakespeare’s Globe Performance brings together fans of games, sports, and entertainment.",
      "image": "images/360_F_1035112255_A9mSbSC4sSJJj4S9Y4eDzxNa7DIqUzed.webp"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CardSwiper(
                  controller: _controller,
                  cardsCount: events.length,
                  onSwipe: (previousIndex, targetIndex, direction) {
                    setState(() {
                      if (direction == CardSwiperDirection.right ||
                          direction == CardSwiperDirection.top) {
                        _swipeFeedback = 'LIKE';

                        _firestore.collection('user_actions').add({
                          'userId': userId,
                          'eventName': events[previousIndex]['name'],
                          'action': 'like',
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      } else if (direction == CardSwiperDirection.left) {
                        _swipeFeedback = 'DISLIKE';

                        _firestore.collection('user_actions').add({
                          'userId': userId,
                          'eventName': events[previousIndex]['name'],
                          'action': 'dislike',
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      } else {
                        _swipeFeedback = null;
                      }

                      _currentEventIndex = targetIndex;

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _swipeFeedback = null;
                        });
                      });
                    });
                    return true;
                  },
                  cardBuilder: (context, index, hOffset, vOffset) {
                    final eventMap = events[index];

                    // Generate random date and price for each event
                    String date = generateRandomDate();
                    double price = generateRandomPrice();

                    String name = eventMap['name'] ?? 'No Name';
                    String description =
                        eventMap['description'] ?? 'No Description';
                    String image = eventMap['image'] ??
                        'https://placehold.it/100'; // Provide a placeholder image if null

                    // Create an Event object from the eventMap
                    Event event = Event(
                      name: name,
                      date: date,
                      price: price,
                      description: description,
                      image: image,
                    );

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketBookingPage(event: event),
                              ),
                            );
                          },
                          child: EventCard(
                            eventName: event.name,
                            description: event.description,
                            image: event.image,
                            isSaved: _savedEvents[index],
                          ),
                        ),
                        if (_swipeFeedback != null &&
                            _currentEventIndex == index)
                          Positioned(
                            top: 40,
                            left: _swipeFeedback == 'DISLIKE' ? 20 : null,
                            right: _swipeFeedback == 'LIKE' ? 20 : null,
                            child: Transform.rotate(
                              angle: _swipeFeedback == 'LIKE' ? 0.2 : -0.2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: _swipeFeedback == 'LIKE'
                                      ? Colors.green.withOpacity(0.8)
                                      : Colors.pink.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _swipeFeedback == 'LIKE'
                                        ? Colors.green
                                        : Colors.pink,
                                    width: 3,
                                  ),
                                ),
                                child: Text(
                                  _swipeFeedback!,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNoSwipeButton(
                      FaIcon(FontAwesomeIcons.share,
                          size: 30, color: Color(0xFFA1A3A5)),
                      Colors.white,
                      shareEvent,
                    ),
                    _buildSwipeButton(
                      FaIcon(FontAwesomeIcons.xmark,
                          size: 30, color: Color(0xFF63E6BE)),
                      Colors.white,
                      CardSwiperDirection.left,
                      dislikeEvent,
                    ),
                    _buildSwipeButton(
                      FaIcon(FontAwesomeIcons.solidHeart,
                          size: 30, color: Color(0xFFFB0909)),
                      Colors.white,
                      CardSwiperDirection.right,
                      likeEvent,
                    ),
                    _buildNoSwipeButton(
                      FaIcon(
                        FontAwesomeIcons.solidBookmark,
                        size: 30,
                        color: _savedEvents[_currentEventIndex ?? 0]
                            ? Colors.blue
                            : Color(0xFF439FE5),
                      ),
                      Colors.white,
                      () => bookmarkEvent(_currentEventIndex ?? 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeButton(FaIcon icon, Color bgColor,
      CardSwiperDirection direction, Function onPress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: icon,
        onPressed: () {
          HapticFeedback.lightImpact();
          onPress();
          _controller.swipe(direction);
        },
      ),
    );
  }

  Widget _buildNoSwipeButton(FaIcon icon, Color bgColor, Function onPress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: icon,
        onPressed: () {
          HapticFeedback.lightImpact();
          onPress();
        },
      ),
    );
  }

  void likeEvent() {
    setState(() {
      _swipeFeedback = 'LIKE';
    });

    if (_currentEventIndex != null) {
      final event = events[_currentEventIndex!];
      _firestore.collection('user_actions').add({
        'userId': userId,
        'eventName': event['name'],
        'action': 'like',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void dislikeEvent() {
    setState(() {
      _swipeFeedback = 'DISLIKE';
    });

    if (_currentEventIndex != null) {
      final event = events[_currentEventIndex!];
      _firestore.collection('user_actions').add({
        'userId': userId,
        'eventName': event['name'],
        'action': 'dislike',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void saveEvent() async {
    if (_currentEventIndex != null) {
      final index = _currentEventIndex!;
      final event = events[index];

      await _firestore
          .collection('bookmarked_events')
          .doc('$userId-${event["name"]}')
          .set({
        'userId': userId,
        'eventName': event['name'],
        'description': event['description'],
        'imagePath': event['image'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('user_actions').add({
        'userId': userId,
        'eventName': event['name'],
        'action': 'bookmark',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _toggleBookmark(index);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event Saved to Cloud!")),
      );
    }
  }

  void shareEvent() async {
    final event = events[_currentEventIndex ?? 0];
    final eventDetails = "${event['name']} - ${event['description']}";

    final byteData = await rootBundle.load(event['image']!);
    final buffer = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempImage = File('${tempDir.path}/${event['name']}.jpg');
    await tempImage.writeAsBytes(buffer);

    await Share.shareXFiles(
      [XFile(tempImage.path)],
      text: eventDetails,
      subject: 'Check out this event!',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Shared!")),
    );
  }

  void _toggleBookmark(int index) {
    setState(() {
      _savedEvents[index] = true;
    });
  }

  Future<void> bookmarkEvent(int index) async {
    final event = events[index];

    final bookmarkedEvent = {
      'title': event['name'],
      'description': event['description'],
      'imageUrl': event['image'], // Use real URL if hosted
      'date': '2025-05-15', // Replace with dynamic date if available
      'location': 'London Stadium', // Replace with actual location if available
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Save the event to Firestore under the user's bookmarked events
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('bookmarkedEvents')
          .doc(event['name']) // Unique ID
          .set(bookmarkedEvent);

      setState(() {
        _savedEvents[index] = true;
      });

      // Show a confirmation snackbar that the event is saved to the cloud
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${event['name']} saved to cloud!')),
      );
    } catch (e) {
      print('Error bookmarking event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save ${event['name']} to cloud.')),
      );
    }
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String description;
  final String image;
  final bool isSaved;

  const EventCard({
    super.key,
    required this.eventName,
    required this.description,
    required this.image,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Image.asset(
              image,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
