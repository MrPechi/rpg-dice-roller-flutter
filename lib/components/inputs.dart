
import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String _label;
  final TextEditingController _controller;

  InputTextField(this._label, this._controller);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: _controller,
      style: TextStyle(fontSize: 24.0),
      decoration: InputDecoration(
        labelText: _label,
      ),
    );
  }
}
