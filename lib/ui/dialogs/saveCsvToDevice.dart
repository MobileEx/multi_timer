import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget saveCsvToDevice(BuildContext context, {int key}) {
  return CupertinoAlertDialog(
    title: new Text("Save Report"),
    content: Column(
      children: [
        new Text("A complete CSV file of today’s game will be Saved on Your Device."),
        SizedBox(
          height: 16,
        ),
      ],
    ),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text("Don,t Saved"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      CupertinoDialogAction(
        child: Text("Saved"),
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
      )
    ],
  );
}
