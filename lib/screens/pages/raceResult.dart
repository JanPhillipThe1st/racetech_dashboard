import 'dart:html';

import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import 'package:racetech_dashboard/utils/colors.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';
import "package:webview_flutter/webview_flutter.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";

class RaceResult extends StatefulWidget {
  const RaceResult({Key? key}) : super(key: key);

  @override
  _RaceResultState createState() => _RaceResultState();
}

class _RaceResultState extends State<RaceResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SessionDetails>(
        builder: (context, race_data, childWidget) {
          return ListView.builder(
            itemBuilder: (context, index) => Container(),
          );
        },
      ),
    );
  }
}
