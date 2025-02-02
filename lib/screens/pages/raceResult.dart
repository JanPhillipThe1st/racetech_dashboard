import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/screens/pages/viewRaceResult.dart';
import 'package:racetech_dashboard/widgets/defaultIconTextField.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:url_launcher/url_launcher.dart";

class RaceResult extends StatefulWidget {
  const RaceResult({Key? key}) : super(key: key);

  @override
  _RaceResultState createState() => _RaceResultState();
}

class _RaceResultState extends State<RaceResult> {
  TextEditingController _raceTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      body: Flex(
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
              builder: (context, sessionDetailsRaceData, childWidget) {
                List<Map<String, dynamic>> raceData =
                    sessionDetailsRaceData.raceList!;
                if (_raceTitleController.text.isNotEmpty) {
                  raceData = sessionDetailsRaceData.raceList!
                      .where((race) => race["race_title"]
                          .toString()
                          .toLowerCase()
                          .contains(_raceTitleController.text.toLowerCase()))
                      .toList();
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _raceTitleController.clear();
                      raceData = sessionDetailsRaceData.raceList!;
                    });
                  },
                  child: ListView.builder(
                    itemCount: raceData.isEmpty ? 0 : raceData.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewRaceResult(
                              race_id: raceData[index]["race_id"]),
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              width: 0.4,
                              color: Color.fromARGB(255, 225, 242, 255),
                            ),
                          ),
                          color: const Color.fromARGB(255, 30, 30, 31),
                        ),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    width: double.maxFinite,
                                    child: raceData[index]["race_logo"],
                                  ),
                                  Container(
                                    height: 100,
                                    decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(),
                                        gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(141, 0, 0, 0),
                                              Color.fromARGB(64, 0, 0, 0)
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter)),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String url =
                                                "https://${raceData[index]["race_external_website"]}";
                                            if (!await launchUrl(
                                                Uri.parse(url))) {
                                              throw Exception(
                                                  'Could not launch $url');
                                            }
                                          },
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                child: const Icon(
                                                  Icons.facebook_outlined,
                                                  size: 24,
                                                  color: Colors.blue,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4)),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: DefaultText(
                                  text: raceData[index]["race_title"],
                                  fontSize: 16,
                                  fontFamily: "MontserratBold",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4)),
                              Container(
                                width: 220,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: DefaultText(
                                  text: raceData[index]["race_location"],
                                  fontSize: 12,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                decoration: ShapeDecoration(
                                    color: raceData[index]["category_name"]
                                            .toString()
                                            .toLowerCase()
                                            .contains("trail")
                                        ? Color.fromARGB(255, 12, 165, 25)
                                        : raceData[index]["category_name"]
                                                .toString()
                                                .toLowerCase()
                                                .contains("triathlon")
                                            ? const Color.fromARGB(
                                                255, 21, 108, 180)
                                            : raceData[index]["category_name"]
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("ultra")
                                                ? Color.fromARGB(
                                                    255, 201, 56, 12)
                                                : Color.fromARGB(
                                                    255, 180, 21, 146),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                      // side: const BorderSide(
                                      //     width: 0.4, color: Colors.white),
                                    )),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  child: DefaultText(
                                    text: raceData[index]["category_name"],
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2)),
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color:
                                        const Color.fromARGB(255, 221, 14, 14),
                                    size: 16,
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2)),
                                  DefaultText(
                                    text: raceData[index]["race_date"],
                                    fontSize: 12,
                                    fontFamily: "Montserrat",
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4)),
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Color.fromARGB(255, 56, 76, 253),
                                    size: 16,
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2)),
                                  DefaultText(
                                    text: raceData[index]["race_time"],
                                    fontSize: 12,
                                    fontFamily: "Montserrat",
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2)),
                                  Icon(
                                    Icons.app_registration_rounded,
                                    color: Color.fromARGB(255, 221, 90, 14),
                                    size: 20,
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2)),
                                  Container(
                                    width: 290,
                                    child: DefaultText(
                                      text: raceData[index]
                                          ["race_organized_by"],
                                      fontSize: 12,
                                      fontFamily: "MontserratBold",
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
