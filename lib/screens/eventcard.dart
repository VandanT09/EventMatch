import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String description;
  final String image = "images/convert.webp"; // Path to the image

  const EventCard({
    super.key,
    required this.eventName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.10, // 10% from the top
        bottom: screenHeight * 0.35, // 35% from the bottom
        left: 16.0, // Horizontal padding
        right: 16.0, // Horizontal padding
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // More rounded corners
        ),
        elevation: 10,
        child: SizedBox(
          width: screenWidth, // Full screen width minus padding
          height: screenHeight * 0.55, // 55% of screen height
          child: Column(
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ), // Rounded corners for the image
                child: Image.asset(
                  image, // Use the asset image path
                  width: double.infinity,
                  height: screenHeight * 0.3, // 30% of screen height
                  fit: BoxFit.cover, // Ensure the image covers the container
                ),
              ),
              // Text Section
              Padding(
                padding: const EdgeInsets.all(16.0), // Padding around the text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event name
                    SizedBox(
                      width: double.infinity, // Make text span the card width
                      child: Text(
                        eventName,
                        style: const TextStyle(
                          fontSize: 28, // Larger font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Event description
                    SizedBox(
                      width: double.infinity, // Make text span the card width
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14, // Smaller font size
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage example
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Column(
          children: [
            Expanded(child: Container()), // Spacer at the top
            const EventCard(
              eventName: "Event Name",
              description:
                  "Join us for an exciting and interactive experience at [Event Title Here]! This event is designed to bring together [target audience] for a day filled with [describe event activities].",
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red, size: 50),
                    onPressed: () {
                      print("Disliked!");
                    },
                  ),
                  const SizedBox(width: 60),
                  IconButton(
                    icon: const Icon(Icons.favorite,
                        color: Colors.green, size: 50),
                    onPressed: () {
                      print("Liked!");
                    },
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
