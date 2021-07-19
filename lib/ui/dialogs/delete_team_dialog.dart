import 'package:flutter/cupertino.dart';

Widget deleteTeam(BuildContext context, {Function onPressed}) {
  return CupertinoAlertDialog(
    title: Text("Are you sure?"),
    content: Text("Deleting will remove all data and players and cannot be undone."),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text("Delete"),
        onPressed: onPressed,
      ),
    ],
  );
}
