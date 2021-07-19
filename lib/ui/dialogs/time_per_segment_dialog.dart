import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/style.dart';
import 'package:flutter/cupertino.dart';

Widget timePerSegmentDialog(BuildContext context, {int segments, ValueChanged<String> onChange}) {
  TextEditingController controller;
  if (segments != null) {
    controller = TextEditingController()..text = segments.toString();
  }

  return CupertinoAlertDialog(
    title: new Text("Time Per Segment"),
    content: Column(
      children: [
        new Text("How much time one segment has in minutes?"),
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
