import 'package:flutter/material.dart';

class DefaultLinkText extends StatelessWidget {
  DefaultLinkText(
      {Key? key,
      required this.text,
      required this.fontSize,
      this.color,
      this.onPressed,
      FontWeight? fontWeight})
      : super(key: key);
  String text = "Insert text here";
  Color? color;
  Function()? onPressed;
  double fontSize = 12;
  FontWeight fontWeight = FontWeight.normal;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: fontSize,
            color: color ?? Colors.white,
            fontWeight: fontWeight),
      ),
    );
  }
}
