import 'package:flutter/material.dart';
import "dart:io";
import "package:path_provider/path_provider.dart";
import "package:http/http.dart" as http;

class FileHandler {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _raceResultFile async {
    final path = await _localPath;
    return File('$path/.json');
  }

  Future<File> downloadRaceResult(int counter) async {
    final file = await _raceResultFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}
