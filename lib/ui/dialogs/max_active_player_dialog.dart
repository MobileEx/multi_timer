import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/style.dart';
import 'package:flutter/cupertino.dart';

Widget maxActivePlayerDialog(BuildContext context,
    {int activePlayer, ValueChanged<String> onChange}) {
  TextEditingController controller;
  if (activePlayer != null) {
    controller = TextEditingController()..text = activePlayer.toString();
  }

  return CupertinoAlertDialog(
    title: new Text("Player On Field"),
    content: Column(
      children: [
        new Text("How many player can be on field at one time?"),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 25,
          child: CupertinoTextField(
            controller: controller,
            onChanged: onChange,
            keyboardType: TextInputType.number,
            style: CustomTextStyle().h4.copyWith(fontSize: 13, color: ThemeService().secondary),
            padding: EdgeInsets.symmetric(
              horizontal: 6,
            ),
            textAlignVertical: TextAlignVertical.center,
            placeholderStyle: CustomTextStyle().h4.copyWith(fontSize: 13, color: Color(0xff3C3C43)),
            placeholder: 'Max Players on Field',
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Color(0xff3C3C43).withOpacity(.35))),
          ),
        ),
      ],
    ),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      CupertinoDialogAction(
        child: Text("Save"),
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
      )
    ],
  );
}
