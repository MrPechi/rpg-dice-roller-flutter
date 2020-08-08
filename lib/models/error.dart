import 'package:rpg_dice_roller/models/message.dart';

class Error implements Message {
  final String text;
  final String roll;
  final String cause;

  Error(this.text, this.roll, this.cause);

  Error.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        roll = json['roll'],
        cause = json['cause'];

  Map<String, dynamic> toJson() => {'text': text, 'cause': cause};
}
