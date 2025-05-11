import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Helper method to normalize date by removing time component
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Store events with normalized dates as strings
  final Map<String, List<Map<String, dynamic>>> _events = {
    '2025-02-12': [
      {
        "title": "Dribbble Meetup",
        "description": "Designer networking event",
        "time": "19:00 PM"
      },
      {
        "title": "Meeting with Joel",
        "description": "Discuss app development",
        "time": "17:30 PM"
      },
      {
        "title": "John's Birthday",
        "description": "Celebration all day",
        "time": "ALL DAY"
      }
    ],
    '2025-02-15': [
      {
        "title": "Team Meeting",
        "description": "Weekly team sync",
        "time": "10:00 AM"
      }
    ],
    '2025-02-14': [
      {
        "title": "Valentine's Day Event",
        "description": "Special company celebration",
        "time": "14:00 PM"
      },
      {
        "title": "Client Presentation",
        "description": "Product demo for new client",
        "time": "16:30 PM"
      }
    ],
    '2025-02-25': [
      {
        "title": "Women's Day Conference",
        "description": "Annual leadership summit",
        "time": "09:00 AM"
      },
      {
        "title": "Team Lunch",
        "description": "Celebration lunch with team",
        "time": "12:30 PM"
      }
    ],
    '2025-02-28': [
      {
        "title": "Q2 Planning",
        "description": "Quarterly planning meeting",
        "time": "10:00 AM"
      },
      {
        "title": "Budget Review",
        "description": "Financial planning for Q2",
        "time": "14:00 PM"
      }
    ],
    '2025-02-11': [
      {
        "title": "Tech Conference",
        "description": "Annual technology conference",
        "time": "ALL DAY"
      }
    ]
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    String dateKey =
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    return _events[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> selectedDayEvents =
        _getEventsForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.shade400,
                          ),
                          width: 6.0,
                          height: 6.0,
                        ),
                      ),
                    ],
                  );
                }
                return null;
              },
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: selectedDayEvents.isNotEmpty
                ? ListView.builder(
                    itemCount: selectedDayEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedDayEvents[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.event,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          title: Text(
                            event['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                event['description'],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event['time'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No events for this day",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
