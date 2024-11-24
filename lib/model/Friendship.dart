class Friendship {
  int userId;
  int friendId;
  String status;

  Friendship({
    required this.userId,
    required this.friendId,
    required this.status,
  });

  // Convert Friendship to Map for database
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'friend_id': friendId,
      'status': status,
    };
  }

  // Convert Map to Friendship
  factory Friendship.fromMap(Map<String, dynamic> map) {
    return Friendship(
      userId: map['user_id'],
      friendId: map['friend_id'],
      status: map['status'],
    );
  }
}
