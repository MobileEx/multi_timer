import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget deletePlayerDialog(BuildContext context, Function onPressed) {
  return CupertinoAlertDialog(
    title: Text("Are you sure?"),
    content: Text("Deleting this player will remove all history from reporting."),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text("Delete"),
        onPressed: onPressed,
      ),
    ],
  );
}
