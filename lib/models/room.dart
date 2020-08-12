class Room {
  static const int SOLO_ID = 1;

  int id;
  String roomName;
  String playerName;
  bool secretRolls;
  int messageHistoryLength;
  bool selected;

  Room(this.id, this.roomName, this.playerName, this.secretRolls, this.messageHistoryLength, this.selected);

  Room.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        roomName = map['room_name'],
        playerName = map['player_name'],
        secretRolls = map['secret_rolls'] == 1,
        messageHistoryLength = map['message_history_length'],
        selected = map['selected'] == 1;

  Room.solo() {
    id = Room.SOLO_ID;
    roomName = "Solo";
    playerName = "Solo Player";
    secretRolls = false;
    messageHistoryLength = 20;
    selected = true;
  }

  Room.empty() {
    id = null;
    roomName = "";
    playerName = "";
    secretRolls = false;
    messageHistoryLength = 20;
    selected = false;
  }

  @override
  String toString() {
    return 'Room{id: $id, roomName: $roomName, playerName: $playerName, secretRolls: $secretRolls, messageHistoryLength: $messageHistoryLength, selected: $selected}';
  }
}
