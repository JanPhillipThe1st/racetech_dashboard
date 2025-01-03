import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultRoundedButton extends StatefulWidget {
  DefaultRoundedButton(
      {Key? key,
      this.text,
      this.fontSize,
      this.onePressed,
      this.color,
      this.isInverted})
      : super(key: key);
  String? text;
  bool? isInverted;
  Color? color;
  double? fontSize;
  Function()? onePressed;
  @override
  _DefaultRoundedButtonState createState() => _DefaultRoundedButtonState();
}

class _DefaultRoundedButtonState extends State<DefaultRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white, width: 0.5),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      ),
      onPressed: widget.onePressed ??
          () {
            showDialog(
                context: context,
                builder: (context) {
                  return DefaultAlertDialog(text: "Logged in!");
                });
          },
      child: DefaultText(
        text: widget.text ?? "Text here...",
        fontSize: widget.fontSize ?? 20,
        color: widget.color ?? racetechPrimaryColor,
      ),
    );
  }
}
