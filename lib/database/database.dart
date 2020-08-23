import 'package:path/path.dart';
import 'package:rpg_dice_roller/database/rooms.dart';
import 'package:rpg_dice_roller/models/room.dart';
import 'package:sqflite/sqflite.dart';

const DB_VERSION = 3;

Future<Database> openRPGDiceDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'rpg_dice_roller.db');

    return openDatabase(
      path,
      onCreate: (db, version) async {
        await _createDatabaseV1(db);
        await _upgradeDatabaseV2(db);
        await _upgradeDatabaseV3(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion <= 1) await _upgradeDatabaseV2(db);
        if (oldVersion <= 2) await _upgradeDatabaseV3(db);
      },
      version: DB_VERSION,
    );
  });
}

Future<void> _createDatabaseV1(Database db) async {
  await db.execute(''
      'CREATE TABLE rooms('
      '  id INTEGER PRIMARY KEY, '
      '  room_name TEXT, '
      '  player_name TEXT, '
      '  secret_rolls BOOLEAN, '
      '  message_history_length INTEGER, '
      '  selected BOOLEAN)');

  await insertRoom(db, Room.solo());
}

Future<void> _upgradeDatabaseV2(Database db) async {
  await db.execute('ALTER TABLE rooms '
      'ADD COLUMN wakelock BOOLEAN DEFAULT 0');
}

Future<void> _upgradeDatabaseV3(Database db) async {
  await db.execute(''
      'CREATE TABLE named_rolls( '
      '  id INTEGER, '
      '  room_id INTEGER, '
      '  name TEXT, '
      '  roll TEXT, '
      'PRIMARY KEY(id, room_id) '
      'FOREIGN KEY (room_id) REFERENCES rooms (id) '
      '  ON DELETE CASCADE '
      '  ON UPDATE NO ACTION )');
}
