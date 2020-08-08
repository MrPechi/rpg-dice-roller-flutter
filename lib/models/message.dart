class Roll {
  final String player;
  final String detail;
  final int result;

  Roll(this.player, this.detail, this.result);

  Roll.fromJson(Map<String, dynamic> json)
      : player = json['name'],
        detail = json['rollDetail'],
        result = json['result'];

  Map<String, dynamic> toJson() => {
        'name': player,
        'rollDetail': detail,
        'result': result,
      };

  @override
  String toString() {
    return 'Roll{player: $player, detail: $detail, result: $result}';
  }
}
