import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  DefaultTextField(
      {Key? key, required this.hintText, this.controller, this.isPassword})
      : super(key: key);
  String hintText = "";
  bool? isPassword = false;
  TextEditingController? controller;
  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: widget.controller,
            decoration: InputDecoration.collapsed(hintText: widget.hintText),
            obscureText: widget.isPassword ?? false,
          ),
        ],
      ),
    );
  }
}
