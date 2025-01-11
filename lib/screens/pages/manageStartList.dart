import 'dart:convert';
import "dart:io";

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/categoryCards.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import 'package:path_provider/path_provider.dart';
import "package:http/http.dart" as http;

class ManageStartList extends StatefulWidget {
  const ManageStartList({Key? key, required this.race_id}) : super(key: key);
  final String race_id;
  @override
  _ManageStartListState createState() => _ManageStartListState();
}

class _ManageStartListState extends State<ManageStartList> {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/startlist_${widget.race_id}.json");
  }

  Future<File> downloadStartList() async {
    http.Response response = await http
        .get(Uri.parse(
            "https://racetechph.com/myeventlist/startlist/" + widget.race_id))
        .then((value) => value);

    final file = await _localFile;

    // Write the file
    return file.writeAsString(response.body);
  }

  List<Map<String, dynamic>> offlineStartList = [];
  Future<void> readOfflineStartlist() async {
    try {
      final file = await _localFile;
      bool exists = await file.exists();
      if (exists) {
        // Read the file
        final contents = await file.readAsString();
        if (_refNumberController.text.isEmpty) {
          offlineStartList = List<Map<String, dynamic>>.from(
              json.decode(contents)["startlist"]);
        } else {
          offlineStartList = List<Map<String, dynamic>>.from(
                  json.decode(contents)["startlist"])
              .where((element) => element["ref_id"]
                  .toString()
                  .contains(_refNumberController.text))
              .toList();
        }
      } else {
        final startListFile = await downloadStartList();
        final contents = await startListFile.readAsString();
        if (_refNumberController.text.isEmpty) {
          offlineStartList = List<Map<String, dynamic>>.from(
              json.decode(contents)["startlist"]);
        } else {
          offlineStartList = List<Map<String, dynamic>>.from(
                  json.decode(contents)["startlist"])
              .where((element) => element["ref_id"]
                  .toString()
                  .contains(_refNumberController.text))
              .toList();
        }
      }
    } catch (e) {
      // If encountering an error, return 0
      offlineStartList = List.empty();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //First, we check if the file is already downloaded

    //TODO: Check if the file is already downloaded
    //And then we parse it as a string
    //TODO: get Map<String,dynamic> jsonStartlist from the available offline file.

    //ignore all for test mode
  }

  TextEditingController _refNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        foregroundColor: Colors.white,
        title: Text("Manage Startlist"),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 12,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      DefaultText(
                        text: "Search by:",
                        fontSize: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Expanded(
                          child: DefaultIconTextField(
                        controller: _refNumberController,
                        onIconClicked: () {
                          setState(() {
                            readOfflineStartlist();
                          });
                        },
                        hintText: "Ref. No.",
                        iconData: Icons.search,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      GestureDetector(
                        child: Icon(Icons.qr_code_2_rounded,
                            size: 32, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: FutureBuilder(
                      future: readOfflineStartlist(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: ShapeDecoration(
                              shadows: defaultCardShadowsDarkMale,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color:
                                          Color.fromARGB(255, 225, 242, 255))),
                              color: Color.fromARGB(255, 30, 30, 31),
                            ),
                            height: 200,
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    categoryCardMap[offlineStartList[index]
                                            ["category"]
                                        .toString()]!,
                                    Container(
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 10),
                                      alignment: Alignment.centerRight,
                                      // decoration: BoxDecoration(
                                      //   gradient: LinearGradient(colors: [
                                      //     const Color.fromARGB(0, 0, 0, 0),
                                      //     Color.fromARGB(153, 253, 198, 161)
                                      //   ]),
                                      // ),
                                      child: offlineStartList[index]
                                                  ["bib_number"] !=
                                              null
                                          ? DefaultText(
                                              text: offlineStartList[index]
                                                  ["bib_number"],
                                              fontSize: 24,
                                              fontFamily: "MontserratBold",
                                              color: Color.fromARGB(
                                                  255, 219, 221, 255),
                                            )
                                          : GestureDetector(
                                              child: Container(
                                                width: 130,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                decoration: ShapeDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 32, 128, 253),
                                                        Color.fromARGB(
                                                            255, 22, 71, 134)
                                                      ]),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    DefaultText(
                                                      text: "Assign",
                                                      fontSize: 20,
                                                      fontFamily:
                                                          "MontserratBold",
                                                      color: Colors.white,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .chevron_right_rounded,
                                                      size: 36,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                                Expanded(
                                  child: DefaultText(
                                    text: offlineStartList[index]["racer_name"],
                                    fontSize: 24,
                                    fontFamily: "MontserratBold",
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        offlineStartList[index]["gender"]
                                                .toString()
                                                .contains("FEMALE")
                                            ? Icons.woman_outlined
                                            : Icons.man_4,
                                        color: offlineStartList[index]["gender"]
                                                .toString()
                                                .contains("FEMALE")
                                            ? const Color.fromARGB(
                                                255, 255, 90, 145)
                                            : const Color.fromARGB(
                                                255, 47, 75, 231),
                                      ),
                                      DefaultText(
                                        text: offlineStartList[index]["gender"]
                                            .toString(),
                                        fontSize: 20,
                                        fontFamily: "Montserrat",
                                        color: offlineStartList[index]["gender"]
                                                .toString()
                                                .contains("FEMALE")
                                            ? const Color.fromARGB(
                                                255, 255, 90, 145)
                                            : const Color.fromARGB(
                                                255, 47, 75, 231),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      DefaultText(
                                        text: "Distance",
                                        fontSize: 16,
                                        fontFamily: "Montserrat",
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                      ),
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          backgroundColor: Colors.transparent,
                                          value: 1,
                                          color:
                                              Color.fromARGB(255, 226, 132, 56),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                      ),
                                      DefaultText(
                                        text: offlineStartList[index]
                                                ["distance_name"]
                                            .toString(),
                                        fontSize: 16,
                                        fontFamily: "Montserrat",
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: DefaultText(
                                    text: "Reference Number: " +
                                        offlineStartList[index]["ref_id"],
                                    fontSize: 12,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          itemCount: offlineStartList == null
                              ? 0
                              : offlineStartList.length,
                        );
                      }),
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => DefaultProgressDialog(
                            title: "Uploading startlist",
                            text: "Please wait...",
                          ),
                      barrierDismissible: false);
                },
                child: Container(
                  constraints: BoxConstraints.expand(),
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(24),
                      ),
                      gradient: const RadialGradient(
                          radius: 3,
                          center: Alignment.topRight,
                          colors: [
                            Color.fromARGB(255, 42, 152, 255),
                            Color.fromARGB(255, 61, 73, 238),
                          ],
                          tileMode: TileMode.clamp)),
                  child: Text(
                    "Upload startlist",
                    style: TextStyle(
                        fontFamily: "MontserratBold", color: Colors.white),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
