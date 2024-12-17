import 'package:sqflite/sqflite.dart';
import '../model/User.dart';
import 'DataBaseClass.dart';
import 'package:giftnest/model/Friendship.dart';

import 'UserHelper.dart';

class FriendshipHelper {
  final DataBaseClass dbClass = DataBaseClass();

  Future<int> insertFriendship(Friendship friendship) async {
    Database? db = await dbClass.database;

    // Ensure smaller ID is in user_id
    int userId = friendship.userId < friendship.friendId ? friendship.userId : friendship.friendId;
    int friendId = friendship.userId < friendship.friendId ? friendship.friendId : friendship.userId;

    return await db!.insert(
      'friendship',
      {'user_id': userId, 'friend_id': friendId, 'status': friendship.status},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Friendship>> getAllFriendships() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('friendship');
    return result.map((map) => Friendship.fromMap(map)).toList();
  }

  Future<int> updateFriendship(Friendship friendship) async {
    Database? db = await dbClass.database;

    // Ensure smaller ID is in user_id
    int userId = friendship.userId < friendship.friendId ? friendship.userId : friendship.friendId;
    int friendId = friendship.userId < friendship.friendId ? friendship.friendId : friendship.userId;

    return await db!.update(
      'friendship',
      {'user_id': userId, 'friend_id': friendId, 'status': friendship.status},
      where: 'user_id = ? AND friend_id = ?',
      whereArgs: [userId, friendId],
    );
  }

  Future<int> deleteFriendship(int id1, int id2) async {
    Database? db = await dbClass.database;

    // Ensure smaller ID is in user_id
    int userId = id1 < id2 ? id1 : id2;
    int friendId = id1 < id2 ? id2 : id1;

    return await db!.delete('friendship', where: 'user_id = ? AND friend_id = ?', whereArgs: [userId, friendId]);
  }
  Future<List<User>> getUserFriends(int userId) async {
    Database? db = await dbClass.database;

    // Query for friendships where the given user_id is either the user or the friend
    List<Map<String, dynamic>> result = await db!.query(
      'friendship',
      where: 'user_id = ? OR friend_id = ?',
      whereArgs: [userId, userId],
    );

    // Extract the friend_id for each friendship entry (ignoring the user_id)
    List friendIds = result.map((map) {
      if (map['user_id'] == userId) {
        return map['friend_id'];
      } else {
        return map['user_id'];
      }
    }).toList();

    // Fetch user details for each friend_id
    List<User> friends = [];
    for (int friendId in friendIds) {
      // Assuming you have a UserHelper class to get user details
      User? friend = await UserHelper().getUserById(friendId);
      if (friend != null) {
        friends.add(friend);
      }
    }

    return friends;
  }

}
