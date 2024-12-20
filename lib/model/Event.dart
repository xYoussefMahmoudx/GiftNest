class Event {
  int? id;
  int userId;
  String title;
  String date;
  String location;
  String? description;
  String category;
  String? lastEdited; // Nullable as it is set by the database

  Event({
    this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.location,
    this.description,
    required this.category,
    this.lastEdited, // Optional for database insertion
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
      'category': category,
      'last_edited':lastEdited,
      // Exclude 'last_edited' from insertion, as it is database-managed
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
      category: map['category'],
      lastEdited: map['last_edited'],
    );
  }
}
