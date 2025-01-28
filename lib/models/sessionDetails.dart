import "dart:convert";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:http/http.dart" as http;

class SessionDetails with ChangeNotifier {
  Map<String, dynamic>? sessionDetailsMap;
  Map<String, dynamic>? userDetailsMap;
  List<Map<String, dynamic>>? myEventList;
  List<Map<String, dynamic>>? raceList;
  Image? userPhoto;

  SessionDetails({
    this.userDetailsMap,
    this.sessionDetailsMap,
  });

  void loginUser(String username, String password) async {
    http.Response response = await http
        .post(
          Uri.parse("https://racetechph.com/api/loginuser?"),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode(
            {
              "username": username,
              "password": password,
            },
          ),
        )
        .then((value) => value);
    sessionDetailsMap = json.decode(response.body);
    updateCookie(response);
    userPhoto = Image.network(
        "https://racetechph.com/assets/img/" +
            sessionDetailsMap!["status"]["user_id"] +
            ".jpg",
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) => Image.network(
            "https://racetechph.com/assets/img/" +
                sessionDetailsMap!["status"]["user_id"] +
                ".png"));
    getUserDetails();
    getMyEventList();
    getRaceResults();
    notifyListeners();
  }

  void getUserDetails() async {
    http.Response response = await http.post(
      Uri.parse("https://racetechph.com/api/accounts/getuser?"),
      headers: {"cookie": sessionDetailsMap!["cookie"].toString()},
    ).then((value) => value);
    userDetailsMap = json.decode(response.body)[0];
  }

// XSRF-TOKEN=eyJpdiI6InhKck5RcUQyQllPOFlFWmlwcTY0NlE9PSIsInZhbHVlIjoiWGw1ellOYlBUZFh0QmNNSTZwdkxzejJqWVpNTGNLdUFHYVRJY2c1YnlyOStKR3YwMEVzN1dWRDIzS01ETEhTR0t0R084VWxLZ2JQalI0QU5nTExSQmc9PSIsIm1hYyI6IjE3MjRhMmVmMzAxZWZmNjE1MzQ0YjkzMTZiNzRmY2M5N2MwYjJkMTFjOGNhYWQ2YzdmNzE1MWZmZWFkOTViMDgifQ%3D%3D
// XSRF-TOKEN=eyJpdiI6IkZwR1gxWVc3XC92clN4NUR4S2E5cjhRPT0iLCJ2YWx1ZSI6InhNNHhOVEtzc3MyS2lCT1wvK3JvVDg1NGlrNGxNK3plREIxcEcwZU5uektTZHN0enhGaDEyUzBBc1ZVZFZJMXMwMjJMbzI0WGVXcm51QmtDTGl6b3lKUT09IiwibWFjIjoiMGRjODNkZjhkOTRhNDY4ZjQ1OGYyMjlmZDJkYmNlMzJkZDhiMDljOGFhY2JjZDU5M2Q4Yjc5OTdhYzhkNjY4NCJ9;
//expires=Mon, 03-Feb-2025 09:19:32 GMT;
//Max-Age=2592000; path=/; secure,
//laravel_session=eyJpdiI6ImhHTG9IczhuWnczMjlQTDVON0VZYUE9PSIsInZhbHVlIjoiUk9pdFNqUXZVc2FRT1RqUTNlWk9INWlhNzRyUGV6WTVxdm9UaEFVUEx2a09rR01UM1hEMTN3Y2FpK2w3N2tqZzBvRnA2MTF2RVVuM0plck9RVUNFN0E9PSIsIm1hYyI6IjJhNDQ4NzJkMTk0NzExMDRmNGIxOGMxNDE3NmQzYjczYjMyYzBjM2JhMjA5YWQ5ODdiYTFmMjM2Y2ExOTI5OTYifQ%3D%3D; expires=Mon, 03-Feb-2025 09:19:32 GMT; Max-Age=2592000; path=/; httponly; secure
  void updateCookie(http.Response response) {
    //Find the XRF-TOKEN value from the 'set-cookie' string
    String? rawCookie = response.headers["set-cookie"];

    String xrfTokenString = rawCookie!
        .split(";")
        .where((element) => element.contains("secure,XSRF-TOKEN="))
        .first
        .substring("secure,".length + 1);
    String laravelSessionString = rawCookie!
        .split(";")
        .where((element) => element.contains("secure,laravel_session="))
        .first
        .substring("secure,".length + 1);
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      sessionDetailsMap!['cookie'] = "$xrfTokenString;$laravelSessionString;";
    }
  }

  void getMyEventList() async {
    http.Response response = await http.get(
      Uri.parse("https://racetechph.com/myeventlist?"),
      headers: {"cookie": sessionDetailsMap!["cookie"].toString()},
    ).then((value) => value);
    myEventList = List<Map<String, dynamic>>.from(json.decode(response.body));
    myEventList!.forEach((eventObject) {
      eventObject["event_image"] = Image.network(
        "https://racetechph.com/assets/img/" + eventObject["race_logo"],
        fit: BoxFit.fitWidth,
      );
    });
  }

  void getRaceResults() async {
    http.Response response = await http.get(
      Uri.parse("https://racetechph.com/mobile/raceresults?"),
      headers: {"cookie": sessionDetailsMap!["cookie"].toString()},
    ).then((value) => value);
    raceList =
        List<Map<String, dynamic>>.from(json.decode(response.body)["races"]);
    raceList!.forEach((eventObject) async {
      try {
        eventObject["race_logo"] = await Image.network(
          "https://racetechph.com/assets/img/" + eventObject["race_logo"],
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            "img/running.png",
            alignment: Alignment.bottomCenter,
            scale: 0.2,
          ),
        );
      } catch (e) {
        eventObject["race_logo"] = Image.asset(
          "img/running.png",
          scale: 100,
          fit: BoxFit.fill,
        );
      }
    });
  }
}
