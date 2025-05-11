class Event {
  final String organiserId;
  final String name;
  final String genre;
  final String ageGroup;
  final String location;

  Event({
    required this.organiserId,
    required this.name,
    required this.genre,
    required this.ageGroup,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      organiserId: json['Organiser ID'] ?? '',
      name: json['Event Name'] ?? '',
      genre: json['Event Genre'] ?? '',
      ageGroup: json['Age Group Allowed'] ?? '',
      location: json['Location'] ?? '',
    );
  }
}
