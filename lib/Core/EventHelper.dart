import 'package:sqflite/sqflite.dart';
import 'DataBaseClass.dart';
import 'package:giftnest/model/Event.dart';

class EventHelper {
  final DataBaseClass dbClass = DataBaseClass();

  Future<int> insertEvent(Event event) async {
    Database? db = await dbClass.database;
    return await db!.insert('Event', event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Event>> getAllEvents() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('Event');
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(Event event) async {
    Database? db = await dbClass.database;
    return await db!.update('Event', event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteEvent(int id) async {
    Database? db = await dbClass.database;
    return await db!.delete('Event', where: 'id = ?', whereArgs: [id]);
  }
}
