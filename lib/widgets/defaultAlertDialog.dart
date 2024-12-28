import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultAlertDialog extends StatefulWidget {
  DefaultAlertDialog({Key? key, this.text}) : super(key: key);
  String? text;
  @override
  _DefaultAlertDialogState createState() => _DefaultAlertDialogState();
}

class _DefaultAlertDialogState extends State<DefaultAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: racetechPrimaryColor,
      title: DefaultText(
        text: widget.text ?? "Hello World!",
        fontSize: 20,
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
