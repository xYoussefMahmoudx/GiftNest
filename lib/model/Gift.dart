import 'dart:typed_data';

class Gift {
  int? id;
  int eventId;
  String title;
  String? description;
  double price;
  String status;
  String category;
  Uint8List? image;
  String? lastEdited;

  Gift({
    this.id,
    required this.eventId,
    required this.title,
    this.description,
    required this.price,
    required this.status,
    required this.category,
    this.image,
    this.lastEdited,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
      'category': category,
      'image': image,
      'last_edited':lastEdited,

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
      category: map['category'],
      image: map['image'],
      lastEdited: map['last_edited'],
    );
  }
}
