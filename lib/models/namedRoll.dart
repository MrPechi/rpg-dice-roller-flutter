class NamedRoll {
  final int id;
  final int roomId;
  final String name;
  final String roll;

  NamedRoll.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        roomId = json['room_id'],
        name = json['name'],
        roll = json['roll'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'name': name,
        'roll': roll,
      };

  @override
  String toString() {
    return 'NamedRoll{id: $id, room_id: $roomId, name: $name, roll: $roll}';
  }
}