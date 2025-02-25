import 'package:flutter/material.dart';

class MyEventsPage extends StatefulWidget {
  final List<Map<String, dynamic>> myEvents;

  const MyEventsPage({super.key, required this.myEvents});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  void _bookEvent(int index) {
    setState(() {
      widget.myEvents[index]["booked"] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("${widget.myEvents[index]["title"]} booked successfully!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Events")),
      body: ListView.builder(
        itemCount: widget.myEvents.length,
        itemBuilder: (context, index) {
          final event = widget.myEvents[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(event["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${event["date"]} | ${event["location"]}",
                  style: TextStyle(color: Colors.grey[600])),
              trailing: event["booked"]
                  ? const Text("Already Booked",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold))
                  : ElevatedButton(
                      onPressed: () => _bookEvent(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text("Book Now",
                          style: TextStyle(color: Colors.white)),
                    ),
            ),
          );
        },
      ),
    );
  }
}
