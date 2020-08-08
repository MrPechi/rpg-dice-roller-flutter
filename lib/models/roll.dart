import 'package:rpg_dice_roller/models/message.dart';

class Roll implements Message {
  final String player;
  final String text;
  final int result;

  Roll(this.player, this.text, this.result);

  Roll.fromJson(Map<String, dynamic> json)
      : player = json['name'],
        text = json['rollDetail'],
        result = json['result'];

  Map<String, dynamic> toJson() => {
        'name': player,
        'rollDetail': text,
        'result': result,
      };
}
