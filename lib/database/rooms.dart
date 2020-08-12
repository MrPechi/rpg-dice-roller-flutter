import 'package:rpg_dice_roller/models/room.dart';
import 'database.dart';
import 'package:sqflite_common/sqlite_api.dart';

Future<int> saveRoom(Room room) {
  return openRPGDiceDatabase().then((db) => insertRoom(db, room));
}

Future<int> insertRoom(Database db, Room room) {
  final Map<String, dynamic> roomMap = new Map();
  roomMap['room_name'] = room.roomName;
  roomMap['player_name'] = room.playerName;
  roomMap['secret_rolls'] = room.secretRolls ? 1 : 0;
  roomMap['message_history_length'] = room.messageHistoryLength;
  roomMap['selected'] = room.selected != null && room.selected ? 1 : 0;
  return db.insert('rooms', roomMap);
}

Future<int> updateRoom(Room room) {
  return openRPGDiceDatabase().then((db) {
    final Map<String, dynamic> roomMap = new Map();
    roomMap['room_name'] = room.roomName;
    roomMap['player_name'] = room.playerName;
    roomMap['secret_rolls'] = room.secretRolls ? 1 : 0;
    roomMap['message_history_length'] = room.messageHistoryLength;
    roomMap['selected'] = room.selected != null && room.selected ? 1 : 0;
    return db.update('rooms', roomMap, where: "id = ?", whereArgs: [room.id]);
  });
}

Future<int> selectRoom(Room room) {
  return openRPGDiceDatabase().then((db) {
    return db.rawUpdate("UPDATE rooms SET selected = 0").then((value) {
      return db.rawUpdate("UPDATE rooms SET selected = 1 WHERE id = ?", [room.id]);
    });
  });
}

Future<int> deleteRoom(Room room) {
  return openRPGDiceDatabase().then((db) {
    return db.delete('rooms', where: "id = ?", whereArgs: [room.id]);
  });
}

Future<int> saveOrUpdateRoom(Room room) {
  if (room.id == null) {
    return saveRoom(room);
  } else {
    return updateRoom(room);
  }
}

Future<List<Room>> findAll() {
  return openRPGDiceDatabase().then((db) {
    return db.query('rooms').then((results) {
      final List<Room> rooms = new List();
      for (Map<String, dynamic> result in results) {
        rooms.add(new Room.fromMap(result));
      }
      return rooms;
    });
  });
}

Future<Room> getRoomById(int id) {
  return openRPGDiceDatabase().then((db) {
    return db.query('rooms', where: "id = ?", whereArgs: [id]).then((result) {
      return result.length > 0 ? Room.fromMap(result[0]) : null;
    });
  });
}

Future<Room> getSelectedRoom() {
  return openRPGDiceDatabase().then((db) {
    return db.query('rooms', where: "selected = 1").then((result) {
      return result.length > 0 ? Room.fromMap(result[0]) : getRoomById(0);
    });
  });
}
