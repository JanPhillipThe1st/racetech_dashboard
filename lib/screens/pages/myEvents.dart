import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/widgets/defaultText.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        color: const Color.fromARGB(255, 230, 230, 230),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 230, 230, 230),
                width: double.maxFinite,
                child: DefaultText(
                  text: "MY EVENTS",
                  fontSize: 24,
                  fontWeight: FontWeight.w100,
                  color: racetechPrimaryColor,
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Consumer<SessionDetails>(
                  builder: (context, value, child) {
                    return Container(
                      padding: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: value.myEventList!.length,
                        itemBuilder: (context, index) => Container(
                          clipBehavior: Clip.hardEdge,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      child: Image.network(
                                        "https://racetechph.com/assets/img/" +
                                            value.myEventList![index]
                                                ["race_logo"],
                                        fit: BoxFit.fitWidth,
                                      ),
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
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DefaultText(
                                            text: value.myEventList![index]
                                                    ["race_title"]
                                                .toString(),
                                            fontSize: 20,
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.white,
                                  width: double.maxFinite,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                          height: 250,
                          decoration: ShapeDecoration(
                            // shadows: [
                            //   BoxShadow(blurRadius: 4, offset: Offset(0, 2))
                            // ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
