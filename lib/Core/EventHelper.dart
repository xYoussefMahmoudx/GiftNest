import 'package:sqflite/sqflite.dart';
import '../model/User.dart';
import 'DataBaseClass.dart';
import 'package:giftnest/model/Event.dart';

class EventHelper {
  final DataBaseClass dbClass = DataBaseClass();

  Future<int> insertEvent(Event event) async {
    Database? db = await dbClass.database;

    // Update the last_edited timestamp
    event.lastEdited = DateTime.now().toIso8601String();

    return await db!.insert('Event', event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Event>> getAllEvents() async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query('Event');
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(Event event) async {
    Database? db = await dbClass.database;

    // Update the last_edited timestamp
    event.lastEdited = DateTime.now().toIso8601String();

    return await db!.update('Event', event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteEvent(int? id) async {
    Database? db = await dbClass.database;
    return await db!.delete('Event', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getUpcomingEventsCountByUserId(int? userId) async {
    Database? db = await dbClass.database;
    final now = DateTime.now().toIso8601String();
    List<Map<String, dynamic>> result = await db!.query(
      'Event',
      columns: ['id'],
      where: 'user_id = ? AND date > ?',
      whereArgs: [userId, now],
    );

    return result.length;
  }

  Future<List<Event>> getEventsByUserId(int? userId) async {
    Database? db = await dbClass.database;
    List<Map<String, dynamic>> result = await db!.query(
      'Event',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((map) => Event.fromMap(map)).toList();
  }
}
