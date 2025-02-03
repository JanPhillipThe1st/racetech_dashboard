import 'dart:convert';
import "dart:io";

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/providers/startListStateProvider.dart';
import 'package:racetech_dashboard/screens/pages/assignBibNumber.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/categoryCards.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import 'package:racetech_dashboard/widgets/defaultAlertInputDialog.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultProgressDialog.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import 'package:path_provider/path_provider.dart';
import "package:provider/provider.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:permission_handler/permission_handler.dart";
import "package:background_sms/background_sms.dart";
import "package:http/http.dart" as http;

class ManageStartList extends StatefulWidget {
  const ManageStartList(
      {Key? key, required this.race_id, required this.race_details})
      : super(key: key);
  final String race_id;
  final Map<String, dynamic> race_details;
  @override
  _ManageStartListState createState() => _ManageStartListState();
}

List<Barcode> _barcodes = [];

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

  Future<void> deleteLocalStartlist() async {
    final file = await _localFile;
    await file.delete(recursive: true);
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

  TextEditingController _smsMessageController = TextEditingController();
  Future<void> notifyRacers(
      {required String racerContact, required String textMessage}) async {
    var status = await Permission.sms.request();
    if (status.isGranted) {
      await BackgroundSms.sendMessage(
              phoneNumber: racerContact, message: textMessage)
          .then((smsStatus) {
        if (smsStatus == SmsStatus.sent) {
          print("Sent to ${racerContact}");
        } else {
          print("Failed: ${smsStatus.name}");
        }
      });
    } else if (status.isDenied) {
      await Permission.sms.request().then((value) async {
        if (value.isGranted) {
          await BackgroundSms.sendMessage(
                  phoneNumber: racerContact, message: textMessage)
              .then((smsStatus) {
            if (smsStatus == SmsStatus.sent) {
              print("Sent to ${racerContact}");
            } else {
              print("Failed: ${smsStatus.name}");
            }
          });
        }
      });
    }

// You can also directly ask permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example, because of parental controls.
    }
  }

  TextEditingController _refNumberController = TextEditingController();
  bool _isScanning = false;
  @override
  Widget build(BuildContext context) {
    final _sessionDetails = Provider.of<SessionDetails>(context, listen: false);
    StartListProvider _startListProvider =
        Provider.of<StartListProvider>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        foregroundColor: Colors.white,
        title: Text("Manage Startlist"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Clear startlist")
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DefaultAlertDialog(
                      text:
                          "Are you sure you want clear the startlist?\nAll progress will be lost.",
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
                                builder: (context) => DefaultProgressDialog(
                                      title: "Downloading Startlist",
                                      text: "Please wait...",
                                    ),
                                barrierDismissible: false);
                            await deleteLocalStartlist();

                            await readOfflineStartlist().then((value) {
                              setState(() {});

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) => DefaultAlertDialog(
                                        text: "Startlist cleared successfully!",
                                      ));
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              PopupMenuItem(
                value: 1,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DefaultAlertDialog(
                      text:
                          "Are you sure you want to notify all ${offlineStartList.length} racers? "
                          "This may use your load balance.",
                      fontSize: 16,
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
                                builder: (context) => DefaultProgressDialog(
                                      title: "Sending SMS",
                                      text: "Please wait...",
                                    ),
                                barrierDismissible: false);
                            Future.delayed(Duration(
                                    seconds: offlineStartList.length * 1))
                                .then((value) {
                              showDialog(
                                context: context,
                                builder: (context) => DefaultAlertDialog(
                                  text: "SMS Successfully sent!",
                                ),
                              ).then((value) {
                                Navigator.of(context).pop();
                              });
                            });
                            for (Map<String, dynamic> racer
                                in offlineStartList) {
                              await notifyRacers(
                                  racerContact:
                                      racer["contact_number"].toString(),
                                  textMessage:
                                      "From: RaceTech PH\n\nGood day, ${racer["racer_name"]}! Your race '${widget.race_details["race_title"]}' is coming up soon!\nPlease be at ${widget.race_details["race_location"]}"
                                      " 1 hour before ${widget.race_details["race_time"]} on ${widget.race_details["race_date"]}");
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Send SMS")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DefaultAlerInputDialog(
                      controller: _smsMessageController,
                      text: "Please input your message below",
                      fontSize: 20,
                      actions: [
                        DefaultRoundedButton(
                          isInverted: true,
                          text: "CANCEL",
                          color: Colors.white,
                          fontSize: 12,
                          onePressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        DefaultRoundedButton(
                          isInverted: true,
                          text: "SEND",
                          color: Colors.white,
                          fontSize: 12,
                          onePressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => DefaultProgressDialog(
                                      title: "Sending SMS",
                                      text: "Please wait...",
                                    ),
                                barrierDismissible: false);
                            Future.delayed(Duration(
                                    seconds: offlineStartList.length * 1))
                                .then((value) {
                              showDialog(
                                context: context,
                                builder: (context) => DefaultAlertDialog(
                                  text: "SMS Successfully sent!",
                                ),
                              ).then((value) {
                                Navigator.of(context).pop();
                              });
                            });

                            for (Map<String, dynamic> racer
                                in offlineStartList) {
                              await notifyRacers(
                                  // racerContact: "09669252741",
                                  racerContact:
                                      racer["contact_number"].toString(),
                                  textMessage: _smsMessageController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Send Custom SMS")
                  ],
                ),
              )
            ],
          )
        ],
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
                  height: 50,
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
                      DefaultIconTextField(
                        controller: _refNumberController,
                        onIconClicked: () {
                          setState(() {
                            readOfflineStartlist();
                          });
                        },
                        hintText: "Ref. No.",
                        iconData: Icons.search,
                      ),
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
                              _refNumberController.text =
                                  _barcodes[0].rawValue.toString();
                              setState(() {
                                readOfflineStartlist();
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
                    onRefresh: readOfflineStartlist,
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
                                        color: Color.fromARGB(
                                            255, 225, 242, 255))),
                                color: Color.fromARGB(255, 30, 30, 31),
                              ),
                              height: 220,
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      categoryCardMap[offlineStartList[index]
                                              ["category"]
                                          .toString()]!,
                                      Container(
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
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
                                              : DefaultText(
                                                  text: "N/A",
                                                  fontSize: 20,
                                                  fontFamily: "MontserratBold",
                                                  color: Color.fromARGB(
                                                      255, 219, 221, 255),
                                                ))
                                    ],
                                  ),
                                  Expanded(
                                    child: DefaultText(
                                      text: offlineStartList[index]
                                          ["racer_name"],
                                      fontSize: 24,
                                      fontFamily: "MontserratBold",
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 2)),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          offlineStartList[index]["gender"]
                                                  .toString()
                                                  .contains("FEMALE")
                                              ? Icons.woman_outlined
                                              : Icons.man_4,
                                          color: offlineStartList[index]
                                                      ["gender"]
                                                  .toString()
                                                  .contains("FEMALE")
                                              ? const Color.fromARGB(
                                                  255, 255, 90, 145)
                                              : const Color.fromARGB(
                                                  255, 47, 75, 231),
                                        ),
                                        DefaultText(
                                          text: offlineStartList[index]
                                                  ["gender"]
                                              .toString(),
                                          fontSize: 20,
                                          fontFamily: "Montserrat",
                                          color: offlineStartList[index]
                                                      ["gender"]
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
                                            backgroundColor: Colors.transparent,
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
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _startListProvider
                                            .setStartList(offlineStartList);
                                        if (_startListProvider
                                            .startList.isNotEmpty) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                AssignBibNumber(
                                              selectedRacer: index,
                                              race_id: widget.race_id,
                                            ),
                                          ))
                                              .then((value) {
                                            setState(() {
                                              readOfflineStartlist();
                                            });
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 4),
                                        decoration: ShapeDecoration(
                                          gradient: LinearGradient(colors: [
                                            Color.fromARGB(255, 32, 128, 253),
                                            Color.fromARGB(255, 22, 71, 134)
                                          ]),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            DefaultText(
                                              text: "Assign Bib",
                                              fontSize: 16,
                                              fontFamily: "MontserratBold",
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
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
                  ),
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) => DefaultProgressDialog(
                            title: "Uploading startlist",
                            text: "Please wait...",
                          ),
                      barrierDismissible: false);
                  List<Map<String, dynamic>> startlistData = [];
                  offlineStartList.forEach((racist) {
                    startlistData.add({
                      "user_id": _sessionDetails.sessionDetailsMap!["status"]
                              ["user_id"]
                          .toString(),
                      "race_id": racist["race_id"].toString(),
                      "ref_id": racist["ref_id"].toString(),
                      "bib_number": racist["bib_number"].toString(),
                      "racer_name": racist["racer_name"].toString(),
                      "gender": racist["gender"].toString(),
                      "chip_id": racist["chip_id"].toString(),
                      "category": racist["category"].toString(),
                      "distance_name": racist["distance_name"].toString(),
                      "shirt": "0"
                    });
                  });
                  await http
                      .post(
                          Uri.parse(
                              "https://racetechph.com/mobile/uploadstartlist/update?"),
                          headers: {
                            "cookie": _sessionDetails
                                .sessionDetailsMap!["cookie"]
                                .toString(),
                            "content-type": "application/json"
                          },
                          body: json.encode({"startlist_data": startlistData}))
                      .then((value) {
                    print(value.statusCode);
                    print(value.reasonPhrase);
                    print(value.body);
                    print(json.encode({"startlist_data": startlistData}));
                    Navigator.of(context).pop();
                  });
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
