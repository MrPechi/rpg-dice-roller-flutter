import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rpg_dice_roller/database/namedRolls.dart';
import 'package:rpg_dice_roller/screens/rooms_screen.dart';

void main() {
  runApp(DiceRoller());
//  findAll().then((value) => debugPrint(value.toString()));

    NamedRolls.findAll(1).then((value) {
      debugPrint(value.toString());
    });
}

class DiceRoller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: RoomsScreen(),
      theme: ThemeData.dark(),
      title: "RPG Dice Roller",
    );
  }
}
