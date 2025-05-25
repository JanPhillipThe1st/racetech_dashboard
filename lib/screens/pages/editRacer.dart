import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/addressSelection.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import 'package:path_provider/path_provider.dart';

class EditRacer extends StatefulWidget {
  const EditRacer(
      {Key? key,
      required this.startList,
      required this.racer_id,
      required this.bib_number,
      required this.itemIndex,
      required this.categories,
      required this.distances,
      required this.race_id})
      : super(key: key);
  final List<Map<String, dynamic>> startList;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> distances;
  final String racer_id;
  final int itemIndex;
  final String bib_number;
  final String race_id;
  @override
  _EditRacerState createState() => _EditRacerState();
}

class _EditRacerState extends State<EditRacer> {
  TextEditingController _racerNameController = TextEditingController();
  String selectedGender = "Gender (Set)";
  String selectedDistance = "Distance (Set)";
  String selectedCategory = "Category (Set)";
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _teamNameController = TextEditingController();
  double _categorySliderValue = 20;
  double _distanceSliderValue = 5;
  bool year2023 = true;
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/startlist_${widget.race_id}.json");
  }

  Future<void> updateOfflineStartlist() async {
    final file = await _localFile;
    bool exists = await file.exists();
    Map<String, dynamic> updatedStartlist = {
      "startlist": widget.startList,
      "category": widget.categories,
      "distance": widget.distances
    };
    if (exists) {
      file.writeAsString(jsonEncode(updatedStartlist));
    }
  }

  Map<String, dynamic> racerDetails = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    racerDetails = widget.startList[widget.itemIndex];
    print(widget.startList);
    _racerNameController.text = racerDetails["racer_name"];
    _phoneNumberController.text = racerDetails["contact_number"].toString();
    _teamNameController.text = racerDetails["team_name"] ?? "";
    selectedGender = racerDetails["gender"];
    selectedCategory = racerDetails["category"];
    selectedDistance = racerDetails["distance_name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: racetechPrimaryColor,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        foregroundColor: Colors.white,
        title: Text("Edit Racer Details"),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
              flex: 12,
              child: ListView(
                children: [
                  Container(
                    height: 100,
                    child: Image.asset("img/registration.png"),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  DefaultIconTextField(
                    hintText: "Full name",
                    controller: _racerNameController,
                    iconData: Icons.group_rounded,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddressSelection(
                          placeMap: ["MALE", "FEMALE"],
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
                            text: selectedGender!,
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
                  DefaultIconTextField(
                    hintText: "Contact no.",
                    textInputType: TextInputType.phone,
                    controller: _phoneNumberController,
                    iconData: Icons.phone_android,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  DefaultIconTextField(
                    hintText: "Team name",
                    controller: _teamNameController,
                    textInputType: TextInputType.text,
                    iconData: Icons.group,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddressSelection(
                          placeMap: widget.distances
                                  .map((distance_object) =>
                                      distance_object["distance_name"]
                                          .toString())
                                  .toList() ??
                              ["Not assigned"],
                          onSelectItem: (selectedGenderResult) {
                            selectedDistance = selectedGenderResult;
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
                            text: selectedDistance!,
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
                      showDialog(
                        context: context,
                        builder: (context) => AddressSelection(
                          placeMap: widget.categories
                                  .map((category_object) =>
                                      category_object["category"].toString())
                                  .toList() ??
                              ["Not assigned"],
                          onSelectItem: (selectedGenderResult) {
                            selectedCategory = selectedGenderResult;
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
                            text: selectedCategory!,
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                          ),
                          const Icon(Icons.wc_rounded),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  Container(
                    constraints: BoxConstraints.expand(height: 40),
                    child: DefaultRoundedButton(
                      onePressed: () async {
                        //Check if the racer name is empty
                        if (_racerNameController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please input a valid racer name.",
                            ),
                          );
                          return;
                        }
                        //Check if the team name is empty
                        if (_teamNameController.text.isEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text: "Please input a valid team name.",
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
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => DefaultProgressDialog(
                            title: "Updating racer information...",
                            text: "Please wait.",
                          ),
                        );
                        //Delete this item in the session details map
                        racerDetails["racer_name"] = _racerNameController.text;
                        racerDetails["gender"] = selectedGender.toUpperCase();
                        racerDetails["category"] = selectedCategory;
                        racerDetails["distance_name"] = selectedDistance;
                        racerDetails["contact_number"] =
                            _phoneNumberController.text.toString();
                        racerDetails["team_name"] = _teamNameController.text;
                        print(racerDetails);
                        widget.startList[widget.itemIndex] = racerDetails;
                        widget.startList.forEach((r) {
                          print(r);
                        });
                        print(widget.startList);
                        updateOfflineStartlist();
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => DefaultAlertDialog(
                            text: "Racer Information saved locally!",
                            fontSize: 16,
                          ),
                        ).then((value) {
                          Navigator.of(context).pop();
                        });
                      },
                      text: "SAVE",
                      color: Colors.white,
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
