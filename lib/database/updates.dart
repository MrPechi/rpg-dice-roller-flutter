import 'package:rpg_dice_roller/models/room.dart';
import 'database.dart';

Future<int> saveRoom(Room room) {
  return openRPGDiceDatabase().then((db) {
    final Map<String, dynamic> roomMap = new Map();
    roomMap['room_name'] = room.roomName;
    roomMap['player_name'] = room.playerName;
    roomMap['secret_rolls'] = room.secretRolls ? 1 : 0;
    roomMap['message_history_length'] = room.messageHistoryLength;
    return db.insert('rooms', roomMap);
  });
}

Future<int> updateRoom(Room room) {
  return openRPGDiceDatabase().then((db) {
    final Map<String, dynamic> roomMap = new Map();
    roomMap['room_name'] = room.roomName;
    roomMap['player_name'] = room.playerName;
    roomMap['secret_rolls'] = room.secretRolls ? 1 : 0;
    roomMap['message_history_length'] = room.messageHistoryLength;
    return db.update('rooms', roomMap, where: "id = ?", whereArgs: [room.id]);
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
