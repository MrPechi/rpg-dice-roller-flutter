class Message {
  final String text;

  Message(this.text);

  Message.fromJson(Map<String, dynamic> json) : text = json['text'];

  Map<String, dynamic> toJson() => {'text': text};
}
