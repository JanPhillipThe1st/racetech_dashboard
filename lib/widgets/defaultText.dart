import 'package:flutter/material.dart';

class DefaultText extends StatelessWidget {
  DefaultText(
      {Key? key,
      required this.text,
      required this.fontSize,
      this.color,
      this.fontFamily,
      this.fontWeight})
      : super(key: key);
  String text = "Insert text here";
  Color? color;
  String? fontFamily;
  double fontSize = 12;
  FontWeight? fontWeight = FontWeight.normal;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: fontFamily ?? "Montserrat",
          fontSize: fontSize,
          color: color ?? Colors.white,
          fontWeight: fontWeight),
    );
  }
}
