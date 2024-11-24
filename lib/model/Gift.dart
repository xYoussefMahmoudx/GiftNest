class Gift {
  int? id;
  int eventId;
  String title;
  String? description;
  double price;
  String status;

  Gift({
    this.id,
    required this.eventId,
    required this.title,
    this.description,
    required this.price,
    required this.status,
  });

  // Convert Gift to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
    };
  }

  // Convert Map to Gift
  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      eventId: map['event_id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      status: map['status'],
    );
  }
}
