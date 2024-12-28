import 'package:flutter/material.dart';

class DefaultText extends StatelessWidget {
  DefaultText(
      {Key? key,
      required this.text,
      required this.fontSize,
      this.color,
      FontWeight? fontWeight})
      : super(key: key);
  String text = "Insert text here";
  Color? color;
  double fontSize = 12;
  FontWeight fontWeight = FontWeight.normal;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: fontSize,
          color: color ?? Colors.white,
          fontWeight: fontWeight),
    );
  }
}
