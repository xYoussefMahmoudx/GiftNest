class Event {
  int? id;
  int userId;
  String title;
  String date;
  String location;
  String? description;

  Event({
    this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.location,
    this.description,
  });

  // Convert Event to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'date': date,
      'location': location,
      'description': description,
    };
  }

  // Convert Map to Event
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      date: map['date'],
      location: map['location'],
      description: map['description'],
    );
  }
}
