import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpg_dice_roller/screens/roll_screen.dart';

void main() => runApp(DiceRoller());

class DiceRoller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: RollScreen(),
      theme: ThemeData.dark(),
    );
  }
}
