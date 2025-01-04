import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:provider/provider.dart";

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
        color: Colors.white,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Consumer<SessionDetails>(
                  builder: (context, value, child) {
                    if (value.sessionDetailsMap == null) {
                      return Icon(CupertinoIcons.person);
                    } else {
                      return Container(
                        padding: EdgeInsets.all(3),
                        decoration: ShapeDecoration(
                            shape: CircleBorder(), color: racetechPrimaryColor),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: ShapeDecoration(shape: CircleBorder()),
                          child: Image.network(
                              "https://racetechph.com/assets/img/" +
                                  value.sessionDetailsMap!["status"]
                                      ["user_id"] +
                                  ".jpg",
                              fit: BoxFit.fitHeight,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.network(
                                      "https://racetechph.com/assets/img/" +
                                          value.sessionDetailsMap!["status"]
                                              ["user_id"] +
                                          ".png")),
                        ),
                      );
                    }
                  },
                )),
            Expanded(
              flex: 2,
              child: Container(
                child: Consumer<SessionDetails>(
                  builder: (context, sessionDetailState, child) {
                    return DefaultText(
                      text: sessionDetailState.sessionDetailsMap == null
                          ? "..."
                          : sessionDetailState.sessionDetailsMap!["status"]
                              ["full_name"],
                      fontSize: 24,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Consumer<SessionDetails>(
                  builder: (context, sessionDetailState, child) {
                    return DefaultText(
                      text:
                          // sessionDetailState.sessionDetailsMap == null?
                          "...",
                      // : sessionDetailState.sessionDetailsMap![]["username"],
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
