import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultIconTextField extends StatefulWidget {
  DefaultIconTextField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.isPassword,
      this.onTextChanged,
      this.onIconClicked,
      required this.iconData})
      : super(key: key);
  String hintText = "";
  IconData? iconData;
  Function(String)? onTextChanged;
  Function()? onIconClicked;
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              onChanged: widget.onTextChanged,
              decoration: InputDecoration.collapsed(hintText: widget.hintText),
              obscureText: widget.isPassword ?? false,
            ),
          ),
          GestureDetector(
            child: Icon(widget.iconData),
            onTap: widget.onIconClicked,
          )
        ],
      ),
    );
  }
}
