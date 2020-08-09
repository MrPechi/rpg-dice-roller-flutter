import 'package:rpg_dice_roller/models/room.dart';
import 'database.dart';

Future<List<Room>> findAll() {
  return openRPGDiceDatabase().then((db) {
    return db.query('rooms').then((results) {
      final List<Room> rooms = new List();
      for (Map<String, dynamic> result in results) {
        Room room = new Room(
          result['id'],
          result['room_name'],
          result['player_name'],
          result['secret_rolls'] == 1,
          result['message_history_length'],
        );
        rooms.add(room);
      }
      return rooms;
    });
  });
}
