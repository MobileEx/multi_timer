import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/style.dart';
import 'package:flutter/cupertino.dart';

Widget playerNoDialog(BuildContext context, {String no, ValueChanged<String> onChange}) {
  TextEditingController controller;
  if (no != null) {
    controller = TextEditingController()..text = no;
  }

  return CupertinoAlertDialog(
    title: new Text("Player Number"),
    content: Column(
      children: [
        new Text("Add the players number to clearly display in the timer."),
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
            placeholder: 'Player Number',
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
