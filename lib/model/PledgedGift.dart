class PledgedGift {
  int userId;
  int giftId;

  PledgedGift({
    required this.userId,
    required this.giftId,
  });


  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'gift_id': giftId,
    };
  }

  // Convert Map to PledgedGift
  factory PledgedGift.fromMap(Map<String, dynamic> map) {
    return PledgedGift(
      userId: map['user_id'],
      giftId: map['gift_id'],
    );
  }
}
