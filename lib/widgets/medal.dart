import 'package:flutter/material.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class Medal extends StatelessWidget {
  Medal(
      {Key? key,
      required this.rank,
      this.borderColor,
      this.fillColor,
      this.fontSize})
      : super(key: key);
  final String rank;
  Color? borderColor;
  Color? fillColor;
  double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                width: 3,
                color: borderColor ?? Color.fromARGB(255, 176, 217, 255)),
          ),
          color: fillColor ?? Color.fromARGB(255, 64, 123, 179)),
      child: DefaultText(
        text: rank,
        fontSize: fontSize ?? 12,
        fontFamily: "MontserratBlack",
      ),
    );
  }
}
