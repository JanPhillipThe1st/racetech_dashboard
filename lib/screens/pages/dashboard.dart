import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: racetechPrimaryColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              child: DefaultText(
                text: "DASHBOARD",
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
