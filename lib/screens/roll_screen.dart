import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rpg_dice_roller/models/error.dart';
import 'package:rpg_dice_roller/models/message.dart';
import 'package:rpg_dice_roller/models/roll.dart';
import 'package:rpg_dice_roller/screens/room_select_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ButtonType { DIE, NUMBER, FUNCTION, OPERATOR }

//  SOCKET_EVENTS = [
//    'connect',
//    'connect_error',
//    'connect_timeout',
//    'connecting',
//    'disconnect',
//    'error',
//    'reconnect',
//    'reconnect_attempt',
//    'reconnect_failed',
//    'reconnect_error',
//    'reconnecting',
//    'ping',
//    'pong'
//  ];

//  DICE_ROLLER_INCOMING_EVENTS = [
//     player-connect,
//     player-disconnect
//     roll-history
//     server-error
//     roll-result
//  ];

//  DICE_ROLLER_OUTGOING_EVENTS = [
//     roll
//  ];

class RollScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RollScreenState();
  }
}

class RollScreenState extends State<RollScreen> {
  static const String _SOCKET_ADDRESS = "wss://www.pechibits.com:443";
  static const String _SOCKET_PATH = "/dice-roller-socket";
  IO.Socket _socket;
  bool _socketConnected = false;

  final List<Message> _messageHistory = new List();
  final ScrollController _scrollController = new ScrollController();
  final Future<SharedPreferences> _configPrefs = SharedPreferences.getInstance();
  final Display _display = new Display();

  String _player;
  String _room;

  @override
  void initState() {
    super.initState();
    _configurePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildRollHistory()),
          _buildDisplay(),
          ..._buildKeyboard(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_room != null ? _room : 'Solo'),
      actions: <Widget>[
        _buildIconConnectionStatus(),
        _selectRoomIconButton(context),
      ],
    );
  }

  Icon _buildIconConnectionStatus() {
    if (_socketConnected) {
      return Icon(
        Icons.cloud,
        color: Colors.green,
      );
    } else {
      return Icon(
        Icons.cloud_off,
        color: Colors.red,
      );
    }
  }

  /// Componete de lista de mensagens
  ///
  /// Apresenta cada uma das mensagens que chegarem ao "_rollHistory" e
  /// desliza suavemente para baixo.
  Widget _buildRollHistory() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: _messageHistory.length,
      itemBuilder: (context, index) {
        return ItemMessage(_messageHistory[index], index);
      },
    );
  }

  /// Componente onde são apresentados os valores selecionados, lembra o display de uma calculadora
  Widget _buildDisplay() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text(
              _display.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            color: Colors.blue[100],
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }

  /// Teclado, com todos os números e dados disponíveis
  List<Widget> _buildKeyboard() {
    List<List<dynamic>> grid = [
      ["d4", "d6", "d8", "del"],
      ["d10", "d12", "d20", "d100"],
      ["7", "8", "9", "+"],
      ["4", "5", "6", "-"],
      ["1", "2", "3", null],
      [null, "0", null, "Roll"]
    ];

    List<Widget> buttons = new List();
    for (List<dynamic> row in grid) {
      List<Widget> line = new List();
      for (dynamic item in row) {
        line.add(_buildButton(item));
      }
      buttons.add(Row(children: <Widget>[...line]));
    }
    return buttons;
  }

  IconButton _selectRoomIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.group_add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return TableSelectScreen();
          }),
        ).then((value) {
          if (value != null) {
            setState(() {
              _room = value.roomName;
              _player = value.playerName;
              _messageHistory.clear();
            });
            _changeSocketRoom();
          }
        });
      },
    );
  }

  Widget _buildButton(String text) {
    Color color;
    ButtonType type;

    if (text == null) {
      return Expanded(child: Container());
    }

    if (RegExp(r'^\d{1}$').hasMatch(text)) {
      color = Colors.blue[300];
      type = ButtonType.NUMBER;
    } else if (RegExp(r'^d{1}\d{1,3}$').hasMatch(text)) {
      color = Colors.blue[500];
      type = ButtonType.DIE;
    } else if (RegExp(r'^[\\,\*,\-,\+]$').hasMatch(text)) {
      color = Colors.blue[700];
      type = ButtonType.OPERATOR;
    } else {
      color = Colors.blue[900];
      type = ButtonType.FUNCTION;
    }

    return Expanded(
      child: RaisedButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
        padding: EdgeInsets.all(4),
        color: color,
        onPressed: () => _setDisplayValue(new RollButton(text, type)),
        disabledColor: Colors.grey,
      ),
    );
  }

  _setDisplayValue(RollButton button) {
    if (button.type != ButtonType.FUNCTION) {
      setState(() => _display.add(button));
    } else if (button.value == 'del') {
      setState(() => _display.clear());
    } else if (button.value == "Roll") {
      if (_display.isFilled()) {
        _socket.emit("roll", {'roll': _display.toString()});
        setState(() => _display.clear());
      }
    }
  }

  void _configurePreferences() {
    if (_player != null && _room != null) {
      _configSocket();
    } else {
      _configPrefs.then((_pref) {
        setState(() {
          _player = _pref.getString("last-name") != null ? _pref.getString("last-name") : "Player";
          _room = _pref.getString("last-room");

          _configSocket();
        });
      });
    }
  }

  void _changeSocketRoom() {
    _socket.emit('change-room', {'name': _player, 'room': _room});
  }

  void _configSocket() {
    _socket = IO.io(_SOCKET_ADDRESS, <String, dynamic>{
      'transports': ['websocket'],
      'path': _SOCKET_PATH,
      'query': {'name': _player, 'room': _room}
    });

    _socket.on('connect', (_) {
      setState(() {
        _socketConnected = true;
      });
    });

    _socket.on('connect_error', (data) {
      debugPrint("connect_error: " + data.toString());
    });

    _socket.on('disconnect', (_) {
      setState(() {
        _socketConnected = false;
      });
      debugPrint('disconnect');
    });

    _socket.on('player-disconnect', (msg) {
      setState(() {
        Message m = Message.fromJson(msg);
        _messageHistory.add(m);
      });
      _scrollDown();
    });

    _socket.on('player-connect', (msg) {
      setState(() {
        Message m = Message.fromJson(msg);
        _messageHistory.add(m);
      });
      _scrollDown();
    });

    _socket.on('server-error', (err) {
      setState(() {
        Error m = Error.fromJson(err);
        _messageHistory.add(m);
      });
      _scrollDown();
    });

    _socket.on('roll-result', (roll) {
      setState(() {
        Roll r = Roll.fromJson(roll);
        _messageHistory.add(r);
      });
      _scrollDown();
    });

    _socket.on('roll-history', (rolls) {
      setState(() {
        _messageHistory.clear();
        for (Map<String, dynamic> rollJson in rolls) {
          Roll r = Roll.fromJson(rollJson);
          _messageHistory.add(r);
        }
      });
      _scrollDown();
    });
  }

  void _scrollDown() {
    Timer(
      Duration(milliseconds: 500),
      () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      ),
    );
  }
}

