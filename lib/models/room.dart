class Room {

  static const int SOLO_ID = 99999999999999;

  int id;
  String roomName;
  String playerName;
  bool secretRolls;
  int messageHistoryLength;

  Room(this.id, this.roomName, this.playerName, this.secretRolls, this.messageHistoryLength);

  Room.solo() {
    id = Room.SOLO_ID;
    roomName = "Solo";
    playerName = "Solo Player";
    secretRolls = false;
    messageHistoryLength = 20;
  }

  @override
  String toString() {
    return 'Room{id: $id, roomName: $roomName, playerName: $playerName, secretRolls: $secretRolls, messageHistoryLength: $messageHistoryLength}';
  }
}
