import "dart:convert";
import "dart:io";

import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import "package:racetech_dashboard/screens/pages/assignBibNumber.dart";
import "package:racetech_dashboard/utils/colors.dart";
import "package:racetech_dashboard/widgets/categoryCards.dart";
import "package:racetech_dashboard/widgets/defaultAlertDialog.dart";
import "package:racetech_dashboard/widgets/defaultIconTextField.dart";
import "package:racetech_dashboard/widgets/defaultProgressDialog.dart";
import "package:racetech_dashboard/widgets/defaultRoundedButton.dart";
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:path_provider/path_provider.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:racetech_dashboard/widgets/medal.dart";

class ViewRaceResult extends StatefulWidget {
  ViewRaceResult({Key? key, required this.race_id}) : super(key: key);
  String? race_id;
  @override
  _ViewRaceResultState createState() => _ViewRaceResultState();
}

class _ViewRaceResultState extends State<ViewRaceResult> {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/race_result_${widget.race_id}.json");
  }

  Future<File> downloadRaceResult() async {
    http.Response response = await http
        .get(
          Uri.parse(
              "https://racetechph.com/mobile/uploadedresult/${widget.race_id}"),
        )
        .then((value) => value);

    final file = await _localFile;

    // Write the file
    return file.writeAsString(response.body);
  }

  Future<void> deleteLocalRaceResult() async {
    final file = await _localFile;
    await file.delete(recursive: true);
  }

  List<Map<String, dynamic>> offlineRaceResultList = [];
  Future<void> readOfflineRaceResult() async {
    try {
      final file = await _localFile;
      bool exists = await file.exists();
      if (exists) {
        // Read the file
        final contents = await file.readAsString();
        if (_bibNumberController.text.isEmpty) {
          offlineRaceResultList =
              List<Map<String, dynamic>>.from(json.decode(contents));
        } else {
          offlineRaceResultList =
              List<Map<String, dynamic>>.from(json.decode(contents))
                  .where((element) => element["bib_number"]
                      .toString()
                      .contains(_bibNumberController.text))
                  .toList();
        }
      } else {
        final startListFile = await downloadRaceResult();
        final contents = await startListFile.readAsString();
        if (_bibNumberController.text.isEmpty) {
          offlineRaceResultList =
              List<Map<String, dynamic>>.from(json.decode(contents));
        } else {
          offlineRaceResultList =
              List<Map<String, dynamic>>.from(json.decode(contents))
                  .where((element) => element["bib_numbers"]
                      .toString()
                      .contains(_bibNumberController.text))
                  .toList();
        }
      }
    } catch (e) {
      // If encountering an error, return 0
      offlineRaceResultList = List.empty();
    }
  }
  //TODO: Filter list here...

  TextEditingController _bibNumberController = TextEditingController();
  bool _isScanning = false;
  List<Barcode> _barcodes = [];
  @override
  Widget build(BuildContext context) {
    SessionDetails _sessionDetails = Provider.of<SessionDetails>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 20, 24),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        foregroundColor: Colors.white,
        title: Text("Race Results"),
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
                        controller: _bibNumberController,
                        onIconClicked: () {
                          setState(() {
                            readOfflineRaceResult();
                          });
                        },
                        hintText: "Bib No.",
                        iconData: Icons.search,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isScanning = _isScanning ? false : true;
                          });
                        },
                        child: Icon(Icons.qr_code_2_rounded,
                            size: 32, color: Colors.white),
                      )
                    ],
                  ),
                ),
                _isScanning
                    ? Expanded(
                        flex: 4,
                        child: MobileScanner(
                          onScannerStarted: (args) {},
                          onDetect: (BarcodeCapture capture) {
                            if (_isScanning) {
                              _barcodes = capture.barcodes;
                              _bibNumberController.text =
                                  _barcodes[0].rawValue.toString();
                              setState(() {
                                readOfflineRaceResult();
                                _isScanning = false;
                              });
                            }
                          },
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
                Expanded(
                  flex: 8,
                  child: RefreshIndicator(
                    onRefresh: readOfflineRaceResult,
                    child: FutureBuilder(
                        future: readOfflineRaceResult(),
                        builder: (context, snapshot) {
                          return offlineRaceResultList.isEmpty
                              ? Center(
                                  child: Container(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "img/loading.gif",
                                          height: 140,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                        ),
                                        DefaultText(
                                          text: "Sorry.",
                                          fontSize: 16,
                                          fontFamily: "MontserratBold",
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 2),
                                        ),
                                        DefaultText(
                                            text:
                                                "Race result has not been uploaded yet.",
                                            fontSize: 12)
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemBuilder: (context, index) => Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    decoration: ShapeDecoration(
                                      shadows: defaultCardShadowsDarkMale,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 225, 242, 255))),
                                      color: Color.fromARGB(255, 30, 30, 31),
                                    ),
                                    height: 220,
                                    child: Flex(
                                      direction: Axis.vertical,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            categoryCardMap[
                                                    offlineRaceResultList[index]
                                                            ["race_distance"]
                                                        .toString()] ??
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 3,
                                                      horizontal: 3),
                                                  height: 35,
                                                  decoration: ShapeDecoration(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      gradient:
                                                          const LinearGradient(
                                                              colors: [
                                                            Color.fromARGB(255,
                                                                20, 74, 173),
                                                            Color.fromARGB(255,
                                                                23, 114, 199)
                                                          ],
                                                              begin: Alignment
                                                                  .bottomLeft,
                                                              end: Alignment
                                                                  .topRight)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Icon(
                                                        CupertinoIcons
                                                            .flame_fill,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                      DefaultText(
                                                        text: offlineRaceResultList[
                                                                    index][
                                                                "race_distance"]
                                                            .toString(),
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "MontserratBold",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            Container(
                                                padding: EdgeInsetsDirectional
                                                    .symmetric(horizontal: 10),
                                                alignment:
                                                    Alignment.centerRight,
                                                // decoration: BoxDecoration(
                                                //   gradient: LinearGradient(colors: [
                                                //     const Color.fromARGB(0, 0, 0, 0),
                                                //     Color.fromARGB(153, 253, 198, 161)
                                                //   ]),
                                                // ),
                                                child: offlineRaceResultList[
                                                                index]
                                                            ["bib_number"] !=
                                                        null
                                                    ? DefaultText(
                                                        text:
                                                            offlineRaceResultList[
                                                                    index]
                                                                ["bib_number"],
                                                        fontSize: 24,
                                                        fontFamily:
                                                            "MontserratBold",
                                                        color: Color.fromARGB(
                                                            255, 219, 221, 255),
                                                      )
                                                    : DefaultText(
                                                        text: "N/A",
                                                        fontSize: 20,
                                                        fontFamily:
                                                            "MontserratBold",
                                                        color: Color.fromARGB(
                                                            255, 219, 221, 255),
                                                      ))
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4)),
                                        Expanded(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 1,
                                              itemBuilder:
                                                  (context, nonsenseIndex) {
                                                return Row(
                                                  children: [
                                                    Medal(
                                                      rank:
                                                          "${offlineRaceResultList[index]["rankingbydistance"]}",
                                                      borderColor: offlineRaceResultList[index]
                                                                      [
                                                                      "rankingbydistance"]
                                                                  .toString() ==
                                                              "1"
                                                          ? const Color.fromARGB(
                                                              255, 253, 212, 89)
                                                          : offlineRaceResultList[index]["rankingbydistance"]
                                                                      .toString() ==
                                                                  "2"
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  207,
                                                                  207,
                                                                  207)
                                                              : offlineRaceResultList[index]["rankingbydistance"]
                                                                          .toString() ==
                                                                      "3"
                                                                  ? Color.fromARGB(
                                                                      255,
                                                                      247,
                                                                      157,
                                                                      85)
                                                                  : null,
                                                      fillColor: offlineRaceResultList[index]
                                                                      [
                                                                      "rankingbydistance"]
                                                                  .toString() ==
                                                              "1"
                                                          ? Color.fromARGB(
                                                              255, 238, 134, 37)
                                                          : offlineRaceResultList[index]["rankingbydistance"]
                                                                      .toString() ==
                                                                  "2"
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  129,
                                                                  129,
                                                                  129)
                                                              : offlineRaceResultList[index]["rankingbydistance"]
                                                                          .toString() ==
                                                                      "3"
                                                                  ? Color.fromARGB(
                                                                      255,
                                                                      187,
                                                                      106,
                                                                      40)
                                                                  : null,
                                                      fontSize: 16,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4)),
                                                    DefaultText(
                                                      text:
                                                          offlineRaceResultList[
                                                                  index]
                                                              ["racer_name"],
                                                      fontSize: 24,
                                                      fontFamily:
                                                          "MontserratBold",
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 2)),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Medal(
                                                    rank:
                                                        "${offlineRaceResultList[index]["rankbygender"]}",
                                                    borderColor: offlineRaceResultList[index][
                                                                    "rankbygender"]
                                                                .toString() ==
                                                            "1"
                                                        ? const Color.fromARGB(
                                                            255, 253, 212, 89)
                                                        : offlineRaceResultList[index]["rankbygender"]
                                                                    .toString() ==
                                                                "2"
                                                            ? Color.fromARGB(
                                                                255,
                                                                207,
                                                                207,
                                                                207)
                                                            : offlineRaceResultList[index]["rankbygender"]
                                                                        .toString() ==
                                                                    "3"
                                                                ? Color.fromARGB(
                                                                    255,
                                                                    247,
                                                                    157,
                                                                    85)
                                                                : null,
                                                    fillColor: offlineRaceResultList[index][
                                                                    "rankbygender"]
                                                                .toString() ==
                                                            "1"
                                                        ? Color.fromARGB(
                                                            255, 238, 134, 37)
                                                        : offlineRaceResultList[index][
                                                                        "rankbygender"]
                                                                    .toString() ==
                                                                "2"
                                                            ? Color.fromARGB(
                                                                255, 129, 129, 129)
                                                            : offlineRaceResultList[index]["rankbygender"]
                                                                        .toString() ==
                                                                    "3"
                                                                ? Color.fromARGB(
                                                                    255,
                                                                    187,
                                                                    106,
                                                                    40)
                                                                : null,
                                                    fontSize: 12,
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4)),
                                                  Icon(
                                                    offlineRaceResultList[index]
                                                                ["gender"]
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains("female")
                                                        ? Icons.woman_outlined
                                                        : Icons.man_4,
                                                    color:
                                                        offlineRaceResultList[
                                                                        index]
                                                                    ["gender"]
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(
                                                                    "female")
                                                            ? const Color
                                                                .fromARGB(255,
                                                                255, 90, 145)
                                                            : const Color
                                                                .fromARGB(255,
                                                                47, 75, 231),
                                                  ),
                                                  DefaultText(
                                                    text: offlineRaceResultList[
                                                            index]["gender"]
                                                        .toString(),
                                                    fontSize: 20,
                                                    fontFamily: "Montserrat",
                                                    color:
                                                        offlineRaceResultList[
                                                                        index]
                                                                    ["gender"]
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(
                                                                    "female")
                                                            ? const Color
                                                                .fromARGB(255,
                                                                255, 90, 145)
                                                            : const Color
                                                                .fromARGB(255,
                                                                47, 75, 231),
                                                  ),
                                                ],
                                              ),
                                              DefaultText(
                                                text:
                                                    offlineRaceResultList[index]
                                                            ["total_time"]
                                                        .toString(),
                                                fontSize: 16,
                                                fontFamily: "Montserrat",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              DefaultText(
                                                text: "Distance",
                                                fontSize: 16,
                                                fontFamily: "Montserrat",
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                              ),
                                              Expanded(
                                                child: LinearProgressIndicator(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  value: 1,
                                                  color: Color.fromARGB(
                                                      255, 226, 132, 56),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                              ),
                                              DefaultText(
                                                text:
                                                    offlineRaceResultList[index]
                                                            ["race_distance"]
                                                        .toString(),
                                                fontSize: 16,
                                                fontFamily: "Montserrat",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              DefaultText(
                                                text: "Category:",
                                                fontSize: 12,
                                                fontFamily: "Montserrat",
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4)),
                                              Medal(
                                                  rank:
                                                      "${offlineRaceResultList[index]["rankbycategory"]}",
                                                  borderColor: offlineRaceResultList[index]["rankbycategory"]
                                                              .toString() ==
                                                          "1"
                                                      ? const Color.fromARGB(
                                                          255, 253, 212, 89)
                                                      : offlineRaceResultList[index]["rankbycategory"]
                                                                  .toString() ==
                                                              "2"
                                                          ? Color.fromARGB(
                                                              255, 207, 207, 207)
                                                          : offlineRaceResultList[index]["rankbycategory"]
                                                                      .toString() ==
                                                                  "3"
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  247,
                                                                  157,
                                                                  85)
                                                              : null,
                                                  fillColor: offlineRaceResultList[index]
                                                                  ["rankbycategory"]
                                                              .toString() ==
                                                          "1"
                                                      ? Color.fromARGB(255, 238, 134, 37)
                                                      : offlineRaceResultList[index]["rankbycategory"].toString() == "2"
                                                          ? Color.fromARGB(255, 129, 129, 129)
                                                          : offlineRaceResultList[index]["rankbycategory"].toString() == "3"
                                                              ? Color.fromARGB(255, 187, 106, 40)
                                                              : null),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4)),
                                              DefaultText(
                                                text:
                                                    offlineRaceResultList[index]
                                                            ["race_category"]
                                                        .toString(),
                                                fontSize: 16,
                                                fontFamily: "Montserrat",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemCount: offlineRaceResultList == null
                                      ? 0
                                      : offlineRaceResultList.length,
                                );
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
