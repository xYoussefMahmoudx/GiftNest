import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DataBaseClass {
  static Database? _database; // Singleton Database

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String mypath = await getDatabasesPath();
    String path = join(mypath, 'giftNest.db');
    Database mydb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create user table with profile_image as a blob
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            profile_image BLOB,
            phone_number TEXT
          )
        ''');

        // Create Event table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Event (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            date TEXT NOT NULL,
            location TEXT NOT NULL,
            description TEXT,
            FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
          )
        ''');

        // Create Gift table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Gift (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            event_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            status TEXT NOT NULL,
            FOREIGN KEY (event_id) REFERENCES Event (id) ON DELETE CASCADE
          )
        ''');

        // Create friendship table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS friendship (
            user_id INTEGER NOT NULL,
            friend_id INTEGER NOT NULL,
            status TEXT NOT NULL,
            PRIMARY KEY (user_id, friend_id),
            FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE,
            FOREIGN KEY (friend_id) REFERENCES user (id) ON DELETE CASCADE
          )
        ''');
      },
    );
    return mydb;
  }


}
