class Friendship {
  int userId;
  int friendId;
  String status;

  Friendship({
    required this.userId,
    required this.friendId,
    required this.status,
  });


  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'friend_id': friendId,
      'status': status,
    };
  }


  factory Friendship.fromMap(Map<String, dynamic> map) {
    return Friendship(
      userId: map['user_id'],
      friendId: map['friend_id'],
      status: map['status'],
    );
  }
}
