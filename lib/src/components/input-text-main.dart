import 'package:flutter/material.dart';

class InputTextMain extends StatelessWidget {
  final Color fillColor;
  final double height;
  final double paddingLeft;
  final double paddingRight;
  final bool password;
  final TextEditingController controller;
  final TextInputType textType;
  final String Function(String) validator;
  final String Function(String) onSaved;
  final void Function(void) onChanged;
  final String hintText;
  final String errorText;



  const InputTextMain({
    Key key,
    this.fillColor = Colors.white,
    this.height = 60.0,
    this.paddingLeft = 20.0,
    this.paddingRight = 20.0,
    this.password = false,
    this.controller,
    this.textType,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.hintText,
    this.errorText,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: height,
      child: TextField(
        obscureText: this.password,
        controller: controller,
        keyboardType: textType,
        onChanged: onChanged,
        decoration: InputDecoration(
            filled: true,
            enabledBorder: InputBorder.none,
            fillColor: fillColor,
            hintText: hintText,
            errorText: errorText,
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2ECC71))
            )
        ),
      ),
    );
  }
}