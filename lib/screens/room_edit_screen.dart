import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:rpg_dice_roller/components/buttons.dart';
import 'package:rpg_dice_roller/components/inputs.dart';
import 'package:rpg_dice_roller/database/rooms.dart';
import 'package:rpg_dice_roller/models/room.dart';

class RoomEditScreen extends StatefulWidget {
  final Room _roomStateful;

  RoomEditScreen(this._roomStateful);

  @override
  State<StatefulWidget> createState() {
    return RoomEditScreenState(_roomStateful);
  }
}

class RoomEditScreenState extends State<RoomEditScreen> {
  Room _room;
  TextEditingController _playerController;
  TextEditingController _roomController;

  RoomEditScreenState(this._room) {
    if (_room == null) {
      this._room = new Room.empty();
    }
    _playerController = new TextEditingController(text: _room.playerName);
    _roomController = new TextEditingController(text: _room.roomName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_room.id == null ? "Nova Sala" : _room.roomName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              InputTextField(
                "Jogador",
                _playerController,
              ),
              Row(
                children: <Widget>[
                  Expanded(child: InputTextField("Sala", _roomController)),
                  RoundButton(Icons.loop, _randomRoom)
                ],
              ),
              InkWell(
                onTap: () => _onSecretRollChange(),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text("Rolagem Secreta", style: TextStyle(color: Colors.grey[500], fontSize: 24))),
                    Switch(value: _room.secretRolls, onChanged: (bool newValue) => _onSecretRollChange()),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("Histórico", style: TextStyle(color: Colors.grey[500], fontSize: 24))),
                  Slider(
                      value: _room.messageHistoryLength.toDouble(),
                      min: 5,
                      max: 50,
                      divisions: 9,
                      label: _room.messageHistoryLength.round().toString(),
                      onChanged: (double value) => _onMaxHistoryChange(value)),
                ],
              ),
              Builder(
                builder: (context) => RaisedButton(
                  child: Text("Salvar"),
                  onPressed: () => _saveOrUpdate(context),
                ),
              ),
              Builder(
                builder: (context) => _buildDeleteButton(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    if (_room.id == null) {
      return Container();
    } else {
      return RaisedButton(
        child: Text("Excluir"),
        color: Colors.red[900],
        onPressed: () => _showAlertSnackBarMessage(context, "Segure o botão de deletar!"),
        onLongPress: () => deleteRoom(_room).then((value) => Navigator.pop(context, value)),
      );
    }
  }

  void _randomRoom() {
    _roomController.text = WordPair.random().first + Random().nextInt(99).toString();
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  void _onMaxHistoryChange(double value) {
    setState(() => _room.messageHistoryLength = value.toInt());
  }

  void _onSecretRollChange() {
    setState(() => _room.secretRolls = !_room.secretRolls);
  }

  Future<void> _saveOrUpdate(BuildContext context) async {
    String name = _playerController.text;
    String room = _roomController.text;

    //TODO: Colocar uma validação melhor que o SnackBar
    if (name == null || name.length == 0) {
      _showAlertSnackBarMessage(context, 'Preencha a nome');
      return;
    }

    if (room == null || room.length == 0) {
      _showAlertSnackBarMessage(context, 'Preencha a sala');
      return;
    }

    _room.playerName = _playerController.text;
    _room.roomName = _roomController.text;

    saveOrUpdateRoom(_room).then((value) => Navigator.pop(context, value));
  }

  ScaffoldFeatureController _showAlertSnackBarMessage(BuildContext context, String message) {
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
      backgroundColor: Color.fromRGBO(255, 0, 0, 100),
    ));
  }
}
