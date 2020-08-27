import 'package:flutter/cupertino.dart';
import 'package:rpg_dice_roller/models/namedRoll.dart';
import 'database.dart';
import 'package:sqflite_common/sqlite_api.dart';

Future<int> saveNameRoll(int room, String name, String roll) {
  return openRPGDiceDatabase().then((db) => _insertNamedRoll(db, room, name, roll));
}

Future<int> _getMaxRollId(Database db, int room) {
  return db.rawQuery("SELECT MAX(id) AS id FROM named_rolls WHERE room_id = ?", [room]).then((result) {
    return result.length == 0 || result[0]['id'] == null ? 0 : result[0]['id'];
  });
}

Future<int> _insertNamedRoll(Database db, int room, String name, String roll) async {
  final int id = await _getMaxRollId(db, room) + 1;

  debugPrint(id.toString());

  final Map<String, dynamic> roomMap = new Map();
  roomMap['id'] = id;
  roomMap['room_id'] = room;
  roomMap['name'] = name;
  roomMap['roll'] = roll;
  return db.insert('named_rolls', roomMap);
}

Future<int> deleteNameRoll(int id, int room) {
  return openRPGDiceDatabase().then((db) {
    return db.delete('named_rolls', where: "id = ? and room_id = ?", whereArgs: [id, room]);
  });
}

Future<List<NamedRoll>> findAll(int room) {
  return openRPGDiceDatabase().then((db) {
    return db.query('named_rolls', where: "room_id = ?", whereArgs: [room]).then((results) {
      final List<NamedRoll> namedRolls = new List();
      for (Map<String, dynamic> result in results) {
        namedRolls.add(new NamedRoll.fromMap(result));
      }
      return namedRolls;
    });
  });
}
