import 'package:giftnest/Core/EventHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Event.dart';
import 'DataBaseClass.dart';
import 'package:giftnest/model/Gift.dart';

class GiftHelper {
  final DataBaseClass dbClass = DataBaseClass();

  Future<int> insertGift(Gift gift) async {
    Database? db = await dbClass.database;
    return await db!.insert('Gift', gift.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Gift>> getAllGifts() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('Gift');
    return result.map((map) => Gift.fromMap(map)).toList();
  }
  Future<List<Gift>> getAllUserGiftsById(int userId, List<Event> events) async {
    Database? db = await dbClass.database;

    // Get the event IDs associated with the user
    List<int> eventIds = events.map((e) => e.id!).toList(); // Assuming Event has an 'id' field

    // Query the gifts that belong to those events
    List<Map<String, dynamic>> result = await db!.query(
      'Gift',
      where: 'event_id IN (${eventIds.join(",")})', // Use the event IDs to filter gifts
    );

    // Map the results to a list of Gift objects
    List<Gift> gifts = result.map((e) => Gift.fromMap(e)).toList();

    return gifts; // Return the list of gifts
  }


  Future<int> updateGift(Gift gift) async {
    Database? db = await dbClass.database;
    return await db!.update('Gift', gift.toMap(), where: 'id = ?', whereArgs: [gift.id]);
  }

  Future<int> deleteGift(int? id) async {
    Database? db = await dbClass.database;
    return await db!.delete('Gift', where: 'id = ?', whereArgs: [id]);
  }
}
