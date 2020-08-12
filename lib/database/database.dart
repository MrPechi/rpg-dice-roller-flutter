import 'package:path/path.dart';
import 'package:rpg_dice_roller/database/rooms.dart';
import 'package:rpg_dice_roller/models/room.dart';
import 'package:sqflite/sqflite.dart';

const DB_VERSION = 1;

Future<Database> openRPGDiceDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'rpg_dice_roller.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await _createDatabaseV1(db);
      },
      version: DB_VERSION,
    );
  });
}

Future<void> _createDatabaseV1(Database db) async {
  await db.execute('CREATE TABLE rooms('
      'id INTEGER PRIMARY KEY, '
      'room_name TEXT, '
      'player_name TEXT, '
      'secret_rolls BOOLEAN, '
      'message_history_length INTEGER, '
      'selected BOOLEAN)');

  await insertRoom(db, Room.solo());
}