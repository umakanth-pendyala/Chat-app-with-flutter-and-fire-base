import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class CustomMaterialRoundedButton extends StatelessWidget {
  final Color buttonColor;
  final String label;
  final Function whatToDo;

  CustomMaterialRoundedButton({this.buttonColor, this.label, this.whatToDo});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: buttonColor,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: whatToDo,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          label,
        ),
      ),
    );
  }
}
