import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/screens/pages/manageStartList.dart';
import 'package:racetech_dashboard/screens/pages/raceDetails.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
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
                flex: 10,
                child: Consumer<SessionDetails>(
                  builder: (context, value, child) {
                    return Container(
                      padding: EdgeInsets.only(top: 10),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if (value.myEventList != null) {
                            setState(() {});
                          }
                        },
                        child: ListView.builder(
                          itemCount: value.myEventList == null
                              ? 0
                              : value.myEventList!.length,
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
                                          child: value.myEventList![index]
                                              ["event_image"],
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
                                                                    race_id: value
                                                                            .myEventList![index]
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
                                                text: value.myEventList![index]
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
                                                text: value.myEventList![index]
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
                                                text: value.myEventList![index]
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
                                                text: value.myEventList![index]
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
