import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:provider/provider.dart";

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;
  @override
  _DashboardState createState() => _DashboardState();
}

//Page       |   Index    |
//Results         1
//Events          2
//Account         3

class _DashboardState extends State<Dashboard> {
  void animateToPage(int index) {
    widget.pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 20, 24),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Container(
              color: racetechPrimaryColor,
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        animateToPage(1);
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 120,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                              borderRadius: BorderRadius.circular(12)),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 38, 39, 41),
                            Color.fromARGB(255, 56, 56, 56),
                          ]),
                          shadows: secondaryCardShadowsDarkDashboard,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 146, 48, 23),
                                    Color.fromARGB(255, 148, 107, 20),
                                  ])),
                              width: double.maxFinite,
                              child: DefaultText(
                                text: "RACE RESULTS",
                                fontSize: 20,
                                fontWeight: FontWeight.w100,
                                color: Color.fromARGB(255, 218, 218, 218),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                            Consumer<SessionDetails>(
                                builder: (context, events, child) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                child: DefaultText(
                                  text:
                                      "Search ${events.raceList == null ? "0" : events.raceList!.length} results",
                                  fontSize: 24,
                                  fontFamily: "MontserratBold",
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromARGB(255, 212, 135, 45),
                                ),
                              );
                            }),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              child: DefaultText(
                                text: "Tap to view...",
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: Color.fromARGB(255, 218, 218, 218),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        animateToPage(2);
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 120,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 0.4,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                              borderRadius: BorderRadius.circular(12)),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 38, 39, 41),
                            Color.fromARGB(255, 56, 56, 56),
                          ]),
                          shadows: defaultCardShadowsDarkDashboard,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 38, 134, 110),
                                    Color.fromARGB(255, 44, 148, 67),
                                  ])),
                              width: double.maxFinite,
                              child: DefaultText(
                                text: "MY EVENTS",
                                fontSize: 20,
                                fontWeight: FontWeight.w100,
                                color: Color.fromARGB(255, 218, 218, 218),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 6)),
                            Consumer<SessionDetails>(
                                builder: (context, events, child) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                child: DefaultText(
                                  text:
                                      "${events.myEventList == null ? "0" : events.myEventList!.length} events",
                                  fontSize: 24,
                                  fontFamily: "MontserratBold",
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromARGB(255, 75, 182, 231),
                                ),
                              );
                            }),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              child: DefaultText(
                                text: "Tap to view...",
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: Color.fromARGB(255, 218, 218, 218),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
