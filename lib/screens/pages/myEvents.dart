import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/screens/pages/manageStartList.dart';
import 'package:racetech_dashboard/screens/pages/raceDetails.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import 'package:path_provider/path_provider.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  TextEditingController _raceTitleController = TextEditingController();
  late List<Map<String, dynamic>> raceData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        color: racetechPrimaryColor,
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  DefaultText(
                    text: "Search by:",
                    fontSize: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  Expanded(
                      child: DefaultIconTextField(
                    controller: _raceTitleController,
                    onIconClicked: () {
                      setState(() {});
                    },
                    onTextChanged: (textValue) {
                      setState(() {});
                    },
                    hintText: "Race title",
                    iconData: Icons.search,
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       _isScanning = _isScanning ? false : true;
                  //     });
                  //   },
                  //   child: Icon(Icons.qr_code_2_rounded,
                  //       size: 32, color: Colors.white),
                  // )
                ],
              ),
            ),
            Expanded(
                flex: 10,
                child: Consumer<SessionDetails>(
                  builder: (context, sessionDetailsRaceData, child) {
                    raceData = sessionDetailsRaceData.myEventList!;
                    if (_raceTitleController.text.isNotEmpty) {
                      raceData = sessionDetailsRaceData.myEventList!
                          .where((race) => race["race_title"]
                              .toString()
                              .toLowerCase()
                              .contains(
                                  _raceTitleController.text.toLowerCase()))
                          .toList();
                    }
                    return Container(
                      padding: EdgeInsets.only(top: 10),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if (raceData != null) {
                            setState(() {});
                          }
                        },
                        child: ListView.builder(
                          itemCount: raceData == null ? 0 : raceData.length,
                          itemBuilder: (context, index) => GestureDetector(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              height: 250,
                              decoration: ShapeDecoration(
                                // shadows: [
                                //   BoxShadow(blurRadius: 4, offset: Offset(0, 2))
                                // ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Flex(
                                direction: Axis.vertical,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.maxFinite,
                                          child: raceData[index]["event_image"],
                                        ),
                                        Container(
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(),
                                            color: Color.fromARGB(176, 0, 0, 0),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  PopupMenuButton<int>(
                                                    itemBuilder: (context) => [
                                                      // PopupMenuItem 1
                                                      PopupMenuItem(
                                                        value: 1,
                                                        // row with 2 children
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .edit_note_rounded,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("Manage Event")
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    RaceDetails(
                                                              raceIndex: index,
                                                            ),
                                                          ));
                                                        },
                                                      ),
                                                      // PopupMenuItem 2
                                                      PopupMenuItem(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                ManageStartList(
                                                                    race_details:
                                                                        raceData![
                                                                            index],
                                                                    race_id: raceData![
                                                                            index]
                                                                        [
                                                                        "race_id"]),
                                                          ));
                                                        },
                                                        value: 2,
                                                        // row with two children
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .flag_circle_rounded,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                "Manage Startlist")
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    icon: Icon(
                                                        Icons
                                                            .mode_edit_outlined,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              DefaultText(
                                                text: raceData![index]
                                                        ["race_title"]
                                                    .toString(),
                                                fontSize: 20,
                                                fontFamily: "MontserratBold",
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      color: Colors.white,
                                      width: double.maxFinite,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.location_solid,
                                                size: 20,
                                                color: Colors.redAccent,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2),
                                              ),
                                              DefaultText(
                                                text: raceData![index]
                                                    ["race_location"],
                                                fontSize: 16,
                                                fontFamily: "MontserratBlack",
                                                color: const Color.fromARGB(
                                                    255, 53, 53, 53),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.calendar,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2),
                                              ),
                                              DefaultText(
                                                text: raceData![index]
                                                    ["race_date"],
                                                fontSize: 16,
                                                color: const Color.fromARGB(
                                                    255, 53, 53, 53),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.time,
                                                size: 20,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2),
                                              ),
                                              DefaultText(
                                                text: raceData![index]
                                                    ["race_time"],
                                                fontSize: 16,
                                                color: const Color.fromARGB(
                                                    255, 53, 53, 53),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
