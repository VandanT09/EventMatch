import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class EventCardScreen extends StatefulWidget {
  const EventCardScreen({Key? key}) : super(key: key);

  @override
  _EventCardScreenState createState() => _EventCardScreenState();
}

class _EventCardScreenState extends State<EventCardScreen> {
  final CardSwiperController _controller = CardSwiperController();
  String? _swipeFeedback;
  int? _currentEventIndex;

  // Store the history of actions (liked, disliked, saved)
  List<Map<String, dynamic>> _actionHistory = [];
  List<bool> _savedEvents = List.filled(6, false); // Track saved events

  final List<Map<String, String>> events = [
    {
      "name": "ColdPlay",
      "description":
          "Coldplay is a British rock band formed in London in 1997. The band consists of vocalist and pianist Chris Martin, guitarist Jonny Buckland, bassist Guy Berryman, drummer Will Champion, and manager Phil Harvey.",
      "image": "images/convert.webp"
    },
    {
      "name": "Music Fest",
      "description": "A great music event featuring top artists!",
      "image": "images/360_F_1035112255_A9mSbSC4sSJJj4S9Y4eDzxNa7DIqUzed.webp"
    },
    {
      "name": "ChainSmokers",
      "description":
          "The Chainsmokers are an American electronic DJ and production duo consisting of Alex Pall and Drew Taggart.",
      "image": "images/celebration-with-balloons-hats-and-horns.webp"
    },
    {
      "name": "SunBurn",
      "description":
          "Sunburn Festival is a commercial electronic dance music festival held in India. It was started by entrepreneur Shailendra Singh of Percept Ltd.",
      "image": "images/cropped-hands-holding-sparkler-at-night-bangladesh.webp"
    },
    {
      "name": "Food Carnival",
      "description":
          "A food carnival event is a celebration that showcases a variety of foods from around the world, often featuring creative and mouth-watering dishes created by experienced chefs.",
      "image": "images/crowd-music-concert_1048944-10571616.webp"
    },
    {
      "name": "YouTube FanFest",
      "description":
          "YouTube FanFest is a unique event that brings together fans of various franchises, including video games, sports, and entertainment.",
      "image": "images/party-time.webp"
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
                      // Determine LIKE or DISLIKE
                      if (direction == CardSwiperDirection.right ||
                          direction == CardSwiperDirection.top) {
                        _swipeFeedback = 'LIKE';
                      } else if (direction == CardSwiperDirection.left) {
                        _swipeFeedback = 'DISLIKE';
                      } else {
                        _swipeFeedback = null;
                      }

                      // Store the action in history (if it's LIKE or DISLIKE)
                      if (_swipeFeedback != null) {
                        _actionHistory.add({
                          'eventIndex': previousIndex,
                          'action': _swipeFeedback,
                        });
                      }

                      // Update current event index
                      _currentEventIndex = targetIndex;

                      // Reset the swipe feedback after 1 second
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _swipeFeedback = null;
                        });
                      });
                    });
                    return true;
                  },
                  cardBuilder: (context, index, horizontalOffsetPercentage,
                      verticalOffsetPercentage) {
                    final event = events[index];
                    return Stack(
                      children: [
                        EventCard(
                          eventName: event['name']!,
                          description: event['description']!,
                          image: event['image']!,
                          isSaved: _savedEvents[index],
                        ),
                        // Show LIKE or DISLIKE text if needed
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

              // Bottom Action Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Share button (new functionality)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _buildNoSwipeButton(
                        FaIcon(
                          FontAwesomeIcons.share,
                          size: 30,
                          color: Color(0xFFA1A3A5),
                        ),
                        Colors.white,
                        shareEvent,
                      ),
                    ),

                    // Dislike button
                    _buildSwipeButton(
                      FaIcon(
                        FontAwesomeIcons.xmark,
                        size: 30,
                        color: Color(0xFF63E6BE),
                      ),
                      Colors.white,
                      CardSwiperDirection.left,
                      dislikeEvent,
                    ),

                    // Like button
                    _buildSwipeButton(
                      FaIcon(
                        FontAwesomeIcons.solidHeart,
                        size: 30,
                        color: Color(0xFFFB0909),
                      ),
                      Colors.white,
                      CardSwiperDirection.right,
                      likeEvent,
                    ),

                    // Save button (Bookmark)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildNoSwipeButton(
                        FaIcon(
                          FontAwesomeIcons.solidBookmark,
                          size: 30,
                          color: _savedEvents[_currentEventIndex ?? 0]
                              ? Colors.blue
                              : Color(0xFF439FE5),
                        ),
                        Colors.white,
                        saveEvent,
                      ),
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

  /// Button builder for LIKE and DISLIKE, which triggers a swipe
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
          onPress();
          _controller.swipe(direction); // Triggers the actual card swipe
        },
      ),
    );
  }

  /// Button builder for UNDO and SAVE, which do NOT trigger a swipe
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
          onPress(); // No swipe triggered
        },
      ),
    );
  }

  // Action Methods

  void likeEvent() {
    setState(() {
      _swipeFeedback = 'LIKE';
    });
  }

  void dislikeEvent() {
    setState(() {
      _swipeFeedback = 'DISLIKE';
    });
  }

  void saveEvent() {
    setState(() {
      if (_currentEventIndex != null) {
        _savedEvents[_currentEventIndex!] = true;
        // Call the toggleBookmark method to update the bookmark state
        _toggleBookmark(_currentEventIndex!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event Saved!")),
        );
      }
    });
  }

  /// Share the event details and image
  void shareEvent() async {
    final event = events[_currentEventIndex ?? 0];
    final eventDetails = "${event['name']} - ${event['description']}";

    // Load the image from assets
    final byteData = await rootBundle.load(event['image']!);
    final buffer = byteData.buffer.asUint8List();

    // Get the temporary directory path
    final tempDir = await getTemporaryDirectory();
    final tempImage = File('${tempDir.path}/${event['name']}.jpg');

    // Write the image to the temporary directory
    await tempImage.writeAsBytes(buffer);

    // Share both the text and image using Share.share
    await Share.share(
      eventDetails, // Event details text
      subject: 'Check out this event!', // Optional subject
      sharePositionOrigin: Rect.fromLTWH(0, 0, 0, 0),
    );

    // Optionally, show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Shared!")),
    );
  }

  /// Undo the last LIKE or DISLIKE action, bringing back the last swiped event
  void undoAction() {
    if (_actionHistory.isNotEmpty) {
      setState(() {
        final lastAction = _actionHistory.removeLast();
        final lastEventIndex = lastAction['eventIndex'];

        // Ensure that the lastEventIndex is valid
        if (lastEventIndex != null &&
            lastEventIndex >= 0 &&
            lastEventIndex < events.length) {
          // Simply revert to the previous event in history
          _swipeFeedback = null; // Clear the swipe feedback
          _currentEventIndex =
              lastEventIndex; // Move back to the previous event
        }
      });
    }
  }

  // Toggle bookmark state for an event
  void _toggleBookmark(int index) {
    setState(() {
      _savedEvents[index] =
          !_savedEvents[index]; // Toggle the saved state for the event
    });
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String description;
  final String image;
  final bool isSaved;

  const EventCard({
    Key? key,
    required this.eventName,
    required this.description,
    required this.image,
    required this.isSaved,
  }) : super(key: key);

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
