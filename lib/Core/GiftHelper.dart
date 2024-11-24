import 'package:sqflite/sqflite.dart';
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

  Future<int> updateGift(Gift gift) async {
    Database? db = await dbClass.database;
    return await db!.update('Gift', gift.toMap(), where: 'id = ?', whereArgs: [gift.id]);
  }

  Future<int> deleteGift(int id) async {
    Database? db = await dbClass.database;
    return await db!.delete('Gift', where: 'id = ?', whereArgs: [id]);
  }
}
