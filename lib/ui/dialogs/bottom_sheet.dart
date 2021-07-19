import 'package:fairplay/services/theme_service.dart';
import 'package:fairplay/static_data.dart';
import 'package:fairplay/ui/style.dart';
import 'package:fairplay/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void infoSheet(BuildContext context) {
  showMaterialModalBottomSheet(
      barrierColor: Colors.black.withOpacity(.8),
      backgroundColor: Colors.transparent,
      expand: true,
      isDismissible: true,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: false,
          child: Container(
            margin: EdgeInsets.only(
              top: 135,
            ),
            decoration: BoxDecoration(
                color: ThemeService().bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              'About',
                              style: CustomTextStyle().h3,
                            ),
                            CupertinoButton(
                                padding: EdgeInsets.all(0),
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: ThemeService().secondary,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                      Text(
                        'Fair Play',
                        style: CustomTextStyle().h1,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        StaticData.ABOUT_SCREEN_TEXT[0],
                        style: CustomTextStyle().h4.copyWith(wordSpacing: 3),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        StaticData.ABOUT_SCREEN_TEXT[1],
                        style: CustomTextStyle().h4.copyWith(wordSpacing: 3),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Fair play for all.',
                        style: CustomTextStyle()
                            .h3
                            .copyWith(color: ThemeService().primaryColor, wordSpacing: 3),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StaticData.SETTINGS_TEXT[0],
                              style: CustomTextStyle()
                                  .h4
                                  .copyWith(color: ThemeService().tertiary, wordSpacing: 3),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              StaticData.SETTINGS_TEXT[1],
                              style: CustomTextStyle()
                                  .h4
                                  .copyWith(color: ThemeService().tertiary, wordSpacing: 3),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              StaticData.SETTINGS_TEXT[2],
                              style: CustomTextStyle()
                                  .h4
                                  .copyWith(color: ThemeService().tertiary, wordSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          children: [
                            RoundIconButton(
                              iconData: Icons.email,
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RoundIconButton(
                              iconData: Icons.video_call,
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            RoundIconButton(
                              iconData: Icons.shopping_bag,
                              color: ThemeService().primaryColor,
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: PrimaryButton(
                    buttonText: 'SUPPORT THE APP, WATCH AN ADVERT',
                    outlineButton: true,
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        );
      });
}
