import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:giftnest/controller/UserHelper.dart';
import 'package:giftnest/controller/EventHelper.dart';
import 'package:giftnest/controller/FriendshipHelper.dart';
import 'package:giftnest/controller/GiftHelper.dart';
import 'package:giftnest/model/User.dart';
import 'package:giftnest/model/Event.dart';
import 'package:giftnest/model/Friendship.dart';
import 'package:giftnest/model/Gift.dart';
Future<Uint8List> getImageBytes(String assetPath) async {
  final ByteData bytes = await rootBundle.load(assetPath);
  return bytes.buffer.asUint8List();
}
Future<void> populateDatabase() async {

  Uint8List imageBytes = await getImageBytes('assets/alice.jpg');
  final UserHelper userHelper = UserHelper();
  final EventHelper eventHelper = EventHelper();
  final FriendshipHelper friendshipHelper = FriendshipHelper();
  final GiftHelper giftHelper = GiftHelper();

  // Insert Users
  User alice = User(
    firstName: 'Alice',
    lastName: 'Smith',
    email: 'alice@example.com',
    profileImage: imageBytes,
    phoneNumber: '1234567890',
  );
  alice.id = await userHelper.insertUser(alice);

  User bob = User(
    firstName: 'Bob',
    lastName: 'Johnson',
    email: 'bob@example.com',
    profileImage: imageBytes,
    phoneNumber: '0987654321',
  );
  bob.id = await userHelper.insertUser(bob);
  User youssef = User(
    firstName: 'youssef',
    lastName: 'Johnson',
    email: 'youssef@example.com',
    profileImage: imageBytes,
    phoneNumber: '0944876581',
  );
  youssef.id = await userHelper.insertUser(youssef);
  // Insert Events
  Event birthdayParty = Event(
    userId: alice.id!,
    title: 'Birthday Party',
    date: '2024-12-25',
    location: 'Alice’s House',
    description: 'A fun birthday party with friends and family',
    category: 'ceremonial',
  );
  birthdayParty.id = await eventHelper.insertEvent(birthdayParty);

  Event officeCelebration = Event(
    userId: bob.id!,
    title: 'Office Celebration',
    date: '2024-12-31',
    location: 'Downtown Office',
    description: 'New Year’s Eve office party',
    category: 'ceremonial',
  );
  officeCelebration.id = await eventHelper.insertEvent(officeCelebration);
  Event newyearCelebration = Event(
    userId: youssef.id!,
    title: 'party',
    date: '2025-1-1',
    location: 'Downtown Office',
    description: 'New Year’s Eve office party',
    category: 'ceremonial',
  );
  newyearCelebration.id = await eventHelper.insertEvent(newyearCelebration);
  // Insert Gifts
  Gift giftCard = Gift(
    eventId: officeCelebration.id!,
    title: 'Gift Card',
    description: 'Amazon gift card',
    price: 50.0,
    status: 'Available',
    category: 'money',
    image: imageBytes,
  );
  await giftHelper.insertGift(giftCard);

  Gift boardGame = Gift(
    eventId: birthdayParty.id!,
    title: 'Board Game',
    description: 'A fun board game for the party',
    price: 30.0,
    status: 'Purchased',
    category: 'game',
    image: imageBytes,
  );
  await giftHelper.insertGift(boardGame);
  Gift videoGame = Gift(
    eventId: newyearCelebration.id!,
    title: 'video Game',
    description: 'A fun board game for the party',
    price: 30.0,
    status: 'Available',
    category: 'game',
    image: imageBytes,
  );
  await giftHelper.insertGift(videoGame);

  // Insert Friendships
  Friendship aliceBob = Friendship(userId: alice.id!, friendId: bob.id!, status: 'accepted');
  await friendshipHelper.insertFriendship(aliceBob);

  print('Database populated successfully!');
}


