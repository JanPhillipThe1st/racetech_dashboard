import 'package:flutter/material.dart';
import 'package:racetech_dashboard/providers/signupProvider.dart';
import 'package:racetech_dashboard/screens/pages/saveUser.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/utils/stringValues.dart';
import 'package:racetech_dashboard/widgets/addressSelection.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "dart:convert";

import "package:provider/provider.dart";
import "package:http/http.dart" as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String selectedProvince = "State / province (Select)";
  String selectedCity = "City (Select)";
  String selectedGender = "Gender (Select)";
  String birthDate = "Birthdate (Set)";

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _middlenameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _teamnameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _countryController =
      TextEditingController(text: "Philippines");
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _contactPersonNumberController =
      TextEditingController();
  // TextEditingController _firstnameController =
  //     TextEditingController(text: "Toni2");
  // TextEditingController _middlenameController =
  //     TextEditingController(text: "H");
  // TextEditingController _lastnameController =
  //     TextEditingController(text: "Starke2");
  // TextEditingController _teamnameController =
  //     TextEditingController(text: "STARK");
  // TextEditingController _addressController = TextEditingController(text: "NYC");
  // TextEditingController _countryController =
  //     TextEditingController(text: "Philippines");
  // TextEditingController _emailController =
  //     TextEditingController(text: "testtony2@example.com");
  // TextEditingController _phoneNumberController =
  //     TextEditingController(text: "9656335688");
  // TextEditingController _contactPersonController =
  //     TextEditingController(text: "Howard");
  // TextEditingController _contactPersonNumberController =
  //     TextEditingController(text: "96532264122");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: racetechPrimaryColor,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        foregroundColor: Colors.white,
        title: Text("Sign up"),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
              flex: 12,
              child: ListView(
                children: [
                  Container(
                    child: DefaultText(
                      text: "Welcome to RaceTech PH!",
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Image.asset("img/registration.png"),
                  ),
                  Container(
                    child: DefaultText(
                      text: "Tell us about yourself!",
                      fontSize: 16,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: DefaultIconTextField(
                            controller: _firstnameController,
                            hintText: "First Name",
                            iconData: null),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4)),
                      Expanded(
                        child: DefaultIconTextField(
                            controller: _middlenameController,
                            hintText: "Middle Name",
                            iconData: null),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                      hintText: "Last Name",
                      controller: _lastnameController,
                      iconData: null),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddressSelection(
                          placeMap: ["Male", "Female"],
                          onSelectItem: (selectedGenderResult) {
                            selectedGender = selectedGenderResult;
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DefaultText(
                            text: selectedGender,
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                          ),
                          const Icon(Icons.wc_rounded),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                              context: context,
                              firstDate: DateTime(1920),
                              lastDate: DateTime.now())
                          .then((birthdateValue) {
                        if (birthdateValue != null) {
                          birthDate =
                              "${birthdateValue.month.toString().padLeft(2, '0')}-${birthdateValue.day.toString().padLeft(2, '0')}-${birthdateValue.year}";
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DefaultText(
                            text: birthDate,
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                          ),
                          const Icon(Icons.cake),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  DefaultIconTextField(
                    hintText: "Team",
                    controller: _teamnameController,
                    iconData: Icons.group_rounded,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    hintText: "Address",
                    controller: _addressController,
                    iconData: Icons.location_on_rounded,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    hintText: "Country",
                    controller: _countryController,
                    iconData: Icons.flag_rounded,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddressSelection(
                          placeMap: addressMap["Philippines"]!.keys.toList()!,
                          onSelectItem: (selectedProvinceResult) {
                            selectedProvince = selectedProvinceResult;
                            selectedCity = "City (Select)";
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DefaultText(
                            text: selectedProvince,
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                          ),
                          const Icon(Icons.house_rounded),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddressSelection(
                          placeMap:
                              addressMap["Philippines"]![selectedProvince]!,
                          onSelectItem: (selectedCityResult) {
                            selectedCity = selectedCityResult;
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DefaultText(
                            text: selectedCity,
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                          ),
                          const Icon(Icons.location_city)
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    hintText: "Email",
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    iconData: Icons.email_rounded,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    hintText: "Contact no.",
                    textInputType: TextInputType.phone,
                    controller: _phoneNumberController,
                    iconData: Icons.phone_android,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image.asset(
                      //   "img/sos.gif",
                      //   scale: 16,
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: DefaultText(
                          text: "Incase of emergency",
                          fontSize: 16,
                        ),
                      ),
                      // Image.asset(
                      //   "img/ambulance.gif",
                      //   scale: 16,
                      // ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    hintText: "Contact person",
                    controller: _contactPersonController,
                    iconData: Icons.contact_phone_rounded,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    textInputType: TextInputType.phone,
                    hintText: "Contact person no.",
                    controller: _contactPersonNumberController,
                    iconData: Icons.contact_emergency_rounded,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  Container(
                    constraints: BoxConstraints.expand(height: 40),
                    child: DefaultRoundedButton(
                      text: "SAVE",
                      color: Colors.white,
                      onePressed: () async {
                        if (_firstnameController.text.isEmpty ||
                            _middlenameController.text.isEmpty ||
                            _lastnameController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please complete your name.",
                            ),
                          );
                          return;
                        }
                        if (birthDate.contains("Set")) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please input your birthdate.",
                            ),
                          );
                          return;
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text)) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please input a valid email.",
                            ),
                          );
                          return;
                        }
                        if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                .hasMatch(_phoneNumberController.text) ||
                            _phoneNumberController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please input a valid mobile number.",
                            ),
                          );
                          return;
                        }
                        if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(
                                _contactPersonNumberController.text) ||
                            _contactPersonNumberController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text:
                                  "Please input a valid contact person mobile number.",
                            ),
                          );
                          return;
                        }
                        if (selectedProvince.contains("Select")) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please select your state/province.",
                            ),
                          );
                          return;
                        }
                        if (selectedCity.contains("Select")) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please select your city.",
                            ),
                          );
                          return;
                        }
                        if (_contactPersonController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please set a contact person.",
                            ),
                          );
                          return;
                        }
                        if (_addressController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please input your address.",
                            ),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => DefaultProgressDialog(
                            title: "Saving your information...",
                            text: "Sign up",
                          ),
                        );
                        await http.post(
                            Uri.parse(
                                "https://racetechph.com/api/personalinformartion/insert?"),
                            body: {
                              "givenName": _firstnameController.text,
                              "middleName": _middlenameController.text,
                              "surName": _lastnameController.text,
                              "birthDate": birthDate,
                              "gender": selectedGender,
                              "contactEmail": _emailController.text,
                              "contactNumber":
                                  "0${_phoneNumberController.text}",
                              "address": _addressController.text,
                              "city": selectedCity,
                              "state": selectedProvince,
                              "country": _countryController.text,
                              "emergencyName": _contactPersonController.text,
                              "emergencyContact":
                                  "0${_contactPersonNumberController.text}",
                              "team": _teamnameController.text
                            }).then((signupResponse) async {
                          if (signupResponse.statusCode == 200) {
                            if (json
                                .decode(signupResponse.body)[0]
                                .toString()
                                .toLowerCase()
                                .contains("insertsuccess")) {
                              Navigator.of(context).pop();
                              await showDialog(
                                  context: context,
                                  builder: (context) => DefaultAlertDialog(
                                        text: "Sign up success!",
                                      ),
                                  barrierDismissible: false);
                              Navigator.of(context).pop();
                              SignupProvider _signupProvider =
                                  Provider.of<SignupProvider>(context,
                                      listen: false);
                              _signupProvider.setUser({
                                "racer_id": json.decode(signupResponse.body)[1],
                                "username": _emailController.text,
                                "gender": selectedGender,
                                "password": "to be set"
                              });
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                    builder: (context) => SaveUser(),
                                  ))
                                  .then((value) {});
                            } else {
                              Navigator.of(context).pop();
                              await showDialog(
                                  context: context,
                                  builder: (context) => DefaultAlertDialog(
                                        text: "Sign up failed!" +
                                            json
                                                .decode(signupResponse.body)[0]
                                                .tostring(),
                                        fontSize: 16,
                                      ),
                                  barrierDismissible: false);
                            }
                          } else {
                            Navigator.of(context).pop();
                            await showDialog(
                                context: context,
                                builder: (context) => DefaultAlertDialog(
                                      text:
                                          "Sign up failed!\n${signupResponse.reasonPhrase!}",
                                      fontSize: 16,
                                    ),
                                barrierDismissible: false);
                          }
                        });
                      },
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 19, 54, 172)),
                      backgroundColor: Color.fromARGB(255, 52, 79, 202),
                      isInverted: true,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              )),
        ],
      ),
    );
  }
}
