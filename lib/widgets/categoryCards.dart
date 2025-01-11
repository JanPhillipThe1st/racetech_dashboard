import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

Map<String, Widget> categoryCardMap = {
  "21K": Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
    width: 65,
    height: 35,
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 197, 55, 20),
          Color.fromARGB(255, 252, 130, 74)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          CupertinoIcons.flame_fill,
          color: Colors.white,
          size: 14,
        ),
        DefaultText(
          text: "21K",
          fontSize: 14,
          fontFamily: "MontserratBold",
        ),
      ],
    ),
  ),
  "12K": Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
    width: 65,
    height: 35,
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 197, 150, 20),
          Color.fromARGB(255, 252, 160, 74)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          CupertinoIcons.flame_fill,
          color: Colors.white,
          size: 14,
        ),
        DefaultText(
          text: "21K",
          fontSize: 14,
          fontFamily: "MontserratBold",
        ),
      ],
    ),
  ),
  "32K": Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
    width: 65,
    height: 35,
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 129, 197, 20),
          Color.fromARGB(255, 95, 252, 74)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          CupertinoIcons.flame_fill,
          color: Colors.white,
          size: 14,
        ),
        DefaultText(
          text: "21K",
          fontSize: 14,
          fontFamily: "MontserratBold",
        ),
      ],
    ),
  ),
  "50K": Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
    width: 65,
    height: 35,
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 20, 197, 159),
          Color.fromARGB(255, 74, 252, 228)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          CupertinoIcons.flame_fill,
          color: Colors.white,
          size: 14,
        ),
        DefaultText(
          text: "21K",
          fontSize: 14,
          fontFamily: "MontserratBold",
        ),
      ],
    ),
  )
};
