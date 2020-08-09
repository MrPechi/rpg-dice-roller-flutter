import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rpg_dice_roller/database/queries.dart';
import 'package:rpg_dice_roller/models/room.dart';
import 'package:rpg_dice_roller/screens/roll_screen.dart';
import 'package:rpg_dice_roller/screens/room_edit_screen.dart';

class RoomsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RoomsScreenState();
  }
}

class RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildRoomsList(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Escolha uma Sala'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _createOrEditRoom(context, null),
        )
      ],
    );
  }

  void _createOrEditRoom(BuildContext context, Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoomEditScreen(room)),
    ).then((value) => {if (value != null) setState(() {})}); // Just for rebuild
  }

  Widget _buildRoomsList() {
    return FutureBuilder<List<Room>>(
      future: findAll(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[CircularProgressIndicator(), Text("Carregando...")],
              ),
            );
          case ConnectionState.done:
            final List<Room> _rooms = List();
            _rooms.add(Room.solo());
            _rooms.addAll(snapshot.data);
            return ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  return _buildItemRoom(context, _rooms[index]);
                });
          default:
            return Text("Ocorreu um erro estranho... Sentimos muito.");
        }
      },
    );
  }

  Widget _buildItemRoom(BuildContext context, Room room) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () => _navigateToRollScreen(context, room),
                child: ListTile(
                  title: Text(
                    room.roomName,
                    style: TextStyle(fontSize: 24),
                  ),
                  subtitle: Text(room.playerName),
                ),
              ),
            ),
          ),
          _buildEditButton(room),
        ],
      ),
    );
  }

  void _navigateToRollScreen(BuildContext context, Room room) {
    if (Navigator.canPop(context)) {
      debugPrint("pop");
      Navigator.pop(context, room);
    } else {
      debugPrint("pushReplacement");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return RollScreen(room);
        }),
      );
    }
  }

  Widget _buildEditButton(Room room) {
    if (room.id == Room.SOLO_ID) {
      return Container();
    } else {
      return IconButton(icon: Icon(Icons.edit), onPressed: () => _createOrEditRoom(context, room));
    }
  }
}
