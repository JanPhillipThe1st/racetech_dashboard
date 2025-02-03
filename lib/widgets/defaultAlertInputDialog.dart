import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultAlerInputDialog extends StatefulWidget {
  DefaultAlerInputDialog(
      {Key? key,
      this.text,
      this.actions,
      required this.controller,
      this.fontSize})
      : super(key: key);
  String? text;
  double? fontSize;
  List<Widget>? actions;
  TextEditingController controller;
  @override
  _DefaultAlerInputDialogState createState() => _DefaultAlerInputDialogState();
}

class _DefaultAlerInputDialogState extends State<DefaultAlerInputDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: racetechPrimaryColor,
      scrollable: true,
      title: DefaultText(
        text: widget.text ?? "Hello World!",
        fontSize: widget.fontSize ?? 20,
      ),
      content: SizedBox(
        height: 150,
        child: TextField(
          controller: widget.controller,
          scrollController: ScrollController(),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(),
          style: TextStyle(color: Colors.white),
          maxLines: 10,
        ),
      ),
      actions: widget.actions ??
          [
            DefaultRoundedButton(
              isInverted: true,
              text: "OK",
              color: Colors.white,
              fontSize: widget.fontSize ?? 12,
              onePressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
    );
  }
}
