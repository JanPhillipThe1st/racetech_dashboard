import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/widgets/defaultText.dart';

class RaceDetails extends StatefulWidget {
  const RaceDetails({Key? key, required this.raceIndex}) : super(key: key);
  final int raceIndex;
  @override
  _RaceDetailsState createState() => _RaceDetailsState();
}

class _RaceDetailsState extends State<RaceDetails> {
  @override
  Widget build(BuildContext context) {
    final _sessionDetails = Provider.of<SessionDetails>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            child: Image.network(
              "https://racetechph.com/assets/img/" +
                  _sessionDetails.myEventList![widget.raceIndex]["race_logo"],
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            height: double.maxFinite,
            color: Color.fromARGB(216, 0, 0, 0),
          ),
          Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: DefaultText(
                    text: _sessionDetails.myEventList![widget.raceIndex]
                        ["race_title"],
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: "MontserratBold",
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.info,
                      size: 20,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Container(
                      child: DefaultText(
                        text: _sessionDetails.myEventList![widget.raceIndex]
                                ["race_description"]
                            .toString()
                            .substring(
                              _sessionDetails.myEventList![widget.raceIndex]
                                          ["race_description"]
                                      .toString()
                                      .indexOf(">") +
                                  1,
                              _sessionDetails.myEventList![widget.raceIndex]
                                      ["race_description"]
                                  .toString()
                                  .indexOf("<", 4),
                            ),
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultText(
                        text: _sessionDetails.myEventList![widget.raceIndex]
                            ["race_date"],
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultText(
                        text: _sessionDetails.myEventList![widget.raceIndex]
                            ["race_location"],
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      size: 20,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultText(
                        text: _sessionDetails.myEventList![widget.raceIndex]
                            ["race_time"],
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
