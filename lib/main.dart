import 'package:flutter/material.dart';
import 'package:racetech_dashboard/models/sessionDetails.dart';
import "package:provider/provider.dart";
import 'package:racetech_dashboard/providers/startListStateProvider.dart';
import 'package:racetech_dashboard/screens/login.dart';

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 76, 253)),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
