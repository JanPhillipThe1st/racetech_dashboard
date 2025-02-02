import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:racetech_dashboard/providers/signupProvider.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:http/http.dart" as http;
import "package:provider/provider.dart";

class SaveUser extends StatefulWidget {
  const SaveUser({Key? key}) : super(key: key);

  @override
  _SaveUserState createState() => _SaveUserState();
}

class _SaveUserState extends State<SaveUser> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _signupUser = Provider.of<SignupProvider>(context);
    return Scaffold(
      backgroundColor: racetechPrimaryColor,
      appBar: AppBar(
        title: Text("Set Password"),
        backgroundColor: Colors.transparent,
        elevation: 2,
        foregroundColor: Colors.grey,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 700,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 20)),
                            Image.asset(
                              "img/runners.png",
                              scale: 16,
                            ),
                            DefaultText(
                              text: "Welcome to RaceTech PH!",
                              fontSize: 24,
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            DefaultText(
                              text: _signupUser.userMap == null
                                  ? "No data"
                                  : _signupUser.userMap["username"],
                              fontSize: 24,
                            ),
                            DefaultText(
                              text: "Username",
                              fontSize: 12,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 20)),
                            DefaultText(
                              text: "Please set your password below.",
                              fontSize: 16,
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                            Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: DefaultIconTextField(
                                  hintText: "Password",
                                  textInputType: TextInputType.text,
                                  isPassword: true,
                                  controller: _passwordController,
                                  iconData: Icons.lock_rounded),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                            Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: DefaultIconTextField(
                                  focusColor: racetechPrimaryColor,
                                  hintText: "Confirm Password",
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  iconData: Icons.lock_outline_rounded),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            Container(
                                constraints: BoxConstraints.expand(height: 50),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: DefaultRoundedButton(
                                    backgroundColor:
                                        Color.fromARGB(255, 52, 79, 202),
                                    isInverted: true,
                                    text: "SAVE",
                                    color: Colors.white,
                                    onePressed: () async {
                                      if (_passwordController.text.isEmpty ||
                                          _confirmPasswordController
                                              .text.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultAlertDialog(
                                            text: "Please fill in all fields",
                                            fontSize: 12,
                                          ),
                                        );
                                        return;
                                      }
                                      if (_passwordController.text !=
                                          _confirmPasswordController.text) {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultAlertDialog(
                                            text: "Passwords do not match!",
                                            fontSize: 16,
                                          ),
                                        );
                                        return;
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                DefaultProgressDialog(
                                                  text:
                                                      "Saving  account.\nPlease wait...",
                                                  fontSize: 16,
                                                ));
                                        await http.post(
                                            Uri.parse(
                                                "https://racetechph.com/api/accounts/insertuser?"),
                                            body: {
                                              "racer_id": _signupUser
                                                  .userMap["racer_id"],
                                              "username": _signupUser
                                                  .userMap["username"],
                                              "password":
                                                  _confirmPasswordController
                                                      .text
                                            }).then((saveUserResponse) {
                                          Navigator.of(context).pop();
                                          if (json
                                              .decode(saveUserResponse.body)[
                                                  "status"]["message"]
                                              .toString()
                                              .toLowerCase()
                                              .contains("success")) {
                                            showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DefaultAlertDialog(
                                                            text:
                                                                "Signup Successful!"))
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            });
                                          } else {
                                            showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DefaultAlertDialog(
                                                            text:
                                                                "Signup failed! ${json.decode(saveUserResponse.body)["status"]["message"]}"))
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        });
                                      }
                                    }))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
