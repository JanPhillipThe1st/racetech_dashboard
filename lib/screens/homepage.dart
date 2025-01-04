import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/screens/pages/dashboard.dart';
import 'package:racetech_dashboard/screens/pages/myAccount.dart';
import 'package:racetech_dashboard/screens/pages/myEvents.dart';
import 'package:racetech_dashboard/screens/pages/raceResult.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultAlertDialog.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/widgets/defaultText.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  List<Widget> homeScreenItems = [
    Dashboard(),
    RaceResult(),
    MyEvents(),
    MyAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SessionDetails>(
          builder: (context, value, child) => DefaultText(
              color: racetechPrimaryColor,
              fontSize: 16,
              text: value.sessionDetailsMap == null
                  ? "Fetching name..."
                  : "Welcome, " +
                      value.sessionDetailsMap!["status"]["full_name"] +
                      "!"),
          child: Text("Loading data..."),
        ),
      ),
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 80,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? racetechPrimaryColor : Colors.black,
            ),
            label: 'Home',
            backgroundColor: racetechPrimaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_rounded,
                color: (_page == 1) ? racetechPrimaryColor : Colors.black,
              ),
              label: 'Results',
              backgroundColor: racetechPrimaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month_rounded,
                color: (_page == 2) ? racetechPrimaryColor : Colors.black,
              ),
              label: 'Events',
              backgroundColor: racetechPrimaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 36,
              color: (_page == 3) ? racetechPrimaryColor : Colors.black,
            ),
            label: 'Account',
            backgroundColor: racetechPrimaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
