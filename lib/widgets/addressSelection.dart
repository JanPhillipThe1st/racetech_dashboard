import 'package:flutter/material.dart';
import 'package:racetech_dashboard/widgets/defaultRoundedButton.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection(
      {Key? key, required this.placeMap, required this.onSelectItem})
      : super(key: key);

  final List<String> placeMap;
  final Function(String)? onSelectItem;
  @override
  _AddressSelectionState createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: widget.placeMap.length,
          itemBuilder: (context, index) => DefaultRoundedButton(
            backgroundColor: Color.fromARGB(255, 28, 28, 31),
            text: widget.placeMap[index],
            borderSide: BorderSide(width: 0.2, color: Colors.black54),
            fontSize: 12,
            onePressed: () {
              widget.onSelectItem!(widget.placeMap[index].toString());
            },
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
