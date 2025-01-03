import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class RaceResult extends StatefulWidget {
  const RaceResult({Key? key}) : super(key: key);

  @override
  _RaceResultState createState() => _RaceResultState();
}

class _RaceResultState extends State<RaceResult> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        color: racetechPrimaryColor,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              child: DefaultText(
                text: "RACE RESULTS",
                fontSize: 24,
                fontWeight: FontWeight.w100,
                color: racetechPrimaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
            ),
          ],
        ),
      ),
    );
  }
}