class RollButton {
  String value;
  ButtonType type;

  RollButton(this.value, this.type);
}

class Display {
  List<RollButton> _display;

  Display() {
    _display = new List();
  }

  /// Adiciona ao display, fazendo as modificações necessárias
  void add(RollButton value) {
    if (value.type == ButtonType.FUNCTION) {
      return;
    }
    ButtonType lastType = _display.length > 0 ? _display.last.type : null;

    if (lastType == null && value.type == ButtonType.OPERATOR) {
      _display.add(RollButton("0", ButtonType.NUMBER));
    }

    if (lastType == ButtonType.DIE && value.type != ButtonType.OPERATOR) {
      _display.add(RollButton("+", ButtonType.OPERATOR));
    }
    if (lastType == ButtonType.OPERATOR && value.type == ButtonType.OPERATOR) {
      _display.removeLast();
    }
    _display.add(value);
  }

  /// Limpa o display
  void clear() {
    _display.clear();
  }

  bool isFilled() {
    return _display.length > 0;
  }

  String toString() {
    String response = "";
    for (RollButton item in _display) {
      if (item.type == ButtonType.OPERATOR) {
        response += " ${item.value} ";
      } else {
        response += item.value;
      }
    }
    return response;
  }
}

// ignore: must_be_immutable
class ItemMessage extends StatelessWidget {
  final Message message;
  Color _color;

  ItemMessage(this.message, int index) {
    if (index % 2 == 0) {
      _color = Colors.black38;
    } else {
      _color = Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4.0),
        child: Container(
          color: _color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: _buildMessage(),
          ),
        ));
  }

  Row _buildMessage() {
    if (message is Roll) {
      return _buildRowOfRoll(message);
    } else if (message is Error) {
      return _buildRowOfErrorMessage(message);
    } else {
      return _buildRowOfGenericMessage(message);
    }
  }

  Row _buildRowOfGenericMessage(Message msg) {
    return Row(
      children: <Widget>[
        Text(
          msg.text,
          style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.grey[300]),
        ),
      ],
    );
  }

  Row _buildRowOfErrorMessage(Error msg) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            "${msg.text} (${msg.roll}) => ${msg.cause}",
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Row _buildRowOfRoll(Roll roll) {
    return Row(
      children: <Widget>[
        _buildAlert(roll),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                roll.player,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                roll.text,
                style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.grey[300]),
              ),
            ],
          ),
        ),
        Text(
          roll.result.toString(),
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Adiciona um Alerta Amarelo cado nenhum dado tenha sido adicionado a rolagem
  Widget _buildAlert(Roll roll) {
    if (!RegExp(r'd').hasMatch(roll.text)) {
      return Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Icon(Icons.warning, color: Colors.yellowAccent),
      );
    } else {
      return Container();
    }
  }
}
