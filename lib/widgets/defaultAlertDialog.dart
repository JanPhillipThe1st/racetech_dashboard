import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultAlertDialog extends StatefulWidget {
  DefaultAlertDialog({Key? key, this.text, this.actions, this.fontSize})
      : super(key: key);
  String? text;
  double? fontSize;
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
        fontSize: widget.fontSize ?? 20,
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
