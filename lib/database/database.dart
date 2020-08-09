import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openRPGDiceDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'rpg_dice_roller.db');

    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE rooms('
          'id INTEGER PRIMARY KEY, '
          'room_name TEXT, '
          'player_name TEXT, '
          'secret_rolls BOOLEAN, '
          'message_history_length INTEGER)');
    }, version: 1);
  });
}
