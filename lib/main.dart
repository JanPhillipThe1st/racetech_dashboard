import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/providers/signupProvider.dart';
import 'package:racetech_dashboard/providers/startListStateProvider.dart';
import 'package:racetech_dashboard/screens/login.dart';
import 'package:racetech_dashboard/utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => SessionDetails(),
      ),
      ChangeNotifierProvider(
        create: (_) => StartListProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SignupProvider(),
      ),
    ],
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racetech Dashboard',
      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(seedColor: racetechPrimaryColor),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
