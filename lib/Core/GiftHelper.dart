import 'package:giftnest/Core/EventHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Event.dart';
import 'DataBaseClass.dart';
import 'package:giftnest/model/Gift.dart';

class GiftHelper {
  final DataBaseClass dbClass = DataBaseClass();

  Future<int> insertGift(Gift gift) async {
    Database? db = await dbClass.database;

    // Update the last_edited timestamp
    gift.lastEdited = DateTime.now().toIso8601String();

    return await db!.insert('Gift', gift.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Gift>> getAllGifts() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('Gift');
    return result.map((map) => Gift.fromMap(map)).toList();
  }

  Future<List<Gift>> getAllUserGiftsById(int userId, List<Event> events) async {
    Database? db = await dbClass.database;

    List<int> eventIds = events.map((e) => e.id!).toList();

    List<Map<String, dynamic>> result = await db!.query(
      'Gift',
      where: 'event_id IN (${eventIds.join(",")})',
    );

    return result.map((map) => Gift.fromMap(map)).toList();
  }
  Future<List<Gift>> getAllGiftsByGiftId(int giftId) async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('Gift',where: "id=?",whereArgs: [giftId]);
    return result.map((map) => Gift.fromMap(map)).toList();
  }
  Future<Gift?> getGiftById(int giftId) async {
    Database? db = await dbClass.database;

    // Query for the gift
    List<Map<String, dynamic>> result = await db!.query(
      'Gift',
      where: "id = ?",
      whereArgs: [giftId],
      limit: 1, // Ensure only one row is returned
    );

    // Return the first gift or null if no result found
    if (result.isNotEmpty) {
      return Gift.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateGift(Gift gift) async {
    Database? db = await dbClass.database;

    // Update the last_edited timestamp
    gift.lastEdited = DateTime.now().toIso8601String();

    return await db!.update('Gift', gift.toMap(), where: 'id = ?', whereArgs: [gift.id]);
  }

  Future<int> deleteGift(int? id) async {
    Database? db = await dbClass.database;
    return await db!.delete('Gift', where: 'id = ?', whereArgs: [id]);
  }
}
