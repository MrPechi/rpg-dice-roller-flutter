
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function _onPressFunction;
  final IconData _iconData;

  RoundButton(this._iconData, this._onPressFunction);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(_iconData),
        color: Colors.white,
        onPressed: () => _onPressFunction(),
      ),
    );
  }
}
