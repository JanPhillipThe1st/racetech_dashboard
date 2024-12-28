import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultProgressDialog extends StatefulWidget {
  DefaultProgressDialog({Key? key, this.text, this.title}) : super(key: key);
  String? text;
  String? title;
  @override
  _DefaultProgressDialogState createState() => _DefaultProgressDialogState();
}

class _DefaultProgressDialogState extends State<DefaultProgressDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: DefaultText(
        text: widget.title ?? "Loading..",
        fontSize: 24,
        color: racetechPrimaryColor,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: racetechPrimaryColor,
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          DefaultText(
            text: widget.text ?? "Hello World!",
            fontSize: 20,
            color: racetechPrimaryColor,
          ),
        ],
      ),
      actions: [
        DefaultRoundedButton(
          text: "OK",
          fontSize: 12,
          onePressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
