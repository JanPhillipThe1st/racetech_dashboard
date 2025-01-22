import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultAlertDialog extends StatefulWidget {
  DefaultAlertDialog({Key? key, this.text, this.actions}) : super(key: key);
  String? text;
  List<Widget>? actions;
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
      actions: widget.actions ??
          [
            DefaultRoundedButton(
              isInverted: true,
              text: "OK",
              color: Colors.white,
              fontSize: 12,
              onePressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
    );
  }
}
