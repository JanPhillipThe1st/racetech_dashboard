import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultIconTextField extends StatefulWidget {
  DefaultIconTextField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.isPassword,
      this.onTextChanged,
      this.isGender,
      this.onIconClicked,
      this.focusColor,
      this.textInputType,
      required this.iconData})
      : super(key: key);
  String hintText = "";
  bool? isGender = false;
  IconData? iconData;
  TextInputType? textInputType;
  Color? focusColor;
  Function(String)? onTextChanged;
  Function()? onIconClicked;
  bool? isPassword = false;
  TextEditingController? controller;
  @override
  _DefaultIconTextFieldState createState() => _DefaultIconTextFieldState();
}

class _DefaultIconTextFieldState extends State<DefaultIconTextField> {
  double containerSize = 160;
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
          widget.textInputType == TextInputType.phone
              ? Container(
                  alignment: Alignment.center,
                  child: DefaultText(
                    text: "+63",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
              : Container(),
          widget.textInputType == TextInputType.phone
              ? Padding(padding: EdgeInsets.symmetric(horizontal: 4))
              : Container(),
          Expanded(
            child: TextField(
              autofillHints:
                  widget.isGender != null ? ["Male", "Female"] : null,
              textInputAction: TextInputAction.search,
              keyboardType: widget.textInputType ?? TextInputType.text,
              controller: widget.controller,
              onChanged: widget.onTextChanged,
              maxLength:
                  widget.textInputType == TextInputType.phone ? 10 : null,
              enableSuggestions: true,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) =>
                  null,
              decoration: InputDecoration.collapsed(
                  hintText: widget.hintText, focusColor: widget.focusColor),
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
