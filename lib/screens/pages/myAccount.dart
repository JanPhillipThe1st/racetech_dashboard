import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
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
                text: "MY ACCOUNT",
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
