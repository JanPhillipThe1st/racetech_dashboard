import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/screens/homepage.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultInfoItem.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import 'package:racetech_dashboard/widgets/defaultTextField.dart';
import "package:mailto/mailto.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import "package:provider/provider.dart";

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController =
      TextEditingController(text: "mikeshinobida1920@gmail.com");

  TextEditingController _passwordController =
      TextEditingController(text: "theDeathGodKuro!");

  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['racetechphilippines@gmail.com'],
      cc: [''],
      subject: 'Racetech App Event Booking',
      body: 'Hello, I would like to book an event.',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    Uri mailUri = Uri.dataFromString(mailtoLink.toString());
    await launch('$mailtoLink');
  }

  _makingPhoneCall(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<String> _login() async {
    //Error response format
    //     {
    //     "status": {
    //         "code": "0",
    //         "message": "Failed",
    //         "is_login": "No"
    //     }
    // }
    String errorResponse =
        '   {"status": {"code": "0","message": "Failed","is_login": "No"}}';
    String successResponse =
        '   {"status": {"code": "0","message": "Success","is_login": "Yes"}}';
    String response = await http
        .post(
          Uri.parse("https://racetechph.com/api/loginuser?"),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode(
            {
              "username": _usernameController.text,
              "password": _passwordController.text,
            },
          ),
        )
        .then((value) => value.body);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final sessionDetails = Provider.of<SessionDetails>(context);
    return Scaffold(
        body: Container(
      height: double.maxFinite,
      child: Stack(
        children: [
          // Container(
          //   height: double.maxFinite,
          //   child: Image.asset(
          //     "img/racetech_background.png",
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Container(
            height: double.maxFinite,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(),
              color: Color.fromARGB(255, 45, 76, 253),
            ),
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 500,
                  child: Image.asset(
                    "img/racetech_logo.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.maxFinite,
                  child: DefaultText(
                    text: "RaceTech PH",
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: DefaultText(
                  text: "Race Registration, Race Timing, Race Result",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: DefaultIconTextField(
                        hintText: "Enter your username here...",
                        controller: _usernameController,
                        iconData: CupertinoIcons.person,
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    Container(
                      width: double.maxFinite,
                      child: DefaultIconTextField(
                        hintText: "Enter your password here...",
                        controller: _passwordController,
                        isPassword: true,
                        iconData: CupertinoIcons.padlock,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: DefaultRoundedButton(
                        text: "LOGIN",
                        isInverted: true,
                        color: Colors.white,
                        onePressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultProgressDialog(
                              text: "Logging in..",
                            ),
                          );

                          await _login().then((loginResponse) {
                            if (loginResponse != null) {
                              print(jsonDecode(loginResponse!)["status"]
                                  ["message"]);
                              if (jsonDecode(loginResponse)["status"]["message"]
                                  .toString()
                                  .contains("Success")) {
                                sessionDetails.loginUser(
                                    _usernameController.text,
                                    _passwordController.text);
                                sessionDetails.addListener(() {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Homepage()));
                                });
                              }
                            }
                          });
                        },
                      ),
                    ),
                    DefaultInfoItem(
                      iconData: CupertinoIcons.mail,
                      itemText: "racetechphilippines@gmail.com",
                      onPressed: () async {
                        await launchMailto();
                      },
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    DefaultInfoItem(
                      iconData: CupertinoIcons.phone,
                      itemText: "0977 063 6496",
                      onPressed: () async {
                        await _makingPhoneCall("0977 063 6496");
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
