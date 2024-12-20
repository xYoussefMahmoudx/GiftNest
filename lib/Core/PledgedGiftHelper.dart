import 'package:sqflite/sqflite.dart';
import '../model/PledgedGift.dart';
import 'DataBaseClass.dart';
class PledgedGiftHelper {
  final DataBaseClass dbClass = DataBaseClass();

  // Insert a pledged gift into the database
  Future<int> insertPledgedGift(PledgedGift pledgedGift) async {
    Database? db = await dbClass.database;
    return await db!.insert(
      'PledgedGift',
      pledgedGift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all pledged gifts from the database
  Future<List<PledgedGift>> getAllPledgedGifts() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('PledgedGift');
    return result.map((map) => PledgedGift.fromMap(map)).toList();
  }

  // Retrieve pledged gifts by userId
  Future<List<PledgedGift>> getPledgedGiftsByUser(int userId) async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query(
      'PledgedGift',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((map) => PledgedGift.fromMap(map)).toList();
  }

  // Retrieve pledged gifts by giftId
  Future<List<PledgedGift>> getPledgedGiftsByGift(int giftId) async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query(
      'PledgedGift',
      where: 'gift_id = ?',
      whereArgs: [giftId],
    );
    return result.map((map) => PledgedGift.fromMap(map)).toList();
  }

  // Delete a pledged gift by userId and giftId
  Future<int> deletePledgedGift(int userId, int giftId) async {
    Database? db = await dbClass.database;
    return await db!.delete(
      'PledgedGift',
      where: 'user_id = ? AND gift_id = ?',
      whereArgs: [userId, giftId],
    );
  }

  // Delete all pledged gifts
  Future<int> deleteAllPledgedGifts() async {
    Database? db = await dbClass.database;
    return await db!.delete('PledgedGift');
  }
}
