import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultIconTextField extends StatefulWidget {
  DefaultIconTextField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.isPassword,
      required this.iconData})
      : super(key: key);
  String hintText = "";
  IconData? iconData;
  bool? isPassword = false;
  TextEditingController? controller;
  @override
  _DefaultIconTextFieldState createState() => _DefaultIconTextFieldState();
}

class _DefaultIconTextFieldState extends State<DefaultIconTextField> {
  double containerSize = 100;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Colors.white),
      width: containerSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration.collapsed(hintText: widget.hintText),
              obscureText: widget.isPassword ?? false,
            ),
          ),
          Icon(widget.iconData)
        ],
      ),
    );
  }
}
