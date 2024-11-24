import 'package:sqflite/sqflite.dart';
import 'DataBaseClass.dart';
import 'package:giftnest/model/User.dart';

class UserHelper {
  final DataBaseClass dbClass = DataBaseClass();

  Future<int> insertUser(User user) async {
    Database? db = await dbClass.database;
    return await db!.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<User>> getAllUsers() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('user');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    Database? db = await dbClass.database;
    return await db!.update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database? db = await dbClass.database;
    return await db!.delete('user', where: 'id = ?', whereArgs: [id]);
  }
}
