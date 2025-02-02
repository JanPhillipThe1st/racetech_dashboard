import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:provider/provider.dart";
import "package:path_provider/path_provider.dart";

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_details.txt');
  }

  Future<void> deleteUserCredentials() async {
    final file = await _localFile;
    await file.delete(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                          child: value.userPhoto,
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
                    return Column(
                      children: [
                        DefaultText(
                          text: sessionDetailState
                                      .sessionDetailsMap!["status"] ==
                                  null
                              ? "..."
                              : sessionDetailState.sessionDetailsMap!["status"]
                                  ["full_name"],
                          fontSize: 24,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ),
                        DefaultText(
                          text: sessionDetailState
                                      .sessionDetailsMap!["status"] ==
                                  null
                              ? "..."
                              : sessionDetailState.userDetailsMap!["username"],
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: DefaultText(
                            text: sessionDetailState.userDetailsMap == null
                                ? "John Doe"
                                : sessionDetailState
                                        .userDetailsMap!["firstname"] +
                                    " " +
                                    sessionDetailState
                                        .userDetailsMap!["middlename"] +
                                    " " +
                                    sessionDetailState
                                        .userDetailsMap!["lastname"],
                            fontSize: 20,
                            fontFamily: "Montserrat",
                            color: Colors.black,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => DefaultAlertDialog(
                                text: "Are you sure you want to log out?",
                                actions: [
                                  DefaultRoundedButton(
                                    isInverted: true,
                                    text: "NO",
                                    color: Colors.white,
                                    fontSize: 12,
                                    onePressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  DefaultRoundedButton(
                                    isInverted: true,
                                    text: "YES",
                                    color: Colors.white,
                                    fontSize: 12,
                                    onePressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultProgressDialog(
                                                title: "Logging out.",
                                                text: "Please wait...",
                                              ),
                                          barrierDismissible: false);
                                      await Future.delayed(
                                          Duration(seconds: 3));
                                      await deleteUserCredentials()
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(
                                        width: 0.5,
                                        color: racetechPrimaryColor))),
                            child: DefaultText(
                              text: "Log out",
                              fontSize: 20,
                              fontFamily: "Montserrat",
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
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
