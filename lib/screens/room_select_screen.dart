//import 'dart:math';
//
//import 'package:english_words/english_words.dart';
//import 'package:flutter/material.dart';
//import 'package:rpg_dice_roller/components/buttons.dart';
//import 'package:rpg_dice_roller/components/inputs.dart';
//import 'package:rpg_dice_roller/models/room.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class TableSelectScreen extends StatelessWidget {
//  final TextEditingController _nameController = TextEditingController();
//  final TextEditingController _roomController = TextEditingController();
//  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//  @override
//  Widget build(BuildContext context) {
//    _prefs.then((_pref) {
//      _nameController.text = _pref.getString("last-name");
//      _roomController.text = _pref.getString("last-room");
//    });
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Conecte-se"),
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(16.0),
//              child: InputTextField("Nome", _nameController),
//            ),
//            Padding(
//                padding: const EdgeInsets.all(16.0),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(child: InputTextField("Sala", _roomController)),
//                    RoundButton(Icons.loop, _randomRoom)
//                  ],
//                )),
//            Builder(
//              builder: (context) => RaisedButton(
//                child: Text("Entrar"),
//                onPressed: () => _joinRoom(context),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  Future<void> _joinRoom(BuildContext context) async {
//    String name = _nameController.text;
//    String room = _roomController.text;
//
//    //TODO: Colocar uma validação melhor que o SnackBar
//    if (name == null || name.length == 0) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text('Preencha o nome'),
//        duration: Duration(seconds: 1),
//        backgroundColor: Color.fromRGBO(255, 0, 0, 100),
//      ));
//      return;
//    }
//
//    if (room == null || room.length == 0) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//        content: Text('Preencha a sala'),
//        duration: Duration(seconds: 1),
//        backgroundColor: Color.fromRGBO(255, 0, 0, 100),
//      ));
//      return;
//    }
//
//    Room selectedRoom = new Room(room, name);
//
//    final prefs = await SharedPreferences.getInstance();
//    prefs.setString('last-room', room);
//    prefs.setString('last-name', name);
//
//    Navigator.pop(context, selectedRoom);
//  }
//
//  void _randomRoom() {
//    _roomController.text = WordPair.random().first + Random().nextInt(99).toString();
//    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
//  }
//}
