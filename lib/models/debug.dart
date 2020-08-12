import 'package:rpg_dice_roller/models/message.dart';

class Debug implements Message {
  final String event;
  final String text;

  Debug(this.event, this.text);

  Debug.fromJson(this.event, dynamic data)
      : text = data != null ? data.toString() : '';

  Map<String, dynamic> toJson() => {'event': event, 'text': text};

  @override
  String toString() {
    return 'Debug{$event => $text}';
  }
}
