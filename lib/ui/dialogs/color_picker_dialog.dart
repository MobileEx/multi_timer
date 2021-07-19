import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/ui/style.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget colorPickerDialog(
  BuildContext context, {
  ValueChanged<Color> onChangeColor,
  Color value,
}) {
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: 460,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)), color: ThemeService().bgColor),
      child: ColorPicker(
        color: value,
        enableShadesSelection: true,
        onColorChanged: onChangeColor,
        width: 44,
        height: 44,
        borderRadius: 4,
        enableOpacity: true,
        heading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select color',
              style: CustomTextStyle().h3,
            ),
            CupertinoButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 20,
                color: ThemeService().secondary,
              ),
            )
          ],
        ),
        subheading: Text(
          'Select color shade',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    ),
  );
}
