import 'dart:convert';
import "dart:io";

import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "package:racetech_dashboard/providers/startListStateProvider.dart";
import "package:racetech_dashboard/utils/colors.dart";
import "package:racetech_dashboard/widgets/defaultAlertDialog.dart";
import "package:racetech_dashboard/widgets/defaultIconTextField.dart";
import "package:racetech_dashboard/widgets/defaultRoundedButton.dart";
import 'package:path_provider/path_provider.dart';
import "package:racetech_dashboard/widgets/defaultText.dart";
import "package:http/http.dart" as http;
import "package:mobile_scanner/mobile_scanner.dart";

class AssignBibNumber extends StatefulWidget {
  const AssignBibNumber(
      {Key? key,
      required this.selectedRacer,
      required this.race_id,
      required this.categories,
      required this.distances})
      : super(key: key);
  final String race_id;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> distances;
  final int selectedRacer;
  @override
  _AssignBibNumberState createState() => _AssignBibNumberState();
}

class _AssignBibNumberState extends State<AssignBibNumber> {
  List<Barcode> _barcodes = [];
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/startlist_${widget.race_id}.json");
  }

  Future<File> saveStartList(List<Map<String, dynamic>> map) async {
    http.Response response = await http
        .get(Uri.parse(
            "https://racetechph.com/myeventlist/startlist/" + widget.race_id))
        .then((value) => value);

    final file = await _localFile;

    // Write the file
    return file.writeAsString(json.encode({
      "startlist": map,
      "category": widget.categories,
      "distance": widget.distances
    }));
  }

  bool _isScanning = false;
  TextEditingController _bibNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _startListProvider = Provider.of<StartListProvider>(context);
    _bibNumberController.text = _startListProvider
        .startList[widget.selectedRacer]["bib_number"]
        .toString();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        foregroundColor: Colors.white,
        title: Text("Assign Bib"),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<StartListProvider>(
              builder: (context, value, child) => Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  DefaultText(
                    text:
                        "${value.startList[widget.selectedRacer]["racer_name"].toString()}",
                    fontSize: 16,
                    fontFamily: "MontserratBold",
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Expanded(
                          child: DefaultIconTextField(
                        onIconClicked: () {
                          showDialog(
                            context: context,
                            builder: (context) => DefaultAlertDialog(
                              text:
                                  "Are you sure you want assign this bib number?",
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
                                  onePressed: () {
                                    value.startList[widget.selectedRacer]
                                            ["bib_number"] =
                                        _bibNumberController.text;
                                    showDialog(
                                      context: context,
                                      builder: (context) => DefaultAlertDialog(
                                        text:
                                            "Bib number assigned successfully!",
                                      ),
                                    ).then((res) {
                                      print(value.startList);
                                      saveStartList(value.startList)
                                          .then((startListResult) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        textInputType: TextInputType.number,
                        controller: _bibNumberController,
                        hintText: "Enter bib number...",
                        iconData: Icons.save_rounded,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                  _isScanning
                      ? Container(
                          height: 200,
                          child: MobileScanner(
                            onScannerStarted: (args) {},
                            onDetect: (BarcodeCapture capture) {
                              _barcodes = capture.barcodes;

                              setState(() {
                                _isScanning = false;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => DefaultAlertDialog(
                                  text:
                                      "${_barcodes[0].rawValue.toString()} found. Use this as bib number?",
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
                                      onePressed: () {
                                        value.startList[widget.selectedRacer]
                                                ["bib_number"] =
                                            _barcodes[0].rawValue.toString();
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DefaultAlertDialog(
                                            text:
                                                "Bib number assigned successfully!",
                                          ),
                                        ).then((res) {
                                          print(value.startList);
                                          saveStartList(value.startList)
                                              .then((startListResult) {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 100),
                        ),
                  Column(
                    children: [
                      DefaultText(
                        text: "Or tap below to assign by QR",
                        fontSize: 16,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_isScanning) {
                              _isScanning = false;
                            } else {
                              _isScanning = true;
                            }
                          });
                        },
                        child: Icon(Icons.qr_code_2_rounded,
                            size: 64,
                            color: _isScanning
                                ? racetechPrimaryColor
                                : Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
