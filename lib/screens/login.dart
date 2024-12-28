import 'package:flutter/material.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import 'package:racetech_dashboard/widgets/defaultTextField.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(vertical: 50),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.maxFinite,
                  child: DefaultText(
                    text: "RaceTech PH",
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: DefaultText(
                  text: "Please enter username and password.",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: DefaultTextField(
                        hintText: "Enter your username here...",
                        controller: _usernameController,
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    Container(
                      width: double.maxFinite,
                      child: DefaultTextField(
                        hintText: "Enter your password here...",
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    Container(
                      width: double.maxFinite,
                      child: DefaultRoundedButton(
                        text: "LOGIN",
                        color: Colors.white,
                        onePressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultProgressDialog(
                              text: "Logging in..",
                            ),
                          );
                        },
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
