import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racetech_dashboard/widgets/defaultLinkText.dart';
import 'package:racetech_dashboard/widgets/defaultText.dart';

class DefaultInfoItem extends StatefulWidget {
  DefaultInfoItem({Key? key, this.iconData, this.itemText, this.onPressed})
      : super(key: key);
  IconData? iconData;
  String? itemText;
  Function()? onPressed;
  @override
  _DefaultInfoItemState createState() => _DefaultInfoItemState();
}

class _DefaultInfoItemState extends State<DefaultInfoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.iconData == null
              ? Container()
              : Icon(
                  widget.iconData ?? CupertinoIcons.ant,
                  weight: 1,
                  size: 16,
                  color: Colors.white,
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
          ),
          DefaultLinkText(
            text: widget.itemText ?? "...",
            fontSize: 12,
            onPressed: widget.onPressed ?? () {},
          )
        ],
      ),
    );
  }
}
