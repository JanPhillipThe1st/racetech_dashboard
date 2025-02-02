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
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> homeScreenItems = [
      Dashboard(
        key: UniqueKey(),
        pageController: pageController,
      ),
      RaceResult(key: UniqueKey()),
      MyEvents(key: UniqueKey()),
      MyAccount(key: UniqueKey()),
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 6,
          backgroundColor: racetechPrimaryColor,
          foregroundColor: Colors.white70,
          title: Consumer<SessionDetails>(
            builder: (context, value, child) => DefaultText(
                color: Colors.white70,
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
          pageSnapping: true,
          children: homeScreenItems,
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          height: 80,
          backgroundColor: Colors.white,
          activeColor: racetechPrimaryColor,
          inactiveColor: Color.fromARGB(255, 139, 139, 139),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: (_page == 0)
                    ? racetechPrimaryColor
                    : Color.fromARGB(255, 139, 139, 139),
              ),
              label: 'Dashboard',
              backgroundColor: racetechPrimaryColor,
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list_rounded,
                  color: (_page == 1)
                      ? racetechPrimaryColor
                      : Color.fromARGB(255, 139, 139, 139),
                ),
                label: 'Results',
                backgroundColor: racetechPrimaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: (_page == 2)
                      ? racetechPrimaryColor
                      : Color.fromARGB(255, 139, 139, 139),
                ),
                label: 'Events',
                backgroundColor: racetechPrimaryColor),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 36,
                color: (_page == 3)
                    ? racetechPrimaryColor
                    : Color.fromARGB(255, 139, 139, 139),
              ),
              label: 'Account',
              backgroundColor: racetechPrimaryColor,
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
